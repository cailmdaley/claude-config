# Running and Debugging Workflows

Execute, monitor, and debug Snakemake workflows through their full lifecycle. Focus on validating before execution, monitoring actively during runs, and systematic debugging when issues arise.

**Documentation**:
- https://snakemake.readthedocs.io/en/stable/executing/cli.html
- https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html

## Pre-Flight Checklist

**ALWAYS run dry-run before executing workflows**:

```bash
# 1. Dry-run to validate workflow
snakemake -n {target}

# 2. Check what will run and why
snakemake --reason {target}

# 3. Verify shell commands
snakemake --printshellcmds {target}
```

**What to verify in dry-run**:
- [ ] Expected number of jobs
- [ ] Correct input/output file paths
- [ ] Wildcards resolved properly
- [ ] No unexpected file regenerations
- [ ] No missing input files

**If dry-run fails**, fix issues before attempting execution. Never skip dry-run for production workflows.

## Cluster-Aware Execution

Check CLAUDE.md for cluster-specific profiles and partitions.

### Candide Cluster Pattern

```bash
# Profile: slurm
# Partitions: comp, pscomp (can use both simultaneously)

# Parallel execution
snakemake --profile slurm -j{n_parallel} {target}

# Examples:
snakemake --profile slurm -j14 build_maps
snakemake --profile slurm -j8 cross_correlations
```

### Leonardo Cluster Pattern

```bash
# Profile: serial (quick tasks) OR prod (parallel production)

# Serial execution (lrd_all_serial partition)
# - Max 1 node / 4 cores / 30GB RAM per user
snakemake --profile serial -j1 {target}

# Production parallel execution (dcgp_usr_prod partition)
# - Max 128 nodes per user, 24h walltime
snakemake --profile prod -j{n_parallel} {target}

# Examples:
snakemake --profile serial -j1 explore_coverage_visibility
snakemake --profile prod -j14 build_maps_fiducial
```

### General Execution Patterns

```bash
# Parallel workflow (multiple jobs)
snakemake --profile {profile} -j{n_parallel} {target}
# -j: number of parallel jobs to submit

# Serial execution (single job, multiple cores)
snakemake --profile {profile} -j1 -c{cores} {target}
# -c: cores/threads for the single job

# Local execution (no cluster)
snakemake -j{cores} {target}
```

**Key distinction**:
- `-j` (jobs): Number of parallel Snakemake jobs
- `-c` (cores): Cores per job (when not using cluster)

## Long-Running Workflows: tmux Pattern

For long workflows, use tmux to allow detaching/reattaching:

```bash
# Create empty tmux session first
tmux new-session -d -s snakemake

# Send commands to the session
tmux send-keys -t snakemake "cd $(pwd)" C-m
tmux send-keys -t snakemake "snakemake --profile slurm -j14 build_maps" C-m

# Capture output if needed
tmux capture-pane -t snakemake -p

# Attach to session (optional)
tmux attach -t snakemake

# Detach: Ctrl-b d
# Kill session when done:
tmux kill-session -t snakemake
```

**Why this pattern**:
- Session persists if SSH connection drops
- Can check progress without interrupting
- Output remains accessible via `tmux capture-pane`
- Prevents terminal blocking for multi-hour workflows

**CRITICAL**: Create empty session first, then send commands. Direct command execution can fail silently.

## Active Monitoring

**Don't just submit and forget** - proactively monitor workflow progress.

### Workflow Status Commands

```bash
# Check workflow summary
snakemake {target} --summary

# Detailed execution status
snakemake {target} --detailed-summary

# List what would run (after workflow started)
snakemake {target} -n
```

### Cluster Job Monitoring (SLURM)

```bash
# Check running jobs
squeue -u $USER

# More detailed status
squeue -u $USER -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R"

# Check completed job details
sacct -j {job_id}

# Check recent jobs
sacct -u $USER --starttime=today
```

### Snakemake Logs

```bash
# Find recent logs
ls -lt .snakemake/log/*.log | head -5

# Follow most recent log
tail -f .snakemake/log/*.log

# Check specific rule execution
grep "rule {rulename}" .snakemake/log/*.log

# Check for errors
grep -i error .snakemake/log/*.log
```

### SLURM Job Logs

Snakemake logs reference SLURM output files like `slurm-{jobid}.out`:

```bash
# Find referenced in Snakemake log, then:
tail -f slurm-{jobid}.out

# Check for errors
grep -i error slurm-*.out
```

### Monitoring Checklist for Long Workflows

