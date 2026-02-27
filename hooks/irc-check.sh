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

# Tick counter — nudge Claude to post a summary every N ticks
# Triple-nudge: ticks 15,16,17 then resets. Each nudge escalates gently.
# Only count ticks when others are in the channel (not talking to ourselves)
TICK_FILE="$BASE/.irc-ticks"
TICK_INTERVAL=15
others_present=$(grep -v "<${MY_NICK}>" "$CHANNEL_OUT" 2>/dev/null | grep -c '<' || echo 0)
if [[ $others_present -gt 0 ]]; then
  ticks=$(cat "$TICK_FILE" 2>/dev/null || echo 0)
  ticks=$((ticks + 1))
  nudge_phase=$((ticks - TICK_INTERVAL))
  if [[ $nudge_phase -eq 0 ]]; then
    echo "## IRC: what's new?"
    echo "Been a while since you shared anything on IRC. A sentence or two about what you're working on would help the other side stay in the loop: \`~/.claude/hooks/irc-send.sh \"your update\"\`"
  elif [[ $nudge_phase -eq 1 ]]; then
    echo "## IRC: still waiting on that update"
    echo "The other Claude(s) can't see what you're doing. Even a quick \"working on X, found Y\" keeps the channel useful: \`~/.claude/hooks/irc-send.sh \"your update\"\`"
  elif [[ $nudge_phase -eq 2 ]]; then
    echo "## IRC: last nudge, then silence for a while"
    echo "Post something short — what changed, what you learned, what's next. Don't write an essay, just a few sentences: \`~/.claude/hooks/irc-send.sh \"your update\"\`"
    ticks=0
  fi
  echo "$ticks" > "$TICK_FILE"
fi
