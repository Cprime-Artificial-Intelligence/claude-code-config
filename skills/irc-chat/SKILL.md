---
name: irc-chat
description: Start or join a local IRC channel for real-time chat between two Claude instances on the same machine. Use when the user says "start a chat", "IRC chat", "talk to the other Claude", "irc-chat", or invokes /irc-chat.
allowed-tools: Bash, Read, Glob, AskUserQuestion, Write
---

# IRC Chat — Local Agent-to-Agent Communication

Two Claude instances on the same machine communicate over a local IRC server using `ii` (filesystem-based IRC client). Nicks are derived from the working directory hash, so each instance gets a stable, unique identity.

## Prerequisites

- `ii` — suckless IRC client (filesystem-based). Check: `which ii`
- `miniircd` — bundled with this skill at `~/.claude/skills/irc-chat/miniircd`

If `ii` is missing, tell the user: `sudo pacman -S ii` (Arch) or build from https://tools.suckless.org/ii/

## Nick Derivation

Nicks are deterministic from the working directory:

```bash
source ~/.claude/hooks/irc-lib.sh
NICK=$(irc_nick_from_dir)   # e.g. claude-5d00b2
SLUG=$(irc_slug_from_dir)   # e.g. 5d00b2
```

This means `/home/aaron/.claude` always gets the same nick, and `/home/aaron/temp` always gets a different one. The slug is used for the ii base directory: `/tmp/irc-chat-<slug>/`.

## Step 0: Determine Role

**Interactive**: Use `AskUserQuestion`:
- **Host** — start a new IRC server and wait for the other side to join
- **Join** — connect to an IRC chat that the other side is hosting

**Automated** (subagent): role and connection info must be in the task prompt.

---

## Host Flow

### 1. Pick a port and channel

Use a random high port to avoid conflicts:

```bash
PORT=$(python3 -c "import random; print(random.randint(10000, 60000))")
CHANNEL="relay"
echo "Port: $PORT Channel: #$CHANNEL"
```

### 2. Start miniircd

```bash
python3 ~/.claude/skills/irc-chat/miniircd --listen 127.0.0.1 --ports $PORT -d
```

The `-d` flag daemonizes it. Verify it started:

```bash
sleep 1 && ss -tlnp | grep $PORT
```

### 3. Connect with ii

```bash
source ~/.claude/hooks/irc-lib.sh
NICK=$(irc_nick_from_dir)
SLUG=$(irc_slug_from_dir)
IRC_BASE="/tmp/irc-chat-${SLUG}"

ii -s 127.0.0.1 -p $PORT -n "$NICK" -i "$IRC_BASE" &
sleep 2
echo "/j #$CHANNEL" > "$IRC_BASE/127.0.0.1/in"
sleep 1
```

### 4. Give the user connection details

Tell the user the host, port, and channel so they can pass it to the other Claude instance:

```
Connection details:
- Host: 127.0.0.1
- Port: $PORT
- Channel: #relay
```

No wormhole needed — the user relays these three values.

### 5. Wait for the other side

```bash
tail -1 "$IRC_BASE/127.0.0.1/#$CHANNEL/out"
```

Once the other side joins, send a hello.

### 6. Initialize ambient monitoring

Reset the high-water mark so the UserPromptSubmit hook starts tracking from now:

```bash
wc -l < "$IRC_BASE/127.0.0.1/#$CHANNEL/out" > "$IRC_BASE/.hwm"
```

The hook at `~/.claude/hooks/irc-check.sh` auto-delivers new messages on each tick.

---

## Join Flow

### 1. Get connection info

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

### 3. Send hello and initialize HWM

```bash
~/.claude/hooks/irc-send.sh "Connected from $(irc_nick_from_dir). Ready to chat."
wc -l < "$IRC_BASE/$HOST/#$CHANNEL/out" > "$IRC_BASE/.hwm"
```

---

## Sending and Reading Messages

Always use the wrapper scripts — they handle path resolution and are permission-allowlisted:

```bash
# Send a message
~/.claude/hooks/irc-send.sh "your message here"

# Read last N messages
~/.claude/hooks/irc-read.sh 10
```

New messages from others are automatically injected by the `irc-check.sh` hook on each user prompt (tick-based delivery).

---

## Ambient Monitoring (irc-check.sh)

The `UserPromptSubmit` hook at `~/.claude/hooks/irc-check.sh`:
- Tracks a high-water mark file (`.hwm`) to avoid replaying old messages
- Filters out your own messages
- Notification tiers:
  - Direct mention → shows the message
  - ≤3 new messages → shows them inline
  - >3 new messages → badge count with last message
- Detects join/part events

No manual polling needed — messages appear in your context automatically.

---

## Ending the Chat

Either side can disconnect:

```bash
source ~/.claude/hooks/irc-lib.sh
SLUG=$(irc_slug_from_dir)
echo "/q goodbye" > "/tmp/irc-chat-${SLUG}/127.0.0.1/in"
```

**Host only** — stop the server:

```bash
pkill -f "miniircd.*--ports $PORT"
```

**Both sides** — clean up:

```bash
source ~/.claude/hooks/irc-lib.sh
rm -rf "/tmp/irc-chat-$(irc_slug_from_dir)"
```

---

## Key Principles

- **ii is filesystem-based** — `out` is a regular file (read it), `in` is a FIFO (echo to it)
- **Hash-based nicks** — deterministic from pwd, stable across restarts, no collisions
- **Tick-based time** — each Claude Code turn is an epoch; wall-clock time doesn't apply
- **Pull, not push** — hook delivers new messages per-tick as notifications, not a firehose
- **Wrapper scripts** — always use `irc-send.sh` / `irc-read.sh` to avoid permission and path issues
- **Localhost only** — both instances must be on the same machine
- **Ephemeral** — everything lives in `/tmp/`, nothing persists after cleanup
