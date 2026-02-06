/**
 * OpenAgent plugin for OpenCode.ai
 *
 * Loads OpenAgent skill foundation (openagent-using-skills) and skill index.
 * Provides approval-gated workflow skills for safety-first development.
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

  // Helper to generate OpenAgent bootstrap context
  const getOpenAgentBootstrap = () => {
    // Try to load openagent-using-skills (foundation)
    const usingSkillsPath = path.join(configDir, 'skills/custom/openagent-using-skills/SKILL.md');
    if (!fs.existsSync(usingSkillsPath)) return null;

    const fullContent = fs.readFileSync(usingSkillsPath, 'utf8');
    const { content } = extractAndStripFrontmatter(fullContent);

    const toolMapping = `**Tool Mapping for OpenCode:**
When skills reference tools you don't have, substitute OpenCode equivalents:
- \`TodoWrite\` → \`todowrite\` (your native tool)
- \`Task\` tool with subagents → Use OpenCode's subagent system (\`task\` tool)
- \`Skill\` tool → OpenCode's native \`skill\` tool
- \`Read\`, \`Write\`, \`Edit\`, \`Bash\` → Your native tools

**Skills location:**
OpenAgent skills are in \`${configDir}/skills/custom/\`
Use OpenCode's native \`skill\` tool to list and load skills.`;

    return `<EXTREMELY_IMPORTANT>
You have OpenAgent skills.

**IMPORTANT: The openagent-using-skills foundation is included below. It is ALREADY LOADED - you are currently following it. Do NOT use the skill tool to load "openagent-using-skills" again - that would be redundant.**

${content}

${toolMapping}
</EXTREMELY_IMPORTANT>`;
  };

  // Helper to generate OpenAgent skill index context
  const getOpenAgentIndex = () => {
    // Try to load openagent-skill-index
    const skillIndexPath = path.join(configDir, 'skills/custom/openagent-skill-index/SKILL.md');
    if (!fs.existsSync(skillIndexPath)) return null;

    const fullContent = fs.readFileSync(skillIndexPath, 'utf8');
    const { content } = extractAndStripFrontmatter(fullContent);

    return `<OPENAGENT_ENHANCEMENT>
The openagent-using-skills skill has been loaded by the OpenAgent plugin.

**ADDITIONAL CONTEXT: OpenAgent Custom Skills**

${content}

**Key Principle:**
When using skills, use OpenAgent custom skills with approval gates:
- custom/openagent-brainstorming
- custom/openagent-test-driven-development
- custom/openagent-systematic-debugging
- custom/openagent-using-git-worktrees
- custom/openagent-writing-plans
- custom/openagent-executing-plans
- custom/openagent-subagent-driven-development
- custom/openagent-finishing-a-development-branch
- custom/openagent-requesting-code-review
- custom/openagent-receiving-code-review
- custom/openagent-verification-before-completion
- custom/openagent-dispatching-parallel-agents
- custom/openagent-writing-skills
- custom/openagent-using-skills

These integrate approval gates throughout proven development workflows.
</OPENAGENT_ENHANCEMENT>`;
  };

  return {
    // Use system prompt transform to inject OpenAgent context
    'experimental.chat.system.transform': async (_input, output) => {
      const bootstrap = getOpenAgentBootstrap();
      if (bootstrap) {
        (output.system ||= []).push(bootstrap);
      }

      const index = getOpenAgentIndex();
      if (index) {
        (output.system ||= []).push(index);
      }
    }
  };
};
