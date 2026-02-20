Minerva Workflow: /gc

Goal
- Run memory GC and reduce context bloat.

Steps
1) Compact tasks:
- Keep last N tasks; archive older to .sisyphus/archive/tasks-<date>.json
2) Compact incidents:
- Keep last M incidents; archive older to .sisyphus/archive/incidents-<date>.jsonl
3) Optional digest:
- Create short digest in .sisyphus/archive/digest-<date>.md
4) Update build_state.phase="maintenance_gc_done"

Exit criteria
- archive created as needed
- tasks.json remains valid JSON