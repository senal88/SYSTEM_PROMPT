#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔧 CORRIGIR CONFIGURAÇÃO COMPLETA CLAUDE DESKTOP
#
# Corrige todos os problemas identificados:
# - API Key correta no claude_desktop_config.json
# - Secrets em texto plano nos MCP servers
# - Referências 1Password corretas
#
# Uso: ./corrigir-claude-desktop-completo_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

CLAUDE_DIR="${HOME}/Library/Application Support/Claude"
CONFIG_FILE="${CLAUDE_DIR}/claude_desktop_config.json"
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

# Verificar 1Password
if ! command -v op &> /dev/null; then
    log_error "1Password CLI não encontrado"
    exit 1
fi

# Obter API Key real do 1Password
log_section "OBTENDO API KEY DO 1PASSWORD"

API_KEY=$(op read "op://${VAULT}/Anthropic/api_key" 2>/dev/null || echo "")

if [[ -z "${API_KEY}" ]]; then
    log_error "Não foi possível obter API Key do 1Password"
    exit 1
fi

log_success "API Key obtida (${#API_KEY} caracteres)"

# Criar backup
log_section "CRIANDO BACKUP"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_CONFIG="${CONFIG_FILE}.backup.${TIMESTAMP}"
BACKUP_MCP="${MCP_CONFIG}.backup.${TIMESTAMP}"

if [[ -f "${CONFIG_FILE}" ]]; then
    cp "${CONFIG_FILE}" "${BACKUP_CONFIG}"
    log_success "Backup criado: ${BACKUP_CONFIG}"
fi

if [[ -f "${MCP_CONFIG}" ]]; then
    cp "${MCP_CONFIG}" "${BACKUP_MCP}"
    log_success "Backup criado: ${BACKUP_MCP}"
fi

# Corrigir claude_desktop_config.json
log_section "CORRIGINDO CLAUDE_DESKTOP_CONFIG.JSON"

if command -v jq &> /dev/null; then
    # Ler configuração atual
    CURRENT_CONFIG=$(cat "${CONFIG_FILE}" 2>/dev/null || echo "{}")

    # Corrigir API Key
    FIXED_CONFIG=$(echo "${CURRENT_CONFIG}" | jq --arg api_key "${API_KEY}" \
        '.anthropic_api_key = $api_key |
         .default_model = (.default_model // "claude-3-5-sonnet-20241022") |
         .theme = (.theme // "auto") |
         .editor_font_size = (.editor_font_size // 14) |
         .editor_font_family = (.editor_font_family // "Monaco, Menlo, monospace")')

    echo "${FIXED_CONFIG}" > "${CONFIG_FILE}"
    log_success "Configuração corrigida"
else
    log_warning "jq não encontrado, usando método alternativo"

    # Método alternativo sem jq
    cat > "${CONFIG_FILE}" << EOF
{
  "anthropic_api_key": "${API_KEY}",
  "default_model": "claude-3-5-sonnet-20241022",
  "theme": "auto",
  "editor_font_size": 14,
  "editor_font_family": "Monaco, Menlo, monospace"
}
EOF

    log_success "Configuração criada (método alternativo)"
fi

# Corrigir MCP Servers (config.json)
log_section "CORRIGINDO MCP SERVERS"

if [[ -f "${MCP_CONFIG}" ]] && command -v jq &> /dev/null; then
    log_info "Corrigindo secrets em texto plano nos MCP servers..."

    # Obter tokens do 1Password
    GITHUB_TOKEN=$(op read "op://${VAULT}/GIT_PAT |Nov-2025/credential" 2>/dev/null || \
                   op read "op://${VAULT}/github.com/password" 2>/dev/null || \
                   echo "")

    # Ler configuração MCP atual
    MCP_CURRENT=$(cat "${MCP_CONFIG}")

    # Corrigir GitHub token
    if [[ -n "${GITHUB_TOKEN}" ]]; then
        MCP_CURRENT=$(echo "${MCP_CURRENT}" | jq --arg token "${GITHUB_TOKEN}" \
            'if .mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN then
                .mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN = $token
            else . end')
        log_success "GitHub token corrigido"
    else
        log_warning "GitHub token não encontrado no 1Password"
    fi

    # Remover placeholders
    MCP_CURRENT=$(echo "${MCP_CURRENT}" | jq '
        walk(if type == "string" and (. == "your-obsidian-api-key-here" or
                                       . == "your-brave-api-key-here" or
                                       . == "ghp_your_github_token_here") then
            empty
        else . end)')

    echo "${MCP_CURRENT}" > "${MCP_CONFIG}"
    log_success "MCP Servers corrigidos"
else
    log_warning "Arquivo MCP config não encontrado ou jq não disponível"
fi

# Validar configurações
log_section "VALIDANDO CONFIGURAÇÕES"

if command -v jq &> /dev/null; then
    if jq empty "${CONFIG_FILE}" 2>/dev/null; then
        log_success "claude_desktop_config.json válido"

        # Verificar API Key
        CONFIG_API_KEY=$(jq -r '.anthropic_api_key' "${CONFIG_FILE}")
        if [[ "${CONFIG_API_KEY}" == "sk-ant-"* ]]; then
            log_success "API Key configurada corretamente"
        else
            log_warning "API Key pode não estar correta"
        fi
    else
        log_error "claude_desktop_config.json inválido"
    fi

    if [[ -f "${MCP_CONFIG}" ]]; then
        if jq empty "${MCP_CONFIG}" 2>/dev/null; then
            log_success "config.json (MCP) válido"
        else
            log_error "config.json (MCP) inválido"
        fi
    fi
fi

log_section "CORREÇÃO CONCLUÍDA"

log_success "╔════════════════════════════════════════════════════════════╗"
log_success "║  CORREÇÕES APLICADAS COM SUCESSO                        ║"
log_success "╚════════════════════════════════════════════════════════════╝"
echo ""
log_info "Próximos passos:"
log_info "1. Reinicie o Claude Desktop"
log_info "2. Execute testes: ./testar-claude-desktop_v1.0.0_20251201.sh"
echo ""
