#!/bin/bash
# Script de Migração de Itens 1Password
# Renomeia, recategoriza e adiciona tags aos itens existentes
#
# Uso: ./scripts/migrate-1password-items.sh [--vault VAULT] [--dry-run] [--remove-cloudflare]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VAULT=""
DRY_RUN=false
REMOVE_CLOUDFLARE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vault)
            VAULT="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --remove-cloudflare)
            REMOVE_CLOUDFLARE=true
            shift
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

# Verificar se 1Password CLI está disponível
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    exit 1
fi

if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Não autenticado no 1Password${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   MIGRAÇÃO DE ITENS 1PASSWORD         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
[ "$REMOVE_CLOUDFLARE" = true ] && echo -e "${YELLOW}🗑️  Removendo itens Cloudflare${NC}"
echo ""

# Mapeamento de correções de nomenclatura
declare -A NAME_FIXES=(
    ["ANTRHOPIC_API_KEY"]="ANTHROPIC_API_KEY"
    ["GEMINI_API_KEY"]="GOOGLE_API_KEY"
    ["Gemini_API_Key_macos"]="GOOGLE_API_KEY_MACOS"
    ["OpenAI_API_Key_macos"]="OPENAI_API_KEY_MACOS"
    ["OpenAI_API_Key_vps"]="OPENAI_API_KEY_VPS"
    ["Openai-API"]="OPENAI_API_KEY"
    ["OPENAI_API_KEY"]="OPENAI_API_KEY_MACOS"  # Se não tiver sufixo, adicionar
)

# Mapeamento de correções de categoria
declare -A CATEGORY_FIXES=(
    ["LOGIN"]="API_CREDENTIAL"  # Se nome contém API_KEY ou TOKEN
)

# Função para corrigir nome
fix_name() {
    local old_name="$1"
    local new_name="$old_name"

    # Aplicar correções conhecidas
    for old in "${!NAME_FIXES[@]}"; do
        if echo "$old_name" | grep -qi "^${old}$"; then
            new_name="${NAME_FIXES[$old]}"
            break
        fi
    done

    # Converter para UPPER_SNAKE_CASE se necessário
    if ! echo "$new_name" | grep -qE '^[A-Z][A-Z0-9_]+$'; then
        new_name=$(echo "$new_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_' | tr ' ' '_')
    fi

    echo "$new_name"
}

# Função para determinar tags baseado no nome
get_tags_from_name() {
    local name="$1"
    local tags=""

    # Environment
    if echo "$name" | grep -qE "_MACOS$"; then
        tags="${tags}environment:macos,"
    elif echo "$name" | grep -qE "_VPS$"; then
        tags="${tags}environment:vps,"
    else
        tags="${tags}environment:shared,"
    fi

    # Service
    if echo "$name" | grep -qi "OPENAI"; then
        tags="${tags}service:openai,"
    elif echo "$name" | grep -qi "ANTHROPIC"; then
        tags="${tags}service:anthropic,"
    elif echo "$name" | grep -qi "GOOGLE\|GEMINI"; then
        tags="${tags}service:google,"
    elif echo "$name" | grep -qi "GITHUB"; then
        tags="${tags}service:github,"
    elif echo "$name" | grep -qi "POSTGRES"; then
        tags="${tags}service:postgresql,"
    elif echo "$name" | grep -qi "REDIS"; then
        tags="${tags}service:redis,"
    elif echo "$name" | grep -qi "N8N"; then
        tags="${tags}service:n8n,"
    elif echo "$name" | grep -qi "CHATWOOT"; then
        tags="${tags}service:chatwoot,"
    fi

    # Type
    if echo "$name" | grep -qi "API_KEY"; then
        tags="${tags}type:api_key,"
    elif echo "$name" | grep -qi "TOKEN"; then
        tags="${tags}type:token,"
    elif echo "$name" | grep -qi "PASSWORD"; then
        tags="${tags}type:password,"
    elif echo "$name" | grep -qi "SSH_KEY"; then
        tags="${tags}type:ssh_key,"
    fi

    # Status
    tags="${tags}status:active"

    echo "$tags"
}

# Função para corrigir categoria
fix_category() {
    local name="$1"
    local current_category="$2"
    local new_category="$current_category"

    # Se é API_KEY ou TOKEN e categoria é LOGIN, mudar para API_CREDENTIAL
    if echo "$name" | grep -qE "(API_KEY|TOKEN)" && [ "$current_category" = "LOGIN" ]; then
        new_category="API_CREDENTIAL"
    fi

    # Se é PASSWORD isolada e categoria é SECURE_NOTE, mudar para PASSWORD
    if echo "$name" | grep -qE "_PASSWORD_" && [ "$current_category" = "SECURE_NOTE" ]; then
        new_category="PASSWORD"
    fi

    echo "$new_category"
}

# Listar vaults
if [ -z "$VAULT" ]; then
    VAULTS=$(op vault list --format json 2>/dev/null | jq -r '.[].name' || echo "")
    if [ -z "$VAULTS" ]; then
        echo -e "${RED}❌ Nenhum vault encontrado${NC}"
        exit 1
    fi
    VAULT=$(echo "$VAULTS" | head -1)
    echo -e "${CYAN}Usando vault: ${VAULT}${NC}"
else
    echo -e "${CYAN}Vault: ${VAULT}${NC}"
fi

echo ""

# Coletar itens
echo -e "${YELLOW}📊 Coletando itens...${NC}"
ITEMS_JSON=$(op item list --vault "$VAULT" --format json 2>/dev/null || echo "[]")
TOTAL_ITEMS=$(echo "$ITEMS_JSON" | jq 'length')

echo -e "${CYAN}Total de itens: ${TOTAL_ITEMS}${NC}"
echo ""

# Processar itens
MIGRATED=0
REMOVED=0
ERRORS=0

echo -e "${YELLOW}🔄 Processando itens...${NC}"
echo ""

echo "$ITEMS_JSON" | jq -r '.[] | "\(.id)|\(.title)|\(.category)"' | while IFS='|' read -r id title category; do
    # Verificar se é Cloudflare e deve ser removido
    if [ "$REMOVE_CLOUDFLARE" = true ] && (echo "$title" | grep -qi "cloudflare\|CF_"); then
        echo -e "${RED}🗑️  Removendo: ${title}${NC}"
        if [ "$DRY_RUN" = false ]; then
            if op item delete "$id" --vault "$VAULT" 2>/dev/null; then
                REMOVED=$((REMOVED + 1))
                echo -e "${GREEN}   ✅ Removido${NC}"
            else
                ERRORS=$((ERRORS + 1))
                echo -e "${RED}   ❌ Erro ao remover${NC}"
            fi
        else
            echo -e "${YELLOW}   [DRY-RUN] Seria removido${NC}"
            REMOVED=$((REMOVED + 1))
        fi
        echo ""
        continue
    fi

    # Verificar se precisa de correção
    NEW_NAME=$(fix_name "$title")
    NEW_CATEGORY=$(fix_category "$title" "$category")
    TAGS=$(get_tags_from_name "$NEW_NAME")

    NEEDS_FIX=false

    if [ "$NEW_NAME" != "$title" ]; then
        NEEDS_FIX=true
        echo -e "${CYAN}📝 Item: ${title}${NC}"
        echo -e "${YELLOW}   Renomear para: ${NEW_NAME}${NC}"
    fi

    if [ "$NEW_CATEGORY" != "$category" ]; then
        NEEDS_FIX=true
        if [ "$NEW_NAME" = "$title" ]; then
            echo -e "${CYAN}📝 Item: ${title}${NC}"
        fi
        echo -e "${YELLOW}   Alterar categoria: ${category} → ${NEW_CATEGORY}${NC}"
    fi

    # Adicionar tags (sempre verificar)
    if [ "$NEEDS_FIX" = true ] || [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}   Adicionar tags: ${TAGS}${NC}"
    fi

    if [ "$NEEDS_FIX" = true ]; then
        if [ "$DRY_RUN" = false ]; then
            # Atualizar item
            if op item edit "$id" --vault "$VAULT" --title "$NEW_NAME" --category "$NEW_CATEGORY" 2>/dev/null; then
                # Adicionar tags (se suportado)
                echo -e "${GREEN}   ✅ Atualizado${NC}"
                MIGRATED=$((MIGRATED + 1))
            else
                echo -e "${RED}   ❌ Erro ao atualizar${NC}"
                ERRORS=$((ERRORS + 1))
            fi
        else
            echo -e "${YELLOW}   [DRY-RUN] Seria atualizado${NC}"
            MIGRATED=$((MIGRATED + 1))
        fi
        echo ""
    fi
done

# Resumo
echo -e "${BLUE}📊 Resumo da Migração:${NC}"
echo -e "   Total de itens: ${TOTAL_ITEMS}"
echo -e "   Migrados: ${MIGRATED}"
if [ "$REMOVE_CLOUDFLARE" = true ]; then
    echo -e "   Removidos (Cloudflare): ${REMOVED}"
fi
echo -e "   Erros: ${ERRORS}"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}⚠️  Modo DRY-RUN: Nenhuma alteração foi feita${NC}"
    echo -e "${YELLOW}   Execute sem --dry-run para aplicar as mudanças${NC}"
else
    if [ $ERRORS -eq 0 ]; then
        echo -e "${GREEN}✅ Migração concluída!${NC}"
    else
        echo -e "${RED}❌ Migração concluída com ${ERRORS} erro(s)${NC}"
    fi
fi
echo ""

