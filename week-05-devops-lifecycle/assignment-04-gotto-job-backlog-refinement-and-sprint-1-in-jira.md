# Assignment 4 — Gotto Job: Backlog Refinement & Sprint 1 in Jira

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purposea

In this 90-minute, time-boxed exercise, you will act as a Scrum team — or run in Solo Mode, playing every role yourself — to turn the Gotto Job template into a value-ordered backlog, estimate the work in story points, plan Sprint 1, open the burndown chart, and ship one small UI-only increment (text, color, spacing, a label, or a CTA — no backend changes).

---

# Task 1 — Roles & Mode Setup (Team vs Solo)

## Goal

Choose Team Mode or Solo Mode, and document how each Scrum role (Product Owner, Scrum Master, Dev Lead, DevOps Lead) was handled.

### Evidence

#### Screenshot 1 — Jira "Create project" screen, or the project sidebar after creation

![Screenshot 1 — Jira "Create project" screen, or the project sidebar after creation](screenshots/assignment-04-screenshot-01.png)

---

### Notes

Write one line for each role: PO (what you prioritized), SM (how you ensured process), Dev Lead (what you built), DevOps Lead (how you shipped).

PO (Product Owner): I prioritized the UI stories that would most improve trust and clarity for job seekers — hero clarity, CTA visibility, and remote badges — over lower-impact cosmetic tweaks.
SM (Scrum Master): I kept the work time-boxed to 90 minutes, made sure each story had clear acceptance criteria before estimating, and tracked progress on the board to avoid scope creep.
Dev Lead: I implemented one small, UI-only change (text/color/CTA) directly in the Gotto Job source code, keeping the diff minimal and backend-free.
DevOps Lead: I committed the change with a clear message, deployed it to a live host, and verified it rendered correctly in the browser before marking the story Done.

---

# Task 2 — Create the Jira Project (Team-managed → Scrum)

## Goal

Create a Team-managed Scrum project named `Gotto Job – Team <#>` (Team Mode) or `Gotto Job – <YourName>` (Solo Mode).

### Evidence

#### Screenshot 2 — Project created page showing the project name and key

![Screenshot 2 — Project created page showing the project name and key](screenshots/assignment-04-screenshot-02.png)

---

# Task 3 — Create the Epic

## Goal

Create the Epic `Improve Gotto Job UI discoverability & trust` to group the UI improvement initiative.

### Evidence

#### Screenshot 3 — Backlog showing the Epic panel with the Epic visible

![Screenshot 3 — Backlog showing the Epic panel with the Epic visible](screenshots/assignment-04-screenshot-03.png)

---

# Task 4 — Seed the Product Backlog (6–8 Stories + Fibonacci Points + Ranking)

## Goal

Create at least six Stories under the Epic, estimate each with 1, 2, or 3 story points, and rank them by value.

### Evidence

#### Screenshot 4 — Backlog showing the Epic and at least six Stories under it

![Screenshot 4 — Backlog showing the Epic and at least six Stories under it](screenshots/assignment-04-screenshot-04.png)

---

#### Screenshot 5 — One Story opened showing its Story Points and acceptance criteria filled in

![Screenshot 5 — One Story opened showing its Story Points and acceptance criteria filled in](screenshots/assignment-04-screenshot-05.png)

---

# Task 5 — Planning Poker (Estimate + Debate Notes)

## Goal

Confirm the Story Points (1, 2, or 3) for each Story and record brief reasoning for each estimate.

### Evidence

#### Screenshot 6 — Backlog showing Story Points visible, or two or three Stories opened showing their points

![Screenshot 6 — Backlog showing Story Points visible, or two or three Stories opened showing their points](screenshots/assignment-04-screenshot-06.png)

---

### Notes

For each story, explain in one or two lines why it is a 1, 2, or 3 (mention any debate, even in Solo Mode).

Hero tagline clarity (1): Simple static text change with no logic — low effort, quick to verify.
Job detail Apply Now CTA (1): A single button add with a static link — minimal complexity, no debate.
Primary CTA color (1): One color/style change applied site-wide — low effort but touches multiple elements, so I considered a 2 before settling on 1 since it's still just CSS.
Remote badge (UI-only) (2): Requires conditional logic to only show on REMOTE-flagged cards, plus new styling for the pill — more than a plain text/color tweak.
Advanced search labels (2): Multiple form fields need label/placeholder updates and alignment checks — more surface area than a single-element change.
Job card typography (2): Affects a shared component (job card) across the whole listing page, so it needed a bit more care to verify it didn't break layout — bumped from 1 to 2 after reflection.

