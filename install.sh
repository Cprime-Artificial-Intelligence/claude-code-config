#!/bin/bash

# Claude Code Configuration Installer
# Installs ADR-driven dev config directly to ~/.claude/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CLAUDE_DIR="$HOME/.claude"
REPO_URL="https://github.com/aaronsb/claude-code-config"
TMP_DIR="/tmp/claude-code-config-install-$$"

echo -e "${BLUE}🤖 Claude Code Configuration Installer${NC}"
echo -e "${BLUE}======================================${NC}"
echo

# Warn about installation location
echo -e "${YELLOW}⚠️  This will install to: ${CLAUDE_DIR}${NC}"
echo -e "${YELLOW}    Including hooks, agents, and methodology files${NC}"
echo

# Check if ~/.claude exists and has content
if [[ -d "$CLAUDE_DIR" ]] && [[ -n "$(ls -A "$CLAUDE_DIR" 2>/dev/null)" ]]; then
    echo -e "${YELLOW}📁 Existing ~/.claude/ directory found${NC}"

    # Check if it's already our repo
    if [[ -d "$CLAUDE_DIR/.git" ]]; then
        cd "$CLAUDE_DIR"
        current_remote=$(git remote get-url origin 2>/dev/null || echo "")
        if [[ "$current_remote" == "$REPO_URL" ]]; then
            echo -e "${BLUE}📦 Updating existing installation...${NC}"
            git pull origin main
            echo -e "${GREEN}✅ Configuration updated successfully!${NC}"
            exit 0
        fi
    fi

    # Backup existing directory
    backup_dir="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}Creating backup: $backup_dir${NC}"
    read -p "Continue with backup? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation cancelled${NC}"
        exit 1
    fi

    mv "$CLAUDE_DIR" "$backup_dir"
    echo -e "${GREEN}✅ Backup created${NC}"
fi

# Clone to temporary directory
echo -e "${BLUE}📦 Downloading configuration...${NC}"
git clone "$REPO_URL" "$TMP_DIR"

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Copy everything including .git to ~/.claude/
echo -e "${BLUE}📋 Installing files to ~/.claude/${NC}"
cp -R "$TMP_DIR"/.git "$CLAUDE_DIR/"
cp -R "$TMP_DIR"/* "$CLAUDE_DIR/"
cp "$TMP_DIR"/.gitignore "$CLAUDE_DIR/" 2>/dev/null || true

# Set correct permissions on hooks
if [[ -d "$CLAUDE_DIR/hooks" ]]; then
    chmod +x "$CLAUDE_DIR/hooks"/*.sh 2>/dev/null || true
fi

# Set correct permissions on scripts
if [[ -d "$CLAUDE_DIR/scripts" ]]; then
    chmod +x "$CLAUDE_DIR/scripts"/*.sh 2>/dev/null || true
fi

if [[ -f "$CLAUDE_DIR/statusline.sh" ]]; then
    chmod +x "$CLAUDE_DIR/statusline.sh"
fi

# Clean up temp directory
rm -rf "$TMP_DIR"

# Success message
echo
echo -e "${GREEN}🎉 Claude Code configuration installed successfully!${NC}"
echo
echo -e "${BLUE}📋 What's included:${NC}"
echo -e "  • ADR-driven development methodology"
echo -e "  • 6 specialized subagents (code-reviewer, requirements-analyst, etc.)"
echo -e "  • Hook-based instruction injection (SessionStart, PreCompact)"
echo -e "  • GitHub-first command patterns"
echo -e "  • Status line with git branch info"
echo
echo -e "${BLUE}🚀 Next steps:${NC}"
echo -e "  1. Restart Claude Code to load the new configuration"
echo -e "  2. Try: /agents to see your specialized team"
echo -e "  3. Say 'we have an issue about X' and watch it check GitHub first!"
echo
echo -e "${YELLOW}💡 To update later: cd ~/.claude && git pull${NC}"
echo
