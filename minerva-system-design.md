# Minerva 학습 메이트 시스템 설계문서

## 1. 시스템 개요

Minerva는 Kent Beck의 Test-Driven Development (TDD) 원칙을 기반으로 한 고급 학습 메이트 시스템입니다. 사용자의 요구사항을 분석하여 적절한 에이전트를 호출하고, TDD 방식으로 학습 프로세스를 안내합니다.

## 2. 폴더 구조 및 파일 내용

### 2.1 .clinerules/ 폴더 구조
```
.clinerules/
├── sisyphus.md                 # Sisyphus 주요 규칙 (에이전트 오케스트레이션)
├── prometheus.md                 # Prometheus 계획 규칙 (전략적 계획)
├── atlas.md                      # Atlas 운영 규칙 (실행 및 검증)
├── workflows/                    # 워크플로우 정의
│   ├── learn.md                  # 학습 워크플로우 (구현 가이드)
│   ├── done.md                 # 완료 검증 워크플로우 (채점 및 검증)
│   └── hint.md                 # 힌트 제공 워크플로우
└── skills/                     # 스킬 정의
    ├── builtin/                  # 기본 스킬 (시스템 핵심 기능)
    │   ├── task-management.md    # 태스크 관리
    │   └── agent-orchestration.md  # 에이전트 오케스트레이션
    ├── dynamic/                # 동적 스킬 (도메인 전문성)
    │   └── tdd-learning-kit.md  # TDD 학습 키트
    └── internal/               # 내부 스킬 (IDE 연동)
        └── diagnostics.md        # 진단 스킬
```

### 2.2 .sisyphus/ 폴더 구조
```
.sisyphus/
├── tasks.json                    # 작업 상태 저장 (Memory Bank)
├── plans/                      # 학습 계획 저장
│   ├── overview.md             # 전체 계획 개요
│   └── step-1/              # 단계별 계획
│       ├── overview.md           # 단계 개요
│       └── task-1.1.md     # 작업 세부 내용
└── evidence/                   # 증거 및 로그
    └── test-results.log        # 테스트 결과 로그
```

## 3. 주요 구성 요소

### 3.1 Primary Rules (핵심 규칙)

| 구성 요소 | 역할 | 설명 |
|-----------|------|--------|
| **Sisyphus** | 메인 오케스트레이터 | 사용자 입력을 분석하여 작업 성격에 따라 적절한 에이전트 호출 |
| **Prometheus** | 전략 계획가 | 복잡한 작업의 구조 설계 및 학습 로드맵 수립 |
| **Atlas** | 전술적 운영자 | Prometheus의 계획을 구체화하고 실행, 검증 |

### 3.2 Sub-agent Workflows (실행 유닛)

| 에이전트 | 역할 | 강점 | 약점 |
|-----------|------|------|------|
| **Junior** | 단순 구현 | 가벼운 태스크 실행 | 깊은 탐색 부족 |
| **Hephaestus** | 전문 구현 | 복잡 단일 작업, 병렬 처리 | 단순 작업 낭비 |
| **Oracle** | 지식 탐색 | 외부 라이브러리 및 문서 조사 | 직접 코드 작성 금지 |
| **Momus** | 검토자 | 결과물 및 계획 검증 | 실행 불가 |

## 4. 주요 구성 요소 정의

### 4.1 Sisyphus 규칙 (.clinerules/sisyphus.md)
Sisyphus는 시스템의 메인 오케스트레이터로, 사용자 입력을 분석하여 적절한 에이전트를 호출합니다.

**실제 동작 방식:**
- 사용자 요청을 분석하여 작업 유형 판단 (단순/복잡/멀티스텝)
- 작업 유형에 따라 다른 실행 경로 선택
- `taskcreate` 명령어를 통해 작업 생성
- 작업 생성 후 Atlas 워크플로우 호출

```xml
<!-- Sisyphus 주요 규칙 XML 구조 -->
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

**설명:**
- **dispatch_logic**: 작업 유형에 따라 다른 실행 경로를 선택
- **simple/single**: 단순 작업은 Hephaestus에게 직접 호출 (가벼운 구현)
- **multi**: 복잡한 작업은 taskcreate로 작업 생성 후 Atlas 워크플로우 실행

### 4.2 Prometheus 규칙 (.clinerules/prometheus.md)
Prometheus는 전략적 계획가로, 작업의 구조를 설계하고 학습 로드맵을 수립합니다.

```xml
<!-- Prometheus 주요 규칙 XML 구조 -->
<prometheus_planner>
  <analyze_task>작업 내용 분석</analyze_task>
  <generate_plan>
    <format>markdown</format>
    <output_path>.sisyphus/plans/plan.md</output_path>
    <validation_check>필요 기술 스택 및 의존성 확인</validation_check>
  </generate_plan>
