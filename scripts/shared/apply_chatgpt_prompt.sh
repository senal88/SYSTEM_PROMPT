#!/bin/bash

# ============================================
# Script de Aplicação: System Prompt no ChatGPT Plus
# ============================================
# Gera instruções para configurar Custom Instructions
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
OUTPUT_FILE="$PROMPT_DIR/configs/chatgpt_custom_instructions.txt"

echo "============================================"
echo "🔧 Gerando Instruções para ChatGPT Plus"
echo "============================================"
echo ""

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado"
    exit 1
fi

# Criar diretório de configs se não existir
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Ler prompt global e adaptar para ChatGPT
cat > "$OUTPUT_FILE" << EOF
# ============================================
# Custom Instructions para ChatGPT Plus
# ============================================
#
# Como usar:
# 1. Acesse https://chat.openai.com/
# 2. Clique em seu perfil (canto inferior esquerdo)
# 3. Selecione "Custom instructions"
# 4. Cole o conteúdo abaixo no campo "How would you like ChatGPT to respond?"
# 5. Salve as alterações
#
# ============================================

EOF

# Adicionar conteúdo do prompt global
cat "$GLOBAL_PROMPT" >> "$OUTPUT_FILE"

# Adicionar instruções específicas do ChatGPT
cat >> "$OUTPUT_FILE" << EOF

# ============================================
# Instruções Adicionais para ChatGPT Plus
# ============================================

- Use formatação Markdown para melhorar a legibilidade
- Inclua exemplos de código quando apropriado
- Forneça explicações técnicas detalhadas
- Mantenha respostas objetivas e diretas
- Evite redundâncias e informações desnecessárias

EOF

echo "✅ Instruções geradas em: $OUTPUT_FILE"
echo ""
echo "📋 Próximos passos:"
echo "   1. Abra o arquivo: $OUTPUT_FILE"
echo "   2. Copie o conteúdo"
echo "   3. Acesse: https://chat.openai.com/"
echo "   4. Vá em: Perfil → Custom instructions"
echo "   5. Cole o conteúdo e salve"
echo ""

