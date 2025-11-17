#!/bin/bash
# fix-portainer.sh
# Corrige problemas comuns do Portainer
# Last Updated: 2025-10-31
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
COMPOSE_FILE="${REPO_ROOT}/compose/docker-compose-portainer-fixed.yml"
ENV_FILE="${REPO_ROOT}/compose/.env"
PORTAINER_CONTAINER="platform_portainer"

# ============================================================================
# FUNÇÕES
# ============================================================================

check_port_in_use() {
    log_section "🔌 Verificando porta 9000"
    
    if lsof -Pi :9000 -sTCP:LISTEN &> /dev/null; then
        process=$(lsof -Pi :9000 -sTCP:LISTEN | tail -1 | awk '{print $1 " (PID " $2 ")"}')
        log_warning "Porta 9000 em uso por: ${process}"
        
        read -p "Parar processo? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            pid=$(lsof -Pi :9000 -sTCP:LISTEN | tail -1 | awk '{print $2}')
            kill "${pid}" 2>/dev/null || log_error "Não foi possível parar processo ${pid}"
            sleep 2
        fi
    else
        log_success "Porta 9000 está livre"
    fi
}

stop_existing_portainer() {
    log_section "🛑 Parando Portainer existente"
    
    # Parar container antigo
    if docker ps --format '{{.Names}}' | grep -q "^${PORTAINER_CONTAINER}$"; then
        log_info "Parando container ${PORTAINER_CONTAINER}..."
        docker stop "${PORTAINER_CONTAINER}" 2>/dev/null || true
        docker rm "${PORTAINER_CONTAINER}" 2>/dev/null || true
        log_success "Container antigo removido"
    else
        log_info "Nenhum container Portainer rodando"
    fi
    
    # Parar via docker compose (se existir)
    if [ -f "${REPO_ROOT}/compose/docker-compose-local.yml" ]; then
        cd "${REPO_ROOT}/compose"
        docker compose -f docker-compose-local.yml stop portainer 2>/dev/null || true
        docker compose -f docker-compose-local.yml rm -f portainer 2>/dev/null || true
    fi
}

create_password_file() {
    log_section "🔐 Criando arquivo de senha"
    
    local password_file="${REPO_ROOT}/compose/portainer_password.txt"
    
    if [ ! -f "${password_file}" ]; then
        log_info "Gerando senha aleatória para Portainer..."
        # Gerar senha aleatória (16 caracteres)
        random_password=$(openssl rand -base64 16 | tr -d "=+/" | cut -c1-16)
        echo "${random_password}" > "${password_file}"
        chmod 600 "${password_file}"
        log_success "Senha gerada e salva em ${password_file}"
        log_warning "ANOTE A SENHA: ${random_password}"
    else
        log_info "Arquivo de senha já existe"
        log_warning "Senha atual: $(cat "${password_file}")"
    fi
}

create_env_if_missing() {
    log_section "📄 Verificando .env"
    
    if [ ! -f "${ENV_FILE}" ]; then
        log_warning ".env não encontrado. Criando básico..."
        cat > "${ENV_FILE}" << EOF
PROJECT_SLUG=platform
PRIMARY_DOMAIN=localhost
EOF
        chmod 600 "${ENV_FILE}"
        log_success ".env básico criado"
    fi
}

start_portainer() {
    log_section "🚀 Iniciando Portainer corrigido"
    
    if [ ! -f "${COMPOSE_FILE}" ]; then
        log_error "Arquivo ${COMPOSE_FILE} não encontrado"
        return 1
    fi
    
    cd "${REPO_ROOT}/compose"
    
    # Carregar variáveis
    export $(grep -v '^#' "${ENV_FILE}" | xargs)
    
    log_info "Iniciando Portainer com configuração corrigida..."
    docker compose -f "${COMPOSE_FILE}" up -d portainer
    
    if [ $? -eq 0 ]; then
        log_success "Portainer iniciado com sucesso"
    else
        log_error "Falha ao iniciar Portainer"
        return 1
    fi
}

verify_portainer() {
    log_section "✅ Verificando Portainer"
    
    sleep 5
    
    # Verificar se container está rodando
    if docker ps --format '{{.Names}}' | grep -q "^${PORTAINER_CONTAINER}$"; then
        log_success "Container Portainer está rodando"
    else
        log_error "Container Portainer não está rodando"
        return 1
    fi
    
    # Verificar se porta está respondendo
    if curl -sf http://localhost:9000/api/status &> /dev/null; then
        log_success "Portainer está respondendo na porta 9000"
    else
        log_warning "Portainer ainda está iniciando (aguarde alguns segundos)"
        log_info "Verificar logs: docker logs ${PORTAINER_CONTAINER}"
    fi
    
    # Verificar logs
    log_info "Últimas linhas dos logs:"
    docker logs "${PORTAINER_CONTAINER}" --tail 10 2>&1 | tail -5
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔧 Correção do Portainer"
    
    check_port_in_use
    echo ""
    
    stop_existing_portainer
    echo ""
    
    create_env_if_missing
    echo ""
    
    create_password_file
    echo ""
    
    start_portainer
    echo ""
    
    verify_portainer
    echo ""
    
    log_section "📊 Resumo"
    log_success "Portainer corrigido e iniciado!"
    echo ""
    echo "Acesse:"
    echo "  - HTTP:  http://localhost:9000"
    echo "  - HTTPS: https://localhost:9443"
    echo ""
    echo "Senha está em: ${REPO_ROOT}/compose/portainer_password.txt"
    echo ""
    echo "Para ver logs:"
    echo "  docker logs -f ${PORTAINER_CONTAINER}"
}

main "$@"

