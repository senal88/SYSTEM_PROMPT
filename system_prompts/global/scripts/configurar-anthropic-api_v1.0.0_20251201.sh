#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔐 CONFIGURAR ANTHROPIC API KEY NO 1PASSWORD
#
# Cria ou atualiza o item Anthropic no vault 1p_macos seguindo as convenções:
# - Vault: 1p_macos
# - Item: Anthropic
# - Campo: api_key
# - Variável: ANTHROPIC_API_KEY
#
# Uso: ./configurar-anthropic-api_v1.0.0_20251201.sh [API_KEY]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="1p_macos"
ITEM_TITLE="Anthropic"
FIELD_NAME="api_key"
ENV_VAR="ANTHROPIC_API_KEY"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
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

# Verificar se item já existe
EXISTING_ITEM=$(op item list --vault "${VAULT}" --format json 2>/dev/null | \
    jq -r ".[] | select(.title == \"${ITEM_TITLE}\") | .id" | head -1)

if [[ -n "${EXISTING_ITEM}" ]]; then
    log_info "Item '${ITEM_TITLE}' já existe (ID: ${EXISTING_ITEM})"
    
    # Ler API key atual
    CURRENT_KEY=$(op item get "${EXISTING_ITEM}" --vault "${VAULT}" \
        --fields label="${FIELD_NAME}" 2>/dev/null || echo "")
    
    if [[ -n "${CURRENT_KEY}" ]]; then
        log_success "API Key já configurada no 1Password"
        log_info "Para atualizar, forneça a nova chave como argumento"
    fi
fi

# Obter API key
if [[ $# -gt 0 ]]; then
    API_KEY="$1"
    log_info "API Key fornecida via argumento"
else
    # Solicitar API key de forma segura
    echo ""
    log_info "Por favor, cole sua chave de API da Anthropic (Claude):"
    echo -n "API Key: "
    read -s API_KEY
    echo ""
    
    if [[ -z "${API_KEY}" ]]; then
        log_error "API Key não fornecida"
        exit 1
    fi
fi

# Criar ou atualizar item no 1Password
log_info "Configurando item no 1Password..."

if [[ -n "${EXISTING_ITEM}" ]]; then
    # Atualizar item existente
    log_info "Atualizando item existente..."
    
    op item edit "${EXISTING_ITEM}" --vault "${VAULT}" \
        "api_key[password]=${API_KEY}" \
        --tags "api-key,claude,anthropic" 2>&1 | grep -v "password" || true
    
    log_success "Item atualizado com sucesso"
else
    # Criar novo item
    log_info "Criando novo item..."
    
    op item create \
        --category "API Credential" \
        --title "${ITEM_TITLE}" \
        --vault "${VAULT}" \
        "api_key[password]=${API_KEY}" \
        --tags "api-key,claude,anthropic" 2>&1 | grep -v "password" || true
    
    log_success "Item criado com sucesso"
fi

# Obter ID do item
ITEM_ID=$(op item list --vault "${VAULT}" --format json 2>/dev/null | \
    jq -r ".[] | select(.title == \"${ITEM_TITLE}\") | .id" | head -1)

log_success "Item configurado: ${ITEM_ID}"

# Configurar variável de ambiente no .zshrc
log_info "Configurando variável de ambiente no .zshrc..."

ZSHRC="${HOME}/.zshrc"
REFERENCE="op://${VAULT}/${ITEM_TITLE}/${FIELD_NAME}"

# Verificar se já existe configuração
if grep -q "${ENV_VAR}" "${ZSHRC}" 2>/dev/null; then
    log_warning "Variável ${ENV_VAR} já existe no .zshrc"
    log_info "Atualizando referência..."
    
    # Remover linha antiga e adicionar nova
    sed -i '' "/export ${ENV_VAR}=/d" "${ZSHRC}"
fi

# Adicionar configuração
if ! grep -q "Anthropic API Key" "${ZSHRC}" 2>/dev/null; then
    echo "" >> "${ZSHRC}"
    echo "# Anthropic API Key" >> "${ZSHRC}"
fi

echo "export ${ENV_VAR}=\$(op read '${REFERENCE}' 2>/dev/null || echo '')" >> "${ZSHRC}"

log_success "Variável de ambiente configurada no .zshrc"

# Testar configuração
log_info "Testando configuração..."

if op read "${REFERENCE}" &> /dev/null; then
    log_success "API Key acessível via 1Password"
    log_info "Referência: ${REFERENCE}"
else
    log_warning "Não foi possível ler a API Key (pode ser normal se ainda não foi carregada)"
fi

echo ""
log_success "╔════════════════════════════════════════════════════════════╗"
log_success "║  CONFIGURAÇÃO CONCLUÍDA                                   ║"
log_success "╚════════════════════════════════════════════════════════════╝"
echo ""
log_info "Próximos passos:"
log_info "1. Recarregue o shell: source ~/.zshrc"
log_info "2. Verifique a variável: echo \$${ENV_VAR}"
log_info "3. Use a referência: op://${VAULT}/${ITEM_TITLE}/${FIELD_NAME}"
echo ""

