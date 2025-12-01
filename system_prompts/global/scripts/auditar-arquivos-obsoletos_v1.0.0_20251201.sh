#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🗑️ AUDITAR ARQUIVOS OBSOLETOS E REDUNDANTES
#
# Objetivo:
#   - Identificar arquivos e diretórios obsoletos na VPS Ubuntu e macOS Silicon
#   - Gerar relatório de limpeza
#   - Criar lista de arquivos para exclusão
#
# Uso: ./auditar-arquivos-obsoletos_v1.0.0_20251201.sh [--vps] [--macos] [--all]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="${GLOBAL_DIR}/logs/audit-obsoletos"
REPORT_FILE="${REPORT_DIR}/relatorio-obsoletos-${TIMESTAMP}.md"

# Flags
AUDIT_VPS=false
AUDIT_MACOS=false
AUDIT_ALL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vps)
            AUDIT_VPS=true
            shift
            ;;
        --macos)
            AUDIT_MACOS=true
            shift
            ;;
        --all)
            AUDIT_ALL=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Se nenhuma flag, auditar tudo
if [[ "${AUDIT_VPS}" == "false" ]] && [[ "${AUDIT_MACOS}" == "false" ]]; then
    AUDIT_ALL=true
fi

if [[ "${AUDIT_ALL}" == "true" ]]; then
    AUDIT_VPS=true
    AUDIT_MACOS=true
fi

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${REPORT_FILE}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${REPORT_FILE}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${REPORT_FILE}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${REPORT_FILE}"
}

log_section() {
    echo "" | tee -a "${REPORT_FILE}"
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}" | tee -a "${REPORT_FILE}"
    echo -e "${MAGENTA}║${NC} $@" | tee -a "${REPORT_FILE}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}" | tee -a "${REPORT_FILE}"
    echo "" | tee -a "${REPORT_FILE}"
}

# Criar diretório de relatórios
mkdir -p "${REPORT_DIR}"

# Padrões de arquivos obsoletos
OBSOLETE_PATTERNS=(
    "*.bak"
    "*.old"
    "*.tmp"
    "*~"
    "*.swp"
    "*.swo"
    "*backup*"
    "*legacy*"
    "*obsoleto*"
    "*OBSOLETO*"
    "*LEGACY*"
    "*BACKUP*"
    "*temp*"
    "*TEMP*"
    "*.log"
    "*.cache"
)

# Diretórios obsoletos conhecidos
OBSOLETE_DIRS=(
    "legacy"
    "backups"
    "backup"
    "old"
    "temp"
    "tmp"
    ".audit"
    ".cache"
    "obsoleto"
    "OBSOLETO"
    "LEGACY"
    "BACKUP"
)

# ============================================================================
# AUDITORIA VPS UBUNTU
# ============================================================================

audit_vps() {
    log_section "AUDITORIA VPS UBUNTU"

    VPS_HOST="${VPS_HOST:-admin-vps}"
    VPS_USER="${VPS_USER:-admin}"
    VPS_HOME="${VPS_HOME:-/home/admin}"

    log_info "Conectando na VPS: ${VPS_USER}@${VPS_HOST}"

    # Verificar conexão
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_error "Não foi possível conectar na VPS"
        return 1
    fi

    log_info "Analisando diretórios obsoletos..."

    # Encontrar diretórios obsoletos
    ssh "${VPS_USER}@${VPS_HOST}" << 'VPS_AUDIT_EOF' | tee -a "${REPORT_FILE}"
        set -e
        VPS_HOME="${HOME}"

        echo "## Diretórios Obsoletos Encontrados:"
        echo ""

        # Diretórios legacy/backup
        for dir in legacy backups backup old temp tmp .audit obsoleto OBSOLETO LEGACY BACKUP; do
            if [ -d "${VPS_HOME}/${dir}" ] || [ -d "${VPS_HOME}/infra-vps/${dir}" ]; then
                if [ -d "${VPS_HOME}/${dir}" ]; then
                    SIZE=$(du -sh "${VPS_HOME}/${dir}" 2>/dev/null | awk '{print $1}')
                    echo "  - ${VPS_HOME}/${dir} (${SIZE})"
                fi
                if [ -d "${VPS_HOME}/infra-vps/${dir}" ]; then
                    SIZE=$(du -sh "${VPS_HOME}/infra-vps/${dir}" 2>/dev/null | awk '{print $1}')
                    echo "  - ${VPS_HOME}/infra-vps/${dir} (${SIZE})"
                fi
            fi
        done

        echo ""
        echo "## Arquivos de Backup Encontrados:"
        echo ""

        # Arquivos .bak, .old, etc
        find "${VPS_HOME}" -maxdepth 3 -type f \( -name "*.bak" -o -name "*.old" -o -name "*.tmp" -o -name "*~" -o -name "*backup*" \) 2>/dev/null | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
        done

        echo ""
        echo "## Arquivos OBSOLETO/LEGACY Encontrados:"
        echo ""

        find "${VPS_HOME}" -maxdepth 3 -type f -iname "*OBSOLETO*" -o -iname "*LEGACY*" 2>/dev/null | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
        done

        echo ""
        echo "## Cache e Logs Antigos:"
        echo ""

        # Cache antigo (> 30 dias)
        find "${VPS_HOME}/.cache" -type f -mtime +30 2>/dev/null | wc -l | xargs -I {} echo "  - Arquivos em .cache com mais de 30 dias: {}"

        # Logs antigos
        find "${VPS_HOME}" -maxdepth 3 -type f -name "*.log" -mtime +30 2>/dev/null | wc -l | xargs -I {} echo "  - Arquivos .log com mais de 30 dias: {}"
VPS_AUDIT_EOF

    log_success "Auditoria VPS concluída"
}

