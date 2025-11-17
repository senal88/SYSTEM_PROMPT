#!/bin/bash

#################################################################################
# Script de Instalação e Configuração de Extensões Google (Gemini Code Assist)
# Versão: 2.0.1
# Compatibilidade: macOS Silicon, Ubuntu 22.04+
# Objetivo: Instalar e configurar Gemini Code Assist no VSCode e Cursor
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$HOME/Dotfiles"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuração do Projeto GCP
GCP_PROJECT_ID="gcp-ai-setup-24410"
GCP_PROJECT_NUMBER="501288307921"
GCP_REGION="us-central1"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detectar sistema operacional
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        success "Sistema detectado: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        success "Sistema detectado: Linux"
    else
        error "Sistema operacional não suportado: $OSTYPE"
        exit 1
    fi
}

# Verificar 1Password CLI
check_1password() {
    if command -v op &> /dev/null; then
        success "1Password CLI encontrado"

        # Verificar se está autenticado
        if op account list &>/dev/null; then
            success "1Password autenticado"
            return 0
        else
            warning "1Password não autenticado"
            echo ""
            echo "Execute: op signin"
            return 1
        fi
    else
        warning "1Password CLI não encontrado"
        echo ""
        if [ "$OS" == "macos" ]; then
            echo "Instale com: brew install --cask 1password-cli"
        else
            echo "Instale com: curl -sSf https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg"
            echo "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list"
            echo "sudo apt update && sudo apt install 1password-cli"
        fi
        return 1
    fi
}

# Obter credenciais do 1Password
get_1password_credential() {
    local vault="$1"
    local item="$2"
    local field="$3"

    if command -v op &> /dev/null; then
        # Tentar formato op:// primeiro
        local value=$(op read "op://$vault/$item/$field" 2>/dev/null)
        if [ -n "$value" ]; then
            echo "$value"
            return 0
        fi

        # Fallback: usar op item get
        value=$(op item get "$item" --vault "$vault" --fields "$field" 2>/dev/null | grep -v "^Title:" | xargs)
        if [ -n "$value" ]; then
            echo "$value"
            return 0
        fi

        # Último fallback: tentar como campo customizado
        value=$(op item get "$item" --vault "$vault" --format json 2>/dev/null | \
            grep -o "\"$field\":\"[^\"]*\"" | cut -d'"' -f4)
        if [ -n "$value" ]; then
            echo "$value"
            return 0
        fi
    fi

    echo ""
    return 1
}

# Instalar extensão no VSCode
install_vscode_extension() {
    local extension_id="$1"
    local extension_name="$2"

    log "Instalando extensão $extension_name no VSCode..."

    if command -v code &> /dev/null; then
        if code --list-extensions | grep -q "$extension_id"; then
            success "$extension_name já instalado no VSCode"
        else
            code --install-extension "$extension_id" --force
            success "$extension_name instalado no VSCode"
        fi
    else
        warning "VSCode CLI não encontrado. Instale a extensão manualmente."
    fi
}

# Instalar extensão no Cursor
install_cursor_extension() {
    local extension_id="$1"
    local extension_name="$2"

    log "Instalando extensão $extension_name no Cursor..."

    if command -v cursor &> /dev/null; then
        if cursor --list-extensions 2>/dev/null | grep -q "$extension_id"; then
            success "$extension_name já instalado no Cursor"
        else
            cursor --install-extension "$extension_id" --force
            success "$extension_name instalado no Cursor"
        fi
    else
        warning "Cursor CLI não encontrado. Instale a extensão manualmente."
    fi
}

