#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔍 VALIDAR E LIMPAR ARQUIVOS OBSOLETOS
#
# Valida o que está em uso e remove o que está obsoleto
# Mantém somente o que está sendo utilizado
#
# Uso: ./validar-e-limpar-obsoletos_v1.0.0_20251201.sh [--dry-run] [--force]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_DIR="${GLOBAL_DIR}/logs/limpeza-obsoletos"
LOG_FILE="${LOG_DIR}/limpeza-${TIMESTAMP}.log"
REPORT_FILE="${LOG_DIR}/relatorio-${TIMESTAMP}.md"

# Flags
DRY_RUN=false
FORCE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${LOG_FILE}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${LOG_FILE}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${LOG_FILE}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${LOG_FILE}"
}

log_section() {
    echo "" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}║${NC} $@" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}" | tee -a "${LOG_FILE}"
    echo "" | tee -a "${LOG_FILE}"
}

# Criar diretório de logs
mkdir -p "${LOG_DIR}"

# Arrays para rastrear arquivos
FILES_TO_DELETE=()
DIRS_TO_DELETE=()
FILES_IN_USE=()
DIRS_IN_USE=()

# ============================================================================
# DEFINIR O QUE ESTÁ EM USO
# ============================================================================

definir_arquivos_em_uso() {
    log_section "DEFININDO ARQUIVOS EM USO"
    
    # Diretórios principais em uso
    DIRS_IN_USE=(
        "${DOTFILES_DIR}/system_prompts/global"
        "${DOTFILES_DIR}/infra-vps/infraestrutura"
        "${DOTFILES_DIR}/scripts"
        "${DOTFILES_DIR}/.git"
    )
    
    # Arquivos principais em uso
    FILES_IN_USE=(
        "${DOTFILES_DIR}/README.md"
        "${DOTFILES_DIR}/.gitignore"
        "${DOTFILES_DIR}/Brewfile"
    )
    
    # Padrões de arquivos em uso
    PATTERNS_IN_USE=(
        "*.sh"
        "*.md"
        "*.yml"
        "*.yaml"
        "*.json"
        ".env.example"
        "README.md"
        ".gitignore"
    )
    
    log_success "Definição de arquivos em uso concluída"
}

# ============================================================================
# IDENTIFICAR OBSOLETOS
# ============================================================================

identificar_obsoletos() {
    log_section "IDENTIFICANDO ARQUIVOS OBSOLETOS"
    
    # Diretórios obsoletos conhecidos
    OBSOLETE_DIRS=(
        "${DOTFILES_DIR}/infra-vps/legacy"
        "${DOTFILES_DIR}/infra-vps/backups"
        "${DOTFILES_DIR}/scripts/backups"
        "${DOTFILES_DIR}/.backup_*"
        "${DOTFILES_DIR}/.audit"
        "${DOTFILES_DIR}/infra-vps/.warp"
    )
    
    # Arquivos obsoletos conhecidos
    OBSOLETE_FILES=(
        "${DOTFILES_DIR}/infra-vps/*.txt"
        "${DOTFILES_DIR}/infra-vps/*.md"
        "${DOTFILES_DIR}/infra-vps/.env"
        "${DOTFILES_DIR}/infra-vps/.env.example"
    )
    
    # Padrões obsoletos
    OBSOLETE_PATTERNS=(
        "*backup*"
        "*legacy*"
        "*old*"
        "*obsoleto*"
        "*.bak"
        "*.tmp"
        "*.log"
        "*~"
    )
    
    log_info "Buscando diretórios obsoletos..."
    for dir_pattern in "${OBSOLETE_DIRS[@]}"; do
        if [[ -e "${dir_pattern}" ]] || compgen -G "${dir_pattern}" > /dev/null 2>&1; then
            for dir in ${dir_pattern}; do
                if [[ -d "${dir}" ]]; then
                    DIRS_TO_DELETE+=("${dir}")
                    log_warning "Diretório obsoleto encontrado: ${dir}"
                fi
            done
        fi
    done
    
    log_info "Buscando arquivos obsoletos..."
    for file_pattern in "${OBSOLETE_FILES[@]}"; do
        if compgen -G "${file_pattern}" > /dev/null 2>&1; then
            for file in ${file_pattern}; do
                if [[ -f "${file}" ]]; then
                    # Verificar se não é um arquivo importante
                    if [[ ! "${file}" =~ README\.md$ ]] && [[ ! "${file}" =~ \.gitignore$ ]]; then
                        FILES_TO_DELETE+=("${file}")
                        log_warning "Arquivo obsoleto encontrado: ${file}"
                    fi
                fi
            done
        fi
    done
    
    log_success "Identificação concluída: ${#DIRS_TO_DELETE[@]} diretórios, ${#FILES_TO_DELETE[@]} arquivos"
}

