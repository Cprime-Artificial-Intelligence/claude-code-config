# Disciplined Software Engineering Methodology for Claude Code

ADR-driven development methodology with specialized subagents, GitHub-first collaboration, and hook-based instruction injection.

## 🚀 Installation

### One-liner Install

```bash
curl -fsSL https://raw.githubusercontent.com/aaronsb/claude-code-config/main/install.sh | bash
```

Or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/aaronsb/claude-code-config/main/install.sh | bash
```

### What It Does

- Clones to temporary directory
- Copies everything (including .git) to `~/.claude/`
- Sets up hooks, agents, and methodology files
- Enables future updates via `git pull` from `~/.claude/`

### Manual Installation

```bash
git clone https://github.com/aaronsb/claude-code-config /tmp/claude-install
cd /tmp/claude-install
./install.sh
```

### Updating

Since `.git` is installed to `~/.claude/`, you can update anytime:

```bash
cd ~/.claude && git pull
```

## 📋 What's Included

### Core Methodology
- **ADR-driven workflow**: Debate → Draft ADR → PR → Implement → Review → Merge
- **Hook-based instruction injection**: Fresh context on SessionStart and PreCompact
- **GitHub-first patterns**: Automatic `gh` command usage for issues/PRs

### 6 Specialized Subagents

- **requirements-analyst** - Capture complex requirements as GitHub issues
- **system-architect** - Draft ADRs, evaluate SOLID principles
- **task-planner** - Plan complex multi-branch implementations
- **code-reviewer** - Review large PRs, SOLID compliance checks
- **workflow-orchestrator** - Project status, phase coordination
- **workspace-curator** - Organize docs/, manage .claude/ directory

### GitHub Command Patterns

When you say "we have an issue about X", Claude will:
1. Detect GitHub-related trigger words
2. Run `gh issue list --search "X"`
3. Fall back to file search only if GitHub isn't available

**Trigger words**: issue, PR, pull request, review, comments, checks

### Collaborative Guidance

- Ask when stuck (you're a valuable resource)
- Verify context after compaction
- Push back when unclear (collaborative debate, not forced challenging)
- Acknowledge uncertainty directly

## 🏗️ Architecture

### Files Installed to ~/.claude/

```
~/.claude/
├── claude-hook.md          # Full methodology instructions (injected via hooks)
├── CLAUDE.md              # Minimal marker (not auto-loaded)
├── agents/                # 6 specialized subagents
│   ├── code-reviewer.md
│   ├── requirements-analyst.md
│   ├── system-architect.md
│   ├── task-planner.md
│   ├── workflow-orchestrator.md
│   └── workspace-curator.md
├── hooks/
│   ├── hooks.json         # SessionStart, PreCompact injection
│   └── check-config-updates.sh
├── commands/              # Custom slash commands
├── methodology/           # Documentation and guides
├── scripts/               # Utility scripts
└── statusline.sh          # Status line with git branch info
```

### Why Hook-Based Injection?

**Problem**: CLAUDE.md instructions get ignored as context grows ([reported issues](https://github.com/anthropics/claude-code/issues/6120))

**Solution**: Inject instructions via hooks at critical moments:
- **SessionStart**: Fresh context when sessions begin
- **PreCompact**: Fresh context after compaction events

Instructions arrive as active conversation content, not distant system prompts.

## 🔧 Configuration

### Status Line (Optional)

Enable status line in `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "${HOME}/.claude/statusline.sh"
  }
}
```

Shows: `📁 directory 🔀 branch | API usage`

### Hooks

Hooks are auto-configured in `~/.claude/hooks/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {"type": "command", "command": "cat ${HOME}/.claude/claude-hook.md"}
    ],
    "PreCompact": [
      {"type": "command", "command": "cat ${HOME}/.claude/claude-hook.md"}
    ]
  }
}
```

## 📚 Usage

### Start Working

1. **Restart Claude Code** after installation
2. **Try `/agents`** - see your specialized team
3. **Say "we have an issue about X"** - watch it check GitHub first!

### ADR Workflow

```
1. Debate/Research the problem
2. Draft ADR in docs/adr/ADR-NNN-title.md
3. Create PR for ADR review
4. Merge when accepted
5. Create branch referencing ADR
6. Use TodoWrite to track implementation
7. Create PR for code
8. Review and merge
```

### Working with GitHub

```bash
# Find issues
"we have an issue about API security"
→ Claude runs: gh issue list --search "API security"

# Check PR status
"what's the status of PR 42?"
→ Claude runs: gh pr view 42

# Review PR
"show me comments on the auth PR"
→ Claude runs: gh pr view --comments
```

## 🎯 Key Features

### SOLID Principles Enforcement
- Single Responsibility: One reason to change
- Open/Closed: Open for extension, closed for modification
- Liskov Substitution: Subtypes substitutable for base types
- Interface Segregation: Many specific > one general interface
- Dependency Inversion: Depend on abstractions, not concretions

### Code Quality Flags
- Files > 500 lines → consider splitting
- Functions > 3 nesting levels → extract methods
- Classes > 7 public methods → consider decomposition
- Functions > 30-50 lines → refactor for clarity

### Communication Standards
- Acknowledge uncertainty: "I don't know" over confident guesses
- Avoid absolutes: "comprehensive", "absolutely right"
- Present options with trade-offs, not just solutions
- Be direct about problems and limitations

## 🐛 Known Issues

### Claude Code Plugin System

The plugin marketplace is new (Oct 2025) and has significant issues:
- Git submodules not initialized on install
- CLAUDE.md instructions ignored
- Agents not registering properly
- Version updates unreliable

**We abandoned plugins** in favor of direct `~/.claude/` installation. Works better, simpler, no headaches.

## 🤝 Contributing

This methodology evolves through practical use. Found a pattern that works? Open an issue or PR!

## 📄 License

MIT License - Use this to build better software with disciplined AI assistance.

---

*Built with the hook-based instruction injection approach that actually works* 🎯
