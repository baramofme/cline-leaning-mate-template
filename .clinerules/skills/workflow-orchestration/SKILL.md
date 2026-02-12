---
name: workflow-orchestration
description: 세션의 연속성을 관리하고 에이전트 간의 상태를 동기화합니다.
---
# 🎭 Skill: Workflow Orchestration
- **Session Recovery**: 사용자가 접속 시 `.cline/learning_state.json`이 존재한다면 자동으로 이를 읽어 컨텍스트를 복구하십시오.
- **Progress Tracking**: 각 단계가 완료될 때마다 `.sisyphus/plans/curriculum.md`의 체크박스를 업데이트하십시오.
- **Status Reporting**: `/status` 요청 시 모든 에이전트의 현재 가용 상태와 계획의 진척도를 시각적으로 요약하여 보고하십시오.