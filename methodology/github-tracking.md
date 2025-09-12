### GitHub Method Equivalents
| GitHub Feature | Authoritative Purpose | Management Commands |
|----------------|-----------------------|---------------------|
| **Project Board Items** | *Requirements & feature tracking.* Strategic work items = User Stories with "As/Want/So" format + acceptance criteria. | `gh project item-create PROJECT_NUMBER --title "req-001: User Login" --body "As a user..."`<br>`gh project item-list PROJECT_NUMBER --format json` |
| **Issues** | *Bug & problem tracking.* Tactical issues that arise during implementation. Link to board items for traceability. | `gh issue create --label bug --title "Fix auth token expiry" --body "Related to req-001"`<br>`gh issue list --label bug --state open` |
| **Discussion/Wiki** | *Design decisions.* Architecture docs, tech choices, trade-offs. Reference board item IDs. | `gh api repos/:owner/:repo/contents/wiki/Design.md --method PUT --field content=@.claude-github/design.md`<br>`gh repo view --web` (navigate to wiki) |
| **Milestones** | *Sprint/release grouping.* Time-boxed collections of board items and issues. | `gh api repos/:owner/:repo/milestones --method POST --field title="Sprint-01"`<br>`gh project item-edit --id ITEM_ID --field-id FIELD_ID --iteration "Sprint-01"` |

## GitHub CLI Command Reference

### Requirements Management (Project Board)
```bash
# List all requirements from project board
gh project item-list PROJECT_NUMBER --owner OWNER --format json | 
  jq '.items[] | select(.content.type=="DraftIssue" or .content.type=="Issue") | {id, title: .content.title, body: .content.body, status: .fieldValues.status}'

# Create new requirement as board item
echo "As a user I want..." > .claude-github/req-temp.md
gh project item-create PROJECT_NUMBER --owner OWNER \
  --title "req-XXX: Title" \
  --body "$(cat .claude-github/req-temp.md)"

# Update requirement (add acceptance criteria)
gh project item-edit --id ITEM_ID --project-id PROJECT_NUMBER \
  --body "$(cat .claude-github/updated-req.md)"

# View requirement details
gh project item-view PROJECT_NUMBER --id ITEM_ID --format json

# Move requirement to different status column
gh project item-edit --id ITEM_ID --project-id PROJECT_NUMBER \
  --field-id STATUS_FIELD_ID --single-select-option-id OPTION_ID
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

### Bug & Problem Tracking (Issues)
```bash
# Create bug/problem issue linked to board item
gh issue create --label bug \
  --title "Fix: Auth token expires too quickly" \
  --body "Related to board item: req-001-user-login\n\nProblem: JWT tokens expire after 5 minutes instead of 1 hour"

# List all bugs/problems
gh issue list --label bug --state open --json number,title,state,labels

# Create implementation problem
gh issue create --label problem \
  --title "Problem: OAuth callback URL mismatch" \
  --body "Blocking req-002-oauth-integration\n\nIssue: Callback URL in dev doesn't match production pattern"

# Link issue to project board item
gh project item-add PROJECT_NUMBER --owner OWNER --url ISSUE_URL

# Close resolved issue
gh issue close NUMBER --comment "✔ Fixed: Token expiry now set to 1 hour"

# List issues by milestone (for sprint tracking)
gh issue list --milestone "Sprint-01" --json number,title,state,labels
```

### Status & Review Commands
```bash
# Project overview
gh project list --owner OWNER --format json | jq '.projects[] | {number, title, url}'
gh project item-list PROJECT_NUMBER --owner OWNER --limit 10 --format json | \
  jq '.items[] | {title: .content.title, status: .fieldValues.status}'

# Requirements in progress
gh project item-list PROJECT_NUMBER --owner OWNER --format json | \
  jq '.items[] | select(.fieldValues.status.name=="In Progress") | .content.title'

# Sprint/milestone status
gh api repos/:owner/:repo/milestones --jq '.[] | select(.state=="open") | {title, open_issues, closed_issues}'

# Bug/problem tracking
gh issue list --label bug --state open --json number,title,assignee | \
  jq 'group_by(.assignee.login) | map({assignee: .[0].assignee.login, count: length})'

# Board completion metrics
gh project item-list PROJECT_NUMBER --owner OWNER --format json | \
  jq '[.items[] | .fieldValues.status.name] | group_by(.) | map({status: .[0], count: length})'
```

## GitHub Setup & Configuration

### Required Labels Setup
**CRITICAL:** Always verify and create required labels before using GitHub tracking:

```bash
# Check existing labels
gh label list --json name,color,description

# Create required labels (run these if missing)
gh label create "bug" --color "EE0000" --description "Bug or problem during implementation"
gh label create "problem" --color "FF6600" --description "Implementation blocker or issue"
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

### Project Board Creation & Setup
```bash
# Create project board for requirements tracking
gh project create --owner OWNER --title "Product Requirements" \
  --body "Strategic requirement and feature tracking board"

# Get project number and details
gh project list --owner OWNER --format json | \
  jq '.projects[] | {number, title, url, id}'

# View project fields (to get field IDs for status, etc.)
gh project field-list PROJECT_NUMBER --owner OWNER --format json

# Create requirement item on board
gh project item-create PROJECT_NUMBER --owner OWNER \
  --title "req-001: User authentication" \
  --body "As a user, I want to log in securely, so that I can access my personal data"

# Add existing issue to project (for bugs/problems only)
gh project item-add PROJECT_NUMBER --owner OWNER \
  --url "https://github.com/owner/repo/issues/123"

# Update item status
gh project item-edit --project-id PROJECT_NUMBER --id ITEM_ID \
  --field-id STATUS_FIELD_ID --single-select-option-id IN_PROGRESS_ID
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