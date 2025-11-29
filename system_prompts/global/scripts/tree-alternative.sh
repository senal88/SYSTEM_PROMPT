#!/usr/bin/env bash

################################################################################
# 🌳 TREE ALTERNATIVE - Visualização de estrutura de diretórios
# Alternativa ao comando tree quando não está instalado
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Visualizar estrutura de diretórios de forma hierárquica
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

TARGET_DIR="${1:-.}"
MAX_DEPTH="${2:-3}"

# Cores (opcional)
if [ -t 1 ]; then
    BLUE='\033[0;34m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    BLUE=''
    GREEN=''
    YELLOW=''
    NC=''
fi

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

show_tree() {
    local dir="$1"
    local prefix="$2"
    local max_depth="$3"
    local current_depth="${4:-0}"

    if [ "${current_depth}" -ge "${max_depth}" ]; then
        return
    fi

    # Listar diretórios
    local items=()
    while IFS= read -r item; do
        [ -n "$item" ] && items+=("$item")
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -type d ! -name '.*' 2>/dev/null | sort)

    local count=${#items[@]}
    local idx=0

    for item in "${items[@]}"; do
        ((idx++))
        local name=$(basename "$item")
        local is_last=$([ "$idx" -eq "$count" ] && echo "1" || echo "0")

        if [ "$is_last" -eq 1 ]; then
            echo -e "${prefix}└── ${GREEN}${name}${NC}/"
            show_tree "$item" "${prefix}    " "$max_depth" $((current_depth + 1))
        else
            echo -e "${prefix}├── ${GREEN}${name}${NC}/"
            show_tree "$item" "${prefix}│   " "$max_depth" $((current_depth + 1))
        fi
    done

    # Listar arquivos (opcional, apenas no último nível)
    if [ "${current_depth}" -eq $((max_depth - 1)) ]; then
        local file_list=$(find "$dir" -maxdepth 1 -mindepth 1 -type f ! -name '.*' 2>/dev/null | sort | head -10)
        local file_count=$(echo "$file_list" | grep -c . || echo "0")
        local file_idx=0

        if [ "${file_count}" -gt 0 ]; then
            while IFS= read -r file; do
                [ -z "$file" ] && continue
                ((file_idx++))
                local filename=$(basename "$file")
                local is_last_file=$([ "$file_idx" -eq "$file_count" ] && echo "1" || echo "0")

                if [ "$is_last_file" -eq 1 ] && [ "$idx" -eq 0 ]; then
                    echo -e "${prefix}└── ${BLUE}${filename}${NC}"
                elif [ "$idx" -eq 0 ]; then
                    echo -e "${prefix}├── ${BLUE}${filename}${NC}"
                elif [ "$is_last_file" -eq 1 ]; then
                    echo -e "${prefix}    └── ${BLUE}${filename}${NC}"
                else
                    echo -e "${prefix}    ├── ${BLUE}${filename}${NC}"
                fi
            done <<< "$file_list"

            local total_files=$(find "$dir" -maxdepth 1 -mindepth 1 -type f ! -name '.*' 2>/dev/null | wc -l | tr -d ' ')
            if [ "${total_files}" -gt 10 ]; then
                echo -e "${prefix}    ... e mais $((total_files - 10)) arquivo(s)"
            fi
        fi
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    local abs_dir=$(cd "$TARGET_DIR" && pwd)
    local dir_name=$(basename "$abs_dir")

    echo -e "${YELLOW}${dir_name}${NC}/"
    show_tree "$abs_dir" "" "$MAX_DEPTH" 0
}

main "$@"

