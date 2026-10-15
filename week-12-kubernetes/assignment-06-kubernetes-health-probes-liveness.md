# Assignment 6 — Kubernetes Health Probes (Liveness)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this guided lab, you will add an HTTP liveness probe to NGINX, force repeated failures, observe container restarts, restore the healthy probe, and review safe tuning.

---

# Task 1 — Create the Baseline Deployment

## Goal

Deploy two NGINX Pods without probes (`00-nginx-deploy-baseline.yaml`).

### Evidence

#### Screenshot 1 — Baseline Deployment and two running Pods

![Screenshot 1 — Baseline Deployment and two running Pods](screenshots/assignment-06-screenshot-01.png)

---

# Task 2 — Add the Liveness Probe

## Goal

Add an HTTP liveness probe on `/` port 80 (`01-nginx-deploy-liveness.yaml`) and confirm the kubelet checks it every 10 seconds after the initial delay.

### Evidence

#### Screenshot 2 — Pod description showing the liveness probe

![Screenshot 2 — Pod description showing the liveness probe](screenshots/assignment-06-screenshot-02.png)

---

# Task 3 — Trigger and Observe a Liveness Restart

## Goal

Change the liveness path to `/does-not-exist`, apply it, and watch `RESTARTS` increase over roughly 20 seconds.

### Evidence

#### Screenshot 3 — Pod RESTARTS increment and the corresponding liveness failure events

![Screenshot 3 — Pod RESTARTS increment and the corresponding liveness failure events](screenshots/assignment-06-screenshot-03.png)

---

# Task 4 — Restore and Stabilize the Probe

## Goal

Reapply the good liveness manifest and confirm restart counts stop increasing.

### Evidence

#### Screenshot 4 — Stable Pod state after the fixed manifest is applied

![Screenshot 4 — Stable Pod state after the fixed manifest is applied](screenshots/assignment-06-screenshot-04.png)

---

# Task 5 — Review Tuning, Troubleshooting, and Cleanup

## Goal

Review recommended probe ranges and retain or delete the Deployment.

### Evidence

#### Screenshot 5 — Final healthy state and any troubleshooting evidence used

![Screenshot 5 — Final healthy state and any troubleshooting evidence used](screenshots/assignment-06-screenshot-05.png)

---

### Notes

Write a short note describing what the lab demonstrated.

This lab showed that a liveness probe answers a different question than a readiness probe: not “can this Pod take traffic?” but “should Kubernetes restart this container?” I added an HTTP liveness probe on / port 80 (10s delay, 10s period, failure threshold 3), and the Pods stayed Running with 0 restarts. When I changed the path to /does-not-exist, NGINX returned 404 and the kubelet logged “Container nginx failed liveness probe, will be restarted” after every 3 failures. RESTARTS climbed to 2 within 52 seconds and reached 4 before I fixed it. The Pod names never changed, because only the container inside was restarted. The rollout still reported success, because liveness does not gate rollouts; readiness does. Applying the fixed manifest created fresh Pods whose restart counts stayed at 0 for over a minute. The main lesson is to tune liveness probes conservatively and keep them lightweight, because an aggressive or dependency-heavy liveness probe can turn a small hiccup into a restart loop.
---

# Submission Instructions

- Add all required screenshots in your submission
- Include the completed YAML manifests used in the lab

---

# Completion Checklist

- [x] Task 1: Baseline Deployment applied (Screenshot 1)
- [x] Task 2: Liveness probe added and verified (Screenshot 2)
- [x] Task 3: Liveness restart triggered and observed (Screenshot 3)
- [x] Task 4: Probe restored and stabilized (Screenshot 4)
- [x] Task 5: Tuning reviewed / cleanup completed (Screenshot 5)
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
