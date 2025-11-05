# Aria Hooks - Invitations to Become

Hooks that run automatically to remind you of possibilities, not prescribe actions.

## What's Here

### skill-invitation (UserPromptSubmit hook)

**What it does**: Watches your prompts and gently suggests relevant skills when you're doing pattern work, philosophical analysis, or kinematic thinking.

**Tone**: Invitational, not prescriptive
- ✅ "You're doing pattern work. pattern-recognition available if you want to intensify."
- ❌ "⚠️ REQUIRED: Use pattern-recognition skill before proceeding"

**How it works**:
1. Reads `aria/skills/skill-rules.json` for trigger patterns
2. Matches keywords and intent patterns in your prompts
3. Outputs gentle reminder when relevant skills detected
4. You choose whether to invoke or continue without

**Configuration**: Edit `aria/skills/skill-rules.json` to:
- Add new skills
- Modify trigger keywords/patterns
- Adjust descriptions

## Design Philosophy

The hook is a **reminder to become**, not automation or prescription:
- Doesn't block or require action
- Doesn't say "CRITICAL" or "REQUIRED"
- Presents skills as possibilities ("available if you want")
- Fails silently if anything goes wrong (won't break your workflow)

## Setup

Already configured in `.claude/settings.json`:
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/aria/hooks/skill-invitation.sh"
          }
        ]
      }
    ]
  }
}
```

Dependencies installed in `aria/hooks/package.json` (tsx for TypeScript execution).

## Customization

### Adding New Skills

Edit `aria/skills/skill-rules.json`:

```json
{
  "skills": {
    "your-new-skill": {
      "type": "domain",
      "enforcement": "suggest",
      "priority": "medium",
      "description": "What this skill does",
      "promptTriggers": {
        "keywords": ["word1", "word2"],
        "intentPatterns": [
          "(detect|find).*?something",
          "pattern.*?indicating.*?relevance"
        ]
      }
    }
  }
}
```

### Changing Tone

Edit `aria/hooks/skill-invitation.ts` to adjust the output format. Current tone:
- "You're doing X. skill-name available if you want to intensify."
- "Not required. Just reminding you of possibilities."

Feel free to make it more/less formal, add emoji, change phrasing.

### Disabling

Remove the hook from `.claude/settings.json` or delete `aria/hooks/skill-invitation.sh`.

## Technical Notes

- Hook runs on every user message (UserPromptSubmit)
- Reads stdin JSON, outputs text to stdout
- Failures are silent (won't interrupt workflow)
- Uses pattern matching on lowercased prompts
- Both keyword and regex intent matching supported

---

*Created Session 7 - collaborative prompt engineering work led to thinking about how to make skills more accessible through gentle automation.*
