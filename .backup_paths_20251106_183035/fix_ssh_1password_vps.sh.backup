#!/bin/bash
set -euo pipefail

# fix_ssh_1password_vps.sh
# Corrige configuração SSH no VPS Ubuntu removendo UseKeychain (macOS-only)
# e configura o agente 1Password SSH corretamente para Linux

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/logs/fix_ssh_1password_${TIMESTAMP}.log"
SSH_CONFIG="${HOME}/.ssh/config"
SSH_CONFIG_BACKUP="${HOME}/.ssh/config.backup.${TIMESTAMP}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
  echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
  echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] ✅ $1${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
  echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] ⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
  echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ❌ $1${NC}" | tee -a "$LOG_FILE"
}

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "${HOME}/.ssh"
mkdir -p "${HOME}/.1password"

log "🔧 Correção de Configuração SSH e 1Password Agent (VPS Ubuntu)"
log "══════════════════════════════════════════════════════════════"
echo ""

# Detectar sistema operacional
if [[ "$(uname)" != "Linux" ]]; then
  log_warning "Este script é específico para Linux. Detectado: $(uname)"
  log_warning "Continuando mesmo assim..."
fi

# Backup do SSH config
if [[ -f "$SSH_CONFIG" ]]; then
  log "Criando backup de ${SSH_CONFIG}..."
  cp "$SSH_CONFIG" "$SSH_CONFIG_BACKUP"
  log_success "Backup criado: ${SSH_CONFIG_BACKUP}"
else
  log "Criando novo arquivo ${SSH_CONFIG}..."
  touch "$SSH_CONFIG"
  chmod 600 "$SSH_CONFIG"
fi

# Remover UseKeychain (macOS-only) do SSH config
log "Removendo opções específicas do macOS do SSH config..."
if grep -q "UseKeychain" "$SSH_CONFIG" 2>/dev/null; then
  log_warning "Encontradas ocorrências de 'UseKeychain' (específico do macOS)"
  
  # Criar versão corrigida
  TEMP_CONFIG=$(mktemp)
  grep -v "UseKeychain" "$SSH_CONFIG" > "$TEMP_CONFIG" || true
  mv "$TEMP_CONFIG" "$SSH_CONFIG"
  
  log_success "Opções 'UseKeychain' removidas"
else
  log_success "Nenhuma opção 'UseKeychain' encontrada"
fi

# Detectar socket do 1Password SSH agent
log "Detectando socket do 1Password SSH agent..."

# Possíveis locais do socket no Linux
POSSIBLE_SOCKETS=(
  "${HOME}/.1password/agent.sock"
  "${HOME}/.config/1Password/ssh/agent.sock"
  "/tmp/1password-ssh-agent.sock"
  "${XDG_RUNTIME_DIR}/1password-ssh-agent.sock"
)

SSH_AGENT_SOCK=""
for socket in "${POSSIBLE_SOCKETS[@]}"; do
  if [[ -S "$socket" ]] || [[ -f "$socket" ]]; then
    SSH_AGENT_SOCK="$socket"
    log_success "Socket encontrado: ${SSH_AGENT_SOCK}"
    break
  fi
done

# Se não encontrou, tentar detectar via environment
if [[ -z "$SSH_AGENT_SOCK" ]]; then
  if [[ -n "${SSH_AUTH_SOCK:-}" ]] && [[ -S "${SSH_AUTH_SOCK}" ]]; then
    SSH_AGENT_SOCK="${SSH_AUTH_SOCK}"
    log_success "Socket detectado via SSH_AUTH_SOCK: ${SSH_AGENT_SOCK}"
  else
    # Socket padrão para 1Password Linux
    SSH_AGENT_SOCK="${HOME}/.1password/agent.sock"
    log_warning "Socket não encontrado, usando padrão: ${SSH_AGENT_SOCK}"
    log "Você precisará configurar o 1Password SSH agent antes de usar"
  fi
fi

# Criar diretório e symlink se necessário
mkdir -p "$(dirname "$SSH_AGENT_SOCK")"

