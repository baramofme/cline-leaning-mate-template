Minerva Workflow: /doctor

Goal
- Run Doctor checks and produce doctor-report.json.

Steps
1) Doctor runs checks and writes .sisyphus/temp/doctor-report.json
2) If ok=false:
- Create fix task "Fill required minerva.config.json fields"
- Provide exact file path and fields to fill (no examples)
3) If ok=true:
- Suggest next: /tdd or /fix depending on state

Exit criteria
- doctor-report.json exists