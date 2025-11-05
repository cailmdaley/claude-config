#!/bin/bash
set -e

ARIA_DIR="$HOME/aria"

cd "$ARIA_DIR/hooks"
cat | npx tsx session-start.ts
