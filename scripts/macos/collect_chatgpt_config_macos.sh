#!/bin/bash

# ============================================
# Script de Coleta: ChatGPT Plus - macOS
# ============================================
# Verifica configurações do ChatGPT Plus (se aplicável)
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/chatgpt_config_macos.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"macOS\"," >> "$REPORT_FILE"
echo "  \"chatgpt_plus\": {" >> "$REPORT_FILE"

# Verificar se há app do ChatGPT instalado
CHATGPT_APP="/Applications/ChatGPT.app"
if [ -d "$CHATGPT_APP" ]; then
    VERSION=$(defaults read "$CHATGPT_APP/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "unknown")
    echo "    \"app_installed\": true," >> "$REPORT_FILE"
    echo "    \"app_version\": \"$VERSION\"," >> "$REPORT_FILE"
else
    echo "    \"app_installed\": false," >> "$REPORT_FILE"
fi

# Verificar configurações locais (se existirem)
CHATGPT_CONFIG="$HOME/Library/Application Support/ChatGPT"
if [ -d "$CHATGPT_CONFIG" ]; then
    echo "    \"config_directory\": {" >> "$REPORT_FILE"
    echo "      \"exists\": true," >> "$REPORT_FILE"
    echo "      \"path\": \"$CHATGPT_CONFIG\"" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
else
    echo "    \"config_directory\": {" >> "$REPORT_FILE"
    echo "      \"exists\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Nota: Custom Instructions do ChatGPT Plus são configuradas via web/app
# Não há arquivo local para verificar, apenas documentar
echo "    \"custom_instructions\": {" >> "$REPORT_FILE"
echo "      \"note\": \"Custom Instructions são configuradas via interface web/app do ChatGPT Plus\"," >> "$REPORT_FILE"
echo "      \"setup_required\": true" >> "$REPORT_FILE"
echo "    }," >> "$REPORT_FILE"

# Verificar se há API key configurada
if [ -n "$OPENAI_API_KEY" ]; then
    KEY_PREFIX="${OPENAI_API_KEY:0:10}..."
    echo "    \"api_key\": {" >> "$REPORT_FILE"
    echo "      \"configured\": true," >> "$REPORT_FILE"
    echo "      \"prefix\": \"$KEY_PREFIX\"" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
else
    echo "    \"api_key\": {" >> "$REPORT_FILE"
    echo "      \"configured\": false" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
fi

echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

