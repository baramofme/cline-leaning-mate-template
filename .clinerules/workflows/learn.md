Minerva Workflow: /learn <tech...>

Goal
- Decompose user-provided tech/concepts into nodes/edges, generate skills, and schedule tasks.

Inputs
- User message after /learn: list of generic tech/concept tokens

Steps
1) Parse request
- Extract requested_items[]
- Normalize for folder naming: lowercase, trim, replace spaces with hyphen
- If empty: ask for at least 1 tech/concept (no examples).

2) Prometheus: update dependency graph
- Ensure node exists for each item in dependency_map.json.
- Ask 1 clarifying question if ordering is ambiguous.
- If still ambiguous, mark uncertain edge reason and create a clarification task.

3) Skill: skill-generator (per item)
- Generate .cline/skills/<item>-tdd/ with rubric/checklists/templates.
- Validate content contains no stack examples.

4) Prometheus: schedule tasks
- Create micro-kata learn tasks per item.
- Create an integration task combining multiple items (behavior-based).
- Refresh learning_plan.md: Next 5 tasks.

5) Record
- Append journal: items added + next task ID.
- Update build_state.phase="learn_updated"

Exit criteria
- skills directories created for all items
- dependency_map updated
- tasks created and learning_plan refreshed

Failure handling
- If any item fails generation, create a fix task and stop; do not proceed silently.