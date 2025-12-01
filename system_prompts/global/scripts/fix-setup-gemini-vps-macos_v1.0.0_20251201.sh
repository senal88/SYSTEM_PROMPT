#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔧 FIX SETUP GEMINI - VPS UBUNTU E macOS SILICON
#
# Corrige e configura Google Gemini API em ambos os ambientes:
# - VPS Ubuntu: Configura variáveis de ambiente e valida acesso
# - macOS Silicon: Configura CLI e valida credenciais
#
# Uso: ./fix-setup-gemini-vps-macos_v1.0.0_20251201.sh [--vps] [--macos] [--all]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_DIR="${GLOBAL_DIR}/logs/gemini-setup"
LOG_FILE="${LOG_DIR}/setup-${TIMESTAMP}.log"

# Flags
SETUP_VPS=false
SETUP_MACOS=false
SETUP_ALL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vps)
            SETUP_VPS=true
            shift
            ;;
        --macos)
            SETUP_MACOS=true
            shift
            ;;
        --all)
            SETUP_ALL=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Se nenhuma flag, executar tudo
if [[ "${SETUP_VPS}" == "false" ]] && [[ "${SETUP_MACOS}" == "false" ]]; then
    SETUP_ALL=true
fi

if [[ "${SETUP_ALL}" == "true" ]]; then
    SETUP_VPS=true
    SETUP_MACOS=true
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

# ============================================================================
# OBTER GEMINI API KEY DO 1PASSWORD
# ============================================================================

obter_gemini_api_key() {
    local vault="$1"
    
    log_info "Obtendo Gemini API Key do vault ${vault}..."
    
    # Tentar diferentes IDs de itens conhecidos
    GEMINI_ITEMS=(
        "knknnlaetdh6tqetsjyxh23kle"  # Gemini-API (1p_vps)
        "6zhhvw43e4cprsqgtzmqxuqysa"  # GCP - Gemini Code Assist (1p_vps)
        "27ateuu2y37dblvo3lkb4szt6y"  # Gemini_API_Key_macos (1p_macos)
        "6xbzl566sj62zphes4b6kodt5e"  # GOOGLE_API_KEY (1p_macos)
        "jnu4r2zp23tvpsnmeeh5dwvgia"  # GOOGLE_API_KEY (1p_macos)
    )
    
    for item_id in "${GEMINI_ITEMS[@]}"; do
        if op item get "${item_id}" --vault "${vault}" &> /dev/null; then
            # Tentar diferentes campos
            API_KEY=$(op item get "${item_id}" --vault "${vault}" --fields label="API_KEY" 2>/dev/null || \
                     op item get "${item_id}" --vault "${vault}" --fields label="password" 2>/dev/null || \
                     op item get "${item_id}" --vault "${vault}" --fields label="credential" 2>/dev/null || \
                     op read "op://${vault}/${item_id}/API_KEY" 2>/dev/null || \
                     op read "op://${vault}/${item_id}/password" 2>/dev/null || \
                     echo "")
            
            if [[ -n "${API_KEY}" ]]; then
                log_success "API Key obtida do item ${item_id}"
                echo "${API_KEY}"
                return 0
            fi
        fi
    done
    
    log_error "Não foi possível obter Gemini API Key do vault ${vault}"
    return 1
}

# ============================================================================
# SETUP VPS UBUNTU
# ============================================================================

setup_vps() {
    log_section "SETUP GEMINI - VPS UBUNTU"
    
    VPS_HOST="${VPS_HOST:-admin-vps}"
    VPS_USER="${VPS_USER:-admin}"
    
    log_info "Conectando na VPS: ${VPS_USER}@${VPS_HOST}"
    
    # Verificar conexão
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_error "Não foi possível conectar na VPS"
        return 1
    fi
    
    # Obter API Key do 1Password
    log_info "Obtendo Gemini API Key do 1Password..."
    
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não encontrado localmente"
        return 1
    fi
    
    API_KEY=$(obter_gemini_api_key "1p_vps")
    
    if [[ -z "${API_KEY}" ]]; then
        log_error "Não foi possível obter API Key"
        return 1
    fi
    
    log_success "API Key obtida"
    
    # Configurar na VPS
    log_info "Configurando Gemini API na VPS..."
    
    ssh "${VPS_USER}@${VPS_HOST}" << VPS_SETUP_EOF
        set -e
        
        # Criar diretório de configuração se não existir
        mkdir -p ~/.config/gemini
        
        # Salvar API Key
        echo "${API_KEY}" > ~/.config/gemini/api_key
        chmod 600 ~/.config/gemini/api_key
        
        # Adicionar ao .bashrc se não existir
        if ! grep -q "GEMINI_API_KEY" ~/.bashrc 2>/dev/null; then
            echo "" >> ~/.bashrc
            echo "# Google Gemini API Key" >> ~/.bashrc
            echo "export GEMINI_API_KEY=\$(cat ~/.config/gemini/api_key 2>/dev/null || echo '')" >> ~/.bashrc
            echo "export GOOGLE_API_KEY=\${GEMINI_API_KEY}" >> ~/.bashrc
        fi
        
        # Testar API Key
        if command -v curl &> /dev/null; then
            echo "Testando Gemini API..."
            RESPONSE=\$(curl -s "https://generativelanguage.googleapis.com/v1/models?key=\${GEMINI_API_KEY}" 2>&1 || echo "ERROR")
            
            if echo "\${RESPONSE}" | grep -q "models"; then
                echo "✅ Gemini API Key válida"
            else
                echo "⚠️ Não foi possível validar API Key"
            fi
        fi
        
        echo "✅ Configuração concluída na VPS"
VPS_SETUP_EOF
    
    log_success "Setup VPS concluído"
    return 0
}

