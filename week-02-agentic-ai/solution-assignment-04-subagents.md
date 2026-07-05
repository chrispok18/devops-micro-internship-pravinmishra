# Assignment 4 — Building Your AI Team

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build and configure a set of specialized AI subagents inside your project. You will learn how different models and tool permissions define agent behavior, and you will trigger two real agent delegations to analyze security and cost aspects of your Terraform infrastructure.

---

# Task 1 — Create the Agents Folder and Add Files

## Goal

Create the `.claude/agents/` directory and add all required agent files.

### Evidence

#### Screenshot 1 — Agents folder structure in VS Code

![Screenshot 1 - Agents folder structure in VS Code](screenshots/assignment-04-screenshot-01.png)

---

# Task 2 — Compare the Agent Configurations

## Goal

Analyze the configuration differences between the three agents and demonstrate understanding of model and tool selection.

### Written Answers

#### 1. Why does the cost optimizer use Haiku instead of Sonnet?

Honestly, cost checks aren't that deep. You're mostly just comparing what's configured against a known list — is it PriceClass_200 when it could be PriceClass_100, is versioning on when it doesn't need to be, that kind of thing. It's checklist work, not real reasoning. So Haiku handles it fine, and you get the answer back way faster without paying for horsepower you don't need.

---

#### 2. Why does the security auditor NOT have Write in its tools list?

A security audit's job is to find and report problems, not fix them. Keeping it read-only (Read, Grep, Glob) means it can never accidentally modify or corrupt infrastructure files — the principle of least privilege in action.

---

#### 3. Why does the tf-writer use `inherit` instead of a specific model?

Because writing actual Terraform is the part that needs real thought, and locking it to one fixed model would be limiting. `inherit` just means it rides along with whatever model you're already using in the main session  so if you're running something sharper, tf-writer gets that too, instead of being stuck on a fixed setting no matter what.
---

### Evidence

#### Screenshot 2 — security-auditor.md frontmatter

![Screenshot 2 - security-auditor.md frontmatter](screenshots/assignment-04-screenshot-02.png)

---

#### Screenshot 3 — cost-optimizer.md frontmatter

![Screenshot 3 - cost-optimizer.md frontmatter](screenshots/assignment-04-screenshot-03.png)

---

# Task 3 — Run the Security Auditor

## Goal

Trigger the security auditor agent and analyze the generated security report for your Terraform infrastructure.

### Evidence

#### Screenshot 4 — Security auditor delegation triggered

![Screenshot 4 - Security auditor delegation triggered](screenshots/assignment-04-screenshot-04.png)

---

#### Screenshot 5 — Security audit report output

![Screenshot 5 - Security audit report output](screenshots/assignment-04-screenshot-05.png)

---

# Task 4 — Run the Cost Optimizer

## Goal

Trigger the cost optimizer agent and review the generated cost optimization report.

### Evidence

#### Screenshot 6 — Cost optimization report output

![Screenshot 6 - Cost optimization report output](screenshots/assignment-04-screenshot-06.png)

---

# Submission Instructions

- Ensure all agent files are committed in `.claude/agents/`
- Complete all written answers in your Google Doc submission
- Push final changes to your forked GitHub repository
- Submit only the Google Doc link as required

---

## Google Doc Link

Paste your Google Doc URL here:

`https://docs.google.com/document/d/1tyewEklmPAiB9vVkkL1GqrRQmbiz1aySjLH9T0uq38Y/edit?usp=sharing`

---

## GitHub Repository URL

Paste your forked repository URL here:

`https://github.com/chrispok18/devops-micro-internship-pravinmishra`

---

# Completion Checklist

- [X] `.claude/agents/` folder contains all 3 agent files
- [X] Screenshot 2 shows correct `security-auditor.md` configuration
- [X] Screenshot 3 shows correct `cost-optimizer.md` configuration
- [X] All 3 written answers completed in Google Doc
- [X] Security auditor executed successfully
- [X] Cost optimizer executed successfully
- [X] Security report is visible with findings
- [X] Cost report is visible with recommendations
- [X] All required screenshots added
- [X] GitHub repo updated with agents

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*