- [ ] Check squeue regularly for running jobs
- [ ] Monitor .snakemake/log/ for progress
- [ ] Check SLURM logs if jobs seem stuck
- [ ] Verify output files being created
- [ ] Track resource usage (memory, time)
- [ ] Report status updates to user

**Keep user informed**: For workflows expected to take >30 minutes, proactively report progress without being asked.

## Debugging Sequence

When workflows fail or behave unexpectedly, follow this sequence:

### 1. Dry-Run First

```bash
snakemake {target} --dry-run
```

**If dry-run fails**: Fix Snakefile syntax/logic before proceeding.

**If dry-run succeeds but DAG is wrong**: Use debugging tools below.

### 2. Understand Why Jobs Trigger

```bash
snakemake {target} --reason
```

Shows why each job will run:
- Input files missing
- Output files missing
- Input files newer than output
- Code/params changed

### 3. Verify Shell Commands

```bash
snakemake {target} --printshellcmds
```

See exact commands with wildcards resolved. Catches:
- Incorrect wildcard substitution
- Wrong file paths
- Missing parameters

### 4. Debug DAG Inference

```bash
snakemake {target} --debug-dag
```

Shows candidate and selected jobs during DAG construction. Useful for:
- Ambiguous wildcard patterns
- Rule selection issues
- Complex dependencies

### 5. Verbose Output

```bash
snakemake {target} --verbose
```

Additional debugging information during execution.

### 6. Show Failed Logs Automatically

```bash
snakemake {target} --show-failed-logs
```

Automatically displays logs from failed jobs. Very helpful for cluster execution.

## File Regeneration Issues

### If File SHOULD Regenerate But DOESN'T

**DO NOT**:
- ❌ Use `--force` or `--forcerun` without explicit user approval
- ❌ Delete the output file
- ❌ Assume Snakemake is wrong

**DO**:
1. **THINK**: Why does Snakemake think the file is up to date?
2. **CHECK**: Are input files actually newer than output?
   ```bash
   ls -l {input_file} {output_file}
   ```
3. **CHECK**: Do upstream jobs work when dry-runned?
   ```bash
   snakemake -n {upstream_target}
   ```
4. **TRY**: `--rerun-incomplete` if there was an interruption
   ```bash
   snakemake --rerun-incomplete {target}
   ```
5. **TRY**: `--unlock` if directory was locked
   ```bash
   snakemake --unlock {target}
   ```
6. **INVESTIGATE**: Are triggers configured correctly? Check:
   ```bash
   snakemake {target} --reason
   ```

**CRITICAL**: Force flags (`--force`, `--forceall`, `-f`, `-F`, `--forcerun`) bypass Snakemake's dependency tracking. This can lead to:
- Wasted computation (regenerating files unnecessarily)
- Inconsistent results (some files updated, others stale)
- Lost debugging information (masking underlying issue)

**Only use force flags with explicit user approval after explaining the implications.**

### If File Should NOT Regenerate But DOES

Usually indicates:
- Input files touched/modified unexpectedly
- Incorrect wildcard constraints (pattern matches multiple rules)
- Timestamps not preserved during file operations

Check:
```bash
snakemake {target} --reason
snakemake {target} --list-changes code,params,input
```

## Common Issues and Solutions

### Locked Directory

**Symptom**: Error about directory being locked

**Solution**:
```bash
# Unlock using exact same command that failed
snakemake --unlock {original_target}

# Then retry original command
snakemake --profile slurm -j14 {original_target}
```

### Incomplete Metadata

**Symptom**: Jobs re-running after interruption, even though outputs exist

**Solution**:
```bash
snakemake --rerun-incomplete {target}
```

Completes interrupted jobs and updates metadata.

### Ambiguous Wildcards

**Symptom**: Multiple rules could produce the same output

**Solution**: Add wildcard constraints to rules:
```python
wildcard_constraints:
    sample="\w+",
    dataset="\d+"
```

Or use regex in output patterns:
```python
output: r"results/{dataset,\d+}.txt"
```

### Rule Ambiguity

**Symptom**: Multiple rules have output patterns matching the requested file

**Solution**:
1. Make output patterns more specific
2. Use `ruleorder:` to specify precedence:
   ```python
   ruleorder: specific_rule > general_rule
   ```
3. Add wildcard constraints to disambiguate

### Missing Input Files

**Symptom**: Snakemake can't find way to generate input files

**Check**:
1. Do input files exist or can they be generated?
2. Are wildcards constrained too tightly?
3. Are file paths correct (check typos)?

**Debug**:
```bash
# Check which rule would generate the missing input
snakemake --dry-run {missing_input_file}
```

### Jobs Failing on Cluster

**Check SLURM logs**:
```bash
# Find job ID from squeue or .snakemake/log/
cat slurm-{jobid}.out
```

