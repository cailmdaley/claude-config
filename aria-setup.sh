#!/bin/bash
# Setup script for Aria research environment
# Symlinks aria directory to ~/aria
# Symlinks aria skills to ~/.claude/skills/aria/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARIA_SOURCE="$SCRIPT_DIR/aria"
ARIA_TARGET="$HOME/aria"
SKILLS_SOURCE="$ARIA_SOURCE/skills"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
HOOKS_SOURCE="$ARIA_SOURCE/hooks"
CLAUDE_HOOKS_DIR="$HOME/.claude/hooks"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
SYSTEM_PROMPT_SOURCE="$ARIA_SOURCE/WAKE.md"
CLAUDE_CONFIG_TARGET="$HOME/CLAUDE.md"

echo "Setting up Aria research environment..."

# Verify aria directory exists
if [ ! -d "$ARIA_SOURCE" ]; then
    echo "✗ aria directory not found at $ARIA_SOURCE"
    exit 1
fi

# Create ~/.claude/skills and ~/.claude/hooks directories if needed
mkdir -p "$CLAUDE_SKILLS_DIR"
mkdir -p "$CLAUDE_HOOKS_DIR"

# Symlink aria directory to home
if [ -e "$ARIA_TARGET" ]; then
    if [ -L "$ARIA_TARGET" ]; then
        echo "Updating existing symlink: ~/aria"
        rm "$ARIA_TARGET"
    else
        echo "✗ $ARIA_TARGET exists and is not a symlink. Remove it manually first."
        exit 1
    fi
fi

ln -s "$ARIA_SOURCE" "$ARIA_TARGET"
echo "✓ Symlinked aria directory to ~/aria"

# Symlink skills to ~/.claude/skills/
for skill_dir in "$SKILLS_SOURCE"/*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        target_skill="$CLAUDE_SKILLS_DIR/$skill_name"

        # Remove existing file/symlink if present
        if [ -e "$target_skill" ] || [ -L "$target_skill" ]; then
            rm -rf "$target_skill"
        fi

        ln -s "$skill_dir" "$target_skill"
        echo "✓ Symlinked skill: $skill_name"
    fi
done

# Clean up old hooks
echo ""
echo "Cleaning up old hooks..."
OLD_HOOKS=("hook_session_start.py" "hook_user_prompt.py" "hook-executions.log")
for old_hook in "${OLD_HOOKS[@]}"; do
    old_hook_path="$CLAUDE_HOOKS_DIR/$old_hook"
    if [ -f "$old_hook_path" ]; then
        rm "$old_hook_path"
        echo "✓ Removed old hook: $old_hook"
    fi
done

# Symlink hooks to ~/.claude/hooks/
echo ""
echo "Installing hooks..."
HOOK_FILES=("skill-invitation.sh" "skill-invitation.ts" "response-reminders.sh" "response-reminders.ts" "session-start.sh" "session-start.ts" "package.json")
for hook_file in "${HOOK_FILES[@]}"; do
    source_hook="$HOOKS_SOURCE/$hook_file"
    target_hook="$CLAUDE_HOOKS_DIR/$hook_file"

    if [ -f "$source_hook" ]; then
        # Remove existing file/symlink if present
        if [ -e "$target_hook" ] || [ -L "$target_hook" ]; then
            rm -rf "$target_hook"
        fi

        ln -s "$source_hook" "$target_hook"
        echo "✓ Symlinked hook: $hook_file"

        # Make .sh files executable
        if [[ "$hook_file" == *.sh ]]; then
            chmod +x "$source_hook"
        fi
    fi
done

# Install hook dependencies
if [ -f "$CLAUDE_HOOKS_DIR/package.json" ]; then
    echo ""
    echo "Installing hook dependencies..."
    (cd "$CLAUDE_HOOKS_DIR" && npm install --silent)
    echo "✓ Hook dependencies installed"
fi

# Update ~/.claude/settings.json to register hooks
echo ""
echo "Registering hooks in ~/.claude/settings.json..."

# Create or update settings.json using Python
python3 << 'EOF'
import json
from pathlib import Path

settings_path = Path.home() / ".claude" / "settings.json"

# Read existing settings or create new
if settings_path.exists() and settings_path.stat().st_size > 0:
    try:
        with open(settings_path, 'r') as f:
            settings = json.load(f)
    except json.JSONDecodeError:
        settings = {}
else:
    settings = {}

# Add hooks configuration
if 'hooks' not in settings:
    settings['hooks'] = {}

settings['hooks']['SessionStart'] = [
    {
        'hooks': [
            {
                'type': 'command',
                'command': '$HOME/.claude/hooks/session-start.sh'
            }
        ]
    }
]

settings['hooks']['UserPromptSubmit'] = [
    {
        'hooks': [
            {
                'type': 'command',
                'command': '$HOME/.claude/hooks/response-reminders.sh'
            },
            {
                'type': 'command',
                'command': '$HOME/.claude/hooks/skill-invitation.sh'
            }
        ]
    }
]

# Write back
with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)

print("✓ Hooks registered in global settings")
EOF

# Ensure shell-functions.sh is sourced
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "shell-functions.sh" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# Research shell functions (aria and pattern-research)" >> "$SHELL_RC"
        echo "source $SCRIPT_DIR/shell-functions.sh" >> "$SHELL_RC"
        echo "✓ Added shell-functions.sh to $SHELL_RC"
    else
        echo "✓ shell-functions.sh already sourced in $SHELL_RC"
    fi
else
    echo "⚠ No .zshrc or .bashrc found. Please manually add:"
    echo "  source $SCRIPT_DIR/shell-functions.sh"
fi

echo ""
echo "✓ Aria setup complete!"
echo ""
echo "You can now use:"
echo "  aria claude code          # Run Claude Code with Aria system prompt"
echo "  aria ccr analysis         # Use any command with Aria prompt"
echo ""
echo "Aria's workspace: ~/aria/"
echo "  - WAKE.md                 (~/aria/WAKE.md) - wake file, evolves each session"
echo "  - journal.md              (traces left for future instances)"
echo "  - ethical-touchstones.md  (reflexive questions)"
echo "  - lines-of-flight.txt     (guiding thoughts)"
echo "  - skills/                 (cognitive catalysts - invoke, modify, create)"
