# Leonardo Cluster Configuration

## Execution Framework

### Primary Execution Method: Snakemake

**Decision Tree**:
- **IF** computational task → **USE** Snakemake (default)
- **IF** task < 1 minute → **USE** direct execution OR mark as `localrules`
- **IF** file operations (read/search) → **USE** appropriate tools directly

### Snakemake Profiles

**Two profiles available** (`~/.config/snakemake/`):

**1. `serial` profile** - Single-job tasks
- Partition: `lrd_all_serial`
- Memory: 8GB per job
- Max: 1 node / 4 cores / 30GB RAM per user
- **Use for**: Exploration scripts, quick tests, single-job tasks

**2. `prod` profile** - Parallel production runs
- Partition: `dcgp_usr_prod`
- QOS: `dcgp_qos_bprod` (priority 60)
- Memory: 8GB per job
- Max: 128 nodes per user
- Walltime: 24h
- **Use for**: Parallel workflows (build_maps, animations, cross-correlations)

**Standard Command Pattern**:
```bash
# Parallel production work
snakemake --profile prod -j{n_parallel} -c{threads_per_job} {target}

# Serial work
snakemake --profile serial -j1 -c8 {target}
```

**Examples**:
```bash
# Parallel map building (production)
snakemake --profile prod -j14 -c2 build_maps_fiducial

# Single exploration
snakemake --profile serial -j1 -c8 explore_coverage_visibility

# Compute-intensive parallel
snakemake --profile prod -j8 -c4 cross_correlations
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

- **Agent runs on**: Login node (high I/O latency)
- **Computational work**: Submitted to SLURM via Snakemake
- **No conda/mamba management**: All dependencies in container
- **Working directory**: `/leonardo_work/EUHPC_E05_083/cdaley00/cmbx`
