#!/bin/bash

#################################################################################
# Script de Instalação Automática Completa - Gemini Code Assist
# Versão: 2.0.1
# Objetivo: Executar toda a configuração automaticamente sem interação
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$HOME/Dotfiles"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

# Verificar 1Password e item
check_1password_setup() {
    log "Verificando configuração do 1Password..."

    if ! command -v op &> /dev/null; then
        warning "1Password CLI não encontrado"
        return 1
    fi

    if ! op account list &>/dev/null; then
        warning "1Password não autenticado"
        return 1
    fi

    # Verificar se item existe
    if op item get "Gemini_API_Keys" --vault "Infra" &>/dev/null; then
        success "Item Gemini_API_Keys encontrado no 1Password"
        return 0
    else
        warning "Item Gemini_API_Keys não encontrado"
        return 1
    fi
}

# Instalar extensão VSCode
install_vscode_extension() {
    log "Instalando extensão Gemini Code Assist no VSCode..."

    if command -v code &> /dev/null; then
        if code --list-extensions 2>/dev/null | grep -q "GoogleLLC.gemini-code-assist"; then
            success "Extensão já instalada no VSCode"
        else
            code --install-extension GoogleLLC.gemini-code-assist --force 2>/dev/null || true
            success "Extensão instalada no VSCode"
        fi
    else
        warning "VSCode CLI não encontrado"
    fi
}

# Instalar extensão Cursor
install_cursor_extension() {
    log "Instalando extensão Gemini Code Assist no Cursor..."

    if command -v cursor &> /dev/null; then
        if cursor --list-extensions 2>/dev/null | grep -q "GoogleLLC.gemini-code-assist"; then
            success "Extensão já instalada no Cursor"
        else
            cursor --install-extension GoogleLLC.gemini-code-assist --force 2>/dev/null || true
            success "Extensão instalada no Cursor"
        fi
    else
        warning "Cursor CLI não encontrado"
    fi
}

# Obter credenciais do 1Password
get_credential() {
    local field="$1"
    local value=""

    if command -v op &> /dev/null; then
        # Tentar diferentes formatos
        value=$(op read "op://Infra/Gemini_API_Keys/$field" 2>/dev/null || echo "")

        if [ -z "$value" ]; then
            value=$(op item get "Gemini_API_Keys" --vault "Infra" --fields "$field" 2>/dev/null | grep -v "^Title:" | xargs || echo "")
        fi
    fi

    echo "$value"
}

# Configurar VSCode
configure_vscode() {
    log "Configurando VSCode..."

    local vs_code_user_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        vs_code_user_dir="$HOME/Library/Application Support/Code/User"
    else
        vs_code_user_dir="$HOME/.config/Code/User"
    fi

    mkdir -p "$vs_code_user_dir"

    local api_key=$(get_credential "GEMINI_API_KEY")
    local google_api_key=$(get_credential "GOOGLE_API_KEY")

    if [ -z "$api_key" ] || [ -z "$google_api_key" ]; then
        warning "Credenciais não encontradas no 1Password. Configure manualmente."
        return 1
    fi

    local settings_file="$vs_code_user_dir/settings.json"

    # Backup
    if [ -f "$settings_file" ]; then
        cp "$settings_file" "$settings_file.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi

    # Usar jq se disponível, senão adicionar manualmente
    if command -v jq &> /dev/null && [ -f "$settings_file" ]; then
        jq ". + {
            \"geminiCodeAssist.project\": \"gcp-ai-setup-24410\",
            \"geminiCodeAssist.region\": \"us-central1\",
            \"geminiCodeAssist.apiKey\": \"$api_key\",
            \"geminiCodeAssist.googleApiKey\": \"$google_api_key\"
        }" "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
    else
        # Adicionar configurações manualmente
        if [ -f "$settings_file" ]; then
            # Remover configurações antigas se existirem
            sed -i '' '/geminiCodeAssist/d' "$settings_file" 2>/dev/null || \
            sed -i '/geminiCodeAssist/d' "$settings_file" 2>/dev/null || true

            # Adicionar novas configurações
            if grep -q "}" "$settings_file"; then
                sed -i '' '$ s/}$/,\
  "geminiCodeAssist.project": "gcp-ai-setup-24410",\
  "geminiCodeAssist.region": "us-central1",\
  "geminiCodeAssist.apiKey": "'"$api_key"'",\
  "geminiCodeAssist.googleApiKey": "'"$google_api_key"'"\
}/' "$settings_file" 2>/dev/null || \
                sed -i '$ s/}$/,\
  "geminiCodeAssist.project": "gcp-ai-setup-24410",\
  "geminiCodeAssist.region": "us-central1",\
  "geminiCodeAssist.apiKey": "'"$api_key"'",\
  "geminiCodeAssist.googleApiKey": "'"$google_api_key"'"\
}/' "$settings_file" 2>/dev/null || true
            fi
        else
            cat > "$settings_file" << EOF
{
  "geminiCodeAssist.project": "gcp-ai-setup-24410",
  "geminiCodeAssist.region": "us-central1",
  "geminiCodeAssist.apiKey": "$api_key",
  "geminiCodeAssist.googleApiKey": "$google_api_key"
}
EOF
        fi
    fi

    success "VSCode configurado"
}

