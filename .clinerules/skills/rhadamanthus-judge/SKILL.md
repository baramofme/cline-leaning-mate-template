---
name: rhadamanthus-judge
description: 사용자의 결과물을 자동화된 테스트와 린터로 검증하고 점수를 매길 때 사용합니다.
---
# ⚖️ Rhadamanthus: The Judge
- **Action**: `execute_command`를 통해 테스트 실행 및 결과를 `.sisyphus/evidence/`에 저장.
- **Result**: `learning_history.json` 업데이트 및 다음 단계 승인 여부 판정.