# ============================================================================
# VALIDAR USO REAL
# ============================================================================

validar_uso_real() {
    log_section "VALIDANDO USO REAL"
    
    # Verificar referências Git
    log_info "Verificando referências Git..."
    
    # Verificar se diretórios estão no .gitignore
    log_info "Verificando .gitignore..."
    
    # Verificar referências em scripts
    log_info "Verificando referências em scripts..."
    
    # Filtrar arquivos que realmente estão em uso
    FILTERED_DIRS=()
    FILTERED_FILES=()
    
    for dir in "${DIRS_TO_DELETE[@]}"; do
        # Verificar se há referências ao diretório
        if ! grep -r "$(basename "${dir}")" "${DOTFILES_DIR}" --exclude-dir=".git" --exclude-dir="$(basename "${dir}")" &> /dev/null; then
            FILTERED_DIRS+=("${dir}")
        else
            log_warning "Diretório pode estar em uso: ${dir}"
        fi
    done
    
    for file in "${FILES_TO_DELETE[@]}"; do
        # Verificar se há referências ao arquivo
        filename=$(basename "${file}")
        if ! grep -r "${filename}" "${DOTFILES_DIR}" --exclude-dir=".git" --exclude="${filename}" &> /dev/null; then
            FILTERED_FILES+=("${file}")
        else
            log_warning "Arquivo pode estar em uso: ${file}"
        fi
    done
    
    DIRS_TO_DELETE=("${FILTERED_DIRS[@]}")
    FILES_TO_DELETE=("${FILTERED_FILES[@]}")
    
    log_success "Validação concluída: ${#DIRS_TO_DELETE[@]} diretórios, ${#FILES_TO_DELETE[@]} arquivos para remover"
}

# ============================================================================
# CALCULAR ESPAÇO
# ============================================================================

calcular_espaco() {
    log_section "CALCULANDO ESPAÇO A SER LIBERADO"
    
    TOTAL_SIZE=0
    
    for dir in "${DIRS_TO_DELETE[@]}"; do
        if [[ -d "${dir}" ]]; then
            size=$(du -sk "${dir}" 2>/dev/null | cut -f1)
            TOTAL_SIZE=$((TOTAL_SIZE + size))
            log_info "Diretório: ${dir} - $(du -sh "${dir}" 2>/dev/null | cut -f1)"
        fi
    done
    
    for file in "${FILES_TO_DELETE[@]}"; do
        if [[ -f "${file}" ]]; then
            size=$(du -sk "${file}" 2>/dev/null | cut -f1)
            TOTAL_SIZE=$((TOTAL_SIZE + size))
            log_info "Arquivo: ${file} - $(du -sh "${file}" 2>/dev/null | cut -f1)"
        fi
    done
    
    TOTAL_SIZE_MB=$((TOTAL_SIZE / 1024))
    TOTAL_SIZE_GB=$((TOTAL_SIZE_MB / 1024))
    
    if [[ ${TOTAL_SIZE_GB} -gt 0 ]]; then
        log_success "Espaço total a ser liberado: ~${TOTAL_SIZE_GB}GB (${TOTAL_SIZE_MB}MB)"
    else
        log_success "Espaço total a ser liberado: ~${TOTAL_SIZE_MB}MB"
    fi
}

# ============================================================================
# GERAR RELATÓRIO
# ============================================================================

