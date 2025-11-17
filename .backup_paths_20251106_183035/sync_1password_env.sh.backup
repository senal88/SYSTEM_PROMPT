#!/bin/bash
# sync_1password_env.sh
# Script para sincronizar variáveis .env no 1Password
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar argumentos
if [[ $# -lt 1 ]]; then
    echo -e "${RED}❌ Erro: Arquivo ENV_FILE é obrigatório${NC}"
    echo "Uso: $0 /caminho/para/.env [VAULT] [ITEM_TITLE]"
    echo ""
    echo "Exemplo:"
    echo "  $0 /path/to/.env vault_senamfo_local 'Google Cloud Credentials'"
    exit 1
fi

ENV_FILE="${1}"
VAULT="${2:-1p_macos}"
ITEM_TITLE="${3:-$(basename "$ENV_FILE" .env)}"

# Validar arquivo existe
if [[ ! -f "$ENV_FILE" ]]; then
    echo -e "${RED}❌ Erro: Arquivo $ENV_FILE não encontrado${NC}"
    exit 1
fi

# Verificar 1Password CLI instalado
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ Erro: 1Password CLI não encontrado${NC}"
    echo "Instale com: brew install 1password-cli"
    exit 1
fi

# Verificar sessão ativa
echo -e "${YELLOW}🔐 Verificando sessão 1Password...${NC}"
if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Erro: Não há sessão 1Password ativa${NC}"
    echo "Execute: op signin [account]"
    echo "Ou: make secrets.audit # para ver instruções"
    exit 1
fi

# Obter account e vault info
CURRENT_ACCOUNT=$(op whoami 2>/dev/null | jq -r '.accountUuid' 2>/dev/null || op whoami 2>/dev/null)
echo -e "${GREEN}✅ Sessão ativa: $CURRENT_ACCOUNT${NC}"

# Verificar se vault existe
if ! op vault get "$VAULT" &>/dev/null; then
    echo -e "${RED}❌ Erro: Vault '$VAULT' não encontrado${NC}"
    echo "Vaults disponíveis:"
    op vault list
    exit 1
fi

# Verificar se item já existe
ITEM_EXISTS=false
if op item get "$ITEM_TITLE" --vault "$VAULT" &>/dev/null 2>&1; then
    ITEM_EXISTS=true
    echo -e "${YELLOW}⚠️  Item '$ITEM_TITLE' já existe no vault '$VAULT'${NC}"
    read -p "Sobrescrever? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operação cancelada"
        exit 0
    fi
fi

# Codificar arquivo em base64
ENV_CONTENT=$(cat "$ENV_FILE" | base64 | tr -d '\n')
ENV_SIZE=$(echo -n "$ENV_CONTENT" | wc -c)

echo -e "${YELLOW}📦 Codificando arquivo ($ENV_SIZE bytes)...${NC}"

# Criar ou atualizar item
if [[ "$ITEM_EXISTS" == "true" ]]; then
    echo -e "${YELLOW}🔄 Atualizando item '$ITEM_TITLE' no vault '$VAULT'...${NC}"
    
    # Extrair apenas variáveis (ignorar comentários e vazios)
    while IFS='=' read -r key value; do
        # Pular comentários e linhas vazias
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        
        # Remover espaços iniciais e quotes
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/^"//;s/"$//' | sed "s/^'//;s/'$//")
        
        # Codificar valor em base64 para segurança
        value_b64=$(echo -n "$value" | base64)
        
        # Adicionar ao item
        op item edit "$ITEM_TITLE" --vault "$VAULT" "${key}_B64=${value_b64}" 2>/dev/null || true
    done < "$ENV_FILE"
    
    echo -e "${GREEN}✅ Item atualizado com sucesso${NC}"
else
    echo -e "${YELLOW}🆕 Criando item '$ITEM_TITLE' no vault '$VAULT'...${NC}"
    
    # Criar item com conteúdo base64 completo
    op item create \
        --vault "$VAULT" \
        --category "Secure Note" \
        --title "$ITEM_TITLE" \
        --field label="env_base64" value="$ENV_CONTENT" \
        --field label="env_file_path" value="$ENV_FILE" \
        --field label="env_size" value="$ENV_SIZE" \
        &>/dev/null
    
    echo -e "${GREEN}✅ Item criado com sucesso${NC}"
fi

# Confirmar
echo -e "${GREEN}✅ Sincronização concluída${NC}"
echo ""
echo "Vault: $VAULT"
echo "Item: $ITEM_TITLE"
echo "Tamanho: $ENV_SIZE bytes"
echo ""
echo "Para recuperar:"
echo "  op read \"op://$VAULT/$ITEM_TITLE/env_base64\" | base64 -d > $ENV_FILE.restored"
