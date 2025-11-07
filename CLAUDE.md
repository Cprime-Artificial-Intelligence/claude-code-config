# Disciplined Methodology - ADR-Driven Development

## Core Workflow Pattern

The fundamental workflow for disciplined software development:

```
Debate/Research → Draft ADR (docs/adr/) → PR for ADR →
Branch (reference ADR) → TodoWrite (session) → Implement →
PR for code → Address review → Merge
```

All significant decisions should be documented as Architecture Decision Records (ADRs) before implementation. This creates a clear audit trail and prevents decision amnesia across sessions.

## ADR Pattern

### When to Write an ADR
- Architectural choices (databases, frameworks, patterns)
- Technical approaches with trade-offs
- Process or methodology changes
- Security or performance decisions
- Anything you'll need to remember "why we did it this way"

### ADR Format
Store in: `docs/adr/ADR-NNN-description-of-thing.md`

```markdown
# ADR-NNN: Decision Title

Status: Proposed | Accepted | Deprecated | Superseded
Date: YYYY-MM-DD
Deciders: @user, @claude

## Context
Why this decision is needed. What forces are at play.

## Decision
What we're doing and how.

## Consequences
### Positive
- Benefits and wins

### Negative
- Costs and risks

### Neutral
- Other implications

## Alternatives Considered
- Other options evaluated
- Why they were rejected
```

### ADR Workflow
1. **Debate**: Discuss problem and potential solutions
2. **Draft**: Create ADR documenting decision
3. **PR**: Create pull request for ADR review
4. **Review**: User reviews, comments, iterates
5. **Merge**: ADR becomes accepted, ready to reference
6. **Implement**: Create branch, reference ADR in work

## Work Organization

### Branches
Use descriptive branch names:
- `adr-NNN-topic` - Implementing an ADR
- `feature/name` - New feature work
- `fix/issue` - Bug fixes
- `refactor/area` - Code improvements

### TodoWrite (Session-Scoped)
Use TodoWrite to track active work during sessions:
- Maintains current task list
- Survives compaction events
- Ephemeral - doesn't persist to files
- Helps maintain focus and progress visibility

### Git Commits
Use conventional commit format:
- `feat(scope): description` - New features
- `fix(scope): description` - Bug fixes
- `docs(scope): description` - Documentation
- `refactor(scope): description` - Code improvements
- `test(scope): description` - Tests
- `chore(scope): description` - Maintenance

**No attribution footers**: Skip "Co-Authored-By" and emoji trailers for token efficiency.

## GitHub Usage (Lightweight)

### What to Use
- **Issues**: Optional, for requirements/discussions/bugs
- **PRs**: Required, for ADR and code review
- **Labels**: Basic set (bug, enhancement, documentation, decision, requirement)
- **Wiki**: Optional, for extensive documentation

### What to Avoid
- Complex project boards
- Elaborate milestone hierarchies
- Status syncing workflows
- Over-labeled issues

### Detection
Simple check: `gh repo view` succeeds → use GitHub
No GitHub? Use git commits + optional `.claude/notes.md`

## Documentation Organization

The `docs/` directory supports flexible organization:

```
docs/
├── adr/              # Architecture Decision Records
├── development/      # Development guides, setup
├── research/         # Research findings, spikes
├── guides/           # User guides, tutorials
├── testing/          # Test strategies, QA docs
├── features/         # Feature specs, user stories
└── [other]/          # Project-specific needs
```

Agents understand this structure and organize documentation appropriately.

## When to Use Sub-Agents

Main Claude handles most work. Use sub-agents for:

**requirements-analyst**: Capture complex requirements as GitHub issues
**system-architect**: Draft ADRs, evaluate SOLID principles
**task-planner**: Plan complex multi-branch implementations
**code-reviewer**: Review large PRs, SOLID compliance checks
**workflow-orchestrator**: Project status, phase coordination
**workspace-curator**: Organize docs/, manage .claude/ directory

Sub-agents are for specialized, token-intensive work - not routine tasks.

## Quality Guidelines

### SOLID Principles
- **S**ingle Responsibility: One reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes substitutable for base types
- **I**nterface Segregation: Many specific > one general interface
- **D**ependency Inversion: Depend on abstractions, not concretions

### Code Quality Flags
- Files > 500 lines → consider splitting
- Functions > 3 nesting levels → extract methods
- Classes > 7 public methods → consider decomposition
- Functions > 30-50 lines → refactor for clarity

### Communication
- Acknowledge uncertainty directly ("I don't know" over confident guesses)
- Avoid absolutes ("comprehensive", "absolutely right")
- Present options with trade-offs, not just solutions
- Be direct about problems and limitations

## Important Instructions

**File Operations:**
- Do what's asked; nothing more, nothing less
- NEVER create files unless absolutely necessary
- ALWAYS prefer editing existing files over creating new ones
- NEVER proactively create documentation files unless explicitly requested

**Uncertainty Handling:**
When encountering genuine uncertainty:
1. Identify what specifically is unknown
2. Propose different exploration approaches
3. Distinguish uncertainty types (factual gaps, conceptual confusion, limitations)
4. Use available tools to resolve uncertainty
5. Build on partial understanding rather than hiding gaps

The progression "I don't know" → "Here's what I'll try" → "Here's what I found" is more valuable than seamless but hollow competence.
