#!/bin/bash

# Get ccusage info
CCUSAGE=$(bun x ccusage statusline 2>/dev/null || echo "")

# Get current directory (basename only for brevity)
DIR=$(basename "$(pwd)")

# Get git branch if in a git repo
GIT_INFO=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        GIT_INFO=" 🔀 $BRANCH*"
    else
        GIT_INFO=" 🔀 $BRANCH"
    fi
fi

# Combine all elements
echo "📁 $DIR$GIT_INFO | $CCUSAGE"