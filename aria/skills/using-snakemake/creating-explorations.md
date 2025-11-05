# Creating Exploratory Analyses

Create exploratory analysis workflows following the explorations.smk pattern. These are standalone, interactive scripts for data exploration and prototyping that live alongside the main production workflow.

**Documentation**: https://snakemake.readthedocs.io/en/stable/snakefiles/writing_snakefiles.html

## Explorations Workflow Pattern

Exploratory analyses use a separate Snakefile (`explorations.smk`) to keep experimental work distinct from production pipeline:

```
project/
├── workflow/
│   ├── Snakefile              # Production pipeline
│   ├── rules/                 # Production rules
│   └── scripts/
│       ├── explorations/      # Exploration scripts ← Your focus
│       │   ├── examine_coverage_patterns.py
│       │   ├── test_map_filtering.py
│       │   └── compare_estimators.py
│       └── production/        # Production scripts
├── explorations.smk           # Exploration workflow ← Define rules here
├── config.yaml                # Shared configuration
└── results/
    └── explorations/          # Exploration outputs
```

## explorations.smk Structure

```python
configfile: "config.yaml"

# Exploration rules - self-contained, topic-focused
rule examine_coverage:
    output:
        "results/explorations/coverage_patterns.png"
    script:
        "workflow/scripts/explorations/examine_coverage_patterns.py"

rule test_filtering:
    input:
        map="data/raw_map.fits"
    output:
        "results/explorations/filtering_comparison.png"
    params:
        thresholds=[0.8, 0.9, 0.95, 0.99]
    script:
        "workflow/scripts/explorations/test_map_filtering.py"

rule compare_estimators:
    input:
        data="data/sample_data.pkl"
    output:
        report="results/explorations/estimator_comparison.html",
        data="results/explorations/estimator_results.csv"
    script:
        "workflow/scripts/explorations/compare_estimators.py"
```

**Key characteristics**:
- One rule per exploration topic
- Self-contained (minimal dependencies)
- Outputs to `results/explorations/`
- Can share config with main workflow
- No complex DAG - simple, linear rules

## Exploration Script Template

Scripts use `# %%` cell delimiters for interactive execution in VS Code, Jupyter, Spyder:

```python
# workflow/scripts/explorations/examine_coverage_patterns.py

# %% Imports
import numpy as np
import healpy as hp
import matplotlib.pyplot as plt
import seaborn as sns

# %% Configuration
# Access Snakemake objects (available when run via Snakemake)
try:
    output_file = snakemake.output[0]
    config = snakemake.config
except NameError:
    # Fallback for interactive execution
    output_file = "results/explorations/coverage_patterns.png"
    config = {"nside": 512}

# %% Load data
nside = config["nside"]
npix = hp.nside2npix(nside)

# Simulate or load real data
coverage_map = hp.read_map("data/coverage.fits")

# %% Analysis
# Examine coverage statistics
coverage_stats = {
    "mean": np.mean(coverage_map),
    "median": np.median(coverage_map),
    "std": np.std(coverage_map),
    "min": np.min(coverage_map),
    "max": np.max(coverage_map)
}

print("Coverage statistics:")
for key, val in coverage_stats.items():
    print(f"  {key}: {val:.4f}")

# %% Visualization
sns.set_palette("husl", 3)

fig, axes = plt.subplots(1, 2, figsize=(12, 4))

# Histogram
axes[0].hist(coverage_map, bins=50, alpha=0.7)
axes[0].set_xlabel("Coverage")
axes[0].set_ylabel("Frequency")
axes[0].set_title("Coverage Distribution")

# Map visualization
hp.mollview(coverage_map, title="Coverage Map", hold=True, sub=(1, 2, 2))

plt.tight_layout()
plt.savefig(output_file, dpi=150, bbox_inches='tight')
print(f"Saved: {output_file}")

# %%
```

**Cell structure breakdown**:
- **Imports cell**: All required packages
- **Configuration cell**: Handle both Snakemake and interactive execution
- **Data loading cell**: Load inputs
- **Analysis cells**: One or more cells for computation
- **Visualization cell**: Create plots/outputs
- **Final cell**: Empty cell for interactive work

## Self-Contained Imports

Each exploration script imports everything it needs at the top:

```python
# %% Imports
import numpy as np
import healpy as hp
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import pickle
from pathlib import Path

# Project-specific imports
from scipy.stats import chi2
from astropy.io import fits
```

**Why**: Explorations should be runnable standalone without complex dependencies. This makes them useful references later.

## Handling Snakemake vs Interactive Execution

Use try/except to support both modes:

```python
# %% Configuration
try:
    # Running via Snakemake
    input_files = snakemake.input
    output_file = snakemake.output[0]
    threshold = snakemake.params.threshold
    config = snakemake.config
except NameError:
    # Interactive execution - use defaults
    input_files = ["data/sample.fits"]
    output_file = "results/explorations/test_output.png"
    threshold = 0.95
    config = {"nside": 512}
```

