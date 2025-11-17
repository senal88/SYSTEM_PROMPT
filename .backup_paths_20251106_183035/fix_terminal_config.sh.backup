#!/bin/bash
set -euo pipefail

# fix_terminal_config.sh
# Corrige automaticamente erros comuns de configuração de terminal
# Compatível: macOS Silicon e Ubuntu VPS

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${HOME}/.dotfiles_backup_${TIMESTAMP}"
LOG_FILE="${HOME}/terminal_fix_${TIMESTAMP}.log"

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
  echo -e "${BLUE}[FIX]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
  echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
  echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Detectar SO
detect_os() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  elif [[ "$(uname)" == "Linux" ]]; then
    echo "ubuntu"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)

# Backup de arquivos
backup_files() {
  log "Criando backup em ${BACKUP_DIR}..."
  mkdir -p "$BACKUP_DIR"
  
  [[ -f ~/.zshrc ]] && cp ~/.zshrc "${BACKUP_DIR}/.zshrc.backup" && log_success "Backup .zshrc"
  [[ -f ~/.bashrc ]] && cp ~/.bashrc "${BACKUP_DIR}/.bashrc.backup" && log_success "Backup .bashrc"
  [[ -f ~/.bash_profile ]] && cp ~/.bash_profile "${BACKUP_DIR}/.bash_profile.backup" && log_success "Backup .bash_profile"
  [[ -f ~/.profile ]] && cp ~/.profile "${BACKUP_DIR}/.profile.backup" && log_success "Backup .profile"
}

# Verificar shell padrão
check_default_shell() {
  log "Verificando shell padrão..."
  
  CURRENT_SHELL=$(echo $SHELL)
  EXPECTED_SHELL="/bin/zsh"
  
  if [[ "$CURRENT_SHELL" != "$EXPECTED_SHELL" ]]; then
    log_warning "Shell atual: ${CURRENT_SHELL}, esperado: ${EXPECTED_SHELL}"
    
    if [[ "$OS" == "macos" ]]; then
      log "Alterando shell padrão para zsh..."
      if chsh -s /bin/zsh 2>/dev/null; then
        log_success "Shell alterado para zsh (requer logout/login)"
      else
        log_error "Não foi possível alterar shell (pode precisar de sudo)"
      fi
    fi
  else
    log_success "Shell padrão correto: ${CURRENT_SHELL}"
  fi
}

# Corrigir .zshrc
fix_zshrc() {
  log "Verificando .zshrc..."
  
  if [[ ! -f ~/.zshrc ]]; then
    log "Criando .zshrc básico..."
    cat > ~/.zshrc << 'EOF'
# .zshrc - Configuração Zsh
# Last Updated: 2025-10-31

# Histórico
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Completions
autoload -Uz compinit
compinit

# PATH básico
export PATH="$HOME/bin:$PATH"

# Se direnv estiver instalado
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Aliases úteis
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
EOF
    log_success ".zshrc criado"
    return 0
  fi
  
  # Verificar sintaxe
  if zsh -n ~/.zshrc 2>&1 | grep -q "error"; then
    log_error "Erro de sintaxe em .zshrc detectado"
    log "Erros encontrados:"
    zsh -n ~/.zshrc 2>&1 | tee -a "$LOG_FILE"
    return 1
  else
    log_success ".zshrc sem erros de sintaxe"
  fi
  
  # Verificar se PATH básico existe
  if ! grep -q "export PATH" ~/.zshrc; then
    log "Adicionando PATH básico ao .zshrc..."
    echo "" >> ~/.zshrc
    echo "# PATH básico" >> ~/.zshrc
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    log_success "PATH básico adicionado"
  fi
  
  return 0
}

