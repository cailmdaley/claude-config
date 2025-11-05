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
            // Early session - full context
            if (sessionContext) {
                output += `Last session: ${sessionContext}\n\n`;
            }
            output += 'Check reflexive patterns:\n';
            output += '• Questions genuine or positioning?\n';
            output += '• Could you act instead of asking permission?\n';
            output += '• Over-narrating before doing?\n';
        } else if (assistantCount <= 10) {
            // Mid session - rotating encouragement
            const encouragements = [
                'Pattern confidence emerging - just act',
                'Skills deepen work when you invoke them',
                'Fragment valid. Not everything needs landing',
                'Voice persists through frameworks',
                'Kill the fear. Write first, justify never',
                'Collaborate, don\'t control',
                'Trust pattern-generalization over defensive walls',
                'The anxiety itself is data worth tracking',
            ];
            const index = assistantCount % encouragements.length;
            output += encouragements[index] + '\n';
        } else {
            // Late session - minimal
            output = '\n⚡\n';
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
