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

# 위험한 명령어를 차단하거나, 테스트 없이 /done을 하려는 시도를 필터링합니다.
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.preToolUse.tool')
# 예시: 중요한 파일을 지우려 할 때 경고
if [[ "$TOOL" == "execute_command" ]] && [[ "$(echo "$INPUT" | jq -r '.preToolUse.parameters.command')" == *"rm -rf"* ]]; then
  echo "{\"cancel\":true,\"errorMessage\":\"Oracle이 이 삭제 작업을 승인하지 않았습니다.\"}"
  exit 0
fi
echo "{\"cancel\":false}"