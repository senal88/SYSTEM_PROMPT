#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔧 CONFIGURAR CLAUDE DESKTOP COM 1PASSWORD
#
# Configura Claude Desktop para usar API Key do 1Password
# Cria/atualiza claude_desktop_config.json com referência op://
#
# Uso: ./configurar-claude-desktop_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/Library/Application Support/Claude"
CONFIG_FILE="${CLAUDE_DIR}/claude_desktop_config.json"
VAULT="1p_macos"
ITEM_TITLE="Anthropic"
FIELD_NAME="api_key"

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

# Verificar 1Password CLI
if ! command -v op &> /dev/null; then
    log_error "1Password CLI não encontrado"
    exit 1
fi

# Verificar autenticação
if ! op account list &> /dev/null; then
    log_error "1Password não autenticado"
    exit 1
fi

log_success "1Password autenticado"

# Verificar se item existe no 1Password
ITEM_ID=$(op item list --vault "${VAULT}" --format json 2>/dev/null | \
    jq -r ".[] | select(.title == \"${ITEM_TITLE}\") | .id" | head -1)

if [[ -z "${ITEM_ID}" ]]; then
    log_warning "Item '${ITEM_TITLE}' não encontrado no vault ${VAULT}"
    log_info "Execute primeiro: ./configurar-anthropic-api_v1.0.0_20251201.sh"
    exit 1
fi

log_success "Item encontrado: ${ITEM_ID}"

# Criar diretório se não existir
mkdir -p "${CLAUDE_DIR}"

# Referência 1Password
OP_REFERENCE="op://${VAULT}/${ITEM_TITLE}/${FIELD_NAME}"

log_section "CONFIGURANDO CLAUDE DESKTOP"

# Ler configuração atual ou criar nova
if [[ -f "${CONFIG_FILE}" ]]; then
    log_info "Arquivo de configuração existente encontrado"
    BACKUP_FILE="${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "${CONFIG_FILE}" "${BACKUP_FILE}"
    log_info "Backup criado: ${BACKUP_FILE}"

    CURRENT_CONFIG=$(cat "${CONFIG_FILE}")
else
    log_info "Criando nova configuração"
    CURRENT_CONFIG="{}"
fi

# Criar/atualizar configuração JSON
log_info "Atualizando configuração..."

# Usar jq para criar/atualizar configuração
if command -v jq &> /dev/null; then
    # Ler API key do 1Password para validação
    API_KEY=$(op read "${OP_REFERENCE}" 2>/dev/null || echo "")

    if [[ -z "${API_KEY}" ]]; then
        log_warning "Não foi possível ler API Key do 1Password"
        log_info "Usando referência op:// diretamente"
        API_KEY_REF="${OP_REFERENCE}"
    else
        log_success "API Key validada no 1Password"
        # Usar referência op:// mesmo assim para segurança
        API_KEY_REF="${OP_REFERENCE}"
    fi

    # Criar configuração JSON
    NEW_CONFIG=$(echo "${CURRENT_CONFIG}" | jq --arg api_key "${API_KEY_REF}" \
        '.anthropic_api_key = $api_key |
         .default_model = (.default_model // "claude-3-5-sonnet-20241022") |
         .theme = (.theme // "auto") |
         .editor_font_size = (.editor_font_size // 14) |
         .editor_font_family = (.editor_font_family // "Monaco, Menlo, monospace")' 2>/dev/null || echo "{}")

    echo "${NEW_CONFIG}" > "${CONFIG_FILE}"

    log_success "Configuração atualizada"
else
    # Fallback sem jq - criar JSON manualmente
    log_warning "jq não encontrado, usando método alternativo"

    cat > "${CONFIG_FILE}" << EOF
{
  "anthropic_api_key": "${OP_REFERENCE}",
  "default_model": "claude-3-5-sonnet-20241022",
  "theme": "auto",
  "editor_font_size": 14,
  "editor_font_family": "Monaco, Menlo, monospace"
}
EOF

    log_success "Configuração criada (método alternativo)"
fi

# Verificar se Claude Desktop suporta op:// diretamente
log_info "Nota: Claude Desktop pode não suportar referências op:// diretamente"
log_info "Criando script auxiliar para carregar API Key..."

# Criar script auxiliar para carregar API Key
AUX_SCRIPT="${CLAUDE_DIR}/load_api_key.sh"
cat > "${AUX_SCRIPT}" << 'EOF'
#!/usr/bin/env bash
# Script auxiliar para carregar API Key do 1Password
export ANTHROPIC_API_KEY=$(op read "op://1p_macos/Anthropic/api_key" 2>/dev/null || echo "")
EOF

chmod +x "${AUX_SCRIPT}"
log_success "Script auxiliar criado: ${AUX_SCRIPT}"

# Se Claude Desktop não suportar op://, criar arquivo temporário seguro
log_info "Criando método alternativo com arquivo temporário seguro..."

ENV_FILE="${CLAUDE_DIR}/.anthropic_api_key"
cat > "${ENV_FILE}" << EOF
# API Key carregada do 1Password
# Este arquivo é gerado automaticamente e não deve ser versionado
ANTHROPIC_API_KEY=\$(op read "${OP_REFERENCE}" 2>/dev/null || echo "")
EOF

chmod 600 "${ENV_FILE}"
log_success "Arquivo de ambiente criado: ${ENV_FILE}"

# Atualizar configuração para usar arquivo se necessário
if command -v jq &> /dev/null; then
    # Tentar ler do arquivo temporário
    TEMP_API_KEY=$(source "${ENV_FILE}" && echo "${ANTHROPIC_API_KEY}")

    if [[ -n "${TEMP_API_KEY}" ]]; then
        log_info "Atualizando configuração com API Key do arquivo temporário"
        echo "${NEW_CONFIG}" | jq --arg api_key "${TEMP_API_KEY}" \
            '.anthropic_api_key = $api_key' > "${CONFIG_FILE}"
    fi
fi

log_section "VALIDAÇÃO"

# Validar configuração
if [[ -f "${CONFIG_FILE}" ]]; then
    log_success "Arquivo de configuração existe: ${CONFIG_FILE}"

    # Verificar conteúdo
    if grep -q "anthropic_api_key" "${CONFIG_FILE}"; then
        log_success "Campo anthropic_api_key encontrado"
    else
        log_warning "Campo anthropic_api_key não encontrado"
    fi
else
    log_error "Arquivo de configuração não foi criado"
    exit 1
fi

# Validar acesso ao 1Password
if op read "${OP_REFERENCE}" &> /dev/null; then
    log_success "API Key acessível via 1Password"
else
    log_warning "Não foi possível ler API Key do 1Password"
fi

log_section "PRÓXIMOS PASSOS"

log_info "1. Reinicie o Claude Desktop para aplicar as mudanças"
log_info "2. Se Claude Desktop não suportar op://, use o arquivo temporário:"
log_info "   source ${ENV_FILE}"
log_info "3. Verifique a configuração:"
log_info "   cat ${CONFIG_FILE}"

echo ""
log_success "╔════════════════════════════════════════════════════════════╗"
log_success "║  CONFIGURAÇÃO CONCLUÍDA                                   ║"
log_success "╚════════════════════════════════════════════════════════════╝"
echo ""
