# Assignment 6 — Deploy the Book Review App with Docker Compose

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the Book Review Application with Docker Compose using MySQL, a backend API, and a frontend user interface. You will configure health-gated startup, browser-facing API access, CORS, and persistent MySQL storage.

---

# Task 1 — Prepare the Project

## Goal

Prepare your fork of the Book Review App repository for Docker Compose deployment.

### Evidence

#### Screenshot 1 — Project Structure

Add a screenshot showing the project structure containing:

```text
frontend/
backend/
.env.example
.gitignore
docker-compose.yml
```

![Screenshot 1 — Project Structure](screenshots/assignment-06-screenshot-01.png)

---

#### Screenshot 2 — Environment and Docker Ignore Files

Add a screenshot showing the contents of:

```text
.env.example
.gitignore
frontend/.dockerignore
backend/.dockerignore
```

Ensure that no real passwords, tokens, or secrets are visible.

![Screenshot 2 — Environment and Docker Ignore Files](screenshots/assignment-06-screenshot-02.png)

---

# Task 2 — Create or Confirm Application Dockerfiles

## Goal

Prepare Dockerfiles for the frontend and backend services and build both services through Docker Compose.

### Evidence

#### Screenshot 3 — Frontend Dockerfile

Add a screenshot showing the completed `frontend/Dockerfile`.

![Screenshot 3 — Frontend Dockerfile](screenshots/assignment-06-screenshot-03.png)

---

#### Screenshot 4 — Backend Dockerfile

Add a screenshot showing the completed `backend/Dockerfile`.

![Screenshot 4 — Backend Dockerfile](screenshots/assignment-06-screenshot-04.png)

---

#### Screenshot 5 — Docker Compose Build

Add a screenshot of the terminal showing successful completion of:

```bash
docker compose build
```

![Screenshot 5 — Docker Compose Build](screenshots/assignment-06-screenshot-05.png)

---

# Task 3 — Create the Docker Compose Stack

## Goal

Create one `docker-compose.yml` file that builds and runs MySQL, backend, and frontend services.

### Evidence

#### Screenshot 6 — MySQL Service, Health Check, and Volume Mount

Add a screenshot showing the MySQL service in `docker-compose.yml`, including:

- MySQL image
- Environment variables
- MySQL health check
- `mysql_data` volume mount
- No published MySQL port

![Screenshot 6 — MySQL Service, Health Check, and Volume Mount](screenshots/assignment-06-screenshot-06.png)

---

#### Screenshot 7 — Backend Configuration

Add a screenshot showing the backend service configuration, including:

- `depends_on` with `condition: service_healthy`
- Database host set to `mysql`
- Browser frontend origin configured for CORS
- Published backend port

![Screenshot 7 — Backend Configuration](screenshots/assignment-06-screenshot-07.png)

---

#### Screenshot 8 — Frontend Configuration

Add a screenshot showing the frontend service configuration, including:

- Published frontend port
- `depends_on` for the backend service
- Browser-facing `NEXT_PUBLIC_API_URL`

![Screenshot 8 — Frontend Configuration](screenshots/assignment-06-screenshot-08.png)

---

#### Screenshot 9 — Named Volume Definition

Add a screenshot showing the `mysql_data` volume definition in `docker-compose.yml`.

![Screenshot 9 — Named Volume Definition](screenshots/assignment-06-screenshot-09.png)

---

# Task 4 — Start and Verify the Stack

## Goal

Build and start all services through one Docker Compose workflow.

### Evidence

#### Screenshot 10 — Docker Compose Service Status

Add a screenshot of the terminal showing:

```bash
docker compose ps
```

The output must show the MySQL, backend, and frontend services running. MySQL must show as healthy.

![Screenshot 10 — Docker Compose Service Status](screenshots/assignment-06-screenshot-10.png)

---

#### Screenshot 11 — MySQL and Backend Logs

Add a screenshot of the terminal showing:

```bash
docker compose logs mysql backend --tail=50
```

The logs must show MySQL readiness and successful backend database connection.

![Screenshot 11 — MySQL and Backend Logs](screenshots/assignment-06-screenshot-11.png)

---

# Task 5 — Test End-to-End Application Functionality

## Goal

Verify that the Book Review App works through the browser.

### Evidence

#### Screenshot 12 — Successful Registration or Login

Add a browser screenshot showing successful user registration or login.


![Screenshot 12 — Successful Registration or Login](screenshots/assignment-06-screenshot-12.png)

