#!/bin/bash
# ==========================================
# Exemplos de Uso - ChatLLM AI Super Assistant
# Versão: 1.0.0
# Data: 2025-12-02
# ==========================================

# Carregar credenciais
source "$(dirname "$0")/../load-abacus-keys.sh"

if [ -z "$ABACUS_API_KEY" ]; then
    echo "❌ ABACUS_API_KEY não definida"
    exit 1
fi

# Função helper para fazer chamadas à API
abacus_chat() {
    local prompt="$1"
    local model="${2:-auto}"

    curl -s -X POST "https://api.abacus.ai/v1/chatllm/chat" \
      -H "Authorization: Bearer ${ABACUS_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "{
        \"prompt\": \"$prompt\",
        \"model\": \"$model\"
      }" | jq -r '.response // .content // .text // .'
}

echo "=========================================="
echo "Exemplos de Uso - ChatLLM"
echo "=========================================="
echo ""

# Exemplo 1: Tradução simples
echo "1. Tradução Simples:"
echo "-------------------"
result=$(abacus_chat "Traduza 'Hello, how are you?' para português")
echo "$result"
echo ""

# Exemplo 2: Geração de código
echo "2. Geração de Código:"
echo "-------------------"
result=$(abacus_chat "Crie uma função Python que calcula o fatorial de um número")
echo "$result"
echo ""

# Exemplo 3: Análise de código
echo "3. Análise de Código:"
echo "-------------------"
code='def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)'
result=$(abacus_chat "Analise este código Python e sugira melhorias de performance: $code" "gpt-4.1")
echo "$result"
echo ""

# Exemplo 4: Roteamento automático
echo "4. Roteamento Automático:"
echo "-------------------"
result=$(abacus_chat "Explique o que é machine learning de forma simples" "auto")
echo "$result"
echo ""

echo "=========================================="
echo "✅ Exemplos concluídos"
echo "=========================================="











