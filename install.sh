#!/bin/bash

# Claude Code Configuration Installer
# Deploys the disciplined software engineering configuration to a clean system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLAUDE_DIR="$HOME/.claude"

# Dynamically determine repository URL
if [[ -d ".git" ]] && command_exists git; then
    # If running from within the repo, use its origin
    REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ -z "$REPO_URL" ]]; then
        echo -e "${RED}❌ Could not determine repository URL${NC}"
        echo -e "${YELLOW}Please run this script from within the claude-code-config repository${NC}"
        exit 1
    fi
else
    # Fallback to environment variable or prompt user
    if [[ -n "$CLAUDE_CONFIG_REPO" ]]; then
        REPO_URL="$CLAUDE_CONFIG_REPO"
    else
        echo -e "${YELLOW}⚠️  No git repository detected. Please provide the repository URL:${NC}"
        echo -e "${BLUE}Example: https://github.com/YOUR_USERNAME/claude-code-config.git${NC}"
        read -p "Repository URL: " REPO_URL
        if [[ -z "$REPO_URL" ]]; then
            echo -e "${RED}❌ Repository URL is required${NC}"
            exit 1
        fi
    fi
fi

echo -e "${BLUE}🤖 Claude Code Configuration Installer${NC}"
echo -e "${BLUE}======================================${NC}"
echo

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
echo -e "${YELLOW}🔍 Checking dependencies...${NC}"

MISSING_DEPS=()

if ! command_exists git; then
    MISSING_DEPS+=("git")
fi

if ! command_exists python3; then
    MISSING_DEPS+=("python3")
fi

if ! command_exists bc; then
    MISSING_DEPS+=("bc")
fi

if ! command_exists node; then
    echo -e "${YELLOW}⚠️  Node.js not found - local tooling may not work${NC}"
fi

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo -e "${RED}❌ Missing required dependencies: ${MISSING_DEPS[*]}${NC}"
    echo -e "${YELLOW}Please install the missing dependencies and run this script again.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All dependencies found${NC}"

# Backup existing configuration
if [[ -d "$CLAUDE_DIR" ]]; then
    echo -e "${YELLOW}⚠️  Existing Claude configuration found${NC}"
    
    # Check if it's already our repo
    if [[ -d "$CLAUDE_DIR/.git" ]]; then
        cd "$CLAUDE_DIR"
        current_remote=$(git remote get-url origin 2>/dev/null || echo "")
        if [[ "$current_remote" == "$REPO_URL" ]]; then
            echo -e "${BLUE}📦 Updating existing configuration...${NC}"
            git pull origin main
            echo -e "${GREEN}✅ Configuration updated successfully!${NC}"
            exit 0
        fi
    fi
    
    backup_dir="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}📁 Backing up to: $backup_dir${NC}"
    mv "$CLAUDE_DIR" "$backup_dir"
    echo -e "${GREEN}✅ Backup created${NC}"
fi

# Clone the configuration
echo -e "${BLUE}📦 Installing Claude Code configuration...${NC}"
git clone "$REPO_URL" "$CLAUDE_DIR"

# Set up local tooling
echo -e "${BLUE}🔧 Setting up local tooling...${NC}"
cd "$CLAUDE_DIR/local"

if command_exists npm; then
    npm install
    echo -e "${GREEN}✅ Node dependencies installed${NC}"
else
    echo -e "${YELLOW}⚠️  npm not found - skipping node dependencies${NC}"
fi

# Set up git hooks
echo -e "${BLUE}🪝 Setting up git hooks...${NC}"
cd "$CLAUDE_DIR"

if [[ -f "hooks/pre-commit" ]]; then
    chmod +x hooks/pre-commit
    ln -sf "$CLAUDE_DIR/hooks/pre-commit" "$CLAUDE_DIR/.git/hooks/pre-commit"
    echo -e "${GREEN}✅ Pre-commit hook installed${NC}"
fi

if [[ -f "hooks/refresh-claude-md.sh" ]]; then
    chmod +x hooks/refresh-claude-md.sh
    echo -e "${GREEN}✅ Refresh hook ready${NC}"
fi

# Set up executable scripts
if [[ -f "local/claude" ]]; then
    chmod +x local/claude
fi

# Verify installation
echo -e "${BLUE}🔍 Verifying installation...${NC}"

VERIFICATION_FAILED=false

# Check essential files
essential_files=(
    "CLAUDE.md"
    "agents/requirements-analyst.md"
    "agents/system-architect.md" 
    "agents/task-planner.md"
    "agents/code-reviewer.md"
    "agents/github-project-manager.md"
    "agents/workflow-orchestrator.md"
)

for file in "${essential_files[@]}"; do
    if [[ ! -f "$CLAUDE_DIR/$file" ]]; then
        echo -e "${RED}❌ Missing: $file${NC}"
        VERIFICATION_FAILED=true
    fi
done

if [[ "$VERIFICATION_FAILED" == "true" ]]; then
    echo -e "${RED}❌ Installation verification failed${NC}"
    exit 1
fi

# Success message
echo
echo -e "${GREEN}🎉 Claude Code configuration installed successfully!${NC}"
echo
echo -e "${BLUE}📋 What's included:${NC}"
echo -e "  • Disciplined software engineering methodology (CLAUDE.md)"
echo -e "  • 6 specialized subagents for team-like development"
echo -e "  • Pre-commit hooks for security (prevents secret commits)"
echo -e "  • Custom slash commands"
echo -e "  • Local tooling and automation"
echo
echo -e "${BLUE}🚀 Next steps:${NC}"
echo -e "  1. Start Claude Code in any project directory"
echo -e "  2. The methodology will auto-detect tracking method"
echo -e "  3. Use /agents to see your specialized team"
echo -e "  4. Follow the Golden Rule: No code without active sub-tasks!"
echo
echo -e "${YELLOW}💡 Pro tip: Run 'git log --oneline' in ~/.claude to see updates${NC}"
echo