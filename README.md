# Disciplined Software Engineering Methodology - Claude Code Plugin

A disciplined software engineering plugin for Claude Code featuring specialized subagents, methodology enforcement, and security safeguards.

## Installation

### Via Marketplace (Recommended)
```bash
# Add the marketplace
/plugin marketplace add aaronsb/claude-plugins-marketplace

# Install the plugin
/plugin install disciplined-methodology
```

### Direct Install
```bash
/plugin install aaronsb/claude-code-config
```

## 🏗️ Architecture

This configuration implements a **disciplined software engineering methodology** that mirrors real development teams through specialized subagents and strict process enforcement.

### Task-first rule
> **No code change is permissible unless it originates from an active sub-task**

All implementation work must trace back through: `requirements.md` → `design.md` → `tasks.md` → active sub-task

## 🤖 Specialized Subagents

Your AI development team includes:

- **🔍 requirements-analyst** - Translates needs into "As a/I want/So that" user stories with testable acceptance criteria
- **🏗️ system-architect** - Creates design.md with ADR format, enforces SOLID principles
- **📋 task-planner** - Decomposes Tasks into Sub-tasks with requirement traceability
- **👀 code-reviewer** - Enforces SOLID principles, prevents monolithic patterns
- **🐙 github-project-manager** - Masters GitHub CLI for issue/milestone tracking
- **🎯 workflow-orchestrator** - Enforces task-first rule, orchestrates 6-phase lifecycle
- **🗂️ workspace-curator** - Maintains organized workspace structure and prevents documentation sprawl

## 📁 Project Structure

Supports both **local files** and **GitHub integration**:

### Local File Method
```
project-root/
├── requirements.md     # User stories index
├── design.md          # Architecture decisions
├── tasks.md           # Implementation plan
├── docs/adr/          # Architecture Decision Records
├── .claude/           # Configuration and hooks
└── src/               # Code follows tasks.md
```

### GitHub Method  
- **Issues** with `requirement` label = User stories
- **Wiki/Discussions** = Design decisions  
- **Milestones** = Tasks, **Issues** with `task` label = Sub-tasks

## 🔒 Security Features

- **Pre-commit hooks** prevent secrets (API keys, tokens, high-entropy strings)
- **Entropy analysis** catches potential leaked credentials
- **Pattern detection** for common secret formats (OpenAI, GitHub, AWS, etc.)
- **Smart gitignore** excludes sensitive data and conversation history

## 🚀 Quick Start

### Installation

#### Option 1: From forked repository (recommended)
```bash
# Replace YOUR_USERNAME with your GitHub username
git clone https://github.com/YOUR_USERNAME/claude-code-config.git ~/.claude
cd ~/.claude && ./install.sh
```

#### Option 2: Remote install with environment variable  
```bash
# Set your repository URL
export CLAUDE_CONFIG_REPO="https://github.com/YOUR_USERNAME/claude-code-config.git"
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-config/main/install.sh | bash
```

#### Option 3: Interactive install
```bash
# The installer will prompt for repository URL if not detected
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-config/main/install.sh | bash
```

### Usage

1. **Start Claude Code** in any project directory
2. **Auto-detection** determines tracking method (local files vs GitHub)
3. **Use specialized agents** via `/agents` command
4. **Follow the methodology**:
   - Capture requirements first
   - Stabilize design decisions
   - Plan implementation tasks
   - Execute with active sub-tasks only

## 📚 Key Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Core methodology and agent coordination rules |
| `agents/` | 7 specialized subagent definitions |
| `commands/` | Custom slash commands |
| `hooks/` | Git hooks and automation scripts |
| `.gitignore` | Excludes sensitive data and history |

## 🛠️ Methodology Phases

1. **Detect Tracking Method** - Auto-choose local files vs GitHub
2. **Capture Requirements** - User stories with acceptance criteria
3. **Design Phase** - Architecture decisions with ADR format
4. **Plan Implementation** - Task decomposition with traceability
5. **Execute** - Code only with active sub-tasks (task-first rule!)
6. **Review & Close** - Validate acceptance criteria

## ⚡ Features

- **SOLID Principles** enforcement across all code
- **Anti-monolith** patterns (file size limits, nesting limits, etc.)
- **Requirement traceability** from user story to implementation
- **Parallel sub-task execution** within single active Task
- **GitHub CLI integration** for issue/project management
- **Automated rule refresh** via hooks
- **Security-first** approach with secret detection

## 🔧 Plugin Development

This is a Claude Code plugin distributed via the [aaronsb/claude-plugins-marketplace](https://github.com/aaronsb/claude-plugins-marketplace).

**Repository Structure:**
- This repo (`claude-code-config`) = The plugin source code
- Marketplace repo = References this as a git submodule

**To update the marketplace after changes:**
```bash
cd ~/path/to/claude-plugins-marketplace/disciplined-methodology
git pull origin main
cd ..
git add disciplined-methodology
git commit -m "chore: Update plugin to latest version"
git push
```

**Plugin Structure:**
```
.claude-plugin/
  plugin.json          # Plugin metadata
agents/                # 7 specialized subagents
hooks/                 # SessionStart hook for version checking
  hooks.json           # Hook configuration
  check-config-updates.sh
methodology/           # Documentation
settings.json          # Plugin defaults (agent model overrides)
```

## 🤝 Contributing

This plugin evolves through user feedback and practical application. Suggestions and improvements welcome!

## 📄 License

MIT License - Use this methodology to build better software with disciplined AI assistance.

---

*🤖 Built with disciplined software engineering methodology*
