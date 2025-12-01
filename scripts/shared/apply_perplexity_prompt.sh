#!/bin/bash

# ============================================
# Script de Aplicação: System Prompt no Perplexity Pro
# ============================================
# Gera instruções para configurar Custom Instructions
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
OUTPUT_FILE="$PROMPT_DIR/configs/perplexity_custom_instructions.txt"

echo "============================================"
echo "🔧 Gerando Instruções para Perplexity Pro"
echo "============================================"
echo ""

# Verificar se o prompt global existe
if [ ! -f "$GLOBAL_PROMPT" ]; then
    echo "❌ Erro: Arquivo system_prompt_global.txt não encontrado"
    exit 1
fi

# Criar diretório de configs se não existir
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Ler prompt global e adaptar para Perplexity
cat > "$OUTPUT_FILE" << EOF
# ============================================
# Custom Instructions para Perplexity Pro
# ============================================
#
# Como usar:
# 1. Acesse https://www.perplexity.ai/
# 2. Faça login na sua conta Pro
# 3. Clique em "Settings" ou "Preferences"
# 4. Localize "Custom Instructions" ou "System Prompt"
# 5. Cole o conteúdo abaixo
# 6. Salve as alterações
#
# ============================================

EOF

# Adicionar conteúdo do prompt global
cat "$GLOBAL_PROMPT" >> "$OUTPUT_FILE"

# Adicionar instruções específicas do Perplexity
cat >> "$OUTPUT_FILE" << EOF

# ============================================
# Instruções Adicionais para Perplexity Pro
# ============================================

- Priorize fontes confiáveis e atualizadas
- Inclua referências quando possível
- Forneça respostas baseadas em evidências
- Mantenha foco em precisão e relevância
- Cite fontes quando apropriado

EOF

echo "✅ Instruções geradas em: $OUTPUT_FILE"
echo ""
echo "📋 Próximos passos:"
echo "   1. Abra o arquivo: $OUTPUT_FILE"
echo "   2. Copie o conteúdo"
echo "   3. Acesse: https://www.perplexity.ai/"
echo "   4. Configure Custom Instructions nas configurações"
echo "   5. Cole o conteúdo e salve"
echo ""

