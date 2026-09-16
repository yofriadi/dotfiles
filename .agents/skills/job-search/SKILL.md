---
name: job-search
description: >
  Search for jobs on LinkedIn based on Yofriadi Yahya's Resume.pdf. Extracts keywords, experience
  levels, and preferences from the resume and uses `mcporter` with the `linkedin` server to find
  matching openings and retrieve details. Use when the user says "find me a job", "look for jobs",
  "search jobs", or invokes /job-search.
disable-model-invocation: true
---

Perform targeted LinkedIn job searches matching the user's software engineering, devops/infrastructure, and AI agentic development profile (Go/TypeScript backend & fullstack with DevOps/infra capabilities in AWS/GCP/Kubernetes and Agentic AI/MCP/Pi development) using `mcporter` and the `linkedin` MCP server.

## Profile Reference (from Resume.pdf)

Use this profile context to filter and match job requirements:
- **Candidate:** Yofriadi Yahya
- **Email:** yofriadi.yahya@outlook.com | **Phone:** +62 812 2524 5168
 - **Location:** Jakarta, Indonesia (open to On-site, Hybrid, and Remote roles; actively open to relocation/global roles aligning with skills, especially neighbor countries in the ASEAN or APAC region)
 - **Role Target:** Senior Backend Engineer, Fullstack Engineer, DevOps/Infrastructure Engineer (focusing on small-scale/hands-on cloud/infra), AI Integration Engineer, Agentic AI/MCP Developer, Go Developer, TypeScript/Node.js Developer
- **Experience Level:** Senior (~9 years of experience since 2016)
- **Relocation Preferences:** Open to relocating internationally/globally, with strong openness to neighbor countries in ASEAN (e.g., Singapore, Malaysia, Thailand, Vietnam, Philippines) and the APAC region (e.g., Australia, Japan, South Korea, New Zealand), as well as global tech hubs (e.g., Germany, Netherlands, United Kingdom).
- **Expertise Stack:**
  - *Languages:* Go (Golang), JavaScript, TypeScript, Lua
  - *Databases/Messaging:* PostgreSQL, MySQL, Google Pub/Sub
  - *Frameworks/Platforms:* Node.js, Express, Cheerio.js, Firecrawl, Retool (internal tools/dashboards), MCP (Model Context Protocol), `mcporter`, Pi (Oh My Pi / OpenClaw) Skill Development, Custom Agentic Execution Loops (GSD-like loops), LLM integrations
  - *Cloud/DevOps:* Kubernetes, AWS, Google Cloud Platform (GCP), Docker, Linux, Git, Dokploy, GitLab CI/CD, GitHub Actions
  - *Architecture:* Microservices, Location-based Services (scheduling/routing), Warehouse Management Systems, REST APIs, GraphQL, RPC
- **Employment History:**
  - *Hendrick’s Corp. (Feb 2025 - Mar 2026):* Fullstack Engineer
  - *Central Mega Kencana (Jan 2024 - Aug 2024):* Fullstack Engineer
  - *Pinhome (Aug 2021 - Sep 2023):* Backend Engineer (GCP, Location-based Services, Scheduling)
  - *TaniHub (Sep 2019 - Jul 2021):* Backend Engineer (Golang, Microservices, Warehouse Management)
  - *Pomona (Mar 2018 - Jun 2019):* Backend Developer
  - *Edumor (Dec 2016 - Aug 2017):* Frontend Developer

## CV/Resume Farming Blocklist

Always skip and **DO NOT** present any job postings from the following agencies/headhunters (they are known to farm CVs/resumes rather than hire):
- **Hire Feed**
- **Hired**
- **Quick Hire Staffing**
- **BJAK**
- **micro1**
- **Second Talent**
- **Crossing Hurdles**

## Search Execution Workflow

1. **Query Formulation:**
   Formulate searches focusing on the core stack (Go, TypeScript, Node.js), DevOps/infrastructure, or Agentic AI development (MCP, LLMs, agents) and senior/mid-senior positions.
   Example keywords:
   - `"golang engineer"`
   - `"backend engineer"`
   - `"fullstack engineer"`
   - `"devops engineer"`
   - `"ai engineer"`
   - `"agentic developer"`
   - `"llm integration"`
   - `"kubernetes engineer"`

