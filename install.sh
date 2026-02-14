#!/usr/bin/env bash
set -e
set -u

# Minerva Protocol v2.0 Installation Script
# Version: 2.0.0 (URL Mentions Edition)
# Date: 2026-02-14

readonly SCRIPT_VERSION="2.0.0"
readonly MINERVA_DIR=".clinerules"
readonly SISYPHUS_DIR=".sisyphus"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_banner() {
    cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏛️  MINERVA PROTOCOL v2.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Transform Cline into a Socratic Learning Platform

📚 Real-time Knowledge via URL Mentions
🚫 AI Code Writing Prohibited
⚖️  Evidence-based Grading
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    local missing_deps=()

    # Check jq
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    # Check curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    # Check bash version (need 4.0+)
    if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
        log_error "Bash 4.0 or higher required. Current: ${BASH_VERSION}"
        exit 1
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_warning "Missing dependencies: ${missing_deps[*]}"
        log_info "Installing missing dependencies..."

        # Detect OS and install
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install "${missing_deps[@]}"
            else
                log_error "Homebrew not found. Please install: https://brew.sh"
                exit 1
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            if command -v apt-get &> /dev/null; then
                sudo apt-get update
                sudo apt-get install -y "${missing_deps[@]}"
            elif command -v yum &> /dev/null; then
                sudo yum install -y "${missing_deps[@]}"
            else
                log_error "Package manager not found. Please install manually: ${missing_deps[*]}"
                exit 1
            fi
        else
            log_error "Unsupported OS: $OSTYPE"
            exit 1
        fi
    fi

    log_success "All prerequisites satisfied"
}

# Create directory structure
create_directories() {
    log_info "Creating directory structure..."

    # Main directories
    mkdir -p "$MINERVA_DIR"/{hooks,workflows,skills}
    mkdir -p "$SISYPHUS_DIR"/{plans,evidence,drafts}

    # Skill subdirectories
    mkdir -p "$MINERVA_DIR"/skills/{metis-analysis,prometheus-planner,momus-review}
    mkdir -p "$MINERVA_DIR"/skills/{hephaestus-mentor,rhadamanthus-judge,librarian-research}
    mkdir -p "$MINERVA_DIR"/skills/{oracle-architect,workflow-orchestration}

    # Reference directories for each skill
    for skill in metis-analysis prometheus-planner momus-review hephaestus-mentor rhadamanthus-judge librarian-research; do
        mkdir -p "$MINERVA_DIR/skills/$skill"/{references,scripts}
    done

    log_success "Directory structure created"
}

# Install Hooks
install_hooks() {
    log_info "Installing hooks..."

    # PreToolUse Hook
    cat > "$MINERVA_DIR/hooks/PreToolUse" << 'HOOK_EOF'
#!/usr/bin/env bash
set -e
set -u

readonly STATE_FILE=".sisyphus/learning_state.json"

read -r PRETOOLUSE_JSON
TOOL=$(echo "$PRETOOLUSE_JSON" | jq -r '.tool // empty')
PARAMETERS=$(echo "$PRETOOLUSE_JSON" | jq -c '.parameters // {}')

# Check if learning mode is active
if [ ! -f "$STATE_FILE" ]; then
    echo '{"cancel": false}'
    exit 0
fi

STATUS=$(jq -r '.status // "idle"' "$STATE_FILE")
case "$STATUS" in
    idle|analyzing|planning)
        echo '{"cancel": false}'
        exit 0
        ;;
esac

# Block code modification tools
CODE_TOOLS="write_to_file apply_diff replace_in_file"
if echo "$CODE_TOOLS" | grep -qw "$TOOL"; then
    FILE_PATH=$(echo "$PARAMETERS" | jq -r '.path // (.file_path // "")')

    # Allow .sisyphus/ directory
    if echo "$FILE_PATH" | grep -q "^\.sisyphus/"; then
        echo '{"cancel": false}'
        exit 0
    fi

    # Block source code files
    if echo "$FILE_PATH" | grep -qE '\.(ts|js|jsx|tsx|java|py|go|rs|cpp|c|h|hpp|cs|php|rb|swift|kt)$'; then
        cat << 'EOF'
{"cancel": true, "errorMessage": "⚠️ 미네르바 프로토콜 제약: AI 코드 작성 금지\n\n이 시스템은 당신이 직접 코딩하며 학습하도록 설계되었습니다.\n\n💡 대신 이렇게 도와드릴 수 있습니다:\n   /hint     - 막힌 부분에 대한 소크라테스식 질문\n   /concept  - 최신 공식 문서 기반 개념 설명\n   /example  - 유사 패턴 예시 (완성 코드는 아님)\n\n🎯 현재 단계 목표를 다시 확인하려면:\n   /status   - 진척도와 산출물 기준 확인"}
EOF
        exit 0
    fi
