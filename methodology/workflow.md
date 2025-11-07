# ADR-Driven Workflow

This methodology follows a simple, pragmatic workflow centered on Architecture Decision Records.

## Core Pattern

```
Debate/Research → Draft ADR → PR for ADR →
Branch (adr-NNN) → TodoWrite (session) → Implement →
PR for code → Address review → Merge
```

All significant architectural decisions should follow this pattern. Small changes (bug fixes, refactors within existing architecture) can skip the ADR step.

## GitHub Detection

**Simple check**: `gh repo view` (succeeds → use GitHub features)

No GitHub upstream? Use git branches, commits, and optional `.claude/notes.md` for lightweight tracking.

## Work Organization

### Branches
Every significant piece of work gets a branch:
- `adr-NNN-description` - Implementing an ADR
- `feature/name` - New feature work
- `fix/issue` - Bug fixes
- `refactor/area` - Code improvements
- `spike/investigation` - Exploration/research

### TodoWrite (Session-Scoped)
Track active work during sessions:
- Maintains current task list
- Survives compaction events
- Ephemeral - doesn't persist to files
- Used for session focus, not permanent tracking

### Documentation
Flexible `docs/` organization:
- `docs/adr/` - Architecture Decision Records (required)
- `docs/development/`, `docs/research/`, `docs/guides/`, etc. (as needed)

### Git Commits
Use conventional commit format:
- `feat(scope): description` - New features
- `fix(scope): description` - Bug fixes
- `docs(scope): description` - Documentation
- `refactor(scope): description` - Code improvements

No attribution footers - clean commits save tokens.

## GitHub Features (Lightweight)

### What to Use
- **Issues**: Requirements, bugs, discussions (optional)
- **PRs**: ADR review and code review (required)
- **Labels**: Basic set (bug, enhancement, documentation, decision, requirement)

### What to Avoid
- Complex project boards
- Elaborate milestone hierarchies
- Status syncing workflows
- Over-labeled issues

### Common Commands
```bash
# Check for GitHub
gh repo view

# Create requirement issue
gh issue create --label requirement \
  --title "User password reset" \
  --body "Problem: Users can't recover accounts..."

# Create ADR PR
gh pr create --title "ADR-NNN: Decision" --body "..."

# Review PR
gh pr review 123 --approve

# List open work
gh pr list --state open
gh issue list --label requirement,bug
```

## ADR Workflow (Detailed)

### 1. Debate Phase
Discuss architectural options with user:
- What problem are we solving?
- What are the options?
- What are the trade-offs?
- What constraints exist?

### 2. Draft ADR
Create `docs/adr/ADR-NNN-description-of-thing.md`:
- **Context**: Why this decision is needed
- **Decision**: What we're doing and how
- **Consequences**: Positive, negative, and neutral impacts
- **Alternatives**: Other options considered and why rejected

### 3. Create PR for ADR
```bash
git checkout -b adr-NNN-description
git add docs/adr/ADR-NNN-description-of-thing.md
git commit -m "docs: Add ADR-NNN for [decision]"
git push -u origin adr-NNN-description
gh pr create --title "ADR-NNN: Decision Title"
```

### 4. Review & Iterate
User reviews ADR in PR, provides feedback, you address comments.

### 5. Merge ADR
After approval, ADR status becomes "Accepted" and is ready to reference.

### 6. Implement
Create implementation branch (can reference ADR):
```bash
git checkout main
git pull
git checkout -b implement-adr-NNN
# or
git checkout -b feature/oauth-support
```

Use TodoWrite to track session work.

### 7. Code PR
```bash
git push -u origin implement-adr-NNN
gh pr create --title "Implement ADR-NNN: OAuth Support" \
  --body "Implements ADR-NNN OAuth integration strategy..."
```

### 8. Code Review
User reviews code, provides feedback, you address via commits or sub-agents.

### 9. Merge & Continue
After approval, merge and move to next work.

## When to Use Sub-Agents

Main Claude handles most work. Use sub-agents for:

- **requirements-analyst**: Capture complex requirements as GitHub issues
- **system-architect**: Draft ADRs, evaluate SOLID principles
- **task-planner**: Plan complex multi-branch implementations
- **code-reviewer**: Review large PRs, SOLID compliance checks
- **workflow-orchestrator**: Project status, phase coordination
- **workspace-curator**: Organize docs/, manage .claude/ directory

Sub-agents are for specialized, token-intensive work - not routine tasks.

## Pragmatic Workflow

**Use full ADR workflow for**:
- Architectural decisions (databases, frameworks, patterns)
- Technical approaches with significant trade-offs
- Security or performance decisions
- Process or methodology changes

**Skip ADR for**:
- Bug fixes
- Small refactorings within existing architecture
- Documentation updates
- Test additions
- Dependency updates

**Use judgment**: The workflow serves the work, not vice versa.

## Quality Standards

**Good workflow adherence**:
- Architectural decisions documented in ADRs
- Work has clear intent (ADR, requirement, bug fix)
- Significant code gets PR review
- Git history tells a coherent story

**Not required**:
- Perfect process compliance
- ADRs for every change
- Rigid phase gates
- Ceremony over substance

Focus on value: documentation that helps, reviews that improve code, process that enables work.
