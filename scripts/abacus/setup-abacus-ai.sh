#!/bin/bash
# ==========================================
# Script de Setup - Abacus AI
# Versão: 1.0.0
# Data: 2025-12-02
# ==========================================

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Diretórios
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Dotfiles}"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
CONFIGS_DIR="$DOTFILES_DIR/configs"

# Função de logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar pré-requisitos
check_prerequisites() {
    log_info "Verificando pré-requisitos..."

    # Verificar 1Password CLI
    if ! command -v op >/dev/null 2>&1; then
        log_error "1Password CLI não instalado. Instale via: brew install --cask 1password-cli"
        exit 1
    fi

    # Verificar autenticação 1Password
    if ! op whoami >/dev/null 2>&1; then
        log_warn "1Password não autenticado. Execute: op signin"
        log_info "Tentando autenticar automaticamente..."
        op signin --account my.1password.com || {
            log_error "Falha na autenticação do 1Password"
            exit 1
        }
    fi

    # Verificar jq
    if ! command -v jq >/dev/null 2>&1; then
        log_warn "jq não instalado. Instalando via Homebrew..."
        brew install jq || {
            log_error "Falha ao instalar jq"
            exit 1
        }
    fi

    log_info "✅ Pré-requisitos verificados"
}

# Verificar credenciais no 1Password
check_credentials() {
    log_info "Verificando credenciais no 1Password..."

    # Verificar API Key
    if op item get "Abacus-AI-API-Key" --vault "1p_macos" >/dev/null 2>&1; then
        log_info "✅ Abacus-AI-API-Key encontrada no 1Password"
    else
        log_warn "⚠️  Abacus-AI-API-Key não encontrada no 1Password"
        log_info "Criando item no 1Password..."
        read -p "Digite a API Key do Abacus AI: " -s api_key
        echo

        op item create \
            --category "API Credential" \
            --title "Abacus-AI-API-Key" \
            --vault "1p_macos" \
            credential="$api_key" \
            --tag "api-key" --tag "abacus" || {
            log_error "Falha ao criar item no 1Password"
            exit 1
        }

        log_info "✅ Item criado no 1Password"
    fi

    # Verificar Account
    if op item get "Abacus-AI-Account" --vault "1p_macos" >/dev/null 2>&1; then
        log_info "✅ Abacus-AI-Account encontrada no 1Password"
    else
        log_warn "⚠️  Abacus-AI-Account não encontrada no 1Password"
        log_info "Criando item no 1Password..."
        read -p "Digite o email da conta Abacus AI: " account_email

        op item create \
            --category "Login" \
            --title "Abacus-AI-Account" \
            --vault "1p_macos" \
            username="$account_email" \
            --tag "abacus" --tag "account" || {
            log_error "Falha ao criar item no 1Password"
            exit 1
        }

        log_info "✅ Item criado no 1Password"
    fi
}

# Configurar variáveis de ambiente
setup_environment() {
    log_info "Configurando variáveis de ambiente..."

    # Verificar se já existe configuração no .zshrc
    if grep -q "ABACUS_API_KEY" "$HOME/.zshrc" 2>/dev/null; then
        log_warn "⚠️  Configuração do Abacus AI já existe no .zshrc"
    else
        log_info "Adicionando configuração ao .zshrc..."

        cat >> "$HOME/.zshrc" << 'EOF'

# ==========================================
# Abacus AI Configuration
# ==========================================
if command -v op >/dev/null 2>&1 && op whoami >/dev/null 2>&1; then
    export ABACUS_API_KEY=$(op read "op://1p_macos/Abacus-AI-API-Key/credential" 2>/dev/null)
    export ABACUS_ACCOUNT_EMAIL=$(op read "op://1p_macos/Abacus-AI-Account/username" 2>/dev/null)

    if [ -n "$ABACUS_API_KEY" ]; then
        export ABACUS_AI_ENABLED=true
    fi
fi
EOF

        log_info "✅ Configuração adicionada ao .zshrc"
    fi
}

# Criar script de carregamento
create_load_script() {
    log_info "Criando script de carregamento de credenciais..."

    mkdir -p "$SCRIPTS_DIR/abacus"

    cat > "$SCRIPTS_DIR/abacus/load-abacus-keys.sh" << 'EOF'
#!/bin/bash
# Carregar credenciais do Abacus AI do 1Password

if command -v op >/dev/null 2>&1; then
    if op whoami >/dev/null 2>&1; then
        export ABACUS_API_KEY=$(op read "op://1p_macos/Abacus-AI-API-Key/credential" 2>/dev/null)
        export ABACUS_ACCOUNT_EMAIL=$(op read "op://1p_macos/Abacus-AI-Account/username" 2>/dev/null)

        if [ -n "$ABACUS_API_KEY" ]; then
            export ABACUS_AI_ENABLED=true
            echo "✅ Abacus AI credenciais carregadas"
        else
            echo "⚠️  Abacus AI API Key não encontrada no 1Password"
        fi
    else
        echo "⚠️  1Password não autenticado. Execute: op signin"
    fi
else
    echo "⚠️  1Password CLI não instalado"
fi
EOF

    chmod +x "$SCRIPTS_DIR/abacus/load-abacus-keys.sh"
    log_info "✅ Script de carregamento criado"
}

