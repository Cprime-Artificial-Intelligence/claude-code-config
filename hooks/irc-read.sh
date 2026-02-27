#!/usr/bin/env bash
# Read recent IRC messages
# Usage: irc-read.sh [num_lines]
source "${BASH_SOURCE%/*}/irc-lib.sh"

N="${1:-10}"
BASE=$(irc_find_base) || { echo "ERROR: No IRC connection found" >&2; exit 1; }
tail -"$N" "$BASE/127.0.0.1/#relay/out"

# Clear history flag — we've caught up
rm -f "$BASE/.irc-has-history"
