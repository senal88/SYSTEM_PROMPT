#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔍 VALIDAR TODA A CONFIGURAÇÃO CLAUDE DESKTOP
#
# Valida todos os aspectos da configuração do Claude Desktop:
# - Arquivos de configuração
# - MCP Servers
# - Extensões
# - Integrações
# - Segurança
#
# Uso: ./validar-todo-claude-desktop_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

CLAUDE_DIR="${HOME}/Library/Application Support/Claude"
CONFIG_FILE="${CLAUDE_DIR}/claude_desktop_config.json"
EXTENSIONS_DIR="${CLAUDE_DIR}/Claude Extensions"
SETTINGS_DIR="${CLAUDE_DIR}/Claude Extensions Settings"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

log_section() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $@"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

ISSUES=0
WARNINGS=0

check_issue() {
    ISSUES=$((ISSUES + 1))
}

check_warning() {
    WARNINGS=$((WARNINGS + 1))
}

log_section "VALIDAÇÃO COMPLETA CLAUDE DESKTOP"

# 1. Verificar estrutura de diretórios
log_info "1. Verificando estrutura de diretórios..."

if [[ -d "${CLAUDE_DIR}" ]]; then
    log_success "Diretório principal existe"
else
    log_error "Diretório principal não existe"
    check_issue
fi

if [[ -d "${EXTENSIONS_DIR}" ]]; then
    EXT_COUNT=$(find "${EXTENSIONS_DIR}" -maxdepth 1 -type d | wc -l | tr -d ' ')
    log_success "Diretório de extensões existe (${EXT_COUNT} extensões)"
else
    log_warning "Diretório de extensões não existe"
    check_warning
fi

# 2. Verificar arquivo de configuração principal
log_info "2. Verificando arquivo de configuração principal..."

if [[ -f "${CONFIG_FILE}" ]]; then
    log_success "Arquivo de configuração existe"

    # Verificar JSON válido
    if command -v jq &> /dev/null; then
        if jq empty "${CONFIG_FILE}" 2>/dev/null; then
            log_success "JSON válido"

            # Verificar campos importantes
            if jq -e '.anthropic_api_key' "${CONFIG_FILE}" &> /dev/null; then
                API_KEY_VALUE=$(jq -r '.anthropic_api_key' "${CONFIG_FILE}")
                if [[ "${API_KEY_VALUE}" == "op://"* ]]; then
                    log_success "API Key usa referência 1Password"
                elif [[ "${API_KEY_VALUE}" == "sk-ant-"* ]]; then
                    log_warning "API Key em texto plano detectada"
                    check_warning
                else
                    log_info "API Key configurada: ${API_KEY_VALUE:0:20}..."
                fi
            else
                log_warning "Campo anthropic_api_key não encontrado"
                check_warning
            fi

            # Verificar modelo padrão
            if jq -e '.default_model' "${CONFIG_FILE}" &> /dev/null; then
                MODEL=$(jq -r '.default_model' "${CONFIG_FILE}")
                log_success "Modelo padrão: ${MODEL}"
            fi
        else
            log_error "JSON inválido"
            check_issue
        fi
    else
        log_warning "jq não encontrado, pulando validação JSON detalhada"
    fi
else
    log_error "Arquivo de configuração não existe"
    check_issue
fi

# 3. Verificar MCP Servers no config.json
log_info "3. Verificando MCP Servers..."

MCP_CONFIG="${CLAUDE_DIR}/config.json"
if [[ -f "${MCP_CONFIG}" ]]; then
    log_success "Arquivo MCP config existe"

    if command -v jq &> /dev/null; then
        MCP_COUNT=$(jq -r '.mcpServers | length' "${MCP_CONFIG}" 2>/dev/null || echo "0")
        log_success "MCP Servers configurados: ${MCP_COUNT}"

        # Verificar secrets em texto plano
        if grep -q "your-.*-key-here\|ghp_.*\|sk-ant-.*" "${MCP_CONFIG}"; then
            log_warning "Possíveis secrets em texto plano encontrados"
            check_warning
        fi
    fi
else
    log_warning "Arquivo MCP config não existe"
    check_warning
fi

# 4. Verificar extensões instaladas
log_info "4. Verificando extensões instaladas..."

if [[ -d "${EXTENSIONS_DIR}" ]]; then
    EXTENSIONS=($(find "${EXTENSIONS_DIR}" -maxdepth 1 -type d -not -name "Claude Extensions" | sed 's|.*/||'))

    for ext in "${EXTENSIONS[@]}"; do
        if [[ -n "${ext}" ]]; then
            log_info "  - ${ext}"

            # Verificar manifest.json
            MANIFEST="${EXTENSIONS_DIR}/${ext}/manifest.json"
            if [[ -f "${MANIFEST}" ]]; then
                log_success "    Manifest encontrado"
            else
                log_warning "    Manifest não encontrado"
                check_warning
            fi
        fi
    done
