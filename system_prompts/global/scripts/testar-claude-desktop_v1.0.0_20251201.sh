#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🧪 TESTAR CONFIGURAÇÃO CLAUDE DESKTOP
#
# Valida configuração do Claude Desktop e acesso à API
#
# Uso: ./testar-claude-desktop_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

CLAUDE_DIR="${HOME}/Library/Application Support/Claude"
CONFIG_FILE="${CLAUDE_DIR}/claude_desktop_config.json"
VAULT="1p_macos"
ITEM_TITLE="Anthropic"
FIELD_NAME="api_key"
OP_REFERENCE="op://${VAULT}/${ITEM_TITLE}/${FIELD_NAME}"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

log_section() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $@"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

TESTS_PASSED=0
TESTS_FAILED=0

test_check() {
    local name="$1"
    local command="$2"

    if eval "${command}" &> /dev/null; then
        log_success "${name}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        log_error "${name}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

log_section "TESTANDO CONFIGURAÇÃO CLAUDE DESKTOP"

# Teste 1: Verificar 1Password CLI
log_info "Teste 1: Verificar 1Password CLI"
test_check "1Password CLI instalado" "command -v op"

# Teste 2: Verificar autenticação 1Password
log_info "Teste 2: Verificar autenticação 1Password"
test_check "1Password autenticado" "op account list"

# Teste 3: Verificar item no 1Password
log_info "Teste 3: Verificar item Anthropic no 1Password"
ITEM_ID=$(op item list --vault "${VAULT}" --format json 2>/dev/null | \
    jq -r ".[] | select(.title == \"${ITEM_TITLE}\") | .id" | head -1)

if [[ -n "${ITEM_ID}" ]]; then
    log_success "Item encontrado: ${ITEM_ID}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    log_error "Item não encontrado"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Teste 4: Verificar acesso à API Key
log_info "Teste 4: Verificar acesso à API Key"
API_KEY=$(op read "${OP_REFERENCE}" 2>/dev/null || echo "")

if [[ -n "${API_KEY}" ]]; then
    log_success "API Key acessível (${#API_KEY} caracteres)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    log_error "API Key não acessível"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Teste 5: Verificar diretório Claude
log_info "Teste 5: Verificar diretório Claude Desktop"
if [[ -d "${CLAUDE_DIR}" ]]; then
    log_success "Diretório existe: ${CLAUDE_DIR}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    log_error "Diretório não existe"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Teste 6: Verificar arquivo de configuração
log_info "Teste 6: Verificar arquivo de configuração"
if [[ -f "${CONFIG_FILE}" ]]; then
    log_success "Arquivo existe: ${CONFIG_FILE}"
    TESTS_PASSED=$((TESTS_PASSED + 1))

    # Verificar conteúdo
    if grep -q "anthropic_api_key" "${CONFIG_FILE}"; then
        log_success "Campo anthropic_api_key encontrado"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        log_error "Campo anthropic_api_key não encontrado"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    log_error "Arquivo não existe"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Teste 7: Validar formato JSON
log_info "Teste 7: Validar formato JSON"
if command -v jq &> /dev/null; then
    if jq empty "${CONFIG_FILE}" 2>/dev/null; then
        log_success "JSON válido"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        log_error "JSON inválido"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    log_warning "jq não encontrado, pulando validação JSON"
fi

# Teste 8: Testar API da Anthropic (se API Key disponível)
log_info "Teste 8: Testar API da Anthropic"
if [[ -n "${API_KEY}" ]]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -H "x-api-key: ${API_KEY}" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d '{"model":"claude-3-5-sonnet-20241022","max_tokens":10,"messages":[{"role":"user","content":"test"}]}' \
        "https://api.anthropic.com/v1/messages" 2>/dev/null || echo -e "\n000")

    HTTP_CODE=$(echo "${RESPONSE}" | tail -1)

    if [[ "${HTTP_CODE}" == "200" ]] || [[ "${HTTP_CODE}" == "401" ]]; then
        log_success "API acessível (HTTP ${HTTP_CODE})"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        log_warning "API retornou HTTP ${HTTP_CODE}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    log_warning "API Key não disponível, pulando teste de API"
fi

# Teste 9: Verificar variável de ambiente
log_info "Teste 9: Verificar variável de ambiente"
if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    log_success "Variável ANTHROPIC_API_KEY definida"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    log_warning "Variável ANTHROPIC_API_KEY não definida (pode ser normal)"
fi

# Teste 10: Verificar processo Claude Desktop
log_info "Teste 10: Verificar processo Claude Desktop"
if pgrep -f "Claude" &> /dev/null; then
    log_success "Claude Desktop em execução"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    log_warning "Claude Desktop não está em execução"
fi

log_section "RESUMO DOS TESTES"

echo ""
echo "✅ Testes passados: ${TESTS_PASSED}"
echo "❌ Testes falhados: ${TESTS_FAILED}"
echo ""

TOTAL=$((TESTS_PASSED + TESTS_FAILED))
if [[ ${TOTAL} -gt 0 ]]; then
    PERCENTAGE=$((TESTS_PASSED * 100 / TOTAL))
    echo "📊 Taxa de sucesso: ${PERCENTAGE}%"
fi

echo ""

if [[ ${TESTS_FAILED} -eq 0 ]]; then
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  TODOS OS TESTES PASSARAM                                ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    exit 0
else
    log_error "╔════════════════════════════════════════════════════════════╗"
    log_error "║  ALGUNS TESTES FALHARAM                                  ║"
    log_error "╚════════════════════════════════════════════════════════════╝"
    exit 1
fi
