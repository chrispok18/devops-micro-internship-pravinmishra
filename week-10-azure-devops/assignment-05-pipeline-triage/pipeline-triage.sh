#!/bin/bash
# =============================================================================
# pipeline-triage.sh — READ-ONLY dual-pipeline failure triage (Azure DevOps)
#
# Based on the supplied course script. Structure kept (checks array, write_line,
# mark_* helpers, summary, exit codes). Extended ONLY where Task 3 of the brief
# requires it: two pipelines, Build Logs REST API, per-pipeline raw logs,
# Terraform / deployment / Unclassified categories, state handling, exit code 3,
# and evidence sanitization. See CHANGES in the submission document.
#
# Read-only: only HTTP GET requests are made. Nothing is queued, retried,
# cancelled, approved, deleted or modified.
#
# Authentication (never stored in this file):
#   export AZURE_DEVOPS_EXT_PAT   (PAT with Build: Read scope only)   OR
#   an active `az login` session (Microsoft Entra token is requested on the fly)
# =============================================================================

set -u

# ---------------- Student-specific configuration (non-secret) ----------------
full_name="Christian Aryee"
ado_org="https://dev.azure.com/krisbillion18"
ado_project="EpicBook-Deployment"
infra_pipeline_name="EpicBook-Infra-Pipeline"
infra_pipeline_id="4"      # numeric ID, e.g. 3
app_pipeline_name="EpicBook-App-Pipeline"
app_pipeline_id="5"          # numeric ID, e.g. 4
api_version="7.1"

# ---------------- Paths (resolved from the script's own directory) -----------
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
report_dir="$base_dir/reports"
report_file="$report_dir/pipeline-health-report.txt"
infra_log_file="$report_dir/infra-last-run.log"
app_log_file="$report_dir/app-last-run.log"

# ---------------- Check functions, run in this order for every pipeline ------
# Specific categories first, general ones later; the run-result check is last so
# a failed run with no matching pattern becomes an Unclassified Pipeline Failure.
checks=(
  check_auth_failure
  check_agent_failure
  check_terraform_failure
  check_dependency_failure
  check_build_failure
  check_test_failure
  check_deployment_failure
  check_ado_run_result
)

pass_count=0
warning_count=0
failure_count=0
error_count=0

# Per-pipeline state (set before the check loop runs)
current_name=""
current_status=""
current_result=""
evidence_file=""
category_matches=0

mkdir -p "$report_dir"
: > "$report_file"

write_line() {
  echo "$1" | tee -a "$report_file"
}

mark_pass() {
  write_line "[PASS] $1"
  pass_count=$((pass_count + 1))
}

mark_warning() {
  write_line "[WARN] $1"
  warning_count=$((warning_count + 1))
}

mark_failure() {
  write_line "[FAIL] $1"
  failure_count=$((failure_count + 1))
}

mark_error() {
  write_line "[ERROR] $1"
  error_count=$((error_count + 1))
}

# ---------------- Sanitization ----------------------------------------------
# Removes secrets before anything is written to the report or saved logs.
sanitize_stream() {
  sed -E \
    -e 's/\r$//' \
    -e 's/(Authorization:[[:space:]]*)[^[:space:]].*/\1[REDACTED]/I' \
    -e 's/(Bearer|Basic)[[:space:]]+[A-Za-z0-9._~+\/=-]+/\1 [REDACTED]/Ig' \
    -e 's/((password|passwd|pwd|secret|client_secret|token|pat|apikey|api_key)[[:space:]]*[:=][[:space:]]*)[^[:space:],;"]+/\1[REDACTED]/Ig' \
    -e 's#(mysql|postgres|postgresql|mongodb|redis)://[^@[:space:]]+@#\1://[REDACTED]@#Ig' \
    -e 's/-----BEGIN [A-Z ]*PRIVATE KEY-----.*/[REDACTED PRIVATE KEY]/' \
    -e 's/[A-Za-z0-9+\/]{40,}={0,2}/[REDACTED]/g'
}

sanitize_line() {
  local line="$1"
  if echo "$line" | grep -qiE "PRIVATE KEY|ssh-rsa AAAA"
  then
    echo "[line redacted: sensitive content removed]"
    return
  fi
  echo "$line" | sanitize_stream | cut -c1-300
}

