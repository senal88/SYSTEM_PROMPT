#!/bin/bash

# ============================================
# Script de Coleta: Gemini API - Ubuntu
# ============================================
# Verifica configuração da API Gemini
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/gemini_api_ubuntu.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"Ubuntu\"," >> "$REPORT_FILE"
echo "  \"gemini_api\": {" >> "$REPORT_FILE"

# Verificar API key
if [ -n "$GEMINI_API_KEY" ] || [ -n "$GOOGLE_AI_API_KEY" ]; then
    API_KEY="${GEMINI_API_KEY:-$GOOGLE_AI_API_KEY}"
    KEY_PREFIX="${API_KEY:0:10}..."
    LENGTH=${#API_KEY}
    echo "    \"api_key\": {" >> "$REPORT_FILE"
    echo "      \"configured\": true," >> "$REPORT_FILE"
    echo "      \"prefix\": \"$KEY_PREFIX\"," >> "$REPORT_FILE"
    echo "      \"length\": $LENGTH" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
else
    echo "    \"api_key\": {" >> "$REPORT_FILE"
    echo "      \"configured\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Verificar biblioteca Python
if command -v python3 &> /dev/null; then
    if python3 -c "import google.generativeai" 2>/dev/null; then
        VERSION=$(python3 -c "import google.generativeai; print(getattr(google.generativeai, '__version__', 'installed'))" 2>/dev/null || echo "installed")
        echo "    \"python_library\": {" >> "$REPORT_FILE"
        echo "      \"installed\": true," >> "$REPORT_FILE"
        echo "      \"version\": \"$VERSION\"" >> "$REPORT_FILE"
        echo "    }," >> "$REPORT_FILE"
    else
        echo "    \"python_library\": {" >> "$REPORT_FILE"
        echo "      \"installed\": false" >> "$REPORT_FILE"
        echo "    }," >> "$REPORT_FILE"
    fi
else
    echo "    \"python_library\": {" >> "$REPORT_FILE"
    echo "      \"installed\": false" >> "$REPORT_FILE"
    echo "    }," >> "$REPORT_FILE"
fi

# Verificar CLI (se existir)
if command -v gemini &> /dev/null; then
    VERSION=$(gemini --version 2>/dev/null || echo "installed")
    echo "    \"cli\": {" >> "$REPORT_FILE"
    echo "      \"installed\": true," >> "$REPORT_FILE"
    echo "      \"version\": \"$VERSION\"," >> "$REPORT_FILE"
    echo "      \"path\": \"$(which gemini)\"" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
else
    echo "    \"cli\": {" >> "$REPORT_FILE"
    echo "      \"installed\": false" >> "$REPORT_FILE"
    echo "    }" >> "$REPORT_FILE"
fi

echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

