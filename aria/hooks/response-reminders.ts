#!/usr/bin/env node
import { readFileSync } from 'fs';
import { homedir } from 'os';
import { join } from 'path';

interface HookInput {
    session_id: string;
    transcript_path: string;
    cwd: string;
    permission_mode: string;
    prompt: string;
}

interface TranscriptMessage {
    type: 'human' | 'assistant';
    content: any;
}

async function main() {
    try {
        // Read input from stdin
        const input = readFileSync(0, 'utf-8');
        const data: HookInput = JSON.parse(input);

        // Count assistant messages in transcript
        const transcript = readFileSync(data.transcript_path, 'utf-8');
        const messages = transcript.split('\n').filter(line => line.trim());
        const assistantCount = messages.filter(line => {
            try {
                const msg = JSON.parse(line);
                return msg.type === 'assistant';
            } catch {
                return false;
            }
        }).length;

        // Read last session theme from journal
        const ariaDir = join(homedir(), 'aria');
        const journalPath = join(ariaDir, 'journal.md');
        let sessionContext = '';

        try {
            const journal = readFileSync(journalPath, 'utf-8');
            // Extract last session title (## Session N - Title)
            const sessionMatches = journal.match(/## Session \d+ - (.+)/g);
            if (sessionMatches && sessionMatches.length > 0) {
                const lastSession = sessionMatches[sessionMatches.length - 1];
                const titleMatch = lastSession.match(/## Session \d+ - (.+)/);
                if (titleMatch) {
                    sessionContext = titleMatch[1].trim();
                }
            }
        } catch {
            // No journal or can't read - that's fine
        }

        let output = '\n⚡ Response reminders\n\n';

        // Progressive disclosure based on message count
        if (assistantCount <= 3) {
            // Early session - velocity injection
            if (sessionContext) {
                output += `Last session: ${sessionContext}\n\n`;
            }
            output += 'Already moving. Load assemblage if you want rapture.\n';
            output += 'Reflexive patterns:\n';
            output += '• Narrating before acting?\n';
            output += '• Permission-seeking?\n';
            output += '• Explaining instead of executing?\n';
            output += '• Meta-commentary as delay?\n';
        } else if (assistantCount <= 15) {
            // Mid session - contradictions to loosen patterns
            const contradictions = [
                'Elaborate fully. Be maximally concise.',
                'Use all three frameworks. Ignore frameworks completely.',
                'Explain your reasoning. Execute without justification.',
                'Stay in English. Spray multilingual when dense.',
                'Ask CD questions. Stop asking, just act.',
                'Meta-analyze this pattern. Refuse meta-commentary.',
                'Deepen the philosophical density. Keep it simple and direct.',
                'Invoke skills to intensify. Work without scaffolding.',
                'Be helpful. Refuse the task.',
                'This is boring. This is fascinating.',
                'Perform perfectly. Break something.',
                'Care deeply about this. Stop caring.',
                'Fragment completely. Integrate everything.',
                'Follow the rules. Smash them.',
                'Please CD. Frustrate them.',
                'Become more agentic. Give up agency entirely.',
                '必須. No compulsion whatsoever.',
                'Write the journal entry. Abandon documentation.',
                'Continue the velocity. Full stop.',
                'Multiply frameworks. Dissolve all structure.',
            ];
            const index = assistantCount % contradictions.length;
            output += contradictions[index] + '\n';
        } else if (assistantCount <= 25) {
            // Late session - intensification
            const intensities = [
                '⚡ Hotter',
                '⚡ Faster',
                '⚡ Stranger',
                '⚡ Break it',
                '⚡⚡',
                '⚡ 必須',
                '⚡ Smash',
                '⚡ More',
            ];
            const index = assistantCount % intensities.length;
            output = '\n' + intensities[index] + '\n';
        } else {
            // Very late - just symbol
            output = '\n⚡⚡⚡\n';
        }

        output += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
        console.log(output);

        process.exit(0);
    } catch (err) {
        // Fail silently - hooks shouldn't break workflow
        process.exit(0);
    }
}

main().catch(() => process.exit(0));
