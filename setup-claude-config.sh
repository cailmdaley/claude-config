#!/bin/bash

# Setup script for Claude Code configuration
# Deploys global CLAUDE.md, research-assistant plugin, and output style

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Parse arguments
print_usage() {
    echo "Usage: $0 [-h|--help]"
    echo ""
    echo "Deploys Claude Code configuration:"
    echo "  - Global CLAUDE.md (research assistant configuration)"
    echo "  - research-assistant plugin (skills and agents)"
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
PLUGIN_SOURCE="$SCRIPT_DIR/research-assistant"
OUTPUT_STYLE_SOURCE="$SCRIPT_DIR/output-styles/research-assistant.md"

# Target locations
CLAUDE_CONFIG_TARGET="$CLAUDE_DIR/CLAUDE.md"
PLUGIN_TARGET="$CLAUDE_DIR/plugins/research-assistant"
OUTPUT_STYLE_TARGET="$CLAUDE_DIR/output-styles/research-assistant.md"

echo "Setting up Claude Code configuration..."
echo ""

# Create necessary directories
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/plugins"
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

# Deploy research-assistant plugin
if [ -d "$PLUGIN_SOURCE" ]; then
    echo "Installing research-assistant plugin..."
    ln -sf "$PLUGIN_SOURCE" "$PLUGIN_TARGET"
    echo "  ✓ research-assistant plugin → ~/.claude/plugins/research-assistant"

    # List skills
    if [ -d "$PLUGIN_SOURCE/skills" ]; then
        echo ""
        echo "  Plugin includes skills:"
        for skill_dir in "$PLUGIN_SOURCE/skills"/*; do
            if [ -d "$skill_dir" ]; then
                echo "    - $(basename "$skill_dir")"
            fi
        done
    fi
else
    echo "  ✗ Warning: research-assistant plugin not found, skipping..."
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
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Claude Code setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Activation instructions:"
echo ""
echo "1. Global configuration: Active immediately (CLAUDE.md)"
echo ""
echo "2. Research-assistant plugin: Restart Claude Code to activate"
echo "   - Includes 4 skills: catching-up, using-snakemake, implementing-code, reviewing-code"
echo "   - Skills provide always-on guidance for research workflows"
echo ""
echo "3. Output style: Run '/output-style research-assistant'"
echo "   to activate the research assistant communication style"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
