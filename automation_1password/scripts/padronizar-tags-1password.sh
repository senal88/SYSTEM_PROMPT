#!/bin/bash
# Script para Padronizar Tags do 1Password
# Remove tags inválidas e aplica padrões
#
# Uso: ./padronizar-tags-1password.sh [--vault VAULT] [--dry-run] [--force]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VAULT=""
ALL_VAULTS=false
DRY_RUN=false
FORCE=false

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
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
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

# Carregar configuração
TAGS_VALIDAS_FILE="$(dirname "$0")/../standards/tags-validas.yaml"
if [ ! -f "$TAGS_VALIDAS_FILE" ]; then
    echo -e "${RED}❌ Arquivo de tags válidas não encontrado${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   PADRONIZAÇÃO DE TAGS 1PASSWORD      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
echo ""

# Funções auxiliares
validar_tag() {
    local tag="$1"
    if [[ "$tag" =~ ^[a-z0-9_]+:[a-z0-9_]+$ ]]; then
        local namespace="${tag%%:*}"
        if grep -q "^  ${namespace}:" "$TAGS_VALIDAS_FILE"; then
            local value="${tag#*:}"
            if grep -A 20 "^  ${namespace}:" "$TAGS_VALIDAS_FILE" | grep -q "      - ${value}$"; then
                echo "VALIDO"
                return
            fi
        fi
    fi
    echo "INVALIDO"
}

migrar_tag() {
    local tag="$1"
    # Verificar regras de migração
    local migrada=$(grep -A 50 "^migration_rules:" "$TAGS_VALIDAS_FILE" | grep "  \"${tag}\":" | cut -d'"' -f4 || echo "")
    if [ -n "$migrada" ]; then
        echo "$migrada"
    else
        echo ""
    fi
}

deve_remover() {
    local tag="$1"
    # Verificar se está na lista de remoção
    if grep -A 10 "^tags_para_remover:" "$TAGS_VALIDAS_FILE" | grep -q "  - ${tag}$"; then
        echo "SIM"
    else
        echo "NAO"
    fi
}

# Processar vaults
if [ "$ALL_VAULTS" = true ]; then
    VAULTS=$(op vault list --format json | jq -r '.[].id')
elif [ -n "$VAULT" ]; then
    VAULTS="$VAULT"
else
    echo -e "${RED}❌ Especificar --vault ou --all${NC}"
    exit 1
fi

TOTAL_PROCESSADOS=0
TOTAL_ATUALIZADOS=0
TOTAL_REMOVIDAS=0
TOTAL_MIGRADAS=0

