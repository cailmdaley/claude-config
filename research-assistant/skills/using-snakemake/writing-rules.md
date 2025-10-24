# Writing Snakemake Rules

Design and implement Snakemake rules for scientific computing workflows. Focus on clean, minimal rules that express dependencies clearly and trust scientific libraries to handle validation.

**Documentation**: https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html

## Rule Anatomy

A well-structured rule includes:

```python
rule rule_name:
    input:
        # File paths, lists, or functions
        # Can use named inputs: reference="ref.fa"
    output:
        # File paths (can use named outputs)
        # Use directory() for directory outputs
    params:
        # Non-file parameters
        # Can be functions accepting wildcards, input, output, threads, resources
    resources:
        mem_mb=8000,      # Memory in megabytes
        runtime=60,       # Runtime in minutes
        tmpdir="/tmp"     # Temporary directory
    threads: 4            # Thread count (Snakemake adjusts to available cores)
    container: "docker://myimage:latest"  # Optional container
    shell:
        "command {input} > {output}"
    # OR
    script:
        "scripts/analyze.py"
```

**Key principle**: Most rules need input, output, and shell/script. Add params, resources, threads when needed. Don't over-specify.

## Wildcards and Pattern Matching

Wildcards enable rules to apply across multiple datasets:

```python
rule process_sample:
    input:
        "data/{sample}.txt"
    output:
        "results/{sample}_processed.txt"
    shell:
        "process {input} > {output}"
```

When Snakemake sees a request for `results/SampleA_processed.txt`, it extracts `{sample}=SampleA` and propagates to inputs.

**Critical rule**: Wildcard names in input and output must match exactly.

### Wildcard Constraints

Prevent ambiguity by constraining wildcards with regex:

```python
# Per-rule constraint
rule analyze:
    input:
        r"data/{dataset,\d+}.{group}.txt"  # dataset must be digits
    output:
        "results/{dataset}.{group}.out"

# Global constraint
wildcard_constraints:
    sample="\w+",
    dataset="\d+"
```

Use constraints when:
- Multiple rules could match the same output
- Wildcards might capture unwanted patterns
- File naming has specific structure

## Using expand() for Multiple Files

Generate file lists from wildcards:

```python
# In config.yaml
samples: ["A", "B", "C"]
conditions: ["ctrl", "treat"]

# In Snakefile
rule all:
    input:
        expand("results/{sample}_{cond}.txt",
               sample=config["samples"],
               cond=config["conditions"])
        # Produces: results/A_ctrl.txt, results/A_treat.txt,
        #           results/B_ctrl.txt, results/B_treat.txt, ...
```

**Combining vs crossing**:
```python
# Cross product (all combinations)
expand("results/{sample}_{cond}.txt", sample=SAMPLES, cond=CONDITIONS)

# Parallel (same-length lists, paired)
expand("results/{sample}_{cond}.txt",
       zip, sample=SAMPLES, cond=CONDITIONS)
```

## Configuration Access

Access config in rules:

```python
# In Python context
rule all:
    input:
        expand("{sample}.output.pdf",
               sample=config["samples"])

# In shell commands (no quotes around keys)
rule process:
    shell:
        "mycommand --param {config[yourparam]} {input}"
```

Config hierarchy (highest priority first):
1. Command-line: `snakemake --config key=value`
2. `--configfile` argument
3. `configfile:` statement in Snakefile

## Resource Specifications

Be realistic with resources - underspecification causes failures, overspecification wastes time in queue:

```python
rule intensive_analysis:
    input: "data/{sample}.fits"
    output: "results/{sample}_analyzed.pkl"
    resources:
        mem_mb=16000,      # 16GB memory
        runtime=120,       # 2 hours
        disk_mb=5000       # 5GB disk
    threads: 8
    script:
        "scripts/analyze.py"
```

**Standard resources**:
- `mem_mb` or `mem`: Memory (megabytes or human-readable like "16G")
- `runtime`: Wall-clock time in minutes
- `disk_mb` or `disk`: Disk space
- `tmpdir`: Temporary directory location

**Threads**: Snakemake will not allocate more threads than available. Set `threads` to the maximum useful for the tool. Many tools read thread count from environment variables like `OMP_NUM_THREADS`.

## Named Inputs and Outputs

Use named inputs/outputs for clarity in complex rules:

```python
rule compare:
    input:
        treatment="data/{sample}_treatment.txt",
        control="data/{sample}_control.txt",
        reference="reference/genome.fa"
    output:
        report="results/{sample}_comparison.html",
        data="results/{sample}_comparison.tsv"
    shell:
        "compare --treatment {input.treatment} "
        "--control {input.control} "
        "--ref {input.reference} "
        "--out-html {output.report} "
        "--out-data {output.data}"
```

## Dynamic Parameters with Functions

Use functions in params when you need context-dependent values:

```python
def get_sample_param(wildcards):
    # Access wildcards to return sample-specific value
    return SAMPLE_CONFIG[wildcards.sample]["parameter"]

rule process:
    input:
        "data/{sample}.txt"
    output:
        "results/{sample}.out"
    params:
        custom_param=get_sample_param
    shell:
        "process --param {params.custom_param} {input} > {output}"
```

Functions can accept: `wildcards`, `input`, `output`, `threads`, `resources`

