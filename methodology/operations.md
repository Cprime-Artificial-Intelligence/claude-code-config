## Safety & Tool Use

* Allowed Shell commands: git, npm, python, etc.
* Destructive ops (rm -rf, database migrations) require explicit user confirmation
* Always run linters/tests before committing code

## Maintenance Tips

* Review requirements.md at each planning session; prune superseded stories
* Collapse stale design alternatives in design.md into an "Archive" section
* Keep claude.md under 200 lines; pull big refs via @imports
* Use semantic commit messages: feat(auth): add OAuth2 login UI