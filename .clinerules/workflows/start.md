# 🚀 /start: Infrastructure Setup & Minerva Initiation

이 워크플로우는 시스템의 의존성을 해결하고, 7인의 에이전트 파이프라인을 가동하여 사용자 맞춤형 학습 환경을 구축합니다.

## 1. Phase 1: Infrastructure & Self-Healing
가장 먼저 시스템 작동에 필요한 권한과 도구를 확보하십시오.

1. Hooks 권한 부여:
   - execute_command를 사용하여 모든 후크 스크립트에 실행 권한을 부여하십시오.
     chmod +x .clinerules/hooks/*.sh

2. 의존성 체크 및 자동 설치:
   - jq, curl 설치 여부를 확인하십시오.
   - 만약 설치되어 있지 않다면, 현재 OS를 감지하여 다음 명령어로 자동 설치를 시도하십시오.
      - macOS: brew install jq curl
      - Linux: sudo apt-get update && sudo apt-get install -y jq curl
      - Windows: choco install jq curl -y (설치 실패 시 사용자에게 수동 설치 요청)

## 2. Phase 2: Workspace Initialization
상태 영속성을 위한 물리적 폴더 구조를 생성하십시오.

1. 디렉토리 구축:
   - execute_command를 사용하여 다음 구조를 생성하십시오.
     mkdir -p .sisyphus/plans .sisyphus/evidence .sisyphus/drafts

## 3. Phase 3: Agent Pipeline Activation
본격적인 학습 컨텍스트 분석과 전략 수립 단계로 진입하십시오.

1. Metis - 의도 분석:
   - use_skill(name="metis-analysis")를 호출하십시오.
   - 학습자의 목표 기술 스택, 현재 숙련도, 학습 목적을 인터뷰하고 결과를 .sisyphus/drafts/analysis.md에 기록하십시오.

2. Prometheus & Momus - 로드맵 설계:
   - use_skill(name="prometheus-planner")를 호출하여 .sisyphus/plans/curriculum.md를 생성하십시오.
   - 생성된 계획은 Momus 페르소나의 지침에 따라 난이도와 실행 가능성을 스스로 검토(Self-Review)한 뒤 최종 확정하십시오.

3. 환경 구축:
   - 프로젝트 루트에 setup-env.sh가 존재한다면 execute_command로 실행하여 기술 스택별 도구 세팅을 완료하십시오.

## 4. Phase 4: Mission Briefing
진행 상황을 보고하고 사용자의 첫 액션을 유도하십시오.

1. 첫 단계 제시:
   - 확정된 계획의 Step 1을 사용자에게 상세히 설명하십시오.
   - 성공 기준(Rhadamanthus가 검증할 내용)을 명시하고, 구현을 시작하거나 /hint를 사용할 수 있음을 알리며 대기하십시오.