# Kubernetes Incident Summary

**Full Name:** Christian Aryee
**Cluster:** minikube (personal lab) · **Namespace:** book-review · **Workload:** Deployment `backend`

## 1. Reported Symptom
After a new image was rolled out to the `backend` Deployment, the backend Pod never became ready and `backend-service` had no endpoints. The frontend had nothing to send API calls to, so the Book Review App stopped serving data.

## 2. Evidence Collected
The read-only `scripts/k8s-triage.sh` produced `reports/incident-failure-report.txt` (2026-10-22T19:04:15Z): PASS 2, WARN 1, FAIL 3, exit code 2.
- Pod `backend-68474bcbfc-nwlr5` was `0/1 ImagePullBackOff` with 0 restarts.
- Readiness check failed: READY 0/1.
- `backend-service` had no ready backends. Its EndpointSlice listed the Pod as `ready=false`.
- Pod events: `Failed to pull image "chrispok18/book-review-backend:does-not-exist" ... not found`, then `ErrImagePull` and `Back-off pulling image`.
- There were no container logs, because the container never started. The events were the key evidence.

## 3. Most Likely Cause
The `backend` Deployment had been pointed at the image tag `chrispok18/book-review-backend:does-not-exist`, which does not exist on Docker Hub. The kubelet could not pull it, so the new Pod could never start. Because the rollout uses `maxSurge: 0` with one replica, the old healthy Pod was removed first, which left the Service with no backend.

## 4. Human-Approved Recovery Action
Claude suggested the recovery command as text only and did not run it. I checked every part against `lab-config.md` (Deployment, container, image and namespace), then ran it myself in a separate terminal:
`kubectl set image deployment/backend backend=chrispok18/book-review-backend:v1 -n book-review`
I then waited with `kubectl rollout status deployment/backend -n book-review --timeout=180s`.

## 5. Verification
- The rollout completed successfully.
- The new Pod `backend-fd4874f67-wz652` was `1/1 Running` with 0 restarts, and the broken Pod was gone.
- `backend-service` had an endpoint again (`10.244.120.98:3010`, `ready=true`), and the Deployment image was back to `chrispok18/book-review-backend:v1`.
- A second `/k8s-triage` run, saved as `reports/recovery-report.txt` (2026-10-22T19:07:21Z), showed PASS 5, WARN 1, **FAIL 0**.
- The remaining WARN comes only from historical ImagePull Warning events on the deleted Pod `backend-68474bcbfc-nwlr5`. These expire on their own after about an hour, so no further action is needed.

## 6. Safety Decision
Claude was limited to running the read-only script and analysing its report. I kept Claude Code in manual permission mode and approved only `bash scripts/k8s-triage.sh || true` and report reads. I would have denied any cluster-changing request. I ran both the failure and the recovery myself, in a separate terminal, on my personal Minikube lab cluster. `CLAUDE.md` and `SKILL.md` describe this boundary, but they don't enforce it, so my review of each request was the real safeguard.

## 7. Agentic Loop Mapping
- **Gather:** `k8s-triage.sh` collected Pod status, readiness, restart counts, Warning events and Service backends, and wrote a PASS/WARN/FAIL report.
- **Analyze:** Claude read the report through `/k8s-triage`, explained each failure with evidence, named the bad image tag as the cause, and suggested one recovery command as text.
- **Human Act:** I reviewed the command against my recorded configuration and ran the image restore myself.
- **Verify:** I ran the same skill again and compared `recovery-report.txt` (FAIL 0) with `incident-failure-report.txt` (FAIL 3).
