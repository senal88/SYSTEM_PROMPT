#!/bin/bash

# ============================================
# Script de Coleta: System Prompt - macOS
# ============================================
# Verifica system prompt global e configurações do Cursor
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/system_prompt_macos.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"macOS\"," >> "$REPORT_FILE"
echo "  \"hostname\": \"$(hostname)\"," >> "$REPORT_FILE"
echo "  \"system_prompt\": {" >> "$REPORT_FILE"

# Verificar system prompt global
GLOBAL_PROMPT="$HOME/.system_prompts/system_prompt_global.txt"
CURSOR_RULES="$HOME/.cursorrules"
CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"

if [ -f "$GLOBAL_PROMPT" ]; then
    CHECKSUM=$(shasum -a 256 "$GLOBAL_PROMPT" | cut -d' ' -f1)
    SIZE=$(stat -f%z "$GLOBAL_PROMPT" 2>/dev/null || echo "0")
    echo "    \"global_file\": {" >> "$REPORT_FILE"
    echo "      \"exists\": true," >> "$REPORT_FILE"
    echo "      \"path\": \"$GLOBAL_PROMPT\"," >> "$REPORT_FILE"
    echo "      \"checksum\": \"$CHECKSUM\"," >> "$REPORT_FILE"
    echo "      \"size\": $SIZE" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
else
    echo "    \"global_file\": {" >> "$REPORT_FILE"
    echo "      \"exists\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Verificar .cursorrules
if [ -f "$CURSOR_RULES" ]; then
    CHECKSUM=$(shasum -a 256 "$CURSOR_RULES" | cut -d' ' -f1)
    SIZE=$(stat -f%z "$CURSOR_RULES" 2>/dev/null || echo "0")
    echo "    \"cursor_rules\": {" >> "$REPORT_FILE"
    echo "      \"exists\": true," >> "$REPORT_FILE"
    echo "      \"path\": \"$CURSOR_RULES\"," >> "$REPORT_FILE"
    echo "      \"checksum\": \"$CHECKSUM\"," >> "$REPORT_FILE"
    echo "      \"size\": $SIZE" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
else
    echo "    \"cursor_rules\": {" >> "$REPORT_FILE"
    echo "      \"exists\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Verificar settings.json do Cursor
if [ -f "$CURSOR_SETTINGS" ]; then
    SYSTEM_PROMPT_ENABLED=$(grep -o '"cursor.systemPrompt.enabled":\s*true' "$CURSOR_SETTINGS" 2>/dev/null && echo "true" || echo "false")
    SYSTEM_PROMPT_PATH=$(grep -o '"cursor.systemPrompt":\s*"[^"]*"' "$CURSOR_SETTINGS" 2>/dev/null | cut -d'"' -f4 || echo "")
    echo "    \"cursor_settings\": {" >> "$REPORT_FILE"
    echo "      \"exists\": true," >> "$REPORT_FILE"
    echo "      \"system_prompt_enabled\": $SYSTEM_PROMPT_ENABLED," >> "$REPORT_FILE"
    echo "      \"system_prompt_path\": \"$SYSTEM_PROMPT_PATH\"" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
else
    echo "    \"cursor_settings\": {" >> "$REPORT_FILE"
    echo "      \"exists\": false" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
fi

echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

