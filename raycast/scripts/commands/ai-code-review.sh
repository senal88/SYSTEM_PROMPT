#!/bin/bash

# @raycast.title IA: Revisar Código
# @raycast.description Revisa código selecionado usando IA (Ollama/HuggingFace/OpenAI)
# @raycast.mode fullOutput
# @raycast.icon 🔍
# @raycast.argument1 { "type": "text", "placeholder": "Código para revisar" }
# @raycast.argument2 { "type": "dropdown", "placeholder": "Provedor IA", "data": "[\"Ollama (Local)\", \"HuggingFace\", \"OpenAI\", \"Gemini\", \"Auto\"]" }

# Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAYCAST_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
CONFIG_DIR="$RAYCAST_DIR/config"

# Carregar configurações
if [ -f "$CONFIG_DIR/ai-config.env" ]; then
    source "$CONFIG_DIR/ai-config.env"
fi

# Configurações padrão
OLLAMA_HOST=${OLLAMA_HOST:-"http://localhost:11434"}
DEFAULT_MODEL=${DEFAULT_MODEL:-"llama3"}
CODE_MODEL=${CODE_MODEL:-"codellama"}

# Parâmetros
CODE="$1"
PROVIDER="${2:-Auto}"

# Prompt para revisão de código (usando template do seu sistema)
REVIEW_PROMPT="Você é um revisor de código experiente. Analise o seguinte código e forneça:

1. **Qualidade Geral**: Avalie a legibilidade, estrutura e organização
2. **Bugs Potenciais**: Identifique possíveis erros ou problemas
3. **Performance**: Sugestões de otimização
4. **Segurança**: Vulnerabilidades de segurança
5. **Melhores Práticas**: Sugestões para seguir padrões da indústria
6. **Refatoração**: Sugestões de melhoria

Código para revisar:
\`\`\`
$CODE
\`\`\`

Responda em formato estruturado e seja específico com exemplos de código quando necessário."

# Função para chamar Ollama
call_ollama() {
    local model="$1"
    local prompt="$2"
    
    curl -s "$OLLAMA_HOST/api/generate" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"$model\",
            \"prompt\": \"$prompt\",
            \"stream\": false,
            \"options\": {
                \"temperature\": 0.3,
                \"num_predict\": 2000
            }
        }" | jq -r '.response'
}

# Função para chamar Hugging Face
call_huggingface() {
    local prompt="$1"
    
    if [ -z "$HUGGINGFACE_API_KEY" ]; then
        echo "❌ Hugging Face API key não configurada"
        return 1
    fi
    
    curl -s "https://api-inference.huggingface.co/models/meta-llama/Meta-Llama-3-8B-Instruct" \
        -X POST \
        -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"inputs\": \"$prompt\",
            \"parameters\": {
                \"temperature\": 0.3,
                \"max_new_tokens\": 2000,
                \"return_full_text\": false
            }
        }" | jq -r '.[0].generated_text'
}

# Função para chamar OpenAI
call_openai() {
    local prompt="$1"
    
    if [ -z "$OPENAI_API_KEY" ]; then
        echo "❌ OpenAI API key não configurada"
        return 1
    fi
    
    curl -s "https://api.openai.com/v1/chat/completions" \
        -X POST \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"gpt-3.5-turbo\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Você é um revisor de código experiente.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.3,
            \"max_tokens\": 2000
        }" | jq -r '.choices[0].message.content'
}

# Função para chamar Gemini
call_gemini() {
    local prompt="$1"
    
    if [ -z "$GEMINI_API_KEY" ]; then
        echo "❌ Gemini API key não configurada"
        return 1
    fi
    
    curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$GEMINI_API_KEY" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "{
            \"contents\": [
                {
                    \"role\": \"user\",
                    \"parts\": [{\"text\": \"$prompt\"}]
                }
            ],
            \"generationConfig\": {
                \"temperature\": 0.3,
                \"maxOutputTokens\": 2000
            }
        }" | jq -r '.candidates[0].content.parts[0].text'
}

# Verificar se o código foi fornecido
if [ -z "$CODE" ]; then
    echo "❌ Por favor, forneça o código para revisar"
    exit 1
fi

echo "🔍 Iniciando revisão de código com IA..."
echo "🤖 Provedor selecionado: $PROVIDER"
echo ""

# Executar baseado no provedor selecionado
case "$PROVIDER" in
    "Ollama (Local)")
        echo "🤖 Usando Ollama (modelo local)..."
        if curl -s "$OLLAMA_HOST/api/tags" > /dev/null 2>&1; then
            RESULT=$(call_ollama "$CODE_MODEL" "$REVIEW_PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Revisão concluída usando Ollama ($CODE_MODEL)"
                echo ""
                echo "$RESULT"
                exit 0
            fi
        fi
        echo "❌ Ollama não disponível"
        ;;
    
    "HuggingFace")
        echo "🌐 Usando Hugging Face..."
        RESULT=$(call_huggingface "$REVIEW_PROMPT")
        if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
            echo "✅ Revisão concluída usando Hugging Face"
            echo ""
            echo "$RESULT"
            exit 0
        fi
        echo "❌ Hugging Face falhou"
        ;;
    
    "OpenAI")
        echo "☁️ Usando OpenAI..."
        RESULT=$(call_openai "$REVIEW_PROMPT")
        if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
            echo "✅ Revisão concluída usando OpenAI"
            echo ""
            echo "$RESULT"
            exit 0
        fi
        echo "❌ OpenAI falhou"
        ;;
    
    "Gemini")
        echo "🔮 Usando Gemini..."
        RESULT=$(call_gemini "$REVIEW_PROMPT")
        if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
            echo "✅ Revisão concluída usando Gemini"
            echo ""
            echo "$RESULT"
            exit 0
        fi
        echo "❌ Gemini falhou"
        ;;
    
    "Auto")
        echo "🔄 Modo automático - tentando provedores em ordem..."
        
        # Tentar Ollama primeiro (local)
        if curl -s "$OLLAMA_HOST/api/tags" > /dev/null 2>&1; then
            RESULT=$(call_ollama "$CODE_MODEL" "$REVIEW_PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Revisão concluída usando Ollama ($CODE_MODEL)"
                echo ""
                echo "$RESULT"
                exit 0
            fi
        fi
        
        # Tentar Hugging Face
        if [ -n "$HUGGINGFACE_API_KEY" ]; then
            RESULT=$(call_huggingface "$REVIEW_PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Revisão concluída usando Hugging Face"
                echo ""
                echo "$RESULT"
                exit 0
            fi
        fi
        
        # Tentar OpenAI
        if [ -n "$OPENAI_API_KEY" ]; then
            RESULT=$(call_openai "$REVIEW_PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Revisão concluída usando OpenAI"
                echo ""
                echo "$RESULT"
                exit 0
            fi
        fi
        
        # Tentar Gemini
        if [ -n "$GEMINI_API_KEY" ]; then
            RESULT=$(call_gemini "$REVIEW_PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Revisão concluída usando Gemini"
                echo ""
                echo "$RESULT"
                exit 0
            fi
        fi
        
        echo "❌ Todos os provedores falharam"
        ;;
esac

echo ""
echo "🔧 Verificações necessárias:"
echo "   - Ollama: brew services start ollama && ollama pull codellama"
echo "   - API Keys: Configure em $CONFIG_DIR/ai-config.env"
echo "   - Conexão: Verifique sua conexão com a internet"
exit 1

