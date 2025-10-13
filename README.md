# Claude Commands & Agents

**Prompt Development Repository** for scientific computing-focused Claude agents.

## ⚠️ Key Concept

**This repository is for writing prompts, not using them.**

- 📝 **What this repo does**: Provides a workspace to develop and version control AI agent prompts
- ❌ **What this repo doesn't do**: Actually affect AI coding tools (files here are inactive templates)
- 🔗 **To activate prompts**: Must deploy to `~/.claude/` or `~/.codex/` as shown in workflow below
- 🔧 **Tool-agnostic**: Prompts use portable language to work with Claude Code, Codex, and other AI assistants

**Dual Output**: Synthesized configurations are written to both `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` for maximum compatibility.

**Based on**: Excellent original collection, adapted for scientific data analysis and library development.

```
agents/                  # Specialized agents optimized for scientific computing
├── config-synthesizer.md # Merges global + cluster configs (★ active)
├── developer.md         # Scientific code implementation (★ active)
├── opinionated-editor.md # Code style and structure (★ active)
├── quality-reviewer.md  # Scientific code review (★ active)
├── snakemake-expert.md  # Workflow management specialist (★ active)
├── architect.md         # Solution design (original)
├── debugger.md          # Bug analysis (original)
└── technical-writer.md  # Documentation (original)
clusters/                # Cluster-specific computing environments
├── candide.md           # Candide cluster configuration
├── leonardo.md          # Leonardo cluster configuration
└── README.md            # Template for new clusters
commands/                # Task execution patterns (original)
global-claude.md         # Core research assistant configuration
setup-claude-config.sh   # Automated setup script (calls claude --exec for synthesis)
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

**Standard deployment** (global config only):
```bash
./setup-claude-config.sh
```

**Cluster-specific deployment** (automatic synthesis):
```bash
# Deploy with cluster-specific execution framework
./setup-claude-config.sh -c candide

# With additional environment notes
./setup-claude-config.sh -c candide -n "No containers on this cluster"
```

The setup script automatically:
- Creates necessary directories (`~/.claude/`, `~/.codex/`, plugins, etc.)
- Calls `claude --exec` to synthesize global + cluster configs
- Writes merged result to both `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`
- Installs research-assistant plugin with specialized agents
- Installs research-assistant output style

**Automatic synthesis**: When using `-c/--cluster` flag, the setup script automatically runs the config-synthesizer agent via `claude --exec` to intelligently merge configurations.

### 3. Use Globally
Once symlinked, agents and configuration are available in all Claude Code sessions for scientific computing projects. The original files in this repository remain as templates for further development.

## Cluster Configuration System

Scientific computing often involves working on HPC clusters with specific execution frameworks (SLURM, Snakemake profiles, containers). The cluster configuration system allows you to modularize these environment-specific details.

### Architecture

**Modular Components**:
- `global-claude.md`: Core research philosophy, workflow patterns (tool-agnostic)
- `clusters/{name}.md`: Execution framework, batch system, container environment
- `agents/config-synthesizer.md`: Agent that intelligently merges both

**Key Benefits**:
- ✓ Share cluster config across all projects on same cluster
- ✓ Version control cluster-specific execution patterns
- ✓ Intelligent synthesis (not just concatenation) - places sections logically
- ✓ Support for environment-specific notes per deployment

### Creating a New Cluster Config

1. Copy an existing cluster config as template:
```bash
cp clusters/leonardo.md clusters/perlmutter.md
```

2. Update cluster-specific details:
   - Snakemake profile names and partitions
   - SLURM QOS and resource limits
   - Container commands (if applicable)
   - Working directory paths
   - Available tools and software

3. Deploy with your new cluster:
```bash
./setup-claude-config.sh -c perlmutter  # Automatic synthesis
```

See `clusters/README.md` for detailed template and guidelines.

### Synthesis Process

The config-synthesizer agent (called via `claude --exec`) merges components intelligently:
1. Reads global research philosophy
2. Reads cluster execution framework
3. Identifies logical placement (e.g., execution framework after project organization)
4. Merges coherently without duplication
5. Integrates any environment-specific notes
6. Writes complete configuration to BOTH `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`

**Not simple concatenation** - the agent understands document structure and maintains narrative flow. The tool-agnostic language ensures prompts work across different AI coding assistants.

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