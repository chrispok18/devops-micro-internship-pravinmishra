#!/usr/bin/env bash
#
# linux-triage.sh — read-only Linux/Nginx health-check script.
#
# Gathers evidence only (service status, port, HTTP response, disk space,
# error logs). Takes no remediation action — recovery is a human decision.

set -uo pipefail

OPERATOR_FULL_NAME="Christian Aryee"
ERROR_LOG="/var/log/nginx/error.log"

CHECK_NAMES=(
  "Service Status"
  "Port Availability"
  "HTTP Response"
  "Disk Space"
  "Error Logs"
)

CHECK_FUNCTIONS=(
  "check_service_status"
  "check_port_availability"
  "check_http_response"
  "check_disk_space"
  "check_error_logs"
)

# Each check_* function prints its own evidence and sets these two globals.
CHECK_STATUS=""
CHECK_DETAIL=""

check_service_status() {
  echo "---- Check 1: Service Status ----"

  if ! command -v systemctl >/dev/null 2>&1; then
    echo "systemctl not found on this system."
    CHECK_STATUS="WARN"
    CHECK_DETAIL="systemctl unavailable; cannot determine service status."
    return
  fi

  if systemctl is-active --quiet nginx; then
    systemctl status nginx --no-pager | head -n 10
    CHECK_STATUS="HEALTHY"
    CHECK_DETAIL="nginx.service is active and running."
  else
    echo "nginx.service is NOT active."
    systemctl status nginx --no-pager | head -n 15
    CHECK_STATUS="FAIL"
    CHECK_DETAIL="nginx.service is not active."
  fi
}

check_port_availability() {
  echo "---- Check 2: Port Availability ----"

  if ! command -v ss >/dev/null 2>&1; then
    echo "ss not found on this system."
    CHECK_STATUS="WARN"
    CHECK_DETAIL="ss unavailable; cannot verify listening ports."
    return
  fi

  local listen_80
  listen_80=$(ss -tulpn 2>/dev/null | grep -E ':80[[:space:]]')

  if [[ -n "$listen_80" ]]; then
    echo "Port 80 is listening:"
    echo "$listen_80"
    CHECK_STATUS="HEALTHY"
    CHECK_DETAIL="Port 80 has an active listener."
  else
    echo "No listener found on port 80."
    CHECK_STATUS="FAIL"
    CHECK_DETAIL="Port 80 has no active listener."
  fi
}

check_http_response() {
  echo "---- Check 3: HTTP Response ----"

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl not found on this system."
    CHECK_STATUS="WARN"
    CHECK_DETAIL="curl unavailable; cannot verify HTTP response."
    return
  fi

  local http_code time_total
  read -r http_code time_total < <(curl -s -o /dev/null --max-time 5 \
    -w '%{http_code} %{time_total}' http://localhost/ 2>/dev/null)

  if [[ -z "$http_code" || "$http_code" == "000" ]]; then
    echo "No HTTP response received from http://localhost/"
    CHECK_STATUS="FAIL"
    CHECK_DETAIL="No response from http://localhost/ (connection failed or timed out)."
  elif [[ "$http_code" =~ ^2 ]]; then
    echo "HTTP $http_code received in ${time_total}s"
    CHECK_STATUS="HEALTHY"
    CHECK_DETAIL="HTTP $http_code in ${time_total}s."
  elif [[ "$http_code" =~ ^(4|5) ]]; then
    echo "HTTP $http_code received in ${time_total}s"
    CHECK_STATUS="FAIL"
    CHECK_DETAIL="HTTP $http_code error response in ${time_total}s."
  else
    echo "HTTP $http_code received in ${time_total}s"
    CHECK_STATUS="WARN"
    CHECK_DETAIL="Unexpected HTTP $http_code in ${time_total}s."
  fi
}

check_disk_space() {
  echo "---- Check 4: Disk Space ----"

  local output use_pct
  output=$(df -h / 2>/dev/null)
  echo "$output"

  use_pct=$(echo "$output" | tail -n 1 | awk '{print $5}' | tr -d '%')

  if [[ -z "$use_pct" ]]; then
    CHECK_STATUS="WARN"
    CHECK_DETAIL="Could not determine disk usage for /."
  elif (( use_pct >= 90 )); then
    CHECK_STATUS="FAIL"
    CHECK_DETAIL="Root filesystem at ${use_pct}% used (critical)."
  elif (( use_pct >= 75 )); then
    CHECK_STATUS="WARN"
    CHECK_DETAIL="Root filesystem at ${use_pct}% used (approaching capacity)."
  else
    CHECK_STATUS="HEALTHY"
    CHECK_DETAIL="Root filesystem at ${use_pct}% used."
  fi
}

check_error_logs() {
  echo "---- Check 5: Recent Error Logs ----"

  if [[ ! -r "$ERROR_LOG" ]]; then
    echo "Cannot read $ERROR_LOG"
    CHECK_STATUS="WARN"
    CHECK_DETAIL="$ERROR_LOG not readable; cannot verify error state."
    return
  fi

  local recent error_count
  recent=$(tail -n 50 "$ERROR_LOG")
  echo "$recent"

  error_count=$(echo "$recent" | grep -Ec '\[(error|crit|alert|emerg)\]')

  if (( error_count > 0 )); then
    CHECK_STATUS="FAIL"
    CHECK_DETAIL="${error_count} error-level entries found in last 50 lines of error.log."
  else
    CHECK_STATUS="HEALTHY"
    CHECK_DETAIL="No error/crit/alert/emerg entries in last 50 lines of error.log."
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "================================================"
echo " Linux/Nginx Triage Report"
echo " Full Name: ${OPERATOR_FULL_NAME}"
echo " Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo " Host: $(hostname)"
echo "================================================"
echo

RESULTS=()

for i in "${!CHECK_NAMES[@]}"; do
  name="${CHECK_NAMES[$i]}"
  func="${CHECK_FUNCTIONS[$i]}"

  CHECK_STATUS=""
  CHECK_DETAIL=""
  "$func"

  RESULTS[$i]="$CHECK_STATUS"
  echo "Result: $CHECK_STATUS — $CHECK_DETAIL"
  echo
done

HAS_FAIL=false
HAS_WARN=false
for r in "${RESULTS[@]}"; do
  [[ "$r" == "FAIL" ]] && HAS_FAIL=true
  [[ "$r" == "WARN" ]] && HAS_WARN=true
done

if $HAS_FAIL; then
  OVERALL_STATUS="FAIL"
elif $HAS_WARN; then
  OVERALL_STATUS="WARN"
else
  OVERALL_STATUS="HEALTHY"
fi

echo "================================================"
echo " Summary"
echo "================================================"
for i in "${!CHECK_NAMES[@]}"; do
  printf "  %-20s %s\n" "${CHECK_NAMES[$i]}:" "${RESULTS[$i]}"
done
echo
echo "Overall Status: ${OVERALL_STATUS}"
echo "================================================"

if [[ "$OVERALL_STATUS" == "HEALTHY" ]]; then
  exit 0
else
  exit 1
fi
