#!/bin/bash
# Script para Analisar Tags do 1Password
# Identifica tags fora do padrão e gera relatório
#
# Uso: ./analisar-tags-1password.sh [--vault VAULT] [--output FILE]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VAULT=""
OUTPUT_FILE=""
ALL_VAULTS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vault)
            VAULT="$2"
            shift 2
            ;;
        --all)
            ALL_VAULTS=true
            shift
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

# Verificar 1Password CLI
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    exit 1
fi

if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Não autenticado no 1Password${NC}"
    exit 1
fi

# Carregar tags válidas
TAGS_VALIDAS_FILE="$(dirname "$0")/../standards/tags-validas.yaml"
if [ ! -f "$TAGS_VALIDAS_FILE" ]; then
    echo -e "${RED}❌ Arquivo de tags válidas não encontrado: $TAGS_VALIDAS_FILE${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ANÁLISE DE TAGS 1PASSWORD          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Função para validar tag
validar_tag() {
    local tag="$1"

    # Verificar formato (namespace:value)
    if [[ ! "$tag" =~ ^[a-z0-9_]+:[a-z0-9_]+$ ]]; then
        echo "FORMATO_INVALIDO"
        return
    fi

    # Extrair namespace e value
    local namespace="${tag%%:*}"
    local value="${tag#*:}"

    # Verificar se namespace é válido
    if ! grep -q "^  ${namespace}:" "$TAGS_VALIDAS_FILE"; then
        echo "NAMESPACE_INVALIDO"
        return
    fi

    # Verificar se value é válido para o namespace
    if ! grep -A 20 "^  ${namespace}:" "$TAGS_VALIDAS_FILE" | grep -q "      - ${value}$"; then
        echo "VALUE_INVALIDO"
        return
    fi

    echo "VALIDO"
}

# Coletar tags de todos os itens
echo -e "${CYAN}📊 Coletando tags...${NC}"

if [ "$ALL_VAULTS" = true ]; then
    VAULTS=$(op vault list --format json | jq -r '.[].id')
else
    if [ -z "$VAULT" ]; then
        echo -e "${YELLOW}⚠️  Especificar --vault ou usar --all${NC}"
        exit 1
    fi
    VAULTS="$VAULT"
fi

TODAS_TAGS=()
TAGS_POR_ITEM=()
ITENS_COM_TAGS_INVALIDAS=()

for vault_id in $VAULTS; do
    vault_name=$(op vault get "$vault_id" --format json 2>/dev/null | jq -r '.name' || echo "$vault_id")
    echo -e "${CYAN}   Analisando vault: ${vault_name}${NC}"

    ITEMS=$(op item list --vault "$vault_id" --format json 2>/dev/null || echo "[]")

    echo "$ITEMS" | jq -r '.[] | "\(.id)|\(.title)"' | while IFS='|' read -r item_id item_title; do
        ITEM_JSON=$(op item get "$item_id" --vault "$vault_id" --format json 2>/dev/null || echo "{}")
        TAGS=$(echo "$ITEM_JSON" | jq -r '.tags[]?' 2>/dev/null || echo "")

        if [ -n "$TAGS" ]; then
            echo "$TAGS" | while read -r tag; do
                if [ -n "$tag" ]; then
                    VALIDACAO=$(validar_tag "$tag")
                    if [ "$VALIDACAO" != "VALIDO" ]; then
                        echo "INVALIDO|${vault_name}|${item_id}|${item_title}|${tag}|${VALIDACAO}"
                    else
                        echo "VALIDO|${vault_name}|${item_id}|${item_title}|${tag}"
                    fi
                fi
            done
        fi
    done
done > /tmp/tags_analysis.txt

# Processar resultados
TAGS_INVALIDAS=$(grep "^INVALIDO" /tmp/tags_analysis.txt || true)
TAGS_VALIDAS=$(grep "^VALIDO" /tmp/tags_analysis.txt || true)

TOTAL_INVALIDAS=$(echo "$TAGS_INVALIDAS" | wc -l | tr -d ' ')
TOTAL_VALIDAS=$(echo "$TAGS_VALIDAS" | wc -l | tr -d ' ')

echo ""
echo -e "${BLUE}📊 Resultados:${NC}"
echo ""
echo -e "${GREEN}✅ Tags válidas: ${TOTAL_VALIDAS}${NC}"
echo -e "${RED}❌ Tags inválidas: ${TOTAL_INVALIDAS}${NC}"
echo ""

# Gerar relatório detalhado
if [ -n "$TAGS_INVALIDAS" ]; then
    echo -e "${YELLOW}📋 Tags Inválidas Encontradas:${NC}"
    echo ""

    echo "$TAGS_INVALIDAS" | while IFS='|' read -r status vault item_id item_title tag motivo; do
        echo -e "${RED}   ❌ ${tag}${NC}"
        echo -e "${CYAN}      Item: ${item_title} (${vault})${NC}"
        echo -e "${CYAN}      Motivo: ${motivo}${NC}"
        echo ""
    done
fi

# Gerar arquivo de saída se solicitado
if [ -n "$OUTPUT_FILE" ]; then
    {
        echo "# Relatório de Análise de Tags - 1Password"
        echo "# Data: $(date)"
        echo ""
        echo "## Resumo"
        echo "- Tags válidas: ${TOTAL_VALIDAS}"
        echo "- Tags inválidas: ${TOTAL_INVALIDAS}"
        echo ""
        echo "## Tags Inválidas"
        echo ""
        if [ -n "$TAGS_INVALIDAS" ]; then
            echo "$TAGS_INVALIDAS" | while IFS='|' read -r status vault item_id item_title tag motivo; do
                echo "### ${tag}"
                echo "- Item: ${item_title}"
                echo "- Vault: ${vault}"
                echo "- ID: ${item_id}"
                echo "- Motivo: ${motivo}"
                echo ""
            done
        else
            echo "Nenhuma tag inválida encontrada."
        fi
    } > "$OUTPUT_FILE"

    echo -e "${GREEN}✅ Relatório salvo em: ${OUTPUT_FILE}${NC}"
fi

# Limpar arquivo temporário
rm -f /tmp/tags_analysis.txt

echo ""