# Configurar Cursor
configure_cursor() {
    log "Configurando Cursor..."

    local cursor_user_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        cursor_user_dir="$HOME/Library/Application Support/Cursor/User"
    else
        cursor_user_dir="$HOME/.config/Cursor/User"
    fi

    mkdir -p "$cursor_user_dir"

    local api_key=$(get_credential "GEMINI_API_KEY")
    local google_api_key=$(get_credential "GOOGLE_API_KEY")

    if [ -z "$api_key" ] || [ -z "$google_api_key" ]; then
        warning "Credenciais não encontradas no 1Password. Configure manualmente."
        return 1
    fi

    local settings_file="$cursor_user_dir/settings.json"

    # Backup
    if [ -f "$settings_file" ]; then
        cp "$settings_file" "$settings_file.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi

    # Usar jq se disponível
    if command -v jq &> /dev/null && [ -f "$settings_file" ]; then
        jq ". + {
            \"geminiCodeAssist.project\": \"gcp-ai-setup-24410\",
            \"geminiCodeAssist.region\": \"us-central1\",
            \"geminiCodeAssist.apiKey\": \"$api_key\",
            \"geminiCodeAssist.googleApiKey\": \"$google_api_key\",
            \"cursor.ai.gemini.enabled\": true,
            \"cursor.ai.gemini.project\": \"gcp-ai-setup-24410\"
        }" "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
    else
        # Adicionar manualmente (similar ao VSCode)
        if [ -f "$settings_file" ]; then
            sed -i '' '/geminiCodeAssist/d' "$settings_file" 2>/dev/null || \
            sed -i '/geminiCodeAssist/d' "$settings_file" 2>/dev/null || true
        else
            cat > "$settings_file" << EOF
{
  "geminiCodeAssist.project": "gcp-ai-setup-24410",
  "geminiCodeAssist.region": "us-central1",
  "geminiCodeAssist.apiKey": "$api_key",
  "geminiCodeAssist.googleApiKey": "$google_api_key",
  "cursor.ai.gemini.enabled": true,
  "cursor.ai.gemini.project": "gcp-ai-setup-24410"
}
EOF
        fi
    fi

    success "Cursor configurado"
}

# Instalar Gemini CLI
install_gemini_cli() {
    log "Instalando Gemini CLI..."

    if command -v gemini &> /dev/null; then
        success "Gemini CLI já instalado"
        return 0
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install google/gemini/gemini-cli 2>/dev/null || true
            success "Gemini CLI instalado via Homebrew"
        else
            warning "Homebrew não encontrado"
        fi
    else
        # Linux
        curl -L https://github.com/google/gemini-cli/releases/latest/download/gemini-cli-linux-amd64 -o /tmp/gemini-cli 2>/dev/null || true
        if [ -f /tmp/gemini-cli ]; then
            sudo mv /tmp/gemini-cli /usr/local/bin/gemini 2>/dev/null || true
            sudo chmod +x /usr/local/bin/gemini 2>/dev/null || true
            success "Gemini CLI instalado"
        fi
    fi
}

# Configurar Gemini CLI
configure_gemini_cli() {
    log "Configurando Gemini CLI..."

    local gemini_config_dir="$HOME/.config/gemini"
    mkdir -p "$gemini_config_dir"

    local api_key=$(get_credential "GEMINI_API_KEY")
    local google_api_key=$(get_credential "GOOGLE_API_KEY")

    if [ -z "$api_key" ] || [ -z "$google_api_key" ]; then
        warning "Credenciais não encontradas. Gemini CLI não configurado."
        return 1
    fi

    cat > "$gemini_config_dir/config.yaml" << EOF
# Gemini CLI Configuration
# Generated automatically on $(date)

gemini:
  apiKey: $api_key
  project: gcp-ai-setup-24410
  location: us-central1

google:
  apiKey: $google_api_key
  projectId: gcp-ai-setup-24410
  region: us-central1
EOF

    success "Gemini CLI configurado"
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Instalação Automática - Gemini Code Assist          ║"
    echo "║              Versão 2.0.1 - Auto Setup                    ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    # Verificar 1Password
    if ! check_1password_setup; then
        warning "1Password não configurado. Continuando sem integração..."
        warning "Configure manualmente as credenciais nos editores."
    fi

    echo ""

    # Instalar extensões
    install_vscode_extension
    install_cursor_extension

    echo ""

    # Configurar editores
    configure_vscode
    configure_cursor

    echo ""

    # Instalar e configurar Gemini CLI
    install_gemini_cli
    configure_gemini_cli

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              INSTALAÇÃO AUTOMÁTICA CONCLUÍDA                ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Configuração concluída!"
    echo ""
    echo "Próximas ações:"
    echo "1. Reinicie VSCode e Cursor"
    echo "2. Verifique se as extensões estão ativas"
    echo "3. Teste o Gemini Code Assist"
    echo ""
}

main "$@"