# ---------------- Read-only Azure DevOps REST access -------------------------
auth_header=""

get_auth_header() {
  if [ -n "${AZURE_DEVOPS_EXT_PAT:-}" ]
  then
    auth_header="Basic $(printf ':%s' "$AZURE_DEVOPS_EXT_PAT" | base64 | tr -d '\n')"
    return 0
  fi

  if command -v az >/dev/null 2>&1
  then
    local token
    # 499b84ac-... is the fixed resource ID of Azure DevOps
    token=$(az account get-access-token \
      --resource 499b84ac-1321-427f-aa17-267ca6975798 \
      --query accessToken -o tsv 2>/dev/null | tr -d '\r' || true)
    if [ -n "$token" ]
    then
      auth_header="Bearer $token"
      return 0
    fi
  fi
  return 1
}

# ado_get <url> <output-file>  — HTTP GET only. Returns 0 on 200, 1 on auth
# problems, 2 on other API errors. The auth header is passed via stdin so it
# never appears in the process list or the terminal.
ado_get() {
  local url="$1"
  local out="$2"
  local http_code
  http_code=$(printf 'header = "Authorization: %s"\n' "$auth_header" | \
    curl -sS --config - -X GET -H "Accept: application/json, text/plain" \
      -o "$out" -w '%{http_code}' "$url" 2>/dev/null || echo "000")

  case "$http_code" in
    200) return 0 ;;
    203|302|401|403) return 1 ;;   # ADO returns 203 + sign-in page for a bad PAT
    *) return 2 ;;
  esac
}

# ---------------- Configuration validation ----------------------------------
validate_config() {
  local ok=0
  local tool
  for tool in curl jq sed grep base64
  do
    if ! command -v "$tool" >/dev/null 2>&1
    then
      mark_error "Configuration error: required tool '$tool' is not installed"
      ok=1
    fi
  done

  if [[ ! "$infra_pipeline_id" =~ ^[0-9]+$ ]] || [[ ! "$app_pipeline_id" =~ ^[0-9]+$ ]]
  then
    mark_error "Configuration error: pipeline IDs must be numeric (infra='$infra_pipeline_id', app='$app_pipeline_id')"
    ok=1
  fi

  if [ -z "$ado_org" ] || [ -z "$ado_project" ] || [ "$full_name" = "<Your Full Name>" ]
  then
    mark_error "Configuration error: organization, project and full name must be set"
    ok=1
  fi

  if [ "$ok" -eq 0 ] && ! get_auth_header
  then
    mark_error "Authentication error: set AZURE_DEVOPS_EXT_PAT (Build: Read) or run 'az login'"
    ok=1
  fi
  return "$ok"
}

print_header() {
  write_line "========================================"
  write_line "CI/CD Dual-Pipeline Failure Triage Report"
  write_line "========================================"
  write_line "Full Name: $full_name"
  write_line "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  write_line "Provider: Azure DevOps ($ado_project)"
  write_line ""
}

