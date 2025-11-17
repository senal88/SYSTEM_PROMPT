#!/bin/bash
# Setup Hugging Face CLI com 1Password
# Configura Hugging Face CLI com autenticação via 1Password

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Verificar se 1Password está configurado
if ! op whoami &>/dev/null; then
    log_error "1Password não está logado. Execute: op-signin-auto"
    exit 1
fi

log_info "🚀 Configurando Hugging Face CLI..."

# Determinar vault padrão
if [[ "$(hostname)" == *"MacBook"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    VAULT="1p_macos"
    VAULT_ID="gkpsbgizlks2zknwzqpppnb2ze"
else
    VAULT="1p_vps"
    VAULT_ID="oa3tidekmeu26nxiier2qbi7v4"
fi

# Verificar se Hugging Face CLI está instalado
if ! command -v huggingface-cli &>/dev/null; then
    log_warning "Hugging Face CLI não instalado"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Instalando via pip..."
        pip install huggingface_hub[cli]
    else
        log_info "Instale via: pip install huggingface_hub[cli]"
        exit 1
    fi
fi

# 1. Verificar se Hugging Face Token existe no 1Password
log_info "Verificando token do Hugging Face no 1Password..."
if ! op item get "Hugging Face Token" --vault "$VAULT" &>/dev/null; then
    log_warning "Token do Hugging Face não encontrado no vault $VAULT"
    log_info "Criando item no 1Password..."

    read -p "Digite o token do Hugging Face (ou pressione Enter para pular): " HF_TOKEN

    if [ -n "$HF_TOKEN" ]; then
        op item create \
            --category=password \
            --title="Hugging Face Token" \
            --vault="$VAULT" \
            --field="username=senal88" \
            --field="password=$HF_TOKEN" \
            --field="url=https://huggingface.co/settings/tokens" \
            --field="notes=Token de acesso do Hugging Face (senal88)"

        log_success "Token do Hugging Face criado no 1Password"
    else
        log_warning "Pulando criação do token. Configure manualmente depois."
        exit 1
    fi
fi

# 2. Obter token e fazer login
log_info "Fazendo login no Hugging Face..."

HF_TOKEN=$(op item get "Hugging Face Token" --vault "$VAULT" --field password)

if echo "$HF_TOKEN" | huggingface-cli login --token "$HF_TOKEN" &>/dev/null; then
    log_success "Hugging Face CLI autenticado"

    # Verificar autenticação
    if huggingface-cli whoami &>/dev/null; then
        USERNAME=$(huggingface-cli whoami)
        log_success "Logado como: $USERNAME"
    fi
else
    log_error "Erro ao autenticar no Hugging Face CLI"
    exit 1
fi

# 3. Configurar variáveis de ambiente
log_info "Configurando variáveis de ambiente..."

# Endpoint URL
HF_ENDPOINT_URL="https://endpoints.huggingface.co/senal88/endpoints/all-minilm-l6-v2-bks"

# Adicionar ao shell config
SHELL_RC="$HOME/.zshrc"
if [[ "$OSTYPE" != "darwin"* ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

if ! grep -q "HF_TOKEN" "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << EOF

# Hugging Face Configuration
export HF_TOKEN="\$(op item get 'Hugging Face Token' --vault $VAULT --field password 2>/dev/null || echo '')"
export HF_ENDPOINT_URL="$HF_ENDPOINT_URL"
export HF_USERNAME="senal88"
EOF
    log_success "Variáveis de ambiente adicionadas ao $SHELL_RC"
else
    log_info "Variáveis de ambiente já configuradas"
fi

# 4. Criar funções helper
log_info "Criando funções helper..."

HF_FUNCTIONS_FILE="$DOTFILES_HOME/automation_1password/scripts/hf-functions.sh"

mkdir -p "$(dirname "$HF_FUNCTIONS_FILE")"

cat > "$HF_FUNCTIONS_FILE" << 'EOF'
#!/bin/bash
# Funções helper para Hugging Face

# Login no Hugging Face usando 1Password
hf-login() {
    local vault="${1:-1p_macos}"
    local token=$(op item get "Hugging Face Token" --vault "$vault" --field password)
    echo "$token" | huggingface-cli login --token "$token"
    export HF_TOKEN="$token"
    echo "✅ Logado no Hugging Face"
}

# Deploy de modelo
hf-deploy-model() {
    local model_path="$1"
    local repo_name="${2:-senal88/$(basename "$model_path")}"

    if [ -z "$model_path" ]; then
        echo "Uso: hf-deploy-model <caminho_modelo> [repo_name]"
        return 1
    fi

    huggingface-cli upload "$repo_name" "$model_path" --repo-type=model
    echo "✅ Modelo deployado: $repo_name"
}

# Upload de dataset
hf-upload-dataset() {
    local dataset_path="$1"
    local repo_name="${2:-senal88/$(basename "$dataset_path")}"

    if [ -z "$dataset_path" ]; then
        echo "Uso: hf-upload-dataset <caminho_dataset> [repo_name]"
        return 1
    fi

    huggingface-cli upload "$repo_name" "$dataset_path" --repo-type=dataset
    echo "✅ Dataset enviado: $repo_name"
}

# Query no endpoint
hf-query-endpoint() {
    local prompt="$1"
    local endpoint_url="${HF_ENDPOINT_URL:-https://endpoints.huggingface.co/senal88/endpoints/all-minilm-l6-v2-bks}"
    local token="${HF_TOKEN:-$(op item get 'Hugging Face Token' --vault 1p_macos --field password)}"

    if [ -z "$prompt" ]; then
        echo "Uso: hf-query-endpoint <prompt>"
        return 1
    fi

    curl -X POST "$endpoint_url" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"inputs\": \"$prompt\"}" | jq .
}

# Listar modelos do usuário
hf-list-models() {
    huggingface-cli list-models --author=senal88
}

# Listar datasets do usuário
hf-list-datasets() {
    huggingface-cli list-datasets --author=senal88
}

# Status do Hugging Face
hf-status() {
    echo "👤 Usuário: $(huggingface-cli whoami)"
    echo "🔗 Endpoint: ${HF_ENDPOINT_URL:-N/A}"
    echo "📦 Modelos: $(hf-list-models | wc -l)"
    echo "📊 Datasets: $(hf-list-datasets | wc -l)"
}
EOF

chmod +x "$HF_FUNCTIONS_FILE"
log_success "Funções helper criadas: $HF_FUNCTIONS_FILE"

# 5. Adicionar ao shell config
if ! grep -q "hf-functions.sh" "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << EOF

# Hugging Face Functions
if [ -f "$HF_FUNCTIONS_FILE" ]; then
    source "$HF_FUNCTIONS_FILE"
fi
EOF
    log_success "Funções adicionadas ao $SHELL_RC"
fi

log_success "✅ Setup do Hugging Face concluído!"
log_info ""
log_info "Funções disponíveis:"
log_info "  hf-login              - Login no Hugging Face"
log_info "  hf-deploy-model       - Deploy de modelo"
log_info "  hf-upload-dataset     - Upload de dataset"
log_info "  hf-query-endpoint    - Query no endpoint"
log_info "  hf-list-models       - Listar modelos"
log_info "  hf-list-datasets     - Listar datasets"
log_info "  hf-status            - Status do Hugging Face"
log_info ""
log_info "Próximos passos:"
log_info "1. Recarregue o shell: source $SHELL_RC"
log_info "2. Teste: hf-status"
log_info "3. Teste: hf-list-models"

