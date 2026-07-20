# Assignment 5 — Bash Script Automation Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will practice Bash scripting by building a series of small automation scripts covering environment setup, variables, arrays, loops, file conditionals, if-else logic, and functions. These scripts form the foundation of real-world Linux automation used in DevOps, cloud, and production support environments.

---

# Task 1 — Bash Environment & Workspace Setup

## Goal

Verify that Bash is available on your system and create a clean workspace for this assignment.

### Evidence

#### Screenshot 1 — Output of `echo $SHELL` and `bash --version`

![Output of `echo $SHELL` and `bash --version`](screenshots/assignment-05-screenshot-01.png)

---

#### Screenshot 2 — Output of `pwd` and `ls -lah` showing the scripts directory

![Output of `pwd` and `ls -lah` showing the scripts directory](screenshots/assignment-05-screenshot-02.png)

---

### Notes

Answer the following in your own words:

**1. What is Bash?**

Bash is basically the program that lets me type commands into the terminal and actually get things done .IT helps me create folders, run scripts, check files, life giving time specific instructions . This is the language of computers and servers
---

**2. What is the difference between shell and Bash?**

Shell is the general term for any program that lets you talk to your computer through commands Its like a platform or medium that lets you communicate with a system. Bash is just one specific shell, probably the most popular one on Linux and Mac systems. So Bash is a shell, but not every shell is Bash .
---

**3. Why is it important to confirm the Bash version before writing scripts?**

Different versions of Bash support different features , some newer things like certain array tricks or string handling simply don't exist in older versions. Checking the version first saves me from writing a script that works perfectly on my machine but breaks on someone else's because their Bash is older. It's a quick sanity check before building anything.
---

# Task 2 — Your First Bash Script

## Goal

Create your first Bash script, make it executable, and run it from the terminal.

### Evidence

#### Screenshot 1 — Content of `first-script.sh`

![Screenshot 1 — Content of `first-script.sh`](screenshots/assignment-05-screenshot-03.png)

---

#### Screenshot 2 — Output of `./first-script.sh`

![Screenshot 2 — Output of `./first-script.sh`](screenshots/assignment-05-screenshot-04.png)

---

#### Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission

![Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission](screenshots/assignment-05-screenshot-05.png)

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `#!/bin/bash`?**

It tells the system exactly which program should run this file — in this case, Bash. Without it, the computer wouldn't know whether to treat the file as a Bash script, a Python script, or just plain text.
---

**2. Why do we use `chmod +x` before running a script?**

By default, a new file isn't allowed to be "executed" as a program — it's just treated as text. chmod +x adds execute permission, which is what lets you run it directly with ./first-script.sh instead of just being able to view it.
---

**3. What is the difference between running a script using `./script.sh` and `bash script.sh`?**

./script.sh runs the file directly, which only works if it has execute permission and the shebang line is correct. bash script.sh tells Bash to run the file explicitly, regardless of whether it has execute permission — it bypasses the need for chmod +x entirely, since you're manually specifying the interpreter.
---

# Task 3 — Variables: User Information Script

## Goal

Use variables to store and display user-related information.

### Evidence

#### Screenshot 1 — Content of `user-info.sh`

![Screenshot 1 — Content of `user-info.sh`](screenshots/assignment-05-screenshot-06.png)

---

#### Screenshot 2 — Output of `./user-info.sh`

![Screenshot 2 — Output of `./user-info.sh`](screenshots/assignment-05-screenshot-07.png)

---

### Notes

Answer the following in your own words:

**1. What is a variable in Bash?**

A variable is just a named container that holds a value — text, a number, whatever — so you can reuse it instead of typing the same thing over and over. In this script, full_name holds "Christian Aryee," and every time I reference $full_name, Bash swaps in that value.
---

**2. Why should we avoid spaces around the `=` sign when creating variables?**

