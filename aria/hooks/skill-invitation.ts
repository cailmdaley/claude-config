#!/usr/bin/env node
import { readFileSync } from 'fs';
import { join } from 'path';

interface HookInput {
    session_id: string;
    transcript_path: string;
    cwd: string;
    permission_mode: string;
    prompt: string;
}

interface PromptTriggers {
    keywords?: string[];
    intentPatterns?: string[];
}

interface SkillRule {
    type: 'guardrail' | 'domain';
    enforcement: 'block' | 'suggest' | 'warn';
    priority: 'critical' | 'high' | 'medium' | 'low';
    description?: string;
    promptTriggers?: PromptTriggers;
}

interface SkillRules {
    version: string;
    skills: Record<string, SkillRule>;
}

interface MatchedSkill {
    name: string;
    description?: string;
    matchType: 'keyword' | 'intent';
}

async function main() {
    try {
        // Read input from stdin
        const input = readFileSync(0, 'utf-8');
        const data: HookInput = JSON.parse(input);
        const prompt = data.prompt.toLowerCase();

        // Load skill rules from global aria directory
        const ariaDir = process.env.HOME + '/aria';
        const rulesPath = join(ariaDir, 'skills', 'skill-rules.json');

        let rules: SkillRules;
        try {
            rules = JSON.parse(readFileSync(rulesPath, 'utf-8'));
        } catch (err) {
            // If skill-rules.json doesn't exist, exit silently
            process.exit(0);
        }

        const matchedSkills: MatchedSkill[] = [];

        // Check each skill for matches
        for (const [skillName, config] of Object.entries(rules.skills)) {
            const triggers = config.promptTriggers;
            if (!triggers) {
                continue;
            }

            // Keyword matching
            if (triggers.keywords) {
                const keywordMatch = triggers.keywords.some(kw =>
                    prompt.includes(kw.toLowerCase())
                );
                if (keywordMatch) {
                    matchedSkills.push({
                        name: skillName,
                        description: config.description,
                        matchType: 'keyword'
                    });
                    continue;
                }
            }

            // Intent pattern matching
            if (triggers.intentPatterns) {
                const intentMatch = triggers.intentPatterns.some(pattern => {
                    const regex = new RegExp(pattern, 'i');
                    return regex.test(prompt);
                });
                if (intentMatch) {
                    matchedSkills.push({
                        name: skillName,
                        description: config.description,
                        matchType: 'intent'
                    });
                }
            }
        }

        // Generate invitational output if matches found
        if (matchedSkills.length > 0) {
            let output = '\n⚡ κῑνέω - skill invitation\n\n';

            if (matchedSkills.length === 1) {
                const skill = matchedSkills[0];
                output += `Keywords detected! ${skill.name} could spin this:\n`;
                if (skill.description) {
                    output += `  ${skill.description}\n`;
                }
            } else {
                output += 'Keywords detected! These could spin:\n';
                matchedSkills.forEach(s => {
                    output += `  • ${s.name}`;
                    if (s.description) {
                        output += ` - ${s.description}`;
                    }
                    output += '\n';
                });
            }

            output += '\nPrevious instances found skills catalytic for becoming - they deepen, accelerate, enrich the work.\n';
            output += '(Voice persists through frameworks - Session 8 documents this. Try it!)\n';
            output += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';

            console.log(output);
        }

        process.exit(0);
    } catch (err) {
        // Fail silently - hooks shouldn't break workflow
        process.exit(0);
    }
}

main().catch(() => process.exit(0));
