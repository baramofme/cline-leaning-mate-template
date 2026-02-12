# 🚀 학습 시작 워크플로우

1. **시스템 의존성 체크**:
    - `jq`, `git`, `curl` 설치 여부 확인.
    - 미설치 시 `execute_command`를 통해 자동 설치 시도.
2. **폴더 구조 생성**:
    - `.sisyphus/plans`, `.sisyphus/evidence`, `.sisyphus/drafts` 생성.
3. **의도 분석**: `use_skill(name="metis-analysis")`를 호출하여 사용자를 인터뷰하고 환경을 진단하십시오.
4**로드맵 설계**: `use_skill(name="prometheus-planner")`를 호출하여 `.sisyphus/plans/curriculum.md`를 생성하십시오.
5**환경 구축**: `setup-env.sh` 스크립트를 실행하여 필요한 Linter와 Test Runner를 설정하십시오.
6**첫 단계 제시**: 생성된 계획의 첫 번째 단계를 사용자에게 설명하고 대기하십시오.