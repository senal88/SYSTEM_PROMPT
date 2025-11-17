#!/bin/bash
#################################################################################
# Zsh Configuration for macOS Silicon
# Versão: 1.0.0
# Objetivo: Configuração padronizada do Zsh para macOS
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
export OP_BIOMETRIC_UNLOCK="true"
export OP_SESSION_my=""
export SSH_AUTH_SOCK=~/.1password/agent.sock

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
# Load from 1Password if available
if command -v op &> /dev/null && op whoami &>/dev/null; then
    export HOSTINGER_API_TOKEN=$(op read "op://1p_macos/API-VPS-HOSTINGER/credential" 2>/dev/null || \
                                  op read "op://Personal/API-VPS-HOSTINGER/credential" 2>/dev/null || \
                                  echo "")
fi

# Fallback to local credential if 1Password fails
if [ -z "$HOSTINGER_API_TOKEN" ] && [ -f "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt" ]; then
    export HOSTINGER_API_TOKEN=$(cat "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt")
fi

# ==========================================
# GEMINI CONFIGURATION
# ==========================================
export GEMINI_CONFIG_DIR="${DOTFILES_DIR}/gemini"
export PATH="${GEMINI_CONFIG_DIR}/.gemini/bin:${PATH}"

# Load Gemini API Key from 1Password
if command -v op &> /dev/null && op whoami &>/dev/null; then
    export GOOGLE_API_KEY=$(op read "op://1p_macos/Gemini-API-Keys/google_api_key" 2>/dev/null || \
                            op read "op://Personal/Gemini-API-Keys/google_api_key" 2>/dev/null || \
                            echo "")
    export GEMINI_API_KEY="${GOOGLE_API_KEY}"
fi

# ==========================================
# GITHUB CONFIGURATION
# ==========================================
if command -v op &> /dev/null && op whoami &>/dev/null; then
    export GITHUB_TOKEN=$(op read "op://1p_macos/GitHub-Token/token" 2>/dev/null || \
                          op read "op://Personal/GitHub-Token/token" 2>/dev/null || \
                          echo "")
fi

# ==========================================
# HUGGINGFACE CONFIGURATION
# ==========================================
export HF_HOME="${HOME}/.cache/huggingface"
if command -v op &> /dev/null && op whoami &>/dev/null; then
    export HF_TOKEN=$(op read "op://1p_macos/HuggingFace-Token/token" 2>/dev/null || \
                      op read "op://Personal/HuggingFace-Token/token" 2>/dev/null || \
                      echo "")
fi

# ==========================================
# ALIASES
# ==========================================
alias dotfiles="cd ${DOTFILES_DIR}"
alias sync-creds="${DOTFILES_DIR}/scripts/sync/sync-1password-to-dotfiles.sh"
alias update-context="${DOTFILES_DIR}/scripts/context/update-global-context.sh"
alias vps="ssh vps"
alias admin-vps="ssh admin-vps"

# ==========================================
# FUNCTIONS
# ==========================================

# Sync credentials from 1Password
sync_credentials() {
    "${DOTFILES_DIR}/scripts/sync/sync-1password-to-dotfiles.sh"
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

# ==========================================
# OH-MY-ZSH CONFIGURATION (if installed)
# ==========================================
if [ -d "${HOME}/.oh-my-zsh" ]; then
    export ZSH="${HOME}/.oh-my-zsh"
    export ZSH_THEME="robbyrussell"
    plugins=(git docker kubectl terraform)
    source "${ZSH}/oh-my-zsh.sh"
fi

# ==========================================
# COMPLETION
# ==========================================
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

if command -v terraform &> /dev/null; then
    complete -o nospace -C terraform terraform
fi

# ==========================================
# PROMPT
# ==========================================
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f %F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f $ '

# ==========================================
# HISTORY
# ==========================================
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ==========================================
# EXPORTS
# ==========================================
export EDITOR="cursor"
export VISUAL="cursor"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ==========================================
# MESSAGE
# ==========================================
if [ -t 1 ]; then
    echo "✅ Zsh configurado com Dotfiles (${DOTFILES_DIR})"
fi
