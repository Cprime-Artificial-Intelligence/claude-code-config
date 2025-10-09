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

# Read canonical upstream URL from config file
CANONICAL_UPSTREAM=""
if [ -f "$HOME/.claude/.canonical-upstream" ]; then
    CANONICAL_UPSTREAM=$(cat "$HOME/.claude/.canonical-upstream" | tr -d '[:space:]')
fi

# Determine which remote to check
ORIGIN_URL=$(git remote get-url origin 2>/dev/null)
REMOTE_TO_CHECK=""
REMOTE_NAME=""

if git remote | grep -q "^upstream$"; then
    # Upstream exists - this is a fork, check upstream
    REMOTE_TO_CHECK="upstream"
    REMOTE_NAME="upstream"
elif [ -n "$CANONICAL_UPSTREAM" ] && [[ "$ORIGIN_URL" == "$CANONICAL_UPSTREAM"* ]]; then
    # Origin points to canonical upstream - this is the original or a direct clone
    REMOTE_TO_CHECK="origin"
    REMOTE_NAME="origin"
else
    # Forked but no upstream configured
    if [ -z "$CANONICAL_UPSTREAM" ]; then
        # No canonical upstream file found - can't suggest what to add
        exit 0
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Claude Code Config - Upstream Check"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "It looks like you forked claude-code-config!"
    echo ""
    echo "To receive updates from the canonical repo, add it as upstream:"
    echo "  cd ~/.claude"
    echo "  git remote add upstream $CANONICAL_UPSTREAM"
    echo ""
    echo "Then check for updates anytime with:"
    echo "  git fetch upstream main"
    echo "  git log HEAD..upstream/main --oneline"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 0
fi

# Fetch remote quietly
git fetch "$REMOTE_TO_CHECK" main --quiet 2>/dev/null

# Check how many commits behind
BEHIND=$(git rev-list --count HEAD.."$REMOTE_TO_CHECK"/main 2>/dev/null)

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
    echo "Your configuration is $BEHIND commit(s) behind $REMOTE_NAME."
    echo ""
    echo "Recent changes:"
    git log HEAD.."$REMOTE_TO_CHECK"/main --oneline --max-count=5 2>/dev/null | sed 's/^/  /'
    echo ""
    echo "To update:"
    echo "  cd ~/.claude"
    echo "  git log HEAD..$REMOTE_TO_CHECK/main  # Review all changes"
    echo "  git pull $REMOTE_TO_CHECK main       # Pull updates"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi
