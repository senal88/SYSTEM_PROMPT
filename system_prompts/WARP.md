# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is the **SYSTEM_PROMPT** repository - a centralized system for managing AI prompts, automation scripts, secure credential handling, and development environment configuration across multiple platforms (macOS, Linux/VPS, DevContainers).

**Purpose**: Governance of prompts, automation of development workflows, and secure credential management using 1Password CLI.

**Base Directory**: `~/Dotfiles/system_prompts/`

## Architecture

### Core Structure

```
system_prompts/
├── global/                    # Global system prompts and shared resources
│   ├── prompts/              # Organized prompts (system/, audit/, revision/)
│   ├── docs/                 # Setup guides and documentation
│   ├── scripts/              # Automation scripts (70+ scripts)
│   ├── governance/           # Governance rules and validation
│   ├── audit/                # Historical audit reports
│   ├── consolidated/         # Generated consolidated files
│   └── templates/            # Reusable templates
│
├── scripts/                  # Host-level utility scripts
│   ├── load_ai_keys.sh      # Load API keys from 1Password
│   ├── auto_config_shells_macos.sh  # Configure shells on macOS
│   └── update_n8n_vps.sh    # Update n8n on VPS
│
├── antigravity/             # Experimental automation module
├── segundo-cerebro-ia/      # Second Brain AI project (Obsidian + Claude MCP)
├── terminal/                # Terminal configurations
│
└── .cursorrules             # Cursor IDE system prompt
```

### Key Concepts

1. **Global First**: All system prompts belong in `global/` directory, never in local project folders
2. **1Password Integration**: All secrets managed via 1Password CLI (never hardcoded)
3. **Multi-Platform**: Scripts support macOS (host), Ubuntu VPS, and DevContainers
4. **Versioned**: All scripts and docs follow semver with dates (e.g., `_v1.0.0_20251201.sh`)

## Common Commands

### Daily Workflow

```bash
# Authenticate with 1Password (required first)
eval $(op signin)

# Load all AI API keys into environment
source ~/Dotfiles/scripts/load_ai_keys.sh

# Navigate to repository
cd ~/Dotfiles/system_prompts
```

### Working with Scripts

```bash
# Make script executable
chmod +x scripts/script_name.sh

# Run a script from global
cd ~/Dotfiles/system_prompts/global/scripts
./script_name_vX.X.X_YYYYMMDD.sh

# Common patterns
./auditar-1password-secrets_v1.0.0_20251130.sh  # Audit secrets
./consolidar-llms-full_v1.0.0_20251130.sh       # Generate LLM prompt
```

### VPS Operations

```bash
# Update n8n with MCP support
cd ~/Dotfiles/system_prompts
bash scripts/update_n8n_vps.sh

# Deploy to VPS
cd global/scripts
./deploy-completo-vps_v1.0.0_20251130.sh

# SSH to VPS (assumes SSH config exists)
ssh vps
```

### Docker Operations

```bash
# Check running DevContainers
docker ps --filter "label=devcontainer"

# View n8n logs on VPS
ssh vps
docker logs -f n8n

# Restart a service
docker-compose -f docker-compose.n8n.yml restart
```

### Audit and Validation

```bash
cd ~/Dotfiles/system_prompts/global/scripts

# Full audit pipeline
./master-auditoria-completa.sh    # Collect data
./analise-e-sintese.sh            # Analyze
./consolidar-llms-full.sh         # Generate consolidated output

# Specific audits
./auditar-1password-secrets_v1.0.0_20251130.sh
./auditar-docker_v1.0.0_20251130.sh
./verificar_secrets_restantes.sh
```

### Git Operations

```bash
# Standard workflow
git status
git diff
git add -A
git commit -m "feat: description"  # Use conventional commits
git push origin main

# For large files, use Git LFS if needed
git lfs track "*.zip"
```

## Key Files and Their Purpose

