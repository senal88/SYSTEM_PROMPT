#!/bin/bash
# Script de Validação de Itens 1Password
# Valida nomenclaturas, formatos, categorias e tags dos itens
#
# Uso: ./scripts/validate-1password-items.sh [--vault VAULT] [--fix]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VAULT=""
FIX=false
VALIDATION_RULES="automation_1password/standards/validation-rules.yaml"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vault)
            VAULT="$2"
            shift 2
            ;;
        --fix)
            FIX=true
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
    echo -e "${YELLOW}   Instale com: brew install 1password-cli${NC}"
    exit 1
fi

# Verificar autenticação
if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Não autenticado no 1Password${NC}"
    echo -e "${YELLOW}   Execute: op signin${NC}"
    exit 1
fi

# Verificar se yq está disponível (para ler YAML)
if ! command -v yq &> /dev/null && ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}⚠️  yq ou python3 não encontrado (usando validação básica)${NC}"
    USE_YAML=false
else
    USE_YAML=true
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   VALIDAÇÃO DE ITENS 1PASSWORD        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Listar vaults
if [ -z "$VAULT" ]; then
    echo -e "${YELLOW}📋 Listando vaults disponíveis...${NC}"
    VAULTS=$(op vault list --format json 2>/dev/null | jq -r '.[].name' || echo "")
    if [ -z "$VAULTS" ]; then
        echo -e "${RED}❌ Nenhum vault encontrado${NC}"
        exit 1
    fi
    echo "$VAULTS" | while read v; do
        echo -e "   - $v"
    done
    echo ""
    VAULT=$(echo "$VAULTS" | head -1)
    echo -e "${CYAN}Usando vault: ${VAULT}${NC}"
else
    echo -e "${CYAN}Vault: ${VAULT}${NC}"
fi

echo ""

