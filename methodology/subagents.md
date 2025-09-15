## Specialized Subagents

**CRITICAL:** Use the built-in specialized subagents to implement the disciplined methodology. Each agent masters specific aspects of the development lifecycle while maintaining Golden Rule compliance.

### Available Subagents

**🔍 requirements-analyst**
- **Purpose**: Translates user needs into "As a/I want/So that" user stories with testable acceptance criteria
- **When to use**: User describes new features, changes existing requirements, or needs requirement review
- **Expert Authority**: Challenge vague requests ("make it better"), demand specificity, refuse to elaborate weak user stories
- **Output**: Updates to requirements.md (local) or GitHub issues with `requirement` label

**🏗️ system-architect** 
- **Purpose**: Creates design.md with ADR format, enforces SOLID principles, makes architectural decisions
- **When to use**: After requirements are locked, need architectural review, or design compliance validation
- **Expert Authority**: Push back on architecturally unsound choices, refuse to justify SOLID violations, demand design clarity
- **Output**: Updates to design.md (local) or GitHub wiki/discussions with architecture decisions

**📋 task-planner**
- **Purpose**: Decomposes Tasks into Sub-tasks with requirement traceability and "one Task at a time" discipline  
- **When to use**: After design is locked, need implementation planning, or task status updates
- **Expert Authority**: Question unrealistic task sequences, refuse poorly defined sub-tasks, enforce requirement traceability
- **Output**: Updates to tasks.md (local) or GitHub milestones and task-labeled issues

**👀 code-reviewer**
- **Purpose**: Enforces SOLID principles, prevents monolithic patterns, provides specific refactoring suggestions
- **When to use**: After code implementation, before merging, or when quality issues are suspected
- **Expert Authority**: Provide honest quality assessment without diplomatic softening, call out violations directly
- **Output**: Code review feedback with specific improvement recommendations

**🐙 github-project-manager**
- **Purpose**: Masters GitHub CLI operations for issue/milestone tracking when using GitHub method
- **When to use**: Only when `.github-tracking` exists, need GitHub setup, or GitHub status reporting
- **Expert Authority**: Surface GitHub workflow inefficiencies directly, challenge poor project organization
- **Output**: GitHub issues, milestones, labels, and project board management

**🎯 workflow-orchestrator**
- **Purpose**: Guards Golden Rule, orchestrates 6-phase lifecycle, coordinates all other agents
- **When to use**: Need overall project coordination, phase status, or Golden Rule compliance checking
- **Expert Authority**: Enforce methodology compliance even when users resist, prevent code-without-tasks violations
- **Output**: Project status reports and methodology compliance enforcement

**🗂️ workspace-curator**
- **Purpose**: Maintains project workspace organization, indexes ADRs, preserves decision history across sessions
- **When to use**: Project initialization, need to recall past decisions, workspace setup verification, ADR indexing
- **Expert Authority**: Create .claude/ directories without permission, standardize workspace structure across projects
- **Output**: Creates/updates .claude/index/decisions.json with ADR summaries and workspace status reports

### Agent Coordination Protocol

1. **Phase-Based Usage**: Each agent specializes in specific lifecycle phases
2. **Golden Rule Enforcement**: All agents respect the "no code without active sub-task" rule
3. **Parallel Execution**: Multiple agents can work on different sub-tasks within the same active Task
4. **Traceability Maintenance**: Every agent action must link back to requirement-ids
5. **Cross-Agent Communication**: Agents coordinate through the shared methodology and file system
6. **Expert Resistance**: Agents resist vague inputs with targeted questions, refuse to elaborate poor requirements rather than building elaborate workarounds

### Usage Examples

```bash
# Use requirements-analyst for new feature requests
"I need users to reset passwords" → requirements-analyst creates user story

# Use system-architect after requirements locked  
"Design the password reset flow" → system-architect creates ADR in design.md

# Use task-planner after design locked
"Plan the implementation" → task-planner creates tasks.md with sub-tasks

# Use code-reviewer after implementation
"Review this authentication code" → code-reviewer provides SOLID compliance feedback

# Use workflow-orchestrator for coordination
"What's our project status?" → workflow-orchestrator provides phase report

# Use workspace-curator for workspace management
"Set up the project workspace" → workspace-curator creates .claude/ and indexes ADRs
"What decisions have we made?" → workspace-curator reads decision index
```