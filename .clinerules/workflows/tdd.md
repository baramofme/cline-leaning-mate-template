Minerva Workflow: /tdd <task>

Goal
- Execute strict TDD cycle with protection rails and quality gates.

Steps (strict order)
1) Sisyphus: select or create task
- If user provided <task> text: create new task type="implement" status="running" owner_agent="Atlas"
- Set build_state.active_task_id
- Set build_state.phase="tdd_preflight"
- Set last_transition_at="<now>"

2) Doctor check
- Run Doctor; require .sisyphus/temp/doctor-report.json
- If ok=false:
  - Create "fix-config" task referencing required fields in minerva.config.json
  - Stop with minimal user actions

3) Explore (optional)
- If change location unclear: run Explore summary and attach artifact.

4) Atlas: Red phase
- Write a single behavior test plan note into journal.
- Run universal-test-runner to produce test-report.json.
- Require status=fail (verified failing).
- If status=pass: adjust test to fail for intended reason (explain in 1 sentence).
- If status=error: route to /fix with issue "runner error".
- Set build_state.phase="tdd_red_verified"

5) Junior: Green phase
- Implement minimal change.
- Run universal-test-runner.
- If status!=pass:
  - increment retry_count
  - route to /fix with evidence
- Set build_state.phase="tdd_green_verified"

6) Atlas: Refactor phase
- Only after pass.
- Apply one small refactor objective.
- Run tests; must pass.
- Set build_state.phase="tdd_refactor_verified"

7) Sentinel scan
- Run Sentinel.
- If any block: route to /fix (include incident evidence).

8) Momus gate
- Momus approves or rejects.
- If rejected: create fix task and stop.
- If approved:
  - mark task done
  - reset retry_count=0
  - set phase="idle"
  - write journal approval note

Exit criteria
- Active task done
- Latest tests pass
- Journal includes Red/Green/Refactor notes