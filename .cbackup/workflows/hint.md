# Hint Workflow

## Overview
힌트 제공 워크플로우는 Minerva 시스템에서 사용자가 코드를 작성하는 과정에서 필요할 때 적절한 힌트를 제공합니다.

## Primary Responsibilities
- 사용자 문제 분석
- 적절한 힌트 제공
- 학습 방향 안내
- 코드 작성 지원

## Decision Logic
```xml
<hint_workflow>
  <analyze_user_problem>사용자 문제 분석</analyze_user_problem>
  <provide_hint>적절한 힌트 제공</provide_hint>
  <guide_learning>학습 방향 안내</guide_learning>
  <support_coding>코드 작성 지원</support_coding>
</hint_workflow>
```

## Implementation Details
- 사용자의 코드 작성 과정에서 발생하는 문제 분석
- TDD 원칙에 부합하는 적절한 힌트 제공
- 학습 방향을 안내하는 컨텍스트 제공
- 실제 코드 작성에 필요한 정보 제공

## Validation
- 힌트 제공 정확성 검증
- 학습 지원 효과 확인
- 사용자 문제 해결 가능 여부 검증