Bash is strict about this — full_name="Christian Aryee" works, but full_name = "Christian Aryee" breaks, because Bash interprets the space as meaning something different (it thinks you're trying to run a command called full_name with arguments). No spaces around = is just required syntax, not a style preference.
---

**3. How do you access the value stored inside a Bash variable?**

By putting a $ in front of the variable name — like $full_name. That tells Bash "give me the value stored here," rather than treating it as plain text.
---

# Task 4 — Arrays & Loops: Tools Checklist Script

## Goal

Use arrays and loops to print a checklist of tools used in Bash scripting.

### Evidence

#### Screenshot 1 — Content of `tools-checklist.sh`

![Screenshot 1 — Content of `tools-checklist.sh`](screenshots/assignment-05-screenshot-08.png)

---

#### Screenshot 2 — Output of `./tools-checklist.sh`

![Screenshot 2 — Output of `./tools-checklist.sh`](screenshots/assignment-05-screenshot-09.png)

---

### Notes

Answer the following in your own words:

**1. What is an array in Bash?**

An array is a way to store multiple values under a single variable name, instead of creating six separate variables for six separate tools. It's basically a list.
---

**2. Why are arrays useful in scripts?**

They keep related data organized together, and they let you loop through everything at once instead of writing a separate line for each item. If I wanted to add a seventh tool, I'd just add it to the array — I wouldn't have to write a whole new echo line.
---

**3. What does `"${tools[@]}"` mean?**

It means "every item in the tools array." The @ expands to all elements, and wrapping it in quotes makes sure each item is treated as a separate value, even if a tool name had spaces in it (not the case here, but it's the safe habit).
---

**4. What is the purpose of the `for` loop in this script?**

It lets the script go through the array one item at a time and run the same echo command for each one, instead of me writing six nearly-identical lines by hand. It's the loop that turns a list into repeated action.
---

# Task 5 — Loops: Number Counter Script

## Goal

Use loops to repeat a task multiple times.

### Evidence

#### Screenshot 1 — Content of `counter.sh`

![Screenshot 1 — Content of `counter.sh`](screenshots/assignment-05-screenshot-10.png)

---

#### Screenshot 2 — Output of `./counter.sh`

![Screenshot 2 — Output of `./counter.sh`](screenshots/assignment-05-screenshot-11.png)

---

### Notes

Answer the following in your own words:

**1. What is a loop?**

A loop is a way to repeat the same block of code multiple times without writing it out over and over. Instead of five separate echo lines, one loop handles all five steps.

---

**2. Why do we use loops in Bash scripting?**

They save time and reduce mistakes — if I need to do something repetitive (check five servers, print ten lines, process a hundred files), a loop does it in a few lines instead of a hundred. It also makes scripts easier to update, since changing the loop changes every repetition at once.
---

**3. How many times did the loop run in your script?**

Five times — once for each number in the list 1 2 3 4 5.

---

**4. What would you change if you wanted the loop to run 10 times?**

I'd change the list to for number in 1 2 3 4 5 6 7 8 9 10. There's also a shorter way to write that using a range, like for number in {1..10}, which does the same thing without typing every number out.
---

# Task 6 — Files & Conditionals: File Validation Script

## Goal

Use file checks and conditionals to verify whether files and directories exist.

### Evidence

#### Screenshot 1 — Output of `ls -lah ../test-folder`

![Screenshot 1 — Output of `ls -lah ../test-folder`](screenshots/assignment-05-screenshot-12.png)

---

#### Screenshot 2 — Content of `file-check.sh`

![Screenshot 2 — Content of `file-check.sh`](screenshots/assignment-05-screenshot-13.png)

---

#### Screenshot 3 — Output of `./file-check.sh`

![Screenshot 3 — Output of `./file-check.sh`](screenshots/assignment-05-screenshot-14.png)

---

### Notes

Answer the following in your own words:

**1. What does `-d` check in Bash?**

It checks whether a given path exists and is a directory. If the path doesn't exist, or exists but is a file rather than a folder, -d returns false.
---

**2. What does `-f` check in Bash?**

It checks whether a given path exists and is a regular file (not a directory, not a special file type). Same idea as -d, just for files instead of folders.
---

**3. Why should file and directory paths be stored in variables?**

If the path is hardcoded into every line of the script, changing it later means hunting down every occurrence. Storing it once in a variable means I only update it in one place, and it also makes the script easier to read — $file_path is clearer than repeating the raw path everywhere.
---

**4. What happens if the file does not exist?**

The -f check returns false, so the script runs the else block instead and prints "File does not exist" — rather than crashing or throwing an error. This is exactly why conditionals matter in automation: the script can respond gracefully to a missing file instead of breaking.
---

# Task 7 — Conditionals: Pass or Retry Script

## Goal

Use if-else conditionals to make decisions based on a variable value.

### Evidence

#### Screenshot 1 — Content of `score-check.sh` with `score=85`

![Screenshot 1 — Content of `score-check.sh` with `score=85`](screenshots/assignment-05-screenshot-15.png)

---

#### Screenshot 2 — Output showing `Result: Pass`

![Screenshot 2 — Output showing `Result: Pass`](screenshots/assignment-05-screenshot-16.png)

---

#### Screenshot 3 — Content of `score-check.sh` with `score=55`

![Screenshot 3 — Content of `score-check.sh` with `score=55`](screenshots/assignment-05-screenshot-17.png)

---

#### Screenshot 4 — Output showing `Result: Retry`

![Screenshot 4 — Output showing `Result: Retry`](screenshots/assignment-05-screenshot-18.png)

---

### Notes

Answer the following in your own words:

**1. What is the purpose of if-else in Bash?**

It lets the script make a decision and take a different action depending on whether a condition is true or false — instead of always doing the same thing regardless of the situation.
---

**2. What does `-ge` mean?**

"Greater than or equal to" — a numeric comparison. "$score" -ge 70 checks whether the score is 70 or higher.
---

**3. Why should conditions be tested with different values?**

Testing only one value (like 85) proves the "Pass" branch works, but it doesn't prove the "Retry" branch works too  or that the boundary (exactly 70) behaves correctly. Testing both a passing and failing value confirms the whole logic actually branches the way it's supposed to, not just the happy path.
---

**4. How can conditionals help in automation scripts?**

They let scripts respond intelligently to different situations instead of blindly running the same steps every time — like checking if a service is running before restarting it, or checking disk space before starting a backup. Without conditionals, automation would be rigid and prone to failing in situations the script didn't anticipate.
---

# Task 8 — Functions: Final Bash Automation Script

## Goal

Create a final Bash script using functions to organize reusable code.

### Evidence

#### Screenshot 1 — Content of `final-automation.sh`

![Screenshot 1 — Content of `final-automation.sh`](screenshots/assignment-05-screenshot-19.png)

---

#### Screenshot 2 — Output of `./final-automation.sh`

![Screenshot 2 — Output of `./final-automation.sh`](screenshots/assignment-05-screenshot-20.png)

---

#### Screenshot 3 — Output of `ls -lah` showing all created scripts

![Screenshot 3 — Output of `ls -lah` showing all created scripts](screenshots/assignment-05-screenshot-21.png)

---

### Notes

Answer the following in your own words:

**1. What is a function in Bash?**

A function is a named block of code you define once and can call by name whenever you need it — like giving a group of commands a label so you don't have to retype them.
---

**2. Why are functions useful in scripts?**

They keep scripts organized and readable — instead of one long wall of commands, related logic gets grouped into clearly labeled sections. They also make it easy to reuse the same logic multiple times, or to test one piece (like check_files) independently of the rest.
---

**3. Which functions did you create in this script?**

Four: print_header (prints the title banner), print_user_details (shows name and assignment), check_files (validates the test folder and file exist), and print_tools (loops through the tools array and prints each one).
---

**4. How does this final script combine variables, arrays, loops, conditionals, files, and functions?**

Variables store the name, assignment title, and file paths. The array holds the list of tools. Loops (inside print_tools) go through that array item by item. Conditionals (inside check_files) test whether the folder and file actually exist using -d and -f. Files are the actual folder/file being checked. And functions wrap all of that logic into labeled, callable pieces that get executed in a clear order at the bottom of the script — turning everything from Tasks 3 through 7 into one organized program instead of scattered separate scripts.
---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/caryee_devops-bash-linux-ugcPost-7483979685576687619-9vCs/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACP6ElcBF7-kOglrea_3V5oUhVp4NSh-Trc`

---

#### Screenshot — Published LinkedIn post

![Screenshot — Published LinkedIn pos](screenshots/assignment-05-screenshot-22.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- All script files must be created and run successfully
- Required notes must be answered clearly for every task
- Do not expose sensitive information (keys, passwords, credentials)

---

# Completion Checklist

- [x] Task 1: Environment setup verified, workspace created (Screenshots 1–2, Notes answered)
- [x] Task 2: First script created, executed, permissions verified (Screenshots 1–3, Notes answered)
- [x] Task 3: Variables script created and run (Screenshots 1–2, Notes answered)
- [x] Task 4: Arrays and loops script created and run (Screenshots 1–2, Notes answered)
- [x] Task 5: Counter loop script created and run (Screenshots 1–2, Notes answered)
- [x] Task 6: File validation script created and run (Screenshots 1–3, Notes answered)
- [x] Task 7: Pass/Retry conditional script tested with both values (Screenshots 1–4, Notes answered)
- [x] Task 8: Final automation script created and run (Screenshots 1–3, Notes answered)
- [x] All scripts run without errors
- [x] Full Name visible in all required screenshots
- [x] LinkedIn post published and URL submitted
- [x] No sensitive data exposed

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
