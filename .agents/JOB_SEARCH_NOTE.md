### 1. Available Search Filters & Valid Options

┌──────────────────┬─────────────────────────────────────────────────────────────────────┬────────────────────────┐
│ Filter           │ Description / Supported Values                                      │ Mapping to Tool        │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Location         │ E.g., "Jakarta, Indonesia", "Remote", "Singapore".                  │ location="..."         │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Date Posted      │ past_hour, past_24_hours, past_week, or past_month.                 │ date_posted="..."      │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Work Type        │ Comma-separated: remote, hybrid, or on_site.                        │ work_type="..."        │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Job Type         │ Comma-separated: full_time, part_time, contract, internship.        │ job_type="..."         │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Experience Level │ Comma-separated: entry, associate, mid_senior, director, executive. │ experience_level="..." │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Easy Apply       │ Set to true to filter only for jobs accepting 1-click Easy Apply.   │ easy_apply=true        │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Sort By          │ date (latest first) or relevance (default).                         │ sort_by="..."          │
├──────────────────┼─────────────────────────────────────────────────────────────────────┼────────────────────────┤
│ Page Limit       │ The maximum pages of results to load (1 to 10, default is 3).       │ max_pages=X            │
└──────────────────┴─────────────────────────────────────────────────────────────────────┴────────────────────────┘

### 2. Examples of How to Prompt

You can prompt the agent naturally using any of the variables above:

- Basic Search with Location & Recency:
  *"Find me Go developer jobs in Jakarta posted in the past week"*
  - Under the hood: mcporter call linkedin.search_jobs keywords="golang" location="Jakarta" date_posted="past_week"
- Remote-Only & Easy Apply Contracts:
  *"Look for Remote DevOps contract jobs posted in the past 24 hours that are Easy Apply"*
  - Under the hood: mcporter call linkedin.search_jobs keywords="devops" location="Remote" date_posted="past_24_hours" job_type="contract" easy_apply=true
- Startups / Founding Roles Sorted by Date:
  *"Search for remote Founding Engineer jobs in Indonesia, sort by latest"*
  - Under the hood: mcporter call linkedin.search_jobs keywords="founding engineer" location="Indonesia" work_type="remote" sort_by="date"

in Indonesia, any work type for the last day, fulltime, 4 years above experience
