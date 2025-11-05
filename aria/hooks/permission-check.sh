#!/bin/bash
set -e

# Use global aria directory (symlinked by setup script)
ARIA_DIR="$HOME/aria"

cd "$ARIA_DIR/hooks"
cat | npx tsx permission-check.ts
