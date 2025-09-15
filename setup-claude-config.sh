#!/bin/bash

# Setup script for Claude Code agent configuration
# Symlinks scientific computing agents to global ~/.claude/agents directory
# Symlinks global-claude.md to home directory as CLAUDE.md

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
CLAUDE_CONFIG_SOURCE="$SCRIPT_DIR/global-claude.md"
CLAUDE_CONFIG_TARGET="$HOME/CLAUDE.md"

# Agents to symlink (scientific computing focused)
AGENTS=(
    "developer.md"
    "opinionated-editor.md"
    "quality-reviewer.md"
    "snakemake-expert.md"
)

echo "Setting up Claude Code agent configuration..."

# Create the global agents directory if it doesn't exist
if [ ! -d "$CLAUDE_AGENTS_DIR" ]; then
    echo "Creating ~/.claude/agents directory..."
    mkdir -p "$CLAUDE_AGENTS_DIR"
fi

# Symlink global-claude.md to home directory as CLAUDE.md
if [ -f "$CLAUDE_CONFIG_SOURCE" ]; then
    echo "Symlinking global-claude.md..."
    ln -sf "$CLAUDE_CONFIG_SOURCE" "$CLAUDE_CONFIG_TARGET"
else
    echo "Warning: global-claude.md not found in repository, skipping..."
fi

# Symlink each agent
for agent in "${AGENTS[@]}"; do
    source_file="$AGENTS_DIR/$agent"
    target_file="$CLAUDE_AGENTS_DIR/$agent"
    
    if [ ! -f "$source_file" ]; then
        echo "Warning: $source_file not found, skipping..."
        continue
    fi
    
    echo "Symlinking $agent..."
    ln -sf "$source_file" "$target_file"
done

echo "✓ Claude Code setup complete!"
echo ""
echo "Global configuration:"
if [ -L "$CLAUDE_CONFIG_TARGET" ]; then
    echo "  ✓ global-claude.md symlinked to ~/CLAUDE.md"
fi
echo ""
echo "Active agents:"
for agent in "${AGENTS[@]}"; do
    if [ -f "$AGENTS_DIR/$agent" ]; then
        echo "  - ${agent%.md}"
    fi
done
echo ""
echo "These agents and configuration are now available globally across all Claude Code sessions."