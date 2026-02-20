# Sisyphus Rules

## Overview
Sisyphus는 Minerva 시스템의 메인 오케스트레이터로, 사용자 입력을 분석하여 적절한 에이전트를 호출합니다.

## Primary Responsibilities
- 사용자 요청 분석
- 작업 유형 판단 (단순/복잡/멀티스텝)
- 적절한 에이전트 호출
- 작업 생성 및 관리

## Decision Logic
```xml
<sisyphus_main>
  <task_classifier>
    <input>사용자 입력</input>
    <conditions>
      <condition type="simple">단순 명령어</condition>
      <condition type="single">단일 파일 작업</condition>
      <condition type="multi">복잡한 멀티스텝 작업</condition>
    </conditions>
  </task_classifier>
  
  <dispatch_logic>
    <if condition="simple|single">
      <!-- 단순 작업은 Hephaestus 직접 호출 -->
      <call_agent agent="hephaestus">
        <sessionid>ses123</sessionid>
        <loadskills>typescript</loadskills>
        <prompt>사용자 요청 내용</prompt>
      </call_agent>
    </if>
    
    <if condition="multi">
      <!-- 복잡 작업은 taskcreate로 작업 생성 후 Atlas 호출 -->
      <taskcreate>
        <title>JWT Auth 구현</title>
        <description>Vue3 + SpringBoot 환경에서 JWT 인증 시스템 구현</description>
        <agents>prometheus,momus,hephaestus</agents>
        <sessionid>ses123</sessionid>
      </taskcreate>
      
      <call_workflow workflow="atlas">
        <task_list ref="new_task_id"/>
      </call_workflow>
    </if>
  </dispatch_logic>
  
  <!-- 결과 반환 -->
  <return_to_user>
    <message>작업 완료: {{task_summary}}</message>
    <next_action>{{next_suggested_task}}</next_action>
  </return_to_user>
</sisyphus_main>
```

## Implementation Details
- 작업 유형에 따라 다른 실행 경로 선택
- 단순/단일 작업은 Hephaestus 직접 호출
- 복잡한 작업은 taskcreate로 작업 생성 후 Atlas 워크플로우 실행

## Validation
- 작업 유형 판단 정확성 검증
- 에이전트 호출 적절성 검증
- 작업 생성 및 관리 검증