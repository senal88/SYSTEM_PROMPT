#!/bin/bash
# ==========================================
# Exemplos de Uso - Deep Agent
# Versão: 1.0.0
# Data: 2025-12-02
# ==========================================

# Carregar credenciais
source "$(dirname "$0")/../load-abacus-keys.sh"

if [ -z "$ABACUS_API_KEY" ]; then
    echo "❌ ABACUS_API_KEY não definida"
    exit 1
fi

echo "=========================================="
echo "Exemplos de Uso - Deep Agent"
echo "=========================================="
echo ""

# Exemplo 1: Pesquisa profunda
echo "1. Pesquisa Profunda:"
echo "-------------------"
response=$(curl -s -X POST "https://api.abacus.ai/v1/deep-agent/research" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Tendências de IA em 2025",
    "depth": "medium",
    "sources": {
      "web": true,
      "news": true
    },
    "output_format": "markdown"
  }')

task_id=$(echo "$response" | jq -r '.task_id // .id // .')
echo "Task ID: $task_id"
echo "Resposta:"
echo "$response" | jq '.' 2>/dev/null || echo "$response"
echo ""

# Exemplo 2: Geração de imagem
echo "2. Geração de Imagem:"
echo "-------------------"
response=$(curl -s -X POST "https://api.abacus.ai/v1/deep-agent/generate-image" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Um robô futurista em uma cidade cyberpunk",
    "model": "dalle",
    "size": "1024x1024"
  }')

task_id=$(echo "$response" | jq -r '.task_id // .id // .')
echo "Task ID: $task_id"
echo "Resposta:"
echo "$response" | jq '.' 2>/dev/null || echo "$response"
echo ""

# Exemplo 3: Criação de apresentação
echo "3. Criação de Apresentação:"
echo "-------------------"
response=$(curl -s -X POST "https://api.abacus.ai/v1/deep-agent/create-presentation" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Introdução ao Machine Learning",
    "slides": 5,
    "format": "powerpoint",
    "style": "professional"
  }')

task_id=$(echo "$response" | jq -r '.task_id // .id // .')
echo "Task ID: $task_id"
echo "Resposta:"
echo "$response" | jq '.' 2>/dev/null || echo "$response"
echo ""

echo "=========================================="
echo "✅ Exemplos concluídos"
echo "=========================================="
echo ""
echo "Nota: As tarefas do Deep Agent são assíncronas."
echo "Use o task_id para verificar o status:"
echo "curl -X GET \"https://api.abacus.ai/v1/deep-agent/tasks/$task_id/status\" \\"
echo "  -H \"Authorization: Bearer \${ABACUS_API_KEY}\""











