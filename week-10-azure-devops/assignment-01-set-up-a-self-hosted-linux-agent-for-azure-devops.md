# Assignment 1 — Set Up a Self-Hosted Linux Agent for Azure DevOps (Ubuntu + PAT)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will set up a self-hosted Azure DevOps build agent on an Ubuntu VM (AWS or Azure), registering it with a Personal Access Token in a dedicated agent pool, running it as a system service, and verifying it by running a test pipeline.

---

# Task 1 — Create a Personal Access Token (PAT)

## Goal

Create a PAT with Agent Pools (Read & Manage) and Build (Read & Execute) scopes, and store it securely.

> No PAT value screenshot required. If you capture the token settings page, ensure the secret value is not visible.

---

# Task 2 — Create an Agent Pool

## Goal

Create a self-hosted agent pool (e.g. `SelfHostedPool`) in Azure DevOps Organization Settings.

### Evidence

#### Screenshot 1 — Azure DevOps Agent Pools page showing the newly created pool

![Screenshot 1 — Azure DevOps Agent Pools page showing the newly created pool](screenshots/assignment-01-screenshot-01.png)

---

# Task 3 — Provision the Ubuntu VM

## Goal

Create an Ubuntu 22.04 (or latest) VM in AWS or Azure with SSH access, and confirm connectivity.

### Evidence

#### Screenshot 2 — Cloud console showing the running Ubuntu VM and its public IP or DNS name

![Screenshot 2 — Cloud console showing the running Ubuntu VM and its public IP or DNS name](screenshots/assignment-01-screenshot-02.png)

---

#### Screenshot 3 — Terminal showing a successful SSH login and Ubuntu version details

![Screenshot 3 — Terminal showing a successful SSH login and Ubuntu version details](screenshots/assignment-01-screenshot-03.png)

---

# Task 4 — Install and Configure the Agent

## Goal

Download the Linux agent package, register it with your organization/pool/PAT via `config.sh`, and install/start it as a system service.

### Evidence

#### Screenshot 4 — Terminal showing successful agent configuration without exposing the PAT

![Screenshot 4 — Terminal showing successful agent configuration without exposing the PAT](screenshots/assignment-01-screenshot-04.png)

---

#### Screenshot 5 — Terminal showing the agent service running successfully

![Screenshot 5 — Terminal showing the agent service running successfully](screenshots/assignment-01-screenshot-05.png)

---

# Task 5 — Verify the Setup

## Goal

Confirm the agent service is running and the agent shows as Online in the Azure DevOps agent pool.

### Evidence

#### Screenshot 6 — Agent Pool listing showing the registered agent online

![Screenshot 6 — Agent Pool listing showing the registered agent online](screenshots/assignment-01-screenshot-06.png)

---

# Task 6 — Run a Test Pipeline

## Goal

Create and run a YAML pipeline targeting the self-hosted pool, running `uname -a`, `whoami`, and `df -h` on the VM.

### Evidence

#### Screenshot 7 — Successful test pipeline run output in Azure DevOps showing the Linux commands

![Screenshot 7 — Successful test pipeline run output in Azure DevOps showing the Linux commands](screenshots/assignment-01-screenshot-07.png)

---

### Notes

Note the cloud platform used, your Azure DevOps organization/project name, and the agent pool name. Describe any issue you faced and how you resolved it.

Here's the summary section text:

---

**Cloud platform:** AWS (EC2) for the VM; Azure DevOps for the organization/pipelines.

**Azure DevOps organization:** `krisbillion18` (https://dev.azure.com/krisbillion18)

**Project:** `self-hosted-agent-lab`

**Agent pool:** `SelfHostedPool`

**VM:** `SelfHostedAgentVM` (EC2 instance `i-03c8befd750765526`), Ubuntu Server 26.04 LTS, `t3.micro`, region eu-north-1 (Stockholm), public IP `51.20.182.27`

**Agent name:** `self-hosted-agent-1`, registered via a PAT scoped to Agent Pools (Read & manage) and Build (Read & execute), running as a systemd service (`vsts.agent.krisbillion18.SelfHostedPool.self-hosted-agent-1.service`)

**Issue faced and resolution:** SSH connections to the VM timed out even though the security group correctly allowed port 22 from my IP. Inspecting the VPC's route table showed the `0.0.0.0/0` route pointed at an Internet Gateway that no longer existed (status: Blackhole) — there was no Internet Gateway at all in the region. I created a new Internet Gateway, attached it to the VPC, and updated the route table's `0.0.0.0/0` route to point to it. SSH connected successfully afterward, and the rest of the setup (agent install, registration, pipeline run) completed without further issues.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not display the PAT, SSH private key, or other secrets in screenshots or logs

---

# Completion Checklist

- [x] Task 1: PAT created with required scopes and stored securely
- [x] Task 2: Self-hosted agent pool created (Screenshot 1)
- [x] Task 3: Ubuntu VM provisioned and SSH verified (Screenshots 2–3)
- [x] Task 4: Agent installed, registered, and running as a service (Screenshots 4–5)
- [x] Task 5: Agent verified Online (Screenshot 6)
- [x] Task 6: Test pipeline run successfully (Screenshot 7)
- [x] Platform/org/pool details and issue notes written (Notes)
- [x] No secrets exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
