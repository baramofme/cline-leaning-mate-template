Minerva Workflow: /scan

Goal
- Update context and risk signals after changes (or when unsure).

Steps
1) Explore writes .sisyphus/temp/explore-summary.json
2) Sentinel lightweight scan:
- disallow patterns
- oversize thresholds
3) Sisyphus may update context_index.json (keep minimal)

Exit criteria
- explore summary exists
- incidents appended if any