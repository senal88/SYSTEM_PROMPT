#!/bin/bash
#################################################################################
# Bash Configuration for Ubuntu VPS
# Versão: 1.0.0
# Objetivo: Configuração padronizada do Bash para Ubuntu VPS
# Base: ~/Dotfiles
#################################################################################

# ==========================================
# DOTFILES BASE PATH
# ==========================================
export DOTFILES_DIR="${HOME}/Dotfiles"
export PATH="${DOTFILES_DIR}/scripts:${PATH}"

# ==========================================
# 1PASSWORD CONFIGURATION
# ==========================================
# Note: 1Password CLI may not be available on VPS
# Use local credential files instead
export SSH_AUTH_SOCK="${HOME}/.ssh/agent.sock"

# ==========================================
# GCP CONFIGURATION
# ==========================================
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"
export GOOGLE_CLOUD_PROJECT="${GCP_PROJECT_ID}"

# ==========================================
# HOSTINGER API CONFIGURATION
# ==========================================
# Load from local credential file
if [ -f "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt" ]; then
    export HOSTINGER_API_TOKEN=$(cat "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt")
fi

# ==========================================
# GEMINI CONFIGURATION
# ==========================================
export GEMINI_CONFIG_DIR="${DOTFILES_DIR}/gemini"
export PATH="${GEMINI_CONFIG_DIR}/.gemini/bin:${PATH}"

# Load Gemini API Key from local file
if [ -f "${DOTFILES_DIR}/credentials/api-keys/google-api-key.txt" ]; then
    export GOOGLE_API_KEY=$(cat "${DOTFILES_DIR}/credentials/api-keys/google-api-key.txt")
    export GEMINI_API_KEY="${GOOGLE_API_KEY}"
fi

# ==========================================
# GITHUB CONFIGURATION
# ==========================================
if [ -f "${DOTFILES_DIR}/credentials/api-keys/github-token.txt" ]; then
    export GITHUB_TOKEN=$(cat "${DOTFILES_DIR}/credentials/api-keys/github-token.txt")
fi

# ==========================================
# HUGGINGFACE CONFIGURATION
# ==========================================
export HF_HOME="${HOME}/.cache/huggingface"
if [ -f "${DOTFILES_DIR}/credentials/api-keys/huggingface-token.txt" ]; then
    export HF_TOKEN=$(cat "${DOTFILES_DIR}/credentials/api-keys/huggingface-token.txt")
fi

# ==========================================
# ALIASES
# ==========================================
alias dotfiles="cd ${DOTFILES_DIR}"
alias sync-creds="${DOTFILES_DIR}/scripts/sync/sync-1password-to-dotfiles.sh"
alias update-context="${DOTFILES_DIR}/scripts/context/update-global-context.sh"
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

# Docker aliases
alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias dexec="docker exec -it"

# System aliases
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# ==========================================
# FUNCTIONS
# ==========================================

# Sync credentials (if 1Password CLI available)
sync_credentials() {
    if command -v op &> /dev/null && op whoami &>/dev/null; then
        "${DOTFILES_DIR}/scripts/sync/sync-1password-to-dotfiles.sh"
    else
        echo "⚠️  1Password CLI não disponível. Use arquivos locais em ${DOTFILES_DIR}/credentials/"
    fi
}

# Update global context
update_context() {
    "${DOTFILES_DIR}/scripts/context/update-global-context.sh"
}

# Test Hostinger API
test_hostinger_api() {
    if [ -z "$HOSTINGER_API_TOKEN" ]; then
        echo "❌ HOSTINGER_API_TOKEN não configurado"
        return 1
    fi
    curl -X GET "https://developers.hostinger.com/api/vps/v1/virtual-machines" \
        -H "Authorization: Bearer ${HOSTINGER_API_TOKEN}" \
        -H "Content-Type: application/json"
}

# Docker Compose helper
dc-up() {
    docker compose up -d "$@"
}

dc-down() {
    docker compose down "$@"
}

dc-logs() {
    docker compose logs -f "$@"
}

dc-restart() {
    docker compose restart "$@"
}

# ==========================================
# PROMPT
# ==========================================
# Color prompt
if [ "$TERM" != "dumb" ]; then
    export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# ==========================================
# HISTORY
# ==========================================
export HISTFILE="${HOME}/.bash_history"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:cd:cd ..:exit"
shopt -s histappend
shopt -s checkwinsize

# ==========================================
# COMPLETION
# ==========================================
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Docker completion
if command -v docker &> /dev/null; then
    if [ -f /usr/share/bash-completion/completions/docker ]; then
        . /usr/share/bash-completion/completions/docker
    fi
fi

# Docker Compose completion
if command -v docker-compose &> /dev/null; then
    if [ -f /usr/share/bash-completion/completions/docker-compose ]; then
        . /usr/share/bash-completion/completions/docker-compose
    fi
fi

# ==========================================
# EXPORTS
# ==========================================
export EDITOR="nano"
export VISUAL="nano"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive

# ==========================================
# MESSAGE
# ==========================================
if [ -t 1 ]; then
    echo "✅ Bash configurado com Dotfiles (${DOTFILES_DIR})"
fi
