#!/bin/bash
# validate-ai-stack.sh
# Validação completa da AI Stack antes de deploy VPS
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
COMPOSE_FILE="${REPO_ROOT}/compose/docker-compose-ai-stack.yml"
ENV_FILE="${REPO_ROOT}/compose/.env"
VALIDATION_LOG="${REPO_ROOT}/logs/validation_ai_stack_$(date +%Y%m%d_%H%M%S).log"

# ============================================================================
# FUNÇÕES DE VALIDAÇÃO
# ============================================================================

check_docker() {
    log_section "🐳 Verificando Docker"
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker não está instalado"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker não está rodando"
        return 1
    fi
    
    log_success "Docker está instalado e rodando"
    
    # Verificar arquitetura
    ARCH=$(docker info --format '{{.Architecture}}')
    log_info "Arquitetura Docker: ${ARCH}"
    
    return 0
}

check_compose_file() {
    log_section "📄 Verificando docker-compose.yml"
    
    if [ ! -f "${COMPOSE_FILE}" ]; then
        log_error "Arquivo ${COMPOSE_FILE} não encontrado"
        return 1
    fi
    
    # Validar sintaxe YAML básica
    if ! docker compose -f "${COMPOSE_FILE}" config &> /dev/null; then
        log_error "Erro de sintaxe no docker-compose.yml"
        docker compose -f "${COMPOSE_FILE}" config
        return 1
    fi
    
    log_success "docker-compose.yml válido"
    return 0
}

check_env_file() {
    log_section "🔐 Verificando arquivo .env"
    
    if [ ! -f "${ENV_FILE}" ]; then
        log_warning "Arquivo .env não encontrado. Gerando a partir do template..."
        
        if [ -f "${REPO_ROOT}/compose/env-ai-stack.template" ]; then
            if command -v op &> /dev/null && op whoami &> /dev/null; then
                cd "${REPO_ROOT}/compose"
                op inject -i env-ai-stack.template -o .env
                chmod 600 .env
                log_success ".env gerado a partir do template"
            else
                log_error "1Password CLI não está autenticado. Execute: op signin"
                return 1
            fi
        else
            log_error "Template env-ai-stack.template não encontrado"
            return 1
        fi
    fi
    
    # Verificar variáveis críticas
    local missing_vars=()
    
    required_vars=(
        "POSTGRES_PASSWORD"
        "N8N_ENCRYPTION_KEY"
        "N8N_USER_MANAGEMENT_JWT_SECRET"
    )
    
    # HUGGINGFACE_TOKEN é recomendado mas não obrigatório (pode usar Ollama apenas)
    optional_vars=(
        "HUGGINGFACE_TOKEN"
    )
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" "${ENV_FILE}" 2>/dev/null; then
            missing_vars+=("${var}")
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        log_error "Variáveis obrigatórias faltando no .env: ${missing_vars[*]}"
        return 1
    fi
    
    # Avisar sobre variáveis opcionais mas recomendadas
    for var in "${optional_vars[@]}"; do
        if ! grep -q "^${var}=" "${ENV_FILE}" 2>/dev/null || grep -q "^${var}=$" "${ENV_FILE}" 2>/dev/null; then
            log_warning "Variável opcional não configurada: ${var} (recomendado para funcionalidade completa)"
        fi
    done
    
    log_success ".env válido com todas as variáveis necessárias"
    return 0
}

