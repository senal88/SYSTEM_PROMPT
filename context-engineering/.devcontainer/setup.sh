#!/bin/bash
# Setup script para devcontainer
# Executado automaticamente após criação do container

set -euo pipefail

echo "🚀 Configurando devcontainer..."

# Instalar 1Password CLI
if ! command -v op &>/dev/null; then
    echo "📦 Instalando 1Password CLI..."
    curl -sSfLo op.zip "https://cache.agilebits.com/dist/1P/op2/pkg/v2.24.0/op_linux_amd64_v2.24.0.zip"
    unzip -od /usr/local/bin/ op.zip
    rm op.zip
    chmod +x /usr/local/bin/op
    echo "✅ 1Password CLI instalado"
fi

# Configurar Git (se necessário)
if [ -n "${GITHUB_TOKEN:-}" ]; then
    git config --global credential.helper store
fi

# Criar diretórios necessários
mkdir -p ~/.config/op
mkdir -p ~/.cursor

# Copiar configurações se dotfiles estiverem disponíveis
if [ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]; then
    DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
    if [ -f "$DOTFILES_DIR/context-engineering/.cursorrules" ]; then
        cp "$DOTFILES_DIR/context-engineering/.cursorrules" ~/.cursorrules
        echo "✅ .cursorrules copiado"
    fi
fi

echo "✅ Setup do devcontainer concluído!"

