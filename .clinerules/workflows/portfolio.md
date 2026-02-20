Minerva Workflow: /portfolio

Goal
- Create/update portfolio artifacts from learning state without copying large code blobs.

Steps
1) Aggregate state:
- tasks.json, journal, incidents, learning_velocity

2) Generate under .sisyphus/portfolio/
- README.md: problem -> approach -> testing strategy -> results
- journey.md: learning highlights and decisions
- metrics.json: counts and rates
- highlights/: curated notes pointing to paths, not full code

3) Journal entry: "Portfolio updated"

Exit criteria
- .sisyphus/portfolio/README.md exists
- .sisyphus/portfolio/metrics.json exists