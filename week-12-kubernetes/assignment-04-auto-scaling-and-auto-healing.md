# Assignment 4 — Auto-Scaling & Auto-Healing: Let Kubernetes React for You

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this guided lab, you will prove Deployment auto-healing by deleting a Pod, then configure a CPU-based Horizontal Pod Autoscaler that maintains between two and five NGINX Pods.

---

# Task 1 — Set Up the Lab Directory

## Goal

Create the `~/k8s-labs/autoscaling` working directory.

### Evidence

#### Screenshot 1 — Terminal showing the `autoscaling` directory

![Screenshot 1 — Terminal showing the `autoscaling` directory](screenshots/assignment-04-screenshot-01.png)

---

# Task 2 — Prove Deployment Auto-Healing

## Goal

Create `demo-autohealing` (two replicas), delete one Pod, and confirm the desired count of two is restored automatically.

### Evidence

#### Screenshot 2 — Deleted Pod and replacement Pod with the replica count restored

![Screenshot 2 — Deleted Pod and replacement Pod with the replica count restored](screenshots/assignment-04-screenshot-02.png)

---

# Task 3 — Create the HPA-Ready Deployment and Enable Metrics

## Goal

Deploy `nginx-deployment` with CPU `requests: 100m` / `limits: 200m`, then enable Metrics Server (Minikube addon or manifest + kubelet TLS patch for kind) and confirm it reports `READY 1/1`.

### Evidence

#### Screenshot 3 — Deployment resources plus successful Metrics Server status

![Screenshot 3 — Deployment resources plus successful Metrics Server status](screenshots/assignment-04-screenshot-03a.png)

![Screenshot 3 — Deployment resources plus successful Metrics Server status](screenshots/assignment-04-screenshot-03b.png)

![Screenshot 3 — Deployment resources plus successful Metrics Server status](screenshots/assignment-04-screenshot-03c.png)

---

# Task 4 — Create and Inspect the HPA

## Goal

Create an HPA (imperatively via `kubectl autoscale` or declaratively via `autoscaling/v2`) targeting `nginx-deployment` with min 2, max 5, and 50% target CPU utilization.

### Evidence

#### Screenshot 4 — `kubectl get hpa` and `kubectl describe hpa nginx-hpa` output

![Screenshot 4 — `kubectl get hpa` and `kubectl describe hpa nginx-hpa` output](screenshots/assignment-04-screenshot-04.png)

![Screenshot 4 — `kubectl get hpa` and `kubectl describe hpa nginx-hpa` output](screenshots/assignment-04-screenshot-04b.png)

---

# Task 5 — Optionally Generate CPU Load

## Goal

Generate CPU load inside an NGINX Pod (`yes > /dev/null`) and monitor whether the HPA increases replicas.

### Evidence

#### Screenshot 5 — HPA output showing current metrics and any replica increase

![Screenshot 5 — HPA output showing current metrics and any replica increase](screenshots/assignment-04-screenshot-05.png)

---

### Notes

Write a short note describing what the lab demonstrated.

This lab showed two different ways Kubernetes keeps an application reliable.

Auto-healing keeps the number of Pods the same. I created demo-autohealing with 2 replicas and deleted the Pod 2phw5. Within seconds, the Deployment’s ReplicaSet created a replacement, f6hhz, and the Deployment went from 1/2 back to 2/2. Auto-healing restores the desired count but never changes it.

Auto-scaling changes the number of Pods based on demand. First I added CPU settings to nginx-deployment: a request of 100m (0.1 of a core) and a limit of 200m. The HPA needs the request because it measures CPU as a percentage of it. Next I installed Metrics Server, which measures real CPU usage. On kind it failed at first with an x509: cannot validate certificate error and stayed at 0/1. After adding the --kubelet-insecure-tls setting it became 1/1, and kubectl top pods showed real numbers.

I then created nginx-hpa with min 2, max 5 and a 50% CPU target. Its target showed <unknown> for the first few seconds until it got its first metrics reading, and then 0%/50%. When I ran yes > /dev/null inside one Pod, its CPU rose to its 200m limit, which pushed the average above 50%. The HPA scaled the Deployment from 2 to 4 Pods and recorded the event “New size: 4; reason: cpu resource utilization above target.” When the load stopped, the CPU dropped back to 0%, and the HPA will gradually scale back toward the minimum of 2.

Together, auto-healing protects the app from failures, and auto-scaling protects it from traffic spikes without anyone scaling manually.

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the completed YAML manifests used in the lab

---

# Completion Checklist

- [x] Task 1: Lab directory created (Screenshot 1)
- [x] Task 2: Auto-healing observed (Screenshot 2)
- [x] Task 3: HPA-ready Deployment applied and Metrics Server verified (Screenshot 3)
- [x] Task 4: HPA created and inspected (Screenshot 4)
- [x] Task 5: CPU load generated and scaling observed (Screenshot 5, optional)
- [x] Reflection notes written (Notes)

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
