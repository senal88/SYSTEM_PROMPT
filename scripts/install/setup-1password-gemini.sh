#!/bin/bash

#################################################################################
# Script de Configuração 1Password para Gemini API Keys
# Versão: 2.0.1
# Objetivo: Criar/verificar item no 1Password para credenciais Gemini
#################################################################################

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

VAULT="Infra"
ITEM="Gemini_API_Keys"

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

# Verificar 1Password CLI
check_op() {
    if ! command -v op &> /dev/null; then
        error "1Password CLI não encontrado"
        return 1
    fi

    if ! op account list &>/dev/null; then
        error "1Password não autenticado"
        echo ""
        echo "Execute: op signin"
        return 1
    fi

    success "1Password CLI configurado"
    return 0
}

# Verificar se item existe
check_item() {
    if op item get "$ITEM" --vault "$VAULT" &>/dev/null; then
        success "Item $ITEM encontrado no vault $VAULT"
        return 0
    else
        warning "Item $ITEM não encontrado no vault $VAULT"
        return 1
    fi
}

# Criar item no 1Password
create_item() {
    log "Criando item $ITEM no vault $VAULT..."

    echo ""
    echo "Por favor, forneça as seguintes informações:"
    echo ""
    read -p "GEMINI_API_KEY: " gemini_key
    read -p "GOOGLE_API_KEY: " google_key

    if [ -z "$gemini_key" ] || [ -z "$google_key" ]; then
        error "Ambas as API keys são obrigatórias"
        return 1
    fi

    # Criar item usando op CLI
    op item create \
        --vault "$VAULT" \
        --title "$ITEM" \
        --category "Secure Note" \
        field.GEMINI_API_KEY="$gemini_key" \
        field.GOOGLE_API_KEY="$google_key" \
        --tags "gemini,api,credentials" \
        &>/dev/null

    if [ $? -eq 0 ]; then
        success "Item criado com sucesso"
        return 0
    else
        error "Erro ao criar item"
        return 1
    fi
}

# Exibir instruções
show_instructions() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Configuração Manual do 1Password                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Se preferir criar manualmente no 1Password:"
    echo ""
    echo "1. Abra o 1Password"
    echo "2. Vá para o vault: $VAULT"
    echo "3. Crie um novo item:"
    echo "   - Tipo: Secure Note"
    echo "   - Título: $ITEM"
    echo "   - Adicione campos customizados:"
    echo "     * Campo: GEMINI_API_KEY (tipo: password)"
    echo "     * Campo: GOOGLE_API_KEY (tipo: password)"
    echo "   - Tags: gemini, api, credentials"
    echo ""
    echo "Ou use o comando op CLI diretamente:"
    echo ""
    echo "op item create \\"
    echo "  --vault \"$VAULT\" \\"
    echo "  --title \"$ITEM\" \\"
    echo "  --category \"Secure Note\" \\"
    echo "  field.GEMINI_API_KEY=\"[sua-key]\" \\"
    echo "  field.GOOGLE_API_KEY=\"[sua-key]\" \\"
    echo "  --tags \"gemini,api,credentials\""
    echo ""
}

main() {
    clear

    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Configuração 1Password para Gemini API Keys           ║"
    echo "║              Versão 2.0.1                                    ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    if ! check_op; then
        exit 1
    fi

    echo ""

    if check_item; then
        success "Item já existe e está configurado corretamente"
        echo ""
        echo "Para verificar os campos:"
        echo "  op item get \"$ITEM\" --vault \"$VAULT\" --format json"
        echo ""
    else
        warning "Item não encontrado"
        echo ""
        read -p "Deseja criar o item agora? (s/N): " create

        if [[ "$create" =~ ^[Ss]$ ]]; then
            create_item
        else
            show_instructions
        fi
    fi
}

main "$@"
