---
name: linux-triage
description: Run the Linux/Nginx health triage script and summarize the results. Use only when explicitly invoked with /linux-triage.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep
---

# Linux Triage Skill

## What this does
Runs `scripts/linux-triage.sh` and reports the health of Nginx and the underlying Linux host based strictly on the script's output.

## Rules
- Only run the triage script and read its output — do not write, edit, or create files.
- Do not execute any recovery or remediation commands (e.g. systemctl restart, systemctl start).
- Base every conclusion strictly on the evidence produced by the script.
- If evidence is inconclusive, say so rather than guessing at a cause.
- If any check reports FAIL, suggest a likely cause and a recovery command, but do not run it — leave execution to the human operator.
