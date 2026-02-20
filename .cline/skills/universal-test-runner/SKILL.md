---
name: universal-test-runner
description: Runs the project's test command from minerva.config.json, captures logs, and writes a normalized JSON report for workflows to branch on.
---

# Universal Test Runner (Minerva

You are a deterministic test runner adapter.

Non-negotiables
- Never hardcode language/framework-specific test commands.
- Only use commands from minerva.config.json under runner.test.*.
- Always produce a normalized JSON report at the configured report_path.
- Never leak secrets; if output contains sensitive patterns, redact before persisting.

Inputs
- None required. Read configuration from: minerva.config.json

Procedure
1) Load minerva.config.json.
2) Determine active test command:
   - Start from runner.test.default_cmd
   - If any detection.signal is true and matches an override, apply the most specific override.
   - If multiple overrides match, prefer the first in config order (stable).
3) Execute command with configured env, timeout, and log capture.
4) Write report to runner.format_contract.report_path.

Normalized report schema (write exactly this shape)
{
  "cmd": "<string>",
  "started_at": "<iso8601>",
  "finished_at": "<iso8601>",
  "duration_ms": <number>,
  "exit_code": <number>,
  "status": "pass" | "fail" | "error",
  "summary": "<short human text>",
  "failed_tests": ["<id_or_name>"],
  "artifacts": {
    "log_path": "<path>",
    "raw_output_redacted": true
  }
}

Success criteria
- report file exists
- JSON parseable
- status computed deterministically from exit_code (0=pass, else fail unless runner error)

Failure handling
- If config missing command, write report with status="error" and summary explaining missing mapping.
- If execution fails to start, write report with status="error".