# GitHub Quick Reference

Lightweight GitHub usage guidelines. Not requirements - just helpful patterns.

## Basic Labels

Create if missing:
```bash
gh label create "bug" --color "d73a4a" --description "Bug fix required"
gh label create "enhancement" --color "a2eeef" --description "New feature or improvement"
gh label create "documentation" --color "0075ca" --description "Documentation update"
gh label create "decision" --color "d4c5f9" --description "Architecture decision (ADR)"
gh label create "requirement" --color "c5def5" --description "Feature requirement or user need"
```

## Common Workflows

### Check for GitHub Upstream
```bash
gh repo view
# Succeeds → use GitHub features
# Fails → use git only
```

### Issues for Requirements (Optional)
```bash
# Create requirement
gh issue create --label requirement \
  --title "User password reset" \
  --body "Problem: Users can't recover locked accounts

Acceptance criteria:
- Reset link expires after 1 hour
- Email delivery with secure token
- Old password invalidated on reset"

# List requirements
gh issue list --label requirement

# Link issue in commits
git commit -m "feat(auth): Implement password reset

Addresses #123"
```

### ADR Pull Requests
```bash
# Create ADR branch
git checkout -b adr-005-oauth-strategy
git add docs/adr/ADR-005-oauth-strategy.md
git commit -m "docs: Add ADR-005 for OAuth integration strategy"
git push -u origin adr-005-oauth-strategy

# Create PR
gh pr create --title "ADR-005: OAuth Integration Strategy" \
  --body "Documents decision to use OAuth 2.0 with PKCE flow..."

# View PR
gh pr view 42 --web

# Merge after approval
gh pr merge 42 --squash
```

### Code Pull Requests
```bash
# Create feature branch
git checkout -b feature/oauth-implementation
# ... work ...
git push -u origin feature/oauth-implementation

# Create PR
gh pr create --title "Implement OAuth authentication" \
  --body "Implements ADR-005 OAuth strategy.

Changes:
- OAuth client configuration
- Login/callback endpoints
- Token management
- User profile sync"

# Address review feedback
git commit -m "refactor: Extract token refresh logic"
git push

# Merge after approval
gh pr merge 45 --squash
```

### Code Review
```bash
# Review PR
gh pr review 45 --approve --body "LGTM. Clean implementation."

# Request changes
gh pr review 45 --request-changes --body "Found issues:
1. file.js:23 - API key exposed
2. auth.js:45 - Missing input validation"

# Add comment
gh pr review 45 --comment --body "Consider extracting this to a helper function"
```

### Project Status
```bash
# List open PRs
gh pr list --state open

# List open issues
gh issue list --state open

# Recent activity
gh pr list --limit 5 --json number,title,updatedAt

# Filter by label
gh issue list --label bug --state open
```

## What to Avoid

**Don't use**:
- Complex project boards (manual tracking overhead)
- Elaborate milestone hierarchies (creates busywork)
- Automated status sync workflows (fragile, hard to maintain)
- Excessive labels (adds noise, requires maintenance)

**Keep it simple**: Issues, PRs, basic labels. That's 90% of what you need.

## Wiki (Optional)

For extensive documentation that doesn't belong in the repo:
```bash
# Clone wiki
gh repo clone owner/repo.wiki

# Edit wiki pages
cd repo.wiki
# ... edit markdown files ...
git add . && git commit -m "Update auth docs"
git push

# View wiki
gh repo view --web
# Click "Wiki" tab
```

**When to use wiki**:
- Extensive user guides
- Team processes
- Reference documentation

**When NOT to use wiki**:
- ADRs (use docs/adr/ instead)
- Code documentation (use repo docs/)
- Active development notes (use issues/PRs)

## Permissions

Verify access before operations:
```bash
# Check auth
gh auth status

# Check repo permissions
gh api repos/:owner/:repo --jq '.permissions'
```

## Summary

GitHub features to **use**: Issues (optional), PRs (required), basic labels.

GitHub features to **avoid**: Complex boards, elaborate milestones, excessive automation.

Keep it lightweight - the value is in code review and discussion, not process overhead.
