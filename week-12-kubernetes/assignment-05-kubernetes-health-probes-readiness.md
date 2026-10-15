# Assignment 5 — Kubernetes Health Probes (Readiness)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this guided lab, you will add an HTTP readiness probe to NGINX, intentionally break it, fix it, and prove that readiness gates Pod availability and safe rolling updates.

---

# Task 1 — Create the Baseline Deployment

## Goal

Deploy two NGINX Pods without probes (`00-nginx-deploy-baseline.yaml`) to establish the comparison state.

### Evidence

#### Screenshot 1 — Baseline manifest and healthy two-Pod rollout output

![Screenshot 1 — Baseline manifest and healthy two-Pod rollout output](screenshots/assignment-05-screenshot-01.png)

---

# Task 2 — Add the Readiness Probe

## Goal

Add an HTTP readiness probe on `/` port 80 (`01-nginx-deploy-readiness.yaml`) and confirm Pods become Ready only after it succeeds.

### Evidence

#### Screenshot 2 — Pod description showing the readiness probe and `Ready=True`

![Screenshot 2 — Pod description showing the readiness probe and `Ready=True`](screenshots/assignment-05-screenshot-02.png)

---

# Task 3 — Break and Fix Readiness

## Goal

Change the readiness path to `/does-not-exist`, observe `NotReady` and a stalled rollout, then restore the good manifest.

### Evidence

#### Screenshot 3 — `NotReady` conditions followed by a successful fixed rollout

![Screenshot 3 — `NotReady` conditions followed by a successful fixed rollout](screenshots/assignment-05-screenshot-03.png)

---

# Task 4 — Prove Readiness-Gated Rolling Updates

## Goal

Perform a good image update to `nginx:1.21.2`, then attempt an update to `nginx:1.21.3` with a broken readiness patch, and confirm the rollout stalls before restoring the good spec.

### Evidence

#### Screenshot 4 — Successful good rollout, stalled broken rollout, and successful recovery

![Screenshot 4 — Successful good rollout, stalled broken rollout, and successful recovery](screenshots/assignment-05-screenshot-04.png)

---

# Task 5 — Review Tuning and Optional Cleanup

## Goal

Review probe timing/thresholds and retain or delete the Deployment.

### Evidence

#### Screenshot 5 — Final healthy Pod state or optional cleanup output

![Screenshot 5 — Final healthy Pod state or optional cleanup output](screenshots/assignment-05-screenshot-05.png)

---

### Notes

Write a short note describing what the lab demonstrated.

This lab showed that Running and Ready are not the same thing. Without a probe, Kubernetes marked NGINX Pods ready as soon as the container started. After I added an HTTP readiness probe on / port 80, Pods only became Ready after NGINX answered successfully. When I changed the path to /does-not-exist, the probe got HTTP 404 eleven times in under a minute, the new Pod stayed 0/1 with Ready=False, and the rollout timed out while both healthy Pods kept serving. In the rolling-update test, a good update to nginx:1.21.3 rolled out cleanly, but a bad release (nginx:1.21.4 plus a broken probe) stalled at 2 available | 1 unavailable. Because of maxUnavailable: 0, Kubernetes never removed a healthy Pod until a new one passed readiness. Applying the fixed manifest restored the Deployment. Note: I used 1.21.3 and 1.21.4 because nginx:1.21.2 does not exist on Docker Hub. Probe timing is a trade-off: with periodSeconds: 5 and failureThreshold: 3, a failing Pod is pulled out after about 15 seconds.
---

# Submission Instructions

- Add all required screenshots in your submission
- Include the completed YAML manifests used in the lab

---

# Completion Checklist

- [x] Task 1: Baseline Deployment applied (Screenshot 1)
- [x] Task 2: Readiness probe added and verified (Screenshot 2)
- [x] Task 3: Readiness broken and fixed (Screenshot 3)
- [x] Task 4: Readiness-gated rolling update proven (Screenshot 4)
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
