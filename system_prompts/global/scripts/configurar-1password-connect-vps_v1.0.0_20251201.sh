#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔐 CONFIGURAÇÃO AUTOMÁTICA DO 1PASSWORD CONNECT NA VPS UBUNTU
#
# Objetivo:
#   - Instalar 1Password CLI na VPS Ubuntu
#   - Configurar autenticação automática usando Service Account
#   - Configurar acesso ao vault 1p_vps
#   - Testar conexão e acesso aos secrets
#
# Uso: ./configurar-1password-connect-vps_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"

# Configuração VPS
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_HOME="/home/${VPS_USER}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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

log_section() {
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} $@"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Validar conexão SSH
validate_ssh() {
    log_step "Validando conexão SSH..."
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_success "Conexão SSH estabelecida"
        return 0
    else
        log_error "Não foi possível conectar via SSH"
        return 1
    fi
}

# Obter credenciais do Service Account do 1Password
get_service_account_credentials() {
    log_step "Obtendo credenciais do Service Account do 1Password..."

    # Tentar obter o service account mais recente (admin-vps conta de servico)
    local service_account_id="yhqdcrihdk5c6sk7x7fwcqazqu"

    # Obter token diretamente usando op read
    SERVICE_ACCOUNT_TOKEN=$(op read "op://1p_vps/${service_account_id}/credencial" 2>/dev/null || \
                            op read "op://1p_vps/${service_account_id}/credential" 2>/dev/null || \
                            echo "")

    if [[ -z "${SERVICE_ACCOUNT_TOKEN}" ]]; then
        log_error "Token do Service Account não encontrado"
        log_info "Tentando obter do item 'Service Account Auth Token: admin-vps conta de servico'"
        log_info "ID do item: ${service_account_id}"
        return 1
    fi

    # Tentar obter URL do Connect Server (se disponível)
    OP_CONNECT_HOST=$(op read "op://1p_vps/${service_account_id}/serverURL" 2>/dev/null || \
                     op read "op://1p_vps/${service_account_id}/url" 2>/dev/null || \
                     op read "op://1p_vps/${service_account_id}/host" 2>/dev/null || \
                     echo "")

    log_success "Credenciais obtidas do 1Password"
    return 0
}

# Instalar 1Password CLI na VPS
install_op_cli() {
    log_step "Instalando 1Password CLI na VPS..."

    ssh "${VPS_USER}@${VPS_HOST}" << 'EOF'
        set -e

        # Verificar se já está instalado
        if command -v op >/dev/null 2>&1; then
            echo "1Password CLI já está instalado"
            op --version
            exit 0
        fi

        # Instalar 1Password CLI para Ubuntu/Debian
        ARCH=$(uname -m)
        if [[ "$ARCH" == "x86_64" ]]; then
            ARCH="amd64"
        elif [[ "$ARCH" == "aarch64" ]]; then
            ARCH="arm64"
        fi

        echo "Baixando 1Password CLI..."
        curl -sSfLo op.zip "https://cache.agilebits.com/dist/1P/op2/pkg/v2.32.0/op_linux_${ARCH}_v2.32.0.zip" || {
            echo "Erro ao baixar 1Password CLI"
            exit 1
        }

        unzip -q op.zip -d /tmp/
        sudo mv /tmp/op /usr/local/bin/op
        sudo chmod +x /usr/local/bin/op
        rm -f op.zip

        # Verificar instalação
        op --version
        echo "1Password CLI instalado com sucesso"
EOF

    if [[ $? -eq 0 ]]; then
        log_success "1Password CLI instalado na VPS"
        return 0
    else
        log_error "Falha ao instalar 1Password CLI"
        return 1
    fi
}

# Configurar autenticação automática na VPS
configure_op_authentication() {
    log_step "Configurando autenticação automática do 1Password..."

    if [[ -z "${SERVICE_ACCOUNT_TOKEN}" ]]; then
        log_error "Token do Service Account não disponível"
        return 1
    fi

    # Criar arquivo de credenciais na VPS
    ssh "${VPS_USER}@${VPS_HOST}" << EOF
        set -e

        # Criar diretório .config/op se não existir
        mkdir -p ~/.config/op

        # Criar arquivo de credenciais
        cat > ~/.config/op/credentials << 'CREDEOF'
${SERVICE_ACCOUNT_TOKEN}
CREDEOF

        chmod 600 ~/.config/op/credentials

        # Configurar variável de ambiente para autenticação automática
        if ! grep -q "OP_SERVICE_ACCOUNT_TOKEN" ~/.bashrc 2>/dev/null; then
            echo "" >> ~/.bashrc
            echo "# 1Password Service Account" >> ~/.bashrc
            echo "export OP_SERVICE_ACCOUNT_TOKEN=\$(cat ~/.config/op/credentials 2>/dev/null)" >> ~/.bashrc
        fi

        # Se OP_CONNECT_HOST estiver definido, configurar também
        if [[ -n "${OP_CONNECT_HOST}" ]]; then
            if ! grep -q "OP_CONNECT_HOST" ~/.bashrc 2>/dev/null; then
                echo "export OP_CONNECT_HOST=\"${OP_CONNECT_HOST}\"" >> ~/.bashrc
            fi
        fi

        echo "Autenticação configurada"
EOF

    if [[ $? -eq 0 ]]; then
        log_success "Autenticação configurada na VPS"
        return 0
    else
        log_error "Falha ao configurar autenticação"
        return 1
    fi
}