check_ports() {
    log_section "🔌 Verificando portas"
    
    ports_to_check=(5678 11434 6333 5432)
    ports_in_use=()
    
    for port in "${ports_to_check[@]}"; do
        if lsof -Pi :${port} -sTCP:LISTEN &> /dev/null; then
            process=$(lsof -Pi :${port} -sTCP:LISTEN | tail -1 | awk '{print $1 " (PID " $2 ")"}')
            ports_in_use+=("${port}: ${process}")
        fi
    done
    
    if [ ${#ports_in_use[@]} -gt 0 ]; then
        log_warning "Portas em uso (pode ser dos próprios containers):"
        for port_info in "${ports_in_use[@]}"; do
            echo "  - ${port_info}"
        done
    else
        log_success "Todas as portas necessárias estão livres"
    fi
    
    return 0
}

check_containers_running() {
    log_section "📦 Verificando containers"
    
    if [ ! -f "${ENV_FILE}" ]; then
        log_error ".env não encontrado. Execute validação completa primeiro."
        return 1
    fi
    
    # Carregar variáveis do .env
    export $(grep -v '^#' "${ENV_FILE}" | xargs)
    
    cd "${REPO_ROOT}/compose"
    
    # Verificar se containers estão rodando (formato compatível)
    if ! docker compose -f docker-compose-ai-stack.yml ps &>/dev/null; then
        log_info "Nenhum container rodando. Isso é normal se ainda não iniciou a stack."
        return 0
    fi
    
    # Usar formato de tabela e contar linhas (mais confiável)
    running=$(docker compose -f docker-compose-ai-stack.yml ps --format "table {{.Name}}\t{{.Status}}" 2>/dev/null | grep -c "Up" || echo "0")
    
    if [ "${running}" -eq 0 ]; then
        log_info "Nenhum container rodando. Isso é normal se ainda não iniciou a stack."
        return 0
    fi
    
    log_info "${running} container(s) rodando"
    
    # Listar containers
    docker compose -f docker-compose-ai-stack.yml ps
    
    return 0
}

check_services_health() {
    log_section "🏥 Verificando saúde dos serviços"
    
    local failed_checks=0
    
    # PostgreSQL
    if docker exec platform_postgres_ai pg_isready -U "${POSTGRES_USER:-n8n}" &> /dev/null; then
        log_success "PostgreSQL está saudável"
    else
        log_error "PostgreSQL não está respondendo"
        ((failed_checks++))
    fi
    
    # n8n
    if curl -sf http://localhost:5678/healthz &> /dev/null; then
        log_success "n8n está saudável"
    else
        log_warning "n8n não está respondendo (pode estar iniciando)"
    fi
    
    # Qdrant
    if curl -sf http://localhost:6333/health &> /dev/null; then
        log_success "Qdrant está saudável"
    else
        log_warning "Qdrant não está respondendo (pode estar iniciando)"
    fi
    
    # Ollama
    if curl -sf http://localhost:11434/api/tags &> /dev/null; then
        log_success "Ollama está saudável"
    else
        log_warning "Ollama não está respondendo (pode estar iniciando)"
    fi
    
    return ${failed_checks}
}

check_huggingface_token() {
    log_section "🤗 Verificando Hugging Face Token"
    
    if [ ! -f "${ENV_FILE}" ]; then
        log_error ".env não encontrado"
        return 1
    fi
    
    export $(grep -v '^#' "${ENV_FILE}" | xargs)
    
    if [ -z "${HUGGINGFACE_TOKEN:-}" ]; then
        log_warning "HUGGINGFACE_TOKEN não está configurado (opcional - pode usar Ollama apenas)"
        return 0
    fi
    
    # Testar token via API
    response=$(curl -s -H "Authorization: Bearer ${HUGGINGFACE_TOKEN}" \
        https://huggingface.co/api/whoami 2>&1)
    
    if echo "${response}" | grep -q '"name"'; then
        username=$(echo "${response}" | jq -r '.name' 2>/dev/null || echo "usuário")
        log_success "Token Hugging Face válido (usuário: ${username})"
    else
        log_warning "Token Hugging Face inválido ou expirado (opcional)"
        log_info "Você pode usar Ollama para LLMs locais sem Hugging Face"
        return 0
    fi
    
    return 0
}

check_volumes() {
    log_section "💾 Verificando volumes"
    
    export $(grep -v '^#' "${ENV_FILE}" | xargs)
    project_slug="${PROJECT_SLUG:-platform}"
    
    required_volumes=(
        "${project_slug}_postgres_ai_data"
        "${project_slug}_n8n_data"
        "${project_slug}_ollama_data"
        "${project_slug}_qdrant_data"
        "${project_slug}_huggingface_cache"
    )
    
    missing_volumes=()
    
    for volume in "${required_volumes[@]}"; do
        if ! docker volume inspect "${volume}" &> /dev/null; then
            missing_volumes+=("${volume}")
        fi
    done
    
    if [ ${#missing_volumes[@]} -gt 0 ]; then
        log_info "Volumes não criados ainda (serão criados no primeiro up): ${missing_volumes[*]}"
    else
        log_success "Todos os volumes necessários existem"
    fi
    
    return 0
}

check_resources() {
    log_section "💻 Verificando recursos do sistema"
    
    # RAM
    total_ram=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
    if [ "${total_ram}" -gt 0 ]; then
        total_ram_gb=$((total_ram / 1024 / 1024 / 1024))
        log_info "RAM Total: ${total_ram_gb} GB"
        
        if [ "${total_ram_gb}" -lt 8 ]; then
            log_warning "RAM recomendada: 8GB+ (atual: ${total_ram_gb}GB)"
        else
            log_success "RAM suficiente: ${total_ram_gb}GB"
        fi
    fi
    
    # Disco
    disk_avail=$(df -h . | tail -1 | awk '{print $4}')
    log_info "Espaço em disco disponível: ${disk_avail}"
    
    # CPU
    cpu_cores=$(sysctl -n hw.ncpu 2>/dev/null || nproc)
    log_info "CPU Cores: ${cpu_cores}"
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🚀 Validação Completa da AI Stack"
    
    local failed=0
    
    # Redirecionar saída para log
    mkdir -p "$(dirname "${VALIDATION_LOG}")"
    exec > >(tee -a "${VALIDATION_LOG}")
    exec 2>&1
    
    echo "Log de validação: ${VALIDATION_LOG}"
    echo ""
    
    check_docker || ((failed++))
    echo ""
    
    check_compose_file || ((failed++))
    echo ""
    
    check_env_file || ((failed++))
    echo ""
    
    check_ports || ((failed++))
    echo ""
    
    check_resources || ((failed++))
    echo ""
    
    check_volumes || ((failed++))
    echo ""
    
    check_huggingface_token || ((failed++))
    echo ""
    
    check_containers_running || ((failed++))
    echo ""
    
    # Verificar saúde apenas se containers estiverem rodando
    cd "${REPO_ROOT}/compose"
    if docker compose -f docker-compose-ai-stack.yml ps 2>/dev/null | grep -q "Up"; then
        check_services_health || ((failed++))
    else
        log_info "Containers da AI stack não estão rodando. Pulando verificação de saúde."
    fi
    
    echo ""
    log_section "📊 Resumo da Validação"
    
    if [ ${failed} -eq 0 ]; then
        log_success "✅ Todas as validações passaram!"
        echo ""
        echo "Próximos passos:"
        echo "  1. Iniciar stack: docker compose -f ${COMPOSE_FILE} --profile cpu up -d"
        echo "  2. Acessar n8n: http://localhost:5678"
        echo "  3. Verificar logs: docker compose -f ${COMPOSE_FILE} logs -f"
        return 0
    else
        log_error "❌ ${failed} validação(ões) falharam"
        echo ""
        echo "Corrija os problemas acima antes de continuar."
        echo "Log completo: ${VALIDATION_LOG}"
        return 1
    fi
}

main "$@"

