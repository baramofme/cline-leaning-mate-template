# Learn Workflow

## Overview
학습 워크플로우는 Minerva 시스템에서 구현 작업을 안내하고, TDD 방식으로 학습 프로세스를 진행합니다.

## Primary Responsibilities
- 사용자 요구사항 분석
- 구현 계획 수립
- TDD 사이클 안내 (Red → Green → Refactor)
- 코드 구현 지원

## Decision Logic
```xml
<learn_workflow>
  <analyze_requirements>사용자 요청 분석</analyze_requirements>
  <plan_implementation>구현 계획 수립</plan_implementation>
  <tdd_cycle>
    <red_step>실패하는 테스트 작성</red_step>
    <green_step>최소 코드로 통과</green_step>
    <refactor_step>리팩토링</refactor_step>
  </tdd_cycle>
  <provide_support>코드 구현 지원</provide_support>
</learn_workflow>
```

## Implementation Details
- TDD 방식으로 학습 프로세스 진행
- Red → Green → Refactor 순환 고리 강제
- 실패하는 테스트부터 시작
- 최소 코드로 통과 후 리팩토링
- 사용자 스스로 코드 작성 및 테스트 통과

## Validation
- TDD 원칙 준수 여부 확인
- 학습 프로세스 정확성 검증