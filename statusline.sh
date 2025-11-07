#!/bin/bash

# Timeout for all operations (1 second max)
TIMEOUT=1

# Get ccusage info with timeout
CCUSAGE=$(timeout $TIMEOUT bun x ccusage statusline --visual-burn-rate emoji 2>/dev/null || echo "")

# Get current directory (basename only for brevity)
DIR=$(basename "$(pwd)")

# Get git branch if in a git repo
GIT_INFO=""
if timeout $TIMEOUT git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(timeout $TIMEOUT git branch --show-current 2>/dev/null || timeout $TIMEOUT git rev-parse --short HEAD 2>/dev/null)
    # Check for uncommitted changes (skip if timeout)
    if timeout $TIMEOUT git status --porcelain 2>/dev/null | grep -q .; then
        GIT_INFO=" 🔀 $BRANCH*"
    else
        GIT_INFO=" 🔀 $BRANCH"
    fi
fi

# Combine all elements
echo "📁 $DIR$GIT_INFO | $CCUSAGE"