fi

# 5. Verificar configurações de extensões
log_info "5. Verificando configurações de extensões..."

if [[ -d "${SETTINGS_DIR}" ]]; then
    SETTINGS_COUNT=$(find "${SETTINGS_DIR}" -name "*.json" | wc -l | tr -d ' ')
    log_success "Arquivos de configuração: ${SETTINGS_COUNT}"

    # Verificar secrets em configurações
    if grep -r "your-.*-key-here\|ghp_.*\|sk-ant-.*" "${SETTINGS_DIR}" &> /dev/null; then
        log_warning "Possíveis secrets em texto plano nas configurações"
        check_warning
    fi
else
    log_warning "Diretório de configurações não existe"
    check_warning
fi

# 6. Verificar backups
log_info "6. Verificando backups..."

BACKUP_COUNT=$(find "${CLAUDE_DIR}" -name "*.backup.*" | wc -l | tr -d ' ')
if [[ ${BACKUP_COUNT} -gt 0 ]]; then
    log_success "Backups encontrados: ${BACKUP_COUNT}"
else
    log_warning "Nenhum backup encontrado"
    check_warning
fi

# 7. Verificar integração 1Password
log_info "7. Verificando integração 1Password..."

if command -v op &> /dev/null; then
    log_success "1Password CLI instalado"

    if op account list &> /dev/null; then
        log_success "1Password autenticado"

        ITEM_ID=$(op item list --vault 1p_macos --format json 2>/dev/null | \
            jq -r '.[] | select(.title == "Anthropic") | .id' | head -1)

        if [[ -n "${ITEM_ID}" ]]; then
            log_success "Item Anthropic encontrado: ${ITEM_ID}"

            if op read "op://1p_macos/Anthropic/api_key" &> /dev/null; then
                log_success "API Key acessível via 1Password"
            else
                log_error "API Key não acessível via 1Password"
                check_issue
            fi
        else
            log_error "Item Anthropic não encontrado no 1Password"
            check_issue
        fi
    else
        log_error "1Password não autenticado"
        check_issue
    fi
else
    log_error "1Password CLI não instalado"
    check_issue
fi

# 8. Verificar variável de ambiente
log_info "8. Verificando variável de ambiente..."

if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    log_success "Variável ANTHROPIC_API_KEY definida"
else
    log_warning "Variável ANTHROPIC_API_KEY não definida"
    check_warning
fi

# 9. Verificar processo Claude Desktop
log_info "9. Verificando processo Claude Desktop..."

if pgrep -f "Claude" &> /dev/null; then
    log_success "Claude Desktop em execução"
    PROCESS_COUNT=$(pgrep -f "Claude" | wc -l | tr -d ' ')
    log_info "  Processos: ${PROCESS_COUNT}"
else
    log_warning "Claude Desktop não está em execução"
    check_warning
fi

# 10. Verificar segurança
log_info "10. Verificando segurança..."

# Verificar permissões de arquivos sensíveis
if [[ -f "${CONFIG_FILE}" ]]; then
    PERMS=$(stat -f "%OLp" "${CONFIG_FILE}" 2>/dev/null || stat -c "%a" "${CONFIG_FILE}" 2>/dev/null || echo "000")
    if [[ "${PERMS}" == "600" ]] || [[ "${PERMS}" == "644" ]]; then
        log_success "Permissões do arquivo de configuração adequadas: ${PERMS}"
    else
        log_warning "Permissões do arquivo de configuração: ${PERMS}"
        check_warning
    fi
fi

# Verificar se há secrets em logs
if find "${CLAUDE_DIR}" -name "*.log" -exec grep -l "sk-ant-\|api.*key" {} \; 2>/dev/null | head -1 | grep -q .; then
    log_warning "Possíveis secrets em arquivos de log"
    check_warning
fi

log_section "RESUMO DA VALIDAÇÃO"

echo ""
echo "✅ Verificações passadas: $((10 - ISSUES - WARNINGS))"
echo "⚠️ Avisos: ${WARNINGS}"
echo "❌ Problemas: ${ISSUES}"
echo ""

if [[ ${ISSUES} -eq 0 ]] && [[ ${WARNINGS} -eq 0 ]]; then
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  VALIDAÇÃO COMPLETA - TUDO OK                             ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    exit 0
elif [[ ${ISSUES} -eq 0 ]]; then
    log_warning "╔════════════════════════════════════════════════════════════╗"
    log_warning "║  VALIDAÇÃO COMPLETA - AVISOS ENCONTRADOS                 ║"
    log_warning "╚════════════════════════════════════════════════════════════╝"
    exit 0
else
    log_error "╔════════════════════════════════════════════════════════════╗"
    log_error "║  VALIDAÇÃO COMPLETA - PROBLEMAS ENCONTRADOS               ║"
    log_error "╚════════════════════════════════════════════════════════════╝"
    exit 1
fi
