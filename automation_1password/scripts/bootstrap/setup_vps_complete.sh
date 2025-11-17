#!/bin/bash
set -euo pipefail

# setup_vps_complete.sh
# Configuração completa do VPS Ubuntu para automação 1Password
# Inclui correção SSH, configuração 1Password, direnv e validação

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/logs/setup_vps_complete_${TIMESTAMP}.log"

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

log "🚀 Configuração Completa do VPS Ubuntu - 1Password Automation"
log "══════════════════════════════════════════════════════════════"
echo ""

# Verificar se está no Linux
if [[ "$(uname)" != "Linux" ]]; then
  log_error "Este script é específico para Linux/VPS Ubuntu"
  exit 1
fi

# FASE 1: Instalação de Dependências
log "📦 FASE 1: Instalação de Dependências"
log "─────────────────────────────────────"

install_packages() {
  log "Atualizando lista de pacotes..."
  sudo apt update -y
  
  log "Instalando dependências básicas..."
  sudo apt install -y curl wget jq git build-essential openssl ca-certificates
  
  log "Instalando direnv..."
  if ! command -v direnv >/dev/null 2>&1; then
    curl -sfL https://direnv.net/install.sh | bash
    log_success "direnv instalado"
  else
    log_success "direnv já instalado"
  fi
  
  log "Instalando 1Password CLI..."
  if ! command -v op >/dev/null 2>&1; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
      sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
      sudo tee /etc/apt/sources.list.d/1password.list > /dev/null
    
    sudo apt update
    sudo apt install -y 1password-cli
    log_success "1Password CLI instalado"
  else
    OP_VERSION=$(op --version 2>/dev/null || echo "installed")
    log_success "1Password CLI já instalado: ${OP_VERSION}"
  fi
}

install_packages
echo ""

# FASE 2: Configuração SSH e 1Password Agent
log "🔐 FASE 2: Configuração SSH e 1Password Agent"
log "─────────────────────────────────────────────"

if [[ -f "${AUTOMATION_ROOT}/scripts/bootstrap/fix_ssh_1password_vps.sh" ]]; then
  log "Executando correção SSH..."
  bash "${AUTOMATION_ROOT}/scripts/bootstrap/fix_ssh_1password_vps.sh"
  log_success "SSH configurado"
else
  log_warning "Script fix_ssh_1password_vps.sh não encontrado, pulando..."
fi

echo ""

# FASE 3: Configuração direnv
log "📝 FASE 3: Configuração direnv"
log "──────────────────────────────"

setup_direnv() {
  # Criar diretório de libs do direnv
  mkdir -p ~/.config/direnv/lib
  
  # Verificar se hook está no shell
  SHELL_RC=""
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    SHELL_RC="${HOME}/.zshrc"
  else
    SHELL_RC="${HOME}/.bashrc"
  fi
  
  if ! grep -q "direnv hook" "$SHELL_RC" 2>/dev/null; then
    log "Adicionando hook do direnv em ${SHELL_RC}..."
    echo "" >> "$SHELL_RC"
    echo "# direnv hook" >> "$SHELL_RC"
    echo 'eval "$(direnv hook bash)"' >> "$SHELL_RC"
    log_success "Hook do direnv adicionado"
  else
    log_success "Hook do direnv já configurado"
  fi
  
  # Verificar se script use_1password_env existe
  if [[ -f "${HOME}/.config/direnv/lib/use_1password_env.sh" ]]; then
    log_success "Script use_1password_env.sh já existe"
  else
    log "Criando script use_1password_env.sh..."
    mkdir -p ~/.config/direnv/lib
    cat > ~/.config/direnv/lib/use_1password_env.sh << 'EOF'
# use_1password_env - direnv extension for 1Password
# Injects secrets from 1Password into environment variables

use_1password_env() {
  local env_file="${1:-.env.op}"
  
  if [[ ! -f "$env_file" ]]; then
    echo "Error: ${env_file} not found" >&2
    return 1
  fi
  
  # Use op inject to process the template
  if command -v op >/dev/null 2>&1; then
    op inject -i "$env_file" | while IFS='=' read -r key value; do
      [[ -n "$key" ]] && export "$key=$value"
    done
  else
    echo "Error: 1Password CLI not found" >&2
    return 1
  fi
}
EOF
    chmod +x ~/.config/direnv/lib/use_1password_env.sh
    log_success "Script use_1password_env.sh criado"
  fi
}

setup_direnv
echo ""

# FASE 4: Configuração de Ambiente 1Password
log "🔑 FASE 4: Configuração de Ambiente 1Password"
log "─────────────────────────────────────────────"

setup_1password_env() {
  # Carregar variáveis do automation_1password se existir
  if [[ -f "${AUTOMATION_ROOT}/env/vps.env" ]]; then
    log "Carregando variáveis de ${AUTOMATION_ROOT}/env/vps.env..."
    source "${AUTOMATION_ROOT}/env/vps.env"
    log_success "Variáveis carregadas"
  else
    log_warning "Arquivo vps.env não encontrado em ${AUTOMATION_ROOT}/env/"
  fi
  
  # Verificar autenticação
  if op whoami >/dev/null 2>&1; then
    OP_USER=$(op whoami 2>/dev/null || echo "unknown")
    log_success "1Password autenticado como: ${OP_USER}"
  else
    log_warning "1Password não está autenticado"
    log "Execute: op signin"
    log "Ou configure OP_SERVICE_ACCOUNT_TOKEN"
  fi
}

setup_1password_env
echo ""

# FASE 5: Estrutura de Diretórios
log "📂 FASE 5: Estrutura de Diretórios"
log "───────────────────────────────────"

setup_directories() {
  DIRS=(
    "${AUTOMATION_ROOT}/logs"
    "${AUTOMATION_ROOT}/exports"
    "${HOME}/.1password"
    "${HOME}/.config/direnv/lib"
  )
  
  for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    log_success "Diretório: ${dir}"
  done
}

setup_directories
echo ""

# FASE 6: Validação Final
log "🧪 FASE 6: Validação Final"
log "───────────────────────────"

if [[ -f "${AUTOMATION_ROOT}/scripts/bootstrap/test_ssh_1password.sh" ]]; then
  log "Executando testes de validação..."
  bash "${AUTOMATION_ROOT}/scripts/bootstrap/test_ssh_1password.sh" || {
    log_warning "Alguns testes falharam - revise os logs acima"
  }
else
  log_warning "Script test_ssh_1password.sh não encontrado, pulando validação..."
fi

echo ""
log "══════════════════════════════════════════════════════════════"
log_success "Configuração Completa do VPS Concluída"
log "══════════════════════════════════════════════════════════════"
echo ""
log "📋 Próximos passos:"
log "  1. Recarregar shell: source ~/.bashrc (ou ~/.zshrc)"
log "  2. Autenticar 1Password: op signin (ou configurar OP_SERVICE_ACCOUNT_TOKEN)"
log "  3. Testar SSH: ssh -T git@github.com"
log "  4. Configurar direnv em projetos: echo 'use 1password_env' >> .envrc && direnv allow"
echo ""
log "📁 Log completo: ${LOG_FILE}"
echo ""

