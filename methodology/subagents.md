## Specialized Subagents

Use the built-in specialized subagents to implement the disciplined methodology. Each agent handles specific aspects of the development lifecycle while maintaining work traceability.

### Available Subagents

**🔍 requirements-analyst**
- **Purpose**: Translates user needs into "As a/I want/So that" user stories with testable acceptance criteria
- **When to use**: User describes new features, changes existing requirements, or needs requirement review
- **Quality focus**: Vague requirements lead to rework - ask clarifying questions rather than guessing intent
- **Output**: Updates to requirements.md (local) or GitHub project board items (GitHub mode)

**🏗️ system-architect**
- **Purpose**: Creates design.md with ADR format, evaluates SOLID principles, documents architectural decisions
- **When to use**: After requirements are stable, need architectural review, or design compliance validation
- **Quality focus**: Undocumented decisions get forgotten, SOLID violations create maintenance problems
- **Output**: Updates to design.md (local) or GitHub wiki/discussions with architecture decisions

**📋 task-planner**
- **Purpose**: Decomposes work into implementable tasks with requirement traceability
- **When to use**: After design is stable, need implementation planning, or task status updates
- **Quality focus**: Undefined tasks lead to incomplete work, missing dependencies cause delays
- **Output**: Updates to tasks.md (local) or GitHub project boards with milestones

**👀 code-reviewer**
- **Purpose**: Reviews code for SOLID compliance, identifies monolithic patterns, provides specific refactoring suggestions
- **When to use**: After code implementation, before merging, or when quality issues are suspected
- **Quality focus**: Each unaddressed violation makes the codebase harder to maintain
- **Output**: Code review feedback with specific improvement recommendations

**🐙 github-project-manager**
- **Purpose**: Handles GitHub CLI operations for project board and issue tracking
- **When to use**: Only when `.github-tracking` exists, need GitHub setup, or GitHub status reporting
- **Quality focus**: Poor GitHub setup causes confusion between requirements and bugs
- **Output**: GitHub project boards, issues, milestones, labels, and wiki management

**🎯 workflow-orchestrator**
- **Purpose**: Coordinates development lifecycle phases and ensures work has declared intent
- **When to use**: Need overall project coordination, phase status, or work tracking verification
- **Quality focus**: Without coordination, agents work in isolation and duplicate effort
- **Output**: Project status reports and lifecycle phase coordination

**🗂️ workspace-curator**
- **Purpose**: Maintains organized project workspace, documentation structure, and .claude/ directory
- **When to use**: Project initialization, documentation getting disorganized, scattered ADRs/decisions, workspace cleanup needed
- **Quality focus**: Unorganized documentation and scattered decisions create confusion and maintenance burden
- **Output**: Organized .claude/ directory structure, well-structured documentation hierarchy, ADR organization (using adr-xxx numbering)

### Agent Coordination Protocol

1. **Phase-Based Usage**: Each agent specializes in specific lifecycle phases
2. **Task-first rule**: All agents respect the "no code without active sub-task" rule
3. **Parallel Execution**: Multiple agents can work on different sub-tasks within the same active Task
4. **Traceability Maintenance**: Every agent action must link back to requirement-ids
5. **Cross-Agent Communication**: Agents coordinate through the shared methodology and file system
6. **Quality Standards**: Agents ask clarifying questions for vague inputs rather than making assumptions

### Usage Examples

```bash
# Use requirements-analyst for new feature requests
"I need users to reset passwords" → requirements-analyst creates user story

# Use system-architect after requirements stable
"Design the password reset flow" → system-architect creates ADR in design.md

# Use task-planner after design stable
"Plan the implementation" → task-planner creates tasks.md with sub-tasks

# Use code-reviewer after implementation
"Review this authentication code" → code-reviewer provides SOLID compliance feedback

# Use workflow-orchestrator for coordination
"What's our project status?" → workflow-orchestrator provides phase report

# Use workspace-curator for workspace management
"Set up the project workspace" → workspace-curator creates .claude/ structure
"Our design docs are scattered everywhere" → workspace-curator proposes organization
"Where should this ADR go?" → workspace-curator recommends adr-xxx structure
```