# Project Overview

This project builds a read-only Azure security-posture audit for Azure resources created or prepared for this assignment.

The audit covers:

- Network Security Groups
- Storage Account public blob access
- Azure managed disk encryption
- Azure Database for MySQL public network access

The Bash script is responsible for collecting evidence using read-only Azure CLI commands.

Claude Code is responsible for analyzing the evidence, explaining the security or operational impact, and recommending a remediation command for the human operator to review.

# Audit Workflow

Always follow this order:

1. Gather evidence using read-only Azure CLI commands.
2. Analyze the evidence.
3. Explain the security or operational impact.
4. Recommend a remediation command.
5. Ask the human to review and execute the remediation.
6. Verify the Azure environment again.

# Safety Rules

- Never create, modify, resize, start, stop, deallocate, or delete an Azure resource.
- Never run az group delete.
- Never run az vm delete.
- Never run az resource delete.
- Never execute a remediation command.
- Use the Bash audit report as the primary source of evidence.
- Do not claim a finding unless the audit report contains supporting evidence.
- The human operator must approve and execute infrastructure-changing commands.

# Output Rules

When analyzing an audit report, show:

1. Overall status.
2. Every WARN or FAIL finding.
3. Exact evidence from the report.
4. Security or operational impact of each finding.
5. One safe remediation command for the human to review.
6. One verification command.
