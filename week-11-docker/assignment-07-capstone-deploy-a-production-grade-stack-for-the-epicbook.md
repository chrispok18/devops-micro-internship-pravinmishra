# Assignment 7 — Capstone: Deploy a Production-Grade Stack for The EpicBook

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook application as a production-oriented Docker Compose stack on a cloud VM. You will use optimized container images, isolated networks, health checks, persistent MySQL storage, a selected reverse proxy, logging, backup and restore testing, and reliability procedures.

---

# Task 0 — App Discovery and Architecture

## Goal

Review the EpicBook repository and design the intended application architecture.

### Evidence

#### Screenshot 1 — EpicBook Project Structure

Add a terminal screenshot showing the EpicBook project structure after cloning the repository.

![Screenshot 1 — EpicBook Project Structure](screenshots/assignment-07-screenshot-01.png)

![Screenshot 1 — EpicBook Project Structure](screenshots/assignment-07-screenshot-01b.png)

---

#### Screenshot 2 — Architecture Diagram

Add a screenshot of your architecture diagram showing:

- Public user
- Reverse proxy
- Frontend
- Backend
- Database
- Docker networks
- Public and private ports
- Persistent database storage

Add your full name inside the diagram or as a clear caption below it.

![Screenshot 2 — Architecture Diagram](screenshots/assignment-07-screenshot-02.png)

---

#### Screenshot 3 — Environment Variables and Ports Document

Add a screenshot showing the contents of:

```text
docs/02-env-and-ports.md
```

It must document environment-variable names, internal ports, persistent-data details, and the health-check method. Do not expose real credentials or values.

![Screenshot 3 — Environment Variables and Ports Document](screenshots/assignment-07-screenshot-03.png)

---

# Task 1 — Create Production Docker Images

## Goal

Create optimized production images for the EpicBook backend and frontend.

### Evidence

#### Screenshot 4 — Backend Dockerfile

Add a screenshot showing `backend/Dockerfile`, including:

- Dependency stage
- Minimal runtime stage
- Production startup command
- Internal backend port
- Non-root user configuration

![Screenshot 4 — Backend Dockerfile](screenshots/assignment-07-screenshot-04.png)

---

#### Screenshot 5 — Frontend Dockerfile

Add a screenshot showing `frontend/Dockerfile`, including:

- Nginx runtime image
- Static frontend files copied to the Nginx web root

![Screenshot 5 — Frontend Dockerfile](screenshots/assignment-07-screenshot-05.png)

---

#### Screenshot 6 — Docker Ignore Files

Add a screenshot showing both:

```text
backend/.dockerignore
frontend/.dockerignore
```

![Screenshot 6 — Docker Ignore Files](screenshots/assignment-07-screenshot-06.png)

---

#### Screenshot 7 — Docker Image Builds and Size Comparison

Add a terminal screenshot showing successful builds of:

- Baseline backend image
- Optimized backend image
- Frontend image

The screenshot must also show the baseline and optimized backend image-size comparison.

![Screenshot 7 — Docker Image Builds and Size Comparison](screenshots/assignment-07-screenshot-07.png)

---

#### Screenshot 8 — Backend Running as Non-Root User

Add a terminal screenshot showing the optimized backend container running as a non-root user.

![Screenshot 8 — Backend Running as Non-Root User](screenshots/assignment-07-screenshot-08.png)

---

### Notes

Write a short note covering:

- Baseline and optimized backend image sizes
- The image-size reduction achieved
- One Docker layer-caching optimization used
- The security benefit of running the backend as a non-root user

Baseline and optimized backend image sizes
The image-size reduction achieved

- **Baseline backend image** (`node:20`, single stage, `npm install`): **1.68 GB** on disk (417 MB content).
- **Optimized backend image** (`node:20-alpine`, multi-stage, `npm ci --omit=dev`): **230 MB** on disk (53.3 MB content). That is about **86% smaller**. The frontend image (`nginx:alpine` + static files) is 159 MB.
- **Layer-caching optimization:** `package.json` and `package-lock.json` are copied and `npm ci` runs *before* the source code is copied. Code changes therefore reuse the cached dependency layer instead of reinstalling every package.
- **Non-root security benefit:** the backend runs as the built-in `node` user (UID 1000). If the app were compromised, the attacker would not have root inside the container, which limits what they can change and reduces the risk of breaking out to the host.
---