# ---------------- Gather: metadata + logs for one pipeline -------------------
# fetch_pipeline <name> <id> <raw-log-file>
# Sets current_* variables and builds $evidence_file (logs of FAILED steps only,
# so successful runs cannot produce false category matches).
fetch_pipeline() {
  local name="$1"
  local id="$2"
  local raw_log="$3"
  local project_enc="${ado_project// /%20}"
  local api="$ado_org/$project_enc/_apis/build/builds"
  local tmp_json="$report_dir/.meta.json"
  local rc

  current_name="$name"
  current_status=""
  current_result=""
  evidence_file="$report_dir/.evidence-$id.log"
  : > "$evidence_file"
  : > "$raw_log"

  write_line "----------------------------------------"
  write_line "Pipeline: $name (ID: $id)"

  # 1) Metadata: latest run on any branch (Builds REST API, GET)
  ado_get "$api?definitions=$id&\$top=1&queryOrder=queueTimeDescending&api-version=$api_version" "$tmp_json"
  rc=$?
  if [ "$rc" -eq 1 ]; then mark_error "Authentication error while reading $name runs (check PAT scope / login)"; return 1; fi
  if [ "$rc" -ne 0 ]; then mark_error "API error while reading $name runs"; return 1; fi

  if [ "$(jq -r '.count // 0' "$tmp_json")" -eq 0 ]
  then
    mark_error "No run found for $name (check the pipeline ID)"
    return 1
  fi

  local run_id build_no branch finish
  run_id=$(jq -r '.value[0].id' "$tmp_json")
  build_no=$(jq -r '.value[0].buildNumber' "$tmp_json")
  branch=$(jq -r '.value[0].sourceBranch // "unknown"' "$tmp_json" | sed 's#^refs/heads/##')
  current_status=$(jq -r '.value[0].status // "unknown"' "$tmp_json")
  current_result=$(jq -r '.value[0].result // "none"' "$tmp_json")
  finish=$(jq -r '.value[0].finishTime // "not finished"' "$tmp_json")

  write_line "Run ID: $run_id (build $build_no)"
  write_line "Branch: $branch"
  write_line "Status: $current_status"
  write_line "Result: $current_result"
  write_line "Completion Time: $finish"

  # 2) Failed steps from the timeline (GET)
  local failed_log_ids=""
  if ado_get "$api/$run_id/timeline?api-version=$api_version" "$tmp_json"
  then
    local failed_steps
    failed_steps=$(jq -r '[.records[]? | select(.type=="Task" and (.result=="failed" or .result=="succeededWithIssues")) | .name] | join(", ")' "$tmp_json")
    failed_log_ids=$(jq -r '.records[]? | select(.type=="Task" and (.result=="failed" or .result=="succeededWithIssues")) | .log.id // empty' "$tmp_json")
    write_line "Failed Step(s): ${failed_steps:-none}"
  else
    mark_error "API error while reading the $name timeline"
    return 1
  fi

  # 3) Log IDs, then each log as text (Build Logs REST API, GET)
  if ! ado_get "$api/$run_id/logs?api-version=$api_version" "$tmp_json"
  then
    mark_error "Log-retrieval error: could not list logs for $name run $run_id"
    return 1
  fi

  local log_id log_count=0
  for log_id in $(jq -r '.value[]?.id' "$tmp_json")
  do
    if ado_get "$api/$run_id/logs/$log_id?api-version=$api_version" "$report_dir/.log.txt"
    then
      # Azure DevOps may return the log as JSON {"count":N,"value":["line",...]}
      if jq -e '.value' "$report_dir/.log.txt" >/dev/null 2>&1
      then
        jq -r '.value[]' "$report_dir/.log.txt" > "$report_dir/.log.lines" && \
          mv "$report_dir/.log.lines" "$report_dir/.log.txt"
      fi
      {
        echo "===== log $log_id ====="
        sanitize_stream < "$report_dir/.log.txt"
      } >> "$raw_log"
      log_count=$((log_count + 1))
      if echo "$failed_log_ids" | grep -qx "$log_id"
      then
        sanitize_stream < "$report_dir/.log.txt" >> "$evidence_file"
      fi
    fi
  done
  rm -f "$report_dir/.log.txt" "$tmp_json"

  if [ "$log_count" -eq 0 ]
  then
    mark_error "Log-retrieval error: no log text downloaded for $name run $run_id"
    return 1
  fi
  write_line "Logs Retrieved: $log_count -> $(basename "$raw_log")"
  write_line ""
  return 0
}

# ---------------- Classification helpers -------------------------------------
# match_category <label> <regex> : case-insensitive search of failed-step logs
match_category() {
  local label="$1"
  local pattern="$2"
  local line
  line=$(grep -m1 -iE "$pattern" "$evidence_file" 2>/dev/null || true)
  if [ -n "$line" ]
  then
    mark_failure "$current_name: $label"
    write_line "       Evidence: $(sanitize_line "$line")"
    category_matches=$((category_matches + 1))
  else
    mark_pass "$current_name: no $label"
  fi
}

check_auth_failure() {
  match_category "Authentication, authorization or SSH failure" \
    "401 Unauthorized|status code 401|403 Forbidden|TF400813|invalid_grant|token has expired|AuthorizationFailed|Permission denied \(publickey|Host key verification failed|Bad credentials"
}

