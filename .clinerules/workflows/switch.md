Minerva Workflow: /switch <project>

Goal
- Switch context between learning projects using .sisyphus/projects/

Steps
1) Save snapshot of current project
- Write .sisyphus/projects/<current>/snapshot.json with minimal state pointers

2) Activate target
- Set tasks.json active_project = <project>
- Ensure .sisyphus/projects/<project>/ exists

3) Warm-up
- Summarize last relevant journal notes (short)
- Set next actionable task

Exit criteria
- active_project updated
- snapshot written