# ============================================================================
# SETUP macOS SILICON
# ============================================================================

setup_macos() {
    log_section "SETUP GEMINI - macOS SILICON"
    
    # Obter API Key do 1Password
    log_info "Obtendo Gemini API Key do 1Password..."
    
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não encontrado"
        return 1
    fi
    
    API_KEY=$(obter_gemini_api_key "1p_macos")
    
    if [[ -z "${API_KEY}" ]]; then
        log_error "Não foi possível obter API Key"
        return 1
    fi
    
    log_success "API Key obtida"
    
    # Criar diretório de configuração
    log_info "Configurando Gemini API no macOS..."
    
    mkdir -p "${HOME}/.config/gemini"
    
    # Salvar API Key
    echo "${API_KEY}" > "${HOME}/.config/gemini/api_key"
    chmod 600 "${HOME}/.config/gemini/api_key"
    
    log_success "API Key salva em ~/.config/gemini/api_key"
    
    # Adicionar ao .zshrc se não existir
    if ! grep -q "GEMINI_API_KEY" "${HOME}/.zshrc" 2>/dev/null; then
        echo "" >> "${HOME}/.zshrc"
        echo "# Google Gemini API Key" >> "${HOME}/.zshrc"
        echo "export GEMINI_API_KEY=\$(cat ~/.config/gemini/api_key 2>/dev/null || echo '')" >> "${HOME}/.zshrc"
        echo "export GOOGLE_API_KEY=\${GEMINI_API_KEY}" >> "${HOME}/.zshrc"
        log_success "Variáveis adicionadas ao .zshrc"
    else
        log_info "Variáveis já existem no .zshrc"
    fi
    
    # Instalar Google Generative AI SDK (Python) se necessário
    log_info "Verificando Google Generative AI SDK..."
    
    if command -v pip3 &> /dev/null; then
        if ! pip3 show google-generativeai &> /dev/null; then
            log_info "Instalando google-generativeai..."
            pip3 install --user google-generativeai || log_warning "Falha ao instalar google-generativeai"
        else
            log_success "google-generativeai já instalado"
        fi
    fi
    
    # Instalar Gemini CLI se necessário
    log_info "Verificando Gemini CLI..."
    
    if ! command -v gemini &> /dev/null; then
        if command -v brew &> /dev/null; then
            log_info "Instalando Gemini CLI via Homebrew..."
            brew install google-gemini-cli || log_warning "Falha ao instalar Gemini CLI"
        else
            log_warning "Homebrew não encontrado, pulando instalação do CLI"
        fi
    else
        log_success "Gemini CLI já instalado"
    fi
    
    # Testar API Key
    log_info "Testando Gemini API..."
    
    if command -v curl &> /dev/null; then
        RESPONSE=$(curl -s "https://generativelanguage.googleapis.com/v1/models?key=${API_KEY}" 2>&1 || echo "ERROR")
        
        if echo "${RESPONSE}" | grep -q "models"; then
            log_success "Gemini API Key válida"
        else
            log_warning "Não foi possível validar API Key (pode ser normal se a API mudou)"
        fi
    fi
    
    log_success "Setup macOS concluído"
    return 0
}

# ============================================================================
# VALIDAR CONFIGURAÇÃO
# ============================================================================

validar_configuracao() {
    log_section "VALIDAÇÃO CONFIGURAÇÃO"
    
    log_info "Validando configuração..."
    
    # Validar arquivos de configuração
    if [[ -f "${HOME}/.config/gemini/api_key" ]]; then
        log_success "API Key encontrada no macOS"
    else
        log_warning "API Key não encontrada no macOS"
    fi
    
    # Validar variáveis de ambiente
    if [[ -n "${GEMINI_API_KEY:-}" ]] || [[ -n "${GOOGLE_API_KEY:-}" ]]; then
        log_success "Variáveis de ambiente configuradas"
    else
        log_warning "Variáveis de ambiente não configuradas (carregue o shell novamente)"
    fi
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  FIX SETUP GEMINI - VPS UBUNTU E macOS SILICON          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Iniciando setup do Gemini..."
    log_info "Log será salvo em: ${LOG_FILE}"
    echo ""
    
    # Cabeçalho do log
    {
        echo "# Fix Setup Gemini - VPS Ubuntu e macOS Silicon"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo ""
        echo "---"
        echo ""
    } > "${LOG_FILE}"
    
    # Verificar 1Password CLI
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não encontrado"
        exit 1
    fi
    
    # Verificar autenticação
    if ! op account list &> /dev/null; then
        log_error "1Password não autenticado"
        exit 1
    fi
    
    log_success "1Password autenticado"
    
    # Executar setups
    if [[ "${SETUP_VPS}" == "true" ]]; then
        setup_vps || log_error "Setup VPS falhou"
    fi
    
    if [[ "${SETUP_MACOS}" == "true" ]]; then
        setup_macos || log_error "Setup macOS falhou"
    fi
    
    # Validar configuração
    validar_configuracao
    
    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  SETUP CONCLUÍDO                                          ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    log_info "Log completo: ${LOG_FILE}"
    log_info "Próximo passo: Recarregue o shell (source ~/.zshrc ou source ~/.bashrc)"
    echo ""
}

main "$@"