2. **Run Search Command:**
   Call `mcporter call linkedin.search_jobs` targeting the desired locations and filters.
   Parameters to use:
  - `keywords`: `"golang engineer"`, `"backend engineer"`, `"fullstack engineer"`, `"devops engineer"`, `"ai engineer"`, or `"agentic developer"`
   - `location`: `"Jakarta, Indonesia"`, `"Indonesia"`, `"Remote"`, or relocation hubs focusing on neighbor countries in ASEAN (e.g., `"Singapore"`, `"Malaysia"`, `"Thailand"`, `"Vietnam"`, `"Philippines"`) and the APAC region (e.g., `"Australia"`, `"Japan"`, `"South Korea"`) as well as global hubs (e.g., `"Germany"`, `"Netherlands"`, `"United Kingdom"`).
   - `experience_level`: `"mid_senior,associate"` (since candidate has ~9 years experience, entry-level/internship is out, but senior roles are in)
   - `work_type`: `"remote,hybrid,on_site"`
   - `sort_by`: `"relevance"` or `"date"`

3. **Enumerate & Inspect Details:**
   The search command returns a list of job postings with `job_id`s. Inspect matching positions by calling:
   `mcporter call linkedin.get_job_details job_id: "JOB_ID"`
   Compare the job description against:
      - Must use Go (Golang), Node.js/TypeScript, require a general backend/fullstack engineer with GCP/AWS/PostgreSQL, focus on DevOps/infrastructure tasks (Kubernetes, Docker, Cloud Platforms), or involve AI Agent development, MCP server integrations, LLM workflows, or custom runtime loops.
      - Preference for companies in fintech, location-based services, e-commerce, SaaS, AI startups, or teams needing hands-on engineering + cloud/infrastructure + agentic AI automation.
      - Exclude jobs requiring stacks completely unrelated to the profile (e.g., pure Java/Spring Boot, C#/.NET, PHP/Laravel, unless they are willing to transition).
      - **MUST EXCLUDE** any job postings by blocklisted headhunters/companies (e.g., Hire Feed, Hired, Quick Hire Staffing, BJAK, micro1, Second Talent, Crossing Hurdles). Always check the company name in the job detail before presenting it.
      - **Visa & Location Filtering (for roles outside Indonesia):** If the job location is outside of Indonesia:
        - **MUST EXCLUDE** any job postings that explicitly state they do not offer visa sponsorship, cannot sponsor visas, require existing local work authorization, do not provide relocation assistance, or specify "no visa sponsorship".
        - **MUST EXCLUDE** any job postings that specify candidates must already reside in the job location, must be locals/PRs/citizens only, or explicitly reject overseas/remote candidates from outside that specific location (e.g., "must be currently based in Singapore", "no remote candidates outside Singapore", "only open to local residents").
        - For remote roles located outside Indonesia, verify that they support hiring globally/from Indonesia and do not restrict candidates to the employer's local region/country.
      - **Applicant Status Filtering:** **MUST EXCLUDE** any job postings that are no longer accepting applications, are closed, or are no longer accepting applicants.
      - **Visited/Viewed Job Filtering:**
        - Check the job ID against the cache at `skills/job-search/cache/visited_jobs.json`.
        - If the job ID is already in the visited list, it has been previously matched and presented to the user. **MUST EXCLUDE** it from processing and output.
        - When new matching job postings are written to the markdown results, save their job IDs to the visited jobs cache so they are excluded in future runs.

## Command Snippets

Search for Go roles in Jakarta/Remote:
```bash
mcporter call linkedin.search_jobs keywords="golang engineer" location="Jakarta, Indonesia" experience_level="mid_senior" work_type="remote,hybrid"
```

Search for Relocation-friendly roles in tech hubs:
```bash
mcporter call linkedin.search_jobs keywords="golang engineer" location="Singapore" experience_level="mid_senior"
```
Search for Remote/Relocation DevOps roles:
```bash
mcporter call linkedin.search_jobs keywords="devops engineer" location="Germany" experience_level="mid_senior"
```

Search for Backend/AI roles in neighbor ASEAN countries:
```bash
mcporter call linkedin.search_jobs keywords="golang engineer" location="Malaysia" experience_level="mid_senior"
```

Search for Fullstack/Infra roles in wider APAC region:
```bash
mcporter call linkedin.search_jobs keywords="fullstack engineer" location="Australia" experience_level="mid_senior"
```

Retrieve details for a specific Job ID:
```bash
mcporter call linkedin.get_job_details job_id="4252026496"
```

## Boundaries

- **NO AUTO-APPLY:** Only search and present job listings to the user. Do not attempt to apply to jobs automatically.
- **NO DESTRUCTIVE ACTIONS:** Do not send messages or connect with recruiters unless explicitly asked by the user.
- **DATA MINIMIZATION:** Do not scrape/query pages unrelated to the job search.
