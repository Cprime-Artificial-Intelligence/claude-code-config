# ADR-003: Simplify to ADR-Driven Workflow Pattern

Status: Reviewed - Ready for Implementation
Date: 2025-01-06
Deciders: @aaronsb, @claude
Tags: #architecture #methodology #workflow #simplification

## Context

The current disciplined methodology plugin suffers from complexity issues:

1. **Dual-mode tracking overhead**: Every agent maintains separate logic for "local mode" (requirements.md, design.md, tasks.md) vs "GitHub mode" (project boards, issues, milestones). This consumes ~30-40% of each agent's content.

2. **Context bloat**: Structured tracking files (requirements.md, design.md, tasks.md) consume context space and require constant synchronization, duplicating information already in git history.

3. **Mismatch with actual workflow**: Analysis of real usage shows the actual pattern is:
   - Debate/research problem → Draft ADR → PR for ADR review → Branch & implement → PR for code review → Merge
   - TodoWrite used ephemerally during sessions
   - Git/GitHub (branches, commits, PRs) provides work organization
   - Structured tracking files rarely consulted after creation

4. **Methodology locked in sub-agents**: Main Claude doesn't have visibility into ADR workflow patterns, requiring users to constantly guide the process. The methodology lives in sub-agent prompts but doesn't inform main Claude's behavior.

5. **Over-engineered GitHub integration**: Complex project board setup, elaborate milestones, and dedicated github-project-manager agent create overhead without value for typical workflows.

## Decision

We will refactor the methodology to be **ADR-driven and GitHub-native**, with the following changes:

### 1. Eliminate Dual-Mode Tracking
- **Remove**: `.claude-tracking` and `.github-tracking` marker files
- **Remove**: requirements.md, design.md, tasks.md structured files
- **Detection**: Simple check for GitHub upstream (`gh repo view` succeeds → use GitHub)
- **Fallback**: No GitHub? Use git commits + optional lightweight `.claude/notes.md`

### 2. ADR-Driven Workflow as Primary Pattern
The core workflow becomes:
```
Debate/Research → Draft ADR (docs/adr/) → PR for ADR →
Branch (reference ADR) → TodoWrite (session) → Implement →
PR for code → Address review → Merge
```

**Documentation Organization:**
The `docs/` directory should support flexible organization beyond just ADRs:
- `docs/adr/` - Architecture Decision Records (ADR-NNN-description.md format)
- `docs/development/` - Development guides, setup instructions
- `docs/research/` - Research findings, spike reports
- `docs/guides/` - User guides, tutorials
- `docs/testing/` - Test strategies, QA documentation
- `docs/features/` - Feature specifications, user stories
- Other subdirectories as needed for project context

Agents should understand this flexible structure and organize documentation appropriately.

### 3. Expose Methodology to Main Claude
- **Add**: `CLAUDE.md` at plugin root with core workflow patterns
- **Content**: ADR pattern, branch strategy, PR-centric review, minimal GitHub usage
- **Length**: ~100-150 lines of essential patterns
- **Purpose**: Main Claude follows methodology without sub-agent invocation

### 4. Simplify Agent Responsibilities

**Keep (simplified):**
- `requirements-analyst` (~40 lines): Capture needs as GitHub issues or ADR context
- `system-architect` (~60 lines): Focus on ADR workflow management
- `task-planner` (~50 lines): Think in branches and TodoWrite, not tracking files
- `code-reviewer` (~50 lines): Assume PR context, SOLID checks
- `workflow-orchestrator` (~70 lines): Coordinate ADR → branch → implement → PR pattern
- `workspace-curator` (~35 lines): Manage `.claude/` and `docs/` organization only

**Remove:**
- `github-project-manager`: Functionality distributed to other agents (each handles own gh CLI)

**Methodology docs:**
- Consolidate 4 files (project-setup.md, local-tracking.md, github-tracking.md, workflow-lifecycle.md) into workflow.md
- Keep quality-guidelines.md (SOLID principles, communication)
- Add github-guidelines.md (quick reference, not requirements)

### 5. Lightweight GitHub Usage
**Use:**
- Issues (optional, for requirements/discussions)
- PRs (required, for ADR and code review)
- Basic labels: bug, enhancement, documentation, decision, requirement
- Standard git workflow

**Avoid:**
- Complex project boards
- Elaborate milestone hierarchies
- Status syncing workflows
- Over-labeled issues