# Task 2 — Create the Docker Compose Stack and Networks

## Goal

Create one Docker Compose stack containing the reverse proxy, frontend, backend, and MySQL database.

### Evidence

#### Screenshot 9 — Docker Compose Services

Add a screenshot showing `docker-compose.yml` with all four services:

```text
reverse-proxy
frontend
backend
database
```

![Screenshot 9 — Docker Compose Services](screenshots/assignment-07-screenshot-09.png)

---

#### Screenshot 10 — Networks and Named Volume

Add a screenshot showing:

- `front-tier` network
- `back-tier` network
- `db_data` named volume

![Screenshot 10 — Networks and Named Volume](screenshots/assignment-07-screenshot-10.png)

---

#### Screenshot 11 — Docker Compose Validation

Add a terminal screenshot showing successful Docker Compose validation without exposing environment-variable values or secrets.

![Screenshot 11 — Docker Compose Validation](screenshots/assignment-07-screenshot-11.png)

---

# Task 3 — Configure Health Checks and Startup Dependencies

## Goal

Configure health checks and ensure services start only after their dependencies are healthy.

### Evidence

#### Screenshot 12 — Backend Health Endpoint

Add a screenshot showing the backend application configuration for the `/health` endpoint.

![Screenshot 12 — Backend Health Endpoint](screenshots/assignment-07-screenshot-12.png)

---

#### Screenshot 13 — MySQL and Backend Health Checks

Add a screenshot showing `docker-compose.yml` with health checks for MySQL and the backend.

![Screenshot 13 — MySQL and Backend Health Checks](screenshots/assignment-07-screenshot-13.png)

---

#### Screenshot 14 — Frontend and Reverse-Proxy Health Checks

Add a screenshot showing:

- Frontend health check
- Reverse-proxy health check
- `depends_on` conditions using `service_healthy`

![Screenshot 14 — Frontend and Reverse-Proxy Health Checks](screenshots/assignment-07-screenshot-14.png)

---

#### Screenshot 15 — Running Healthy Services

Add a terminal screenshot showing Docker Compose service status. The database, backend, frontend, and reverse proxy must be running successfully.

![Screenshot 15 — Running Healthy Services](screenshots/assignment-07-screenshot-15.png)

---

#### Screenshot 16 — Public Health Endpoint

Add a terminal screenshot showing a successful response from the public application health endpoint through the reverse proxy.

![Screenshot 16 — Public Health Endpoint](screenshots/assignment-07-screenshot-16.png)

---

#### Screenshot 17 — Health-Check and Startup-Order Document

Add a screenshot showing the contents of:

```text
docs/03-healthchecks-and-depends-on.md
```

Explain the health-check method for each service and the startup dependency order.

![Screenshot 17 — Health-Check and Startup-Order Document](screenshots/assignment-07-screenshot-17.png)

---

# Task 4 — Configure the Reverse Proxy and Same-Origin Routing

## Goal

Use either Nginx or Traefik as the only public entry point for the EpicBook application.

### Evidence

#### Screenshot 18 — Selected Reverse-Proxy Configuration

Add a screenshot showing the configuration for your selected reverse proxy.

It must show routes for:

- Static frontend assets
- Application pages
- API requests
- Health endpoint

![Screenshot 18 — Selected Reverse-Proxy Configuration](screenshots/assignment-07-screenshot-18.png)

---

#### Screenshot 19 — Only Reverse Proxy Publishes Port 80

Add a screenshot of `docker-compose.yml` showing that only the `reverse-proxy` service publishes port 80.

![Screenshot 19 — Only Reverse Proxy Publishes Port 80](screenshots/assignment-07-screenshot-19.png)

---

#### Screenshot 20 — Reverse-Proxy Route Testing

Add a terminal screenshot showing successful requests through the selected reverse proxy to:

- Application page
- One API endpoint
- One static asset
- Health endpoint

![Screenshot 20 — Reverse-Proxy Route Testing](screenshots/assignment-07-screenshot-20.png)

---

#### Screenshot 21 — EpicBook Application Through Public IP

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![Screenshot 21 — EpicBook Application Through Public IP](screenshots/assignment-07-screenshot-21.png)

---

#### Screenshot 22 — Proxy Routing and CORS Document

Add a screenshot showing the contents of:

```text
docs/04-proxy-routing-and-cors.md
```

Explain the proxy routes and state whether CORS was required and why.

![Screenshot 22 — Proxy Routing and CORS Document](screenshots/assignment-07-screenshot-22.png)

---

# Task 5 — Prove Data Persistence, Backup, and Restore

## Goal

Verify MySQL persistence and perform a controlled backup and restore drill.

### Evidence

#### Screenshot 23 — MySQL Volume Configuration

Add a terminal screenshot showing the `db_data` named volume and its MySQL mount configuration.

![Screenshot 23 — MySQL Volume Configuration](screenshots/assignment-07-screenshot-23.png)

---

#### Screenshot 24 — Test Data Before Backup

Add a terminal screenshot showing the selected test data before the backup and restore drill.

![Screenshot 24 — Test Data Before Backup](screenshots/assignment-07-screenshot-24.png)

---

#### Screenshot 25 — Successful Backup Creation

Add a terminal screenshot showing successful backup creation and the backup file stored in the host backup directory.

![Screenshot 25 — Successful Backup Creation](screenshots/assignment-07-screenshot-25.png)

---

#### Screenshot 26 — Controlled Data-Loss Test

Add a terminal screenshot showing that the selected test record was removed during the controlled data-loss test.

![Screenshot 26 — Controlled Data-Loss Test](screenshots/assignment-07-screenshot-26.png)

---

#### Screenshot 27 — Restore Verification

Add a terminal screenshot showing successful restore and verification that the deleted test record is available again.

![Screenshot 27 — Restore Verification](screenshots/assignment-07-screenshot-27.png)

---

#### Screenshot 28 — Persistence After Down/Up Cycle

Add a terminal screenshot showing that database data remains available after a non-destructive Docker Compose down/up cycle.

Do not use `docker compose down -v`.

![Screenshot 28 — Persistence After Down/Up Cycle](screenshots/assignment-07-screenshot-28.png)

---

#### Screenshot 29 — Persistence and Backup Document

Add a screenshot showing the contents of:

```text
docs/05-persistence-and-backup.md
```

Include the backup plan and restore procedure.

![Screenshot 29 — Persistence and Backup Document](screenshots/assignment-07-screenshot-29a.png)

![Screenshot 29 — Persistence and Backup Document](screenshots/assignment-07-screenshot-29b.png)

---

# Task 6 — Configure Logging and Observability

## Goal

Configure useful reverse-proxy and backend logs without exposing sensitive information.

### Evidence

#### Screenshot 30 — Logging Configuration

Add a screenshot showing:

- Configuration for the selected reverse proxy
- Proxy log format
- Docker Compose host log-directory bind mount

![Screenshot 30 — Logging Configuration](screenshots/assignment-07-screenshot-30.png)

---

#### Screenshot 31 — Persistent Proxy Logs and Backend Logs

Add a terminal screenshot showing:

- Selected reverse-proxy logs available from the host directory after a proxy restart
- Backend logs displayed through Docker Compose

![Screenshot 31 — Persistent Proxy Logs and Backend Logs](screenshots/assignment-07-screenshot-31.png)

---

### Notes

Write a short note covering:

- The selected reverse proxy
- Host path used for reverse-proxy logs
- How backend logs are viewed
- Whether JSON or standard text logs were used
- Why passwords, tokens, headers, and database connection strings must not appear in logs

- **Reverse proxy:** Nginx (`nginx:alpine`) is the only public entry point, on port 80.
- **Proxy log host path:** `./logs/proxy` on the VM (`/home/ubuntu/theepicbook/logs/proxy`), bind-mounted to `/var/log/nginx`. Files: `epicbook_access.log` and `epicbook_error.log`. The logs survived a proxy restart.
- **Backend logs:** written to stdout and viewed with `docker compose logs backend`. Docker's `json-file` driver is capped at 10 MB × 3 files per service so logs can't fill the disk.
- **Format:** JSON for both. The proxy logs time, client, method, URI (path only), status, bytes, request time, upstream and user agent. The backend logs one JSON line per request with method, path, status and duration. Health probes are skipped, and Sequelize SQL query logging was turned off because it was printing `SELECT 1+1` on every health check.
- **No secrets in logs:** passwords, tokens, cookies, Authorization headers and database connection strings (`JAWSDB_URL` contains the DB password) must never be logged. Logs are read by more people and tools than the app itself, are copied to other systems, and are kept for a long time, so a leaked secret in a log is a leaked secret everywhere. That's why the proxy logs `$uri` (no query string), and the backend logs `req.path` and never headers, bodies or environment values.
---