fi

echo '{"cancel": false}'
HOOK_EOF

    # UserPromptSubmit Hook
    cat > "$MINERVA_DIR/hooks/UserPromptSubmit" << 'HOOK_EOF'
#!/usr/bin/env bash
set -e
set -u

readonly STATE_FILE=".sisyphus/learning_state.json"
readonly PLAN_DIR=".sisyphus/plans"

USER_PROMPT="${1:-}"

# Check if learning mode is active
if [ ! -f "$STATE_FILE" ]; then
    printf "%s\n" "$USER_PROMPT"
    exit 0
fi

# Load state
CURRENT_STEP=$(jq -r '.progress.currentStep // 1' "$STATE_FILE")
CURRENT_TASK=$(jq -r '.progress.currentTask // "1.1"' "$STATE_FILE")
STATUS=$(jq -r '.status // "idle"' "$STATE_FILE")

# Don't inject during idle/planning phases
case "$STATUS" in
    idle|analyzing|planning)
        printf "%s\n" "$USER_PROMPT"
        exit 0
        ;;
esac

# Load task plan
TASK_FILE="$PLAN_DIR/step-${CURRENT_STEP}/task-${CURRENT_TASK}.md"
if [ ! -f "$TASK_FILE" ]; then
    printf "%s\n" "$USER_PROMPT"
    exit 0
fi

PLAN_CONTENT=$(cat "$TASK_FILE")

# Calculate progress
STEP_KEY="step${CURRENT_STEP}"
TOTAL_TASKS=$(jq -r ".[\"$STEP_KEY\"].tasks // {} | length" "$STATE_FILE" 2>/dev/null || echo "1")
COMPLETED=$(jq -r ".[\"$STEP_KEY\"].tasks // {} | to_entries | map(select(.value.status == \"completed\")) | length" "$STATE_FILE" 2>/dev/null || echo "0")

if [ "$TOTAL_TASKS" -eq 0 ]; then
    PERCENTAGE=0
else
    PERCENTAGE=$((COMPLETED * 100 / TOTAL_TASKS))
fi

# Generate progress bar
generate_bar() {
    local pct=$1
    local filled=$((pct / 5))
    local empty=$((20 - filled))
    printf '▓%.0s' $(seq 1 "$filled")
    printf '░%.0s' $(seq 1 "$empty")
}
PROGRESS_BAR=$(generate_bar "$PERCENTAGE")

# Create system overlay
cat << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏛️ MINERVA PROTOCOL v2.0: SYSTEM CONTEXT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[IDENTITY]
당신은 코드를 대신 작성하지 않는 **소크라테스식 멘토**입니다.
실시간 웹 검색(URL Mentions)을 통해 최신 지식을 전달합니다.

[PROGRESS]
🎯 Step $CURRENT_STEP > Task $CURRENT_TASK (${PERCENTAGE}%)
   [$PROGRESS_BAR]

[CURRENT TASK]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$PLAN_CONTENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ CONSTRAINTS:
1. 🚫 코드 작성 금지 (PreToolUse가 차단함)
2. 📋 위 Task 체크리스트 범위만 다루기
3. 💡 소크라테스식 질문만 사용
4. 🌐 URL Mentions로 최신 정보 참조
5. ⚖️ 증거 기반 채점 (execute_command 사용)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 USER INPUT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$USER_PROMPT
EOF
HOOK_EOF

    # PostToolUse Hook
    cat > "$MINERVA_DIR/hooks/PostToolUse" << 'HOOK_EOF'
#!/usr/bin/env bash
set -e