# Configurar VSCode Gemini Code Assist
configure_vscode_gemini() {
    log "Configurando Gemini Code Assist no VSCode..."

    local vs_code_user_dir
    if [ "$OS" == "macos" ]; then
        vs_code_user_dir="$HOME/Library/Application Support/Code/User"
    else
        vs_code_user_dir="$HOME/.config/Code/User"
    fi

    mkdir -p "$vs_code_user_dir"

    # Obter credenciais do 1Password
    local api_key=$(get_1password_credential "Infra" "Gemini_API_Keys" "GEMINI_API_KEY")
    local google_api_key=$(get_1password_credential "Infra" "Gemini_API_Keys" "GOOGLE_API_KEY")

    # Criar/atualizar settings.json
    local settings_file="$vs_code_user_dir/settings.json"

    if [ -f "$settings_file" ]; then
        # Backup
        cp "$settings_file" "$settings_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Ler settings existente ou criar novo
    if [ -f "$settings_file" ]; then
        # Usar jq se disponível, senão usar sed
        if command -v jq &> /dev/null; then
            jq ". + {
                \"geminiCodeAssist.project\": \"$GCP_PROJECT_ID\",
                \"geminiCodeAssist.apiKey\": \"$api_key\",
                \"geminiCodeAssist.googleApiKey\": \"$google_api_key\",
                \"geminiCodeAssist.region\": \"$GCP_REGION\"
            }" "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
        else
            # Fallback: adicionar manualmente
            cat >> "$settings_file" << EOF

  // Gemini Code Assist Configuration
  "geminiCodeAssist.project": "$GCP_PROJECT_ID",
  "geminiCodeAssist.apiKey": "$api_key",
  "geminiCodeAssist.googleApiKey": "$google_api_key",
  "geminiCodeAssist.region": "$GCP_REGION",
EOF
        fi
    else
        # Criar novo settings.json
        cat > "$settings_file" << EOF
{
  // Gemini Code Assist Configuration
  "geminiCodeAssist.project": "$GCP_PROJECT_ID",
  "geminiCodeAssist.apiKey": "$api_key",
  "geminiCodeAssist.googleApiKey": "$google_api_key",
  "geminiCodeAssist.region": "$GCP_REGION"
}
EOF
    fi

    success "VSCode Gemini Code Assist configurado"
}

# Configurar Cursor Gemini Code Assist
configure_cursor_gemini() {
    log "Configurando Gemini Code Assist no Cursor..."

    local cursor_user_dir
    if [ "$OS" == "macos" ]; then
        cursor_user_dir="$HOME/Library/Application Support/Cursor/User"
    else
        cursor_user_dir="$HOME/.config/Cursor/User"
    fi

    mkdir -p "$cursor_user_dir"

    # Obter credenciais do 1Password
    local api_key=$(get_1password_credential "Infra" "Gemini_API_Keys" "GEMINI_API_KEY")
    local google_api_key=$(get_1password_credential "Infra" "Gemini_API_Keys" "GOOGLE_API_KEY")

    # Criar/atualizar settings.json
    local settings_file="$cursor_user_dir/settings.json"

    if [ -f "$settings_file" ]; then
        # Backup
        cp "$settings_file" "$settings_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Ler settings existente ou criar novo
    if [ -f "$settings_file" ]; then
        if command -v jq &> /dev/null; then
            jq ". + {
                \"geminiCodeAssist.project\": \"$GCP_PROJECT_ID\",
                \"geminiCodeAssist.apiKey\": \"$api_key\",
                \"geminiCodeAssist.googleApiKey\": \"$google_api_key\",
                \"geminiCodeAssist.region\": \"$GCP_REGION\"
            }" "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
        else
            cat >> "$settings_file" << EOF

  // Gemini Code Assist Configuration
  "geminiCodeAssist.project": "$GCP_PROJECT_ID",
  "geminiCodeAssist.apiKey": "$api_key",
  "geminiCodeAssist.googleApiKey": "$google_api_key",
  "geminiCodeAssist.region": "$GCP_REGION",
