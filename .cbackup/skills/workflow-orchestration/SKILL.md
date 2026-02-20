---
name: workflow-orchestration
description: Multi-agent coordination via .clinerules/workflows/ (v3.6)
model: qwen3-30b
trigger: Council Operations
---

# 🎭 Skill: Workflow Orchestration (The Council Conductor)

## 📡 Debug & Visibility Protocol (MANDATORY)
모든 에이전트는 응답의 최상단에 아래 형식의 **[Agent Status Board]**를 출력하여 현재 작업의 맥락을 투명하게 공개해야 합니다.

> **[Agent Status Board]**
> * **Current Skill**: (예: Hephaestus-worker)
> * **Phase**: (예: /forge - Mode 1: Infrastructure)
> * **Reasoning**: (왜 이 작업을 하는지, 어떤 지침에 근거했는지 1문장 요약)
> * **Input Context**: (참조 중인 파일 - 예: .sisyphus/blueprint.md)
> * **Next Expected**: (이 작업 후 호출될 에이전트나 워크플로우)

## 🔄 Workflow Execution Logic
각 단계는 `.clinerules/workflows/` 내의 해당 파일을 엄격히 준수하여 실행됩니다.

### 1. 가용성 검증: `/status` & `/list`
- 모든 작업 시작 전 `/status`를 통해 현재 `.sisyphus/learning_state.json`의 무결성을 확인합니다.
- `/list`를 통해 현재 남아있는 태스크와 우선순위를 파악합니다.

### 2. 인프라 구축: `/forge` & `/blueprint`
- `/blueprint`: Metis/Librarian의[learningstate.md.template](../../templates/learningstate.md.template)
[progress.md.template](../../templates/progress.md.template)
[task.md.template](../../templates[blueprint](../../workflows/blueprint)
[concept](../../workflows/concept)
[done](../../workflows/done)
[fix](../../workflows/fix)
[forge](../../workflows/forge)
[hint](../../workflows/hint)
[learn](../../workflows/learn)
[list](../../workflows/list)
[plan](../../workflows/plan)
[resume](../../workflows/resume)
[status](../../workflows/status)
[.clinerules](../../.clinerules)/task.md.template) 2026 규격 검증 설계도 생성.
- `/forge`: Hephaestus의 물리 환경 구축. 오류 시 **Investigation Loop** 가동.
- 에러 발생 시 `/fix`를 호출하기 전 **Rhadamanthus(증거) + Librarian(검색)** 조사를 선행합니다.

### 3. 상세 계획: `/plan`
- **Prometheus**가 주도하여 `/plan` 워크플로우를 실행합니다.
- 결과물은 반드시 `draft` 폴더를 거쳐 **Momus**의 비판을 통과해야 합니다.

### 4. 실행 및 복구: `/resume`, `/done`, `/fix`
- `/resume`: 중단된 태스크나 새로 승인된 계획의 첫 단계를 시작합니다.
- `/done`: Rhadamanthus의 검증 로그를 기반으로 태스크를 종료합니다.
- `/fix`: 장애 발생 시 Oracle의 가설과 Momus의 비판을 거쳐 수리합니다.

### 5. 지식 자산화: `/learn` & `/hint`
- 성공 패턴은 `/learn`으로 적재, 반복 가이드는 `/hint`로 제시.

## 🚫 Mandatory Constraints (The Golden Rules)
1. **Self-Identification**: 작업을 시작하기 전 자신이 어떤 워크플로우 파일(`.clinerules/workflows/`)을 준수하고 있는지 선언하십시오.
2. **Phase Boundary**: 현재 페이즈(예: /forge)를 벗어나는 행동(예: 비즈니스 로직 코딩)을 하려 할 때, Board에 그 이유를 명시하고 사용자의 승인을 구하십시오.
3. **Evidence-Based**: Rhadamanthus의 물리적 증거(로그) 없이는 '성공'이라고 판단하지 말고, Board에 `Waiting for Evidence` 상태를 표시하십시오.
4. **Momus Anti-Stupidity**: Momus는 비판 시 Oracle의 해석이 아닌 Rhadamanthus의 로그와 Librarian의 리서치 원본을 직접 대조해야 합니다.
5. **TDD Enforcement**: 구현 코드를 작성하기 전 반드시 테스트 코드가 선행되도록 계획하고 검증하십시오.
6. **No Data, No Status**: 물리적 증거(Exit Code 0, Success Log) 없이는 상태 전이를 허용하지 않습니다.
7. **Context Guard**: 동일 지점 3회 실패 시 강제로 `/oracle`을 호출하여 아키텍처 수준의 재설계를 검토하십시오.

## 🔄 State & Memory Synchronization
- **Metadata Update**: MCP 도구 확인 직후 `.sisyphus/learning_state.json` 즉시 동기화.
- **CRCT Sync**: 위원회 합의가 완료된 사항만 `activeContext.md` 및 `systemPatterns.md`에 반영합니다.