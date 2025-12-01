#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔧 CORRIGIR CONFIGURAÇÃO 1PASSWORD - VPS
#
# Objetivo:
#   - Corrigir configuração do 1Password CLI na VPS Ubuntu
#   - Configurar Service Account Token automaticamente
#   - Adicionar aliases e variáveis de ambiente
#   - Testar conexão
#
# Uso: ./corrigir-1password-vps_v1.0.0_20251201.sh
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

# Obter token do Service Account do 1Password local
get_service_account_token() {
    log_step "Obtendo Service Account Token do 1Password..."

    # Verificar se está autenticado localmente
    if ! op account list &>/dev/null; then
        log_error "1Password CLI não está autenticado localmente"
        log_info "Execute: op signin"
        return 1
    fi

    # Ler o token do vault 1p_vps
    local token
    token=$(op read "op://1p_vps/${OP_SERVICE_ACCOUNT_ITEM_ID}/credencial" 2>/dev/null)

    if [[ -z "${token}" ]]; then
        log_error "Token não encontrado no 1Password"
        return 1
    fi

    log_success "Token obtido com sucesso"
    echo "${token}"
    return 0
}

# Configurar 1Password na VPS
configure_op_vps() {
    local service_account_token="$1"

    print_header "CORRIGIR CONFIGURAÇÃO 1PASSWORD - VPS"

    log_step "1. Criando diretório de configuração..."
    ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_HOME}/.config/op" || {
        log_error "Falha ao criar diretório"
        return 1
    }

    log_step "2. Salvando Service Account Token..."
    echo "${service_account_token}" | ssh "${VPS_USER}@${VPS_HOST}" "cat > ${VPS_HOME}/.config/op/credentials && chmod 600 ${VPS_HOME}/.config/op/credentials" || {
        log_error "Falha ao salvar token"
        return 1
    }

    log_step "3. Adicionando conta 1Password..."
    ssh "${VPS_USER}@${VPS_HOST}" << EOF
        set -e
        export OP_SERVICE_ACCOUNT_TOKEN=\$(cat ${VPS_HOME}/.config/op/credentials)

        # Adicionar conta se não existir
        if ! op account list &>/dev/null; then
            op account add --address my.1password.com --token \${OP_SERVICE_ACCOUNT_TOKEN} --account ${OP_CONNECT_ACCOUNT_NAME} || {
                echo "Conta pode já existir, continuando..."
            }
        fi
EOF

    log_step "4. Configurando variáveis de ambiente no .bashrc..."
    ssh "${VPS_USER}@${VPS_HOST}" << 'BASHRC_EOF'
        set -e
        BASHRC_FILE="${HOME}/.bashrc"

        # Remover configurações antigas se existirem
        sed -i '/# 1Password Configuration/,/^$/d' "${BASHRC_FILE}" 2>/dev/null || true

        # Adicionar configuração completa
        cat >> "${BASHRC_FILE}" << 'OP_CONFIG_EOF'

# ============================================================================
# 1Password CLI Configuration
# ============================================================================
export OP_SERVICE_ACCOUNT_TOKEN=$(cat "${HOME}/.config/op/credentials" 2>/dev/null || echo "")
export OP_ACCOUNT="dev"

# Aliases úteis para 1Password
alias op-status='op account list && op vault list --account "${OP_ACCOUNT}" 2>/dev/null || echo "1Password não autenticado"'
alias op-vaults='op vault list --account "${OP_ACCOUNT}"'
alias op-items='op item list --vault 1p_vps --account "${OP_ACCOUNT}"'

# Função helper para ler secrets
op-read() {
    local item_path="$1"
    op read "${item_path}" --account "${OP_ACCOUNT}" 2>/dev/null
}
OP_CONFIG_EOF
        echo "Configuração adicionada ao .bashrc"
BASHRC_EOF

    log_step "5. Testando configuração..."
    ssh "${VPS_USER}@${VPS_HOST}" << 'TEST_EOF'
        set -e
        source "${HOME}/.bashrc"

        # Testar autenticação
        if op vault list --account "${OP_ACCOUNT}" &>/dev/null; then
            echo "✅ Autenticação funcionando"
            echo "Vaults disponíveis:"
            op vault list --account "${OP_ACCOUNT}"
        else
            echo "❌ Falha na autenticação"
            exit 1
        fi
TEST_EOF

    log_success "Configuração corrigida com sucesso!"
    return 0
}

# Main
main() {
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_error "Não foi possível conectar via SSH"
        exit 1
    fi

    local token
    token=$(get_service_account_token) || exit 1

    configure_op_vps "${token}" || exit 1

    print_header "CONFIGURAÇÃO CORRIGIDA COM SUCESSO"

    log_info "Próximos passos:"
    log_info "  1. Conectar na VPS: ssh ${VPS_USER}@${VPS_HOST}"
    log_info "  2. Recarregar shell: source ~/.bashrc"
    log_info "  3. Testar: op-status"
    log_info "  4. Listar vaults: op-vaults"
    log_info "  5. Listar itens: op-items"
    echo ""
}

main "$@"