*Christian Aryee*

---

#### Screenshot 13 — Created Book Review

Add a browser screenshot showing a created book review visible in the application.


![Screenshot 13 — Created Book Review](screenshots/assignment-06-screenshot-13.png)

*Christian Aryee*

---

#### Screenshot 14 — CORS Verification

Add a browser developer-tools screenshot with:

- The Network tab showing a successful API request
- The Console drawer showing no CORS error after the API interaction

![Screenshot 14 — CORS Verification](screenshots/assignment-06-screenshot-14.png)

---

# Task 6 — Prove MySQL Data Persistence

## Goal

Verify that MySQL data remains after a non-destructive Docker Compose down/up cycle.

### Evidence

#### Screenshot 15 — Data Before Restart

Add a browser screenshot showing the registered user or created review before the down/up cycle.


![Screenshot 15 — Data Before Restart](screenshots/assignment-06-screenshot-15.png)

*Christian Aryee*

---

#### Screenshot 16 — Non-Destructive Stack Restart

Add a screenshot of the terminal showing the non-destructive shutdown and restart:

```bash
docker compose down
docker compose up -d
docker compose ps
```

Do not use `docker compose down -v`.

![Screenshot 16 — Non-Destructive Stack Restart](screenshots/assignment-06-screenshot-16.png)

---

#### Screenshot 17 — Data After Restart

Add a browser screenshot showing the same registered user or review after the stack restarts.


![Screenshot 17 — Data After Restart](screenshots/assignment-06-screenshot-17.png)

*Christian Aryee*

---

# Task 7 — Explain Docker Compose Teardown Modes

## Goal

Explain the difference between preserving data and fully resetting a Docker Compose environment.

### Notes

Write a short explanation of 5–8 lines covering:

- What `docker compose down` removes and preserves
- Why named volumes should be kept when preserving MySQL data
- What happens when named volumes are removed
- When a full reset is useful
- Why a full reset must not be used before persistence evidence is captured

docker compose down stops and removes the stack's containers and its default network, but it leaves named volumes like mysql_data untouched. That is the right choice when I want to keep MySQL data, because the database files live in the volume rather than inside the container, so new containers mount the same data on the next up. I proved this by running down then up -d: my registered user and both reviews were still there. docker compose down -v also deletes the named volumes, which permanently wipes every table, user and review stored in MySQL. A full reset like that is useful for starting a development database from scratch, re-running seed data, or fixing a volume created with the wrong credentials (MySQL only reads MYSQL_USER/MYSQL_PASSWORD the first time it initialises a volume). It must never be used before persistence evidence is captured, because it destroys the very data the proof depends on, and that cannot be undone. In short: down is a safe restart, while down -v is a factory reset.

---

# Final Public Frontend URL

**Frontend URL:** `http://54.195.77.105:3000/`

Replace the placeholder with your working application URL.

---

# GitHub Repository URL

**Your Fork or Repository URL:** `https://github.com/chrispok18/book-review-app`

---

# LinkedIn Requirement

## Goal

Create a LinkedIn post about the Book Review App deployment and what you learned from using Docker Compose.

### Evidence

**LinkedIn Post URL:** `https://www.linkedin.com/posts/caryee_deployed-a-full-book-review-app-with-docker-ugcPost-7513592180456845312-YQKx/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACP6ElcBF7-kOglrea_3V5oUhVp4NSh-Trc`

#### LinkedIn Post Screenshot

![LinkedIn Post Screenshot](screenshots/assignment-06-screenshot-18.png)

---

# Submission Checklist

- [X] Book Review App repository forked and used
- [X] `.env` excluded from Git tracking
- [X] `.env.example` contains only safe placeholder values
- [X] Frontend and backend Dockerfiles created or confirmed
- [X] MySQL health check configured
- [X] Backend waits for healthy MySQL
- [X] Backend uses `mysql` as the database hostname
- [X] Frontend API URL uses the VM public IP and backend port
- [X] Backend CORS origin matches the frontend origin
- [X] MySQL port 3306 is not publicly exposed
- [X] Registration and login work
- [X] Book review creation works
- [X] Data persists after a non-destructive down/up cycle
- [X] Screenshots 1–17 included
- [X] Teardown explanation completed
- [X] Public frontend URL included
- [X] GitHub repository URL included
- [X] LinkedIn post URL and screenshot included
- [X] Full name visible in required terminal screenshots
- [X] Browser screenshots include a full-name caption
- [X] No sensitive information exposed

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