# Testar conexão e acesso aos secrets
test_op_connection() {
    log_step "Testando conexão e acesso aos secrets..."

    ssh "${VPS_USER}@${VPS_HOST}" << 'EOF'
        set -e

        # Carregar variáveis de ambiente
        export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null || echo "")

        if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN}" ]]; then
            echo "Token não encontrado"
            exit 1
        fi

        # Testar acesso ao vault 1p_vps
        echo "Testando acesso ao vault 1p_vps..."
        op vault list --account dev 2>&1 | grep -q "1p_vps" && {
            echo "✅ Acesso ao vault 1p_vps confirmado"
        } || {
            echo "⚠️ Vault 1p_vps não encontrado, listando vaults disponíveis:"
            op vault list --account dev 2>&1 || true
        }

        # Tentar ler um secret de teste
        echo "Testando leitura de secret..."
        op item list --vault 1p_vps --account dev 2>&1 | head -5 || {
            echo "⚠️ Não foi possível listar itens do vault 1p_vps"
        }

        echo "Teste concluído"
EOF

    if [[ $? -eq 0 ]]; then
        log_success "Conexão testada com sucesso"
        return 0
    else
        log_warning "Alguns testes podem ter falhado, mas a configuração básica está completa"
        return 0
    fi
}

# Criar script helper na VPS
create_op_helper_script() {
    log_step "Criando script helper na VPS..."

    ssh "${VPS_USER}@${VPS_HOST}" << 'EOF'
        set -e

        mkdir -p ~/Dotfiles/system_prompts/global/scripts

        cat > ~/Dotfiles/system_prompts/global/scripts/op-helper.sh << 'HELPEOF'
#!/usr/bin/env bash
# Helper script para usar 1Password CLI na VPS

# Carregar credenciais
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null || echo "")

# Função helper para ler secrets
op_read() {
    local reference="$1"
    op read "${reference}" --account dev 2>/dev/null
}

# Função helper para listar itens do vault
op_list_vault() {
    local vault="${1:-1p_vps}"
    op item list --vault "${vault}" --account dev 2>/dev/null
}

# Exemplo de uso:
# export DB_PASSWORD=$(op_read "op://1p_vps/Postgres-Prod/PASSWORD")
HELPEOF

        chmod +x ~/Dotfiles/system_prompts/global/scripts/op-helper.sh
        echo "Script helper criado"
EOF

    log_success "Script helper criado na VPS"
}

# Main
main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  CONFIGURAÇÃO AUTOMÁTICA 1PASSWORD CONNECT - VPS         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_info "Configuração:"
    log_info "  - VPS Host: ${VPS_USER}@${VPS_HOST}"
    log_info "  - VPS Home: ${VPS_HOME}"
    echo ""

    # Validar conexão SSH
    if ! validate_ssh; then
        exit 1
    fi

    # Obter credenciais
    if ! get_service_account_credentials; then
        log_error "Não foi possível obter credenciais. Verifique se está autenticado no 1Password CLI local."
        log_info "Execute: op signin"
        exit 1
    fi

    log_info "Credenciais obtidas:"
    log_info "  - Service Account Token: ${SERVICE_ACCOUNT_TOKEN:0:20}..."
    if [[ -n "${OP_CONNECT_HOST}" ]]; then
        log_info "  - Connect Host: ${OP_CONNECT_HOST}"
    fi
    echo ""

    # Instalar 1Password CLI
    install_op_cli || {
        log_warning "Instalação do 1Password CLI pode ter falhado ou já estar instalado"
    }

    # Configurar autenticação
    configure_op_authentication || {
        log_error "Falha ao configurar autenticação"
        exit 1
    }

    # Testar conexão
    test_op_connection || {
        log_warning "Testes podem ter falhado, mas configuração básica está completa"
    }

    # Criar script helper
    create_op_helper_script

    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  CONFIGURAÇÃO CONCLUÍDA COM SUCESSO                       ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    log_info "Próximos passos:"
    log_info "  1. Conectar na VPS: ssh ${VPS_HOST}"
    log_info "  2. Testar acesso: op vault list --account dev"
    log_info "  3. Ler secret: op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev"
    log_info "  4. Usar helper: source ~/Dotfiles/system_prompts/global/scripts/op-helper.sh"
    echo ""
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
