#!/bin/bash

# ============================================
# Script de Sincronização: Mac ↔ VPS
# ============================================
# Sincroniza system prompt entre ambientes
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"

echo "============================================"
echo "🔄 Sincronização System Prompt"
echo "============================================"
echo ""

# Detectar plataforma atual
if [[ "$OSTYPE" == "darwin"* ]]; then
    CURRENT_PLATFORM="macos"
    REMOTE_PLATFORM="ubuntu"
else
    CURRENT_PLATFORM="ubuntu"
    REMOTE_PLATFORM="macos"
fi

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado em $GLOBAL_PROMPT"
    exit 1
fi

echo "📁 Arquivo local: $GLOBAL_PROMPT"
echo "🖥️  Plataforma atual: $CURRENT_PLATFORM"
echo ""

# Solicitar informações de conexão
read -p "Digite o hostname/IP do ambiente remoto ($REMOTE_PLATFORM): " REMOTE_HOST
read -p "Digite o usuário remoto [root]: " REMOTE_USER
REMOTE_USER=${REMOTE_USER:-root}

read -p "Digite o caminho remoto do system prompt [/root/SYSTEM_PROMPT/system_prompt_global.txt]: " REMOTE_PATH
REMOTE_PATH=${REMOTE_PATH:-/root/SYSTEM_PROMPT/system_prompt_global.txt}

echo ""
echo "Escolha a direção da sincronização:"
echo "  1) Local → Remoto (enviar para $REMOTE_PLATFORM)"
echo "  2) Remoto → Local (receber de $REMOTE_PLATFORM)"
read -p "Escolha [1]: " SYNC_DIRECTION
SYNC_DIRECTION=${SYNC_DIRECTION:-1}

echo ""

if [ "$SYNC_DIRECTION" = "1" ]; then
    echo "📤 Enviando para $REMOTE_HOST..."

    # Verificar se rsync está disponível
    if command -v rsync &> /dev/null; then
        rsync -avz -e ssh "$GLOBAL_PROMPT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
        echo ""
        echo "✅ Sincronização concluída (rsync)"
    elif command -v scp &> /dev/null; then
        scp "$GLOBAL_PROMPT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
        echo ""
        echo "✅ Sincronização concluída (scp)"
    else
        echo "❌ Erro: rsync ou scp não encontrado"
        echo ""
        echo "📋 Sincronização manual:"
        echo "   scp $GLOBAL_PROMPT $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
        exit 1
    fi

    # Sincronizar .cursorrules também
    CURSOR_RULES="$HOME/.cursorrules"
    if [ -f "$CURSOR_RULES" ]; then
        read -p "Deseja sincronizar .cursorrules também? [s/N]: " SYNC_CURSOR
        if [[ "$SYNC_CURSOR" =~ ^[Ss]$ ]]; then
            REMOTE_CURSOR="$HOME/.cursorrules"
            if command -v rsync &> /dev/null; then
                rsync -avz -e ssh "$CURSOR_RULES" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_CURSOR"
            else
                scp "$CURSOR_RULES" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_CURSOR"
            fi
            echo "✅ .cursorrules sincronizado"
        fi
    fi

else
    echo "📥 Recebendo de $REMOTE_HOST..."

    # Criar backup do arquivo local
    if [ -f "$GLOBAL_PROMPT" ]; then
        BACKUP_FILE="${GLOBAL_PROMPT}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$GLOBAL_PROMPT" "$BACKUP_FILE"
        echo "💾 Backup criado: $BACKUP_FILE"
    fi

    # Verificar se rsync está disponível
    if command -v rsync &> /dev/null; then
        rsync -avz -e ssh "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" "$GLOBAL_PROMPT"
        echo ""
        echo "✅ Sincronização concluída (rsync)"
    elif command -v scp &> /dev/null; then
        scp "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" "$GLOBAL_PROMPT"
        echo ""
        echo "✅ Sincronização concluída (scp)"
    else
        echo "❌ Erro: rsync ou scp não encontrado"
        echo ""
        echo "📋 Sincronização manual:"
        echo "   scp $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH $GLOBAL_PROMPT"
        exit 1
    fi
fi

echo ""
echo "============================================"
echo "✅ Sincronização concluída!"
echo "============================================"
echo ""
echo "📋 Próximos passos:"
echo "   1. Verificar checksums em ambos os ambientes"
echo "   2. Aplicar system prompt no ambiente remoto (se necessário)"
echo "   3. Executar validação: validate_ia_system.sh"
echo ""

