#!/bin/bash

# ============================================
# Script de Coleta: API Keys - macOS
# ============================================
# Verifica disponibilidade de API keys (sanitizado)
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/api_keys_macos.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"macOS\"," >> "$REPORT_FILE"
echo "  \"api_keys\": {" >> "$REPORT_FILE"

# Lista de API keys para verificar
KEYS=(
    "OPENAI_API_KEY"
    "ANTHROPIC_API_KEY"
    "CLAUDE_API_KEY"
    "GEMINI_API_KEY"
    "GOOGLE_AI_API_KEY"
    "HUGGINGFACE_API_KEY"
    "HF_TOKEN"
    "PERPLEXITY_API_KEY"
)

FIRST=true
for key in "${KEYS[@]}"; do
    if [ "$FIRST" = false ]; then
        echo "," >> "$REPORT_FILE"
    fi
    FIRST=false

    VALUE="${!key}"
    if [ -n "$VALUE" ]; then
        PREFIX="${VALUE:0:10}..."
        LENGTH=${#VALUE}
        echo "    \"$key\": {" >> "$REPORT_FILE"
        echo "      \"configured\": true," >> "$REPORT_FILE"
        echo "      \"prefix\": \"$PREFIX\"," >> "$REPORT_FILE"
        echo "      \"length\": $LENGTH" >> "$REPORT_FILE"
        echo "    }" >> "$REPORT_FILE"
    else
        echo "    \"$key\": {" >> "$REPORT_FILE"
        echo "      \"configured\": false" >> "$REPORT_FILE"
        echo "    }" >> "$REPORT_FILE"
    fi
done

# Verificar arquivos .env
ENV_FILES=(
    "$HOME/.env"
    "$HOME/.env.local"
    "$HOME/.zshrc"
    "$HOME/.bash_profile"
    "$HOME/.bashrc"
)

echo "," >> "$REPORT_FILE"
echo "    \"env_files\": {" >> "$REPORT_FILE"
FIRST=true
for env_file in "${ENV_FILES[@]}"; do
    if [ "$FIRST" = false ]; then
        echo "," >> "$REPORT_FILE"
    fi
    FIRST=false

    if [ -f "$env_file" ]; then
        echo "      \"$(basename $env_file)\": {" >> "$REPORT_FILE"
        echo "        \"exists\": true," >> "$REPORT_FILE"
        echo "        \"path\": \"$env_file\"" >> "$REPORT_FILE"
        echo "      }" >> "$REPORT_FILE"
    else
        echo "      \"$(basename $env_file)\": {" >> "$REPORT_FILE"
        echo "        \"exists\": false" >> "$REPORT_FILE"
        echo "      }" >> "$REPORT_FILE"
    fi
done

echo "    }" >> "$REPORT_FILE"
echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

