---
name: builtin-task-management
description: Task Management skill for Minerva system
usage: Managing tasks.json schema and task lifecycle management
model: qwen-32b
---

# 📋 Task Management Skill

## Purpose
Minerva 시스템의 tasks.json 스키마 및 태스크 생명주기 관리를 담당하며, 태스크 상태 관리와 작업 진행 상황 추적을 수행합니다.

## 🎯 Primary Responsibilities
- **태스크 상태 관리**
- **작업 진행 상황 추적**
- **메모리 관리**
- **컨텍스트 주입**

## 🛠️ Implementation Details
- `.sisyphus/tasks.json` 내용 요약하여 컨텍스트 생성
- 작업 상태 실시간 추적 및 관리
- 작업 시작 전/진행 중/종료 후 처리

## ✅ Validation
- 태스크 관리 정확성 검증
- 상태 추적 완료 여부 확인
- 메모리 압축 및 주입 검증

## 📋 Common Constraints
- **Identity Sync**: Librarian(표준), Momus(비판), Rhadamanthus(증거)의 기준을 준수하십시오.
- **TDD First**: 모든 구현 모드에서 테스트 코드 선행 원칙을 최우선으로 합니다.
