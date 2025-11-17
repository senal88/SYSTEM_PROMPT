#!/bin/bash

#################################################################################
# DevContainer Post-Create Script
# Versão: 2.0.1
# Executado após criação do container
#################################################################################

set -e

echo "🚀 Configurando DevContainer..."

# Instalar dependências Python globais
if [ -f "requirements.txt" ]; then
    echo "📦 Instalando dependências Python..."
    pip install --user -r requirements.txt
fi

# Instalar dependências Node.js
if [ -f "package.json" ]; then
    echo "📦 Instalando dependências Node.js..."
    npm install
fi

# Configurar Git (se não estiver configurado)
if [ -z "$(git config --global user.name)" ]; then
    echo "⚙️  Configurando Git..."
    git config --global init.defaultBranch main
    git config --global pull.rebase false
fi

# Configurar Zsh
if [ -f "$HOME/.zshrc" ]; then
    echo "⚙️  Configurando Zsh..."
    # Adicionar aliases úteis
    cat >> "$HOME/.zshrc" << 'EOF'

# DevContainer aliases
alias la='ls -lah'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd ../..'
EOF
fi

# Criar diretórios úteis
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.cache"

echo "✅ DevContainer configurado com sucesso!"

