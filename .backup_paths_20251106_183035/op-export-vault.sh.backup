#!/bin/bash
# Script para exportar e parametrizar dados de todas as vaults do 1Password
# Uso: op-export-vault.sh [--vault VAULT_ID] [--format json|yaml]

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Diretórios
OP_CONFIG_DIR="$HOME/.config/op"
OP_VAULT_DATA_DIR="$OP_CONFIG_DIR/vault_data"
OP_VAULT_CONFIG="$OP_CONFIG_DIR/vault_config.json"

# Parâmetros
VAULT_ID=""
FORMAT="json"
ALL_VAULTS=false

# Função de ajuda
show_help() {
    cat << EOF
Uso: op-export-vault.sh [OPÇÕES]

Exporta e parametriza dados de vaults do 1Password.

OPÇÕES:
    --vault VAULT_ID    Exporta apenas a vault especificada
    --all               Exporta todas as vaults (padrão)
    --format FORMAT      Formato de saída: json ou yaml (padrão: json)
    --help              Mostra esta ajuda

EXEMPLOS:
    op-export-vault.sh                    # Exporta todas as vaults em JSON
    op-export-vault.sh --vault gkpsbgizlks2zknwzqpppnb2ze  # Exporta vault específica
    op-export-vault.sh --format yaml      # Exporta em formato YAML

EOF
}

# Parse de argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --vault)
            VAULT_ID="$2"
            shift 2
            ;;
        --all)
            ALL_VAULTS=true
            shift
            ;;
        --format)
            FORMAT="$2"
            if [[ "$FORMAT" != "json" && "$FORMAT" != "yaml" ]]; then
                echo -e "${RED}❌ Formato inválido: $FORMAT. Use 'json' ou 'yaml'.${NC}" >&2
                exit 1
            fi
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opção desconhecida: $1${NC}" >&2
            show_help
            exit 1
            ;;
    esac
done

# Verifica se está logado
if ! op whoami &>/dev/null; then
    echo -e "${YELLOW}⚠️  Não está logado no 1Password. Fazendo login...${NC}"
    eval "$(op signin)"
fi

# Cria diretório de dados se não existir
mkdir -p "$OP_VAULT_DATA_DIR"

# Função para obter nome do vault
get_vault_name() {
    local vault_id="$1"
    if [ -f "$OP_VAULT_CONFIG" ] && command -v jq &>/dev/null; then
        jq -r ".vault_mapping.\"$vault_id\" // \"$vault_id\"" "$OP_VAULT_CONFIG" 2>/dev/null || echo "$vault_id"
    else
        echo "$vault_id"
    fi
}

# Função para exportar uma vault
export_vault() {
    local vault_id="$1"
    local vault_name=$(get_vault_name "$vault_id")
    local output_file="$OP_VAULT_DATA_DIR/vault_${vault_name}.${FORMAT}"

    echo -e "${BLUE}📦 Exportando vault: $vault_name ($vault_id)${NC}"

    # Lista todos os items da vault
    local items
    if ! items=$(op item list --vault "$vault_id" --format json 2>/dev/null); then
        echo -e "${YELLOW}⚠️  Erro ao listar items da vault $vault_name. Pulando...${NC}"
        return 1
    fi

    # Se não houver items, cria arquivo vazio
    if [ -z "$items" ] || [ "$items" == "[]" ]; then
        echo -e "${YELLOW}⚠️  Vault $vault_name está vazia${NC}"
        if [ "$FORMAT" == "json" ]; then
            echo "[]" > "$output_file"
        else
            echo "[]" | yq -P > "$output_file" 2>/dev/null || echo "[]" > "$output_file"
        fi
        return 0
    fi

    # Para cada item, obtém detalhes completos
    local item_ids
    item_ids=$(echo "$items" | jq -r '.[].id' 2>/dev/null || echo "")

    if [ -z "$item_ids" ]; then
        echo -e "${YELLOW}⚠️  Nenhum item encontrado na vault $vault_name${NC}"
        return 0
    fi

    local vault_data="[]"
    local count=0

    while IFS= read -r item_id; do
        [ -z "$item_id" ] && continue

        echo -e "  ${BLUE}→${NC} Processando item: $item_id"

        local item_data
        if item_data=$(op item get "$item_id" --format json 2>/dev/null); then
            # Adiciona metadata da vault
            item_data=$(echo "$item_data" | jq ". + {vault_id: \"$vault_id\", vault_name: \"$vault_name\"}" 2>/dev/null || echo "$item_data")

            # Adiciona ao array
            vault_data=$(echo "$vault_data" | jq ". + [$(echo "$item_data")]" 2>/dev/null || echo "$vault_data")
            ((count++))
        else
            echo -e "  ${YELLOW}⚠️  Erro ao obter item $item_id${NC}"
        fi
    done <<< "$item_ids"

    # Salva arquivo
    if [ "$FORMAT" == "json" ]; then
        echo "$vault_data" | jq '.' > "$output_file" 2>/dev/null || echo "$vault_data" > "$output_file"
    else
        if command -v yq &>/dev/null; then
            echo "$vault_data" | jq '.' | yq -P > "$output_file" 2>/dev/null || echo "$vault_data" > "$output_file"
        else
            echo -e "${YELLOW}⚠️  yq não instalado. Salvando como JSON.${NC}"
            echo "$vault_data" | jq '.' > "${output_file%.yaml}.json" 2>/dev/null || echo "$vault_data" > "${output_file%.yaml}.json"
        fi
    fi

    echo -e "${GREEN}✅ Vault $vault_name exportada: $count items → $output_file${NC}"
}

# Função principal
main() {
    echo -e "${GREEN}🚀 Iniciando exportação de vaults do 1Password${NC}"
    echo ""

    # Lista todas as vaults
    local vaults
    if ! vaults=$(op vault list --format json 2>/dev/null); then
        echo -e "${RED}❌ Erro ao listar vaults${NC}" >&2
        exit 1
    fi

    # Se vault específica foi solicitada
    if [ -n "$VAULT_ID" ]; then
        export_vault "$VAULT_ID"
    else
        # Exporta todas as vaults
        local vault_ids
        vault_ids=$(echo "$vaults" | jq -r '.[].id' 2>/dev/null || echo "")

        if [ -z "$vault_ids" ]; then
            echo -e "${YELLOW}⚠️  Nenhuma vault encontrada${NC}"
            exit 0
        fi

        while IFS= read -r vault_id; do
            [ -z "$vault_id" ] && continue
            export_vault "$vault_id"
            echo ""
        done <<< "$vault_ids"
    fi

    echo ""
    echo -e "${GREEN}✅ Exportação concluída!${NC}"
    echo -e "${BLUE}📁 Arquivos salvos em: $OP_VAULT_DATA_DIR${NC}"

    # Lista arquivos criados
    echo ""
    echo -e "${BLUE}📋 Arquivos gerados:${NC}"
    ls -lh "$OP_VAULT_DATA_DIR"/*."$FORMAT" 2>/dev/null || echo "  (nenhum arquivo encontrado)"
}

# Executa função principal
main

