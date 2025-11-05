---
name: codex
description: Use when the user asks to run Codex CLI (codex exec, codex resume) or references OpenAI Codex for code analysis, refactoring, or automated editing
---

# Codex Skill Guide

## Running a Task

**Assumption**: Permissions (sandbox modes, git checks, etc.) are configured globally in codex settings. Don't pass permission flags unless user explicitly requests specific overrides.

1. Ask the user (via `AskUserQuestion`) which model to run (`gpt-5` or `gpt-5-codex`) AND which reasoning effort to use (`low`, `medium`, or `high`) in a **single prompt with two questions**.
2. Assemble the command with configuration options:
   - `-m, --model <MODEL>`
   - `--config model_reasoning_effort="<low|medium|high>"`
   - `-C, --cd <DIR>` (if running from different directory)
3. **IMPORTANT**: By default, append `2>/dev/null` to all `codex exec` commands to suppress thinking tokens (stderr). Only show stderr if the user explicitly requests to see thinking tokens or if debugging is needed.
4. Run the command, capture stdout/stderr (filtered as appropriate), and summarize the outcome for the user.
5. **After Codex completes**, inform the user: "You can resume this Codex session at any time by saying 'codex resume' or asking me to continue with additional analysis or changes."

### Resuming Sessions
When continuing a previous session, use `codex exec resume --last` via stdin. Don't add configuration flags when resuming unless user explicitly requests changes.

Resume syntax: `echo "your prompt here" | codex exec resume --last 2>/dev/null`

### Quick Reference
| Use case | Command pattern |
| --- | --- |
| New task | `codex exec -m <model> --config model_reasoning_effort="<level>" <prompt> 2>/dev/null` |
| Resume session | `echo "prompt" \| codex exec resume --last 2>/dev/null` |
| Run from another directory | `codex exec -C <DIR> -m <model> --config model_reasoning_effort="<level>" <prompt> 2>/dev/null` |
| Override sandbox (rare) | Add `--sandbox <mode>` only if user explicitly requests it |

## Following Up
- After every `codex` command, immediately use `AskUserQuestion` to confirm next steps, collect clarifications, or decide whether to resume with `codex exec resume --last`.
- When resuming, pipe the new prompt via stdin: `echo "new prompt" | codex exec resume --last 2>/dev/null`. The resumed session automatically uses the same model, reasoning effort, and sandbox mode from the original session.
- Restate the chosen model, reasoning effort, and sandbox mode when proposing follow-up actions.

## Error Handling
- Stop and report failures whenever `codex --version` or a `codex exec` command exits non-zero; request direction before retrying.
- If user requests specific sandbox overrides (`--sandbox danger-full-access`, `--full-auto`), confirm via AskUserQuestion before applying.
- When output includes warnings or partial results, summarize them and ask how to adjust using `AskUserQuestion`.