for vault_id in $VAULTS; do
    vault_name=$(op vault get "$vault_id" --format json 2>/dev/null | jq -r '.name' || echo "$vault_id")
    echo -e "${CYAN}📦 Processando vault: ${vault_name}${NC}"

    ITEMS=$(op item list --vault "$vault_id" --format json 2>/dev/null || echo "[]")

    echo "$ITEMS" | jq -r '.[] | "\(.id)|\(.title)"' | while IFS='|' read -r item_id item_title; do
        ITEM_JSON=$(op item get "$item_id" --vault "$vault_id" --format json 2>/dev/null || echo "{}")
        TAGS_ATUAIS=$(echo "$ITEM_JSON" | jq -r '.tags[]?' 2>/dev/null || echo "")

        if [ -z "$TAGS_ATUAIS" ]; then
            continue
        fi

        TAGS_VALIDAS_TEMP=""
        TAGS_REMOVIDAS_TEMP=""
        TAGS_MIGRADAS_TEMP=""

        echo "$TAGS_ATUAIS" | while read -r tag; do
            if [ -z "$tag" ]; then
                continue
            fi

            VALIDACAO=$(validar_tag "$tag")

            if [ "$VALIDACAO" = "VALIDO" ]; then
                TAGS_VALIDAS_TEMP="${TAGS_VALIDAS_TEMP}${tag}\n"
            else
                # Tentar migrar
                TAG_MIGRADA=$(migrar_tag "$tag")
                if [ -n "$TAG_MIGRADA" ]; then
                    TAGS_MIGRADAS_TEMP="${TAGS_MIGRADAS_TEMP}${TAG_MIGRADA}\n"
                    TAGS_REMOVIDAS_TEMP="${TAGS_REMOVIDAS_TEMP}${tag}\n"
                else
                    # Verificar se deve remover
                    REMOVER=$(deve_remover "$tag")
                    if [ "$REMOVER" = "SIM" ]; then
                        TAGS_REMOVIDAS_TEMP="${TAGS_REMOVIDAS_TEMP}${tag}\n"
                    else
                        # Tag inválida sem migração - remover
                        TAGS_REMOVIDAS_TEMP="${TAGS_REMOVIDAS_TEMP}${tag}\n"
                    fi
                fi
            fi
        done

        # Processar tags válidas e migradas
        TAGS_VALIDAS_ARRAY=($(echo -e "$TAGS_VALIDAS_TEMP" | grep -v '^$' | sort -u))
        TAGS_MIGRADAS_ARRAY=($(echo -e "$TAGS_MIGRADAS_TEMP" | grep -v '^$' | sort -u))
        TAGS_REMOVIDAS_ARRAY=($(echo -e "$TAGS_REMOVIDAS_TEMP" | grep -v '^$'))

        # Combinar tags válidas e migradas
        TAGS_FINAIS=("${TAGS_VALIDAS_ARRAY[@]}" "${TAGS_MIGRADAS_ARRAY[@]}")

        # Remover duplicatas
        TAGS_FINAIS_UNICAS=($(printf '%s\n' "${TAGS_FINAIS[@]}" | sort -u))

        # Verificar se há mudanças
        TAGS_ATUAIS_SORTED=$(echo "$TAGS_ATUAIS" | sort | tr '\n' ',' | sed 's/,$//')
        TAGS_FINAIS_SORTED=$(printf '%s\n' "${TAGS_FINAIS_UNICAS[@]}" | sort | tr '\n' ',' | sed 's/,$//')

        if [ "$TAGS_ATUAIS_SORTED" != "$TAGS_FINAIS_SORTED" ]; then
            echo -e "${YELLOW}   📝 ${item_title}${NC}"

            if [ ${#TAGS_REMOVIDAS[@]} -gt 0 ]; then
                echo -e "${RED}      Removidas: ${TAGS_REMOVIDAS[*]}${NC}"
            fi

            if [ ${#TAGS_MIGRADAS[@]} -gt 0 ]; then
                echo -e "${CYAN}      Migradas: ${TAGS_MIGRADAS[*]}${NC}"
            fi

            if [ ${#TAGS_FINAIS_UNICAS[@]} -gt 0 ]; then
                echo -e "${GREEN}      Tags finais: ${TAGS_FINAIS_UNICAS[*]}${NC}"
            fi

            if [ "$DRY_RUN" = false ]; then
                # Atualizar item
                TAGS_STRING=$(printf '%s,' "${TAGS_FINAIS_UNICAS[@]}" | sed 's/,$//')

                if op item edit "$item_id" --vault "$vault_id" --tags "$TAGS_STRING" &>/dev/null; then
                    echo -e "${GREEN}      ✅ Atualizado${NC}"
                    ((TOTAL_ATUALIZADOS++))
                else
                    echo -e "${RED}      ❌ Erro ao atualizar${NC}"
                fi
            else
                echo -e "${CYAN}      [DRY-RUN] Seria atualizado${NC}"
            fi

            echo ""
            ((TOTAL_PROCESSADOS++))
        fi
    done
done

echo ""
echo -e "${BLUE}📊 Resumo:${NC}"
echo -e "${CYAN}   Itens processados: ${TOTAL_PROCESSADOS}${NC}"
echo -e "${CYAN}   Itens atualizados: ${TOTAL_ATUALIZADOS}${NC}"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}⚠️  Modo DRY-RUN: Nenhuma alteração foi feita${NC}"
    echo -e "${YELLOW}   Execute sem --dry-run para aplicar as mudanças${NC}"
fi

echo ""

