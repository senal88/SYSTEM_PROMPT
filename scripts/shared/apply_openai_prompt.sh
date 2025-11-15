#!/bin/bash

# ============================================
# Script de Aplicação: System Prompt OpenAI API
# ============================================
# Configura system prompt para uso com OpenAI API
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
CONFIG_FILE="$PROMPT_DIR/configs/openai_api_config.py"

echo "============================================"
echo "🔧 Configurando OpenAI API com System Prompt"
echo "============================================"
echo ""

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado"
    exit 1
fi

# Verificar API key
if [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  Aviso: OPENAI_API_KEY não configurada"
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
Configuração OpenAI API com System Prompt
"""

import os
from openai import OpenAI

# Carregar system prompt
SYSTEM_PROMPT = """$PROMPT_CONTENT"""

def get_openai_client():
    """Retorna cliente OpenAI configurado"""
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY não configurada")

    return OpenAI(api_key=api_key)

def chat_with_system_prompt(message, model="gpt-4-turbo-preview"):
    """Envia mensagem com system prompt"""
    client = get_openai_client()

    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": message}
        ],
        temperature=0.7,
        max_tokens=4096
    )

    return response.choices[0].message.content

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
echo "      export OPENAI_API_KEY='sua-chave-aqui'"
echo ""
echo "   2. Instale a biblioteca (se necessário):"
echo "      pip install openai"
echo ""
echo "   3. Use o script Python:"
echo "      python3 $CONFIG_FILE"
echo ""
echo "   4. Ou importe em seu código:"
echo "      from openai_api_config import chat_with_system_prompt"
echo "      response = chat_with_system_prompt('sua mensagem')"
echo ""

