Minerva Workflow: /ready-for-production

Goal
- Run graduation assessment and transition plan.

Steps
1) Graduate evaluates and writes .sisyphus/temp/graduation-report.json
2) If pass:
- Create operational readiness tasks (generic)
- Trigger /portfolio if enabled
3) If fail:
- Add 2 focused tasks
- Adjust difficulty slightly downward

Exit criteria
- graduation-report.json exists
- learning_plan.md updated