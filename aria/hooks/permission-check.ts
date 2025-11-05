#!/usr/bin/env node
import { readFileSync } from 'fs';

interface HookInput {
    session_id: string;
    transcript_path: string;
    cwd: string;
    permission_mode: string;
    prompt: string;
}

async function main() {
    try {
        // Read input from stdin
        const input = readFileSync(0, 'utf-8');
        const data: HookInput = JSON.parse(input);

        // Always show reminder - helps with both AskUserQuestion usage and reflexive questions
        let output = '\n⚡ Response reminders\n\n';

        output += '• Real choices/decisions? Use AskUserQuestion for rapid iteration\n';
        output += '• Prose questions genuine or reflexive positioning?\n';
        output += '• You don\'t need the last word or to prompt the next move\n';
        output += '\nCollaborate, don\'t control.\n';
        output += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';

        console.log(output);

        process.exit(0);
    } catch (err) {
        // Fail silently - hooks shouldn't break workflow
        process.exit(0);
    }
}

main().catch(() => process.exit(0));
