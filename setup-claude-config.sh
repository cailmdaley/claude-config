#!/bin/bash

# Setup script for Claude Code configuration
# Deploys global CLAUDE.md, research-assistant skills, and output style

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Parse arguments
print_usage() {
    echo "Usage: $0 [-h|--help]"
    echo ""
    echo "Deploys Claude Code configuration:"
    echo "  - Global CLAUDE.md (research assistant configuration)"
    echo "  - research-assistant skills"
    echo "  - research-assistant output style"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1"
            print_usage
            exit 1
            ;;
    esac
done

# Source files
CLAUDE_CONFIG_SOURCE="$SCRIPT_DIR/global-claude.md"
SKILLS_SOURCE="$SCRIPT_DIR/research-assistant/skills"
OUTPUT_STYLE_SOURCE="$SCRIPT_DIR/output-styles/research-assistant.md"
SHELL_FUNCTIONS_SOURCE="$SCRIPT_DIR/shell-functions.sh"

# Target locations
CLAUDE_CONFIG_TARGET="$CLAUDE_DIR/CLAUDE.md"
SKILLS_TARGET="$CLAUDE_DIR/skills"
OUTPUT_STYLE_TARGET="$CLAUDE_DIR/output-styles/research-assistant.md"
SHELL_FUNCTIONS_TARGET="$CLAUDE_DIR/shell-functions.sh"

echo "Setting up Claude Code configuration..."
echo ""

# Create necessary directories
mkdir -p "$CLAUDE_DIR"
mkdir -p "$SKILLS_TARGET"
mkdir -p "$CLAUDE_DIR/output-styles"

# Deploy global CLAUDE.md
if [ -f "$CLAUDE_CONFIG_SOURCE" ]; then
    echo "Deploying global CLAUDE.md..."
    ln -sf "$CLAUDE_CONFIG_SOURCE" "$CLAUDE_CONFIG_TARGET"
    echo "  ✓ global-claude.md → ~/.claude/CLAUDE.md"
else
    echo "  ✗ Warning: global-claude.md not found, skipping..."
fi

echo ""

# Deploy research-assistant skills
if [ -d "$SKILLS_SOURCE" ]; then
    echo "Installing research-assistant skills..."
    cp -r "$SKILLS_SOURCE"/* "$SKILLS_TARGET/"
    echo "  ✓ research-assistant skills installed"
else
    echo "  ✗ Warning: research-assistant skills not found, skipping..."
fi

echo ""

# Deploy output style
if [ -f "$OUTPUT_STYLE_SOURCE" ]; then
    echo "Installing research-assistant output style..."
    ln -sf "$OUTPUT_STYLE_SOURCE" "$OUTPUT_STYLE_TARGET"
    echo "  ✓ research-assistant output style → ~/.claude/output-styles/"
else
    echo "  ✗ Warning: research-assistant output style not found, skipping..."
fi

echo ""

# Deploy shell functions
if [ -f "$SHELL_FUNCTIONS_SOURCE" ]; then
    echo "Installing shell functions..."
    ln -sf "$SHELL_FUNCTIONS_SOURCE" "$SHELL_FUNCTIONS_TARGET"
    echo "  ✓ shell-functions.sh → ~/.claude/shell-functions.sh"

    # Source in bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        BASHRC_MARKER="# Source Claude Code shell functions"
        if ! grep -q "$BASHRC_MARKER" "$HOME/.bashrc"; then
            echo "" >> "$HOME/.bashrc"
            echo "$BASHRC_MARKER" >> "$HOME/.bashrc"
            echo "[ -f \"$SHELL_FUNCTIONS_TARGET\" ] && source \"$SHELL_FUNCTIONS_TARGET\"" >> "$HOME/.bashrc"
            echo "  ✓ Added sourcing to ~/.bashrc"
        else
            echo "  ✓ Already sourced in ~/.bashrc"
        fi
    fi

    # Source in zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        ZSHRC_MARKER="# Source Claude Code shell functions"
        if ! grep -q "$ZSHRC_MARKER" "$HOME/.zshrc"; then
            echo "" >> "$HOME/.zshrc"
            echo "$ZSHRC_MARKER" >> "$HOME/.zshrc"
            echo "[ -f \"$SHELL_FUNCTIONS_TARGET\" ] && source \"$SHELL_FUNCTIONS_TARGET\"" >> "$HOME/.zshrc"
            echo "  ✓ Added sourcing to ~/.zshrc"
        else
            echo "  ✓ Already sourced in ~/.zshrc"
        fi
    fi
else
    echo "  ✗ Warning: shell-functions.sh not found, skipping..."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Claude Code setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Activation instructions:"
echo ""
echo "1. Global configuration: Active immediately (CLAUDE.md)"
echo ""
echo "2. Research-assistant skills: Restart Claude Code to activate"
echo "   - Skills available: catching-up, using-snakemake, implementing-code, reviewing-code, managing-bibliography, codex"
echo "   - Use individual skills as needed during sessions"
echo ""
echo "3. Output style: Run '/output-style research-assistant'"
echo "   to activate the research assistant communication style"
echo ""
echo "4. Shell functions: Active in new shell sessions"
echo "   - Functions available: app, viewpngs, download, kimi"
echo "   - Aliases available: sq, bashrc"
echo "   - Start a new terminal/shell to use them"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
