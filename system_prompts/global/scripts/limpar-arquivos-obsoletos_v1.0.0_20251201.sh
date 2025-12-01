#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🗑️ LIMPAR ARQUIVOS OBSOLETOS E REDUNDANTES
#
# Objetivo:
#   - Limpar arquivos e diretórios obsoletos identificados na auditoria
#   - Fazer backup antes de excluir
#   - Gerar relatório de limpeza
#
# Uso: ./limpar-arquivos-obsoletos_v1.0.0_20251201.sh [--vps] [--macos] [--all] [--dry-run]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="${GLOBAL_DIR}/logs/audit-obsoletos"
CLEANUP_REPORT="${REPORT_DIR}/limpeza-${TIMESTAMP}.md"
BACKUP_DIR="${HOME}/.cleanup-backup-${TIMESTAMP}"

# Flags
CLEAN_VPS=false
CLEAN_MACOS=false
CLEAN_ALL=false
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vps)
            CLEAN_VPS=true
            shift
            ;;
        --macos)
            CLEAN_MACOS=true
            shift
            ;;
        --all)
            CLEAN_ALL=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Se nenhuma flag, limpar tudo
if [[ "${CLEAN_VPS}" == "false" ]] && [[ "${CLEAN_MACOS}" == "false" ]]; then
    CLEAN_ALL=true
fi

if [[ "${CLEAN_ALL}" == "true" ]]; then
    CLEAN_VPS=true
    CLEAN_MACOS=true
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
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${CLEANUP_REPORT}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${CLEANUP_REPORT}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${CLEANUP_REPORT}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${CLEANUP_REPORT}"
}

log_section() {
    echo "" | tee -a "${CLEANUP_REPORT}"
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}" | tee -a "${CLEANUP_REPORT}"
    echo -e "${MAGENTA}║${NC} $@" | tee -a "${CLEANUP_REPORT}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}" | tee -a "${CLEANUP_REPORT}"
    echo "" | tee -a "${CLEANUP_REPORT}"
}

# Criar diretório de relatórios
mkdir -p "${REPORT_DIR}"

# ============================================================================
# LIMPEZA VPS UBUNTU
# ============================================================================

clean_vps() {
    log_section "LIMPEZA VPS UBUNTU"
    
    VPS_HOST="${VPS_HOST:-admin-vps}"
    VPS_USER="${VPS_USER:-admin}"
    VPS_HOME="${VPS_HOME:-/home/admin}"
    
    log_info "Conectando na VPS: ${VPS_USER}@${VPS_HOST}"
    
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_error "Não foi possível conectar na VPS"
        return 1
    fi
    
    log_info "Criando backup antes de limpar..."
    
    ssh "${VPS_USER}@${VPS_HOST}" << 'VPS_CLEAN_EOF' | tee -a "${CLEANUP_REPORT}"
        set -e
        VPS_HOME="${HOME}"
        BACKUP_DIR="${HOME}/.cleanup-backup-$(date +%Y%m%d_%H%M%S)"
        DRY_RUN="${DRY_RUN:-false}"
        
        mkdir -p "${BACKUP_DIR}"
        
        echo "## Itens para Limpeza na VPS:"
        echo ""
        
        # Diretórios legacy/backup
        ITEMS_TO_CLEAN=(
            "${VPS_HOME}/legacy"
            "${VPS_HOME}/backups"
            "${VPS_HOME}/infra-vps/legacy"
            "${VPS_HOME}/.audit"
        )
        
        for item in "${ITEMS_TO_CLEAN[@]}"; do
            if [ -e "${item}" ]; then
                SIZE=$(du -sh "${item}" 2>/dev/null | awk '{print $1}')
                echo "  - ${item} (${SIZE})"
                
                if [ "${DRY_RUN}" != "true" ]; then
                    # Fazer backup
                    cp -r "${item}" "${BACKUP_DIR}/" 2>/dev/null || true
                    # Excluir
                    rm -rf "${item}"
                    echo "    ✅ Removido (backup em ${BACKUP_DIR})"
                else
                    echo "    [DRY-RUN] Seria removido"
                fi
            fi
        done
        
        # Arquivos de backup
        echo ""
        echo "## Arquivos de Backup:"
        echo ""
        
        find "${VPS_HOME}" -maxdepth 3 -type f \( -name "*.bak" -o -name "*.old" -o -name "*.tmp" -o -name "*~" -o -name "*backup*" \) 2>/dev/null | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
            
            if [ "${DRY_RUN}" != "true" ]; then
                mkdir -p "${BACKUP_DIR}/files"
                cp "${file}" "${BACKUP_DIR}/files/" 2>/dev/null || true
                rm -f "${file}"
                echo "    ✅ Removido"
            else
                echo "    [DRY-RUN] Seria removido"
            fi
        done
        
        # Cache antigo (> 30 dias)
        echo ""
        echo "## Cache Antigo (> 30 dias):"
        echo ""
        
        CACHE_COUNT=$(find "${VPS_HOME}/.cache" -type f -mtime +30 2>/dev/null | wc -l)
        if [ "${CACHE_COUNT}" -gt 0 ]; then
            echo "  - ${CACHE_COUNT} arquivos em .cache"
            if [ "${DRY_RUN}" != "true" ]; then
                find "${VPS_HOME}/.cache" -type f -mtime +30 -delete 2>/dev/null || true
                echo "    ✅ Limpo"
            else
                echo "    [DRY-RUN] Seria limpo"
            fi
        fi
        
        echo ""
        echo "Backup criado em: ${BACKUP_DIR}"
VPS_CLEAN_EOF
    
    log_success "Limpeza VPS concluída"
}

