---
name: builtin-agent-orchestration
description: Agent Orchestration skill for Minerva system
usage: Managing agent calling rules and workflow orchestration
model: qwen-32b
---

# 🤝 Agent Orchestration Skill

## Purpose
Minerva 시스템의 에이전트 오케스트레이션 규약을 담당하며, 에이전트 호출 규칙과 워크플로우 조정을 수행합니다.

## 🎯 Primary Responsibilities
- **에이전트 호출 규칙 관리**
- **워크플로우 호출 및 조정**
- **작업 흐름의 정확한 순서 유지**
- **에이전트 간 협력 방식 정의**

## 🛠️ Implementation Details
- `call_rule`로 규칙 호출
- `call_workflow`로 워크플로우 호출
- 작업 흐름의 정확한 순서 유지
- 에이전트 간 협력 방식 정의

## ✅ Validation
- 에이전트 호출 정확성 검증
- 워크플로우 호출 완료 여부 확인
- 작업 흐름 조정 정확성 검증

## 📋 Common Constraints
- **Identity Sync**: Librarian(표준), Momus(비판), Rhadamanthus(증거)의 기준을 준수하십시오.
- **TDD First**: 모든 구현 모드에서 테스트 코드 선행 원칙을 최우선으로 합니다.