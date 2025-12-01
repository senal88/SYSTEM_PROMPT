#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔧 CORRIGIR TOKEN 1PASSWORD - VPS (Limpar e Reconfigurar)
#
# Objetivo:
#   - Limpar arquivo de credenciais corrompido
#   - Obter token correto do 1Password local
#   - Salvar apenas o token (sem espaços, sem quebras extras)
#   - Testar autenticação
#
# Uso: ./corrigir-token-1password-vps_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_HOME="${VPS_HOME:-/home/admin}"
OP_SERVICE_ACCOUNT_ITEM_ID="yhqdcrihdk5c6sk7x7fwcqazqu"
OP_CONNECT_ACCOUNT_NAME="dev"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_step() {
    echo -e "${CYAN}▶${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
}

# Obter token limpo do 1Password local
get_clean_token() {
    log_step "Obtendo token limpo do 1Password local..."
    
    # Verificar autenticação local
    if ! op account list &>/dev/null; then
        log_error "1Password CLI não está autenticado localmente"
        log_info "Execute: op signin"
        return 1
    fi
    
    # Ler token e limpar (remover espaços, quebras de linha, etc)
    local token
    token=$(op read "op://1p_vps/${OP_SERVICE_ACCOUNT_ITEM_ID}/credencial" 2>/dev/null | tr -d '\n\r\t ' | head -1)
    
    if [[ -z "${token}" ]] || [[ "${#token}" -lt 50 ]]; then
        log_error "Token inválido ou muito curto"
        return 1
    fi
    
    log_success "Token obtido: ${token:0:20}... (${#token} caracteres)"
    echo "${token}"
    return 0
}

# Corrigir token na VPS
fix_token_vps() {
    local clean_token="$1"
    
    print_header "CORRIGIR TOKEN 1PASSWORD - VPS"
    
    log_step "1. Fazendo backup do arquivo atual..."
    ssh "${VPS_USER}@${VPS_HOST}" "cp ${VPS_HOME}/.config/op/credentials ${VPS_HOME}/.config/op/credentials.backup.$(date +%Y%m%d_%H%M%S)" || true
    
    log_step "2. Limpando e salvando token correto..."
    echo "${clean_token}" | ssh "${VPS_USER}@${VPS_HOST}" "cat > ${VPS_HOME}/.config/op/credentials && chmod 600 ${VPS_HOME}/.config/op/credentials" || {
        log_error "Falha ao salvar token"
        return 1
    }
    
    log_step "3. Verificando arquivo salvo..."
    local saved_token
    saved_token=$(ssh "${VPS_USER}@${VPS_HOST}" "cat ${VPS_HOME}/.config/op/credentials | tr -d '\n\r\t '")
    local file_lines
    file_lines=$(ssh "${VPS_USER}@${VPS_HOST}" "wc -l < ${VPS_HOME}/.config/op/credentials")
    
    if [[ "${file_lines}" -gt 1 ]]; then
        log_warning "Arquivo ainda tem ${file_lines} linhas. Limpando novamente..."
        echo "${clean_token}" | ssh "${VPS_USER}@${VPS_HOST}" "cat > ${VPS_HOME}/.config/op/credentials && chmod 600 ${VPS_HOME}/.config/op/credentials"
    fi
    
    log_success "Token salvo corretamente (${#saved_token} caracteres, 1 linha)"
    
    log_step "4. Testando autenticação..."
    ssh "${VPS_USER}@${VPS_HOST}" << 'TEST_EOF'
        set -e
        export OP_SERVICE_ACCOUNT_TOKEN=$(cat "${HOME}/.config/op/credentials" | tr -d '\n\r\t ')
        export OP_ACCOUNT="dev"
        
        # Testar autenticação
        if op vault list --account "${OP_ACCOUNT}" &>/dev/null; then
            echo "✅ Autenticação funcionando!"
            echo ""
            echo "Vaults disponíveis:"
            op vault list --account "${OP_ACCOUNT}"
        else
            echo "❌ Falha na autenticação"
            echo "Token: ${OP_SERVICE_ACCOUNT_TOKEN:0:20}..."
            exit 1
        fi
TEST_EOF
    
    if [[ $? -eq 0 ]]; then
        log_success "Autenticação testada com sucesso!"
        return 0
    else
        log_error "Falha no teste de autenticação"
        return 1
    fi
}

# Main
main() {
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_error "Não foi possível conectar via SSH"
        exit 1
    fi
    
    local token
    token=$(get_clean_token) || exit 1
    
    fix_token_vps "${token}" || exit 1
    
    print_header "TOKEN CORRIGIDO COM SUCESSO"
    
    log_info "Próximos passos:"
    log_info "  1. Conectar na VPS: ssh ${VPS_USER}@${VPS_HOST}"
    log_info "  2. Recarregar shell: source ~/.bashrc"
    log_info "  3. Testar: op-status"
    log_info "  4. Listar vaults: op-vaults"
    log_info "  5. Listar itens: op-items"
    echo ""
}

main "$@"

