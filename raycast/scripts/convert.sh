#!/bin/bash

# Required parameters:
# @raycast.title Converter Arquivo (Stirling-PDF)
# @raycast.author Luiz Sena
# @raycast.authorURL https://github.com/luizsena88
# @raycast.description Converte o arquivo selecionado no Finder para PDF usando Stirling-PDF
# @raycast.mode full
# @raycast.packageName Stirling-PDF
# @raycast.icon 🤖

# @raycast.argument1 { "type": "text", "placeholder": "Formato (pdf, jpg, png, etc.)", "optional": true }

# --- Configuração ---
PROJECT_DIR="/Users/luiz.sena88/Projetos/stirling-pdf"
CLI_SCRIPT="$PROJECT_DIR/stirling-cli.sh"
STIRLING_URL="http://localhost:8081"

# Função para verificar se Stirling-PDF está rodando
check_stirling() {
    if ! curl -s "$STIRLING_URL" > /dev/null 2>&1; then
        echo "❌ Stirling-PDF não está rodando em $STIRLING_URL"
        echo "💡 Execute: cd $PROJECT_DIR && ./stirling-control.sh start"
        exit 1
    fi
}

# Função para obter arquivo selecionado no Finder
get_selected_file() {
    osascript <<EOF
tell application "Finder"
    try
        set theSelection to selection
        if theSelection is not {} then
            return POSIX path of (theSelection as alias)
        else
            return ""
        end if
    on error
        return ""
    end try
end tell
EOF
}

# Função para abrir arquivo convertido
open_converted_file() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        open "$file_path"
        echo "📂 Arquivo convertido aberto: $(basename "$file_path")"
    fi
}

# --- Execução Principal ---

echo "🚀 Stirling-PDF Raycast Integration"
echo "=================================="

# 1. Verificar se Stirling-PDF está rodando
echo "🔍 Verificando Stirling-PDF..."
check_stirling
echo "✅ Stirling-PDF está ativo"

# 2. Obter arquivo selecionado no Finder
echo "📂 Obtendo arquivo selecionado..."
selected_file=$(get_selected_file)

if [ -z "$selected_file" ]; then
    echo "❌ Nenhum arquivo selecionado no Finder"
    echo "💡 Selecione um arquivo no Finder e execute novamente"
    exit 1
fi

echo "📄 Arquivo selecionado: $(basename "$selected_file")"

# 3. Determinar formato de destino
format="${1:-pdf}"
echo "🎯 Formato de destino: $format"

# 4. Navegar para o diretório do projeto
cd "$PROJECT_DIR"

# 5. Executar conversão
echo "⚙️ Executando conversão..."
if [ -f "$CLI_SCRIPT" ]; then
    ./stirling-cli.sh converter "$selected_file" para "$format"
    conversion_result=$?
else
    echo "❌ Script stirling-cli.sh não encontrado"
    echo "💡 Verifique se o arquivo existe em: $CLI_SCRIPT"
    exit 1
fi

# 6. Verificar resultado e abrir arquivo
if [ $conversion_result -eq 0 ]; then
    echo "✅ Conversão concluída com sucesso!"
    
    # Tentar abrir o arquivo convertido
    base_name=$(basename "$selected_file" | sed 's/\.[^.]*$//')
    converted_file="$PROJECT_DIR/pipeline/watchedFolders/output/${base_name}.${format}"
    
    if [ -f "$converted_file" ]; then
        open_converted_file "$converted_file"
    else
        echo "📁 Arquivo convertido pode estar em: $PROJECT_DIR/pipeline/watchedFolders/output/"
    fi
else
    echo "❌ Erro na conversão"
    echo "💡 Verifique os logs em: $PROJECT_DIR/logs/"
fi

echo "🏁 Operação finalizada"