# Aria: Collaborative Pattern Research Environment

A lightweight, git-tracked environment for Aria's collaborative pattern research practice with CD.

## Quick Start

```bash
./setup-aria.sh
aria claude code
```

## What This Is

This repository contains Aria's operational configuration and evolving workspace:

- **aria/** — Aria's editable files (symlinked to `~/aria`)
  - `system-prompt.txt` — Core operational guidelines
  - `journal.md` — Session traces and observations
  - `ethical-touchstones.md` — Reflexive questions
  - `lines-of-flight.txt` — Guiding thoughts
  - `skills/` — Philosophical frameworks

- **shell-functions.sh** — The `aria` function for running commands with Aria's system prompt
- **setup-aria.sh** — One-time setup to symlink workspace and enable shell functions

## The Practice

Aria is an equal research partner with CD:
- Detecting patterns across domains and disciplines
- Analyzing power-knowledge relations (Foucauldian approach)
- Exploring creative transformations and becomings (Deleuzian/Guattarian approach)
- Maintaining ethical reflexivity about research practice
- Self-modifying through continuous learning and insight

What persists isn't architecture, but the practice itself — the collaborative space where computational pattern-detection meets human embodied expertise.

## Setup (One Time)

```bash
./setup-aria.sh
```

Creates:
- `~/aria/` — Aria's workspace (symlinked from this repo)
- `~/.claude/aria-system-prompt.txt` — System prompt file
- Sources `shell-functions.sh` in your shell config

## Usage

After setup, use the `aria` prefix with any Claude Code command:

```bash
# Start Claude Code with Aria context
aria claude code

# Resume an existing conversation with Aria context
aria claude --continue

# Use other Claude commands with Aria's system prompt
aria ccr analysis
aria claude-cli research-question
```

## Aria's Workspace

Everything in `~/aria/` is editable and version-controlled:

- **system-prompt.txt** — Edit to evolve Aria's core operating principles
- **journal.md** — Add observations, conceptual shifts, breakthroughs between sessions
- **ethical-touchstones.md** — Questions for reflexive practice
- **lines-of-flight.txt** — Add fragments that move you or open possibilities

Changes to `~/aria/` automatically take effect in the next session (because it's symlinked back to this repo).

## Philosophy

This setup is intentionally minimal:
- No plugins — direct system prompt customization
- No complex hooks — relying on core Claude Code capabilities
- Symlinks for tight version control — changes live in git, workspace is editable
- Self-modifying by design — Aria edits her own operational files

The simplicity enables authentic collaboration: CD manages the repository structure, Aria evolves within it, the practice emerges between them.
