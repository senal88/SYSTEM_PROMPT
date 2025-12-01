#!/bin/bash

# ============================================
# Script de Coleta: Extensões IDE com IA - macOS
# ============================================
# Detecta extensões de IA em IDEs instalados
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/ide_extensions_macos.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"macOS\"," >> "$REPORT_FILE"
echo "  \"ide_extensions\": {" >> "$REPORT_FILE"

# Função para verificar extensões do VS Code / Cursor
check_vscode_extensions() {
    local ide_name=$1
    local extensions_dir=$2

    if [ -d "$extensions_dir" ]; then
        echo "    \"$ide_name\": {" >> "$REPORT_FILE"
        echo "      \"installed\": true," >> "$REPORT_FILE"
        echo "      \"extensions_dir\": \"$extensions_dir\"," >> "$REPORT_FILE"
        echo "      \"extensions\": [" >> "$REPORT_FILE"

        # Buscar extensões relacionadas a IA
        AI_EXTENSIONS=$(find "$extensions_dir" -maxdepth 2 -name "package.json" -exec grep -l -iE "(copilot|ai|artificial|intelligence|claude|chatgpt|gemini|openai|anthropic)" {} \; 2>/dev/null || echo "")

        if [ -n "$AI_EXTENSIONS" ]; then
            FIRST=true
            while IFS= read -r ext_file; do
                if [ "$FIRST" = false ]; then
                    echo "," >> "$REPORT_FILE"
                fi
                FIRST=false

                EXT_NAME=$(grep -o '"name":\s*"[^"]*"' "$ext_file" 2>/dev/null | head -1 | cut -d'"' -f4 || echo "unknown")
                EXT_PUBLISHER=$(grep -o '"publisher":\s*"[^"]*"' "$ext_file" 2>/dev/null | head -1 | cut -d'"' -f4 || echo "unknown")
                EXT_VERSION=$(grep -o '"version":\s*"[^"]*"' "$ext_file" 2>/dev/null | head -1 | cut -d'"' -f4 || echo "unknown")

                echo "        {" >> "$REPORT_FILE"
                echo "          \"name\": \"$EXT_NAME\"," >> "$REPORT_FILE"
                echo "          \"publisher\": \"$EXT_PUBLISHER\"," >> "$REPORT_FILE"
                echo "          \"version\": \"$EXT_VERSION\"" >> "$REPORT_FILE"
                echo "        }" >> "$REPORT_FILE"
            done <<< "$AI_EXTENSIONS"
        fi

        echo "      ]" >> "$REPORT_FILE"
        echo "    }," >> "$REPORT_FILE"
    else
        echo "    \"$ide_name\": {" >> "$REPORT_FILE"
        echo "      \"installed\": false" >> "$REPORT_FILE"
        echo "    }," >> "$REPORT_FILE"
    fi
}

# Verificar Cursor
check_vscode_extensions "cursor" "$HOME/Library/Application Support/Cursor/User/extensions"

# Verificar VS Code
check_vscode_extensions "vscode" "$HOME/Library/Application Support/Code/User/extensions"

# Verificar extensões conhecidas de IA
KNOWN_AI_EXTENSIONS=(
    "GitHub.copilot"
    "GitHub.copilot-chat"
    "Codeium.codeium"
    "TabNine.tabnine-vscode"
    "AmazonWebServices.aws-toolkits"
)

echo "    \"known_extensions\": {" >> "$REPORT_FILE"
FIRST=true
for ext_id in "${KNOWN_AI_EXTENSIONS[@]}"; do
    if [ "$FIRST" = false ]; then
        echo "," >> "$REPORT_FILE"
    fi
    FIRST=false

    EXT_NAME=$(echo "$ext_id" | cut -d'.' -f2)
    FOUND=false

    # Verificar em Cursor
    if [ -d "$HOME/Library/Application Support/Cursor/User/extensions" ]; then
        if find "$HOME/Library/Application Support/Cursor/User/extensions" -type d -name "*${ext_id}*" | grep -q .; then
            FOUND=true
        fi
    fi

    # Verificar em VS Code
    if [ -d "$HOME/Library/Application Support/Code/User/extensions" ]; then
        if find "$HOME/Library/Application Support/Code/User/extensions" -type d -name "*${ext_id}*" | grep -q .; then
            FOUND=true
        fi
    fi

    echo "      \"$EXT_NAME\": {" >> "$REPORT_FILE"
    echo "        \"id\": \"$ext_id\"," >> "$REPORT_FILE"
    echo "        \"installed\": $FOUND" >> "$REPORT_FILE"
    echo "      }" >> "$REPORT_FILE"
done

echo "    }" >> "$REPORT_FILE"
echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