check_agent_failure() {
  match_category "Agent availability, timeout or queue failure" \
    "no agent found|agent.*offline|timed out waiting for an agent|job.*timed out|ran longer than the maximum time|lost communication with the server|received a shutdown signal"
}

check_terraform_failure() {
  match_category "Terraform infrastructure or provisioning failure" \
    "Error acquiring the state lock|Error: .*(creating|updating|deleting|reading) |RequestDisallowedByAzure|SkuNotAvailable|ProvisionNotSupportedForRegion|terraform.*(plan|apply|init|validate).*(failed|error)|Error: Invalid|Error: Unsupported"
}

check_dependency_failure() {
  match_category "Dependency installation failure" \
    "npm ERR!|npm error|ERESOLVE|E404|No matching version found|is not in this registry|pip install.*error|ModuleNotFoundError|package not found|Unable to locate package|Could not resolve dependencies"
}

check_build_failure() {
  match_category "Build or compilation failure" \
    "build failed|compilation error|SyntaxError|TS[0-9]{4}|webpack.*failed|Cannot find module"
}

check_test_failure() {
  match_category "Test failure" \
    "tests? failed|AssertionError|[0-9]+ failing|expect\(received\)|Tests:.*failed|FAIL "
}

check_deployment_failure() {
  match_category "Ansible, Nginx or application deployment failure" \
    "fatal: \[|UNREACHABLE!|failed=[1-9]|ERROR! |nginx: \[emerg\]|configuration file .* test failed|Job for .*service failed|curl: \([0-9]+\)"
}

# Final check per pipeline: interprets the Azure DevOps state/result.
check_ado_run_result() {
  case "$current_status" in
    notStarted|inProgress|postponed|cancelling)
      mark_warning "$current_name: run is '$current_status' - final result not known yet (not healthy)"
      return ;;
  esac

  case "$current_result" in
    succeeded)
      mark_pass "$current_name: Azure DevOps result is 'succeeded'" ;;
    partiallySucceeded)
      mark_warning "$current_name: Azure DevOps result is 'partiallySucceeded'" ;;
    canceled)
      mark_warning "$current_name: run was canceled - no final result" ;;
    failed)
      if [ "$category_matches" -eq 0 ]
      then
        mark_failure "$current_name: Unclassified Pipeline Failure (result 'failed', no known pattern matched)"
      else
        mark_pass "$current_name: failed result is explained by the category above"
      fi ;;
    *)
      mark_warning "$current_name: unexpected result '$current_result'" ;;
  esac
}

# ---------------- Summary + differentiated exit codes ------------------------
print_summary() {
  local overall_status
  local script_exit_code

  if [ "$error_count" -gt 0 ]
  then
    overall_status="ERROR"
    script_exit_code=3
  elif [ "$failure_count" -gt 0 ]
  then
    overall_status="FAIL"
    script_exit_code=2
  elif [ "$warning_count" -gt 0 ]
  then
    overall_status="WARN"
    script_exit_code=1
  else
    overall_status="HEALTHY"
    script_exit_code=0
  fi

  write_line ""
  write_line "Summary:"
  write_line "PASS: $pass_count"
  write_line "WARN: $warning_count"
  write_line "FAIL: $failure_count"
  write_line "ERROR: $error_count"
  write_line "Overall Status: $overall_status"
  write_line "Script Exit Code: $script_exit_code"
  write_line "Report File: $report_file"
  write_line "Raw Log Files: $infra_log_file, $app_log_file"

  return "$script_exit_code"
}

# ---------------- Main -------------------------------------------------------
print_header

if validate_config
then
  pipelines=(
    "$infra_pipeline_name|$infra_pipeline_id|$infra_log_file"
    "$app_pipeline_name|$app_pipeline_id|$app_log_file"
  )

  for entry in "${pipelines[@]}"
  do
    IFS='|' read -r p_name p_id p_log <<< "$entry"
    category_matches=0

    if fetch_pipeline "$p_name" "$p_id" "$p_log"
    then
      for check_function in "${checks[@]}"
      do
        "$check_function"
      done
    fi
    rm -f "$evidence_file"
    write_line ""
  done
fi

print_summary
exit $?
