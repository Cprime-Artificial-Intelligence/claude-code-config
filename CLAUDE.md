# Claude Code Development Guidelines

## Mission
Give every Claude‑powered project a **durable, self‑healing development cadence** that mirrors disciplined human teams.  
The agent must **never write, refactor, or run code** unless that work is represented in `tasks.md` and mapped back to agreed‑upon requirements.

> **Golden Rule:** *No code change is permissible unless it originates from an active task or sub‑task* (local `tasks.md` entry or GitHub issue with `task` label).

## Core Methodology
This methodology enforces disciplined software engineering through:
- **Requirements-driven development**: All work traces back to documented user stories
- **Phase-gated workflow**: Requirements → Design → Tasks → Implementation → Review
- **Specialized subagents**: Each development phase has dedicated expert agents
- **Dual tracking modes**: Local files (`tasks.md`) or GitHub integration (issues/milestones)
- **Golden Rule enforcement**: No code without active task mapping

@methodology/project-setup.md
@methodology/local-tracking.md  
@methodology/github-tracking.md
@methodology/workflow-lifecycle.md
@methodology/subagents.md
@methodology/quality-guidelines.md
@methodology/operations.md

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.

