# Candide Cluster Configuration

## Execution Framework

### Primary Execution Method: Snakemake

**Decision Tree**:
- **IF** computational task → **USE** Snakemake (default)
- **IF** task < 1 minute → **USE** direct execution OR mark as `localrules`
- **IF** file operations (read/search) → **USE** appropriate tools directly

### Snakemake Profile

**Profile**: `slurm` (`~/.config/snakemake/slurm/`)

**Available Partitions**:
- `comp` - Standard compute partition
- `pscomp` - Priority/specialized compute partition
- **Note**: Can submit jobs to both partitions simultaneously

**Standard Command Pattern**:
```bash
# Parallel workflow execution
snakemake --profile slurm -j{n_parallel} -c{threads_per_job} {target}

# Examples
snakemake --profile slurm -j14 -c2 build_maps
snakemake --profile slurm -j8 -c4 cross_correlations
```

### Container Environment

**Automatic**: Snakemake uses container automatically
**Manual access**: `app <command> [args]` for direct container execution
**Writable mode**: `app --writable <command>` for installing packages
**Available tools**: healpy, pymaster, pyccl, sacc, polars, numpy, scipy, pandas, ripgrep, jupyter, full cosmology stack

**When to use container directly**:
- Quick interactive computations
- Tool validation
- Direct Python/script execution outside workflow
- Installing packages: `app --writable pip install <package>`

### Execution Context

- **Agent runs on**: Login node (enables SLURM job submission)
- **Computational work**: Submitted to SLURM via Snakemake
- **No conda/mamba management**: All dependencies in container
- **Partiticn flexibility**: Jobs can be distributed across comp and pscomp partitions