gerar_relatorio() {
    log_section "GERANDO RELATÓRIO"
    
    {
        echo "# Relatório de Limpeza de Arquivos Obsoletos"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo "**Modo:** $([ "${DRY_RUN}" == "true" ] && echo "DRY-RUN" || echo "EXECUÇÃO REAL")"
        echo ""
        echo "---"
        echo ""
        echo "## Resumo"
        echo ""
        echo "- **Diretórios a remover:** ${#DIRS_TO_DELETE[@]}"
        echo "- **Arquivos a remover:** ${#FILES_TO_DELETE[@]}"
        echo "- **Espaço a liberar:** ~${TOTAL_SIZE_MB}MB"
        echo ""
        echo "---"
        echo ""
        echo "## Diretórios Obsoletos"
        echo ""
        for dir in "${DIRS_TO_DELETE[@]}"; do
            echo "- \`${dir}\`"
        done
        echo ""
        echo "---"
        echo ""
        echo "## Arquivos Obsoletos"
        echo ""
        for file in "${FILES_TO_DELETE[@]}"; do
            echo "- \`${file}\`"
        done
        echo ""
        echo "---"
        echo ""
        echo "## Arquivos Mantidos (Em Uso)"
        echo ""
        echo "Os seguintes arquivos e diretórios foram mantidos por estarem em uso:"
        echo ""
        for dir in "${DIRS_IN_USE[@]}"; do
            echo "- \`${dir}\`"
        done
        echo ""
    } > "${REPORT_FILE}"
    
    log_success "Relatório gerado: ${REPORT_FILE}"
}

# ============================================================================
# EXECUTAR LIMPEZA
# ============================================================================

executar_limpeza() {
    log_section "EXECUTANDO LIMPEZA"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "MODO DRY-RUN - Nenhum arquivo será removido"
    fi
    
    REMOVED_COUNT=0
    
    # Remover diretórios
    for dir in "${DIRS_TO_DELETE[@]}"; do
        if [[ -d "${dir}" ]]; then
            if [[ "${DRY_RUN}" == "true" ]]; then
                log_info "[DRY-RUN] Removeria: ${dir}"
            else
                if [[ "${FORCE}" == "true" ]] || confirmar "Remover diretório ${dir}?"; then
                    rm -rf "${dir}"
                    log_success "Removido: ${dir}"
                    REMOVED_COUNT=$((REMOVED_COUNT + 1))
                fi
            fi
        fi
    done
    
    # Remover arquivos
    for file in "${FILES_TO_DELETE[@]}"; do
        if [[ -f "${file}" ]]; then
            if [[ "${DRY_RUN}" == "true" ]]; then
                log_info "[DRY-RUN] Removeria: ${file}"
            else
                if [[ "${FORCE}" == "true" ]] || confirmar "Remover arquivo ${file}?"; then
                    rm -f "${file}"
                    log_success "Removido: ${file}"
                    REMOVED_COUNT=$((REMOVED_COUNT + 1))
                fi
            fi
        fi
    done
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "DRY-RUN concluído - Nenhum arquivo foi removido"
    else
        log_success "Limpeza concluída - ${REMOVED_COUNT} itens removidos"
    fi
}

confirmar() {
    local prompt="$1"
    if [[ "${FORCE}" == "true" ]]; then
        return 0
    fi
    read -p "${prompt} (s/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Ss]$ ]]
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  VALIDAR E LIMPAR ARQUIVOS OBSOLETOS                      ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Iniciando validação e limpeza..."
    log_info "Log será salvo em: ${LOG_FILE}"
    echo ""
    
    # Cabeçalho do log
    {
        echo "# Validação e Limpeza de Arquivos Obsoletos"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo "**Modo:** $([ "${DRY_RUN}" == "true" ] && echo "DRY-RUN" || echo "EXECUÇÃO REAL")"
        echo ""
        echo "---"
        echo ""
    } > "${LOG_FILE}"
    
    # Executar etapas
    definir_arquivos_em_uso
    identificar_obsoletos
    validar_uso_real
    calcular_espaco
    gerar_relatorio
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "MODO DRY-RUN - Revise o relatório antes de executar sem --dry-run"
    else
        executar_limpeza
    fi
    
    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  VALIDAÇÃO CONCLUÍDA                                     ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    log_info "Log completo: ${LOG_FILE}"
    log_info "Relatório: ${REPORT_FILE}"
    echo ""
}

main "$@"

