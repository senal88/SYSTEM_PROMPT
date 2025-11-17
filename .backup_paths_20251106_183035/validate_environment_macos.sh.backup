#!/bin/bash

################################################################################
# ✅ validate_environment_macos.sh
# Script de Validação do Ambiente de Automação do 1Password para macOS Silicon
# Propósito: Verificar todas as dependências e configurações necessárias
# Autor: Manus AI
# Data: 2025-10-22
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="environment_validation_report.txt"
ISSUES_FOUND=0
WARNINGS_FOUND=0

# ============================================================================
# CORES PARA OUTPUT
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "[INFO] $1" >> "$REPORT_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "[SUCCESS] $1" >> "$REPORT_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    echo "[WARNING] $1" >> "$REPORT_FILE"
    ((WARNINGS_FOUND++))
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    echo "[ERROR] $1" >> "$REPORT_FILE"
    ((ISSUES_FOUND++))
}

log_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "================================================================================" >> "$REPORT_FILE"
    echo "$1" >> "$REPORT_FILE"
    echo "================================================================================" >> "$REPORT_FILE"
}

# ============================================================================
# VALIDAÇÃO DO SISTEMA OPERACIONAL
# ============================================================================

validate_os() {
    log_section "Validação do Sistema Operacional"

    # Verificar se está no macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "Este script é específico para macOS. Seu sistema operacional é: $OSTYPE"
        return 1
    fi

    log_success "macOS detectado."

    # Verificar versão do macOS
    MACOS_VERSION=$(sw_vers -productVersion)
    log_info "Versão do macOS: $MACOS_VERSION"

    # Verificar se é uma versão suportada (Monterey ou superior)
    MAJOR_VERSION=$(echo "$MACOS_VERSION" | cut -d'.' -f1)
    if [[ $MAJOR_VERSION -lt 12 ]]; then
        log_warning "macOS Monterey (12.x) ou superior é recomendado. Você tem: $MACOS_VERSION"
    else
        log_success "Versão do macOS é suportada."
    fi

    # Verificar se é Apple Silicon
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        log_success "Apple Silicon (arm64) detectado."
    else
        log_warning "Arquitetura detectada: $ARCH. Este script foi otimizado para Apple Silicon (arm64)."
    fi
}

# ============================================================================
# VALIDAÇÃO DO 1PASSWORD CLI
# ============================================================================

validate_1password_cli() {
    log_section "Validação do 1Password CLI"

    # Verificar se op está instalado
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI (op) não está instalado."
        log_info "Instale com: brew install 1password-cli"
        return 1
    fi

    log_success "1Password CLI está instalado."

    # Verificar versão
    OP_VERSION=$(op --version)
    log_info "Versão: $OP_VERSION"

    # Verificar se está autenticado
    if op whoami &>/dev/null; then
        log_success "Autenticado no 1Password."
        ACCOUNT_INFO=$(op whoami)
        log_info "Conta: $ACCOUNT_INFO"
    else
        log_warning "Não autenticado no 1Password. Execute: eval \$(op signin)"
    fi

    # Verificar vaults acessíveis
    if op vault list &>/dev/null; then
        VAULT_COUNT=$(op vault list --format json | jq 'length')
        log_success "Acessando $VAULT_COUNT vault(s)."
        log_info "Vaults disponíveis:"
        op vault list --format json | jq -r '.[] | "  - \(.name)"' | sed 's/^/    /'
    else
        log_warning "Não foi possível listar os vaults. Você pode precisar fazer login."
    fi
}

# ============================================================================
# VALIDAÇÃO DO 1PASSWORD DESKTOP APP
# ============================================================================

validate_1password_desktop_app() {
    log_section "Validação do 1Password Desktop App"

    if [[ -d "/Applications/1Password 7.app" ]]; then
        log_success "1Password 7 Desktop App encontrado."
    elif [[ -d "/Applications/1Password.app" ]]; then
        log_success "1Password Desktop App encontrado."
    else
        log_warning "1Password Desktop App não encontrado em /Applications."
        log_info "Você pode baixar em: https://1password.com/downloads/mac/"
        log_info "Nota: O Desktop App é recomendado para autenticação biométrica."
    fi
}

# ============================================================================
# VALIDAÇÃO DE BIOMETRIA
# ============================================================================

validate_biometric() {
    log_section "Validação de Autenticação Biométrica"

    # Verificar se Touch ID está disponível
    if system_profiler SPBiometricInformation 2>/dev/null | grep -q "Touch ID"; then
        log_success "Touch ID está disponível."
    elif system_profiler SPBiometricInformation 2>/dev/null | grep -q "Face ID"; then
        log_success "Face ID está disponível."
    else
        log_warning "Nenhum sensor biométrico detectado no relatório do sistema."
        log_info "Você pode usar Apple Watch para desbloqueio do 1Password."
    fi

    # Verificar se biometria está ativada no 1Password
    if [[ -d "/Applications/1Password.app" ]]; then
        log_info "Para ativar biometria no 1Password:"
        log_info "  1. Abra o 1Password Desktop App"
        log_info "  2. Vá para Settings > Security"
        log_info "  3. Habilite 'Unlock with Touch ID' ou 'Unlock with Apple Watch'"
    fi
}

# ============================================================================
# VALIDAÇÃO DE SHELL
# ============================================================================

