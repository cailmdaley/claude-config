---
description: Quick research status overview - todos, recent progress, running jobs, and recent work
---

Provide a concise status overview for the current research project. Check these in order, handling missing files/directories gracefully:

## 1. Active Todos
List current todos with their status. If none exist, note that.

## 2. Recent Research Progress
If `docs/RESEARCH_PROGRESS.qmd` exists, scan and summarize the last 2-3 dated entries. Focus on:
- What was being investigated
- Key findings or outcomes
- Any open questions or next steps mentioned

If the file doesn't exist, note it and move on.

## 3. Recent Explorations
Check for `docs/explorations/*.qmd` files. List the 3-5 most recently modified ones with:
- Filename (date + topic gives context)
- Last modified date
- Brief topic if extractable from filename

If directory doesn't exist or is empty, note it and move on.

## 4. Running Jobs
Check for active Slurm jobs with `squeue -u $USER` (if squeue is available). Show:
- Job IDs and names
- Status and runtime
- Any notable resource usage

If no jobs running or squeue unavailable, note it and move on.

## 5. Recent Workflow Activity
Check for recently modified files in `workflow/` directory (if it exists):
- Snakefile modifications
- New or changed rule files
- Modified scripts

Show last modified dates for context. If workflow directory doesn't exist, note it.

## 6. Snakemake Status
If a Snakefile exists, optionally run `snakemake --summary` or `snakemake --detailed-summary` to show workflow state. Handle locked workflows or errors gracefully - just note the issue without failing.

---

## Output Format

After gathering this information, provide a **concise summary** in this structure:

```
## Research Status

**Active work:**
[Summary of todos and what seems to be in progress]

**Recent progress:**
[Highlights from RESEARCH_PROGRESS.qmd if available]

**Recent explorations:**
[List of recent .qmd files if any]

**Running jobs:**
[Active Slurm jobs or "None running"]

**Workflow status:**
[Recent workflow changes or current state]

---

What are we working on?
```

Keep it brief - this is a quick orientation tool, not a comprehensive report. If most sections have nothing to report (common in new projects), that's fine - just note it and ask what the user wants to work on.

**Tone**: Direct and matter-of-fact. This is a status check, not a presentation. Missing information is normal, not a problem.
