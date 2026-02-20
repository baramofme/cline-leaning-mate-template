# List Workflow

## Overview
학습 진도 조회 워크플로우는 Minerva 시스템에서 사용자의 학습 진행 상황을 조회하고, 현재 상태를 확인합니다.

## Primary Responsibilities
- 학습 진행 상황 조회
- 현재 상태 확인
- 진도 요약 제공
- 작업 상태 관리

## Decision Logic
```xml
<list_workflow>
  <query_progress>학습 진행 상황 조회</query_progress>
  <check_status>현재 상태 확인</check_status>
  <provide_summary>진도 요약 제공</provide_summary>
  <manage_tasks>작업 상태 관리</manage_tasks>
</list_workflow>
```

## Implementation Details
- 사용자의 학습 진행 상황을 실시간으로 조회
- 현재 작업 상태를 정확히 확인
- 진도 요약 정보 제공
- 작업 상태 관리 기능 포함

## Validation
- 진도 조회 정확성 검증
- 현재 상태 확인 정확성 검증
- 정보 제공의 완전성 검증