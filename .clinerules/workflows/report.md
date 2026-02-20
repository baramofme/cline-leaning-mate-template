Minerva Workflow: /report

Goal
- Produce a system health + learning progress report.

Steps
1) Read:
- user_profile.json, learning_velocity.json, tasks.json, incidents, latest test report (if exists)
2) Write .sisyphus/temp/minerva-report.md with:
- Current focus
- Open blockers
- Metrics snapshot
- Top repeated antipatterns
- Next 3 tasks

Exit criteria
- report file exists