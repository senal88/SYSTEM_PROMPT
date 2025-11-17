#!/usr/bin/env bash
#
# validate_architecture.sh
# Script de validação e correção automática da arquitetura do projeto
# Compara estrutura atual com o README-COMPLETE.md de referência
#
# Uso: bash scripts/validation/validate_architecture.sh
#

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================

source "$(dirname "${BASH_SOURCE[0]}")/../lib/logging.sh"

# Função de ajuda
show_help() {
    cat << EOF
🚀 Validação de Arquitetura - automation_1password

USAGE:
    bash scripts/validation/validate_architecture.sh [OPTIONS]

OPTIONS:
    --dry-run    Executar apenas validações sem aplicar correções
    --fix        Aplicar correções automaticamente (default)
    --help       Mostrar esta ajuda

EXAMPLES:
    # Validação completa com correções
    bash scripts/validation/validate_architecture.sh

    # Apenas verificar sem corrigir
    bash scripts/validation/validate_architecture.sh --dry-run

EOF
}

# Variáveis globais
DRY_RUN=false
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

log_info "Iniciando validação de arquitetura..."
log_info "Repositório: $REPO_ROOT"

# Parse de argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --fix)
            DRY_RUN=false
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            log_error "Opção desconhecida: $1"
            show_help
            exit 1
            ;;
    esac
done

# ============================================================================
# PROBLEMAS IDENTIFICADOS E CORREÇÕES
# ============================================================================

log_info "🔍 Detecção de problemas..."

ISSUES=0
FIXES=0

# 1. Renomear arquivo com espaço no nome
if [[ -f "1password-credentials .json" ]]; then
    ((ISSUES++))
    log_warning "Arquivo inválido detectado: '1password-credentials .json'"
    if [[ "$DRY_RUN" == false ]]; then
        mv "1password-credentials .json" "1password-credentials.json"
        ((FIXES++))
        log_success "Renomeado para: '1password-credentials.json'"
    else
        log_info "[DRY-RUN] Seria renomeado para: '1password-credentials.json'"
    fi
fi

# 2. Consolidar credentials.json
if [[ -f "configs/1password-credentials.json" ]]; then
    ((ISSUES++))
    log_warning "Credentials duplicado em configs/"
    if [[ "$DRY_RUN" == false ]]; then
        if [[ ! -f "connect/credentials.json" ]] && [[ -f "1password-credentials.json" ]]; then
            cp "1password-credentials.json" "connect/credentials.json"
            chmod 600 "connect/credentials.json"
            log_success "Copiado para connect/credentials.json"
        fi
        rm -f "configs/1password-credentials.json"
        ((FIXES++))
        log_success "Removido configs/1password-credentials.json"
    else
        log_info "[DRY-RUN] Seria copiado para connect/ e removido de configs/"
    fi
fi

# 3. Remover arquivos temporários
TEMP_FILES=(
    ".tmp_tree.txt"
    "estrutura_diretorios.txt"
)

for file in "${TEMP_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ((ISSUES++))
        log_warning "Arquivo temporário detectado: $file"
        if [[ "$DRY_RUN" == false ]]; then
            rm -f "$file"
            ((FIXES++))
            log_success "Removido: $file"
        else
            log_info "[DRY-RUN] Seria removido: $file"
        fi
    fi
done

# 4. Remover backups obsoletos
if [[ -d "connect/macos_connect_server" ]]; then
    ZIP_COUNT=$(find "connect/macos_connect_server" -name "*.zip" 2>/dev/null | wc -l)
    if [[ $ZIP_COUNT -gt 0 ]]; then
        ((ISSUES++))
        log_warning "Backups obsoletos encontrados em connect/macos_connect_server/"
        if [[ "$DRY_RUN" == false ]]; then
            rm -f connect/macos_connect_server/*.zip
            ((FIXES++))
            log_success "Backups removidos"
        else
            log_info "[DRY-RUN] Seriam removidos: $ZIP_COUNT arquivo(s) .zip"
        fi
    fi
fi

# 5. Corrigir permissões de scripts
log_info "Verificando permissões de scripts..."
SCRIPT_COUNT=0
while IFS= read -r -d '' file; do
    if [[ ! -x "$file" ]]; then
        ((ISSUES++))
        ((SCRIPT_COUNT++))
        if [[ "$DRY_RUN" == false ]]; then
            chmod +x "$file"
            ((FIXES++))
        fi
    fi
done < <(find scripts -name "*.sh" -print0 2>/dev/null || true)

if [[ $SCRIPT_COUNT -gt 0 ]]; then
    if [[ "$DRY_RUN" == false ]]; then
        log_success "Permissões corrigidas em $SCRIPT_COUNT script(s)"
    else
        log_info "[DRY-RUN] Seriam corrigidas permissões em $SCRIPT_COUNT script(s)"
    fi
fi

# 6. Substituir README.md por README-COMPLETE.md
if [[ -f "README-COMPLETE.md" ]]; then
    LINES_CURRENT=$(wc -l < README.md 2>/dev/null || echo "0")
    LINES_COMPLETE=$(wc -l < README-COMPLETE.md)
    
    if [[ ! -f "README.md" ]] || [[ $LINES_CURRENT -lt 500 ]]; then
        ((ISSUES++))
        log_warning "README.md incompleto ($LINES_CURRENT linhas vs $LINES_COMPLETE no README-COMPLETE.md)"
        if [[ "$DRY_RUN" == false ]]; then
            cp README-COMPLETE.md README.md
            ((FIXES++))
            log_success "README.md substituído pela versão completa"
        else
            log_info "[DRY-RUN] README.md seria substituído"
        fi
    fi
fi

# 7. Verificar estrutura de diretórios
log_info "Verificando estrutura de diretórios..."
REQUIRED_DIRS=(
    "connect"
    "configs"
    "env"
    "templates"
    "scripts"
    "tokens"
    "docs"
    "logs"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        ((ISSUES++))
        log_error "Diretório ausente: $dir"
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$dir"
            ((FIXES++))
            log_success "Diretório criado: $dir"
        fi
    fi
done

# ============================================================================
# RESUMO
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ "$DRY_RUN" == true ]]; then
    log_info "🔍 VALIDAÇÃO COMPLETA (DRY-RUN)"
else
    log_success "🔧 CORREÇÕES APLICADAS"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [[ $ISSUES -eq 0 ]]; then
    log_success "Nenhum problema encontrado! Arquitetura válida ✅"
else
    if [[ "$DRY_RUN" == true ]]; then
        log_warning "Problemas detectados: $ISSUES"
        log_info "Execute sem --dry-run para aplicar correções"
    else
        log_success "Problemas corrigidos: $FIXES de $ISSUES"
    fi
fi

echo ""

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================

if [[ "$DRY_RUN" == false ]] && [[ $FIXES -gt 0 ]]; then
    log_info "📋 Próximos passos recomendados:"
    echo ""
    echo "  1. Validar ambiente:"
    echo "     bash scripts/validation/validate_environment_macos.sh"
    echo ""
    echo "  2. Validar organização:"
    echo "     bash scripts/validation/validate_organization.sh"
    echo ""
    echo "  3. Regerar relatório de arquitetura:"
    echo "     bash scripts/export_architecture.sh"
    echo ""
    echo "  4. Testar 1Password Connect:"
    echo "     cd connect && make validate"
    echo ""
fi

exit 0