## localrules for Quick Operations

Mark rules that run quickly (<1 minute) as local to avoid cluster overhead:

```python
localrules: prepare_config, symlink_data, create_report

rule prepare_config:
    output: "config/runtime.yaml"
    shell:
        "echo 'timestamp: $(date)' > {output}"

rule symlink_data:
    input: "/path/to/data/{file}"
    output: "data/{file}"
    shell:
        "ln -s {input} {output}"
```

## Temporary and Protected Files

Mark intermediate files for cleanup:

```python
rule step1:
    output:
        temp("intermediate/{sample}.tmp")  # Deleted after use
    shell:
        "process > {output}"

rule step2:
    input:
        "intermediate/{sample}.tmp"
    output:
        protected("final/{sample}.dat")  # Write-protected after creation
    shell:
        "finalize {input} > {output}"
```

Use `temp()` for large intermediate files to save disk space. Use `protected()` for final results you don't want accidentally overwritten.

## Directory Outputs

Mark directory outputs explicitly:

```python
rule create_database:
    input:
        "data/samples.txt"
    output:
        directory("database/")
    shell:
        "build_db {input} --outdir {output}"
```

## Trust Scientific Libraries

**Do NOT validate inputs that scientific libraries will catch**:

```python
# BAD - unnecessary validation
rule analyze:
    input: "data/{sample}.fits"
    output: "results/{sample}.pkl"
    shell:
        """
        if [ ! -f {input} ]; then echo "Missing input"; exit 1; fi
        python analyze.py {input} {output}
        """

# GOOD - let astropy/healpy catch file issues
rule analyze:
    input: "data/{sample}.fits"
    output: "results/{sample}.pkl"
    script:
        "scripts/analyze.py"
```

Trust numpy, scipy, astropy, healpy, pandas to handle their domains. Focus on clear workflow logic.

## Script vs Shell Directives

**Use `script:` for Python/R analysis**:
```python
rule analyze:
    input:
        data="data/{sample}.fits",
        mask="masks/{sample}.fits"
    output:
        "results/{sample}.pkl"
    params:
        threshold=0.95
    script:
        "scripts/analyze.py"
```

In the script, access via `snakemake` object:
```python
# scripts/analyze.py
import healpy as hp
import pickle

data = hp.read_map(snakemake.input.data)
mask = hp.read_map(snakemake.input.mask)
threshold = snakemake.params.threshold

# ... analysis ...

with open(snakemake.output[0], 'wb') as f:
    pickle.dump(results, f)
```

**Use `shell:` for command-line tools**:
```python
rule compress:
    input: "data/{file}.txt"
    output: "data/{file}.txt.gz"
    shell:
        "gzip -c {input} > {output}"
```

## Multiple Outputs with multiext()

For files differing only by extension:

```python
rule process:
    input:
        "data/{sample}.txt"
    output:
        multiext("results/{sample}", ".txt", ".log", ".stats")
        # Produces: results/{sample}.txt, results/{sample}.log, results/{sample}.stats
    shell:
        "process {input} --outbase results/{wildcards.sample}"
```

## Common Patterns

### Aggregating across samples

```python
rule aggregate:
    input:
        expand("results/{sample}.txt", sample=config["samples"])
    output:
        "results/combined.txt"
    shell:
        "cat {input} > {output}"
```

### Conditional inputs based on config

```python
def get_inputs(wildcards):
    if config["use_mask"]:
        return {"data": "data/{sample}.fits", "mask": "masks/{sample}.fits"}
    else:
        return {"data": "data/{sample}.fits"}

rule analyze:
    input:
        unpack(get_inputs)
    output:
        "results/{sample}.pkl"
    script:
        "scripts/analyze.py"
```

## Best Practices

1. **Keep rules simple**: One conceptual step per rule
2. **Use config.yaml for parameters**: Paths can be in Snakefile, but flags, thresholds, sample lists go in config
3. **Realistic resources**: Profile your jobs to set accurate mem_mb and runtime
4. **Meaningful wildcards**: Use descriptive names like `{sample}`, `{dataset}`, `{frequency}` not `{x}`, `{y}`
5. **Trust the DAG**: Don't validate what Snakemake's dependency system handles
6. **Named inputs/outputs**: For rules with multiple files, naming improves readability
7. **localrules**: Mark quick operations to avoid cluster submission overhead

## Project Context

Always check CLAUDE.md or project README for:
- Project-specific wildcard conventions
- Config.yaml structure and expected keys
- Resource specifications for typical jobs
- Container or environment requirements
- Preferred script locations (workflow/scripts/)

## Quick Reference

```python
# Basic rule
rule name:
    input: "in.txt"
    output: "out.txt"
    shell: "command {input} > {output}"

# With wildcards and config
rule process:
    input: "data/{sample}.txt"
    output: "results/{sample}.out"
    params:
        param=config["param"]
    resources:
        mem_mb=4000,
        runtime=30
    threads: 2
    shell:
        "tool --threads {threads} --param {params.param} {input} > {output}"

# Aggregation
rule combine:
    input:
        expand("results/{sample}.txt", sample=config["samples"])
    output:
        "results/all.txt"
    shell:
        "cat {input} > {output}"
```

For complex DAG issues or workflow design questions, use the main snakemake-expert agent.
