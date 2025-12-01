#!/bin/bash

# ============================================
# Script de Aplicação: System Prompt no Cursor
# ============================================
# Aplica system prompt global no Cursor IDE
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"

# Detectar plataforma
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    CURSOR_RULES="$HOME/.cursorrules"
    CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
else
    PLATFORM="ubuntu"
    CURSOR_RULES="$HOME/.cursorrules"
    CURSOR_SETTINGS="$HOME/.config/Cursor/User/settings.json"
fi

echo "============================================"
echo "🔧 Aplicando System Prompt no Cursor IDE"
echo "============================================"
echo ""
echo "📁 Prompt Global: $GLOBAL_PROMPT"
echo "🖥️  Plataforma: $PLATFORM"
echo ""

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado em $GLOBAL_PROMPT"
    exit 1
fi

# 1. Copiar prompt para .cursorrules
echo "1️⃣  Criando/atualizando ~/.cursorrules..."
cp "$GLOBAL_PROMPT" "$CURSOR_RULES"
echo "   ✅ ~/.cursorrules atualizado"

# 2. Configurar settings.json
echo ""
echo "2️⃣  Configurando settings.json..."

# Criar diretório se não existir
SETTINGS_DIR=$(dirname "$CURSOR_SETTINGS")
mkdir -p "$SETTINGS_DIR"

# Se settings.json não existe, criar
if [ ! -f "$CURSOR_SETTINGS" ]; then
    echo "   📝 Criando novo settings.json..."
    echo "{}" > "$CURSOR_SETTINGS"
fi

# Verificar se já está configurado
if grep -q '"cursor.systemPrompt.enabled":\s*true' "$CURSOR_SETTINGS" 2>/dev/null; then
    echo "   ℹ️  System prompt já está habilitado"
else
    # Adicionar configuração usando Python ou jq
    if command -v python3 &> /dev/null; then
        python3 << EOF
import json
import os

settings_file = "$CURSOR_SETTINGS"
prompt_path = "$GLOBAL_PROMPT"

# Ler settings existente
try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)
except:
    settings = {}

# Atualizar configurações
settings["cursor.systemPrompt.enabled"] = True
settings["cursor.systemPrompt"] = prompt_path

# Salvar
with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)

print("   ✅ Settings.json atualizado")
EOF
    elif command -v jq &> /dev/null; then
        # Usar jq como fallback
        TMP_FILE=$(mktemp)
        jq '. + {"cursor.systemPrompt.enabled": true, "cursor.systemPrompt": "'"$GLOBAL_PROMPT"'"}' "$CURSOR_SETTINGS" > "$TMP_FILE"
        mv "$TMP_FILE" "$CURSOR_SETTINGS"
        echo "   ✅ Settings.json atualizado"
    else
        echo "   ⚠️  Python3 ou jq não encontrado. Configure manualmente:"
        echo "      \"cursor.systemPrompt.enabled\": true"
        echo "      \"cursor.systemPrompt\": \"$GLOBAL_PROMPT\""
    fi
fi

echo ""
echo "============================================"
echo "✅ System Prompt aplicado com sucesso!"
echo "============================================"
echo ""
echo "📋 Próximos passos:"
echo "   1. Reinicie o Cursor IDE"
echo "   2. Verifique se o prompt está ativo (Cmd+L ou Ctrl+L)"
echo "   3. Execute validação: validate_ia_system.sh"
echo ""

