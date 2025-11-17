#!/bin/bash

#################################################################################
# Script de Configuração OAuth Local - Governança Centralizada
# Versão: 2.0.1
# Objetivo: Configurar OAuth local usando ~/Dotfiles como padrão global
#################################################################################

set -e

DOTFILES_DIR="$HOME/Dotfiles"
CREDENTIALS_DIR="$DOTFILES_DIR/credentials"
OAUTH_DIR="$CREDENTIALS_DIR/oauth"
SERVICE_ACCOUNTS_DIR="$CREDENTIALS_DIR/service-accounts"

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

# Detectar sistema operacional
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        success "Sistema detectado: macOS Silicon"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        success "Sistema detectado: Ubuntu Linux"
    else
        error "Sistema operacional não suportado"
        exit 1
    fi
}

# Criar estrutura de diretórios
create_structure() {
    log "Criando estrutura de diretórios..."

    mkdir -p "$CREDENTIALS_DIR"/{oauth,service-accounts,api-keys}
    mkdir -p "$OAUTH_DIR"/{google,github,other}
    mkdir -p "$SERVICE_ACCOUNTS_DIR"

    # Criar .gitignore se não existir
    if [ ! -f "$CREDENTIALS_DIR/.gitignore" ]; then
        cat > "$CREDENTIALS_DIR/.gitignore" << 'EOF'
# Credenciais - NUNCA commitar
*.json
*.key
*.pem
*.p12
*.env
*.txt
*.local
*.secret
!*.example
!*.template
EOF
        success ".gitignore criado"
    fi

    success "Estrutura criada"
}

# Configurar OAuth Google
setup_google_oauth() {
    log "Configurando OAuth Google..."

    local oauth_file="$OAUTH_DIR/google/oauth-client-secret.json"

    # Verificar se já existe
    if [ -f "$oauth_file" ]; then
        success "OAuth Google já configurado"
        return 0
    fi

    # Tentar obter do 1Password
    if command -v op &> /dev/null; then
        local vault=$(op vault list --format json 2>/dev/null | jq -r '.[] | select(.name == "1p_macos" or .name == "Personal") | .name' | head -1 || echo "Personal")

        # Tentar diferentes nomes de itens
        for item_name in "Google_OAuth_Credentials" "Google_OAuth" "OAuth_Google"; do
            if op item get "$item_name" --vault "$vault" &>/dev/null 2>&1; then
                op document get "$item_name" --vault "$vault" > "$oauth_file" 2>/dev/null && {
                    chmod 600 "$oauth_file"
                    success "OAuth Google obtido do 1Password"
                    return 0
                }
            fi
        done
    fi

    # Criar template se não encontrado
    cat > "$oauth_file.example" << 'EOF'
{
  "web": {
    "client_id": "YOUR_CLIENT_ID.apps.googleusercontent.com",
    "project_id": "gcp-ai-setup-24410",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_secret": "YOUR_CLIENT_SECRET",
    "redirect_uris": [
      "http://localhost:8080/oauth2callback",
      "http://localhost:3000/oauth2callback"
    ]
  }
}
EOF

    warning "OAuth Google não encontrado no 1Password. Template criado em $oauth_file.example"
}

# Configurar Service Account GCP
setup_gcp_service_account() {
    log "Configurando GCP Service Account..."

    local sa_file="$SERVICE_ACCOUNTS_DIR/gcp-ai-setup-24410.json"

    # Verificar se já existe
    if [ -f "$sa_file" ]; then
        success "Service Account já configurado"
        return 0
    fi

    # Tentar obter do 1Password ou arquivo fonte
    local source_file="/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/curso-n8n/aulas/04-workflows-iniciantes/aula-15-criando-projeto-no-console-do-google-e-chave-de-api-do-gemini /gcp-ai-setup-24410-2141022d473f.json"

    if [ -f "$source_file" ]; then
        cp "$source_file" "$sa_file"
        chmod 600 "$sa_file"
        success "Service Account copiado de $source_file"
        return 0
    fi

    # Tentar obter do 1Password
    if command -v op &> /dev/null; then
        local vault=$(op vault list --format json 2>/dev/null | jq -r '.[] | select(.name == "1p_macos" or .name == "Personal") | .name' | head -1 || echo "Personal")

        for item_name in "GCP_Service_Account_gcp-ai-setup-24410" "GCP_Service_Account" "gcp-ai-setup-24410"; do
            if op item get "$item_name" --vault "$vault" &>/dev/null 2>&1; then
                op document get "$item_name" --vault "$vault" > "$sa_file" 2>/dev/null && {
                    chmod 600 "$sa_file"
                    success "Service Account obtido do 1Password"
                    return 0
                }
            fi
        done
    fi

    warning "Service Account não encontrado. Configure manualmente em $sa_file"
}