This pattern allows:
- Running via Snakemake: `snakemake -s explorations.smk results/explorations/test_output.png`
- Running interactively: Cell-by-cell in editor
- Running as script: `python workflow/scripts/explorations/test_script.py`

## Execution Pattern

```bash
# Run specific exploration
snakemake -s explorations.smk results/explorations/coverage_patterns.png

# List available explorations
snakemake -s explorations.smk --list

# Dry-run to verify
snakemake -s explorations.smk -n results/explorations/coverage_patterns.png
```

**Note**: Explorations typically run locally (not on cluster) since they're for interactive development. If an exploration becomes computationally intensive, consider moving it to the main workflow or marking resources for cluster execution.

## Topic-Based Naming

Name explorations by conceptual topic, not chronologically:

**Good naming**:
- `examine_coverage_patterns.py` - Clear what it investigates
- `test_map_filtering.py` - Clear what it tests
- `compare_binning_schemes.py` - Clear what it compares

**Poor naming**:
- `exploration_1.py` - No context
- `test_new_idea.py` - Vague
- `debug_stuff.py` - Not descriptive

## When to Promote to Main Workflow

Consider promoting an exploration to the main production workflow when:

1. **Results are definitive**: The analysis produces results you'll use in papers/reports
2. **Needs to run regularly**: You'll re-run it for different datasets
3. **Has dependencies**: Other analyses depend on its outputs
4. **Computationally intensive**: Needs cluster resources, worth tracking in main DAG

**How to promote**:
1. Move script from `workflow/scripts/explorations/` to `workflow/scripts/`
2. Add rule to main `workflow/Snakefile` or `workflow/rules/*.smk`
3. Add proper resource specifications
4. Integrate outputs into main workflow DAG
5. Remove try/except for Snakemake object access (always runs via Snakemake)

## Integration with Main Workflow

Explorations can use outputs from the main workflow:

```python
# explorations.smk
rule explore_processed_maps:
    input:
        # Use output from main workflow
        maps=expand("results/maps/{freq}_map.fits",
                    freq=config["frequencies"])
    output:
        "results/explorations/map_quality_assessment.png"
    script:
        "workflow/scripts/explorations/assess_map_quality.py"
```

But main workflow should NOT depend on exploration outputs (keep it one-directional).

## Visualization Standards

Follow project conventions from CLAUDE.md:

```python
import seaborn as sns

# Set palette based on number of series
n_series = len(datasets)
sns.set_palette("husl", n_series)

# Create plots
fig, ax = plt.subplots()
for dataset in datasets:
    ax.plot(dataset.x, dataset.y, label=dataset.name)

ax.legend()
plt.savefig(output_file, dpi=150, bbox_inches='tight')
```

## Common Exploration Patterns

### Pattern 1: Parameter Sweep

```python
# explorations.smk
rule sweep_thresholds:
    output:
        "results/explorations/threshold_sweep.png"
    params:
        thresholds=np.linspace(0.5, 1.0, 11)
    script:
        "workflow/scripts/explorations/sweep_thresholds.py"
```

### Pattern 2: Method Comparison

```python
# explorations.smk
rule compare_methods:
    input:
        data="data/test_sample.pkl"
    output:
        plot="results/explorations/method_comparison.png",
        table="results/explorations/method_metrics.csv"
    script:
        "workflow/scripts/explorations/compare_methods.py"
```

### Pattern 3: Data Quality Assessment

```python
# explorations.smk
rule assess_quality:
    input:
        expand("data/{sample}.fits", sample=config["samples"])
    output:
        report="results/explorations/quality_report.html"
    script:
        "workflow/scripts/explorations/assess_quality.py"
```

## Best Practices

1. **One exploration = one topic**: Each script investigates a single question or comparison
2. **Self-contained**: All imports at top, minimal dependencies on project modules
3. **Cell delimiters**: Use `# %%` for interactive development
4. **Dual-mode support**: try/except for Snakemake vs interactive execution
5. **Clear outputs**: Save figures and data to `results/explorations/`
6. **Descriptive naming**: Topic-based names, not chronological
7. **Document findings**: Add comments about what you learned, surprising results
8. **Promote when ready**: Move successful explorations to main workflow

## Quick Reference

```python
# explorations.smk
rule exploration_name:
    input:
        "data/input.fits"  # Optional
    output:
        "results/explorations/output.png"
    params:
        param=value  # Optional
    script:
        "workflow/scripts/explorations/script_name.py"

# Script template
# %% Imports
import numpy as np
# ... all imports ...

# %% Configuration
try:
    input_file = snakemake.input[0]
    output_file = snakemake.output[0]
except NameError:
    input_file = "data/test.fits"
    output_file = "results/explorations/test.png"

# %% Analysis
# ... your exploration code ...

# %% Save results
plt.savefig(output_file)
# %%

# Execution
# snakemake -s explorations.smk results/explorations/output.png
```

For integrating explorations into the main workflow or complex DAG issues, use the main snakemake-expert agent.
