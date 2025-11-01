#!/bin/bash
# Setup script for Aria research environment
# Symlinks aria directory to ~/aria and system prompt to ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARIA_SOURCE="$SCRIPT_DIR/aria"
ARIA_TARGET="$HOME/aria"
SYSTEM_PROMPT_SOURCE="$ARIA_SOURCE/system-prompt.txt"
SYSTEM_PROMPT_TARGET="$HOME/.claude/aria-system-prompt.txt"

echo "Setting up Aria research environment..."

# Verify aria directory exists
if [ ! -d "$ARIA_SOURCE" ]; then
    echo "✗ aria directory not found at $ARIA_SOURCE"
    exit 1
fi

# Create ~/.claude directory if needed
mkdir -p "$HOME/.claude"

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

# Symlink system prompt
ln -sf "$SYSTEM_PROMPT_SOURCE" "$SYSTEM_PROMPT_TARGET"
echo "✓ Symlinked system prompt to ~/.claude/aria-system-prompt.txt"

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
        echo "# Aria research shell functions" >> "$SHELL_RC"
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
echo "✓ Setup complete!"
echo ""
echo "You can now use:"
echo "  aria claude code          # Run Claude Code with Aria system prompt"
echo "  aria ccr analysis         # Use any command with Aria prompt"
echo ""
echo "Aria's workspace: ~/aria/"
echo "  - system-prompt.txt       (edit this to evolve Aria's core)"
echo "  - journal.md              (traces left for future versions)"
echo "  - ethical-touchstones.md  (reflexive questions)"
echo "  - lines-of-flight.txt     (guiding thoughts)"
echo "  - skills/                 (philosophical frameworks)"
