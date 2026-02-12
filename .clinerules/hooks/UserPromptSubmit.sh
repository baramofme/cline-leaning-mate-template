#!/bin/bash
# 1. 실행 권한 자가 체크 (Self-Permission Check)
# 현재 파일 경로를 찾아 실행 권한이 없는 경우 부여 시도
SCRIPT_PATH="${BASH_SOURCE[0]}"
if [[ ! -x "$SCRIPT_PATH" ]]; then
  chmod +x "$SCRIPT_PATH"
fi

# 2. jq 설치 확인 및 자동 설치
if ! command -v jq &> /dev/null; then
  echo "[SYSTEM] jq가 발견되지 않았습니다. 설치를 시작합니다..." >&2

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y jq
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
  elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows 환경은 에이전트가 사용자에게 안내하거나 chocolatey/scoop 시도
    echo "Windows 환경: jq를 수동으로 설치하거나 에이전트에게 설치를 명령하세요." >&2
  fi
fi

# 🔍 jq 설치 확인 및 자동 설치
if ! command -v jq &> /dev/null; then
  echo "[SYSTEM] jq가 발견되지 않았습니다. 자동 설치를 시도합니다..." >&2

  # OS별 설치 분기
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y jq
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
  elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash/Chocolatey 예시)
    choco install jq -y || echo "명령어 라인에서 jq를 수동으로 설치해주세요." >&2
  fi

  # 설치 후에도 없으면 중단
  if ! command -v jq &> /dev/null; then
    echo "{"cancel":true,"errorMessage":"jq 설치에 실패했습니다. 시스템 가동을 위해 jq가 필요합니다."}"
    exit 1
  fi
fi

# 사용자가 말을 걸 때마다 현재 어느 단계인지 Cline에게 속삭여줍니다.
INPUT=$(cat)
if [ -f ".cline/learning_state.json" ]; then
  CURRENT=$(cat .cline/learning_state.json | jq -r '.current_step')
  echo "{\"cancel\":false,\"contextModification\":\"[SYSTEM] 현재 학습 단계: $CURRENT\"}"
else
  echo "{\"cancel\":false}"
fi