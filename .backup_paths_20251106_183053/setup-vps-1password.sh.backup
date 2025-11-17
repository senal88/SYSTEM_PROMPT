#!/bin/bash
# setup-vps-1password.sh
# Configura 1Password CLI na VPS e injeta variáveis de ambiente
# Last Updated: 2025-11-03
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/../lib/logging.sh"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
VPS_HOST="vps"
VPS_PATH="/home/luiz.sena88/automation_1password/prod"
VAULT_VPS="1p_vps"

# ============================================================================
# FUNÇÕES
# ============================================================================

check_vps_1password_auth() {
    log_section "🔐 Verificando Autenticação 1Password na VPS"
    
    if ssh "${VPS_HOST}" "op whoami &>/dev/null 2>&1"; then
        local account=$(ssh "${VPS_HOST}" "op whoami 2>/dev/null" || echo "desconhecido")
        log_success "1Password autenticado na VPS (${account})"
        return 0
    else
        log_warning "1Password não está autenticado na VPS"
        log_info "Será necessário autenticar manualmente"
        return 1
    fi
}

check_vault_exists() {
    log_section "📦 Verificando Vault 1p_vps"
    
    if ssh "${VPS_HOST}" "op vault get '${VAULT_VPS}' --format json &>/dev/null 2>&1"; then
        log_success "Vault ${VAULT_VPS} existe"
        return 0
    else
        log_error "Vault ${VAULT_VPS} não encontrado"
        log_info "Crie o vault no 1Password app antes de continuar"
        return 1
    fi
}

inject_env_file() {
    log_section "💉 Injetando Variáveis de Ambiente"
    
    # Verificar se template existe
    if ! ssh "${VPS_HOST}" "test -f ${VPS_PATH}/.env.template"; then
        log_error "Template .env.template não encontrado na VPS"
        return 1
    fi
    
    log_info "Executando op inject na VPS..."
    
    if ssh "${VPS_HOST}" "cd ${VPS_PATH} && op inject -i .env.template -o .env 2>&1"; then
        # Verificar se arquivo foi criado
        if ssh "${VPS_HOST}" "test -f ${VPS_PATH}/.env"; then
            # Proteger arquivo
            ssh "${VPS_HOST}" "chmod 600 ${VPS_PATH}/.env"
            log_success ".env criado na VPS"
            
            # Validar que tem conteúdo (sem valores sensíveis no output)
            local line_count=$(ssh "${VPS_HOST}" "wc -l < ${VPS_PATH}/.env" | tr -d ' ')
            if [ "${line_count}" -gt 0 ]; then
                log_success "${line_count} linha(s) injetada(s)"
                return 0
            else
                log_error ".env criado mas vazio"
                return 1
            fi
        else
            log_error ".env não foi criado"
            return 1
        fi
    else
        log_error "Falha ao executar op inject"
        return 1
    fi
}

validate_env_file() {
    log_section "✅ Validando .env"
    
    # Verificar variáveis críticas (apenas nomes, não valores)
    local required_vars=("POSTGRES_PASSWORD" "N8N_ENCRYPTION_KEY" "N8N_USER_MANAGEMENT_JWT_SECRET")
    local missing=0
    
    for var in "${required_vars[@]}"; do
        if ssh "${VPS_HOST}" "grep -q '^${var}=' ${VPS_PATH}/.env 2>/dev/null"; then
            log_success "${var} configurado"
        else
            log_error "${var} não encontrado no .env"
            ((missing++))
        fi
    done
    
    if [ ${missing} -eq 0 ]; then
        log_success "Todas as variáveis críticas presentes"
        return 0
    else
        log_error "${missing} variável(is) crítica(s) faltando"
        return 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🚀 Configurando 1Password na VPS"
    
    check_vps_1password_auth || {
        log_warning "1Password não autenticado"
        echo ""
        log_info "Para autenticar na VPS:"
        echo "  ssh ${VPS_HOST}"
        echo "  op signin --account <sua-conta>"
        echo "  ou configure via Connect se disponível"
        echo ""
        read -p "Deseja continuar mesmo sem autenticação? (s/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log_error "Abortado - autentique 1Password primeiro"
            return 1
        fi
    }
    echo ""
    
    check_vault_exists || {
        log_error "Vault ${VAULT_VPS} não encontrado"
        log_info "Crie o vault no 1Password app e sincronize os items antes de continuar"
        return 1
    }
    echo ""
    
    inject_env_file || return 1
    echo ""
    
    validate_env_file || {
        log_warning "Algumas variáveis podem estar faltando"
        log_info "Verifique manualmente: ssh ${VPS_HOST} 'cat ${VPS_PATH}/.env'"
    }
    echo ""
    
    log_section "✅ Configuração Completa"
    log_success "1Password configurado na VPS"
    log_success ".env criado com variáveis injetadas"
    echo ""
    echo "Próximos passos na VPS:"
    echo "  ssh ${VPS_HOST}"
    echo "  cd ${VPS_PATH}"
    echo "  docker compose -f docker-compose.yml config  # Validar"
    echo "  docker compose -f docker-compose.yml up -d   # Iniciar"
    
    return 0
}

main "$@"