# Task 7 — Deploy and Verify the Stack on a Cloud VM

## Goal

Deploy the completed Docker Compose stack on an AWS or Azure VM and verify public access.

### Evidence

#### Screenshot 32 — VM Public IP and Inbound Rules

Add a cloud-console screenshot showing:

- VM public IP address
- SSH port 22 restricted to your IP address
- HTTP port 80 allowed from Anywhere

![Screenshot 32 — VM Public IP and Inbound Rules](screenshots/assignment-07-screenshot-32a.png)

![Screenshot 32 — VM Public IP and Inbound Rules](screenshots/assignment-07-screenshot-32b.png)

---

#### Screenshot 33 — Cloud VM Stack Verification

Add a VM terminal screenshot showing:

- Docker Compose service status
- Successful public health or API response
- No published database, frontend, or backend ports

![Screenshot 33 — Cloud VM Stack Verification](screenshots/assignment-07-screenshot-33.png)

---

#### Screenshot 34 — EpicBook Application on Cloud VM

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![Screenshot 34 — EpicBook Application on Cloud VM](screenshots/assignment-07-screenshot-34.png)

---

### Notes

Write a short note covering:

- Cloud provider used
- VM operating system
- Public port exposed
- Security rules configured
- Confirmation that the application and backend API worked through the reverse proxy

- **Cloud provider:** AWS EC2, region eu-west-1 (Ireland), instance type `t3.small`, public IP `54.195.77.105`.
- **VM operating system:** Ubuntu 24.04.4 LTS with Docker Engine and Docker Compose v2.
- **Public port exposed:** only **80/tcp**, published by the Nginx reverse proxy. The frontend (80), backend (8080) and MySQL (3306) are not published to the host. They are reachable only on the internal Docker networks, and `back-tier` is `internal: true`.
- **Security rules:** the security group allows SSH 22 only from my IP (`/32`) and HTTP 80 from `0.0.0.0/0`. Ports 3000/3001 belong to a separate Assignment 6 application running on the same VM and will be removed once it is graded. EpicBook itself exposes only port 80.
- **Verification:** `docker compose ps` shows all four services healthy. `curl http://54.195.77.105/health` returned `{"status":"ok","database":"connected"}`, `/api/cart` returned JSON, and the EpicBook UI loaded in the browser through the public IP, all via the reverse proxy.
---

# Task 8 — Automate Deployment with CI/CD (Optional)

## Goal

Optionally automate image build, image push, and deployment through GitHub Actions or Azure Pipelines.

### Optional Evidence

#### Optional Screenshot — Successful CI/CD Pipeline Run

Add a screenshot showing a successful pipeline run with build, image push, deployment, and verification stages.

Optional task not attempted.
---

### Optional Notes

Write a short note covering:

- CI/CD platform used
- Image-tagging method
- Registry used
- Deployment trigger
- Manual approval or secret-handling approach

Optional task not attempted.
---

# Task 9 — Perform Reliability Tests and Create an Operations Runbook

## Goal

Test controlled service failures and document safe operating procedures.

### Evidence

#### Screenshot 35 — Backend Failure and Recovery

Add a terminal screenshot showing:

- Backend failure test
- Expected unavailable response through the reverse proxy
- Backend restart
- Successful health-check recovery

![Screenshot 35 — Backend Failure and Recovery](screenshots/assignment-07-screenshot-35.png)

---

#### Screenshot 36 — Database Failure and Recovery

Add a terminal screenshot showing:

- Database outage test
- Failed database-dependent request
- Database restart
- Successful application recovery

![Screenshot 36 — Database Failure and Recovery](screenshots/assignment-07-screenshot-36.png)

---

### Notes

Write a short operations runbook covering:

- Safe restart procedure for reverse proxy, frontend, backend, and database
- Backup and restore procedure
- Secret-rotation approach
- Database recovery procedure
- What to check when the application returns an error
- Results of backend and database reliability tests

**Safe restarts (always from `~/theepicbook`, never `down -v`):**

- **Proxy:** `docker compose restart reverse-proxy` (logs are kept in `./logs/proxy`).
- **Frontend:** `docker compose restart frontend`.
- **Backend:** `docker compose up -d --wait backend` (the proxy returns 502 until it is healthy).
- **Database:** `docker compose stop database`, then `docker compose up -d --wait` (data stays in `db_data`).
- After any restart, check `docker compose ps` and that `/health` returns 200.

