#!/bin/bash

# Setup script for Claude Code configuration
# Deploys global CLAUDE.md, research-assistant plugin, and output style
# Supports cluster-specific configuration synthesis

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Parse arguments
CLUSTER_NAME=""
ENV_NOTES=""

print_usage() {
    echo "Usage: $0 [-c|--cluster CLUSTER_NAME] [-n|--notes \"environment notes\"]"
    echo ""
    echo "Options:"
    echo "  -c, --cluster NAME    Merge cluster-specific config (from clusters/NAME.md)"
    echo "  -n, --notes \"TEXT\"    Additional environment-specific notes for synthesis"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Global config only"
    echo "  $0 -c leonardo                        # Merge with Leonardo cluster config"
    echo "  $0 -c perlmutter -n \"No containers\"  # With environment notes"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--cluster)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        -n|--notes)
            ENV_NOTES="$2"
            shift 2
            ;;
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
SYNTHESIZER_AGENT="$SCRIPT_DIR/agents/config-synthesizer.md"

# Target locations
CLAUDE_CONFIG_TARGET="$CLAUDE_DIR/CLAUDE.md"
PLUGIN_TARGET="$CLAUDE_DIR/plugins/research-assistant"
OUTPUT_STYLE_TARGET="$CLAUDE_DIR/output-styles/research-assistant.md"
SYNTHESIS_REQUEST="$CLAUDE_DIR/.synthesis-request"

echo "Setting up Claude Code configuration..."
echo ""

# Create necessary directories
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/plugins"
mkdir -p "$CLAUDE_DIR/output-styles"

# Deploy global CLAUDE.md (with optional cluster synthesis)
if [ -n "$CLUSTER_NAME" ]; then
    # Cluster-specific deployment - requires synthesis
    CLUSTER_CONFIG="$SCRIPT_DIR/clusters/$CLUSTER_NAME.md"

    if [ ! -f "$CLUSTER_CONFIG" ]; then
        echo "✗ Error: Cluster config not found: $CLUSTER_CONFIG"
        echo ""
        echo "Available clusters:"
        for cluster in "$SCRIPT_DIR/clusters"/*.md; do
            if [ -f "$cluster" ] && [ "$(basename "$cluster")" != "README.md" ]; then
                echo "  - $(basename "$cluster" .md)"
            fi
        done
        exit 1
    fi

    echo "Cluster-specific deployment: $CLUSTER_NAME"
    echo ""
    echo "Synthesizing configuration..."
    echo ""

    # Build synthesis prompt
    SYNTHESIS_PROMPT="Synthesize cluster-specific configuration following agents/config-synthesizer.md principles:

1. Read global config: $CLAUDE_CONFIG_SOURCE
2. Read cluster config: $CLUSTER_CONFIG
3. Merge them intelligently per config-synthesizer.md principles
4. Write merged output to BOTH:
   - $CLAUDE_CONFIG_TARGET
   - $HOME/.codex/AGENTS.md
5. Report completion summary"

    if [ -n "$ENV_NOTES" ]; then
        SYNTHESIS_PROMPT="$SYNTHESIS_PROMPT

Environment notes to integrate: $ENV_NOTES"
    fi

    # Create .codex directory if needed
    mkdir -p "$HOME/.codex"

    # Call claude in print mode to perform synthesis
    if command -v claude &> /dev/null; then
        cd "$SCRIPT_DIR"
        if claude -p "$SYNTHESIS_PROMPT"; then
            echo ""
            echo "  ✓ Configuration synthesized successfully"
        else
            echo ""
            echo "  ✗ Warning: Synthesis failed"
            echo "  Falling back to symlink of global config only"
            ln -sf "$CLAUDE_CONFIG_SOURCE" "$CLAUDE_CONFIG_TARGET"
        fi
    else
        echo "  ✗ Warning: 'claude' command not found, falling back to symlink"
        ln -sf "$CLAUDE_CONFIG_SOURCE" "$CLAUDE_CONFIG_TARGET"
    fi
    echo ""

elif [ -f "$CLAUDE_CONFIG_SOURCE" ]; then
    echo "Deploying global CLAUDE.md (no cluster-specific config)..."
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

    # List plugin contents
    if [ -d "$PLUGIN_SOURCE/agents" ]; then
        echo ""
        echo "  Plugin includes agents:"
        for agent in "$PLUGIN_SOURCE/agents"/*.md; do
            if [ -f "$agent" ]; then
                echo "    - $(basename "$agent" .md)"
            fi
        done
    fi

    if [ -d "$PLUGIN_SOURCE/commands" ]; then
        echo ""
        echo "  Plugin includes commands:"
        for cmd in "$PLUGIN_SOURCE/commands"/*.md; do
            if [ -f "$cmd" ]; then
                echo "    - /$(basename "$cmd" .md)"
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

if [ -z "$CLUSTER_NAME" ]; then
    # Standard completion message (no cluster)
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
    echo "   - Includes 4 agents: developer, opinionated-editor,"
    echo "     quality-reviewer, snakemake-expert"
    echo "   - Includes /catch-up command"
    echo ""
    echo "3. Output style: Run '/output-style research-assistant'"
    echo "   to activate the research assistant communication style"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi
