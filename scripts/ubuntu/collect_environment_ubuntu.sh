#!/bin/bash

# ============================================
# Script de Coleta: Ambiente - Ubuntu
# ============================================
# Coleta shell, aliases, env vars relevantes
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/environment_ubuntu.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"Ubuntu\"," >> "$REPORT_FILE"
echo "  \"environment\": {" >> "$REPORT_FILE"

# Informações do sistema
echo "    \"system\": {" >> "$REPORT_FILE"
echo "      \"hostname\": \"$(hostname)\"," >> "$REPORT_FILE"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "      \"os_name\": \"$NAME\"," >> "$REPORT_FILE"
    echo "      \"os_version\": \"$VERSION\"," >> "$REPORT_FILE"
fi
echo "      \"architecture\": \"$(uname -m)\"," >> "$REPORT_FILE"
echo "      \"kernel\": \"$(uname -r)\"" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

# Shell
echo "    \"shell\": {" >> "$REPORT_FILE"
echo "      \"current\": \"$SHELL\"," >> "$REPORT_FILE"
echo "      \"version\": \"$($SHELL --version 2>/dev/null | head -1 || echo 'unknown')\"" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

# Aliases relacionados a IA
echo "    \"aliases\": {" >> "$REPORT_FILE"
ALIASES=$(alias 2>/dev/null | grep -E "(system-prompt|cursor|chatgpt|claude|gemini|openai|ia|ai)" || echo "")
if [ -n "$ALIASES" ]; then
    echo "      \"found\": true," >> "$REPORT_FILE"
    echo "      \"count\": $(echo "$ALIASES" | wc -l | tr -d ' ')" >> "$REPORT_FILE"
else
    echo "      \"found\": false," >> "$REPORT_FILE"
    echo "      \"count\": 0" >> "$REPORT_FILE"
fi
echo "    }," >> "$REPORT_FILE"

# Variáveis de ambiente relevantes
echo "    \"env_vars\": {" >> "$REPORT_FILE"
ENV_VARS=(
    "PATH"
    "HOME"
    "USER"
    "EDITOR"
    "LANG"
    "LC_ALL"
    "OPENAI_API_KEY"
    "ANTHROPIC_API_KEY"
    "GEMINI_API_KEY"
    "HUGGINGFACE_API_KEY"
)

FIRST=true
for var in "${ENV_VARS[@]}"; do
    if [ "$FIRST" = false ]; then
        echo "," >> "$REPORT_FILE"
    fi
    FIRST=false

    VALUE="${!var}"
    if [ -n "$VALUE" ]; then
        # Sanitizar valores sensíveis
        if [[ "$var" == *"API_KEY"* ]] || [[ "$var" == *"TOKEN"* ]]; then
            DISPLAY_VALUE="${VALUE:0:10}... (hidden)"
        else
            DISPLAY_VALUE="$VALUE"
        fi
        echo "      \"$var\": \"$DISPLAY_VALUE\"" >> "$REPORT_FILE"
    else
        echo "      \"$var\": null" >> "$REPORT_FILE"
    fi
done

echo "    }" >> "$REPORT_FILE"
echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

