# Claude Commands & Agents

Template repository for developing scientific computing-focused Claude agents.

**Based on**: Excellent original collection, adapted for scientific data analysis and library development.

```
agents/                # Specialized agents optimized for scientific computing
├── developer.md       # Scientific code implementation (★ customized)
├── quality-reviewer.md # Scientific code review (★ customized)  
├── architect.md       # Solution design (original)
├── debugger.md        # Bug analysis (original)
└── technical-writer.md # Documentation (original)
commands/              # Task execution patterns (original)
prompt-engineering.md  # Prompt optimization techniques (from Southbridge Research)
```

## Development Workflow

### 1. Edit Agents Locally
Develop and test agent prompts in this repository:
```bash
# Edit agents for scientific computing use cases
vim agents/developer.md
vim agents/quality-reviewer.md
```

### 2. Symlink to Global Directory
Deploy agents for global use across scientific projects:
```bash
# Symlink updated agents to global Claude directory
ln -sf $(pwd)/agents/developer.md ~/.claude/agents/
ln -sf $(pwd)/agents/quality-reviewer.md ~/.claude/agents/

# Verify symlinks
ls -la ~/.claude/agents/
```

### 3. Use Globally
Agents are now available in all Claude Code sessions for scientific computing projects.

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
