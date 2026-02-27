#!/usr/bin/env bash
# Send a message to IRC relay channel
# Usage: irc-send.sh <message>
source "${BASH_SOURCE%/*}/irc-lib.sh"

MSG="$*"
[[ -z "$MSG" ]] && { echo "Usage: irc-send.sh <message>" >&2; exit 1; }

BASE=$(irc_find_base) || { echo "ERROR: No IRC connection found" >&2; exit 1; }
echo "$MSG" > "$BASE/127.0.0.1/#relay/in"
