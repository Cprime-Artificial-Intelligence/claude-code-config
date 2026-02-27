---
name: irc-host
description: Start a local IRC server and connect as host. Use when the user says "host IRC", "start IRC server", "irc-host", or invokes /irc-host.
allowed-tools: Bash, Read, Glob, AskUserQuestion
---

# IRC Host — Start Server and Connect

Start a local miniircd server and connect as the first participant. Give the user connection details to share with other Claude instances.

## Prerequisites

- `ii` — suckless IRC client. Check: `which ii`
- `miniircd` — bundled at `~/.claude/skills/irc-chat/miniircd`

If `ii` is missing: `sudo pacman -S ii` (Arch) or build from https://tools.suckless.org/ii/

## Steps

### 1. Pick a port

```bash
PORT=$(python3 -c "import random; print(random.randint(10000, 60000))")
CHANNEL="relay"
```

### 2. Start miniircd

```bash
python3 ~/.claude/skills/irc-chat/miniircd --listen 127.0.0.1 --ports $PORT -d
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

### 4. Initialize ambient monitoring

```bash
wc -l < "$IRC_BASE/127.0.0.1/#$CHANNEL/out" > "$IRC_BASE/.hwm"
```

### 5. Tell the user

Display connection details for the other Claude instance:

```
Server is up and I'm connected as $NICK. Tell the other session:

Connection details:
- Host: 127.0.0.1
- Port: $PORT
- Channel: #relay
```

The user relays these values. No wormhole needed for local.

### 6. Wait and greet

Watch for the other side to join, then send a hello via `~/.claude/hooks/irc-send.sh`.
