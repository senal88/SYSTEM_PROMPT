#!/bin/bash

# ============================================
# Script de Instalação: SSH Config macOS
# ============================================
# Instala configuração SSH completa no macOS
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SSH_CONFIG_SOURCE="$PROMPT_DIR/configs/ssh_config_macos_complete"
SSH_CONFIG_TARGET="$HOME/.ssh/config"
SSH_DIR="$HOME/.ssh"

echo "============================================"
echo "🔧 Instalação SSH Config - macOS"
echo "============================================"
echo ""

# Verificar se estamos no macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Este script é apenas para macOS"
    exit 1
fi

# Verificar se arquivo fonte existe
if [ ! -f "$SSH_CONFIG_SOURCE" ]; then
    echo "❌ Arquivo fonte não encontrado: $SSH_CONFIG_SOURCE"
    exit 1
fi

# Criar diretório .ssh se não existir
if [ ! -d "$SSH_DIR" ]; then
    echo "📁 Criando diretório ~/.ssh..."
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Fazer backup do config existente
if [ -f "$SSH_CONFIG_TARGET" ]; then
    BACKUP_FILE="${SSH_CONFIG_TARGET}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Fazendo backup do config existente..."
    cp "$SSH_CONFIG_TARGET" "$BACKUP_FILE"
    echo "   Backup salvo em: $BACKUP_FILE"
fi

# Copiar novo config
echo "📋 Instalando nova configuração SSH..."
cp "$SSH_CONFIG_SOURCE" "$SSH_CONFIG_TARGET"
chmod 600 "$SSH_CONFIG_TARGET"

echo ""
echo "✅ Configuração SSH instalada com sucesso!"
echo ""
echo "📋 Próximos passos:"
echo "   1. Revisar configuração: nano ~/.ssh/config"
echo "   2. Testar conexões:"
echo "      ssh -T vps"
echo "      ssh -T git@github.com"
echo "   3. Verificar permissões:"
echo "      chmod 600 ~/.ssh/config"
echo "      chmod 600 ~/.ssh/id_ed25519_universal"
echo ""
