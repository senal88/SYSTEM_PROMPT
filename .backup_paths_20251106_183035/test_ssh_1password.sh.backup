#!/bin/bash
set -euo pipefail

# test_ssh_1password.sh
# Testa configuração SSH e autenticação 1Password no VPS Ubuntu

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/logs/test_ssh_1password_${TIMESTAMP}.log"
SSH_CONFIG="${HOME}/.ssh/config"

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

log "🧪 Teste de Configuração SSH e 1Password Agent"
log "════════════════════════════════════════════════"
echo ""

TESTS_PASSED=0
TESTS_FAILED=0

# Teste 1: Verificar sistema operacional
test_os() {
  log "Teste 1: Sistema Operacional"
  if [[ "$(uname)" == "Linux" ]]; then
    OS_VERSION=$(lsb_release -d 2>/dev/null | cut -f2 || echo "Linux")
    log_success "Sistema: Linux (${OS_VERSION})"
    ((TESTS_PASSED++))
  else
    log_warning "Sistema: $(uname) (esperado Linux para VPS)"
    ((TESTS_FAILED++))
  fi
  echo ""
}

# Teste 2: Verificar SSH config
test_ssh_config() {
  log "Teste 2: Configuração SSH"
  
  if [[ ! -f "$SSH_CONFIG" ]]; then
    log_error "Arquivo SSH config não encontrado: ${SSH_CONFIG}"
    ((TESTS_FAILED++))
    echo ""
    return 1
  fi
  
  log_success "Arquivo SSH config encontrado"
  
  # Verificar permissões
  PERMS=$(stat -c "%a" "$SSH_CONFIG" 2>/dev/null || stat -f "%OLp" "$SSH_CONFIG" 2>/dev/null || echo "unknown")
  if [[ "$PERMS" == "600" ]]; then
    log_success "Permissões corretas: ${PERMS}"
  else
    log_warning "Permissões: ${PERMS} (ideal: 600)"
  fi
  
  # Verificar UseKeychain (não deve existir)
  if grep -q "UseKeychain" "$SSH_CONFIG" 2>/dev/null; then
    log_error "Opção 'UseKeychain' encontrada (específica do macOS, não funciona no Linux)"
    ((TESTS_FAILED++))
  else
    log_success "Nenhuma opção 'UseKeychain' encontrada"
    ((TESTS_PASSED++))
  fi
  
  # Verificar IdentityAgent
  if grep -q "IdentityAgent" "$SSH_CONFIG"; then
    AGENT_PATH=$(grep "IdentityAgent" "$SSH_CONFIG" | awk '{print $2}' | head -1)
    log_success "IdentityAgent configurado: ${AGENT_PATH}"
    ((TESTS_PASSED++))
  else
    log_warning "IdentityAgent não configurado"
    ((TESTS_FAILED++))
  fi
  
  echo ""
}

# Teste 3: Verificar socket do 1Password agent
test_1password_socket() {
  log "Teste 3: Socket do 1Password SSH Agent"
  
  # Detectar socket do config
  AGENT_PATH=$(grep "IdentityAgent" "$SSH_CONFIG" 2>/dev/null | awk '{print $2}' | head -1 || echo "")
  
  if [[ -z "$AGENT_PATH" ]]; then
    # Tentar paths comuns
    POSSIBLE_PATHS=(
      "${HOME}/.1password/agent.sock"
      "${HOME}/.config/1Password/ssh/agent.sock"
      "/tmp/1password-ssh-agent.sock"
    )
    
    for path in "${POSSIBLE_PATHS[@]}"; do
      if [[ -S "$path" ]] || [[ -f "$path" ]]; then
        AGENT_PATH="$path"
        break
      fi
    done
  fi
  
  if [[ -n "$AGENT_PATH" ]]; then
    # Expandir ~ se necessário
    AGENT_PATH="${AGENT_PATH/#\~/$HOME}"
    
    if [[ -S "$AGENT_PATH" ]]; then
      log_success "Socket encontrado e acessível: ${AGENT_PATH}"
      ((TESTS_PASSED++))
    elif [[ -f "$AGENT_PATH" ]]; then
      log_warning "Arquivo encontrado (não é socket): ${AGENT_PATH}"
      log "Verificando se é symlink..."
      if [[ -L "$AGENT_PATH" ]]; then
        REAL_SOCK=$(readlink -f "$AGENT_PATH" 2>/dev/null || echo "")
        if [[ -S "$REAL_SOCK" ]]; then
          log_success "Symlink válido apontando para: ${REAL_SOCK}"
          ((TESTS_PASSED++))
        else
          log_error "Symlink quebrado"
          ((TESTS_FAILED++))
        fi
      else
        ((TESTS_FAILED++))
      fi
    else
      log_error "Socket não encontrado: ${AGENT_PATH}"
      log "Certifique-se de que o 1Password está rodando"
      ((TESTS_FAILED++))
    fi
  else
    log_error "Nenhum socket do 1Password encontrado"
    ((TESTS_FAILED++))
  fi
  
  echo ""
}

# Teste 4: Verificar 1Password CLI
test_1password_cli() {
  log "Teste 4: 1Password CLI"
  
  if ! command -v op >/dev/null 2>&1; then
    log_error "1Password CLI não encontrado"
    log "Instale com: sudo apt install -y 1password-cli"
    ((TESTS_FAILED++))
    echo ""
    return 1
  fi
  
  OP_VERSION=$(op --version 2>/dev/null || echo "unknown")
  log_success "1Password CLI instalado: ${OP_VERSION}"
  ((TESTS_PASSED++))
  
  # Verificar autenticação
  if op whoami >/dev/null 2>&1; then
    OP_USER=$(op whoami 2>/dev/null || echo "unknown")
    log_success "1Password autenticado como: ${OP_USER}"
    ((TESTS_PASSED++))
  else
    log_warning "1Password CLI não está autenticado"
    log "Execute: op signin"
    ((TESTS_FAILED++))
  fi
  
  echo ""
}

# Teste 5: Testar conexão SSH com GitHub
test_ssh_github() {
  log "Teste 5: Conexão SSH com GitHub"
  
  log "Executando: ssh -T git@github.com"
  
  SSH_OUTPUT=$(ssh -T git@github.com 2>&1 || true)
  SSH_EXIT=$?
  
  if echo "$SSH_OUTPUT" | grep -q "successfully authenticated"; then
    log_success "Autenticação SSH com GitHub bem-sucedida"
    log "Resposta: $(echo "$SSH_OUTPUT" | head -1)"
    ((TESTS_PASSED++))
  elif echo "$SSH_OUTPUT" | grep -q "Bad configuration option: usekeychain"; then
    log_error "Erro de configuração: UseKeychain (macOS-only)"
    log "Execute: bash scripts/bootstrap/fix_ssh_1password_vps.sh"
    ((TESTS_FAILED++))
  elif echo "$SSH_OUTPUT" | grep -q "Permission denied"; then
    log_warning "Permission denied - verificar chaves SSH"
    log "Certifique-se de que as chaves estão no 1Password e o agent está rodando"
    ((TESTS_FAILED++))
  else
    log_warning "Resposta inesperada: $(echo "$SSH_OUTPUT" | head -1)"
    ((TESTS_FAILED++))
  fi
  
  echo ""
}

# Teste 6: Verificar variáveis de ambiente SSH
test_ssh_env() {
  log "Teste 6: Variáveis de Ambiente SSH"
  
  if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
    log_success "SSH_AUTH_SOCK configurado: ${SSH_AUTH_SOCK}"
    if [[ -S "${SSH_AUTH_SOCK}" ]]; then
      log_success "Socket acessível"
      ((TESTS_PASSED++))
    else
      log_warning "Socket não acessível: ${SSH_AUTH_SOCK}"
      ((TESTS_FAILED++))
    fi
  else
    log_warning "SSH_AUTH_SOCK não configurado"
    ((TESTS_FAILED++))
  fi
  
  echo ""
}

# Executar todos os testes
test_os
test_ssh_config
test_1password_socket
test_1password_cli
test_ssh_env
test_ssh_github

# Resumo final
echo ""
log "════════════════════════════════════════════════"
log "📊 Resumo dos Testes"
log "════════════════════════════════════════════════"
TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
log "Total de testes: ${TOTAL_TESTS}"
log_success "Testes aprovados: ${TESTS_PASSED}"
if (( TESTS_FAILED > 0 )); then
  log_error "Testes falharam: ${TESTS_FAILED}"
else
  log_success "Todos os testes passaram! ✅"
fi
echo ""
log "📁 Log completo: ${LOG_FILE}"
echo ""

# Exit code baseado nos resultados
if (( TESTS_FAILED == 0 )); then
  exit 0
else
  exit 1
fi

