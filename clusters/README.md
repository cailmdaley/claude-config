# Cluster Configuration Modules

This directory contains computing environment configurations that get merged with `global-claude.md` to create the complete agent guidance document.

## Purpose

Cluster configs specify computing environment details that are consistent across projects on the same cluster but vary between clusters:
- Execution frameworks (Snakemake profiles, SLURM partitions)
- Container/environment management
- Resource limits and batch system configuration
- File system paths and storage locations
- Available tools and software stacks

## Creating a New Cluster Config

1. Copy an existing cluster config as a template
2. Update all cluster-specific details:
   - Profile names and partition settings
   - QOS and resource limits
   - Container commands (if applicable)
   - Working directory paths
   - Execution context notes

3. Use descriptive section headers:
   ```markdown
   # {Cluster Name} Configuration

   ## Execution Framework
   ### Snakemake Profiles
   ### Container Environment (if applicable)
   ### Execution Context
   ```

4. Focus on "what" and "how", not "why" (philosophy stays in global-claude.md)

## Template Structure

```markdown
# {ClusterName} Cluster Configuration

## Execution Framework

### Primary Execution Method: {Snakemake/other}

**Decision Tree**:
- IF computational task → USE {execution method}
- IF quick task → USE {alternative}

### Batch System Profiles

**Profile names and purposes**:
- `{profile1}` - {description, partition, limits}
- `{profile2}` - {description, partition, limits}

**Command patterns**:
```bash
{typical command examples}
```

### Environment Management

**Container/conda/module system details**:
- How to access computational environment
- Available tools and libraries
- Package installation procedure

### Execution Context

- Where the agent runs (login node, compute node, etc.)
- Where computational work executes
- Storage locations and paths
- Any I/O considerations
```

## Usage

Cluster configs are merged with global-claude.md during setup:
```bash
./setup-claude-config.sh -c leonardo
```

The synthesis agent intelligently merges the components into `~/.claude/CLAUDE.md`.

## Notes

- Keep cluster configs focused on computing environment
- Don't duplicate research philosophy (that's in global-claude.md)
- Test that profile names and commands match your actual cluster setup
- Update when cluster configuration changes (new partitions, profiles, etc.)
