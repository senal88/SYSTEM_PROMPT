#!/bin/bash
# Script para Registrar GOOGLE_API_KEY no 1Password
# Seguindo padrões de nomenclatura SERVICE_TYPE_ENV
#
# Uso: ./registrar-google-api-key.sh [--key KEY] [--vault VAULT] [--dry-run]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VAULT="1p_macos"
ITEM_NAME="GOOGLE_API_KEY"
DRY_RUN=false
API_KEY=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --key)
            API_KEY="$2"
            shift 2
            ;;
        --vault)
            VAULT="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   REGISTRAR GOOGLE_API_KEY            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Item: ${ITEM_NAME}${NC}"
echo -e "${CYAN}Vault: ${VAULT}${NC}"
[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
echo ""

# Verificar se 1Password CLI está disponível
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    echo -e "${CYAN}Instale com: brew install 1password-cli${NC}"
    exit 1
fi

# Verificar autenticação
if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Não autenticado no 1Password${NC}"
    echo -e "${CYAN}Autentique com: op signin${NC}"
    exit 1
fi

# Obter chave se não fornecida
if [ -z "$API_KEY" ]; then
    # Tentar ler do arquivo
    KEY_FILE="framework/curso-n8n/aulas/04-workflows-iniciantes/aula-15-criando-projeto-no-console-do-google-e-chave-de-api-do-gemini /GOOGLE_API_KEY.txt"

    if [ -f "$KEY_FILE" ]; then
        echo -e "${CYAN}📄 Lendo chave do arquivo: ${KEY_FILE}${NC}"
        API_KEY=$(grep -E "^GOOGLE_API_KEY=" "$KEY_FILE" | cut -d'=' -f2 | tr -d ' ')

        if [ -z "$API_KEY" ]; then
            echo -e "${RED}❌ Chave não encontrada no arquivo${NC}"
            read -sp "🔑 Cole sua GOOGLE_API_KEY (não será visível): " API_KEY
            echo ""
        else
            echo -e "${GREEN}✅ Chave lida do arquivo${NC}"
        fi
    else
        read -sp "🔑 Cole sua GOOGLE_API_KEY (não será visível): " API_KEY
        echo ""
    fi
fi

# Validar formato da chave
if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ Chave não fornecida${NC}"
    exit 1
fi

# Validar formato básico (Google API keys geralmente começam com AIza)
if [[ ! "$API_KEY" =~ ^AIza[0-9A-Za-z_-]{35}$ ]]; then
    echo -e "${YELLOW}⚠️  Formato da chave pode estar incorreto${NC}"
    echo -e "${CYAN}   Esperado: AIza seguido de 35 caracteres alfanuméricos${NC}"
    read -p "   Continuar mesmo assim? (s/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 0
    fi
fi

# Verificar se item já existe
echo -e "${YELLOW}🔍 Verificando se item já existe...${NC}"
if op item get "$ITEM_NAME" --vault="$VAULT" &>/dev/null; then
    echo -e "${YELLOW}   ⚠️  Item '$ITEM_NAME' já existe no vault '$VAULT'${NC}"
    read -p "   Deseja atualizar? (s/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${CYAN}Operação cancelada${NC}"
        exit 0
    fi

    # Atualizar item existente
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}   [DRY-RUN] Seria atualizado:${NC}"
        echo -e "${CYAN}   - Item: ${ITEM_NAME}${NC}"
        echo -e "${CYAN}   - Campo: credential${NC}"
        echo -e "${CYAN}   - Vault: ${VAULT}${NC}"
    else
        echo -e "${CYAN}   Atualizando item existente...${NC}"
        op item edit "$ITEM_NAME" --vault="$VAULT" "credential[concealed]=$API_KEY" 2>/dev/null || {
            echo -e "${RED}   ❌ Erro ao atualizar item${NC}"
            exit 1
        }
        echo -e "${GREEN}   ✅ Item atualizado com sucesso${NC}"
    fi
else
    # Criar novo item
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}   [DRY-RUN] Seria criado:${NC}"
        echo -e "${CYAN}   - Item: ${ITEM_NAME}${NC}"
        echo -e "${CYAN}   - Categoria: API Credential${NC}"
        echo -e "${CYAN}   - Vault: ${VAULT}${NC}"
        echo -e "${CYAN}   - Tags: environment:macos, service:google, type:credentials, status:active${NC}"
    else
        echo -e "${CYAN}   Criando novo item...${NC}"
        op item create \
            --category "API Credential" \
            --title "$ITEM_NAME" \
            --vault "$VAULT" \
            "credential[concealed]=$API_KEY" \
            --tags "environment:macos,service:google,type:credentials,status:active,project:gemini" \
            2>/dev/null || {
            echo -e "${RED}   ❌ Erro ao criar item${NC}"
            exit 1
        }
        echo -e "${GREEN}   ✅ Item criado com sucesso${NC}"
    fi
fi

echo ""
echo -e "${BLUE}📊 Resumo:${NC}"
echo ""
echo -e "${CYAN}Item:${NC} ${ITEM_NAME}"
echo -e "${CYAN}Vault:${NC} ${VAULT}"
echo -e "${CYAN}Categoria:${NC} API Credential"
echo -e "${CYAN}Tags:${NC} environment:macos, service:google, type:credentials, status:active, project:gemini"
echo ""

if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}✅ GOOGLE_API_KEY registrada no 1Password!${NC}"
    echo ""
    echo -e "${CYAN}📝 Usar a chave:${NC}"
    echo -e "   export GOOGLE_API_KEY=\$(op read \"op://${VAULT}/${ITEM_NAME}/credential\")"
    echo ""
    echo -e "${CYAN}📝 Adicionar ao .zshrc:${NC}"
    echo -e "   echo 'export GOOGLE_API_KEY=\$(op read \"op://${VAULT}/${ITEM_NAME}/credential\" 2>/dev/null || echo \"\")' >> ~/.zshrc"
    echo ""
else
    echo -e "${YELLOW}⚠️  Modo DRY-RUN: Nenhum item foi criado/atualizado${NC}"
    echo -e "${YELLOW}   Execute sem --dry-run para criar/atualizar o item${NC}"
fi

echo ""