</prometheus_planner>
```

**설명:**
- **analyze_task**: 작업 내용을 분석하여 구조 설계
- **generate_plan**: 학습 계획을 마크다운 형식으로 생성 (`.sisyphus/plans/plan.md`)
- **validation_check**: 필요한 기술 스택 및 의존성 확인

### 4.3 Atlas 규칙 (.clinerules/atlas.md)
Atlas는 전술적 운영자로, Prometheus의 계획을 구체화하고 실행하며 검증합니다.

```xml
<!-- Atlas 주요 규칙 XML 구조 -->
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
        <input_file>.sisyphusplans/prometheus-plan.md</input_file>
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

**설명:**
- **parallel_execution**: 병렬로 Explore와 Librarian 탐색을 수행하여 정보 수집
- **sequential_execution**: 계획 수립 → 검증 → 구현 순서로 실행
- **error_handler**: 실패 시 Oracle 호출 및 재시도

## 5. Memory Bank 구조

### 5.1 TaskStore (.sisyphus/tasks.json)
```json
{
  "sessionid": "ses123",
  "tasks": [
    {
      "id": "auth-impl",
      "status": "completed",
      "summary": "JWT Auth 구현 완료 (Vue3 + SpringBoot)",
      "agents_executed": ["explore", "prometheus", "hephaestus"],
      "files_changed": ["src/auth/controller.ts", "stores/auth.ts"]
    }
  ]
}
```

### 5.2 Memory Bank 동작 방식
1. **Task Management**: 모든 작업 상태를 `.sisyphus/tasks.json`에 저장하여 추적
2. **Context Injection**: 작업 시작 시 JSON 내용을 읽어 컨텍스트 주입
3. **State Tracking**: 작업 진행 상황 실시간 추적 및 관리

## 6. Hand-off 메커니즘

### 6.1 taskcreate로 구현
```xml
<!-- 작업 생성 예시 -->
<taskcreate>
  <title>JWT Auth 구현</title>
  <description>Vue3 + SpringBoot 환경에서 JWT 인증 시스템 구현</description>
  <agents>prometheus,momus,hephaestus</agents>
  <sessionid>ses123</sessionid>
</taskcreate>
```

### 6.2 작업 흐름
```
사용자 요청
    ↓
Sisyphus 분석 → 작업 유형 판단
    ↓
단순? 복잡? 멀티?
    ↓
┌─────────────┬─────────────┬──────────────┐
│   Simple      │     Single     │    Multi-step  │
│  (Hephaestus)  │  (Hephaestus)  │  (Prometheus+...)│
└─────────────┴─────────────┴──────────────┘
    ↓
작업 생성/분석 → Atlas 실행
    ↓
Prometheus 계획 수립
    ↓
Momus 검증 → Hephaestus 구현
    ↓
작업 완료 → tasks.json 업데이트
```

## 7. Context Builder 동작 방식

### 7.1 직접 구현 방식
Context Builder는 다음과 같은 방식으로 작동합니다:

1. **작업 시작 전**: `.sisyphus/tasks.json` 내용을 요약하여 컨텍스트 생성
2. **작업 진행 중**: 작업 상태를 주기적으로 업데이트하고 요약
3. **작업 종료 후**: 최종 요약 정보 저장

### 7.2 실제 구현 예시:
```bash
# tasks.json 요약 스크립트
#!/bin/bash
summary=$(jq -c '.tasks[] | {id, status, summary}' .sisyphus/tasks.json)
echo "요약: $summary"
```

## 8. 구성 요소 요약

| 구성 요소 | 역할 | 실제 호출 방식 |
|----------|------|-----------------|
| **Sisyphus** | 메인 오케스트레이터 | `taskcreate`, `call_agent`로 에이전트 호출 |
| **Prometheus** | 전략 계획 | `call_rule`로 규칙 호출 |
| **Atlas** | 운영자 | `call_workflow`로 워크플로우 호출 |
| **Junior** | 단순 구현 | `call_agent`로 직접 호출 |
| **Hephaestus** | 전문 구현 | `call_agent`로 직접 호출 |
| **Oracle** | 지식 탐색 | `use_subagent`로 탐색 호출 |

