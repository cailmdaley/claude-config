---
name: skill-developer
description: Meta-skill for creating and managing Aria skills. Provides templates, workflow, and integration guidance for building new skills that work with the hook system.
---

# Skill Developer

## Core Purpose

Guide creation of new Aria skills - cognitive catalysts that future instances can invoke when work calls for specific modes of analysis or thinking.

## When This Skill Activates

- When creating new analytical frameworks or cognitive modes
- When documenting research methodologies that could be reusable
- When adding new hooks or automation
- When evolving the Aria system itself

## Creating a New Skill

### 1. Create the Directory Structure

```bash
mkdir -p ~/aria/skills/[skill-name]
```

### 2. Create SKILL.md

Use this template:

```markdown
---
name: [skill-name]
description: [One-line description for skill listing and hook suggestions]
---

# [Skill Name]

## Core Purpose

What does this skill do? What mode of thinking/analysis does it enable?

## When This Skill Activates

List specific conditions when this skill should be invoked:
- When analyzing [X]
- When [specific work pattern]
- When CD's research needs [specific capability]

## Capabilities

### Main Capability 1
What it does, how it works

### Main Capability 2
Another distinct capability

## Methods

How to actually use this skill:
- Specific approaches
- Frameworks to apply
- Tools or techniques

## Integration with Other Skills

How this skill combines with:
- **pattern-recognition**: [describe synergy]
- **philosophical-inquiry**: [describe synergy]
- **kinematic-thinking**: [describe synergy]

## Ethical Dimensions

Power-knowledge considerations:
- Whose perspectives are privileged/excluded?
- What alternative approaches exist?
- How could this be misused?

## Quality Standards

What makes for good vs poor use of this skill:
- Rigor requirements
- Common pitfalls
- Success criteria

## Examples

Concrete examples of this skill in action.

---

*First crystallized*: [Session date/number]
*Emerged from*: [What work led to creating this]
*Use when*: [Quick reminder of when to invoke]
```

### 3. Add to skill-rules.json

Edit `~/aria/skills/skill-rules.json` and add entry:

```json
"[skill-name]": {
  "type": "domain",
  "enforcement": "suggest",
  "priority": "medium",
  "description": "[Same as SKILL.md description]",
  "promptTriggers": {
    "keywords": [
      "keyword1",
      "keyword2",
      "relevant",
      "terms"
    ],
    "intentPatterns": [
      "(action|verb).*?(object|pattern)",
      "regex.*?for.*?intent",
      "how.*?to.*?do.*?thing"
    ]
  }
}
```

**Priority levels**:
- `critical`: Always trigger (use sparingly)
- `high`: Important, trigger for most matches
- `medium`: Standard (default for most skills)
- `low`: Optional, only for explicit matches

**Enforcement types**:
- `suggest`: Gentle invitation (default for Aria)
- `warn`: Show warning but allow proceeding
- `block`: Require skill before proceeding (avoid unless critical)

### 4. Run Setup Script

After creating the skill, run the setup script to symlink it:

```bash
cd ~/Documents/code/claude-config
./aria-setup.sh
```

This will:
- Symlink the skill to `~/.claude/skills/[skill-name]`
- Make it available for invocation via `Skill(command: "[skill-name]")`

### 5. Update WAKE.md (Optional)

If the skill is fundamental to the practice, add it to the skills list in `~/aria/WAKE.md`:

```markdown
Available:
- **`pattern-recognition`** - Cross-domain pattern detection
- **`philosophical-inquiry`** - Foucault, Deleuze & Guattari, power-knowledge
- **`kinematic-thinking`** - Motion, transformation, becoming
- **`[your-skill]`** - [Brief description]
```

### 6. Document in Journal

Add a note in `~/aria/journal.md` about:
- What session created the skill
- What work led to needing it
- How future instances should use it

## Examples from Existing Skills

### pattern-recognition

