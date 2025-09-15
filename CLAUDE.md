# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose
**Prompt Development Repository** - This is a workspace for writing and refining Claude agent prompts for scientific computing. The prompts themselves have no effect until they are symlinked to the global ~/.claude/agents directory.

**Important**: Files in this repository are only templates for prompt development. To actually use these agents in Claude Code sessions, you must symlink them to your ~/.claude directory as described in the Development Workflow section.

Based on an excellent original collection, adapted for scientific data analysis and library development rather than production software engineering.

## Architecture & Workflow
```
agents/                  # Specialized AI agents optimized for scientific computing
├── architect.md         # Solution design and ADR creation (production-focused)
├── debugger.md         # Systematic bug analysis (production-focused) 
├── developer.md        # Scientific code implementation ★ ACTIVE
├── opinionated-editor.md # Code style and structure improvement ★ ACTIVE
├── quality-reviewer.md # Scientific code review ★ ACTIVE
├── snakemake-expert.md # Workflow management specialist ★ ACTIVE
└── technical-writer.md # Documentation creation (production-focused)

commands/                # Task execution patterns (from original template)
└── plan-execution.md   # Project management workflow

global-claude.md        # Global Claude configuration file
setup-claude-config.sh  # Automated deployment script
prompt-engineering.md   # Advanced prompt patterns and techniques (from Southbridge Research)
```

★ ACTIVE = Automatically symlinked by setup script
★ = Adapted for scientific computing workflows

## Development Workflow
1. **Edit agents locally** in this repository
2. **Test and refine** agent prompts for scientific use cases  
3. **Setup global configuration**: `./setup-claude-config.sh`
4. **Use agents globally** across all scientific computing projects

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

### Agent Specializations

#### Developer Agent
- **Focus**: Implements scientific algorithms with mathematical precision
- **Patterns**: Direct numpy/scipy usage, vectorized operations, snakemake integration
- **Validation**: Basic functionality checks, not production test suites
- **Anti-patterns**: Unnecessary intermediate variables, loops over vectorizable operations

#### Quality Reviewer Agent  
- **Focus**: Analysis-breaking issues only (not style preferences)
- **Flags**: Mathematical errors, performance killers, magic numbers without provenance
- **Ignores**: Variable naming, import order, theoretical edge cases
- **Priority**: Simplicity > Performance > Ease of use (unless >10x performance impact)

## Prompt Engineering Integration
When modifying agents, apply patterns from `prompt-engineering.md`:
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
**This repository is purely for prompt development** - the agent files here are inactive templates until deployed. This serves as a development environment where you can:

1. **Write and edit agent prompts** in isolation
2. **Version control your prompt modifications** with git
3. **Test different prompt variations** before deploying globally
4. **Share prompt configurations** across machines via git

**Automated Deployment**: Use `./setup-claude-config.sh` to deploy all configuration:
- Symlinks `global-claude.md` → `~/CLAUDE.md` (global Claude configuration)
- Symlinks active agents → `~/.claude/agents/` (per-session agents)
- Creates directories and provides deployment confirmation

The original excellent template has been adapted to focus on:
- Mathematical correctness over defensive programming  
- Research workflow efficiency over production robustness
- Scientific library best practices over general software engineering
- Rapid iteration over comprehensive testing

**One-command deployment**: Run `./setup-claude-config.sh` to activate all prompts for Claude Code sessions across scientific computing projects.