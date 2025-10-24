# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose
**Prompt Development Repository** - This is a workspace for writing and refining prompts (skills and agents) for scientific computing. The prompts themselves have no effect until they are deployed to global configuration directories.

**Important**: Files in this repository are templates for prompt development. To actually use these in sessions, you must deploy them as described in the Development Workflow section.

**Tool-Agnostic Design**: All prompts use tool-agnostic language (e.g., "you" instead of "Claude") to remain portable across AI coding assistants. Claude Code-specific features (like skills vs agents) are clearly marked but the core guidance works with any tool.

Based on an excellent original collection, adapted for scientific data analysis and library development rather than production software engineering.

## Architecture & Workflow
```
research-assistant/          # Plugin for scientific computing workflows
└── skills/                  # Interactive guidance (always-on)
    ├── catching-up/        # Research status overview
    ├── using-snakemake/    # Workflow management
    ├── implementing-code/  # Code implementation standards
    └── reviewing-code/     # Code review guidance

global-claude.md            # Core research assistant configuration
setup-claude-config.sh      # Automated deployment script
prompt-engineering.md       # Advanced prompt patterns
```

## Development Workflow
1. **Edit prompts locally** in this repository
2. **Test and refine** for scientific use cases
3. **Deploy**: `./setup-claude-config.sh`
4. **Use globally** across all scientific computing projects

## Skills-Based Workflow

**All guidance is skill-based** (always-on, interactive):
- Active during every conversation
- Interactive, back-and-forth development
- Domain expertise and coding standards
- No separate delegation/editing steps

**Philosophy**: Write it right the first time. Skills provide comprehensive guidance so you don't need separate cleanup or review steps.

## Scientific Computing Focus
Unlike production software development, scientific computing has different priorities:

### Quality Standards
- **Primary**: Mathematical correctness and numerical stability
- **Secondary**: Clean, concise code that expresses scientific intent clearly
- **Tertiary**: Basic validation with toy data (not exhaustive test suites)
- **Tools**: ruff for linting, spot checks for functionality

### Error Handling Philosophy
- Trust scientific libraries (numpy, scipy) to handle their domains
- Explicit handling only when needed (e.g., division by zero in specific contexts)
- Clean, readable code over defensive programming
- Concise error handling focused on scientific workflow needs

### Skills

#### implementing-code
- **Focus**: Implements scientific algorithms with mathematical precision
- **Write it right**: Clean, concise, conceptually dense code from the start
- **Patterns**: Direct numpy/scipy usage, vectorized operations, eliminate intermediates
- **Optimization**: Loop consolidation, ternary conditionals, inline calculations
- **Validation**: Basic functionality checks, not production test suites
- **Quality**: Zero linting violations, timeless comments
- **Philosophy**: If you write it right the first time, you don't need to edit

#### reviewing-code
- **Focus**: Review existing code for real issues that impact research
- **Flags**: Mathematical errors, numerical instability, performance killers (>10x), magic numbers
- **Ignores**: Style preferences, theoretical edge cases, minor optimizations
- **Priorities**: P0 (critical bugs) → P1 (important) → P2 (nice-to-fix) → P3 (optional)
- **Principle**: Flag what the author would fix if they discovered it
- **Based on**: Codex review command, adapted for scientific computing

#### using-snakemake
- **Focus**: Complete Snakemake workflow lifecycle (write, execute, debug)
- **Progressive disclosure**: Main skill + reference docs for deep dives
- **Coverage**: Rule design, explorations pattern, execution/monitoring
- **Cluster-aware**: Includes execution patterns for different HPC environments
- **References**: writing-rules.md, creating-explorations.md, running-workflows.md

#### catching-up
- **Focus**: Quick research status overview
- **Checks**: Recent files, todos, git status, workflow progress
- **Conditional**: Adapts to project structure (works in bare directories)
- **Fast**: Uses smaller model for efficiency

## Prompt Engineering Integration
When modifying prompts, apply patterns from `prompt-engineering.md`:
- Progressive disclosure for complex scientific instructions
- Example-driven clarification with scientific code samples
- Behavioral consequences focused on research productivity
- Trust-building language appropriate for scientific contexts

## Key Differences from Production Development
- **Less testing overhead**: Focus on "does it work" rather than comprehensive test coverage
- **Fewer security concerns**: Scientific computing typically doesn't involve user-facing systems
- **Different performance priorities**: Vectorization and numerical stability over scalability
- **Research iteration speed**: Clean, working code delivered quickly over robust production systems
- **Domain trust**: Assume scientific libraries handle edge cases appropriately

## Template Nature & Deployment
**This repository is purely for prompt development** - the files here are inactive templates until deployed. This serves as a development environment where you can:

1. **Write and edit prompts** in isolation
2. **Version control your modifications** with git
3. **Test different variations** before deploying globally
4. **Share configurations** across machines via git

**Automated Deployment**: Use `./setup-claude-config.sh` to deploy all configuration:
- Symlinks `global-claude.md` → `~/.claude/CLAUDE.md`
- Symlinks `research-assistant/` → `~/.claude/plugins/research-assistant`
- Symlinks output style → `~/.claude/output-styles/`
- Creates directories and provides deployment confirmation

The original excellent template has been adapted to focus on:
- Mathematical correctness over defensive programming
- Research workflow efficiency over production robustness
- Scientific library best practices over general software engineering
- Rapid iteration over comprehensive testing

**One-command deployment**: Run `./setup-claude-config.sh` to activate all prompts for Claude Code sessions across scientific computing projects.
