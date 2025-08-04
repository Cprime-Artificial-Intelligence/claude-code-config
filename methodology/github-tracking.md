### GitHub Method Equivalents
| GitHub Feature | Authoritative Purpose | Management Commands |
|----------------|-----------------------|---------------------|
| **Issues with labels** | *Requirements tracking.* Each issue = User Story with `requirement` label. Body contains "As/Want/So" format + acceptance criteria. | `gh issue create --label requirement --title "req-001: User Login" --body-file .claude-github/req.md`<br>`gh issue list --label requirement --state all` |
| **Discussion/Wiki** | *Design decisions.* Architecture docs, tech choices, trade-offs. Link to requirement issues. | `gh api repos/:owner/:repo/contents/wiki/Design.md --method PUT --field content=@.claude-github/design.md`<br>`gh repo view --web` (navigate to wiki) |
| **Milestones + Issues** | *Task management.* Milestones = Tasks, Issues = Sub-tasks with `task` label. | `gh issue create --milestone "Task-01-Auth" --label task --assignee @me`<br>`gh issue list --milestone "Task-01-Auth" --label task` |

## GitHub CLI Command Reference

### Requirements Management
```bash
# List all requirements
gh issue list --label requirement --state all --json number,title,state,labels

# Create new requirement
echo "As a user I want..." > .claude-github/req-temp.md
gh issue create --label requirement --title "req-XXX: Title" --body-file .claude-github/req-temp.md

# Update requirement (add acceptance criteria)
gh issue edit NUMBER --body-file .claude-github/updated-req.md

# View requirement details
gh issue view NUMBER --json title,body,labels,state
```

### Design Management  
```bash
# View current design decisions (via wiki or discussions)
gh api repos/:owner/:repo/contents/wiki/Design.md --jq '.content' | base64 -d

# Update design document
echo "## Architecture Decision..." > .claude-github/design-update.md
gh api repos/:owner/:repo/contents/wiki/Design.md --method PUT \
  --field message="Update design decisions" \
  --field content="$(base64 -i .claude-github/design-update.md)"
```

### Task Management
```bash
# Create milestone (Task)
gh api repos/:owner/:repo/milestones --method POST \
  --field title="Task-01-Authentication" \
  --field description="User auth implementation"

# List all tasks (milestones) 
gh api repos/:owner/:repo/milestones --jq '.[] | {title, state, open_issues, closed_issues}'

# Create sub-task
gh issue create --milestone "Task-01-Authentication" --label task \
  --title "sub-01-a: Research OAuth providers (req-001)" \
  --assignee @me --body "Implements req-001 acceptance criteria"

# List sub-tasks for active milestone
gh issue list --milestone "Task-01-Authentication" --label task --json number,title,state

# Complete sub-task  
gh issue close NUMBER --comment "✔ Done: OAuth provider research complete"

# Check milestone progress
gh api repos/:owner/:repo/milestones --jq '.[] | select(.title=="Task-01-Authentication") | {open_issues, closed_issues}'
```

### Status & Review Commands
```bash
# Project overview
gh repo view --json name,description,hasIssuesEnabled,hasProjectsEnabled
gh issue list --label requirement --state open --limit 5
gh api repos/:owner/:repo/milestones --jq '.[] | select(.state=="open") | .title'

# Daily standup view
gh issue list --assignee @me --label task --state open --json title,milestone

# Requirements completion status  
gh issue list --label requirement --state all --json number,title,state | \
  jq 'group_by(.state) | map({state: .[0].state, count: length})'
```

## GitHub Setup & Configuration

### Required Labels Setup
**CRITICAL:** Always verify and create required labels before using GitHub tracking:

```bash
# Check existing labels
gh label list --json name,color,description

# Create required labels (run these if missing)
gh label create "requirement" --color "0052CC" --description "User story/requirement tracking"
gh label create "task" --color "00AA00" --description "Implementation sub-task"
gh label create "design" --color "9932CC" --description "Architecture/design decision"
gh label create "blocked" --color "FF0000" --description "Work blocked, needs resolution"
gh label create "ready" --color "FFAA00" --description "Ready for implementation"

# Optional enhancement labels
gh label create "bug" --color "EE0000" --description "Bug fix required"
gh label create "enhancement" --color "00AA00" --description "Feature enhancement"
gh label create "priority-high" --color "FF4444" --description "High priority item"
gh label create "priority-medium" --color "FFAA44" --description "Medium priority item"
gh label create "priority-low" --color "44FF44" --description "Low priority item"
```

### Projects Configuration Check
**Ask user about project board setup when:**
- No projects exist: `gh project list --owner OWNER` returns empty
- Complex multi-milestone work is planned
- User wants visual kanban/roadmap tracking

**User Configuration Questions:**
1. *"Would you like me to create a GitHub Project board for visual task tracking?"*
2. *"Should we use a simple kanban view (To Do/In Progress/Done) or milestone-based planning?"*
3. *"Do you want automated project board updates when issues change status?"*

### Project Board Creation
```bash
# Create basic kanban project
gh project create --title "Project Development" --body "Main development tracking board"

# Get project number from creation output, then:
PROJECT_NUMBER="1"  # Replace with actual number

# Add standard columns
gh api graphql -f query='
  mutation {
    addProjectV2DraftIssue(input: {
      projectId: "PROJECT_ID"
      title: "Configure Board"
    }) {
      projectItem {
        id
      }
    }
  }'

# Alternative: Create via web UI and get project info
gh project list --owner OWNER --format json | jq '.[] | {number, title, url}'
```

### Automated Workflows (Optional)
Ask user: *"Should I help set up automated workflows for issue/project sync?"*

If yes, create `.github/workflows/project-sync.yml`:
```yaml
name: Project Sync
on:
  issues:
    types: [opened, edited, closed, reopened]
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Add to project
        uses: actions/add-to-project@v0.4.0
        with:
          project-url: https://github.com/users/USERNAME/projects/PROJECT_NUMBER
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Repository Permissions Check
```bash
# Verify repo permissions
gh api repos/:owner/:repo --jq '.permissions | {admin, push, pull}'

# Check if user can create milestones, labels, projects
gh api user --jq '.login'
gh api repos/:owner/:repo/collaborators/USERNAME/permission --jq '.permission'
```