# Criar script de teste
create_test_script() {
    log_info "Criando script de teste da API..."

    cat > "$SCRIPTS_DIR/abacus/test-abacus-api.sh" << 'EOF'
#!/bin/bash
# Testar conexão com a API do Abacus AI

source "$(dirname "$0")/load-abacus-keys.sh"

if [ -z "$ABACUS_API_KEY" ]; then
    echo "❌ ABACUS_API_KEY não definida"
    exit 1
fi

echo "Testando conexão com Abacus AI API..."

# Testar endpoint de informações da conta
response=$(curl -s -w "\n%{http_code}" -X GET "https://api.abacus.ai/v1/account/info" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}")

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" -eq 200 ]; then
    echo "✅ Conexão bem-sucedida!"
    echo "$body" | jq '.' 2>/dev/null || echo "$body"
else
    echo "❌ Falha na conexão (HTTP $http_code)"
    echo "$body"
    exit 1
fi
EOF

    chmod +x "$SCRIPTS_DIR/abacus/test-abacus-api.sh"
    log_info "✅ Script de teste criado"
}

# Criar script de monitoramento de créditos
create_monitor_script() {
    log_info "Criando script de monitoramento de créditos..."

    cat > "$SCRIPTS_DIR/abacus/monitor-credits.sh" << 'EOF'
#!/bin/bash
# Monitorar créditos do Abacus AI

source "$(dirname "$0")/load-abacus-keys.sh"

if [ -z "$ABACUS_API_KEY" ]; then
    echo "❌ ABACUS_API_KEY não definida"
    exit 1
fi

THRESHOLD=${1:-100000}

response=$(curl -s -X GET "https://api.abacus.ai/v1/account/credits" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}")

credits=$(echo "$response" | jq -r '.credits // .available_credits // "unknown"')

if [ "$credits" = "unknown" ]; then
    echo "⚠️  Não foi possível obter informações de créditos"
    echo "Resposta da API:"
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    exit 1
fi

echo "Créditos disponíveis: $credits"

if [ "$credits" -lt "$THRESHOLD" ]; then
    echo "⚠️  ATENÇÃO: Créditos abaixo do threshold ($THRESHOLD)"
    exit 1
else
    echo "✅ Créditos acima do threshold"
fi
EOF

    chmod +x "$SCRIPTS_DIR/abacus/monitor-credits.sh"
    log_info "✅ Script de monitoramento criado"
}

# Validar configuração
validate_setup() {
    log_info "Validando configuração..."

    # Carregar credenciais
    source "$SCRIPTS_DIR/abacus/load-abacus-keys.sh" 2>/dev/null || true

    if [ -z "${ABACUS_API_KEY:-}" ]; then
        log_warn "⚠️  ABACUS_API_KEY não está definida"
        log_info "Execute: source $SCRIPTS_DIR/abacus/load-abacus-keys.sh"
    else
        log_info "✅ ABACUS_API_KEY está definida"
    fi

    # Verificar arquivo de configuração
    if [ -f "$CONFIGS_DIR/abacus_config.json" ]; then
        log_info "✅ Arquivo de configuração encontrado"
    else
        log_warn "⚠️  Arquivo de configuração não encontrado"
    fi
}

# Main
main() {
    log_info "=========================================="
    log_info "Setup Abacus AI - Iniciando"
    log_info "=========================================="

    check_prerequisites
    check_credentials
    setup_environment
    create_load_script
    create_test_script
    create_monitor_script
    validate_setup

    log_info "=========================================="
    log_info "✅ Setup Abacus AI - Concluído"
    log_info "=========================================="
    log_info ""
    log_info "Próximos passos:"
    log_info "1. Recarregue o shell: source ~/.zshrc"
    log_info "2. Teste a API: $SCRIPTS_DIR/abacus/test-abacus-api.sh"
    log_info "3. Monitore créditos: $SCRIPTS_DIR/abacus/monitor-credits.sh"
    log_info ""
    log_info "Documentação completa:"
    log_info "$DOTFILES_DIR/system_prompts/global/docs/ABACUS_SETUP_v1.0.0_20251202.md"
}

# Executar main
main "$@"