EOF
        fi
    else
        cat > "$settings_file" << EOF
{
  // Gemini Code Assist Configuration
  "geminiCodeAssist.project": "$GCP_PROJECT_ID",
  "geminiCodeAssist.apiKey": "$api_key",
  "geminiCodeAssist.googleApiKey": "$google_api_key",
  "geminiCodeAssist.region": "$GCP_REGION"
}
EOF
    fi

    success "Cursor Gemini Code Assist configurado"
}

# Instalar Gemini CLI
install_gemini_cli() {
    log "Instalando Gemini CLI..."

    if command -v gemini &> /dev/null; then
        success "Gemini CLI já instalado"
        gemini --version
    else
        if [ "$OS" == "macos" ]; then
            if command -v brew &> /dev/null; then
                brew install google/gemini/gemini-cli
                success "Gemini CLI instalado via Homebrew"
            else
                warning "Homebrew não encontrado. Instale manualmente: https://github.com/google/gemini-cli"
            fi
        else
            # Ubuntu/Linux
            log "Instalando Gemini CLI no Linux..."
            curl -L https://github.com/google/gemini-cli/releases/latest/download/gemini-cli-linux-amd64 -o /tmp/gemini-cli
            sudo mv /tmp/gemini-cli /usr/local/bin/gemini
            sudo chmod +x /usr/local/bin/gemini
            success "Gemini CLI instalado"
        fi
    fi
}

# Configurar Gemini CLI
configure_gemini_cli() {
    log "Configurando Gemini CLI..."

    local gemini_config_dir="$HOME/.config/gemini"
    mkdir -p "$gemini_config_dir"

    # Obter credenciais do 1Password
    local api_key=$(get_1password_credential "Infra" "Gemini_API_Keys" "GEMINI_API_KEY")
    local google_api_key=$(get_1password_credential "Infra" "Gemini_API_Keys" "GOOGLE_API_KEY")

    # Criar arquivo de configuração
    cat > "$gemini_config_dir/config.yaml" << EOF
# Gemini CLI Configuration
# Generated automatically on $(date)

gemini:
  apiKey: $api_key
  project: $GCP_PROJECT_ID
  location: $GCP_REGION

google:
  apiKey: $google_api_key
  projectId: $GCP_PROJECT_ID
  region: $GCP_REGION
EOF

    success "Gemini CLI configurado em $gemini_config_dir/config.yaml"
}

main() {
    clear

    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Instalação Extensões Google (Gemini Code Assist)    ║"
    echo "║              Versão 2.0.1 - Universal Setup                ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    detect_os

    echo ""
    warning "Este script irá:"
    echo "1. Instalar extensão Gemini Code Assist no VSCode e Cursor"
    echo "2. Configurar credenciais via 1Password"
    echo "3. Instalar e configurar Gemini CLI"
    echo ""
    read -p "Continuar? (s/N): " confirm

    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        log "Operação cancelada"
        exit 0
    fi

    echo ""

    # Verificar 1Password
    if ! check_1password; then
        warning "1Password não configurado. Continuando sem integração..."
    fi

    echo ""

    # Instalar extensões
    log "Instalando extensões..."
    install_vscode_extension "GoogleLLC.gemini-code-assist" "Gemini Code Assist"
    install_cursor_extension "GoogleLLC.gemini-code-assist" "Gemini Code Assist"

    echo ""

    # Configurar editores
    configure_vscode_gemini
    configure_cursor_gemini

    echo ""

    # Instalar e configurar Gemini CLI
    install_gemini_cli
    configure_gemini_cli

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              INSTALAÇÃO CONCLUÍDA COM SUCESSO                ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Todas as configurações aplicadas!"
    echo ""
    echo "Próximas ações:"
    echo "1. Reinicie VSCode e Cursor para aplicar as configurações"
    echo "2. Verifique se as extensões estão ativas"
    echo "3. Teste o Gemini Code Assist em um arquivo"
    echo ""
    echo "Configurações aplicadas:"
    echo "  Projeto GCP: $GCP_PROJECT_ID"
    echo "  Região: $GCP_REGION"
    echo ""
}

main "$@"