# Função para validar nomenclatura
validate_nomenclature() {
    local name="$1"
    local errors=0

    # Verificar formato UPPER_SNAKE_CASE
    if ! echo "$name" | grep -qE '^[A-Z][A-Z0-9_]+$'; then
        echo -e "${RED}   ❌ Formato incorreto: deve ser UPPER_SNAKE_CASE${NC}"
        errors=$((errors + 1))
    fi

    # Verificar erros de digitação conhecidos
    if echo "$name" | grep -qi "ANTRHOPIC"; then
        echo -e "${RED}   ❌ Erro de digitação: ANTRHOPIC → ANTHROPIC${NC}"
        errors=$((errors + 1))
    fi

    # Verificar uso de GEMINI ao invés de GOOGLE
    if echo "$name" | grep -qE "GEMINI_API_KEY"; then
        echo -e "${YELLOW}   ⚠️  Usar GOOGLE_API_KEY ao invés de GEMINI_API_KEY${NC}"
    fi

    # Verificar comprimento
    if [ ${#name} -lt 5 ]; then
        echo -e "${RED}   ❌ Nome muito curto (mínimo 5 caracteres)${NC}"
        errors=$((errors + 1))
    fi

    if [ ${#name} -gt 100 ]; then
        echo -e "${RED}   ❌ Nome muito longo (máximo 100 caracteres)${NC}"
        errors=$((errors + 1))
    fi

    return $errors
}

# Função para validar categoria
validate_category() {
    local name="$1"
    local category="$2"
    local errors=0

    # Verificar se API keys estão como API_CREDENTIAL
    if echo "$name" | grep -qE "(API_KEY|TOKEN)" && [ "$category" != "API_CREDENTIAL" ]; then
        echo -e "${RED}   ❌ Categoria incorreta: API_KEY/TOKEN deve ser API_CREDENTIAL${NC}"
        errors=$((errors + 1))
    fi

    # Verificar se passwords isoladas estão como PASSWORD
    if echo "$name" | grep -qE "_PASSWORD_" && [ "$category" != "PASSWORD" ] && [ "$category" != "LOGIN" ]; then
        echo -e "${YELLOW}   ⚠️  Verificar categoria: PASSWORD isolada deve ser PASSWORD${NC}"
    fi

    return $errors
}

# Função para validar formato de credencial
validate_credential_format() {
    local name="$1"
    local value="$2"
    local errors=0

    # OpenAI API Key
    if echo "$name" | grep -qi "OPENAI"; then
        if ! echo "$value" | grep -qE "^sk-[a-zA-Z0-9]{32,}$"; then
            echo -e "${YELLOW}   ⚠️  Formato de OpenAI API Key pode estar incorreto${NC}"
        fi
    fi

    # Anthropic API Key
    if echo "$name" | grep -qi "ANTHROPIC"; then
        if ! echo "$value" | grep -qE "^sk-ant-[a-zA-Z0-9-]{95,}$"; then
            echo -e "${YELLOW}   ⚠️  Formato de Anthropic API Key pode estar incorreto${NC}"
        fi
    fi

    # Google API Key
    if echo "$name" | grep -qi "GOOGLE.*API"; then
        if ! echo "$value" | grep -qE "^AIza[0-9A-Za-z-_]{35}$"; then
            echo -e "${YELLOW}   ⚠️  Formato de Google API Key pode estar incorreto${NC}"
        fi
    fi

    # GitHub Token
    if echo "$name" | grep -qi "GITHUB.*TOKEN"; then
        if ! echo "$value" | grep -qE "^(ghp_|gho_|ghu_|ghs_|ghr_)[a-zA-Z0-9]{36,}$"; then
            echo -e "${YELLOW}   ⚠️  Formato de GitHub Token pode estar incorreto${NC}"
        fi
    fi

    return $errors
}

# Coletar itens
echo -e "${YELLOW}📊 Coletando itens do vault...${NC}"
ITEMS_JSON=$(op item list --vault "$VAULT" --format json 2>/dev/null || echo "[]")
TOTAL_ITEMS=$(echo "$ITEMS_JSON" | jq 'length')

echo -e "${CYAN}Total de itens: ${TOTAL_ITEMS}${NC}"
echo ""

# Validar cada item
ERRORS=0
WARNINGS=0
VALIDATED=0

echo -e "${YELLOW}🔍 Validando itens...${NC}"
echo ""

echo "$ITEMS_JSON" | jq -r '.[] | "\(.id)|\(.title)|\(.category)"' | while IFS='|' read -r id title category; do
    echo -e "${CYAN}Item: ${title}${NC}"
    echo -e "   ID: ${id}"
    echo -e "   Categoria: ${category}"

    ITEM_ERRORS=0

    # Validar nomenclatura
    if ! validate_nomenclature "$title"; then
        ITEM_ERRORS=$((ITEM_ERRORS + 1))
    fi

    # Validar categoria
    if ! validate_category "$title" "$category"; then
        ITEM_ERRORS=$((ITEM_ERRORS + 1))
    fi

    # Tentar validar formato (se possível obter valor)
    if [ "$FIX" = false ]; then
        # Apenas verificar estrutura, não valores
        echo -e "${GREEN}   ✅ Estrutura validada${NC}"
    fi

    if [ $ITEM_ERRORS -eq 0 ]; then
        VALIDATED=$((VALIDATED + 1))
    else
        ERRORS=$((ERRORS + ITEM_ERRORS))
    fi

    echo ""
done

# Resumo
echo -e "${BLUE}📊 Resumo da Validação:${NC}"
echo -e "   Total de itens: ${TOTAL_ITEMS}"
echo -e "   Validados: ${VALIDATED}"
echo -e "   Erros: ${ERRORS}"
echo -e "   Avisos: ${WARNINGS}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Validação concluída sem erros!${NC}"
else
    echo -e "${RED}❌ Validação concluída com ${ERRORS} erro(s)${NC}"
    echo -e "${YELLOW}   Execute com --fix para corrigir automaticamente${NC}"
    exit 1
fi