validate_shell() {
    log_section "Validação do Shell"

    CURRENT_SHELL="$SHELL"
    log_info "Shell padrão: $CURRENT_SHELL"

    if [[ "$CURRENT_SHELL" == *"zsh"* ]]; then
        log_success "Zsh detectado (recomendado)."

        # Verificar se .zshrc existe
        if [[ -f "$HOME/.zshrc" ]]; then
            log_success "Arquivo .zshrc encontrado."

            # Verificar se contém configuração do 1Password
            if grep -q "1Password" "$HOME/.zshrc"; then
                log_success "Configuração do 1Password encontrada no .zshrc."
            else
                log_warning "Configuração do 1Password não encontrada no .zshrc."
                log_info "Execute: source zshrc_1password_config.sh"
            fi
        else
            log_warning "Arquivo .zshrc não encontrado."
        fi
    elif [[ "$CURRENT_SHELL" == *"bash"* ]]; then
        log_info "Bash detectado. Zsh é recomendado para melhor integração."
    else
        log_warning "Shell desconhecido: $CURRENT_SHELL"
    fi
}

# ============================================================================
# VALIDAÇÃO DE FERRAMENTAS ESSENCIAIS
# ============================================================================

validate_essential_tools() {
    log_section "Validação de Ferramentas Essenciais"

    # Lista de ferramentas essenciais
    TOOLS=("brew" "git" "jq" "curl" "openssl")

    for tool in "${TOOLS[@]}"; do
        if command -v "$tool" &> /dev/null; then
            VERSION=$("$tool" --version 2>&1 | head -n1)
            log_success "$tool está instalado: $VERSION"
        else
            log_warning "$tool não está instalado."
        fi
    done
}

# ============================================================================
# VALIDAÇÃO DE VARIÁVEIS DE AMBIENTE
# ============================================================================

validate_environment_variables() {
    log_section "Validação de Variáveis de Ambiente"

    # Verificar variáveis importantes
    IMPORTANT_VARS=("HOME" "SHELL" "PATH" "LANG")

    for var in "${IMPORTANT_VARS[@]}"; do
        if [[ -n "${!var:-}" ]]; then
            log_success "$var está definida."
        else
            log_warning "$var não está definida."
        fi
    done

    # Verificar se OP_SERVICE_ACCOUNT_TOKEN está definido (opcional)
    if [[ -n "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
        log_success "OP_SERVICE_ACCOUNT_TOKEN está definido (para automação)."
    else
        log_info "OP_SERVICE_ACCOUNT_TOKEN não está definido (opcional para desenvolvimento local)."
    fi
}

# ============================================================================
# VALIDAÇÃO DE ARQUIVOS DE CONFIGURAÇÃO
# ============================================================================

validate_config_files() {
    log_section "Validação de Arquivos de Configuração"

    # Verificar se .env.op existe
    if [[ -f ".env.op" ]]; then
        log_success "Arquivo .env.op encontrado."
        LINES=$(wc -l < .env.op)
        log_info "Linhas: $LINES"
    else
        log_warning "Arquivo .env.op não encontrado no diretório atual."
    fi

    # Verificar se .env existe
    if [[ -f ".env" ]]; then
        log_success "Arquivo .env encontrado."
        PERMS=$(stat -f '%A' .env)
        log_info "Permissões: $PERMS"
        if [[ "$PERMS" == "------" ]]; then
            log_success "Permissões corretas (600)."
        else
            log_warning "Permissões não ideais. Considere: chmod 600 .env"
        fi
    else
        log_info "Arquivo .env não encontrado (será gerado dinamicamente)."
    fi
}

# ============================================================================
# VALIDAÇÃO DE CONECTIVIDADE
# ============================================================================

validate_connectivity() {
    log_section "Validação de Conectividade"

    # Testar conexão com 1Password
    if curl -s -I https://app.1password.com | grep -q "200\|301\|302"; then
        log_success "Conectividade com 1Password estabelecida."
    else
        log_warning "Não foi possível conectar a https://app.1password.com"
    fi

    # Testar conexão com internet
    if ping -c 1 8.8.8.8 &> /dev/null; then
        log_success "Conexão com internet está funcionando."
    else
        log_warning "Não foi possível conectar à internet."
    fi
}

# ============================================================================
# RELATÓRIO FINAL
# ============================================================================

generate_report() {
    log_section "Relatório Final"

    echo "" >> "$REPORT_FILE"
    echo "================================================================================" >> "$REPORT_FILE"
    echo "RESUMO DA VALIDAÇÃO" >> "$REPORT_FILE"
    echo "================================================================================" >> "$REPORT_FILE"
    echo "Data: $(date)" >> "$REPORT_FILE"
    echo "Problemas encontrados: $ISSUES_FOUND" >> "$REPORT_FILE"
    echo "Avisos encontrados: $WARNINGS_FOUND" >> "$REPORT_FILE"
    echo "================================================================================" >> "$REPORT_FILE"

    if [[ $ISSUES_FOUND -eq 0 ]]; then
        log_success "Nenhum problema crítico encontrado!"
    else
        log_error "Foram encontrados $ISSUES_FOUND problema(s) crítico(s)."
    fi

    if [[ $WARNINGS_FOUND -gt 0 ]]; then
        log_warning "Foram encontrados $WARNINGS_FOUND aviso(s)."
    fi

    log_info ""
    log_info "Relatório completo salvo em: $REPORT_FILE"
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  ✅ Validação do Ambiente - 1Password para macOS Silicon       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Inicializar arquivo de relatório
    > "$REPORT_FILE"
    echo "Validação do Ambiente - 1Password para macOS Silicon" > "$REPORT_FILE"
    echo "Data: $(date)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # Executar validações
    validate_os
    validate_1password_cli
    validate_1password_desktop_app
    validate_biometric
    validate_shell
    validate_essential_tools
    validate_environment_variables
    validate_config_files
    validate_connectivity
    generate_report

    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Validação Concluída                                           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

main "$@"

