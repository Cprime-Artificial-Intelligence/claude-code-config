#!/bin/bash
# Check if claude-code-config is out of date from upstream
# Runs once per day to avoid spam

TIMESTAMP_FILE="$HOME/.claude/.last-update-check"
CURRENT_TIME=$(date +%s)
ONE_DAY=86400

# Check if we've run this recently
if [ -f "$TIMESTAMP_FILE" ]; then
    LAST_CHECK=$(cat "$TIMESTAMP_FILE")
    TIME_DIFF=$((CURRENT_TIME - LAST_CHECK))

    if [ "$TIME_DIFF" -lt "$ONE_DAY" ]; then
        # Checked recently, skip
        exit 0
    fi
fi

# Update timestamp
echo "$CURRENT_TIME" > "$TIMESTAMP_FILE"

# Only check if we're in the .claude directory
cd "$HOME/.claude" 2>/dev/null || exit 0

# Check if this is a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    exit 0
fi

# Check if upstream remote exists
if ! git remote | grep -q "^upstream$"; then
    # No upstream configured - user might have forked
    # Check if origin points to aaronsb's repo
    ORIGIN_URL=$(git remote get-url origin 2>/dev/null)
    if [[ "$ORIGIN_URL" != *"aaronsb/claude-code-config"* ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📦 Claude Code Config - Upstream Check"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "It looks like you forked claude-code-config!"
        echo ""
        echo "To receive updates from the original repo, add it as upstream:"
        echo "  cd ~/.claude"
        echo "  git remote add upstream https://github.com/aaronsb/claude-code-config.git"
        echo ""
        echo "Then check for updates anytime with:"
        echo "  git fetch upstream main"
        echo "  git log HEAD..upstream/main --oneline"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    fi
    exit 0
fi

# Fetch upstream quietly
git fetch upstream main --quiet 2>/dev/null

# Check how many commits behind
BEHIND=$(git rev-list --count HEAD..upstream/main 2>/dev/null)

if [ -z "$BEHIND" ]; then
    # Fetch failed or something went wrong
    exit 0
fi

if [ "$BEHIND" -gt 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔔 Claude Code Config - Updates Available"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Your configuration is $BEHIND commit(s) behind upstream."
    echo ""
    echo "Recent changes:"
    git log HEAD..upstream/main --oneline --max-count=5 2>/dev/null | sed 's/^/  /'
    echo ""
    echo "To update:"
    echo "  cd ~/.claude"
    echo "  git log HEAD..upstream/main  # Review all changes"
    echo "  git pull upstream main       # Pull updates"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi
