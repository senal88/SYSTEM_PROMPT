#!/bin/bash

# ============================================
# Script de Coleta: Ferramentas de IA - Ubuntu
# ============================================
# Detecta ferramentas CLI de IA instaladas
# ============================================

set -e

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
mkdir -p "$OUTPUT_DIR"

REPORT_FILE="$OUTPUT_DIR/ia_tools_ubuntu.json"

# Inicializar JSON
echo "{" > "$REPORT_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$REPORT_FILE"
echo "  \"platform\": \"Ubuntu\"," >> "$REPORT_FILE"
echo "  \"tools\": {" >> "$REPORT_FILE"

# Função para verificar comando
check_command() {
    local cmd=$1
    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>/dev/null | head -1 || echo "installed")
        echo "      \"$cmd\": {" >> "$REPORT_FILE"
        echo "        \"installed\": true," >> "$REPORT_FILE"
        echo "        \"version\": \"$version\"," >> "$REPORT_FILE"
        echo "        \"path\": \"$(which $cmd)\"" >> "$REPORT_FILE"
        echo "      }," >> "$REPORT_FILE"
    else
        echo "      \"$cmd\": {" >> "$REPORT_FILE"
        echo "        \"installed\": false" >> "$REPORT_FILE"
        echo "      }," >> "$REPORT_FILE"
    fi
}

# Verificar ferramentas CLI
echo "    \"cli_tools\": {" >> "$REPORT_FILE"
check_command "ollama"
check_command "huggingface-cli"
check_command "anthropic"
check_command "cursor"
check_command "code"

# Verificar Python e bibliotecas de IA
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>/dev/null || echo "unknown")
    echo "      \"python3\": {" >> "$REPORT_FILE"
    echo "        \"installed\": true," >> "$REPORT_FILE"
    echo "        \"version\": \"$PYTHON_VERSION\"," >> "$REPORT_FILE"
    echo "        \"path\": \"$(which python3)\"" >> "$REPORT_FILE"
    echo "      }," >> "$REPORT_FILE"

    # Verificar bibliotecas Python de IA
    echo "      \"python_packages\": {" >> "$REPORT_FILE"
    for pkg in openai anthropic google.generativeai transformers; do
        PKG_NAME=$(echo "$pkg" | tr '.' '_')
        if python3 -c "import $PKG_NAME" 2>/dev/null; then
            VERSION=$(python3 -c "import $PKG_NAME; print($PKG_NAME.__version__)" 2>/dev/null || echo "installed")
            echo "        \"$pkg\": {" >> "$REPORT_FILE"
            echo "          \"installed\": true," >> "$REPORT_FILE"
            echo "          \"version\": \"$VERSION\"" >> "$REPORT_FILE"
            echo "        }," >> "$REPORT_FILE"
        else
            echo "        \"$pkg\": {" >> "$REPORT_FILE"
            echo "          \"installed\": false" >> "$REPORT_FILE"
            echo "        }," >> "$REPORT_FILE"
        fi
    done
    echo "      }" >> "$REPORT_FILE"
else
    echo "      \"python3\": {" >> "$REPORT_FILE"
    echo "        \"installed\": false" >> "$REPORT_FILE"
    echo "      }," >> "$REPORT_FILE"
fi

echo "    }" >> "$REPORT_FILE"
echo "  }" >> "$REPORT_FILE"
echo "}" >> "$REPORT_FILE"

cat "$REPORT_FILE"

