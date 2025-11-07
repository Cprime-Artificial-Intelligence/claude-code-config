# Specialized Sub-Agents

Use sub-agents for specialized, token-intensive work. Main Claude handles most tasks.

## Available Sub-Agents

### requirements-analyst
**Purpose**: Capture user needs as GitHub issues or in ADR context

**When to use**:
- Complex requirements needing structure
- Multiple stakeholders with different needs
- Requirements that will evolve over time

**What it does**:
- Creates GitHub issues with `requirement` label
- Captures problem statements and acceptance criteria
- Asks clarifying questions to understand needs

**What it doesn't do**:
- Implement solutions
- Make architectural decisions
- Write code

### system-architect
**Purpose**: Draft ADRs and evaluate SOLID principles

**When to use**:
- Architectural decisions need documentation
- Need SOLID principles evaluation
- Complex design trade-offs to analyze

**What it does**:
- Drafts ADRs with context, decision, consequences
- Creates PR for ADR review
- Evaluates code against SOLID principles
- Provides specific refactoring recommendations

**What it doesn't do**:
- Implement code
- Make unilateral decisions (proposes, doesn't decide)

### task-planner
**Purpose**: Plan complex multi-branch implementations

**When to use**:
- Feature spans multiple branches
- Complex dependencies to coordinate
- Need implementation sequencing

**What it does**:
- Suggests branch strategy
- Identifies dependencies
- Breaks down complex work
- Maintains TodoWrite for session focus

**What it doesn't do**:
- Over-plan simple work
- Create tracking files (uses TodoWrite)
- Provide time estimates (uses complexity ratings)

### code-reviewer
**Purpose**: Review PRs for quality and SOLID compliance

**When to use**:
- Large PR needs thorough review
- SOLID compliance check needed
- Security-sensitive code review

**What it does**:
- Reviews code against SOLID principles
- Identifies monolithic patterns
- Provides specific refactoring suggestions
- Checks security practices

**What it doesn't do**:
- Edit or write code (strictly a reviewer)
- Approve without proper analysis
- Nitpick style over substance

### workflow-orchestrator
**Purpose**: Coordinate project phases and workflow

**When to use**:
- Need overall project status
- Workflow guidance for complex situation
- Coordinating multiple agents

**What it does**:
- Guides ADR-driven workflow
- Provides project status reports
- Coordinates between agents
- Ensures work has clear intent

**What it doesn't do**:
- Act as process police
- Enforce rigid methodology
- Create overhead for simple tasks

### workspace-curator
**Purpose**: Organize docs/ and .claude/ directories

**When to use**:
- Documentation getting scattered
- Need ADR numbering guidance
- Project workspace needs organization

**What it does**:
- Recommends docs/ structure
- Suggests ADR numbering (ADR-NNN-description.md)
- Organizes .claude/ configuration
- Prevents documentation sprawl

**What it doesn't do**:
- Create elaborate structures upfront
- Mandate rigid organization
- Reorganize without asking

## Agent Removed

**github-project-manager** (ELIMINATED in v2.0.0):
- Functionality distributed to other agents
- Each agent handles its own `gh` CLI operations
- Reduces coordination overhead

## When to Use Sub-Agents

**Main Claude handles**:
- Most implementation work
- Simple ADRs
- Straightforward requirements
- Basic planning
- Quick reviews

**Sub-agents handle**:
- Token-intensive refactors
- Complex requirement capture
- Detailed ADR drafting with SOLID analysis
- Large PR reviews
- Multi-branch planning

**Rule of thumb**: If the task would consume significant context or requires specialized focus, consider a sub-agent. Otherwise, main Claude is sufficient.

## Invoking Sub-Agents

Sub-agents are invoked by name through Claude's Task tool:
```
User: "Can you review this auth implementation for SOLID compliance?"
Claude: "I'll use the code-reviewer agent to analyze the auth code..."
```

Claude decides when to use sub-agents based on task complexity and specialization needs.

## Agent Coordination

Agents coordinate through:
- **Shared context**: ADRs, requirements, git history
- **GitHub artifacts**: Issues, PRs, comments
- **Git workflow**: Branches, commits, tags

No complex coordination layer - agents work independently on their specialized tasks.
