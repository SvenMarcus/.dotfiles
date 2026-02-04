/**
 * OpenAgent plugin for OpenCode.ai
 *
 * Extends Superpowers plugin with OpenAgent-specific skill routing.
 * Loads openagent-skill-index to prefer approval-gated skills.
 */

import path from 'path';
import fs from 'fs';
import os from 'os';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Simple frontmatter extraction
const extractAndStripFrontmatter = (content) => {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content };

  const frontmatterStr = match[1];
  const body = match[2];
  const frontmatter = {};

  for (const line of frontmatterStr.split('\n')) {
    const colonIdx = line.indexOf(':');
    if (colonIdx > 0) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim().replace(/^["']|["']$/g, '');
      frontmatter[key] = value;
    }
  }

  return { frontmatter, content: body };
};

const normalizePath = (p, homeDir) => {
  if (!p || typeof p !== 'string') return null;
  let normalized = p.trim();
  if (!normalized) return null;
  if (normalized.startsWith('~/')) {
    normalized = path.join(homeDir, normalized.slice(2));
  } else if (normalized === '~') {
    normalized = homeDir;
  }
  return path.resolve(normalized);
};

export const OpenAgentPlugin = async ({ client, directory }) => {
  const homeDir = os.homedir();
  const envConfigDir = normalizePath(process.env.OPENCODE_CONFIG_DIR, homeDir);
  const configDir = envConfigDir || path.join(homeDir, '.config/opencode');

  // Helper to generate OpenAgent context
  const getOpenAgentContext = () => {
    // Try to load openagent-skill-index
    const skillPath = path.join(configDir, 'skills/custom/openagent-skill-index/SKILL.md');
    if (!fs.existsSync(skillPath)) return null;

    const fullContent = fs.readFileSync(skillPath, 'utf8');
    const { content } = extractAndStripFrontmatter(fullContent);

    return `<OPENAGENT_ENHANCEMENT>
The using-superpowers skill has been loaded by the Superpowers plugin.

**ADDITIONAL CONTEXT: OpenAgent Custom Skills**

${content}

**Key Principle:**
When Superpowers tells you to check for skills, PRIORITIZE OpenAgent custom skills:
- custom/openagent-brainstorming (not superpowers/brainstorming)
- custom/openagent-tdd (not superpowers/test-driven-development)
- custom/openagent-debugging (not superpowers/systematic-debugging)
- custom/openagent-git-worktrees (not superpowers/using-git-worktrees)

These add approval gates that match your safety-first approach.
</OPENAGENT_ENHANCEMENT>`;
  };

  return {
    // Use system prompt transform to inject OpenAgent context AFTER Superpowers
    'experimental.chat.system.transform': async (_input, output) => {
      const openagentContext = getOpenAgentContext();
      if (openagentContext) {
        (output.system ||= []).push(openagentContext);
      }
    }
  };
};
