---
name: catch-up
description: Quick research status overview - todos, recent progress, running jobs, and recent work
model: claude-4-5-haiku
---

Provide a concise status overview for the current research project. This skill accepts optional focus text to filter results around specific concepts.

**Usage:**
- Type "catch-up" - General overview of recent activity
- Type "catch-up n(z)s" - Focus on redshift distribution work
- Type "catch-up calibration" - Focus on calibration-related work

The focus text performs wide-ranging, case-insensitive matching across file names and contents. Use conceptual terms, and be liberal with variations (e.g., "n(z)s" should also catch "DNDZ", "redshift", "photo-z").

---

## Information Gathering Strategy

### 1. ALWAYS: Recent File Activity (Core Context)
Find the 10 most recently modified files (excluding common non-work patterns):
- Use `find` to list files, sorted by modification time
- **Exclude:** `.*/` (dot directories), `_*/` (underscore directories), `*.pyc`, `*.log`, `.git/`
- **Get 10 most recent:** Assess relevance based on modification date and file name

**If focus text provided:**
- Use `grep -i` to search file contents for focus text and related terms
- Prioritize files with matches
- Consider conceptual expansions (e.g., "n(z)s" → also search for "redshift", "DNDZ", "photo-z")

**Read 2-3 most relevant files:**
- If focused: Read top matches from grep
- If unfocused: Read most recently modified files that appear relevant
- Extract: Current work direction, key variables/functions, recent changes

**Purpose:** This section always works, even in bare directories or new projects.

---

### 2. ALWAYS: Active Todos
Check current todos from Claude Code's todo system. If focus text provided, highlight relevant todos.

---

### 3. CONDITIONAL: Git Status (if `.git/` exists)
**Check for:** `.git/` directory

If exists:
1. **Check uncommitted changes:** Run `git status --short` to see modified, staged, and untracked files
2. **Show most recent commit:** Run `git log -1 --oneline` to display the latest commit message and hash
3. **Note:** Brief summary of what's uncommitted and what was last committed

If not a git repository, skip this section entirely.

---

### 4. CONDITIONAL: Research Progress (if `docs/` exists)
**Check for:** `docs/RESEARCH_PROGRESS.qmd` or `docs/RESEARCH_PROGRESS.md`

If exists:
- Scan last 2-3 dated entries
- Focus on: what was investigated, key findings, open questions
- If focus text: only summarize entries related to focus concept

**Check for:** `docs/explorations/*.qmd` or similar exploration files

If exists:
- List 3-5 most recently modified
- If focus text: filter for relevant explorations only
- Show: filename, date, brief topic

If `docs/` doesn't exist or is empty, skip this section entirely.

---

### 5. CONDITIONAL: Workflow Status (if `.snakemake/` exists)
**CRITICAL: Never run snakemake directly.** The Snakemake log is the primary entry point for all workflow management.

**Check for:** `.snakemake/log/` directory

If exists:
1. **Find 5 most recent Snakemake logs** in `.snakemake/log/` (sorted by modification time)
2. **Assess temporal clustering:** Check modification times of these logs
   - If multiple logs are clustered together in time (e.g., within last few hours/days), read all clustered logs
   - If logs span a long time period, focus on the most recent 1-2
3. **Parse log(s) for status:**
   - Job completion status
   - Current rule being executed
   - Any error messages
   - Links to Slurm log files (e.g., `slurm-*.out`)
4. **If job is running or failed:** Read linked Slurm logs to get detailed status
   - Look for paths like `slurm-<jobid>.out` mentioned in Snakemake log
   - Check for error messages, resource usage, completion status
5. **Assess workflow state:** What rules completed? What's pending? What failed?

**Also check:** `workflow/` directory for recent modifications to Snakefile, rules/*.smk, scripts/*
- If focus text: only show files matching the concept
- Note key recent changes to workflow infrastructure

If no `.snakemake/` directory, skip this section entirely.

---

### 6. CONDITIONAL: Running Jobs (if `squeue` available)
**Check for:** Active Slurm jobs with `squeue -u $USER`

If available and jobs running:
- Show: Job IDs, names, status, runtime
- If focus text: filter for jobs matching the concept
- Note any notable resource usage

If no `squeue` or no jobs running, skip or briefly note.

---

## Output Format

Provide a **concise, focused summary** in this structure:

```
## Research Status [for <focus-concept>]

**Recent work:**
[Based on recently modified files - what's actively being developed?]
[If files were read: key observations from those files]

**Active todos:**
[Current todos, filtered by focus if provided]

**Git status:** [if .git/ exists]
[Uncommitted changes and most recent commit]

**Research progress:** [if docs/ exists]
[Recent progress entries, filtered by focus if provided]

**Workflow status:** [if workflow/ exists]
[Recent changes, current state, filtered by focus if provided]

**Running jobs:** [if any]
[Active jobs, filtered by focus if provided]

---

What should we work on next?
```

**Key Principles:**
- **Always functional:** Recent files work everywhere
- **Gracefully degrade:** Skip sections when infrastructure doesn't exist
- **Focus-aware:** Filter everything by focus text when provided
- **Context-building:** Actually read relevant files, don't just list them
- **Brief:** This is orientation, not a comprehensive report

**Tone:** Direct and matter-of-fact. This is a status check. Missing sections are normal, not a problem. If focused on a concept and nothing is found, say so clearly.
