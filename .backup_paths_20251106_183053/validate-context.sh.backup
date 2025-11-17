#!/usr/bin/env bash
# validate-context.sh
# Validação automática de contexto para Claude Cloud

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTEXT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
GOVERNANCE_DIR="$CONTEXT_DIR/governance"
SCHEMAS_DIR="$GOVERNANCE_DIR/schemas"
CLAUDE_KNOWLEDGE_DIR="$(dirname "$CONTEXT_DIR")/claude-cloud-knowledge"

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $1"; }

# Validar JSON
validate_json() {
    local file="$1"
    if command -v jq &> /dev/null; then
        if jq empty "$file" 2>/dev/null; then
            return 0
        else
            log_error "JSON inválido: $file"
            return 1
        fi
    elif command -v python3 &> /dev/null; then
        if python3 -m json.tool "$file" >/dev/null 2>&1; then
            return 0
        else
            log_error "JSON inválido: $file"
            return 1
        fi
    else
        log_warning "jq ou python3 não encontrado, pulando validação JSON"
        return 0
    fi
}

# Validar paths
validate_paths() {
    log_info "Validando paths..."
    local errors=0

    # Verificar estrutura de diretórios
    local dirs=(
        "$CLAUDE_KNOWLEDGE_DIR/00_CONTEXTO_GLOBAL"
        "$CLAUDE_KNOWLEDGE_DIR/01_CONFIGURACOES"
        "$CLAUDE_KNOWLEDGE_DIR/02_PROJETO_BNI"
        "$CLAUDE_KNOWLEDGE_DIR/05_SKILLS"
        "$CLAUDE_KNOWLEDGE_DIR/06_MCP"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_success "Diretório existe: $dir"
        else
            log_error "Diretório não encontrado: $dir"
            errors=$((errors + 1))
        fi
    done

    return $errors
}

# Validar arquivos críticos
validate_critical_files() {
    log_info "Validando arquivos críticos..."
    local errors=0

    local files=(
        "$CONTEXT_DIR/.cursorrules"
        "$CONTEXT_DIR/PREFERENCIAS_PESSOAIS.md"
        "$CONTEXT_DIR/templates/claude-cloud-pro-config.xml"
    )

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            log_success "Arquivo existe: $(basename "$file")"
        else
            log_error "Arquivo não encontrado: $file"
            errors=$((errors + 1))
        fi
    done

    return $errors
}

# Validar autenticação
validate_authentication() {
    log_info "Validando autenticação..."
    local errors=0

    # 1Password
    if command -v op &> /dev/null; then
        if op whoami &>/dev/null; then
            log_success "1Password: Autenticado"
        else
            log_error "1Password: Não autenticado"
            errors=$((errors + 1))
        fi
    else
        log_error "1Password CLI não encontrado"
        errors=$((errors + 1))
    fi

    # ANTHROPIC_API_KEY
    if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
        log_success "ANTHROPIC_API_KEY: Configurada"
    else
        log_warning "ANTHROPIC_API_KEY: Não configurada nesta sessão"
    fi

    return $errors
}

# Validar configurações JSON
validate_configs() {
    log_info "Validando configurações JSON..."
    local errors=0

    local json_files=(
        "$CLAUDE_KNOWLEDGE_DIR/01_CONFIGURACOES/claude_desktop_config.json"
    )

    if [[ "$OSTYPE" == "darwin"* ]]; then
        json_files+=("$HOME/Library/Application Support/Claude/claude_desktop_config.json")
    fi

    for file in "${json_files[@]}"; do
        if [ -f "$file" ]; then
            if validate_json "$file"; then
                log_success "JSON válido: $(basename "$file")"
            else
                errors=$((errors + 1))
            fi
        fi
    done

    return $errors
}

# Função principal
main() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}🔍 Validação de Contexto${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""

    local total_errors=0

    validate_paths || total_errors=$((total_errors + $?))
    validate_critical_files || total_errors=$((total_errors + $?))
    validate_authentication || total_errors=$((total_errors + $?))
    validate_configs || total_errors=$((total_errors + $?))

    echo ""
    if [ $total_errors -eq 0 ]; then
        log_success "✅ Validação concluída sem erros"
        exit 0
    else
        log_error "❌ Validação concluída com $total_errors erro(s)"
        exit 1
    fi
}

main "$@"