### 6. Agent Size & Complexity Reduction
Target reductions:
- Agent content: ~60-65% reduction (814 lines → ~305 lines)
- Methodology docs: ~60% reduction (500 lines → ~200 lines)
- Total context saved: ~800 lines

## Consequences

### Positive
- **Massive context savings**: ~60-65% reduction in methodology overhead
- **Aligned with actual usage**: Workflow matches how users actually work
- **Main Claude awareness**: Methodology visible in primary conversation, not just sub-agents
- **Simpler mental model**: ADR-driven pattern easy to understand and follow
- **Less coordination overhead**: No dual-mode logic, simpler agent interactions
- **Git-native**: Leverages existing git/GitHub tools users already understand
- **Faster onboarding**: Less complexity to learn and remember

### Negative
- **Breaking change**: Existing projects using local tracking files won't work without migration
- **Less structure for newcomers**: Some users might benefit from more prescribed tracking
- **GitHub dependency**: Optimal workflow requires GitHub (though fallback exists)
- **Requires user discipline**: Less automatic tracking means users must manage branches/PRs

### Neutral
- **ADR emphasis**: Strong opinion that decisions should be documented (some may prefer less ceremony)
- **PR-centric review**: Assumes PR-based workflow (not all teams use this)
- **TodoWrite ephemeral**: Session-only tracking might not suit all workflows

## Alternatives Considered

### Alternative 1: Keep Dual-Mode but Simplify
- Retain local/GitHub modes but reduce complexity
- **Rejected**: Still maintains fundamental complexity and context bloat

### Alternative 2: Force GitHub-Only
- Require GitHub, remove all fallbacks
- **Rejected**: Too restrictive, excludes users without GitHub

### Alternative 3: Keep All Tracking Files, Make Optional
- Make requirements.md, design.md, tasks.md optional
- **Rejected**: Doesn't solve context bloat problem, adds configuration complexity

### Alternative 4: Database-Backed Tracking
- Implement SQLite or similar for persistence
- **Rejected**: Over-engineered, harder to version control, less transparent

## Implementation Plan

### Phase 1: Core CLAUDE.md & Agent Simplification
1. Create `CLAUDE.md` with ADR-driven workflow (~100-150 lines)
2. Refactor 6 agents to simplified versions (~305 lines total)
3. Remove github-project-manager agent
4. Test main Claude awareness of methodology

### Phase 2: Methodology Documentation
1. Consolidate 4 methodology files → `workflow.md`
2. Create `github-guidelines.md` (reference, not requirements)
3. Update `quality-guidelines.md` if needed
4. Create ADR template file

### Phase 3: Testing & Documentation
1. Test with new projects (clean slate approach)
2. Update plugin README with new workflow
3. Version bump to 2.0.0 (breaking change - no backward compatibility)

### Phase 4: Polish
1. Gather user feedback
2. Refine agent prompts based on real usage
3. Update examples and documentation

## Decisions from PR Review

1. **CLAUDE.md scope**: Up to 150 lines is acceptable - minimum viable content. Beyond that becomes too detailed.
2. **ADR storage location**: Use `docs/adr/ADR-NNN-description-of-thing.md` format
3. **Migration support**: No migration scripts needed - clean break approach
4. **Backward compatibility**: No backward compatibility - version 2.0.0 breaking change
5. **User customization**: Users customize by editing their project's CLAUDE.md file directly
6. **Documentation flexibility**: Support multiple `docs/` subdirectories (development, research, guides, testing, features, etc.)

## References

- Current implementation: disciplined-methodology plugin v1.0.0
- User workflow analysis: This conversation (2025-01-06)
- ADR-001: Workspace Curator Agent
- ADR-002: Agent Responsibilities

---
<!-- LLM-STRUCTURED-DATA -->
adr:
  id: ADR-003
  title: Simplify to ADR-Driven Workflow Pattern
  status: proposed
  date: 2025-01-06
  decision: methodology-refactoring
  category: architecture
  impacts:
    - component: "all agents"
      change: "60-65% reduction in size and complexity"
    - component: "main Claude"
      change: "Gains methodology awareness via CLAUDE.md"
    - component: "tracking system"
      change: "Eliminates dual-mode, removes local tracking files"
    - component: "github integration"
      change: "Simplified to basic issues/PRs, removes project boards"
    - component: "user workflow"
      change: "Breaking change - requires migration from v1.x"
  rationale: "Align methodology with actual user workflow patterns, reduce context bloat by 60-65%, make main Claude methodology-aware"
  breaking_change: true
  migration_required: true
<!-- END-LLM-STRUCTURED-DATA -->
