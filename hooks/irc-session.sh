#!/usr/bin/env bash
# IRC session state — runs on SessionStart (compact/resume)
# Emits a one-liner if there's unread IRC history, nothing otherwise
# Reading messages via irc-read.sh clears the flag

set -euo pipefail

source "${BASH_SOURCE%/*}/irc-lib.sh"

BASE=$(irc_find_base 2>/dev/null) || exit 0

# Check for history flag
HISTORY_FLAG="$BASE/.irc-has-history"
[[ -f "$HISTORY_FLAG" ]] || exit 0

COUNT=$(cat "$HISTORY_FLAG" 2>/dev/null || echo "some")
NICK=$(irc_nick_from_base "$BASE")

echo "## IRC #relay: message history available"
echo "You're connected as ${NICK}. ${COUNT} messages received before compaction."
echo "Run \`~/.claude/hooks/irc-read.sh 20\` to catch up, or \`~/.claude/hooks/irc-read.sh 50\` for more context."
