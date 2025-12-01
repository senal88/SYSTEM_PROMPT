#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔐 CORRIGIR SECRETS NOS MCP SERVERS DO CLAUDE DESKTOP
#
# Substitui placeholders por referências 1Password ou tokens reais
# Remove secrets em texto plano
#
# Uso: ./corrigir-mcp-servers-secrets_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

CLAUDE_DIR="${HOME}/Library/Application Support/Claude"
MCP_CONFIG="${CLAUDE_DIR}/config.json"
VAULT="1p_macos"

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

if [[ ! -f "${MCP_CONFIG}" ]]; then
    log_error "Arquivo MCP config não encontrado: ${MCP_CONFIG}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    log_error "jq não encontrado"
    exit 1
fi

log_section "CORRIGINDO SECRETS NOS MCP SERVERS"

# Criar backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="${MCP_CONFIG}.backup.${TIMESTAMP}"
cp "${MCP_CONFIG}" "${BACKUP}"
log_success "Backup criado: ${BACKUP}"

# Ler configuração atual
CURRENT_CONFIG=$(cat "${MCP_CONFIG}")

# Obter tokens do 1Password
log_info "Obtendo tokens do 1Password..."

# GitHub Token
GITHUB_TOKEN=$(op read "op://${VAULT}/GIT_PAT |Nov-2025/credential" 2>/dev/null || \
               op read "op://${VAULT}/github.com/password" 2>/dev/null || \
               op read "op://${VAULT}/GitHub/credential" 2>/dev/null || \
               echo "")

if [[ -n "${GITHUB_TOKEN}" ]]; then
    log_success "GitHub token obtido"
    CURRENT_CONFIG=$(echo "${CURRENT_CONFIG}" | jq --arg token "${GITHUB_TOKEN}" \
        'if .mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN then
            .mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN = $token
        else . end')
else
    log_warning "GitHub token não encontrado, removendo placeholder"
    CURRENT_CONFIG=$(echo "${CURRENT_CONFIG}" | jq \
        'if .mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN == "ghp_your_github_token_here" then
            del(.mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN)
        else . end')
fi

# Remover outros placeholders
log_info "Removendo placeholders..."

CURRENT_CONFIG=$(echo "${CURRENT_CONFIG}" | jq '
    walk(if type == "object" then
        with_entries(select(.value != "your-obsidian-api-key-here" and
                           .value != "your-brave-api-key-here" and
                           .value != "ghp_your_github_token_here"))
    else . end)')

# Salvar configuração corrigida
echo "${CURRENT_CONFIG}" | jq '.' > "${MCP_CONFIG}"
log_success "Configuração corrigida"

# Validar JSON
if jq empty "${MCP_CONFIG}" 2>/dev/null; then
    log_success "JSON válido"
else
    log_error "JSON inválido após correção"
    log_info "Restaurando backup..."
    cp "${BACKUP}" "${MCP_CONFIG}"
    exit 1
fi

log_section "CORREÇÃO CONCLUÍDA"

log_success "╔════════════════════════════════════════════════════════════╗"
log_success "║  SECRETS CORRIGIDOS COM SUCESSO                          ║"
log_success "╚════════════════════════════════════════════════════════════╝"
echo ""
