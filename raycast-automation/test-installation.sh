#!/usr/bin/env bash
set -euo pipefail

# Script de teste para verificar se a instalação está funcionando

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[TEST]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    if eval "$test_command" >/dev/null 2>&1; then
        log "✅ $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        error "❌ $test_name"
        ((TESTS_FAILED++))
        return 1
    fi
}

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    TESTE DE INSTALAÇÃO                        ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# 1. Testar Homebrew
log "Testando Homebrew..."
run_test "Homebrew instalado" "command -v brew"
run_test "Homebrew funcionando" "brew --version"

# 2. Testar Raycast
log "Testando Raycast..."
run_test "Raycast instalado" "ls /Applications/Raycast.app"
run_test "Raycast configurado" "defaults read com.raycast.macos hotkey"

# 3. Testar 1Password
log "Testando 1Password..."
run_test "1Password CLI instalado" "command -v op"
run_test "1Password CLI funcionando" "op account list"

# 4. Testar scripts criados
log "Testando scripts criados..."
RAYCAST_DIR="$HOME/Library/Application Support/com.raycast.macos"
run_test "Script Git Status" "test -f $RAYCAST_DIR/script-commands/development/git-status.sh"
run_test "Script Docker PS" "test -f $RAYCAST_DIR/script-commands/development/docker-ps.sh"
run_test "Script Test 1Password" "test -f $RAYCAST_DIR/script-commands/security/test-1password.sh"

# 5. Testar Quicklinks
log "Testando Quicklinks..."
run_test "GitHub Issues Quicklink" "test -f $RAYCAST_DIR/quicklinks/github-issues.json"
run_test "Translate Quicklink" "test -f $RAYCAST_DIR/quicklinks/translate.json"

# 6. Testar Snippets
log "Testando Snippets..."
run_test "Email Signature Snippet" "test -f $RAYCAST_DIR/snippets/email-signature.json"

# 7. Testar permissões de execução
log "Testando permissões..."
run_test "Scripts executáveis" "test -x $RAYCAST_DIR/script-commands/development/git-status.sh"

# 8. Testar 1Password CLI (se configurado)
log "Testando 1Password CLI..."
if op account list >/dev/null 2>&1; then
    run_test "1Password autenticado" "op item list"
else
    warn "1Password CLI não está autenticado"
    info "Para configurar: op signin"
fi

# Resumo dos testes
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    RESUMO DOS TESTES                          ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

if [[ $TESTS_PASSED -gt 0 ]]; then
    log "✅ Testes aprovados: $TESTS_PASSED"
fi

if [[ $TESTS_FAILED -gt 0 ]]; then
    error "❌ Testes falharam: $TESTS_FAILED"
fi

echo ""
if [[ $TESTS_FAILED -eq 0 ]]; then
    log "🎉 Todos os testes passaram! A instalação está funcionando perfeitamente."
    echo ""
    info "Próximos passos:"
    echo "1. Abra o Raycast (⌘ Space)"
    echo "2. Conceda as permissões necessárias"
    echo "3. Teste os scripts criados"
else
    warn "⚠️  Alguns testes falharam. Verifique os erros acima."
    echo ""
    info "Para resolver problemas:"
    echo "1. Execute: ./install.sh novamente"
    echo "2. Verifique as permissões do sistema"
    echo "3. Configure o 1Password CLI: op signin"
fi

echo ""
info "Para executar este teste novamente: ./test-installation.sh"