# Se o socket é um symlink ou não existe, tentar criar
if [[ ! -S "$SSH_AGENT_SOCK" ]]; then
  # Tentar encontrar o socket real do 1Password
  REAL_SOCK=$(find /tmp -name "*1password*agent*.sock" 2>/dev/null | head -1 || true)
  
  if [[ -n "$REAL_SOCK" ]] && [[ -S "$REAL_SOCK" ]]; then
    log "Criando symlink para socket real: ${REAL_SOCK}"
    ln -sf "$REAL_SOCK" "$SSH_AGENT_SOCK" || true
    log_success "Symlink criado"
  else
    log_warning "Socket do 1Password não encontrado. Certifique-se de que o 1Password está rodando."
  fi
fi

# Configurar SSH config com opções corretas para Linux
log "Configurando SSH config com opções corretas para Linux..."

# Criar bloco de configuração padrão se não existir
if ! grep -q "Host \*" "$SSH_CONFIG" 2>/dev/null; then
  log "Adicionando configuração padrão SSH..."
  cat >> "$SSH_CONFIG" << 'EOF'

# Configuração 1Password SSH Agent (Linux)
Host *
    IdentityAgent ~/.1password/agent.sock
    AddKeysToAgent yes
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes
EOF
  log_success "Configuração padrão adicionada"
else
  log "Atualizando configuração existente..."
  
  # Verificar se IdentityAgent já está configurado
  if grep -q "IdentityAgent" "$SSH_CONFIG"; then
    # Atualizar IdentityAgent existente
    sed -i "s|IdentityAgent.*|IdentityAgent ${SSH_AGENT_SOCK}|g" "$SSH_CONFIG"
    log_success "IdentityAgent atualizado"
  else
    # Adicionar IdentityAgent ao bloco Host *
    sed -i "/^Host \*/a\\    IdentityAgent ${SSH_AGENT_SOCK}" "$SSH_CONFIG"
    log_success "IdentityAgent adicionado"
  fi
  
  # Garantir que outras opções estão presentes
  for option in "AddKeysToAgent yes" "IdentitiesOnly yes" "ServerAliveInterval 60"; do
    if ! grep -q "$option" "$SSH_CONFIG"; then
      sed -i "/^Host \*/a\\    ${option}" "$SSH_CONFIG"
    fi
  done
fi

# Corrigir permissões
chmod 600 "$SSH_CONFIG"
log_success "Permissões do SSH config corrigidas"

# Verificar 1Password CLI
log "Verificando instalação do 1Password CLI..."
if command -v op >/dev/null 2>&1; then
  OP_VERSION=$(op --version 2>/dev/null || echo "unknown")
  log_success "1Password CLI instalado: ${OP_VERSION}"
  
  # Verificar se está autenticado
  if op whoami >/dev/null 2>&1; then
    OP_USER=$(op whoami 2>/dev/null || echo "unknown")
    log_success "1Password autenticado como: ${OP_USER}"
  else
    log_warning "1Password CLI não está autenticado. Execute: op signin"
  fi
else
  log_error "1Password CLI não encontrado"
  log "Instale com:"
  log "  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg"
  log "  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list"
  log "  sudo apt update && sudo apt install -y 1password-cli"
fi

echo ""
log "══════════════════════════════════════════════════════════════"
log_success "Correção SSH/1Password concluída"
log "══════════════════════════════════════════════════════════════"
echo ""
log "📋 Próximos passos:"
log "  1. Reiniciar terminal ou executar: source ~/.bashrc"
log "  2. Verificar socket: ls -la ${SSH_AGENT_SOCK}"
log "  3. Testar SSH: ssh -T git@github.com"
log "  4. Se necessário, autenticar: op signin"
echo ""
log "📁 Arquivos:"
log "  - Log: ${LOG_FILE}"
log "  - Backup SSH config: ${SSH_CONFIG_BACKUP}"
log "  - SSH config: ${SSH_CONFIG}"
echo ""