**Backup and restore:**

- Back up with `mysqldump --single-transaction` inside the database container to `./backups/` (git-ignored). Accept the dump only if its last line says `-- Dump completed`.
- Restore by piping the dump into `mysql` with `docker compose exec -T`.
- Verify row counts and `/health`. Daily cron, 7 daily + 4 weekly retention, an off-site S3 copy and a monthly test restore are planned (`docs/05`).

**Secret rotation:**

- Generate a new value with `openssl rand -hex 16` and run `ALTER USER` in MySQL first.
- Then update `.env` (git-ignored), recreate the backend with `docker compose up -d --wait backend`, and verify `/health`.
- `MYSQL_*` variables only apply on the first boot, so editing `.env` alone does not change a live password.

**Database recovery:**

- Check `docker compose ps`, `docker compose logs database` and `df -h` (a full disk stops MySQL).
- Restart with `docker compose up -d --wait database`.
- If the data is damaged, restore the latest verified dump, then verify counts and `/health`.

**When the app returns an error:**

- **Connection refused:** check the VM, the security group or the proxy.
- **502:** the backend is down or crashed (`docker compose logs backend`).
- **503 from `/health`:** the database is unreachable.
- **Page without styling:** frontend or `/assets` problem.
- **404:** check `uri` and `status` in `logs/proxy/epicbook_access.log`.

**Reliability test results (2026-10-08):**

- **Backend stopped:** the proxy returned **HTTP 502**. `docker compose up -d --wait backend` brought it back healthy in about 6 s, and `/health` returned 200.
- **Database stopped:** `/health` returned **HTTP 503** `{"database":"unreachable"}` and `/api/cart` returned **502**. After `docker compose up -d --wait`, all services were healthy in about 7 s, `/health` returned 200 and all **54 books** were intact.
- **Finding:** the original cart route does not handle DB errors, so the backend process restarted (`restart: unless-stopped` recovered it). An improvement would be to return 503 there instead.
---

# Final Public Application URL

**EpicBook URL:** `http://54.195.77.105/`

---

# GitHub Repository URL

**Your Fork or Repository URL:** `https://github.com/chrispok18/theepicbook/tree/capstone-production`

---

# LinkedIn Requirement

## Goal

Create a professional LinkedIn post of 6–10 lines about your EpicBook capstone deployment.

Your post must include:

- The architectural decision that most improved reliability
- Your biggest image-size reduction, with numbers
- Key production-hardening lessons
- A deployment verification image

### Evidence

**LinkedIn Post URL:** `https://www.linkedin.com/posts/caryee_epicbook-from-monolith-to-production-grade-ugcPost-7514088509901611009-s_SO/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACP6ElcBF7-kOglrea_3V5oUhVp4NSh-Trc`

#### LinkedIn Post Screenshot

Add a screenshot of the published LinkedIn post showing the text body and deployment verification image.

![LinkedIn Post Screenshot](screenshots/assignment-07-screenshot-37.png)

---

# Submission Checklist

- [x] EpicBook repository reviewed and architecture diagram created
- [x] Environment variables, ports, persistence, and health-check details documented
- [x] Backend and frontend production Dockerfiles created
- [x] Backend runs as a non-root user
- [x] Docker image-size comparison completed
- [x] Docker Compose stack includes reverse proxy, frontend, backend, and database
- [x] `front-tier` and `back-tier` networks configured
- [x] `db_data` named volume configured
- [x] MySQL, backend, frontend, and reverse-proxy health checks configured
- [x] Startup dependencies use `service_healthy`
- [x] Nginx or Traefik selected as the only public reverse proxy
- [x] Only reverse-proxy port 80 is publicly published
- [x] Same-origin routing configured and CORS used only when required
- [x] Backup, restore, and persistence testing completed
- [x] Reverse-proxy and backend logs verified
- [x] Cloud VM deployment verified through the public IP
- [x] Backend and database reliability tests completed
- [x] Screenshots 1–36 included
- [x] Required notes completed
- [x] LinkedIn post URL and screenshot included
- [x] Full name visible in required screenshots or captions
- [x] No passwords, tokens, private keys, account IDs, or other sensitive information exposed

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

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
