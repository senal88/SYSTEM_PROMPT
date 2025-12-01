#!/usr/bin/env bash
################################################################################
# ✅ SCRIPT DE VALIDAÇÃO RIGOROSA PRÉ-EXECUÇÃO
#
# DESCRIÇÃO:
#   Valida todas as dependências, credenciais, conectividade e estrutura
#   antes de executar qualquer fase de implantação.
#
# VERSÃO: 1.0.0
# DATA: 2025-01-15
# STATUS: CRÍTICO - DEVE SER EXECUTADO ANTES DE QUALQUER OUTRA FASE
################################################################################

set -euo pipefail

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Contadores
VALIDATION_PASSED=0
VALIDATION_FAILED=0
VALIDATION_WARNINGS=0

# Funções
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✅]${NC} $*"
    ((VALIDATION_PASSED++))
}

log_error() {
    echo -e "${RED}[❌]${NC} $*"
    ((VALIDATION_FAILED++))
}

log_warning() {
    echo -e "${YELLOW}[⚠️]${NC} $*"
    ((VALIDATION_WARNINGS++))
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Validação de ferramentas obrigatórias
validate_tools() {
    print_header "🔧 VALIDAÇÃO DE FERRAMENTAS OBRIGATÓRIAS"

    local tools=("op" "jq" "git" "ssh" "curl" "rsync")
    local tool_names=("1Password CLI" "jq" "Git" "SSH" "curl" "rsync")

    for i in "${!tools[@]}"; do
        local tool="${tools[$i]}"
        local name="${tool_names[$i]}"

        if command -v "$tool" >/dev/null 2>&1; then
            log_success "${name} instalado: $(command -v ${tool})"
        else
            log_error "${name} NÃO instalado - CRÍTICO"
        fi
    done
}

# Validação de 1Password
validate_1password() {
    print_header "🔐 VALIDAÇÃO DE 1PASSWORD CLI"

    if ! command -v op >/dev/null 2>&1; then
        log_error "1Password CLI não instalado"
        return 1
    fi

    log_info "Verificando autenticação 1Password..."
    if op whoami >/dev/null 2>&1; then
        local user=$(op whoami 2>/dev/null)
        log_success "1Password autenticado: ${user}"
    else
        log_error "1Password NÃO autenticado - Execute: op signin"
        return 1
    fi

    # Validar vaults
    log_info "Verificando vaults disponíveis..."
    if op vault list >/dev/null 2>&1; then
        local vault_count=$(op vault list --format json 2>/dev/null | jq -r '. | length')
        log_success "Vaults disponíveis: ${vault_count}"
    else
        log_warning "Não foi possível listar vaults"
    fi
}

# Validação de credenciais
validate_credentials() {
    print_header "🔑 VALIDAÇÃO DE CREDENCIAIS NO 1PASSWORD"

    # Placeholders inválidos
    local invalid_placeholders=(
        "YOUR_API_KEY"
        "your-api-key-here"
        "placeholder"
        "REPLACE_ME"
        "INSERT_KEY_HERE"
        "example.com"
        "example@example.com"
        "1234567890"
        "changeme"
        "TODO"
        "FIXME"
        "TBD"
        "null"
        "undefined"
        "empty"
    )

    # Validar credenciais obrigatórias
    local credentials=(
        "API-VPS-HOSTINGER:credential"
        "Gemini-API-Keys:google_api_key"
    )

    for cred in "${credentials[@]}"; do
        local item="${cred%%:*}"
        local field="${cred##*:}"

        log_info "Validando: ${item} (campo: ${field})"

        # Tentar buscar do 1Password
        local value=$(op read "op://1p_macos/${item}/${field}" 2>/dev/null || echo "")

        if [[ -z "$value" ]]; then
            log_error "${item} não encontrado ou vazio"
            continue
        fi

        # Verificar se é placeholder
        local is_placeholder=false
        for placeholder in "${invalid_placeholders[@]}"; do
            if [[ "$value" == *"${placeholder}"* ]]; then
                is_placeholder=true
                break
            fi
        done

        if [[ "$is_placeholder" == true ]]; then
            log_error "${item} contém placeholder inválido"
        elif [[ ${#value} -lt 16 ]]; then
            log_warning "${item} muito curto (${#value} caracteres) - pode ser inválido"
        else
            log_success "${item} válido (${#value} caracteres)"
        fi
    done
}

# Validação de conectividade SSH
validate_ssh() {
    print_header "🌐 VALIDAÇÃO DE CONECTIVIDADE SSH"

    local vps_host="${VPS_HOST:-admin-vps}"

    log_info "Testando conexão SSH com ${vps_host}..."

    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${vps_host}" "echo 'OK'" >/dev/null 2>&1; then
        log_success "Conexão SSH estabelecida com ${vps_host}"

        # Validar chaves SSH
        if ssh-add -l >/dev/null 2>&1; then
            local key_count=$(ssh-add -l 2>/dev/null | wc -l)
            log_success "Chaves SSH carregadas: ${key_count}"
        else
            log_warning "Nenhuma chave SSH carregada no agente"
        fi
    else
        log_error "Não foi possível conectar via SSH a ${vps_host}"
        log_info "Verifique:"
        log_info "  - Alias SSH configurado em ~/.ssh/config"
        log_info "  - Chaves SSH autorizadas na VPS"
        log_info "  - Host acessível"
    fi
}

# Validação de APIs
validate_apis() {
    print_header "🌍 VALIDAÇÃO DE APIS"

    # Validar Hostinger API
    log_info "Testando Hostinger API..."
    local hostinger_token=$(op read "op://1p_macos/API-VPS-HOSTINGER/credential" 2>/dev/null || echo "")

    if [[ -n "$hostinger_token" ]] && [[ "$hostinger_token" != *"placeholder"* ]]; then
        if curl -s -X GET "https://developers.hostinger.com/api/vps/v1/virtual-machines" \
            -H "Authorization: Bearer ${hostinger_token}" \
            -H "Content-Type: application/json" \
            -w "\n%{http_code}" -o /tmp/hostinger_response.json | tail -1 | grep -q "200"; then
            log_success "Hostinger API respondendo corretamente"
        else
            log_warning "Hostinger API não respondeu como esperado"
        fi
    else
        log_warning "Token Hostinger não disponível para teste"
    fi

    # Validar GitHub API
    log_info "Testando GitHub API..."
    if command -v gh >/dev/null 2>&1; then
        if gh auth status >/dev/null 2>&1; then
            log_success "GitHub CLI autenticado"
            if gh api user >/dev/null 2>&1; then
                log_success "GitHub API respondendo corretamente"
            else
                log_warning "GitHub API não respondeu como esperado"
            fi
        else
            log_warning "GitHub CLI não autenticado"
        fi
    else
        log_warning "GitHub CLI não instalado (opcional)"
    fi
}

# Validação de estrutura
validate_structure() {
    print_header "📁 VALIDAÇÃO DE ESTRUTURA DE DIRETÓRIOS"

    local required_dirs=(
        "${DOTFILES_DIR}/system_prompts/global"
        "${DOTFILES_DIR}/system_prompts/global/prompts"
        "${DOTFILES_DIR}/system_prompts/global/scripts"
        "${DOTFILES_DIR}/system_prompts/global/docs"
        "${DOTFILES_DIR}/configs"
        "${DOTFILES_DIR}/scripts/sync"
    )

    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_success "Diretório existe: ${dir}"
        else
            log_error "Diretório NÃO existe: ${dir}"
        fi
    done
}

# Validação de arquivos JSON/YAML
validate_json_yaml() {
    print_header "📄 VALIDAÇÃO DE ARQUIVOS JSON/YAML"

    if ! command -v jq >/dev/null 2>&1; then
        log_warning "jq não instalado - pulando validação JSON"
        return
    fi

    # Validar arquivos JSON
    local json_files=$(find "${DOTFILES_DIR}/system_prompts/global" -name "*.json" 2>/dev/null || true)

    if [[ -n "$json_files" ]]; then
        local json_count=0
        local json_valid=0

        while IFS= read -r file; do
            ((json_count++))
            if jq empty "$file" 2>/dev/null; then
                ((json_valid++))
            else
                log_error "JSON inválido: ${file}"
            fi
        done <<< "$json_files"

        if [[ $json_count -gt 0 ]]; then
            log_success "Arquivos JSON válidos: ${json_valid}/${json_count}"
        fi
    else
        log_info "Nenhum arquivo JSON encontrado para validar"
    fi
}

# Validação de scripts
validate_scripts() {
    print_header "🔧 VALIDAÇÃO DE SCRIPTS"

    local scripts=$(find "${DOTFILES_DIR}/system_prompts/global/scripts" -name "*.sh" 2>/dev/null || true)

    if [[ -n "$scripts" ]]; then
        local script_count=0
        local script_valid=0

        while IFS= read -r script; do
            ((script_count++))

            # Validar sintaxe
            if bash -n "$script" 2>/dev/null; then
                ((script_valid++))

                # Validar permissões
                if [[ -x "$script" ]]; then
                    log_success "Script válido e executável: $(basename ${script})"
                else
                    log_warning "Script válido mas não executável: $(basename ${script})"
                fi
            else
                log_error "Script com erro de sintaxe: ${script}"
            fi
        done <<< "$scripts"

        if [[ $script_count -gt 0 ]]; then
            log_success "Scripts válidos: ${script_valid}/${script_count}"
        fi
    else
        log_info "Nenhum script encontrado para validar"
    fi
}

# Resumo final
print_summary() {
    print_header "📊 RESUMO DA VALIDAÇÃO"

    echo "Validações aprovadas: ${VALIDATION_PASSED}"
    echo "Validações falhadas: ${VALIDATION_FAILED}"
    echo "Avisos: ${VALIDATION_WARNINGS}"
    echo ""

    if [[ $VALIDATION_FAILED -eq 0 ]]; then
        log_success "✅ TODAS AS VALIDAÇÕES CRÍTICAS PASSARAM!"
        echo ""
        echo "Prosseguir com a execução do planejamento."
        return 0
    else
        log_error "❌ VALIDAÇÕES CRÍTICAS FALHARAM!"
        echo ""
        echo "Corrija os erros antes de continuar."
        return 1
    fi
}

# Função principal
main() {
    print_header "🚀 VALIDAÇÃO RIGOROSA PRÉ-EXECUÇÃO"

    validate_tools
    validate_1password
    validate_credentials
    validate_ssh
    validate_apis
    validate_structure
    validate_json_yaml
    validate_scripts

    print_summary
}

main "$@"
