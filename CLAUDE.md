# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose
**Prompt Development Repository** - This is a workspace for writing and refining agent prompts for scientific computing. The prompts themselves have no effect until they are deployed to global configuration directories.

**Important**: Files in this repository are templates for prompt development. To actually use these agents in sessions, you must deploy them as described in the Development Workflow section.

**Tool-Agnostic Design**: All prompts use tool-agnostic language (e.g., "you" instead of "Claude") to remain portable across AI coding assistants. Agent-specific features (like subagents) are clearly marked but the core guidance works with any tool.

**Dual Output**: Synthesized configurations are written to both:
- `~/.claude/CLAUDE.md` (for Claude Code)
- `~/.codex/AGENTS.md` (for Codex and other AI coding tools)

Based on an excellent original collection, adapted for scientific data analysis and library development rather than production software engineering.

## Architecture & Workflow
```
agents/                  # Specialized agents optimized for scientific computing
├── config-synthesizer.md # Merges global + cluster configs ★ ACTIVE
├── developer.md        # Scientific code implementation ★ ACTIVE
├── opinionated-editor.md # Code style and structure improvement ★ ACTIVE
├── quality-reviewer.md # Scientific code review ★ ACTIVE
├── snakemake-expert.md # Workflow management specialist ★ ACTIVE
├── architect.md        # Solution design and ADR creation (production-focused)
├── debugger.md         # Systematic bug analysis (production-focused)
└── technical-writer.md # Documentation creation (production-focused)

clusters/               # Cluster-specific computing environments
├── leonardo.md         # Leonardo cluster configuration
└── README.md           # Template for new clusters

commands/               # Task execution patterns (from original template)
└── plan-execution.md   # Project management workflow

global-claude.md        # Core research assistant configuration
setup-claude-config.sh  # Automated deployment script (calls claude --exec for synthesis)
prompt-engineering.md   # Advanced prompt patterns (from Southbridge Research)
```

★ ACTIVE = Automatically deployed by setup script
★ = Adapted for scientific computing workflows

## Development Workflow
1. **Edit agents locally** in this repository
2. **Test and refine** agent prompts for scientific use cases
3. **Setup global configuration**:
   - Standard: `./setup-claude-config.sh`
   - With cluster: `./setup-claude-config.sh -c candide` (automatically synthesizes)
4. **Use agents globally** across all scientific computing projects

The setup script automatically calls `claude --exec` to synthesize configurations when a cluster is specified, writing to both `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`.

## Cluster Configuration System

Modularize computing environment details (SLURM, Snakemake, containers) that are consistent across projects on the same cluster.

**Components**:
- `global-claude.md`: Core research philosophy (tool-agnostic)
- `clusters/{name}.md`: Execution framework, profiles, paths
- `agents/config-synthesizer.md`: Intelligently merges both

**Workflow**:
```bash
# Create or edit cluster config
vim clusters/candide.md

# Deploy with automatic synthesis
./setup-claude-config.sh -c candide
```

**Result**: Both `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` contain intelligently merged global philosophy + cluster execution framework, with logical section placement (not just concatenation).

The setup script automatically calls `claude --exec` to perform synthesis via the config-synthesizer agent.

See `clusters/README.md` for template and guidelines.

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