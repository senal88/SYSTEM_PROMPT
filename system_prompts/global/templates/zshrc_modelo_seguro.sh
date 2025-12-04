#!/usr/bin/env zsh
################################################################################
# ~/.zshrc - Modelo Seguro e Resiliente
# Alinhado com repositório SYSTEM_PROMPT
# Data: 2025-12-02
################################################################################

# =============================================================================
# 1. DETECÇÃO DE AMBIENTE
# =============================================================================
export DOTFILES_DIR="${HOME}/Dotfiles"
export SYSTEM_PROMPTS_DIR="${DOTFILES_DIR}/system_prompts"

# macOS vs Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
  export IS_MACOS=1
  export IS_LINUX=0
else
  export IS_MACOS=0
  export IS_LINUX=1
fi

# =============================================================================
# 2. PATH CONFIGURATION
# =============================================================================
# Homebrew (Apple Silicon)
if [[ $IS_MACOS -eq 1 ]]; then
  if [[ -d "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  fi
fi

# User binaries
export PATH="$HOME/.local/bin:$PATH"

# Dotfiles scripts
if [[ -d "$DOTFILES_DIR/scripts" ]]; then
  export PATH="$DOTFILES_DIR/scripts:$PATH"
fi

# =============================================================================
# 3. ZSH CONFIGURATION
# =============================================================================
# History
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Completion
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# =============================================================================
# 4. ALIASES
# =============================================================================
# Core utils
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Segurança - evitar sobrescritas acidentais
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Dotfiles
alias dotfiles='cd $DOTFILES_DIR'
alias prompts='cd $SYSTEM_PROMPTS_DIR'

# =============================================================================
# 5. CARREGAR API KEYS (1Password) - SEGURO
# =============================================================================
# Este bloco é tolerante a erros: se falhar, não mata a shell
if [[ -f "$DOTFILES_DIR/scripts/load_ai_keys.sh" ]]; then
  # Método 1: Source direto (recomendado - script já é seguro)
  source "$DOTFILES_DIR/scripts/load_ai_keys.sh" 2>/dev/null || {
    echo "⚠️  Não foi possível carregar chaves de IA (continuando...)"
  }

  # Método 2 (alternativo): Carregar apenas se 1Password estiver autenticado
  # if command -v op >/dev/null 2>&1 && op account list >/dev/null 2>&1; then
  #   source "$DOTFILES_DIR/scripts/load_ai_keys.sh"
  # fi
fi

# =============================================================================
# 6. PROMPT CUSTOMIZADO (Simples)
# =============================================================================
# Formato: [user@host dir]$
PROMPT='%F{cyan}[%n@%m %1~]%f$ '

# Ou usar um prompt mais elaborado (oh-my-zsh, powerlevel10k, starship)
# Descomentar se usar starship:
# if command -v starship >/dev/null 2>&1; then
#   eval "$(starship init zsh)"
# fi

# =============================================================================
# 7. PLUGINS E FRAMEWORKS (Opcional)
# =============================================================================
# Oh-My-Zsh (descomentar se instalado)
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git docker kubectl)
# source $ZSH/oh-my-zsh.sh

# Zinit (descomentar se instalado)
# if [[ -f "${HOME}/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
#   source "${HOME}/.local/share/zinit/zinit.git/zinit.zsh"
#   zinit light zsh-users/zsh-autosuggestions
#   zinit light zsh-users/zsh-syntax-highlighting
# fi

# =============================================================================
# 8. FERRAMENTAS DE DESENVOLVIMENTO
# =============================================================================
# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# Python (pyenv)
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# Ruby (rbenv)
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# =============================================================================
# 9. DOCKER & KUBERNETES
# =============================================================================
# Docker completion (macOS)
if [[ $IS_MACOS -eq 1 ]] && [[ -f /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion ]]; then
  fpath=(/Applications/Docker.app/Contents/Resources/etc $fpath)
fi

# Kubectl completion
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
  alias k='kubectl'
  complete -F __start_kubectl k
fi

# =============================================================================
# 10. FUNÇÕES AUXILIARES
# =============================================================================
# Criar diretório e entrar
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Buscar processos
psgrep() {
  ps aux | grep -v grep | grep -i -e VSZ -e "$@"
}

# Extrair arquivos diversos
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' não pode ser extraído via extract()" ;;
    esac
  else
    echo "'$1' não é um arquivo válido"
  fi
}

# Recarregar .zshrc
reload() {
  source ~/.zshrc
  echo "✅ ~/.zshrc recarregado"
}

# =============================================================================
# 11. VARIÁVEIS DE AMBIENTE PERSONALIZADAS
# =============================================================================
# Editor padrão
export EDITOR='vim'
export VISUAL='vim'

# Linguagem e locale
export LANG='pt_BR.UTF-8'
export LC_ALL='pt_BR.UTF-8'

# Menos colorido
export LESS='-R'
export LESSCHARSET='utf-8'

# GPG (se usar)
export GPG_TTY=$(tty)

# =============================================================================
# 12. CUSTOMIZAÇÕES LOCAIS (não versionadas)
# =============================================================================
# Carregar configurações específicas da máquina (se existir)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# =============================================================================
# FIM
# =============================================================================
# Mensagem de boas-vindas (opcional - comentar se preferir silencioso)
# echo "✅ Shell carregado com sucesso | $(date +'%Y-%m-%d %H:%M:%S')"
