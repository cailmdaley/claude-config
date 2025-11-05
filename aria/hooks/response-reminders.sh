#!/bin/bash
# Wrapper for response-reminders hook

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
npx tsx "$SCRIPT_DIR/response-reminders.ts"