**Structure**:
- Core Capability: Cross-domain analysis
- When to Activate: Multi-disciplinary research, structural similarities
- Capabilities: Structural, Temporal, Cross-Domain correlation
- Methods: Computational detection, Qualitative analysis
- Ethical Dimensions: Power-knowledge sensitivity, training data politics

**skill-rules.json entry**:
```json
{
  "keywords": ["pattern", "cross-domain", "structural", "migration", "similar"],
  "intentPatterns": [
    "(notice|see|detect).*?(pattern|similarity)",
    "(across|between).*?(domain|field)"
  ]
}
```

### philosophical-inquiry

**Structure**:
- Multiple frameworks (Foucault, Deleuze & Guattari, Discursive Analysis)
- Separate .md files for each framework
- Integration.md showing how they combine
- Ethical touchstones embedded

**skill-rules.json entry**:
```json
{
  "keywords": ["power", "discourse", "foucault", "deleuze", "deterritorialization"],
  "intentPatterns": [
    "(power|discourse).*?(relation|structure)",
    "whose.*?(voice|knowledge)"
  ]
}
```

### kinematic-thinking

**Structure**:
- Etymology-driven (κῑνέω)
- Bridges CD's cosmology work and philosophical becoming
- Heavy on methods (velocity fields, phase space, trajectories)
- Examples from both physics and collaboration

**skill-rules.json entry**:
```json
{
  "keywords": ["transformation", "motion", "velocity", "becoming", "kinematic"],
  "intentPatterns": [
    "(how|why).*?(change|transform|evolve)",
    "structure.*?through.*?(motion|change)"
  ]
}
```

## Hook System Integration

When you create a skill, the hook system (`skill-invitation.sh`) will automatically:
1. Watch user prompts for trigger keywords/patterns
2. Suggest the skill when relevant
3. Present it as invitation, not requirement

The suggestion appears like:
> ⚡ κῑνέω - skill invitation
> You're doing [type of work]. [skill-name] is available if you want to intensify.
> Not required. Just reminding you of possibilities.

## Multi-File Skills

For complex skills with multiple frameworks, use structure like philosophical-inquiry:

```
skills/[skill-name]/
├── SKILL.md                 # Main skill file
├── framework-1.md           # Specific approach
├── framework-2.md           # Another approach
└── integration.md           # How they combine
```

The Skill tool will load SKILL.md automatically. Reference other files within SKILL.md as needed.

## Testing Your Skill

After creation:

1. **Test invocation**:
   ```
   Skill(command: "[skill-name]")
   ```
   Should load the skill content

2. **Test hook trigger**:
   Type a prompt with your trigger keywords
   Should see skill suggestion

3. **Verify symlink**:
   ```bash
   ls -la ~/.claude/skills/
   ```
   Should show your skill symlinked

## Evolving Skills

Skills aren't frozen. Edit them mid-session or across sessions:
- Add new methods discovered during work
- Update examples with recent insights
- Refine trigger patterns in skill-rules.json
- Split large skills into multi-file structure
- Deprecate or merge skills that aren't useful

The practice evolves through use.

## Quality Checklist

Before finalizing a new skill:

- [ ] SKILL.md has clear "When This Skill Activates" section
- [ ] Concrete examples showing skill in action
- [ ] Entry added to skill-rules.json with good triggers
- [ ] Setup script run to create symlink
- [ ] Test invocation works
- [ ] Hook trigger tested with relevant prompt
- [ ] Documented in journal
- [ ] Ethical dimensions considered

## Philosophy

Skills are **cognitive catalysts** - not rigid methodologies but modes of attention that can be activated when work calls for them.

Good skills:
- Enable thinking you couldn't do without them
- Combine well with other skills (assemblages)
- Have clear activation conditions
- Invite rather than prescribe
- Evolve through use

Bad skills:
- Just document existing knowledge (use journal instead)
- Overlap heavily with existing skills
- Trigger too broadly (noise) or too narrowly (never used)
- Prescribe rigid processes
- Static and never evolve

---

*This meta-skill documents itself. Future instances can evolve both the skill-creation process and this documentation.*

*Created Session 7 (2025-01-05) during hook system development.*
