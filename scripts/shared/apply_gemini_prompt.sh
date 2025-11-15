#!/bin/bash

# ============================================
# Script de Aplicação: System Prompt Gemini API
# ============================================
# Configura system instructions para uso com Gemini API
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
CONFIG_FILE="$PROMPT_DIR/configs/gemini_api_config.py"

echo "============================================"
echo "🔧 Configurando Gemini API com System Instructions"
echo "============================================"
echo ""

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado"
    exit 1
fi

# Verificar API key
if [ -z "$GEMINI_API_KEY" ] && [ -z "$GOOGLE_AI_API_KEY" ]; then
    echo "⚠️  Aviso: GEMINI_API_KEY ou GOOGLE_AI_API_KEY não configurada"
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
Configuração Gemini API com System Instructions
"""

import os
import google.generativeai as genai

# Carregar system instructions
SYSTEM_INSTRUCTIONS = """$PROMPT_CONTENT"""

def get_gemini_client():
    """Configura cliente Gemini com API key"""
    api_key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_AI_API_KEY")
    if not api_key:
        raise ValueError("GEMINI_API_KEY ou GOOGLE_AI_API_KEY não configurada")

    genai.configure(api_key=api_key)
    return genai

def chat_with_system_instructions(message, model="gemini-2.0-flash-exp"):
    """Envia mensagem com system instructions"""
    client = get_gemini_client()

    # Criar modelo com system instructions
    model_instance = genai.GenerativeModel(
        model_name=model,
        system_instruction=SYSTEM_INSTRUCTIONS
    )

    # Gerar resposta
    response = model_instance.generate_content(message)

    return response.text

if __name__ == "__main__":
    # Exemplo de uso
    message = input("Digite sua mensagem: ")
    response = chat_with_system_instructions(message)
    print("\nResposta:")
    print(response)
EOF

chmod +x "$CONFIG_FILE"

echo "✅ Configuração criada em: $CONFIG_FILE"
echo ""
echo "📋 Como usar:"
echo "   1. Configure a API key:"
echo "      export GEMINI_API_KEY='sua-chave-aqui'"
echo ""
echo "   2. Instale a biblioteca (se necessário):"
echo "      pip install google-generativeai"
echo ""
echo "   3. Use o script Python:"
echo "      python3 $CONFIG_FILE"
echo ""
echo "   4. Ou importe em seu código:"
echo "      from gemini_api_config import chat_with_system_instructions"
echo "      response = chat_with_system_instructions('sua mensagem')"
echo ""

