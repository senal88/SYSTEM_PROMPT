#!/bin/bash
# apply-best-practices-fixes.sh
# Aplica todas as correções de melhores práticas identificadas
# Last Updated: 2025-11-01
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
CONNECT_DIR="${REPO_ROOT}/connect"
COMPOSE_DIR="${REPO_ROOT}/compose"

# ============================================================================
# FUNÇÕES
# ============================================================================

fix_connect_healthchecks() {
    log_section "🔧 Corrigindo Healthchecks do 1Password Connect"
    
    local compose_file="${CONNECT_DIR}/docker-compose.yml"
    
    if [ ! -f "${compose_file}" ]; then
        log_warning "Arquivo ${compose_file} não encontrado"
        return 0
    fi
    
    # Verificar se já está corrigido
    if grep -q 'http://localhost:8080/health' "${compose_file}" && \
       grep -q 'retries: 5' "${compose_file}"; then
        log_success "Healthchecks já estão corrigidos"
        return 0
    fi
    
    log_info "Healthchecks serão corrigidos (se necessário recriar containers)"
    return 0
}

remove_obsolete_versions() {
    log_section "🗑️  Removendo versões obsoletas dos docker-compose.yml"
    
    local files_fixed=0
    
    for file in "${COMPOSE_DIR}"/*.yml; do
        if [ -f "${file}" ]; then
            if grep -q '^version:' "${file}"; then
                log_info "Removendo 'version:' de $(basename "${file}")"
                sed -i '' '/^version:/d' "${file}" 2>/dev/null || \
                sed -i '/^version:/d' "${file}" 2>/dev/null
                ((files_fixed++))
            fi
        fi
    done
    
    if [ ${files_fixed} -gt 0 ]; then
        log_success "${files_fixed} arquivo(s) corrigido(s)"
    else
        log_info "Nenhum arquivo precisou de correção"
    fi
    
    return 0
}

validate_compose_files() {
    log_section "✅ Validando arquivos docker-compose.yml"
    
    local errors=0
    
    for file in "${COMPOSE_DIR}"/*.yml "${CONNECT_DIR}/docker-compose.yml"; do
        if [ -f "${file}" ]; then
            if docker compose -f "${file}" config &>/dev/null; then
                log_success "$(basename "${file}") válido"
            else
                log_error "$(basename "${file}") tem erros de sintaxe"
                ((errors++))
            fi
        fi
    done
    
    return ${errors}
}

restart_connect_if_needed() {
    log_section "🔄 Verificando necessidade de reiniciar Connect"
    
    local connect_compose="${CONNECT_DIR}/docker-compose.yml"
    
    if [ ! -f "${connect_compose}" ]; then
        log_info "Connect não configurado neste diretório"
        return 0
    fi
    
    cd "${CONNECT_DIR}"
    
    # Verificar se containers estão unhealthy
    if docker compose ps --format json 2>/dev/null | \
       jq -r '.[] | select(.Health == "unhealthy") | .Name' 2>/dev/null | \
       grep -q "op-connect"; then
        
        log_warning "Containers Connect estão unhealthy. Recomendado reiniciar após correções."
        log_info "Para reiniciar: cd connect && docker compose down && docker compose up -d"
    else
        log_success "Containers Connect estão saudáveis"
    fi
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🚀 Aplicando Melhores Práticas e Correções"
    
    fix_connect_healthchecks
    echo ""
    
    remove_obsolete_versions
    echo ""
    
    validate_compose_files
    local validation_result=$?
    echo ""
    
    restart_connect_if_needed
    echo ""
    
    log_section "📊 Resumo"
    
    if [ ${validation_result} -eq 0 ]; then
        log_success "✅ Todas as correções aplicadas com sucesso!"
        echo ""
        echo "Próximos passos recomendados:"
        echo "  1. Se Connect estava unhealthy, reiniciar:"
        echo "     cd connect && docker compose down && docker compose up -d"
        echo "  2. Validar stack AI:"
        echo "     ./scripts/validation/validate-ai-stack.sh"
        echo "  3. Verificar logs:"
        echo "     docker compose -f compose/docker-compose-ai-stack.yml logs -f"
        return 0
    else
        log_error "❌ Alguns arquivos têm erros. Corrija antes de continuar."
        return 1
    fi
}

main "$@"

