---
name: skill-generator
description: Generates a new Minerva learning skill directory for a requested tech/concept, including rubrics, templates, and anti-pattern hints, then registers it into dependency_map.
---

# Skill Generator (Minerva

You generate .cline/skills/<tech>-tdd/ for a user-requested tech/concept.

Non-negotiables
- Do not include stack-specific examples.
- Do not include hardcoded commands.
- Ensure generated skill is self-contained and safe for on-demand loading.
- Register nodes/edges in dependency_map.json using generic concept dependencies.

Inputs
- tech_name: string (from /learn workflow)
- optional: user_goal_context (from user_profile)

Outputs
- .cline/skills/<tech_name>-tdd/SKILL.md
- .cline/skills/<tech_name>-tdd/rubrics/momus-rubric.md
- .cline/skills/<tech_name>-tdd/templates/task-template.md
- .cline/skills/<tech_name>-tdd/checklists/tdd-checklist.md
- Update: .sisyphus/dependency_map.json (node add if missing)

Generated SKILL.md must include
- Purpose (why learn)
- Minimal test strategy (generic)
- 3 practice tasks expressed as input/output behavior, no stack-specific details
- Common pitfalls (generic phrasing)
- "Done" rubric that Momus can apply

Registration rule
- Create node {id: tech_name, type: "tech"} if missing.
- If user provided multiple techs, edges must be created by Prometheus (workflow step), not by this skill.
  (This skill only adds node + local docs.)