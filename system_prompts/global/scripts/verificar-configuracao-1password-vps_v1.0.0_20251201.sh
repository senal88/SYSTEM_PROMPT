#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔍 VERIFICAÇÃO DA CONFIGURAÇÃO 1PASSWORD NA VPS
#
# Objetivo:
#   - Verificar se 1Password CLI está instalado
#   - Verificar se autenticação está configurada
#   - Testar acesso ao vault 1p_vps
#   - Validar funcionamento completo
#
# Uso: ./verificar-configuracao-1password-vps_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️${NC} $@"; }
log_success() { echo -e "${GREEN}✅${NC} $@"; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $@"; }
log_error() { echo -e "${RED}❌${NC} $@"; }

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  VERIFICAÇÃO CONFIGURAÇÃO 1PASSWORD - VPS                ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar instalação do CLI
log_info "1. Verificando instalação do 1Password CLI..."
CLI_VERSION=$(ssh "${VPS_USER}@${VPS_HOST}" "command -v op >/dev/null && op --version 2>&1 || echo 'NÃO INSTALADO'")
if [[ "${CLI_VERSION}" == "NÃO INSTALADO" ]]; then
    log_error "1Password CLI não está instalado"
else
    log_success "1Password CLI instalado: ${CLI_VERSION}"
fi

# Verificar arquivo de credenciais
log_info "2. Verificando arquivo de credenciais..."
CREDENTIALS_EXISTS=$(ssh "${VPS_USER}@${VPS_HOST}" "test -f ~/.config/op/credentials && echo 'EXISTS' || echo 'NOT_EXISTS'")
if [[ "${CREDENTIALS_EXISTS}" == "EXISTS" ]]; then
    CREDENTIALS_SIZE=$(ssh "${VPS_USER}@${VPS_HOST}" "wc -c < ~/.config/op/credentials")
    log_success "Arquivo de credenciais existe (${CREDENTIALS_SIZE} bytes)"
    CREDENTIALS_PERM=$(ssh "${VPS_USER}@${VPS_HOST}" "stat -c '%a' ~/.config/op/credentials 2>/dev/null || stat -f '%A' ~/.config/op/credentials 2>/dev/null")
    if [[ "${CREDENTIALS_PERM}" == "600" ]]; then
        log_success "Permissões corretas: ${CREDENTIALS_PERM}"
    else
        log_warning "Permissões devem ser 600, atual: ${CREDENTIALS_PERM}"
    fi
else
    log_error "Arquivo de credenciais não encontrado"
fi

# Verificar variável de ambiente
log_info "3. Verificando configuração no .bashrc..."
BASHRC_CONFIG=$(ssh "${VPS_USER}@${VPS_HOST}" "grep -q 'OP_SERVICE_ACCOUNT_TOKEN' ~/.bashrc && echo 'CONFIGURADO' || echo 'NÃO_CONFIGURADO'")
if [[ "${BASHRC_CONFIG}" == "CONFIGURADO" ]]; then
    log_success "Variável de ambiente configurada no .bashrc"
else
    log_warning "Variável de ambiente não configurada no .bashrc"
fi

# Testar acesso ao vault
log_info "4. Testando acesso ao vault 1p_vps..."
VAULT_TEST=$(ssh "${VPS_USER}@${VPS_HOST}" "
    export OP_SERVICE_ACCOUNT_TOKEN=\$(cat ~/.config/op/credentials 2>/dev/null || echo '')
    op vault list --account dev 2>&1 | grep -q '1p_vps' && echo 'ACESSO_OK' || echo 'ACESSO_FALHOU'
" 2>/dev/null || echo "ERRO_TESTE")

if [[ "${VAULT_TEST}" == "ACESSO_OK" ]]; then
    log_success "Acesso ao vault 1p_vps confirmado"

    # Listar alguns itens
    log_info "5. Listando itens do vault..."
    ITEMS_COUNT=$(ssh "${VPS_USER}@${VPS_HOST}" "
        export OP_SERVICE_ACCOUNT_TOKEN=\$(cat ~/.config/op/credentials 2>/dev/null || echo '')
        op item list --vault 1p_vps --account dev 2>&1 | wc -l
    " 2>/dev/null || echo "0")
    log_success "Itens encontrados no vault: ${ITEMS_COUNT}"
else
    log_error "Não foi possível acessar o vault 1p_vps"
fi

# Verificar script helper
log_info "6. Verificando script helper..."
HELPER_EXISTS=$(ssh "${VPS_USER}@${VPS_HOST}" "test -f ~/Dotfiles/system_prompts/global/scripts/op-helper.sh && echo 'EXISTS' || echo 'NOT_EXISTS'")
if [[ "${HELPER_EXISTS}" == "EXISTS" ]]; then
    log_success "Script helper encontrado"
else
    log_warning "Script helper não encontrado"
fi

# Teste final: ler um secret
log_info "7. Testando leitura de secret..."
SECRET_TEST=$(ssh "${VPS_USER}@${VPS_HOST}" "
    export OP_SERVICE_ACCOUNT_TOKEN=\$(cat ~/.config/op/credentials 2>/dev/null || echo '')
    op item list --vault 1p_vps --account dev 2>&1 | head -1 | awk '{print \$1}' | xargs -I {} op item get {} --vault 1p_vps --account dev --format json 2>&1 | grep -q 'id' && echo 'LEITURA_OK' || echo 'LEITURA_FALHOU'
" 2>/dev/null || echo "ERRO_TESTE")

if [[ "${SECRET_TEST}" == "LEITURA_OK" ]]; then
    log_success "Leitura de secrets funcionando"
else
    log_warning "Teste de leitura pode ter falhado"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  VERIFICAÇÃO CONCLUÍDA                                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Resumo
echo "📊 Resumo:"
if [[ "${CLI_VERSION}" != "NÃO INSTALADO" ]] && \
   [[ "${CREDENTIALS_EXISTS}" == "EXISTS" ]] && \
   [[ "${VAULT_TEST}" == "ACESSO_OK" ]]; then
    log_success "Configuração completa e funcional!"
else
    log_warning "Algumas verificações falharam. Execute o script de configuração:"
    log_info "  ./configurar-1password-connect-vps_v1.0.0_20251201.sh"
fi