# ============================================================================
# AUDITORIA macOS SILICON
# ============================================================================

audit_macos() {
    log_section "AUDITORIA macOS SILICON"

    log_info "Analisando diretórios obsoletos no macOS..."

    # Encontrar diretórios obsoletos
    {
        echo "## Diretórios Obsoletos Encontrados:"
        echo ""

        # Diretórios legacy/backup no Dotfiles
        for dir in "${OBSOLETE_DIRS[@]}"; do
            if [ -d "${DOTFILES_DIR}/${dir}" ]; then
                SIZE=$(du -sh "${DOTFILES_DIR}/${dir}" 2>/dev/null | awk '{print $1}')
                echo "  - ${DOTFILES_DIR}/${dir} (${SIZE})"
            fi

            # Verificar em subdiretórios
            find "${DOTFILES_DIR}" -maxdepth 3 -type d -name "${dir}" 2>/dev/null | while read found_dir; do
                SIZE=$(du -sh "${found_dir}" 2>/dev/null | awk '{print $1}')
                echo "  - ${found_dir} (${SIZE})"
            done
        done

        echo ""
        echo "## Arquivos de Backup Encontrados:"
        echo ""

        # Arquivos .bak, .old, etc
        find "${DOTFILES_DIR}" -maxdepth 4 -type f \( -name "*.bak" -o -name "*.old" -o -name "*.tmp" -o -name "*~" -o -name "*backup*" \) 2>/dev/null | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
        done

        echo ""
        echo "## Arquivos OBSOLETO/LEGACY Encontrados:"
        echo ""

        find "${DOTFILES_DIR}" -maxdepth 4 -type f \( -iname "*OBSOLETO*" -o -iname "*LEGACY*" \) 2>/dev/null | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
        done

        echo ""
        echo "## Diretórios Não Versionados (Git):"
        echo ""

        cd "${DOTFILES_DIR}"
        git status --porcelain 2>/dev/null | grep "^??" | head -20 | while read line; do
            FILE=$(echo "${line}" | awk '{print $2}')
            if [ -f "${FILE}" ]; then
                SIZE=$(du -h "${FILE}" 2>/dev/null | awk '{print $1}')
                echo "  - ${FILE} (${SIZE})"
            fi
        done

    } | tee -a "${REPORT_FILE}"

    log_success "Auditoria macOS concluída"
}

# ============================================================================
# GERAR RESUMO E RECOMENDAÇÕES
# ============================================================================

generate_summary() {
    log_section "RESUMO E RECOMENDAÇÕES"

    {
        echo "## 📊 Resumo da Auditoria"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        echo "### Diretórios para Revisão:"
        echo ""
        echo "1. **VPS Ubuntu:**"
        echo "   - \`~/legacy/\` - Diretório legacy"
        echo "   - \`~/backups/\` - Backups antigos"
        echo "   - \`~/.audit/\` - Logs de auditoria antigos"
        echo "   - \`~/infra-vps/legacy/\` - Legacy do infra-vps"
        echo ""
        echo "2. **macOS Silicon:**"
        echo "   - \`~/Dotfiles/infra-vps/legacy/\` - Legacy do infra-vps"
        echo "   - Arquivos não versionados no Git"
        echo "   - Cache e logs antigos"
        echo ""
        echo "### Recomendações:"
        echo ""
        echo "1. **Revisar antes de excluir:**"
        echo "   - Verificar se há conteúdo importante em diretórios legacy"
        echo "   - Confirmar que backups não são mais necessários"
        echo "   - Validar que arquivos obsoletos não são referenciados"
        echo ""
        echo "2. **Limpar com segurança:**"
        echo "   - Fazer backup antes de excluir"
        echo "   - Usar script de limpeza automática"
        echo "   - Validar após limpeza"
        echo ""
        echo "3. **Manter organizado:**"
        echo "   - Adicionar ao .gitignore"
        echo "   - Documentar exclusões"
        echo "   - Criar rotina de limpeza periódica"
        echo ""

    } | tee -a "${REPORT_FILE}"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  AUDITORIA DE ARQUIVOS OBSOLETOS E REDUNDANTES          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_info "Iniciando auditoria..."
    log_info "Relatório será salvo em: ${REPORT_FILE}"
    echo ""

    # Cabeçalho do relatório
    {
        echo "# 🗑️ Relatório de Auditoria - Arquivos Obsoletos"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo ""
        echo "---"
        echo ""
    } > "${REPORT_FILE}"

    if [[ "${AUDIT_VPS}" == "true" ]]; then
        audit_vps
    fi

    if [[ "${AUDIT_MACOS}" == "true" ]]; then
        audit_macos
    fi

    generate_summary

    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  AUDITORIA CONCLUÍDA                                      ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    log_info "Relatório completo: ${REPORT_FILE}"
    log_info "Próximo passo: Revisar relatório e executar limpeza"
    echo ""
}

main "$@"