### Configuration Files

- **`.cursorrules`**: System prompt for Cursor IDE with security guidelines
- **`docker-compose.n8n.yml`**: n8n automation platform configuration (v1.122.4 with MCP)
- **`docker-compose.coolify.yaml`**: Coolify deployment configuration

### Critical Scripts

#### In `~/Dotfiles/scripts/`
- **`load_ai_keys.sh`**: Loads API keys from 1Password (Anthropic, OpenAI, Gemini, Perplexity, GitHub)
- **`auto_config_shells_macos.sh`**: Configures Terminal.app, iTerm2, Warp to use zsh
- **`update_n8n_vps.sh`**: Updates n8n on VPS with backup and rollback capability

#### In `global/scripts/`
- **`auditar-1password-secrets_v1.0.0_20251130.sh`**: Complete secrets audit
- **`consolidar-llms-full_v1.0.0_20251130.sh`**: Generates `llms-full.txt` for LLM import
- **`master-auditoria-completa.sh`**: Master audit script (collects system data)

### Documentation

- **`global/docs/CLAUDE_SETUP_v1.0.0_20251130.md`**: Complete Claude Desktop + MCP setup
- **`global/docs/N8N_SETUP_MCP_v1.0.0_20251202.md`**: n8n with MCP capabilities guide
- **`global/docs/GEMINI_SETUP_v1.0.0_20251130.md`**: Google Gemini API setup
- **`global/README.md`**: Complete global system documentation

## Security Model

### Never Do This ❌

```bash
# Never hardcode credentials
ANTHROPIC_API_KEY="sk-ant-..."  # ❌ WRONG

# Never expose secrets in logs
echo $ANTHROPIC_API_KEY  # ❌ WRONG

# Never commit .env files with real values
git add .env  # ❌ WRONG
```

### Always Do This ✅

```bash
# Use 1Password references in documentation
ANTHROPIC_API_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential")

# Validate before using
if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo "❌ ANTHROPIC_API_KEY not set"
  exit 1
fi

# Use the load script
source ~/Dotfiles/scripts/load_ai_keys.sh
```

### 1Password CLI Patterns

```bash
# Read a credential
op read "op://Vault/Item Name/field"

# Check authentication
op account list

# Sign in if needed
eval $(op signin)

# List items in vault
op item list --vault Development
```

## Shell Environment

### macOS (Host)
- **Shell**: `zsh` (default login shell)
- **RC File**: `~/.zshrc`
- **Package Manager**: Homebrew (`/opt/homebrew` on Apple Silicon)

### Linux VPS (Ubuntu)
- **Shell**: `bash`
- **RC File**: `~/.bashrc`
- **Package Manager**: `apt`

### DevContainers
- **Shell**: `bash` (for compatibility)
- **User**: `vscode` or `root` (depends on base image)
- **Secrets**: Injected via environment or mounted `.config/op`

## Testing

This repository uses shell script testing patterns:

```bash
# Test mode (dry-run)
./script_name.sh --dry-run

# Backup only (no changes)
./script_name.sh --backup-only

# Validate without executing
bash -n script_name.sh  # Syntax check
shellcheck script_name.sh  # Static analysis (if available)
```

## Naming Conventions

### Scripts
- Format: `name_vMAJOR.MINOR.PATCH_YYYYMMDD.sh`
- Example: `auditar-1password-secrets_v1.0.0_20251130.sh`

### Documentation
- Format: `[TOOL]_SETUP_v[VERSION]_[DATE].md`
- Example: `CLAUDE_SETUP_v1.0.0_20251130.md`

### Prompts
- Format: `PROMPT_[ACTION]_[CONTEXT].md`
- Example: `PROMPT_REVISAO_MEMORIAS_CONCISO.md`

## Project-Specific Workflows

### Segundo Cérebro IA (Second Brain)

This is an integrated knowledge management system:

```bash
cd ~/Dotfiles/system_prompts/segundo-cerebro-ia

# Components
# - Claude Desktop with MCP servers
# - Obsidian vault with Mind Maps
# - n8n for audio transcription automation
# - 1Password for credentials

# Setup process documented in:
segundo-cerebro-ia/README.md
```

### Antigravity Module

Experimental automation and CI/CD demonstrations:

```bash
cd ~/Dotfiles/system_prompts/antigravity

# Deploy on macOS
./scripts/deploy_antigravity_macos.sh
```

## Common Issues and Solutions

### 1Password Not Authenticated

```bash
# Sign in to 1Password
eval $(op signin)

# Verify
op account list
```

### Script Permission Denied

```bash
# Make executable
chmod +x script_name.sh

# Or run with bash
bash script_name.sh
```

### Shell Not Using Correct Environment

```bash
# Fix macOS shells (Terminal, iTerm2, Warp)
cd ~/Dotfiles/system_prompts/scripts
./auto_config_shells_macos.sh

# Verify current shell
echo $SHELL
ps -p $$
```

### VPS Connection Issues

```bash
# Check SSH config
cat ~/.ssh/config | grep -A 5 "Host vps"

# Test connection
ssh vps "echo 'Connected successfully'"
```

### Docker Container Issues

```bash
# Check container status
docker ps -a

# View logs
docker logs container_name

# Restart container
docker restart container_name
```

## IDE Integration

### Cursor

System prompt is automatically loaded from `.cursorrules` at repository root.

Key features:
- Enforces 1Password usage for secrets
- Provides shell scripting standards
- Documents file structure and conventions

### VS Code

Workspace settings in `.vscode/settings.json` configure:
- Shell preferences (zsh on macOS, bash on Linux)
- Integrated terminal behavior

### DevContainers

Configuration in `.devcontainer/devcontainer.json`:
- Base image selection
- Environment variable injection
- Volume mounts

## Related Resources

- **Main Dotfiles**: `~/Dotfiles/` (parent repository)
- **Global Prompts**: `~/Dotfiles/system_prompts/global/prompts/`
- **Consolidated LLM Prompt**: `~/Dotfiles/system_prompts/global/consolidated/llms-full.txt`
- **1Password Items**: Vault "Development" (primary)

## Maintenance

### Backup Locations

- **Script Backups**: `global/logs/backups/`
- **Audit Reports**: `global/audit/[timestamp]/`
- **Preference Backups**: `logs/backups/prefs_[timestamp]/`

### Version Updates

When updating scripts or docs:
1. Increment version number (semver)
2. Update date in filename
3. Keep old version in place (or move to `legacy/`)
4. Update references in documentation
5. Test thoroughly before committing

### Audit Trail

The system maintains comprehensive audit trails:
- All audits timestamped in `global/audit/`
- Change history in `global/CHANGELOG.md`
- Git commit history for code changes

## Support

For detailed documentation on specific topics:

```bash
# View global README
cat global/README.md | less

# View specific setup guide
cat global/docs/CLAUDE_SETUP_v1.0.0_20251130.md | less

# Check cursorrules for guidelines
cat .cursorrules | less

# List all available scripts
ls -lh global/scripts/*.sh
```

## Quick Reference

```bash
# Load API keys
source ~/Dotfiles/scripts/load_ai_keys.sh

# Run audit
cd ~/Dotfiles/system_prompts/global/scripts && ./master-auditoria-completa.sh

# Update n8n
cd ~/Dotfiles/system_prompts && bash scripts/update_n8n_vps.sh

# Generate LLM prompt
cd ~/Dotfiles/system_prompts/global/scripts && ./consolidar-llms-full.sh

# Check VPS services
ssh vps "docker ps"
```

---

**Repository**: senal88/SYSTEM_PROMPT  
**Branch**: main  
**Last Updated**: 2025-12-02  
**Version**: 2.0.0