# Configurar variáveis de ambiente
setup_env_vars() {
    log "Configurando variáveis de ambiente..."

    local env_file="$CREDENTIALS_DIR/.env.local"

    # Ler credenciais
    local gemini_key=""
    local google_key=""

    # Tentar do 1Password
    if command -v op &> /dev/null; then
        local vault=$(op vault list --format json 2>/dev/null | jq -r '.[] | select(.name == "1p_macos" or .name == "Personal") | .name' | head -1 || echo "Personal")

        if op item get "Gemini_API_Keys" --vault "$vault" &>/dev/null 2>&1; then
            gemini_key=$(op read "op://$vault/Gemini_API_Keys/GEMINI_API_KEY" 2>/dev/null || echo "")
            google_key=$(op read "op://$vault/Gemini_API_Keys/GOOGLE_API_KEY" 2>/dev/null || echo "")
        fi
    fi

    # Fallback: ler de arquivos locais
    if [ -z "$gemini_key" ] && [ -f "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local" ]; then
        gemini_key=$(cat "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local")
    fi

    if [ -z "$google_key" ] && [ -f "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local" ]; then
        google_key=$(cat "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local")
    fi

    # Criar arquivo .env.local
    cat > "$env_file" << EOF
# Credenciais Locais - Gerado automaticamente
# NUNCA commitar este arquivo

# GCP Configuration
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"
export GOOGLE_APPLICATION_CREDENTIALS="$SERVICE_ACCOUNTS_DIR/gcp-ai-setup-24410.json"

# Gemini API Keys
export GEMINI_API_KEY="$gemini_key"
export GOOGLE_API_KEY="$google_key"

# OAuth
export GOOGLE_OAUTH_CLIENT_SECRET="$OAUTH_DIR/google/oauth-client-secret.json"
EOF

    chmod 600 "$env_file"
    success "Variáveis de ambiente configuradas em $env_file"

    # Adicionar ao shell rc se não estiver
    local shell_rc=""
    if [ "$OS" == "macos" ]; then
        shell_rc="$HOME/.zshrc"
    else
        shell_rc="$HOME/.bashrc"
    fi

    if [ -f "$shell_rc" ] && ! grep -q "Dotfiles/credentials/.env.local" "$shell_rc"; then
        echo "" >> "$shell_rc"
        echo "# Dotfiles Credentials" >> "$shell_rc"
        echo "source $env_file 2>/dev/null || true" >> "$shell_rc"
        success "Adicionado ao $shell_rc"
    fi
}

# Configurar gcloud
setup_gcloud() {
    log "Configurando gcloud..."

    if ! command -v gcloud &> /dev/null; then
        warning "gcloud CLI não instalado"
        return 1
    fi

    # Configurar projeto
    gcloud config set project gcp-ai-setup-24410 2>/dev/null || true

    # Configurar service account se existir
    if [ -f "$SERVICE_ACCOUNTS_DIR/gcp-ai-setup-24410.json" ]; then
        export GOOGLE_APPLICATION_CREDENTIALS="$SERVICE_ACCOUNTS_DIR/gcp-ai-setup-24410.json"
        gcloud auth activate-service-account --key-file="$SERVICE_ACCOUNTS_DIR/gcp-ai-setup-24410.json" 2>/dev/null || true
        success "Service Account ativado no gcloud"
    fi

    success "gcloud configurado"
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Configuração OAuth Local - Governança Global         ║"
    echo "║              Versão 2.0.1 - ~/Dotfiles                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    detect_os
    create_structure
    setup_google_oauth
    setup_gcp_service_account
    setup_env_vars
    setup_gcloud

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              CONFIGURAÇÃO CONCLUÍDA                         ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "OAuth local configurado em ~/Dotfiles/credentials"
    echo ""
    echo "Estrutura criada:"
    echo "  - OAuth: $OAUTH_DIR"
    echo "  - Service Accounts: $SERVICE_ACCOUNTS_DIR"
    echo "  - API Keys: $CREDENTIALS_DIR/api-keys"
    echo "  - Env vars: $CREDENTIALS_DIR/.env.local"
    echo ""
}

main "$@"
