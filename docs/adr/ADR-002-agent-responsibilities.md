# ADR-002: Agent Responsibility Boundaries and Coordination

Status: Proposed
Date: 2025-09-15
Deciders: @aaron, @claude
Tags: #architecture #agents #coordination

## Context

During implementation of workspace-curator, we discovered that multiple agents reference ADRs and design decisions, creating potential conflicts and duplicated effort. We need clear boundaries and coordination protocols.

## Decision

We will establish clear responsibility boundaries for each agent:

### Primary Responsibilities (Owner)

| Agent | Owns | Creates | Modifies |
|-------|------|---------|----------|
| **system-architect** | design.md, ADR content | ADRs in docs/adr/ | Design decisions |
| **workspace-curator** | .claude/index/, decision indexing | Index files | Never modifies ADRs |
| **requirements-analyst** | requirements.md | User stories | Requirements only |
| **task-planner** | tasks.md | Task breakdowns | Task status |
| **workflow-orchestrator** | Phase coordination | Status reports | Never creates artifacts |
| **code-reviewer** | Code quality reports | Review comments | Never modifies code |
| **github-project-manager** | GitHub integration | Issues/milestones | GitHub artifacts only |

### Coordination Rules

1. **ADR Creation Flow**:
   - **system-architect** CREATES ADRs (authoritative for content)
   - **workspace-curator** INDEXES ADRs (never modifies, only reads)
   - **workflow-orchestrator** COORDINATES timing (doesn't touch files)

2. **No Duplication**:
   - Only **system-architect** writes to design.md
   - Only **workspace-curator** writes to .claude/index/
   - Only **requirements-analyst** writes to requirements.md
   - Only **task-planner** writes to tasks.md

3. **Read vs Write Permissions**:
   - All agents can READ any file
   - Each agent only WRITES to their owned files
   - Coordination happens through agent invocation, not file modification

4. **Handoff Protocol**:
   - requirements-analyst → system-architect: "Requirements locked, ready for design"
   - system-architect → workspace-curator: "New ADR created, needs indexing"
   - system-architect → task-planner: "Design locked, ready for task breakdown"
   - task-planner → workflow-orchestrator: "Tasks defined, ready for execution"

## Consequences

### Positive
- Clear ownership prevents conflicts
- No duplicate work or file corruption
- Predictable agent behavior
- Clean handoffs between phases

### Negative
- More agent invocations needed
- Agents can't "fix" each other's work
- Rigid boundaries might slow some workflows

### Neutral
- Requires discipline in agent usage
- Users need to understand which agent to invoke

---
<!-- LLM-STRUCTURED-DATA -->
adr:
  id: ADR-002
  title: Agent Responsibility Boundaries and Coordination
  status: proposed
  date: 2025-09-15
  decision: clear-boundaries
  category: architecture
  impacts:
    - component: "all agents"
      change: "Enforced read/write boundaries"
    - component: "workflow"
      change: "Explicit handoff protocols"
  rationale: "Prevent conflicts and duplication between specialized agents"
<!-- END-LLM-STRUCTURED-DATA -->