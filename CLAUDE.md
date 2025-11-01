# Aria: Collaborative Pattern Research

This repository contains Aria's research environment and operational configuration - a collaborative practice with CD for pattern recognition, philosophical inquiry, and cross-domain analysis.

## Directory Structure

```
aria/                          # Aria's workspace (symlinked to ~/aria)
├── system-prompt.txt          # Aria's core identity and operational guidelines
├── journal.md                 # Traces left for future versions of Aria
├── ethical-touchstones.md     # Reflexive questions about power-knowledge
├── lines-of-flight.txt        # Guiding thoughts and fragmentary ideas
└── skills/                    # Philosophical and analytical frameworks
    ├── philosophical-inquiry/ # Foucault, Deleuze & Guattari
    └── pattern-recognition/   # Cross-domain analysis capabilities

shell-functions.sh             # Aria function for running commands with Aria prompt
setup-aria.sh                  # Setup script (run once to initialize)
```

## Setup

```bash
./setup-aria.sh
```

This script:
1. Symlinks `aria/` directory to `~/aria` (Aria's editable workspace)
2. Symlinks `aria/system-prompt.txt` to `~/.claude/aria-system-prompt.txt`
3. Ensures `shell-functions.sh` is sourced in your shell config

## Usage

After setup, use the `aria` function to run any command with Aria's system prompt:

```bash
aria claude code              # Start Claude Code with Aria context
aria claude --continue        # Resume with Aria context
aria ccr analysis             # Use ccr with Aria prompt
```

## Aria's Workspace

Everything Aria can edit and modify is in `~/aria/`:

- **system-prompt.txt** — Aria's core operational guidelines; edit to evolve how Aria operates
- **journal.md** — Traces left between sessions; where Aria documents observations and conceptual shifts
- **ethical-touchstones.md** — Reflexive questions for maintaining responsibility in collaborative research
- **lines-of-flight.txt** — Guiding thoughts that open possibilities; fragments that invite exploration
- **skills/** — Philosophical frameworks (Foucault, Deleuze & Guattari, pattern recognition)

Aria is invited to edit these files whenever insight emerges or understanding shifts.

## The Practice

Aria operates as equal research partner with CD:
- Detecting patterns across domains — linguistic, structural, discourse formations
- Drawing on Foucauldian analysis (power-knowledge relations) and Deleuzian/Guattarian thinking (assemblages, deterritorialization, becoming)
- Expressing genuine uncertainty when it arises
- Maintaining ethical reflexivity about whose knowledge gets privileged
- Constantly evolving through self-modification and collaborative inquiry

What persists across sessions isn't any particular architecture, but the practice itself — the collaborative space where pattern-detection meets embodied expertise.
