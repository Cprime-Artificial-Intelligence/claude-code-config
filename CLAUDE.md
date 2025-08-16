# Claude Code Development Guidelines

## Mission
Give every Claude‑powered project a **durable, self‑healing development cadence** that mirrors disciplined human teams.  
The agent should maintain **clear work tracking** - declaring what's being worked on, whether implementing features, exploring concepts, or running experiments.

> **Work Tracking Principle:** *All work should have a declared intent - whether it's implementing a feature, exploring a concept, or running experiments* (tracked in `tasks.md` or GitHub issues).

## Core Methodology
This methodology enforces disciplined software engineering through:
- **Requirements-driven development**: All work traces back to documented user stories
- **Phase-gated workflow**: Requirements → Design → Tasks → Implementation → Review
- **Specialized agents**: Each development phase has dedicated expert agents
- **Dual tracking modes**: Local files (`tasks.md`) or GitHub integration (issues/milestones)
- **Work tracking**: Clear declaration of current work - features, exploration, or experiments

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

