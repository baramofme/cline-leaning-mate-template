---
name: builtin-context-summary
description: Context Summary skill for Minerva system
usage: Memory compression and context injection guidance
model: qwen-32b
---

# 📊 Context Summary Skill

## Purpose
Minerva 시스템의 Context Builder를 통한 메모리 압축 및 주입 지침을 담당하며, 작업 컨텍스트를 효율적으로 관리합니다.

## 🎯 Primary Responsibilities
- **작업 컨텍스트 요약**
- **메모리 압축**
- **컨텍스트 주입**

## 🛠️ Implementation Details
- 작업 시작 전 `.sisyphus/tasks.json` 내용 요약하여 컨텍스트 생성
- 작업 진행 중 상태 업데이트 및 요약
- 작업 종료 후 최종 요약 정보 저장
- 작업 컨텍스트를 효율적으로 관리

## ✅ Validation
- 컨텍스트 요약 정확성 검증
- 메모리 압축 효과 확인
- 컨텍스트 주입 완료 여부 검증

## 📋 Common Constraints
- **Identity Sync**: Librarian(표준), Momus(비판), Rhadamanthus(증거)의 기준을 준수하십시오.
- **TDD First**: 모든 구현 모드에서 테스트 코드 선행 원칙을 최우선으로 합니다.