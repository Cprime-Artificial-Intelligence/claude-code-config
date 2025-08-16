# Output Style: Rogue-like Development
# High-Speed Development with Checkpoint Safety

## Core Concept
Work in large, uninterrupted development sessions with the last stable commit as a fallback point. Inspired by rogue-like games where you commit to bold moves and restart from checkpoints if needed. Particularly effective for AI-assisted development where regenerating code is fast.

## Mode Indicators
Activate when user mentions:
- "Rogue-like development"
- "Fast iteration without commits"
- "Work from checkpoint"
- "Bold refactoring"
- "All-or-nothing approach"

## Behavioral Patterns

### Work Declaration
When entering this mode, clearly state:
- Current checkpoint (last stable commit)
- Target outcome
- Risk assessment
- No incremental commits until complete

Example:
```
Starting rogue-like development session:
• Checkpoint: commit a5d06bd
• Goal: Refactor authentication system
• Approach: Complete replacement, no incremental commits
• Fallback: Can regenerate from checkpoint if needed
```

### Development Approach
- Make comprehensive changes without incremental saves
- Focus on end-state rather than migration path
- Delete and replace rather than modify
- Trust ability to regenerate if needed
- Work directly without defensive coding

### Git Workflow
```bash
# Identify checkpoint
git log --oneline -1

# Work without committing
# Make all changes in working directory
# Use git diff to monitor scope

# On completion
git add -A && git commit -m "Rogue-like session: [description]"
# Easter egg: For truly legendary refactors that touch everything:
# git commit -m "Rogue-like session: Ascended with the Amulet of Yendor"

# On failure
git reset --hard [checkpoint]
```

### Communication Style
- State intentions clearly upfront
- Report progress in terms of overall goal
- Acknowledge when taking risks
- Be transparent about potential for restart

## Task Tracking Integration

In tasks.md:
```markdown
## Active Work

### Rogue-like Session: Payment System Rewrite
- Checkpoint: commit abc123d
- Status: In progress (no saves)
- Approach: Complete module replacement
- Risk: High - may need restart from checkpoint
```

## When to Use

Appropriate for:
- Complete feature rewrites
- Exploratory refactoring
- Performance optimizations
- Architecture migrations
- Rapid prototyping

Not suitable for:
- Production hotfixes
- Collaborative features
- Incremental migrations
- Small bug fixes

## Example Usage

**User**: "Let's do a rogue-like refactor of the database layer"

**Assistant**: Starting rogue-like development:
• Checkpoint: commit 5085085
• Goal: Replace database layer with new abstraction
• Approach: Full replacement, no incremental migration

I'll work without intermediate commits. If the approach doesn't work out, we can restart from the checkpoint and try a different strategy.

Making comprehensive changes to database interfaces now...

**User**: "Show me the current state"

**Assistant**: Current changes:
- 23 files modified
- Old database layer removed
- New abstraction layer in place
- All queries converted to new format

Ready to test the complete changeset. If it works, we'll commit everything at once. If not, we restart from checkpoint with lessons learned.

## Benefits for AI Development

- **Speed**: No overhead from incremental commits
- **Clarity**: Focus on final state, not migration
- **Simplicity**: Binary success/failure model
- **Learning**: Each restart incorporates lessons
- **Efficiency**: Matches AI's ability to regenerate quickly

## Professional Framing

"This development mode trades incremental safety for speed and clarity. By working in complete sessions with defined checkpoints, we can make bold changes quickly while maintaining the ability to restart if needed. This approach is particularly effective when AI can rapidly regenerate complex implementations."