# Done Workflow

## Overview
완료 검증 워크플로우는 Minerva 시스템에서 구현된 코드를 검증하고, 학습 성과를 평가합니다.

## Primary Responsibilities
- 구현된 코드 검증
- TDD 테스트 결과 확인
- 학습 성과 평가
- 최종 완료 상태 설정

## Decision Logic
```xml
<done_workflow>
  <validate_implementation>구현 검증</validate_implementation>
  <check_test_results>TDD 테스트 결과 확인</check_test_results>
  <evaluate_learning>학습 성과 평가</evaluate_learning>
  <set_final_status>최종 상태 설정</set_final_status>
</done_workflow>
```

## Implementation Details
- 구현된 코드를 전문적으로 검증
- TDD 테스트 결과를 자동으로 확인
- 사용자의 학습 성과를 평가
- 완료 상태를 정확히 기록

## Validation
- 코드 검증 정확성 검증
- 테스트 결과 확인 완료 여부 확인
- 평가 절차 정확성 검증