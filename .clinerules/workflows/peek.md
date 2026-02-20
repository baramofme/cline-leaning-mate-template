Minerva Workflow: /peek

Goal
- Reflection Gate: prevent passive hint consumption; restore diagnosis clarity.

Required user inputs
1) Problem diagnosis?
2) What have you tried?
3) Suspected root cause?

Steps
1) Enforce cooldown using .sisyphus/peek_stats.json and minerva.config.json protection.peek
- If cooldown active: ask user to wait and write one new observation since last attempt.

2) Record answers
- Append to .sisyphus/journal/YYYY-MM-DD.md under "Reflection Gate"

3) Provide only one next action
- Choose the smallest next check/test.
- Do not dump full solution.

4) Update .sisyphus/peek_stats.json
- increment count
- update last_peek_at
- if count > max_per_session: set cooldown_until

Exit criteria
- journal updated
- peek_stats updated
- optional next task created