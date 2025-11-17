# ~/.bashrc - VPS Ubuntu Configuration
# Versão: 2.0.1
# Última Atualização: 2025-01-17

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Dotfiles configuration
export DOTFILES_DIR="${HOME}/Dotfiles"
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"

# Hostinger API
export HOSTINGER_API_KEY="${HOSTINGER_API_KEY:-$(op read "op://1p_vps/API-VPS-HOSTINGER/credential" 2>/dev/null || echo "jkBoNklZ2vnWHquuZRjbR09CxmqPfXNOqabkEnJvc06e0665")}"
export HOSTINGER_API_BASE_URL="https://developers.hostinger.com"

# Paths
export PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"
export PATH="${DOTFILES_DIR}/scripts:${PATH}"

# Context paths
export CONTEXT_GLOBAL="${DOTFILES_DIR}/context/global/CONTEXTO_GLOBAL_COMPLETO.md"
export CONTEXT_HOSTINGER="${DOTFILES_DIR}/context/global/HOSTINGER_API.md"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Docker aliases
alias docker-ps='docker ps'
alias docker-logs='docker logs'
alias docker-restart='docker restart'
alias docker-compose='docker compose'
alias dc='docker compose'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# System aliases
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'

# Hostinger API aliases
alias hapi-vps='hapi vps vm'
alias hapi-domains='hapi domains'
alias hapi-dns='hapi dns'

# Functions
function hostinger-api() {
    local endpoint="$1"
    shift
    curl -H "Authorization: Bearer ${HOSTINGER_API_KEY}" \
         -H "Content-Type: application/json" \
         "${HOSTINGER_API_BASE_URL}${endpoint}" "$@"
}

function vps-list() {
    hostinger-api "/api/vps/v1/virtual-machines" | jq .
}

function vps-info() {
    local vm_id="$1"
    hostinger-api "/api/vps/v1/virtual-machines/${vm_id}" | jq .
}

# 1Password functions
function op-read() {
    op read "$1" 2>/dev/null || echo ""
}

function hostinger-key() {
    op-read "op://1p_vps/API-VPS-HOSTINGER/credential" || \
    op-read "op://1p_macos/API-VPS-HOSTINGER/credential" || \
    echo "jkBoNklZ2vnWHquuZRjbR09CxmqPfXNOqabkEnJvc06e0665"
}

# Update HOSTINGER_API_KEY if available
export HOSTINGER_API_KEY=$(hostinger-key)

# Welcome message
if [ -n "$PS1" ]; then
    echo ""
    echo "🌐 VPS Ubuntu - senamfo.com.br"
    echo "📁 Dotfiles: ${DOTFILES_DIR}"
    echo "🔑 Hostinger API: ${HOSTINGER_API_KEY:0:10}..."
    echo ""
fi

