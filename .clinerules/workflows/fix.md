Minerva Workflow: /fix <issue>

Goal
- Fix a failing test, blocked gate, or environment error using TDD principles.

Steps
1) Sisyphus: create/activate fix task
- Create task type="fix" status="running" owner_agent="Atlas"
- Attach evidence paths if present:
  - .sisyphus/temp/test-report.json
  - .sisyphus/temp/doctor-report.json
  - incidents ids (from incidents.jsonl)

2) Diagnose (Doctor + Explore as needed)
- If doctor-report shows block: focus on config/environment, keep changes minimal.
- Else focus on reproducing failure with a minimal failing condition.

3) Atlas: lock Red
- Ensure failing condition is reproducible and explained in 1 sentence.
- Run universal-test-runner; confirm fail/error is consistent.

4) Junior: minimal fix
- Smallest diff to satisfy failing behavior.
- Run tests; must pass.

5) Sentinel + Momus
- Sentinel scan; if block, record incident and continue only via another fix loop.
- Momus approval required to close fix task.

6) Adaptive update (Prometheus)
- Update learning_velocity: add struggle point if repeated, lower difficulty if needed.
- Add a micro-kata prevention task.

Exit criteria
- Root issue resolved
- fix task done
- journal captures what broke and why

Escalation
- If retry_count exceeds limit: force /peek then offer Oracle.