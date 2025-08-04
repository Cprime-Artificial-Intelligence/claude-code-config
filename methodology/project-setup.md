## Project Context Discovery
**CRITICAL:** Always discover and read project-scoped CLAUDE.md files when starting work in any project:

1. **Locate Project Root:** Search upward from current working directory for:
   - `CLAUDE.md` (primary project configuration)
   - `CLAUDE.local.md` (local overrides, typically gitignored)
   - `.claude/` directory containing project-specific configurations

2. **Read Order:** When multiple CLAUDE.md files exist in a project tree:
   - Read user scope first (`~/.claude/CLAUDE.md` - this file)
   - Read project root `CLAUDE.md` 
   - Read any subdirectory `CLAUDE.md` files relevant to current work area
   - Read `CLAUDE.local.md` last (highest precedence for local overrides)

3. **Auto-Discovery Trigger:** Perform this discovery:
   - At conversation start in any new directory
   - After compaction events (via hook system)
   - When user mentions project-specific requirements or constraints

## Tracking Method Selection

**CRITICAL:** When no task structure exists on disk, ask the user to choose tracking method:

### Detection Pattern
Look for these indicators of existing tracking:
- Local: `requirements.md`, `design.md`, `tasks.md`, or `.claude-tracking` file
- GitHub: Repository with issues/projects, or `.github-tracking` file

### If No Structure Found
Ask: *"This project has no tracking structure. Choose method:*
- **Local files** (requirements.md, design.md, tasks.md on disk)
- **GitHub integration** (issues, projects, milestones)*"

### Local File Setup (if chosen)
1. Create tracking indicator: `echo "local" > .claude-tracking`
2. Create initial structure:
   ```
   requirements.md    # User stories index
   design.md         # Architecture decisions  
   tasks.md          # Implementation plan
   ```

### GitHub Setup (if chosen) 
1. Create tracking indicator: `echo "github" > .github-tracking`
2. Create working directory: `mkdir -p .claude-github/`
3. Verify GitHub CLI: `gh auth status && gh repo view`
4. Enable GitHub features:
   - Issues: `gh repo edit --enable-issues=true`
   - Projects: Check with `gh project list --owner OWNER`
5. **Setup required labels**: Run label creation commands (see GitHub Setup section)
6. **Configure Projects**: Ask user about project board setup if needed