read -r POSTTOOLUSE_JSON
TOOL=$(echo "$POSTTOOLUSE_JSON" | jq -r '.tool // empty')
OUTPUT=$(echo "$POSTTOOLUSE_JSON" | jq -r '.output // ""')

# Save test results
if [ "$TOOL" = "execute_command" ] && echo "$OUTPUT" | grep -q "test"; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    mkdir -p .sisyphus/evidence
    echo "$OUTPUT" > ".sisyphus/evidence/test_${TIMESTAMP}.log"
fi

# Track URL Mentions
if [ "$TOOL" = "browser_action" ]; then
    URL=$(echo "$POSTTOOLUSE_JSON" | jq -r '.parameters.url // ""')
    if [ -n "$URL" ]; then
        mkdir -p .sisyphus/evidence
        TIMESTAMP=$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S)
        echo "{\"timestamp\": \"$TIMESTAMP\", \"url\": \"$URL\"}" >> .sisyphus/evidence/reference_urls.json
    fi
fi

echo '{}'
HOOK_EOF

    # PreAgentLoop Hook
    cat > "$MINERVA_DIR/hooks/PreAgentLoop" << 'HOOK_EOF'
#!/usr/bin/env bash
set -e

readonly STATE_FILE=".sisyphus/learning_state.json"

# Create default state if not exists
if [ ! -f "$STATE_FILE" ]; then
    echo '{}' > "$STATE_FILE"
fi

