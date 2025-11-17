#!/bin/bash
# validate-vps-ready.sh
# Valida se VPS está pronta para deploy completo
# Last Updated: 2025-11-02
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
VPS_PATH="/home/luiz.sena88/automation_1password"

# ============================================================================
# FUNÇÕES
# ============================================================================

check_vps_connectivity() {
    log_section "🔌 Verificando Conectividade VPS"
    
    if ssh -o ConnectTimeout=5 "${VPS_HOST}" "echo 'OK'" &>/dev/null; then
        log_success "Conexão SSH com ${VPS_HOST} funcional"
        return 0
    else
        log_error "Não foi possível conectar em ${VPS_HOST}"
        return 1
    fi
}

check_vps_prerequisites() {
    log_section "📋 Verificando Pré-requisitos VPS"
    
    local checks=0
    local passed=0
    
    # Docker
    if ssh "${VPS_HOST}" "docker --version" &>/dev/null; then
        log_success "Docker instalado"
        ((passed++))
    else
        log_error "Docker não instalado"
    fi
    ((checks++))
    
    # Docker Compose
    if ssh "${VPS_HOST}" "docker-compose --version" &>/dev/null; then
        log_success "Docker Compose instalado"
        ((passed++))
    else
        log_warning "Docker Compose não encontrado (pode usar 'docker compose')"
    fi
    ((checks++))
    
    # 1Password CLI
    if ssh "${VPS_HOST}" "op --version" &>/dev/null; then
        log_success "1Password CLI instalado"
        ((passed++))
    else
        log_warning "1Password CLI não instalado"
    fi
    ((checks++))
    
    # Git
    if ssh "${VPS_HOST}" "git --version" &>/dev/null; then
        log_success "Git instalado"
        ((passed++))
    else
        log_error "Git não instalado"
    fi
    ((checks++))
    
    # Espaço em disco
    local disk_avail=$(ssh "${VPS_HOST}" "df -h / | tail -1 | awk '{print \$4}'")
    log_info "Espaço disponível: ${disk_avail}"
    
    if [ ${passed} -eq ${checks} ]; then
        log_success "Todos os pré-requisitos atendidos"
        return 0
    else
        log_warning "${passed}/${checks} pré-requisitos atendidos"
        return 0  # Não falhar, apenas avisar
    fi
}

check_data_sync() {
    log_section "📊 Verificando Dados Sincronizados"
    
    local local_count=$(find "${REPO_ROOT}/dados" -type f 2>/dev/null | wc -l | tr -d ' ')
    local remote_count=$(ssh "${VPS_HOST}" "find ${VPS_PATH}/dados -type f 2>/dev/null | wc -l" | tr -d ' ')
    
    if [ "${local_count}" -eq "${remote_count}" ]; then
        log_success "${remote_count} arquivo(s) sincronizado(s)"
    else
        log_warning "Diferença: Local=${local_count}, VPS=${remote_count}"
    fi
    
    # Verificar arquivo principal
    if ssh "${VPS_HOST}" "test -f ${VPS_PATH}/dados/INVENTORY_REPORT.md"; then
        log_success "Inventory report presente na VPS"
    else
        log_error "Inventory report não encontrado na VPS"
        return 1
    fi
    
    return 0
}

check_prod_files() {
    log_section "📁 Verificando Arquivos de Produção"
    
    local files=(
        "deployment_plan.md"
        "vps_prerequisites_check.sh"
        "README.md"
    )
    
    local missing=0
    
    for file in "${files[@]}"; do
        if ssh "${VPS_HOST}" "test -f ${VPS_PATH}/prod/${file}"; then
            log_success "${file} presente"
        else
            log_error "${file} não encontrado"
            ((missing++))
        fi
    done
    
    if [ ${missing} -eq 0 ]; then
        return 0
    else
        log_warning "${missing} arquivo(s) faltando"
        return 1
    fi
}

check_docker_services() {
    log_section "🐳 Verificando Docker na VPS"
    
    # Verificar se Docker está rodando
    if ssh "${VPS_HOST}" "docker ps &>/dev/null"; then
        log_success "Docker está rodando"
        
        # Listar containers (se houver)
        local containers=$(ssh "${VPS_HOST}" "docker ps --format '{{.Names}}' 2>/dev/null | wc -l" | tr -d ' ')
        log_info "${containers} container(s) rodando"
    else
        log_error "Docker não está acessível"
        return 1
    fi
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "✅ Validação Final VPS - Pronto para Deploy"
    
    check_vps_connectivity || return 1
    echo ""
    
    check_vps_prerequisites
    echo ""
    
    check_data_sync || return 1
    echo ""
    
    check_prod_files || return 1
    echo ""
    
    check_docker_services || return 1
    echo ""
    
    log_section "📊 Resumo da Validação"
    log_success "✅ VPS está pronta para deploy!"
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar deployment plan:"
    echo "     ssh ${VPS_HOST} 'cat ${VPS_PATH}/prod/deployment_plan.md'"
    echo ""
    echo "  2. Verificar 1Password vault na VPS:"
    echo "     ssh ${VPS_HOST} 'op vault list'"
    echo ""
    echo "  3. Iniciar deploy seguindo o plano"
    
    return 0
}

main "$@"