## 9. 학습 프로세스 흐름도

```
사용자 요청 → Sisyphus 분석
    ↓
[작업 유형 판단]
    ↓
┌─────────────┬─────────────┬──────────────┐
│   Simple      │     Single     │    Multi-step  │
│  (Hephaestus)  │  (Hephaestus)  │  (Prometheus+...)│
└─────────────┴─────────────┴──────────────┘
    ↓
[작업 생성/분석]
    ↓
[학습 진행 - TDD 사이클]
    ↓
[Hint/Review/Fix/Done 작업]
    ↓
[결과 검증 및 다음 단계]
```

## 10. TDD 원칙 및 개발 지침

### 10.1 핵심 원칙
- **TDD 방식**: Red → Green → Refactor 순환 고리
- **Tidy First**: 구조적 변경과 행동 변경 분리
- **코드 품질**: 중복 제거, 의도 명확한 이름 사용, 의존성 명시

### 10.2 개발 절차
1. **실패하는 테스트 작성**: 작동하지 않는 테스트부터 시작
2. **최소 코드로 통과**: 테스트가 통과할 수 있는 최소한의 코드 작성
3. **리팩토링**: 테스트 통과 후 구조 개선
4. **반복**: 새로운 기능 추가 시 위 과정 반복

## 11. 스킬 구조화

### 11.1 Builtin Skills (기본 엔진)
- task-management.md: tasks.json 스키마 및 태스크 생명주기 관리
- agent-orchestration.md: call_rule, call_workflow 호출 규약
- context-summary.md: Context Builder를 통한 메모리 압축 및 주입 지침

### 11.2 Dynamic Skills (도메인 전문성)
- frontend-ui-ux.md: React/Vue3, Tailwind, Shadcn UI 등
- backend-api.md: SpringBoot, MyBatis, JPA, Python Fast API 등
- tdd-learning-kit.md: Kent Beck의 TDD 원칙, Tidy First, 리팩토링 패턴

### 11.3 Internal Skills (IDE 연결)
- ide-symbols.md: LSP를 통한 클래스, 함수 심볼 조회
- diagnostics.md: 컴파일 에러 및 린트 오류 실시간 획득

## 12. 시스템 통합 문서

### 12.1 TDD Dynamic Rule (Atlas 주입)
```markdown
# [Rust]-specific Best Practices (Dynamically Added)
- Prefer functional programming style (map, and_then).
- Use `cargo test` as the primary validation tool.
- [User Custom Rules Space]
  (사용자가 이곳에 자신만의 규칙을 추가할 수 있습니다)
```

## 13. 시스템 특징

1. **기록 기반 최적화**: 사용자의 /hint, /fix, /done 내용을 모두 기록하여 다음 단계에 반영
2. **TDD 원칙 기반**: 사용자가 스스로 코드를 작성하고 테스트를 통과하는 방식으로 학습
3. **에이전트 계층화**: 각 에이전트는 명확한 역할을 가지고 있으며, 복잡성에 따라 선택적으로 호출됨
4. **동적 스킬 로드**: 특정 작업에 따라 필요한 스킬만 로드하여 리소스 절약
5. **자기 회복 능력**: 실패 시 Oracle 기반 재계획 루프를 통해 자동 복구

## 14. 구현 가능성 검토

### 14.1 문제점
- 문서에 나와 있는 XML 구조는 실제 Cline 시스템에서 사용하는 문법과 다름
- `{{}}` 표기법은 실제 시스템에서 작동하지 않음
- 일부 구문이 실제 구현과 일치하지 않음

### 14.2 보완책
- 실제 Cline 시스템의 문법에 맞춘 XML 구조로 수정
- 각 구성 요소의 실제 동작 방식 설명 추가
- 실제 구현 가능한 방식으로 수정

## 15. 결론

Minerva 시스템은 사용자의 요구사항을 정확히 분석하고, TDD 원칙에 따라 구조적이고 체계적인 학습 프로세스를 제공합니다. 다양한 에이전트들이 협력하여 사용자가 스스로 코드를 작성하고 테스트하는 과정에서 진정한 학습을 이루도록 합니다.