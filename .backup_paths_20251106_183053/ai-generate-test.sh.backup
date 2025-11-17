#!/bin/bash

# @raycast.title IA: Gerar Testes
# @raycast.description Gera testes unitários para função usando IA
# @raycast.mode fullOutput
# @raycast.icon 🧪
# @raycast.argument1 { "type": "text", "placeholder": "Código da função" }
# @raycast.argument2 { "type": "dropdown", "placeholder": "Framework", "data": "[\"Jest\", \"Vitest\", \"Mocha\", \"JUnit\", \"Pytest\", \"RSpec\", \"XCTest\"]" }
# @raycast.argument3 { "type": "dropdown", "placeholder": "Provedor IA", "data": "[\"Auto\", \"Ollama (Local)\", \"HuggingFace\", \"OpenAI\", \"Gemini\"]" }

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
CODE_MODEL=${CODE_MODEL:-"codellama"}

# Parâmetros
FUNCTION_CODE="$1"
TEST_FRAMEWORK="${2:-Jest}"
PROVIDER="${3:-Auto}"

# Detectar linguagem de programação
detect_language() {
    local code="$1"
    
    if echo "$code" | grep -q "function\|const.*=\|let.*=" && echo "$code" | grep -q "console.log\|return"; then
        echo "javascript"
    elif echo "$code" | grep -q "def\|class\|import\|from"; then
        echo "python"
    elif echo "$code" | grep -q "public.*class\|private.*\|System.out"; then
        echo "java"
    elif echo "$code" | grep -q "func\|package\|import"; then
        echo "go"
    elif echo "$code" | grep -q "fn\|let\|mut"; then
        echo "rust"
    elif echo "$code" | grep -q "func.*{\|var\|let"; then
        echo "swift"
    else
        echo "javascript" # default
    fi
}

# Gerar prompt baseado na linguagem e framework
generate_prompt() {
    local code="$1"
    local framework="$2"
    local language="$3"
    
    cat << EOF
Você é um especialista em testes unitários. Gere testes completos e abrangentes para a seguinte função usando $framework.

**Linguagem**: $language
**Framework**: $framework

**Código da função**:
\`\`\`$language
$code
\`\`\`

**Requisitos**:
1. **Casos de teste básicos**: Teste o comportamento normal da função
2. **Casos extremos**: Valores limite, null/undefined, strings vazias
3. **Casos de erro**: Entradas inválidas, exceções esperadas
4. **Cobertura completa**: Teste todos os caminhos possíveis
5. **Mocking**: Use mocks quando necessário para dependências externas
6. **Assertions claras**: Use assertions descritivas e específicas

**Formato de saída**:
- Use a sintaxe correta do $framework para $language
- Inclua comentários explicativos
- Organize os testes de forma lógica
- Use nomes descritivos para os testes

Gere apenas o código dos testes, sem explicações adicionais.
EOF
}

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
                \"temperature\": 0.2,
                \"num_predict\": 3000
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
                \"temperature\": 0.2,
                \"max_new_tokens\": 3000,
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
                {\"role\": \"system\", \"content\": \"Você é um especialista em testes unitários.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.2,
            \"max_tokens\": 3000
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
                \"temperature\": 0.2,
                \"maxOutputTokens\": 3000
            }
        }" | jq -r '.candidates[0].content.parts[0].text'
}

# Verificar se o código foi fornecido
if [ -z "$FUNCTION_CODE" ]; then
    echo "❌ Por favor, forneça o código da função para testar"
    exit 1
fi

# Detectar linguagem
LANGUAGE=$(detect_language "$FUNCTION_CODE")

echo "🔍 Analisando código..."
echo "📝 Linguagem detectada: $LANGUAGE"
echo "🧪 Framework de teste: $TEST_FRAMEWORK"
echo "🤖 Provedor IA: $PROVIDER"
echo ""

# Gerar prompt
PROMPT=$(generate_prompt "$FUNCTION_CODE" "$TEST_FRAMEWORK" "$LANGUAGE")

echo "🤖 Gerando testes..."
echo ""

# Executar baseado no provedor selecionado
case "$PROVIDER" in
    "Ollama (Local)")
        echo "🤖 Usando Ollama (CodeLlama)..."
        if curl -s "$OLLAMA_HOST/api/tags" > /dev/null 2>&1; then
            RESULT=$(call_ollama "$CODE_MODEL" "$PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Testes gerados com sucesso!"
                echo ""
                echo "```$LANGUAGE"
                echo "$RESULT"
                echo "```"
                exit 0
            fi
        fi
        echo "❌ Ollama não disponível"
        ;;
    
    "HuggingFace")
        echo "🌐 Usando Hugging Face..."
        RESULT=$(call_huggingface "$PROMPT")
        if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
            echo "✅ Testes gerados com sucesso!"
            echo ""
            echo "```$LANGUAGE"
            echo "$RESULT"
            echo "```"
            exit 0
        fi
        echo "❌ Hugging Face falhou"
        ;;
    
    "OpenAI")
        echo "☁️ Usando OpenAI..."
        RESULT=$(call_openai "$PROMPT")
        if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
            echo "✅ Testes gerados com sucesso!"
            echo ""
            echo "```$LANGUAGE"
            echo "$RESULT"
            echo "```"
            exit 0
        fi
        echo "❌ OpenAI falhou"
        ;;
    
    "Gemini")
        echo "🔮 Usando Gemini..."
        RESULT=$(call_gemini "$PROMPT")
        if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
            echo "✅ Testes gerados com sucesso!"
            echo ""
            echo "```$LANGUAGE"
            echo "$RESULT"
            echo "```"
            exit 0
        fi
        echo "❌ Gemini falhou"
        ;;
    
    "Auto")
        echo "🔄 Modo automático - tentando provedores em ordem..."
        
        # Tentar Ollama primeiro (especializado em código)
        if curl -s "$OLLAMA_HOST/api/tags" > /dev/null 2>&1; then
            RESULT=$(call_ollama "$CODE_MODEL" "$PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Testes gerados usando Ollama ($CODE_MODEL)"
                echo ""
                echo "```$LANGUAGE"
                echo "$RESULT"
                echo "```"
                exit 0
            fi
        fi
        
        # Tentar Hugging Face
        if [ -n "$HUGGINGFACE_API_KEY" ]; then
            RESULT=$(call_huggingface "$PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Testes gerados usando Hugging Face"
                echo ""
                echo "```$LANGUAGE"
                echo "$RESULT"
                echo "```"
                exit 0
            fi
        fi
        
        # Tentar OpenAI
        if [ -n "$OPENAI_API_KEY" ]; then
            RESULT=$(call_openai "$PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Testes gerados usando OpenAI"
                echo ""
                echo "```$LANGUAGE"
                echo "$RESULT"
                echo "```"
                exit 0
            fi
        fi
        
        # Tentar Gemini
        if [ -n "$GEMINI_API_KEY" ]; then
            RESULT=$(call_gemini "$PROMPT")
            if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
                echo "✅ Testes gerados usando Gemini"
                echo ""
                echo "```$LANGUAGE"
                echo "$RESULT"
                echo "```"
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

