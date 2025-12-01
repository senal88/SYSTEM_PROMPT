#!/bin/bash

# ============================================
# Script de Aplicação: System Prompt Claude API
# ============================================
# Configura system prompt para uso com Claude API
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
CONFIG_FILE="$PROMPT_DIR/configs/claude_api_config.py"

echo "============================================"
echo "🔧 Configurando Claude API com System Prompt"
echo "============================================"
echo ""

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado"
    exit 1
fi

# Verificar API key
if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$CLAUDE_API_KEY" ]; then
    echo "⚠️  Aviso: ANTHROPIC_API_KEY ou CLAUDE_API_KEY não configurada"
    echo "   Configure a variável de ambiente antes de usar"
fi

# Criar diretório de configs se não existir
mkdir -p "$(dirname "$CONFIG_FILE")"

# Ler prompt global
PROMPT_CONTENT=$(cat "$GLOBAL_PROMPT" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Criar arquivo de configuração Python
cat > "$CONFIG_FILE" << EOF
#!/usr/bin/env python3
"""
Configuração Claude API com System Prompt
"""

import os
from anthropic import Anthropic

# Carregar system prompt
SYSTEM_PROMPT = """$PROMPT_CONTENT"""

def get_claude_client():
    """Retorna cliente Claude configurado com system prompt"""
    api_key = os.getenv("ANTHROPIC_API_KEY") or os.getenv("CLAUDE_API_KEY")
    if not api_key:
        raise ValueError("ANTHROPIC_API_KEY ou CLAUDE_API_KEY não configurada")

    return Anthropic(api_key=api_key)

def chat_with_system_prompt(message, model="claude-3-5-sonnet-20241022"):
    """Envia mensagem com system prompt"""
    client = get_claude_client()

    response = client.messages.create(
        model=model,
        max_tokens=4096,
        system=SYSTEM_PROMPT,
        messages=[
            {"role": "user", "content": message}
        ]
    )

    return response.content[0].text

if __name__ == "__main__":
    # Exemplo de uso
    message = input("Digite sua mensagem: ")
    response = chat_with_system_prompt(message)
    print("\nResposta:")
    print(response)
EOF

chmod +x "$CONFIG_FILE"

echo "✅ Configuração criada em: $CONFIG_FILE"
echo ""
echo "📋 Como usar:"
echo "   1. Configure a API key:"
echo "      export ANTHROPIC_API_KEY='sua-chave-aqui'"
echo ""
echo "   2. Use o script Python:"
echo "      python3 $CONFIG_FILE"
echo ""
echo "   3. Ou importe em seu código:"
echo "      from claude_api_config import chat_with_system_prompt"
echo "      response = chat_with_system_prompt('sua mensagem')"
echo ""

