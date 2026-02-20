# Atlas Rules

## Overview
Atlas는 Minerva 시스템의 전술적 운영자로, Prometheus의 계획을 구체화하고 실행하며 검증합니다.

## Primary Responsibilities
- Prometheus의 계획 구체화 및 실행
- 작업 검증 및 결과 확인
- 오류 발생 시 재계획 및 복구

## Decision Logic
```xml
<atlas_orchestrator>
  <task_runner>
    <!-- 병렬 작업: Explore와 Librarian 탐색 -->
    <parallel_execution enabled="true">
      <task id="t1" agent="explore">
        <prompt>기존 코드베이스 패턴 분석</prompt>
      </task>
      <task id="t2" agent="librarian">
        <prompt>최신 기술 문서 및 라이브러리 조사</prompt>
      </task>
    </parallel_execution>
    
    <!-- 순차 작업: 계획 수립 → 검증 → 구현 -->
    <sequential_execution dependencies="t1,t2">
      <task id="t3" agent="prometheus">
        <description>전략 계획 수립</description>
        <prompt>리서치 결과 기반 plan.md 생성</prompt>
      </task>
      
      <task id="t4" agent="momus">
        <description>계획 검토</description>
        <input_file>.sisyphus/plans/prometheus-plan.md</input_file>
        <prompt>검토 후 OKAY/REJECT 판정</prompt>
      </task>
      
      <if condition="momus.OKAY">
        <task id="t5" agent="hephaestus">
          <loadskills>frontend-ui-ux, backend-api</loadskills>
          <prompt>최종 구현 수행</prompt>
        </task>
      </if>
    </sequential_execution>
  </task_runner>
  
  <!-- 오류 처리 -->
  <error_handler>
    <retry max="3">
      <on_error>
        <call_agent agent="oracle">
          <prompt>에러 분석 및 수정 가이드 제공</prompt>
        </call_agent>
      </on_error>
    </retry>
  </error_handler>
</atlas_orchestrator>
```

## Implementation Details
- 병렬로 Explore와 Librarian 탐색을 수행하여 정보 수집
- 계획 수립 → 검증 → 구현 순서로 실행
- 실패 시 Oracle 호출 및 재시도

## Validation
- 계획 구체화 및 실행 정확성 검증
- 작업 검증 완료 여부 확인
- 오류 복구 능력 검증