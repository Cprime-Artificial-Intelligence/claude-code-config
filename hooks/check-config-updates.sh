#!/bin/bash
# Check if disciplined-methodology plugin has updates available
# Runs once per day to avoid spam

TIMESTAMP_FILE="$HOME/.claude/.last-plugin-update-check"
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

# Get installed plugin version from plugin.json
if [ -n "$CLAUDE_PLUGIN_ROOT" ] && [ -f "$CLAUDE_PLUGIN_ROOT/.claude-plugin/plugin.json" ]; then
    INSTALLED_VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$CLAUDE_PLUGIN_ROOT/.claude-plugin/plugin.json" | cut -d'"' -f4)
else
    # Not running from plugin context, skip
    exit 0
fi

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    # No gh CLI, can't check for updates
    exit 0
fi

# Get latest GitHub release version
LATEST_VERSION=$(gh api repos/aaronsb/claude-code-config/releases/latest --jq '.tag_name' 2>/dev/null | tr -d 'v')

if [ -z "$LATEST_VERSION" ]; then
    # Failed to fetch latest version
    exit 0
fi

# Compare versions (simple string comparison, works for semver)
if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔔 Plugin Update Available"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Disciplined Methodology Plugin"
    echo "  Current: v$INSTALLED_VERSION"
    echo "  Latest:  v$LATEST_VERSION"
    echo ""
    echo "To update:"
    echo "  /plugin update disciplined-methodology"
    echo ""
    echo "Release notes:"
    echo "  https://github.com/aaronsb/claude-code-config/releases/tag/v$LATEST_VERSION"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi
