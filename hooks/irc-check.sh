#!/usr/bin/env bash
# IRC message check — runs on UserPromptSubmit
# Notifies of new messages without injecting full content (avoids context rot)
# Uses high-water mark to track last-read position
# Auto-detects any /tmp/irc-chat-* connection

set -euo pipefail

source "${BASH_SOURCE%/*}/irc-lib.sh"

BASE=$(irc_find_base 2>/dev/null) || exit 0
MY_NICK=$(irc_nick_from_base "$BASE")

CHANNEL_OUT="$BASE/127.0.0.1/#relay/out"
HWM_FILE="$BASE/.hwm"

[[ -f "$CHANNEL_OUT" ]] || exit 0

total=$(wc -l < "$CHANNEL_OUT" 2>/dev/null || echo 0)
last=$(cat "$HWM_FILE" 2>/dev/null || echo 0)

if [[ $total -gt $last ]]; then
  new_count=$((total - last))
  new_lines=$(tail -n +"$((last + 1))" "$CHANNEL_OUT")

  # Detect join/part events (not from us)
  events=$(echo "$new_lines" | grep -E 'has joined|has quit|has left' | grep -v "$MY_NICK" || true)
  if [[ -n "$events" ]]; then
    echo "## IRC #relay: connection event"
    echo "$events"
  fi

  # Get chat messages, skip our own
  new_msgs=$(echo "$new_lines" | grep -v "<${MY_NICK}>" | grep -v -E 'has joined|has quit|has left|-!-' || true)
  other_count=$(echo "$new_msgs" | grep -c '.' || true)

  if [[ $other_count -gt 0 ]]; then
    mentions=$(echo "$new_msgs" | grep -i "$MY_NICK" || true)

    if [[ -n "$mentions" ]]; then
      echo "## IRC #relay: mentioned you"
      echo "$mentions" | tail -3
      echo ""
      echo "_Read more: \`~/.claude/hooks/irc-read.sh ${new_count}\`_"
    elif [[ $other_count -le 3 ]]; then
      echo "## IRC #relay: ${other_count} new"
      echo "$new_msgs"
    else
      echo "## IRC #relay: ${other_count} new messages"
      echo "_Last: $(echo "$new_msgs" | tail -1)_"
    fi
  fi

  # Set history flag for compaction awareness
  if [[ $other_count -gt 0 ]]; then
    echo "$other_count" > "$BASE/.irc-has-history"
  fi

  # Update high-water mark
  echo "$total" > "$HWM_FILE"
fi
