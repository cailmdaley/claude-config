# Claude Commands & Agents

**Prompt Development Repository** for scientific computing-focused Claude agents.

## ⚠️ Key Concept

**This repository is for writing prompts, not using them.**

- 📝 **What this repo does**: Provides a workspace to develop and version control Claude agent prompts
- ❌ **What this repo doesn't do**: Actually affect Claude Code behavior (files here are inactive templates)
- 🔗 **To activate prompts**: Must symlink to ~/.claude/agents/ directory as shown in workflow below

**Based on**: Excellent original collection, adapted for scientific data analysis and library development.

```
agents/                  # Specialized agents optimized for scientific computing
├── developer.md         # Scientific code implementation (★ active)
├── opinionated-editor.md # Code style and structure (★ active)
├── quality-reviewer.md  # Scientific code review (★ active)
├── snakemake-expert.md  # Workflow management specialist (★ active)
├── architect.md         # Solution design (original)
├── debugger.md          # Bug analysis (original)
└── technical-writer.md  # Documentation (original)
commands/                # Task execution patterns (original)
global-claude.md         # Global Claude configuration
setup-claude-config.sh   # Automated setup script
prompt-engineering.md    # Prompt optimization techniques (from Southbridge Research)
```

★ active = Automatically deployed by setup script

## Development Workflow

### 1. Edit Configuration Locally
Develop and test agent prompts and global configuration in this repository:
```bash
# Edit agents for scientific computing use cases
vim agents/developer.md
vim agents/quality-reviewer.md

# Edit global Claude configuration
vim global-claude.md
```

### 2. Deploy Configuration 
Run the automated setup script to deploy agents and configuration globally:
```bash
# Deploy all configuration with one command
./setup-claude-config.sh

# Verify setup (optional)
ls -la ~/CLAUDE.md ~/.claude/agents/
```

The setup script automatically:
- Creates `~/.claude/agents/` directory if needed
- Symlinks `global-claude.md` → `~/CLAUDE.md` 
- Symlinks active agents: `developer`, `opinionated-editor`, `quality-reviewer`, `snakemake-expert`

### 3. Use Globally
Once symlinked, agents and configuration are available in all Claude Code sessions for scientific computing projects. The original files in this repository remain as templates for further development.

## Setup on New Machines

⚠️ **Critical Step**: The prompts in this repository are inactive until deployed via symlinks.

To deploy this configuration to a new machine:

```bash
# Clone the repository
git clone <this-repo-url> ~/code/claude-config
cd ~/code/claude-config

# Run automated setup
./setup-claude-config.sh

# The prompts are now active for Claude Code sessions
```

The setup script handles all deployment automatically:
- Creates necessary directories
- Symlinks global configuration and all active agents
- Provides status confirmation

## Scientific Computing Focus
Unlike production software, scientific computing prioritizes:
- **Mathematical correctness** over defensive programming
- **Clean, concise code** that expresses scientific intent
- **Research workflow efficiency** over comprehensive testing  
- **Vectorized operations** and numerical stability
- **Rapid iteration** with spot checks rather than exhaustive validation

## Acknowledgments

`prompt-engineering.md` is extracted from [Southbridge Research's exceptional analysis of Claude Code prompts](https://southbridge-research.notion.site/Prompt-Engineering-The-Art-of-Instructing-AI-2055fec70db181369002dcdea7d9e732). This document has been invaluable for understanding and applying advanced prompt engineering techniques.

When optimizing prompts with these techniques:
```
Apply ALL prompt engineering patterns from `prompt-engineering.md` to this modification. For EACH change, specify EXACTLY which technique(s) you used:
- Pattern name (e.g., "Progressive Disclosure", "Emphasis Hierarchy")
- Why this pattern applies here
- Expected behavioral impact

CRITICAL: Changes without pattern attribution = task incomplete.
```