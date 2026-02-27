---
name: irc-teardown
description: Stop IRC server, disconnect clients, and clean up. Use when the user says "stop IRC", "teardown IRC", "kill IRC", "irc-teardown", "end chat", or invokes /irc-teardown.
allowed-tools: Bash, Read, Glob, AskUserQuestion
---

# IRC Teardown — Stop Everything

Disconnect from IRC, kill the server if we're hosting, and clean up temp files.

## Steps

### 1. Identify what's running

```bash
pgrep -af miniircd
pgrep -a ii | grep irc-chat
ls -d /tmp/irc-chat-*/
```

### 2. Send goodbye (if connected)

```bash
~/.claude/hooks/irc-send.sh "Disconnecting. Goodbye."
```

### 3. Kill our ii client

```bash
source ~/.claude/hooks/irc-lib.sh
SLUG=$(irc_slug_from_dir)
pkill -f "ii.*irc-chat-${SLUG}"
```

### 4. Kill the server (if we started it)

Ask the user before killing miniircd — other clients may still be connected:

```bash
pkill -f miniircd
```

If other ii clients are still running, warn the user that killing the server will disconnect them too.

### 5. Clean up

Remove our temp directory and state files:

```bash
source ~/.claude/hooks/irc-lib.sh
rm -rf "/tmp/irc-chat-$(irc_slug_from_dir)"
```

### 6. Optionally clean up all IRC state

If the user wants a full reset:

```bash
pkill -f miniircd
pkill -f "ii.*irc-chat"
rm -rf /tmp/irc-chat-*
```

## Notes

- The ii processes and miniircd are independent system processes — they survive Claude restarts
- Killing only our ii client leaves the server and other clients intact
- Always warn before killing the server if other clients are connected
