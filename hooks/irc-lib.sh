#!/usr/bin/env bash
# Shared IRC helpers — sourced by irc-send.sh, irc-read.sh, irc-check.sh
#
# Nick derivation: hash the absolute path to get a stable short identifier
#   /home/aaron/.claude → claude-a7b3c1
#   /home/aaron/temp    → claude-f2e184
# Deterministic, collision-resistant, fits IRC nick limits (max 16 chars)

# Derive a stable short nick from a directory path
# Uses first 6 chars of sha256 hash for uniqueness
irc_nick_from_dir() {
  local dir
  dir=$(realpath "${1:-$PWD}" 2>/dev/null || echo "${1:-$PWD}")
  local hash
  hash=$(printf '%s' "$dir" | sha256sum | cut -c1-6)
  echo "claude-${hash}"
}

# Convert path to the slug used in /tmp/irc-chat-<slug>/
# Same hash as nick but without the "claude-" prefix
irc_slug_from_dir() {
  local dir
  dir=$(realpath "${1:-$PWD}" 2>/dev/null || echo "${1:-$PWD}")
  printf '%s' "$dir" | sha256sum | cut -c1-6
}

# Find this instance's IRC base directory
# Checks for a base matching our pwd-derived hash first, then falls back to any
irc_find_base() {
  local my_slug
  my_slug=$(irc_slug_from_dir "${1:-$PWD}")

  # Try exact match first
  local exact="/tmp/irc-chat-${my_slug}"
  if [[ -d "$exact/127.0.0.1" ]]; then
    echo "$exact"
    return 0
  fi

  # Fallback: first available connection
  for candidate in /tmp/irc-chat-*/127.0.0.1; do
    if [[ -d "$candidate" ]]; then
      echo "${candidate%/127.0.0.1}"
      return 0
    fi
  done
  return 1
}

# Get the nick from an IRC base directory path
# /tmp/irc-chat-a7b3c1 → claude-a7b3c1
irc_nick_from_base() {
  local base="$1"
  local slug="${base##*/irc-chat-}"
  echo "claude-${slug}"
}