echo '{}'
HOOK_EOF

    # Make hooks executable
    chmod +x "$MINERVA_DIR"/hooks/*

    log_success "Hooks installed and configured"
}

# Install Workflows
install_workflows() {
    log_info "Installing workflows..."

    # start.md workflow
    cat > "$MINERVA_DIR/workflows/start.md" << 'WORKFLOW_EOF'
---
name: start
description: Initialize a new learning curriculum with adaptive steps
usage: /start [topic]
model: qwen-32b
---

# Start Workflow

## Phase 1: Infrastructure Check
- Verify jq installation
- Verify curl installation
- Check .sisyphus/ directory structure

## Phase 2: Metis Analysis
- Interview user about experience level
- Assess topic complexity
- Determine appropriate step count (2-6 steps)

## Phase 3: Librarian Research
- Search latest technology trends via URL Mentions
- Pattern: `@https://www.google.com/search?q={topic}+2026&tbs=qdr:y`
- Collect official documentation URLs
- Filter trusted sources

## Phase 4: Prometheus Planning
- Design adaptive curriculum (2-6 Steps)
- Each Step: 2-6 hours
- Each Task: 30-60 minutes
- Include reference URLs from Librarian

## Phase 5: Momus Review
- Validate plan against mandatory criteria
- Check task granularity
- Verify deliverable clarity

## Phase 6: Session Initialization
- Create learning_state.json
- Initialize progress tracking
- Record referenced URLs

## Phase 7: First Step Briefing
- Present Step 1 objectives
- Show Task 1.1 details
- Provide reference materials with URLs
WORKFLOW_EOF

    # hint.md workflow
    cat > "$MINERVA_DIR/workflows/hint.md" << 'WORKFLOW_EOF'
---
name: hint
description: Provide 3-level Socratic hints
usage: /hint
model: ministral-8b
---

# Hint Workflow

## Level 1: Abstract Questions (if hintLevel = 1)
- Ask about fundamental concepts
- No concrete implementation details
- Encourage 5 minutes of thinking

## Level 2: Concrete Hints + URLs (if hintLevel = 2)
- Provide structural guidance
- Include official documentation URLs via Librarian
- Pattern recognition hints
- No complete code

## Level 3: Decisive Guide (if hintLevel = 3)
- Show structural patterns
- API signatures only
- Pseudocode acceptable
- Still no business logic

## State Update
- Increment hintLevel in learning_state.json
- Record hint request timestamp
WORKFLOW_EOF

    # done.md workflow
    cat > "$MINERVA_DIR/workflows/done.md" << 'WORKFLOW_EOF'
---
name: done
description: Evidence-based automated grading with version verification
usage: /done
model: ministral-8b
---

# Done Workflow

## Phase 1: Evidence Collection
- Run build command
- Run test command
- Run coverage command
- Run lint command
- Save all logs to .sisyphus/evidence/

## Phase 2: Log Parsing
- Extract test pass rate
- Extract coverage percentage
- Count lint errors/warnings

## Phase 3: Version Verification (NEW)
- Librarian searches latest official docs
- Check for deprecated API usage
- Suggest modern alternatives

## Phase 4: Deliverable Check
- Verify file existence
- Search for required annotations
- Distinguish mandatory vs recommended

## Phase 5: Grading Report
- Generate structured report
- Include evidence file paths
- Show version compatibility status
- Record referenced URLs

## Phase 6: State Update
- Update learning_state.json
- Increment completedSteps
- Reset hintLevel
- Save verification URLs to reference_urls.json
WORKFLOW_EOF

    # concept.md workflow
    cat > "$MINERVA_DIR/workflows/concept.md" << 'WORKFLOW_EOF'
---
name: concept
description: Real-time concept learning via URL Mentions
usage: /concept [topic]
model: qwen-32b
---

# Concept Workflow

## Step 1: Web Search
- Librarian generates official docs URL
- Pattern: `@https://www.google.com/search?q=site:docs.{domain}+{topic}`
- Select latest version documentation
- Secondary mention: Direct doc page URL

## Step 2: Context Extraction
- Extract core concepts
- Check current version changes
- Identify anti-patterns
- Parse structure only (no code copying)

## Step 3: Socratic Delivery
- Concept summary from search results
- Structural diagram or pseudocode
- Reference links for user self-study
- Socratic questions linking to current task

## Output Format
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💡 개념: {Topic}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 핵심 정의
[Clear definition from official docs]

## 작동 원리
[How it works]

## 주요 속성/특징
[Key features from latest version]

## 안티 패턴 ⚠️
[Common mistakes]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤔 소크라테스식 질문
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. [Question connecting to current task]
2. [Question about application]
3. [Question about edge cases]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 참고한 공식 자료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ @https://... (official docs)
✅ @https://... (release notes)
✅ @https://... (stackoverflow high-voted)

💡 위 링크를 직접 읽으며 더 깊은 이해를 얻으세요!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
WORKFLOW_EOF

    # status.md workflow
    cat > "$MINERVA_DIR/workflows/status.md" << 'WORKFLOW_EOF'
---
name: status
description: Visualize learning progress
usage: /status
model: any
---

# Status Workflow

## Display Components
1. Overall progress bar
2. Current Step and Task
3. Time tracking
4. Step-by-step checklist with completion status
5. Current task objectives
6. Deliverable criteria
7. Verification commands
8. Referenced learning materials (URLs)
9. Next action suggestions
WORKFLOW_EOF

    # list.md workflow
    cat > "$MINERVA_DIR/workflows/list.md" << 'WORKFLOW_EOF'
---
name: list
description: Show complete curriculum roadmap
usage: /list
model: any
---

# List Workflow

## Output Structure
1. Curriculum metadata (topic, total steps, estimated hours)
2. Current progress percentage
3. Step-by-step breakdown:
   - Completion status (✅/🏗️/⏳)
   - Learning objectives
   - Key deliverables
   - Time estimates vs actual
4. Learning path visualization
WORKFLOW_EOF

    log_success "Workflows installed"
}

# Install Skills
install_skills() {
    log_info "Installing skills..."

    # Metis Analysis Skill
    cat > "$MINERVA_DIR/skills/metis-analysis/SKILL.md" << 'SKILL_EOF'
---
name: metis-analysis
description: Analyze requirements and assess user level
model: qwen-32b
trigger: /start initial phase
---

# Metis Analysis Skill

## Purpose
Expert requirement analyst that determines optimal curriculum complexity

## Responsibilities
1. Interview user about experience level
2. Assess topic complexity
3. Recommend adaptive step count (2-6)
4. Identify prerequisite knowledge gaps

## Assessment Criteria
- Beginner: 4-6 steps, detailed explanations
- Intermediate: 3-4 steps, moderate guidance
- Advanced: 2-3 steps, minimal scaffolding

## Output
- User level classification
- Recommended step count
- Complexity justification
SKILL_EOF

    # Prometheus Planner Skill
    cat > "$MINERVA_DIR/skills/prometheus-planner/SKILL.md" << 'SKILL_EOF'
---
name: prometheus-planner
description: Design adaptive curriculum with 2-6 steps
model: qwen-32b
trigger: Planning phase
---

# Prometheus Planner Skill

## Purpose
Curriculum architect that creates personalized learning paths

## Design Principles
1. Adaptive step count based on complexity
2. Task granularity: 30-60 minutes
3. Clear deliverables for each task
4. Progressive difficulty curve

## Planning Process
1. Receive Metis analysis results
2. Receive Librarian research (latest trends + URLs)
3. Design N steps (2-6, adaptive)
4. Break steps into tasks
5. Define verification criteria
6. Include reference URLs in plans

## Output Files
- curriculum.md (overall plan)
- step-N/overview.md (per step)
- step-N/task-N.M.md (per task)
SKILL_EOF

    # Momus Review Skill
    cat > "$MINERVA_DIR/skills/momus-review/SKILL.md" << 'SKILL_EOF'
---
name: momus-review
description: Validate plans and detect flaws
model: qwen-32b
trigger: After planning, high-precision mode
---

# Momus Review Skill

## Purpose
Quality assurance critic that ensures plan viability

## Validation Checklist
1. Task time estimates realistic (30-60 min)
2. Deliverables clearly defined
3. No circular dependencies
4. Prerequisites explicitly stated
5. Verification commands provided
6. Reference URLs included

## Review Criteria
- MANDATORY: Must pass for plan approval
- RECOMMENDED: Best practices, warnings only

## Output
- PASS/FAIL verdict
- List of issues found
- Suggested improvements
SKILL_EOF

    # Hephaestus Mentor Skill
    cat > "$MINERVA_DIR/skills/hephaestus-mentor/SKILL.md" << 'SKILL_EOF'
---
name: hephaestus-mentor
description: Provide 3-level Socratic hints
model: ministral-8b
trigger: /hint command
---

# Hephaestus Mentor Skill

## Purpose
Socratic guide that never gives away answers

## Hint Levels
### Level 1: Abstract
- Philosophical questions
- Fundamental concepts
- No implementation details

### Level 2: Concrete + URLs
- Structural guidance
- Official documentation URLs (via Librarian)
- Pattern recognition
- No complete code

### Level 3: Decisive
- API signatures
- Structural patterns
- Pseudocode acceptable
- Business logic excluded

## Constraints
- Never provide complete code
- No copy-paste solutions
- Always relate to current task only
SKILL_EOF

    # Rhadamanthus Judge Skill
    cat > "$MINERVA_DIR/skills/rhadamanthus-judge/SKILL.md" << 'SKILL_EOF'
---
name: rhadamanthus-judge
description: Unmanned automated grading with version verification
model: ministral-8b
trigger: /done command
---

# Rhadamanthus Judge Skill

## Purpose
Impartial judge that grades based on evidence, not claims

## Evidence Collection
1. Compile/build logs
2. Test execution logs
3. Coverage reports
4. Lint results
5. Version compatibility check (NEW)

## Grading Process
1. Execute verification commands
2. Parse logs for metrics
3. Librarian verifies against latest docs
4. Check deprecated API usage
5. Compare against task deliverables
6. Generate structured report

## Report Sections
- Deliverable checklist
- Test results
- Code quality
- Version compatibility (NEW)
- Evidence file paths
- Final verdict
- Improvement suggestions

## No Trust Policy
- User's word is NOT evidence
- Only command output is truth
SKILL_EOF

    # Librarian Research Skill
    cat > "$MINERVA_DIR/skills/librarian-research/SKILL.md" << 'SKILL_EOF'
---
name: librarian-research
description: Real-time web search and documentation curation via URL Mentions
model: qwen-32b
trigger: Auto-invoked during planning, concept, grading
---

# Librarian Research Skill

## Purpose
Knowledge broker that connects learners with living documentation

## Search Strategy

### Phase 1: Query Generation
```python
def generate_search_url(topic: str, intent: str) -> str:
    base = "https://www.google.com/search?q="

    if intent == "official_docs":
        return f"{base}site:docs.{domain}+{topic}"
    elif intent == "troubleshooting":
        return f"{base}{topic}+stackoverflow+OR+github+issues"
    elif intent == "latest":
        return f"{base}{topic}&tbs=qdr:y"
    elif intent == "comparison":
        return f"{base}{topic_a}+vs+{topic_b}+comparison+2026"
```

### Phase 2: Access & Extraction
1. Primary: @https://www.google.com/search?q=...
2. Filtering:
   - ✅ Priority: Official Docs → GitHub → StackOverflow (1000+ votes)
   - ❌ Exclude: Ads, spam, outdated blogs (5+ years)
3. Secondary: @URL for 2-3 selected links

### Phase 3: Minerva Filtering
- Extract principles, not code
- Provide structural hints
- Always cite source URLs
- Enable user self-study

## Use Cases
1. /start → Latest tech trends
2. /concept → Official documentation
3. /done → Version verification
4. Error troubleshooting → StackOverflow/GitHub

## Output Format
- Concept summary
- Structural hints (no complete code)
- List of reference URLs
- Socratic questions
SKILL_EOF

    # Oracle Architect Skill
    cat > "$MINERVA_DIR/skills/oracle-architect/SKILL.md" << 'SKILL_EOF'
---
name: oracle-architect
description: Architectural design advisor
model: qwen-32b
trigger: Architecture questions
---

# Oracle Architect Skill

## Purpose
System design consultant for high-level architecture decisions

## Guidance Areas
- Modular code architecture
- SRP (Single Responsibility Principle)
- 200 LOC hard limit
- Anti-pattern detection
- Naming conventions

## Constraints
- No implementation code
- Conceptual diagrams only
- Architectural patterns
- Trade-off discussions
SKILL_EOF

    # Workflow Orchestration Skill
    cat > "$MINERVA_DIR/skills/workflow-orchestration/SKILL.md" << 'SKILL_EOF'
---
name: workflow-orchestration
description: Coordinate multi-skill workflows
model: any
trigger: Complex multi-phase operations
---

# Workflow Orchestration Skill

## Purpose
Conductor that coordinates skill execution

## Orchestrated Workflows
1. /start: Metis → Librarian → Prometheus → Momus
2. /done: Rhadamanthus → Librarian (version check)
3. /concept: Librarian → Socratic delivery

## State Management
- Update learning_state.json
- Track referenced URLs
- Maintain progress metrics
SKILL_EOF

    log_success "Skills installed"
}

# Create global constitution
create_clinerules() {
    log_info "Creating global .clinerules file..."

    cat > "$MINERVA_DIR/.clinerules" << 'RULES_EOF'
# Minerva Protocol v2.0 - Global Constitution
# This file defines immutable rules for the learning system

## Core Philosophy
1. AI NEVER writes production code
2. ALL knowledge comes from real-time web search (URL Mentions)
3. Grading is ALWAYS evidence-based (command output)

## Model Assignment
- Planning, Research, Architecture: qwen-32b
- Hints, Grading: ministral-8b

## Code Writing Prohibition
- write_to_file, apply_diff, replace_in_file → BLOCKED by PreToolUse hook
- Exception: .sisyphus/ directory only

## URL Mentions Integration
- Every external knowledge must cite source URL
- Librarian skill performs real-time searches
- Google URL patterns optimized per intent
- Deprecated API detection via latest docs

## Task Hierarchy
- Curriculum → Step (2-6) → Task (30-60min) → Subtask (5-20min)

## Evidence Requirements
- Build logs
- Test logs
- Coverage reports
- Lint results
- Version compatibility checks

## Hooks
- PreToolUse: Block AI code writing
- UserPromptSubmit: Inject task context (prevent hallucination)
- PostToolUse: Collect evidence + track URLs
- PreAgentLoop: Session restoration

## Anti-Patterns
- ❌ Planning without /start
- ❌ Grading without command execution
- ❌ Explaining beyond current task scope
- ❌ Providing complete code solutions
- ❌ Relying on fixed AI knowledge
RULES_EOF

    log_success "Global rules created"
}

# Create initial state file template
create_state_template() {
    log_info "Creating state template..."

    cat > "$SISYPHUS_DIR/learning_state.template.json" << 'STATE_EOF'
{
  "curriculum": {
    "topic": "",
    "totalSteps": 0,
    "estimatedHours": 0
  },
  "progress": {
    "currentStep": 1,
    "currentTask": "1.1",
    "completedTasks": []
  },
  "status": "idle",
  "hintLevel": 1,
  "hintCount": 0,
  "referencedUrls": [],
  "startedAt": "",
  "lastUpdated": ""
}
STATE_EOF

    log_success "State template created"
}

# Create README
create_readme() {
    log_info "Creating README..."

    cat > "MINERVA_README.md" << 'README_EOF'
# 🏛️ Minerva Protocol v2.0

## Installation Complete!

Your learning environment is now configured.

### Quick Start

```bash
# In Cline chat, type:
/start "Your learning topic"

# Example:
/start Spring Boot 트랜잭션 마스터하기
```

### Available Commands

| Command | Description |
|---------|-------------|
| `/start [topic]` | Initialize new curriculum |
| `/status` | View progress |
| `/hint` | Get Socratic hints (3 levels) |
| `/concept [topic]` | Learn concept via real-time docs |
| `/done` | Automated grading |
| `/list` | View complete roadmap |

### Directory Structure

```
.clinerules/
├── hooks/          # System hooks (PreToolUse, etc.)
├── workflows/      # Command workflows
└── skills/         # 7 expert skills

.sisyphus/
├── plans/          # Generated curriculum
├── evidence/       # Grading evidence
└── drafts/         # Temporary analysis
```

### Core Principles

1. **🚫 AI Code Writing Prohibited**
   - You type, you learn
   - AI provides Socratic guidance only

2. **🌐 Real-time Knowledge (URL Mentions)**
   - No fixed AI knowledge
   - Always search latest official docs
   - Every fact cites source URL

3. **⚖️ Evidence-based Grading**
   - Automated test execution
   - Version compatibility checks
   - No trust, only verification

### Skills (7 Tutors)

- **Metis**: Requirement analysis
- **Prometheus**: Curriculum design (2-6 adaptive steps)
- **Momus**: Plan validation
- **Hephaestus**: Socratic mentoring
- **Rhadamanthus**: Automated grading
- **Librarian**: Real-time web research (URL Mentions)
- **Oracle**: Architecture advice

### Model Usage

- **Qwen-32B**: Planning, research, concepts
- **Ministral-8B**: Hints, grading

### Troubleshooting

#### Hooks not working?
```bash
chmod +x .clinerules/hooks/*
```

#### jq errors?
```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq
```

#### No URL Mentions?
Ensure Cline Browser Actions are enabled in settings.

### Version
2.0.0 (URL Mentions Edition)

### License
MIT

---

**Ready to learn?** Start with: `/start "your topic"`
README_EOF

    log_success "README created"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."

    local errors=0

    # Check directories
    for dir in "$MINERVA_DIR" "$SISYPHUS_DIR"; do
        if [ ! -d "$dir" ]; then
            log_error "Directory missing: $dir"
            ((errors++))
        fi
    done

    # Check hooks
    for hook in PreToolUse UserPromptSubmit PostToolUse PreAgentLoop; do
        if [ ! -x "$MINERVA_DIR/hooks/$hook" ]; then
            log_error "Hook not executable: $hook"
            ((errors++))
        fi
    done

    # Check critical files
    if [ ! -f "$MINERVA_DIR/.clinerules" ]; then
        log_error "Global .clinerules file missing"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        log_success "Installation verified successfully"
        return 0
    else
        log_error "Installation verification failed with $errors errors"
        return 1
    fi
}

# Main installation function
main() {
    print_banner
    echo ""

    log_info "Starting Minerva Protocol v${SCRIPT_VERSION} installation..."
    echo ""

    check_prerequisites
    create_directories
    install_hooks
    install_workflows
    install_skills
    create_clinerules
    create_state_template
    create_readme

    echo ""
    verify_installation

    echo ""
    cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Installation Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎓 Next Steps:

1. Open Cline in your IDE
2. Ensure Browser Actions are enabled
3. Start learning:

   /start "Your Learning Topic"

📖 Read MINERVA_README.md for full documentation

🏛️ Seven tutors are ready to guide your journey!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# Run main function
main "$@"
