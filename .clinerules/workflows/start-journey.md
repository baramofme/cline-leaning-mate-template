Minerva Workflow: /start-journey

Goal
- Build initial profile, detect project signals, generate roadmap, create first tasks.

Steps
1) Sisyphus -> Metis
- Run Metis interview.
- Update: .sisyphus/user_profile.json

2) Sisyphus -> Skill: language-detector
- Produce .sisyphus/temp/detection.json

3) Sisyphus -> Explore
- Produce .sisyphus/temp/explore-summary.json

4) Sisyphus -> Prometheus
- Create/refresh:
  - .sisyphus/dependency_map.json (may remain minimal)
  - .sisyphus/learning_plan.md
- Create initial tasks in .sisyphus/tasks.json:
  - One micro-kata TDD task
  - One discovery task if Explore found ambiguity

5) Record state
- Update .sisyphus/build_state.json:
  - phase="journey_initialized"
  - last_transition_at="<now>"
- Journal entry: profile summary + next 1 task ID

Exit criteria
- user_profile.json updated
- learning_plan.md exists
- tasks.json has at least 2 tasks