# Implementation Plan

## Overview
Minerva 학습 메이트 시스템의 설계문서를 바탕으로 .clinerules 디렉토리에 필요한 규칙 파일과 워크플로우 파일들을 구현합니다. 이 계획은 Sisyphus, Prometheus, Atlas 등의 주요 구성 요소와 hint, review, fix, done 워크플로우를 포함한 완전한 시스템 구조를 정의합니다.

## Types
Minerva 시스템의 핵심 구성 요소들을 정의하는 XML 규칙 파일들입니다:
- Primary Rules: Sisyphus, Prometheus, Atlas 규칙 파일
- Sub-agent Workflows: 학습 프로세스에서 사용되는 워크플로우 파일들

## Files
### New Files to be Created
- `.clinerules/sisyphus.md`: Sisyphus 주요 규칙 (에이전트 오케스트레이션)
- `.clinerules/prometheus.md`: Prometheus 계획 규칙 (전략적 계획)
- `.clinerules/atlas.md`: Atlas 운영 규칙 (실행 및 검증)
- `.clinerules/workflows/learn.md`: 학습 워크플로우 (구현 가이드)
- `.clinerules/workflows/done.md`: 완료 검증 워크플로우 (채점 및 검증)
- `.clinerules/workflows/hint.md`: 힌트 제공 워크플로우
- `.clinerules/workflows/review.md`: 코드 검토 워크플로우
- `.clinerules/workflows/fix.md`: 오류 수정 워크플로우
- `.clinerules/workflows/list.md`: 학습 진도 조회 워크플로우

## Functions
각 규칙 파일의 내부 로직 구현:
- Sisyphus: 사용자 입력을 분석하여 작업 유형 판단
- Prometheus: 복잡한 작업의 구조 설계 및 계획 수립
- Atlas: Prometheus의 계획을 구체화하고 실행, 검증

## Classes
Minerva 시스템은 클래스 기반의 구현이 아닌 텍스트 기반 규칙과 워크플로우를 사용하므로 별도의 클래스 정의는 없습니다.

## Dependencies
- Cline 시스템의 XML 문법을 따른다.
- JetBrains MCP 도구 사용 규칙 준수
- TDD 원칙 및 Kent Beck 원칙 기반

## Testing
- 각 규칙 및 워크플로우가 문서에 명시된 대로 작동하는지 검증
- 작업 흐름이 정의된 대로 동작하는지 확인
- XML 구조가 올바르게 작성되었는지 검증

## Implementation Order
1. `.clinerules/sisyphus.md` 생성 (메인 오케스트레이터)
2. `.clinerules/prometheus.md` 생성 (전략 계획가)
3. `.clinerules/atlas.md` 생성 (운영자)
4. `.clinerules/workflows/learn.md` 생성
5. `.clinerules/workflows/done.md` 생성
6. `.clinerules/workflows/hint.md` 생성
7. `.clinerules/workflows/review.md` 생성
8. `.clinerules/workflows/fix.md` 생성
9. `.clinerules/workflows/list.md` 생성

## Task Progress
- [x] Sisyphus 규칙 파일 생성
- [ ] Prometheus 규칙 파일 생성
- [ ] Atlas 규칙 파일 생성
- [ ] 학습 워크플로우 파일 생성
- [ ] 완료 검증 워크플로우 파일 생성
- [ ] 힌트 제공 워크플로우 파일 생성
- [ ] 코드 검토 워크플로우 파일 생성
- [ ] 오류 수정 워크플로우 파일 생성
- [ ] 진도 조회 워크플로우 파일 생성