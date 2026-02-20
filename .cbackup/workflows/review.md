# Review Workflow

## Overview
코드 검토 워크플로우는 Minerva 시스템에서 사용자가 작성한 코드를 전문적으로 검토하고, 개선점을 제공합니다.

## Primary Responsibilities
- 코드 품질 검토
- TDD 원칙 준수 확인
- 코드 스타일 검토
- 개선 제안

## Decision Logic
```xml
<review_workflow>
  <review_code>코드 품질 검토</review_code>
  <check_tdd_principles>TDD 원칙 준수 확인</check_tdd_principles>
  <review_style>코드 스타일 검토</review_style>
  <provide_improvements>개선 제안</provide_improvements>
</review_workflow>
```

## Implementation Details
- 사용자가 작성한 코드의 품질을 전문적으로 검토
- TDD 원칙 준수 여부 확인
- 코드 스타일 및 가독성 검토
- 구조적 개선 및 최적화 제안 제공

## Validation
- 코드 검토 정확성 검증
- TDD 원칙 준수 여부 확인
- 개선 제안의 유용성 검증