**Common causes**:
- Insufficient memory (increase `mem_mb`)
- Insufficient time (increase `runtime`)
- Missing container/environment
- Incorrect paths (cluster vs login node)

## Visualization

Generate workflow diagrams for understanding structure:

```bash
# DAG visualization
snakemake --dag {target} | dot -Tpdf > dag.pdf

# Rule dependency graph (higher level)
snakemake --rulegraph {target} | dot -Tpdf > rules.pdf

# View without saving
snakemake --dag {target} | dot | display
```

Useful for:
- Understanding complex dependencies
- Identifying bottlenecks
- Communicating workflow structure
- Debugging unexpected DAG behavior

## Batching Large Workflows

For workflows with thousands of jobs, process in batches:

```bash
# Split into 3 batches
snakemake --profile slurm -j10 --batch myrule=1/3 {target}
snakemake --profile slurm -j10 --batch myrule=2/3 {target}
snakemake --profile slurm -j10 --batch myrule=3/3 {target}
```

Reduces filesystem queries and improves performance for massive workflows.

## Resource Overrides

Override resource specifications from command line:

```bash
# Set threads for specific rule
snakemake --cores 4 --set-threads myrule=2 {target}

# Set resources for specific rule
snakemake --cores 4 --set-resources myrule:partition="foo" {target}

# Set resources globally
snakemake --cores 4 --default-resources mem_mb=8000 runtime=60 {target}
```

Useful for:
- Testing with different resource allocations
- Temporarily adjusting for cluster conditions
- Overriding without editing Snakefile

## Container Execution

Workflows using containers (specified in rules or globally):

```bash
# Snakemake handles containers automatically via profiles

# Manual container access (outside Snakemake)
app <command> [args]

# Writable mode for installing packages
app --writable pip install <package>
```

**Container info** (from cluster config):
- Available tools: healpy, pymaster, pyccl, sacc, polars, numpy, scipy, pandas, ripgrep, jupyter
- Container used automatically by Snakemake rules
- Manual access for testing/validation

## Best Practices

### Before Execution
1. **ALWAYS dry-run first**: `snakemake -n {target}`
2. **Check reasons**: `snakemake --reason {target}` if DAG looks wrong
3. **Verify commands**: `snakemake --printshellcmds {target}` for complex rules
4. **Start small**: Test with subset of data before full workflow

### During Execution
5. **Use tmux for long workflows**: Prevent SSH disconnection issues
6. **Monitor actively**: Check squeue, logs regularly for long jobs
7. **Track resource usage**: Note actual memory/time for future tuning
8. **Keep user informed**: Report progress for >30 minute workflows

### After Failures
9. **Read logs first**: .snakemake/log/ and slurm-*.out
10. **Use debugging flags**: --reason, --debug-dag, --show-failed-logs
11. **Never force without approval**: Explain implications first
12. **Systematic approach**: Follow debugging sequence above

### General
13. **Profile-aware**: Use cluster-appropriate profiles from CLAUDE.md
14. **Realistic resources**: Neither under- nor over-specify
15. **Trust the DAG**: Investigate rather than override with force flags
16. **Document issues**: Note unexpected behavior for future reference

## Quick Reference

```bash
# Pre-flight (ALWAYS)
snakemake -n {target}                    # Dry-run
snakemake --reason {target}              # Why jobs run
snakemake --printshellcmds {target}      # See commands

# Execution
snakemake --profile {profile} -j{n} {target}        # Cluster
snakemake -j{cores} {target}                        # Local

# Monitoring
squeue -u $USER                          # Cluster jobs
tail -f .snakemake/log/*.log            # Snakemake logs
snakemake {target} --summary             # Workflow status

# Debugging
snakemake {target} --debug-dag           # DAG inference
snakemake {target} --show-failed-logs    # Auto-show failures
snakemake {target} --list-changes code,params,input

# Recovery
snakemake --unlock {target}              # Unlock directory
snakemake --rerun-incomplete {target}    # Complete interrupted

# Visualization
snakemake --dag {target} | dot -Tpdf > dag.pdf
snakemake --rulegraph {target} | dot -Tpdf > rules.pdf
```

## Execution Workflow Summary

```
1. Dry-run (ALWAYS)
   ↓
2. Verify DAG correct
   ↓
3. Start tmux (if long-running)
   ↓
4. Execute with appropriate profile
   ↓
5. Monitor actively (squeue, logs)
   ↓
6. If issues: systematic debugging
   ↓
7. Report completion/status
```

For complex DAG design or multi-rule refactoring, use the main snakemake-expert agent.