# ============================================================================
# LIMPEZA macOS SILICON
# ============================================================================

clean_macos() {
    log_section "LIMPEZA macOS SILICON"
    
    log_info "Criando backup antes de limpar..."
    mkdir -p "${BACKUP_DIR}"
    
    {
        echo "## Itens para Limpeza no macOS:"
        echo ""
        
        # Diretórios obsoletos
        ITEMS_TO_CLEAN=(
            "${DOTFILES_DIR}/infra-vps/legacy"
            "${DOTFILES_DIR}/.backup_20251106_140126"
            "${DOTFILES_DIR}/.backup_configs_20251106_190154"
            "${DOTFILES_DIR}/.backup_cursorrules_20251106_183038"
            "${DOTFILES_DIR}/.backup_cursorrules_20251106_190155"
            "${DOTFILES_DIR}/.backup_paths_20251106_183035"
            "${DOTFILES_DIR}/.backup_paths_20251106_183053"
            "${DOTFILES_DIR}/system_prompts/global/prompts_temp"
            "${DOTFILES_DIR}/system_prompts/global/scripts/legacy"
            "${DOTFILES_DIR}/automation_1password/compose/n8n-ai-starter"
            "${DOTFILES_DIR}/cursor/awesome-cursorrules"
            "${DOTFILES_DIR}/cursor/claude-task-master"
            "${DOTFILES_DIR}/cursor/system-prompts-and-models-of-ai-tools"
            "${DOTFILES_DIR}/gemini"
            "${DOTFILES_DIR}/codex"
            "${DOTFILES_DIR}/infraestrutura-vps"
        )
        
        for item in "${ITEMS_TO_CLEAN[@]}"; do
            if [ -e "${item}" ]; then
                SIZE=$(du -sh "${item}" 2>/dev/null | awk '{print $1}')
                echo "  - ${item} (${SIZE})"
                
                if [[ "${DRY_RUN}" != "true" ]]; then
                    # Fazer backup
                    cp -r "${item}" "${BACKUP_DIR}/" 2>/dev/null || true
                    # Excluir
                    rm -rf "${item}"
                    echo "    ✅ Removido (backup em ${BACKUP_DIR})"
                else
                    echo "    [DRY-RUN] Seria removido"
                fi
            fi
        done
        
        # Arquivos de backup
        echo ""
        echo "## Arquivos de Backup:"
        echo ""
        
        find "${DOTFILES_DIR}" -maxdepth 4 -type f \( -name "*.bak" -o -name "*.old" -o -name "*.tmp" -o -name "*~" -o -name "*backup*" \) 2>/dev/null | head -20 | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
            
            if [[ "${DRY_RUN}" != "true" ]]; then
                mkdir -p "${BACKUP_DIR}/files"
                cp "${file}" "${BACKUP_DIR}/files/" 2>/dev/null || true
                rm -f "${file}"
                echo "    ✅ Removido"
            else
                echo "    [DRY-RUN] Seria removido"
            fi
        done
        
        # Arquivos OBSOLETO
        echo ""
        echo "## Arquivos Marcados como OBSOLETO:"
        echo ""
        
        find "${DOTFILES_DIR}" -maxdepth 4 -type f -iname "*OBSOLETO*" 2>/dev/null | while read file; do
            SIZE=$(du -h "${file}" 2>/dev/null | awk '{print $1}')
            echo "  - ${file} (${SIZE})"
            
            if [[ "${DRY_RUN}" != "true" ]]; then
                mkdir -p "${BACKUP_DIR}/obsoleto"
                cp "${file}" "${BACKUP_DIR}/obsoleto/" 2>/dev/null || true
                rm -f "${file}"
                echo "    ✅ Removido"
            else
                echo "    [DRY-RUN] Seria removido"
            fi
        done
        
        echo ""
        echo "Backup criado em: ${BACKUP_DIR}"
        
    } | tee -a "${CLEANUP_REPORT}"
    
    log_success "Limpeza macOS concluída"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  LIMPEZA DE ARQUIVOS OBSOLETOS E REDUNDANTES             ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "MODO DRY-RUN: Nenhuma alteração será feita"
        echo ""
    fi
    
    log_info "Iniciando limpeza..."
    log_info "Relatório será salvo em: ${CLEANUP_REPORT}"
    log_info "Backup será criado em: ${BACKUP_DIR}"
    echo ""
    
    # Cabeçalho do relatório
    {
        echo "# 🗑️ Relatório de Limpeza - Arquivos Obsoletos"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo "**Modo:** $([ "${DRY_RUN}" == "true" ] && echo "DRY-RUN" || echo "EXECUÇÃO")"
        echo ""
        echo "---"
        echo ""
    } > "${CLEANUP_REPORT}"
    
    if [[ "${CLEAN_VPS}" == "true" ]]; then
        clean_vps
    fi
    
    if [[ "${CLEAN_MACOS}" == "true" ]]; then
        clean_macos
    fi
    
    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  LIMPEZA CONCLUÍDA                                        ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    log_info "Relatório completo: ${CLEANUP_REPORT}"
    log_info "Backup criado em: ${BACKUP_DIR}"
    echo ""
}

main "$@"

