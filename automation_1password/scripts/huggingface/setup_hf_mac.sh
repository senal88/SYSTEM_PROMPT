#!/bin/bash
# setup_hf_mac.sh
# Configuração HuggingFace Pro no macOS
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🤗 Configurando HuggingFace Pro no macOS"
echo "========================================"

# Verificar Python
if ! command -v python3 &>/dev/null; then
    echo "❌ Python3 não encontrado. Instale com: brew install python3"
    exit 1
fi

# Instalar HuggingFace Hub
echo "📦 Instalando HuggingFace Hub..."
pip3 install --upgrade huggingface_hub transformers datasets accelerate

# Configurar diretórios de cache
HF_HOME="${HOME}/.cache/huggingface"
HF_DATASETS="${HF_HOME}/datasets"
HF_HUB="${HF_HOME}/hub"

mkdir -p "${HF_HOME}" "${HF_DATASETS}" "${HF_HUB}"

# Configurar variáveis de ambiente
cat >> ~/.zshrc << 'EOF'

# HuggingFace Pro Configuration
export HF_HOME="$HOME/.cache/huggingface"
export HF_DATASETS_CACHE="$HF_HOME/datasets"
export HF_HUB_CACHE="$HF_HOME/hub"
export HF_TOKEN="${HF_TOKEN}"
EOF

# Login no HuggingFace
if command -v op &>/dev/null && op whoami &>/dev/null; then
    echo "🔐 Obtendo token do 1Password..."
    HF_TOKEN=$(op read "op://1p_macos/HuggingFace-Token/credential" 2>/dev/null || echo "")
    
    if [ -n "$HF_TOKEN" ]; then
        hugginface-cli login --token "$HF_TOKEN"
        echo "✅ Login no HuggingFace concluído"
    else
        echo "⚠️  Token não encontrado. Execute: huggingface-cli login"
    fi
fi

echo "✅ HuggingFace configurado"
echo ""
echo "Cache configurado em: ${HF_HOME}"
echo "Token salvo em ~/.zshrc"