---

# Task 6 — Sprint Planning: Create Sprint 1 + Sprint Goal + Scope

## Goal

Create Sprint 1, move three or four Stories into it (approximately 3–6 points), set the Sprint Goal, and break each selected Story into Build, Verify, Deploy, and Screenshot Sub-tasks.

### Evidence

#### Screenshot 7 — Sprint 1 with the selected Stories inside it

![Screenshot 7 — Sprint 1 with the selected Stories inside it](screenshots/assignment-04-screenshot-07.png)

---

#### Screenshot 8 — One Story showing the Sub-tasks created

![Screenshot 8 — One Story showing the Sub-tasks created](screenshots/assignment-04-screenshot-08.png)

---

# Task 7 — Reports: Open Burndown Chart

## Goal

Open the Burndown Chart and confirm it exists for Sprint 1. It is acceptable if the chart is not yet populated.

### Evidence

#### Screenshot 9 — Burndown Chart page opened, even if empty

![Screenshot 9 — Burndown Chart page opened, even if empty](screenshots/assignment-04-screenshot-09.png)
---

# Task 8 — Ship One Small Increment (Build + Deploy + Proof)

## Goal

Implement one small UI-only Story from Sprint 1, commit it, deploy it live, and move the Story and its Sub-tasks to Done in Jira.

### Evidence

#### Screenshot 10 — Jira board showing the Story moved to Done

![Screenshot 10 — Jira board showing the Story moved to Done](screenshots/assignment-04-screenshot-10.png)

---

#### Screenshot 11 — Git commit output

![Screenshot 11 — Git commit output](screenshots/assignment-04-screenshot-11.png)

---

#### Screenshot 12 — Live URL in the browser showing the UI change, with the URL visible

![Screenshot 12 — Live URL in the browser showing the UI change, with the URL visible](screenshots/assignment-04-screenshot-12.png)

---

# Task 9 — Retro Notes (Scrum Pillar + Value)

## Goal

Add a retro comment covering what went well, what to improve, one Scrum pillar observed (Transparency, Inspection, or Adaptation), and one Scrum value (Openness, Focus, Commitment, Courage, or Respect).

### Evidence

#### Screenshot 13 — Jira retro comment visible

![Screenshot 13 — Jira retro comment visible](screenshots/assignment-04-screenshot-13.png)

---

# Task 10 — LinkedIn Post (Mandatory)

## Goal

Publish a LinkedIn post about what you delivered, including your live URL, three to five lines on what you did and learned, and one screenshot (Burndown Chart, Sprint board, or the live UI change).

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/caryee_dmibypravinmishra-devops-scrum-share-7492008967800541184-c_Ln/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACP6ElcBF7-kOglrea_3V5oUhVp4NSh-Trc`

---

#### Screenshot 14 — Published LinkedIn post

![Screenshot 14 — Published LinkedIn post](screenshots/assignment-04-screenshot-14.png)

---

# Submission Instructions

- Add all 14 required screenshots
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [x] Task 1: Team Mode or Solo Mode selected and all four roles documented (Screenshot 1 & Notes)
- [x] Task 2: Team-managed Scrum project created with the required name (Screenshot 2)
- [x] Task 3: UI improvement Epic created (Screenshot 3)
- [x] Task 4: 6–8 Stories added under the Epic and ranked by value (Screenshots 4 & 5)
- [x] Task 5: Story Points set (1, 2, or 3) with reasoning recorded (Screenshot 6 & Notes)
- [x] Task 6: Sprint 1 created with Sprint Goal, 3–4 Stories, and Sub-tasks (Screenshots 7 & 8)
- [x] Task 7: Burndown Chart opened (Screenshot 9)
- [x] Task 8: One UI-only increment implemented, committed, deployed, and verified (Screenshots 10–12)
- [x] Task 9: Retro comment with one Scrum pillar and one Scrum value (Screenshot 13)
- [x] Task 10: Mandatory LinkedIn post published with the live URL, backlog refinement, Sprint planning, one shipped increment, proof, and Screenshot 14
- [x] Full Name visible in required screenshots
- [x] No sensitive data exposed

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