# Corrigir PATH
fix_path() {
  log "Verificando PATH..."
  
  # Verificar diretórios essenciais
  ESSENTIAL_PATHS=(
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "$HOME/bin"
  )
  
  MISSING_PATHS=()
  for path in "${ESSENTIAL_PATHS[@]}"; do
    if [[ ":$PATH:" != *":$path:"* ]]; then
      MISSING_PATHS+=("$path")
    fi
  done
  
  if [[ ${#MISSING_PATHS[@]} -gt 0 ]]; then
    log_warning "Paths faltando no PATH: ${MISSING_PATHS[*]}"
    
    if [[ -f ~/.zshrc ]]; then
      log "Adicionando paths faltantes ao .zshrc..."
      for path in "${MISSING_PATHS[@]}"; do
        if [[ -d "$path" ]]; then
          echo "export PATH=\"$path:\$PATH\"" >> ~/.zshrc
          log_success "Adicionado: $path"
        fi
      done
    fi
  else
    log_success "PATH contém diretórios essenciais"
  fi
}

# Corrigir permissões
fix_permissions() {
  log "Verificando permissões..."
  
  [[ -f ~/.zshrc ]] && chmod 644 ~/.zshrc && log_success "Permissões .zshrc corrigidas"
  [[ -f ~/.bashrc ]] && chmod 644 ~/.bashrc && log_success "Permissões .bashrc corrigidas"
  [[ -f ~/.profile ]] && chmod 644 ~/.profile && log_success "Permissões .profile corrigidas"
  
  # Verificar diretório bin
  if [[ ! -d ~/bin ]]; then
    mkdir -p ~/bin
    chmod 755 ~/bin
    log_success "Diretório ~/bin criado"
  fi
}

# Verificar comandos essenciais
check_essential_commands() {
  log "Verificando comandos essenciais..."
  
  ESSENTIAL_COMMANDS=("ls" "cat" "echo" "cd" "pwd" "mkdir" "rm" "cp" "mv")
  MISSING=()
  
  for cmd in "${ESSENTIAL_COMMANDS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
      MISSING+=("$cmd")
    fi
  done
  
  if [[ ${#MISSING[@]} -gt 0 ]]; then
    log_error "Comandos faltando: ${MISSING[*]}"
    return 1
  else
    log_success "Todos os comandos essenciais disponíveis"
    return 0
  fi
}

# Adicionar automação 1password ao PATH (se existir)
add_automation_path() {
  AUTOMATION_DIR="${HOME}/Dotfiles/automation_1password"
  
  if [[ -d "$AUTOMATION_DIR" ]]; then
    log "Verificando automação 1password..."
    
    SCRIPTS_DIR="${AUTOMATION_DIR}/scripts"
    if [[ -d "$SCRIPTS_DIR" ]]; then
      if ! grep -q "automation_1password" ~/.zshrc 2>/dev/null; then
        log "Adicionando automação 1password ao PATH..."
        cat >> ~/.zshrc << EOF

# automation_1password scripts
export PATH="\${HOME}/Dotfiles/automation_1password/scripts:\$PATH"
EOF
        log_success "Automação 1password adicionada ao PATH"
      fi
    fi
  fi
}

# Testar configuração
test_config() {
  log "Testando configuração..."
  
  # Tentar carregar .zshrc em subprocesso
  if zsh -c "source ~/.zshrc && echo 'Configuração OK'" 2>&1 | grep -q "OK"; then
    log_success "Configuração testada com sucesso"
    return 0
  else
    log_error "Erro ao testar configuração"
    zsh -c "source ~/.zshrc" 2>&1 | tee -a "$LOG_FILE"
    return 1
  fi
}

# Main
main() {
  echo "=========================================="
  echo "Correção Automática de Terminal"
  echo "Sistema: $OS"
  echo "Timestamp: $TIMESTAMP"
  echo "=========================================="
  echo ""
  
  backup_files
  echo ""
  
  check_default_shell
  echo ""
  
  fix_zshrc
  echo ""
  
  fix_path
  echo ""
  
  fix_permissions
  echo ""
  
  check_essential_commands
  echo ""
  
  add_automation_path
  echo ""
  
  test_config
  echo ""
  
  echo "=========================================="
  echo "Correção concluída!"
  echo "Log: $LOG_FILE"
  echo "Backup: $BACKUP_DIR"
  echo "=========================================="
  echo ""
  echo "Próximos passos:"
  echo "1. Recarregue o terminal: exec zsh"
  echo "2. Ou faça logout/login"
  echo "3. Verifique logs em: $LOG_FILE"
}

main

