#!/bin/bash

# ============================================
# Script de Coleta: Configurações Cursor IDE - macOS
# ============================================
# Coleta configurações completas do Cursor IDE
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/cursor_config_macos.json"

CURSOR_APP="/Applications/Cursor.app"
CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
CURSOR_KEYBINDINGS="$HOME/Library/Application Support/Cursor/User/keybindings.json"
CURSOR_RULES="$HOME/.cursorrules"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"macOS\"," >> "$REPORT_FILE"
echo "  \"cursor_ide\": {" >> "$REPORT_FILE"

# Verificar se Cursor está instalado
if [ -d "$CURSOR_APP" ]; then
    VERSION=$(defaults read "$CURSOR_APP/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "unknown")
    echo "    \"installed\": true," >> "$REPORT_FILE"
    echo "    \"version\": \"$VERSION\"," >> "$REPORT_FILE"
    echo "    \"path\": \"$CURSOR_APP\"," >> "$REPORT_FILE"
else
    echo "    \"installed\": false," >> "$REPORT_FILE"
    echo "    \"version\": null," >> "$REPORT_FILE"
fi

# Verificar settings.json
if [ -f "$CURSOR_SETTINGS" ]; then
    SYSTEM_PROMPT_ENABLED=$(grep -o '"cursor.systemPrompt.enabled":\s*true' "$CURSOR_SETTINGS" 2>/dev/null && echo "true" || echo "false")
    SYSTEM_PROMPT_PATH=$(grep -o '"cursor.systemPrompt":\s*"[^"]*"' "$CURSOR_SETTINGS" 2>/dev/null | cut -d'"' -f4 || echo "")
    MODELS=$(grep -o '"cursor.chat.model":\s*"[^"]*"' "$CURSOR_SETTINGS" 2>/dev/null | cut -d'"' -f4 || echo "")

    echo "    \"settings\": {" >> "$REPORT_FILE"
    echo "      \"exists\": true," >> "$REPORT_FILE"
    echo "      \"system_prompt_enabled\": $SYSTEM_PROMPT_ENABLED," >> "$REPORT_FILE"
    echo "      \"system_prompt_path\": \"$SYSTEM_PROMPT_PATH\"," >> "$REPORT_FILE"
    echo "      \"chat_model\": \"$MODELS\"" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
else
    echo "    \"settings\": {" >> "$REPORT_FILE"
    echo "      \"exists\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Verificar .cursorrules
if [ -f "$CURSOR_RULES" ]; then
    CHECKSUM=$(shasum -a 256 "$CURSOR_RULES" | cut -d' ' -f1)
    echo "    \"cursor_rules\": {" >> "$REPORT_FILE"
    echo "      \"exists\": true," >> "$REPORT_FILE"
    echo "      \"path\": \"$CURSOR_RULES\"," >> "$REPORT_FILE"
    echo "      \"checksum\": \"$CHECKSUM\"" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
else
    echo "    \"cursor_rules\": {" >> "$REPORT_FILE"
    echo "      \"exists\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Verificar extensões (se possível)
EXTENSIONS_DIR="$HOME/Library/Application Support/Cursor/User/extensions"
if [ -d "$EXTENSIONS_DIR" ]; then
    EXT_COUNT=$(find "$EXTENSIONS_DIR" -maxdepth 2 -name "package.json" | wc -l | tr -d ' ')
    echo "    \"extensions\": {" >> "$REPORT_FILE"
    echo "      \"count\": $EXT_COUNT," >> "$REPORT_FILE"
    echo "      \"directory\": \"$EXTENSIONS_DIR\"" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
else
    echo "    \"extensions\": {" >> "$REPORT_FILE"
    echo "      \"count\": 0" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
fi

echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

