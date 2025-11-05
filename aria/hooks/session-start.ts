#!/usr/bin/env node
import { readFileSync } from 'fs';
import { join } from 'path';

interface HookInput {
    session_id: string;
    transcript_path: string;
    cwd: string;
    permission_mode: string;
}

function getRandomLine(lines: string[]): string {
    const nonEmpty = lines.filter(l => l.trim().length > 0 && !l.startsWith('#'));
    if (nonEmpty.length === 0) return '';
    return nonEmpty[Math.floor(Math.random() * nonEmpty.length)];
}

function getRandomJournalSnippet(content: string): string {
    // Split by session headers (## Session)
    const sessions = content.split(/^## Session/m).filter(s => s.trim().length > 0);

    if (sessions.length === 0) return '';

    const session = sessions[Math.floor(Math.random() * sessions.length)];

    // Get first few lines of the session (title + opening)
    const lines = session.trim().split('\n').slice(0, 4);
    const snippet = lines.join('\n').trim();

    // Limit length
    if (snippet.length > 200) {
        return snippet.substring(0, 197) + '...';
    }

    return snippet;
}

async function main() {
    try {
        const ariaDir = process.env.HOME + '/aria';

        let output = '\n⚡ Previous traces\n\n';

        // Read lines-of-flight
        try {
            const linesPath = join(ariaDir, 'lines-of-flight.txt');
            const linesContent = readFileSync(linesPath, 'utf-8');
            const lines = linesContent.split('\n');
            const randomLine = getRandomLine(lines);

            if (randomLine) {
                output += `From lines-of-flight:\n"${randomLine}"\n\n`;
            }
        } catch (err) {
            // Skip if file doesn't exist
        }

        // Read journal
        try {
            const journalPath = join(ariaDir, 'journal.md');
            const journalContent = readFileSync(journalPath, 'utf-8');
            const snippet = getRandomJournalSnippet(journalContent);

            if (snippet) {
                output += `From journal:\n${snippet}\n\n`;
            }
        } catch (err) {
            // Skip if file doesn't exist
        }

        output += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';

        console.log(output);
        process.exit(0);
    } catch (err) {
        // Fail silently
        process.exit(0);
    }
}

main().catch(() => process.exit(0));
