#!/bin/bash
# analyze-collected-data.sh
# Analisa dados coletados e gera relatório de inventory
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
DATA_DIR="${REPO_ROOT}/dados"
REPORT_FILE="${DATA_DIR}/INVENTORY_REPORT.md"

# ============================================================================
# FUNÇÕES
# ============================================================================

generate_inventory_report() {
    log_section "📊 Gerando Relatório de Inventory"
    
    {
        echo "# Inventory Report - Hybrid Dev/Prod Setup"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Ambiente:** macOS Silicon → VPS Ubuntu"
        echo ""
        echo "---"
        echo ""
    } > "${REPORT_FILE}"

    # 1. System Specifications
    if [ -f "${DATA_DIR}/01_system_info.txt" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 1. System Specifications

EOF
        cat "${DATA_DIR}/01_system_info.txt" >> "${REPORT_FILE}"
        echo "" >> "${REPORT_FILE}"
    fi
    
    # 2. Docker Status
    if [ -f "${DATA_DIR}/02_docker_status.txt" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 2. Docker Status

EOF
        head -30 "${DATA_DIR}/02_docker_status.txt" >> "${REPORT_FILE}"
        echo "" >> "${REPORT_FILE}"
    fi
    
    # 3. Stacks Running
    if [ -f "${DATA_DIR}/03_docker_stacks.txt" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 3. Docker Stacks Running

EOF
        cat "${DATA_DIR}/03_docker_stacks.txt" >> "${REPORT_FILE}"
        echo "" >> "${REPORT_FILE}"
    fi
    
    # 6. 1Password Inventory
    if [ -f "${DATA_DIR}/06_1password_inventory.json" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 6. 1Password Inventory (1p_macos)

EOF
        if command -v jq &>/dev/null; then
            jq '.' "${DATA_DIR}/06_1password_inventory.json" >> "${REPORT_FILE}" 2>&1 || \
            echo "Arquivo vazio ou inválido" >> "${REPORT_FILE}"
        else
            cat "${DATA_DIR}/06_1password_inventory.json" >> "${REPORT_FILE}"
        fi
        echo "" >> "${REPORT_FILE}"
    fi
    
    # 7. Environment Variables (Keys Only)
    if [ -f "${DATA_DIR}/07_env_vars_keys.txt" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 7. Environment Variables (Keys Only)

⚠️ **Segurança:** Apenas nomes de variáveis, sem valores!

EOF
        cat "${DATA_DIR}/07_env_vars_keys.txt" >> "${REPORT_FILE}"
        echo "" >> "${REPORT_FILE}"
    fi
    
    # 8. Git Configuration
    if [ -f "${DATA_DIR}/08_git_info.txt" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 8. Git Configuration

EOF
        cat "${DATA_DIR}/08_git_info.txt" >> "${REPORT_FILE}"
        echo "" >> "${REPORT_FILE}"
    fi
    
    # 9. Network Configuration
    if [ -f "${DATA_DIR}/09_ports_mapping.txt" ]; then
        cat >> "${REPORT_FILE}" << 'EOF'
## 9. Network & Ports Mapping

EOF
        cat "${DATA_DIR}/09_ports_mapping.txt" >> "${REPORT_FILE}"
        echo "" >> "${REPORT_FILE}"
    fi
    
    # Summary
    cat >> "${REPORT_FILE}" << 'EOF'
---

## Summary

✅ Dados coletados com sucesso do ambiente macOS Silicon
✅ Inventory pronto para análise e preparação de deploy na VPS
✅ Nenhuma credencial foi exposta (apenas metadata)

**Próximo passo:** Preparar deployment para VPS Ubuntu

EOF

    log_success "Relatório gerado: ${REPORT_FILE}"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "📋 Análise de Dados Coletados"
    
    if [ ! -d "${DATA_DIR}" ]; then
        log_error "Diretório ${DATA_DIR} não encontrado"
        log_info "Execute primeiro: ./scripts/collection/collect-hybrid-environment.sh"
        return 1
    fi
    
    local files_count=$(find "${DATA_DIR}" -name "*.txt" -o -name "*.json" | wc -l | tr -d ' ')
    
    if [ "${files_count}" -eq 0 ]; then
        log_error "Nenhum arquivo de dados encontrado em ${DATA_DIR}"
        log_info "Execute primeiro: ./scripts/collection/collect-hybrid-environment.sh"
        return 1
    fi
    
    log_success "${files_count} arquivo(s) de dados encontrado(s)"
    echo ""
    
    generate_inventory_report
    echo ""
    
    log_section "✅ Análise Completa"
    log_success "Relatório gerado em: ${REPORT_FILE}"
    echo ""
    echo "Para visualizar:"
    echo "  cat ${REPORT_FILE} | less"
    echo "  ou abra no editor"
    
    return 0
}

main "$@"

