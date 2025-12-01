#!/usr/bin/env bash

################################################################################
# 🌳 TREE SIMPLE - Visualização simples de estrutura de diretórios
# Alternativa ao comando tree quando não está instalado
#
# Uso: ./tree-simple.sh [diretório] [profundidade]
# Exemplo: ./tree-simple.sh . 3
################################################################################

set +euo pipefail 2>/dev/null || set +e

TARGET_DIR="${1:-.}"
MAX_DEPTH="${2:-3}"

# Função recursiva simplificada
show_tree_simple() {
    local dir="$1"
    local prefix="$2"
    local depth="${3:-0}"
    local max_depth="$4"

    [ "$depth" -ge "$max_depth" ] && return

    # Encontrar diretórios
    local dirs=$(find "$dir" -maxdepth 1 -mindepth 1 -type d ! -name '.*' 2>/dev/null | sort)

    if [ -z "$dirs" ]; then
        return
    fi

    local count=$(echo "$dirs" | wc -l | tr -d ' ')
    local idx=0

    echo "$dirs" | while IFS= read -r item; do
        [ -z "$item" ] && continue
        ((idx++))
        local name=$(basename "$item")
        local is_last=$([ "$idx" -eq "$count" ] && echo "1" || echo "0")

        if [ "$is_last" -eq 1 ]; then
            echo "${prefix}└── ${name}/"
            show_tree_simple "$item" "${prefix}    " $((depth + 1)) "$max_depth"
        else
            echo "${prefix}├── ${name}/"
            show_tree_simple "$item" "${prefix}│   " $((depth + 1)) "$max_depth"
        fi
    done
}

# Mostrar estrutura
abs_dir=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")
dir_name=$(basename "$abs_dir")

echo "${dir_name}/"
show_tree_simple "$abs_dir" "" 0 "$MAX_DEPTH"

