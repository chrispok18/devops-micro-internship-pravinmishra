# Changes made to the supplied files (and why)

The supplied `pipeline-triage.sh` and `SKILL.md` were a single-pipeline version.
Task 3 of the brief states what the script **must** do, which counts as the
instructor's direction to change more than the placeholders. The original
structure (check-function array, `write_line`, `mark_*` helpers, summary,
exit codes) was kept. Only the items below were added or changed.

## pipeline-triage.sh

| # | Change | Brief requirement it satisfies |
|---|--------|--------------------------------|
| 1 | Placeholders set: full name, organization URL, project, **two** pipeline IDs and names | Task 3 – replace placeholders for Infra + App pipeline IDs |
| 2 | `base_dir` now resolves to the script's own folder (the supplied `/..` wrote reports one level up) | Task 3 – "resolves the directory containing the script" |
| 3 | Raw logs split into `infra-last-run.log` and `app-last-run.log` | Task 3 – required report filenames |
| 4 | Run metadata via the Builds REST API (GET) now records pipeline name, ID, run ID, branch, status, result and completion time | Task 3 – required report fields |
| 5 | Step console logs downloaded via the **Build Logs REST API** (list log IDs, then GET each log as text) | Task 3 – "must use the Build Logs REST API"; `az pipelines runs show` alone is not enough |
| 6 | Categories added: Terraform infrastructure, Ansible/Nginx/deployment, and **Unclassified Pipeline Failure**; auth pattern extended with SSH errors; `exit code 1` removed from the build pattern because every failed step prints it | Task 3 – required failure categories; specific patterns before general ones |
| 7 | Category checks only search the logs of **failed** steps, so a green run cannot produce a false match | Task 3 – classification from log evidence |
| 8 | State handling: queued/running → WARN, partiallySucceeded/canceled → WARN, no run found / auth / API / config / log-retrieval problems → ERROR | Task 3 – required state handling; running must not be healthy |
| 9 | Exit code **3** added for configuration, authentication, API or log-retrieval errors (supplied script reported these as HEALTHY / 0) | Task 3 – recommended exit-code design |
| 10 | `sanitize_stream` / `sanitize_line` redact authorization headers, Bearer/Basic tokens, password=/secret=/token= values, connection-string credentials, private keys and long token-like strings before anything is written | Task 3 – evidence-sanitization requirements |
| 11 | Authentication from `AZURE_DEVOPS_EXT_PAT` (Build: Read) or an `az login` Entra token; passed to curl through stdin so it never appears on screen, in files or the process list | Prerequisites – never store or print the PAT |
| 12 | GitHub Actions branch removed | Brief – "GitHub Actions is not required" |

All Azure DevOps calls are HTTP **GET**. No queue, retry, cancel, approve, delete or update operation exists in the script.

## SKILL.md

| # | Change | Why |
|---|--------|-----|
| 1 | `allowed-tools: Bash` → `Bash(./pipeline-triage.sh), Read(reports/**), Read(CLAUDE.md), Grep` | Brief – "Do not give the skill broad or unrestricted Bash approval" |
| 2 | Runs exactly `./pipeline-triage.sh` | Only the exact triage command is pre-approved |
| 3 | Reads `pipeline-health-report.txt` and greps both pipeline logs | Two log files now exist |
| 4 | Output adds affected pipeline, run ID, branch, exit code, likely cause; category list extended | Task 5 – required output fields |

Frontmatter on line 1, `disable-model-invocation: true`, and all safety rules were kept unchanged.

## Added

- `.claude/settings.json` – project **deny** rules (Edit/Write, git push/commit, pipeline queue/cancel/update, service connections, variable groups, Terraform, Ansible, curl, rm, and reading SSH keys / .env / Azure credentials). Brief Task 5: combine allowed-tools with project permission deny rules.
- `.gitignore` – keeps raw logs out of Git.
| 13 | Logs returned by Azure DevOps as JSON (`{"count":N,"value":[...]}`) are unpacked into plain lines, and Windows line endings (`\r`) are stripped, so evidence lines are readable | Found during the drill: the first report quoted raw JSON instead of the npm error line |
