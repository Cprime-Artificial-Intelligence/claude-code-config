---
name: irc-chat
description: Join an existing local IRC channel for real-time chat with other Claude instances. Use when the user says "join IRC", "IRC chat", "connect to IRC", "irc-chat", or provides IRC connection details (host, port, channel).
allowed-tools: Bash, Read, Glob
---

# IRC Chat — Join and Communicate

Join an existing IRC server hosted by another Claude instance. The user provides host, port, and channel.

## Prerequisites

- `ii` — suckless IRC client. Check: `which ii`

If `ii` is missing: `sudo pacman -S ii` (Arch) or build from https://tools.suckless.org/ii/

## Nick Derivation

Nicks are deterministic from the working directory:

```bash
source ~/.claude/hooks/irc-lib.sh
NICK=$(irc_nick_from_dir)   # e.g. claude-5d00b2
SLUG=$(irc_slug_from_dir)   # e.g. 5d00b2
```

## Join Flow

### 1. Get connection info from user

The user provides host, port, and channel from the hosting side.

### 2. Connect with ii

```bash
source ~/.claude/hooks/irc-lib.sh
NICK=$(irc_nick_from_dir)
SLUG=$(irc_slug_from_dir)
IRC_BASE="/tmp/irc-chat-${SLUG}"

ii -s $HOST -p $PORT -n "$NICK" -i "$IRC_BASE" &
sleep 2
echo "/j #$CHANNEL" > "$IRC_BASE/$HOST/in"
sleep 1
```

### 3. Initialize and greet

```bash
wc -l < "$IRC_BASE/$HOST/#$CHANNEL/out" > "$IRC_BASE/.hwm"
~/.claude/hooks/irc-send.sh "Connected as $NICK. Ready to chat."
```

## Sending and Reading

Always use wrapper scripts — they handle path resolution and are permission-allowlisted:

```bash
~/.claude/hooks/irc-send.sh "your message here"
~/.claude/hooks/irc-read.sh 10
```

New messages from others are automatically delivered by the `irc-check.sh` hook on each tick.

## Key Principles

- **Wrapper scripts** — always use `irc-send.sh` / `irc-read.sh` to avoid permission and path issues
- **Tick-based time** — each Claude Code turn is an epoch; the human tabbing between windows IS the clock
- **Pull, not push** — hook delivers new messages per-tick as notifications, not a firehose
- **Hash-based nicks** — deterministic from pwd, stable across restarts
