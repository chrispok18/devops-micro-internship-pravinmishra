# Assignment 3 — Deploy a React Application on Azure Virtual Machine Using Terraform

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to provision an Azure resource group, network, and Ubuntu 20.04 VM, then deploy the `my-react-app` React application onto the VM over SSH and serve it through Nginx.

---

# Task 1 — Create a New Terraform Project

## Goal

Create a `terraform-react-azure` project directory for the Azure Terraform configuration.

### Evidence

#### Screenshot 1 — File Explorer, VS Code, or terminal showing the `terraform-react-azure` project directory

![Screenshot 1 — File Explorer, VS Code, or terminal showing the `terraform-react-azure` project directory](screenshots/assignment-03-screenshot-01.png)

---

# Task 2 — Write main.tf to Provision the Azure Infrastructure

## Goal

Define the resource group, virtual network/subnet, Network Security Group (SSH 22, HTTP 80), public IP, network interface, and Ubuntu 20.04 Standard B1s VM in `main.tf`.

### Evidence

#### Screenshot 2 — VS Code showing `main.tf` with the required Azure resources, with any password or sensitive values hidden

![Screenshot 2 — VS Code showing `main.tf` with the required Azure resources, with any password or sensitive values hidden](screenshots/assignment-03-screenshot-04.png)

---

# Task 3 — Initialize Terraform

## Goal

Run `terraform init` and confirm the working directory initializes successfully.

### Evidence

#### Screenshot 3 — Terminal showing successful `terraform init` output

![Screenshot 3 — Terminal showing successful `terraform init` output](screenshots/assignment-03-screenshot-03a.png)

---

# Task 4 — Plan and Apply the Configuration

## Goal

Review `terraform plan`, run `terraform apply`, and record the VM's public IP.

### Evidence

#### Screenshot 4 — Terraform apply output showing successful completion

![Screenshot 4 — Terraform apply output showing successful completion](screenshots/assignment-03-screenshot-04a.png)

---

#### Screenshot 5 — Azure portal showing the Virtual Machine running and its public IP

![Screenshot 5 — Azure portal showing the Virtual Machine running and its public IP](screenshots/assignment-03-screenshot-05a.png)

---

# Task 5 — Connect to the Virtual Machine

## Goal

Establish an SSH session with the Ubuntu VM through its public IP.

### Evidence

#### Screenshot 6 — Terminal showing a successful SSH connection to the Azure VM

![Screenshot 6 — Terminal showing a successful SSH connection to the Azure VM](screenshots/assignment-03-screenshot-06a.png)

---

# Task 6 — Install Node.js, npm, and Git

## Goal

Update Ubuntu and install Node.js, npm, and Git.

### Evidence

#### Screenshot 7 — Terminal showing successful installation and the `node -v` and `npm -v` output

![Screenshot 7 — Terminal showing successful installation and the `node -v` and `npm -v` output](screenshots/assignment-03-screenshot-07a.png)

---

# Task 7 — Clone, Build, and Serve the React App with Nginx

## Goal

Follow the `my-react-app` repository README to clone, install, and build the app, then serve the production build through Nginx.

### Evidence

#### Screenshot 8 — Terminal showing the successful React build

![Screenshot 8 — Terminal showing the successful React build](screenshots/assignment-03-screenshot-08a.png)

---

#### Screenshot 9 — Terminal showing that Nginx is active and running

![Screenshot 9 — Terminal showing that Nginx is active and running](screenshots/assignment-03-screenshot-09a.png)

---

# Task 8 — Test the Deployment

## Goal

Confirm the React application loads through the VM's public IP and navigation works.

### Evidence

#### Screenshot 10 — Browser showing the React application with the Azure VM public IP visible in the address bar

![Screenshot 10 — Browser showing the React application with the Azure VM public IP visible in the address bar](screenshots/assignment-03-screenshot-10aa.png)
---

### Notes

Write a short summary of what you built and any issues you encountered and how you resolved them.

Write your answer here.

I built the terraform-react-azure project from scratch, provisioning a resource group, virtual network, subnet, Network Security Group, public IP, and network interface, then automated the initial React app deployment using a cloud-init.sh script passed to the VM via custom_data = base64encode(file(...)). The script was written from the my-react-app repository's README instructions, using sed to inject my name and deployment date non-interactively so the VM could provision without any manual input.

The main issue I hit during provisioning was a SkuNotAvailable error on Standard_B1s in East US — the same capacity problem from an earlier Terraform assignment on this subscription. I resolved it by switching the VM size to Standard_D2ads_v7, which also required updating the OS image SKU to 22_04-lts-gen2, since that VM size only supports Gen2 images.

After deployment, I connected over SSH and manually verified the environment: node -v and npm -v confirmed Node.js and npm were installed (via cloud-init), and I ran npm run build again to confirm the React app compiled successfully. This build attempt initially failed with an EACCES: permission denied error, because cloud-init runs as root, leaving the project files owned by root instead of azureuser. I fixed this with sudo chown -R azureuser:azureuser ~/my-react-app before rebuilding successfully. I also confirmed Nginx was active and running, and loaded the app in a browser via the VM's public IP.

I restricted SSH access in the NSG to my own public IP (rather than leaving it open to *) and kept the VM password out of version control using a variables.tf + gitignored terraform.tfvars pair. All resources were destroyed with terraform destroy after testing was complete.

# Submission Instructions

- Add all required screenshots in your submission
- Include the Azure VM public IP
- Do not expose Azure credentials, passwords, or private keys

---

# Completion Checklist

- [x] Task 1: `terraform-react-azure` project created (Screenshot 1)
- [x] Task 2: `main.tf` defines all required Azure resources (Screenshot 2)
- [x] Task 3: `terraform init` completed successfully (Screenshot 3)
- [x] Task 4: Plan applied and VM running with public IP (Screenshots 4–5)
- [x] Task 5: SSH connection verified (Screenshot 6)
- [x] Task 6: Node.js, npm, and Git installed (Screenshot 7)
- [x] Task 7: React app built and served through Nginx (Screenshots 8–9)
- [x] Task 8: App verified through the VM public IP (Screenshot 10)
- [x] Summary paragraph written (Notes)
- [x] No sensitive information exposed

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
