#!/usr/bin/env bash
# Macro: check for running IRC servers and other Claude instances
# Output is prepended to the way content

# Check for running miniircd
SERVER_PID=$(pgrep -f miniircd 2>/dev/null || true)
if [[ -n "$SERVER_PID" ]]; then
  PORT=$(ps -p "$SERVER_PID" -o args= 2>/dev/null | grep -oP '(?<=--ports )\d+' || echo "unknown")
  echo "## IRC server detected"
  echo "- miniircd running on port ${PORT}"

  # Check who's connected
  CLIENTS=$(pgrep -af "ii.*irc-chat" 2>/dev/null | grep -oP '(?<=-n )\S+' || true)
  if [[ -n "$CLIENTS" ]]; then
    echo "- Connected clients: ${CLIENTS//$'\n'/, }"
  fi

  # Check if WE are connected
  source "${BASH_SOURCE%/*}/../../../irc-lib.sh" 2>/dev/null || true
  if type irc_find_base &>/dev/null; then
    BASE=$(irc_find_base 2>/dev/null || true)
    if [[ -n "$BASE" ]]; then
      echo "- **You are connected.** Use \`irc-send.sh\` / \`irc-read.sh\`."
    else
      echo "- **You are not connected.** Use \`/irc-chat\` to join (host: 127.0.0.1, port: ${PORT}, channel: #relay)."
    fi
  fi
else
  # No server — check if other Claude instances exist
  CC_COUNT=$(pgrep -c -f "claude" 2>/dev/null || echo 0)
  if [[ $CC_COUNT -gt 1 ]]; then
    echo "## No IRC server, but multiple Claude processes detected (${CC_COUNT})"
    echo "- Use \`/irc-host\` to start a server, then share connection details with the other instance."
  else
    echo "## No IRC server running, no other Claude instances detected."
    echo "- Use \`/irc-host\` to start one when ready."
  fi
fi
