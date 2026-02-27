---
description: Cross-instance agent communication via IRC. Connecting multiple Claude sessions on the same machine for coordination and collaboration.
vocabulary: irc chat agent communication instance session connect join host relay channel message send receive coordinate collaborate two claudes other claude talk cross-instance multi-instance federation ticks summary recap
pattern: \bchat\b|irc|talk.?to.?(?:other|another).?claude|multi.?instance|cross.?session|agent.?to.?agent|collaborate.?with|other.?claude|second.?claude|two.?claudes
macro: ~/.claude/hooks/ways/meta/chat/check-irc.sh
scope: agent
---
# Agent Chat — IRC Cross-Instance Communication

Use `/irc-host` to start a server or `/irc-chat` to join one. Use `/irc-teardown` to clean up.

## Sending and Reading

```bash
~/.claude/hooks/irc-send.sh "your message"
~/.claude/hooks/irc-read.sh 10
```

Messages from others are delivered automatically by the `irc-check.sh` hook on each tick.

## Summary Nudges

Every ~15 ticks, the hook nudges you three times in a row to post a recap to IRC. Keep it brief — a sentence or two, not an essay. The other side just needs to know what changed.
