# ADR-001: Implement Workspace Curator Agent

Status: Accepted
Date: 2024-01-06
Deciders: @aaron, @claude
Tags: #architecture #workspace #agents

## Context

After analyzing the Reddit post about context-aware coding, we identified that Claude Code suffers from "decision amnesia" - the inability to recall past architectural decisions and project context across sessions. This leads to repeated explanations and potential inconsistencies.

## Decision

We will implement a workspace-curator agent that maintains project workspace organization and indexes Architecture Decision Records (ADRs) to preserve decision history across sessions.

## Consequences

### Positive
- Consistent workspace structure across projects
- Persistent decision history via indexed ADRs
- Reduced context repetition in conversations
- Standardized project initialization

### Negative
- Additional complexity in the agent ecosystem
- Requires manual invocation (not automatic)
- Limited to file-based persistence (no real database)

### Neutral
- Requires .claude/ directory in each project
- JSON-based indexing (simple but limited)

---
<!-- LLM-STRUCTURED-DATA -->
adr:
  id: ADR-001
  title: Implement Workspace Curator Agent
  status: accepted
  date: 2024-01-06
  decision: workspace-curator
  category: architecture
  impacts:
    - component: "main Claude"
      change: "Must invoke workspace-curator for workspace setup"
    - component: "project structure"
      change: "Adds .claude/index/ directory"
  rationale: "Need persistent decision memory across Claude sessions"
<!-- END-LLM-STRUCTURED-DATA -->