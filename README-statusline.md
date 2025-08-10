# Claude Code Custom Statusline

## Overview
Custom statusline configuration that combines multiple information sources into a single, informative display at the bottom of Claude Code.

## Current Configuration
The statusline displays:
- 📁 Current directory name (basename only for brevity)
- 🔀 Git branch with change indicator (* for uncommitted changes)
- 💰 ccusage metrics (model, session/daily costs, burn rate)

## Files
- `statusline.sh` - Main script that combines all statusline components
- `settings.json` - Claude Code settings pointing to the custom script

## How It Works
1. Claude Code calls `/home/aaron/.claude/statusline.sh` 
2. The script gathers:
   - Current directory using `basename "$(pwd)"`
   - Git branch and status using `git branch --show-current`
   - ccusage information via `bun x ccusage statusline`
3. Outputs combined format: `📁 dir 🔀 branch* | [ccusage info]`

## Requirements
- `bun` installed for ccusage execution
- `git` for repository information
- `ccusage` package (auto-downloaded via bun x)

## Example Output
```
📁 planetary 🔀 main* | 🤖 Sonnet 4 | 💰 $0.51 session / $0.00 today / $1.81 block (4h 21m left) | 🔥 $8.47/hr
```

## Customization
Edit `statusline.sh` to add/remove components. The script is a simple bash script that can be modified to include any information accessible via shell commands.

## Troubleshooting
- If statusline doesn't appear, restart Claude Code
- Check script is executable: `chmod +x statusline.sh`
- Test manually: `~/.claude/statusline.sh`
- Verify settings.json points to correct script path