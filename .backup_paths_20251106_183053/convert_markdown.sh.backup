#!/bin/bash

# Required parameters:
# @raycast.title Converter Markdown para PDF
# @raycast.author Luiz Sena
# @raycast.authorURL https://github.com/luizsena88
# @raycast.description Converte arquivo Markdown selecionado para PDF via TableConvert + Stirling-PDF
# @raycast.mode full
# @raycast.packageName Stirling-PDF
# @raycast.icon 📊

# --- Configuração ---
PROJECT_DIR="/Users/luiz.sena88/Projetos/stirling-pdf"
TABLECONVERT_SCRIPT="$PROJECT_DIR/tableconvert/scripts/convert_markdown_json_local.sh"
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

# --- Execução Principal ---

echo "📊 TableConvert + Stirling-PDF Integration"
echo "========================================="

# 1. Verificar se Stirling-PDF está rodando
echo "🔍 Verificando Stirling-PDF..."
check_stirling
echo "✅ Stirling-PDF está ativo"

# 2. Obter arquivo selecionado no Finder
echo "📂 Obtendo arquivo Markdown selecionado..."
selected_file=$(get_selected_file)

if [ -z "$selected_file" ]; then
    echo "❌ Nenhum arquivo selecionado no Finder"
    echo "💡 Selecione um arquivo .md no Finder e execute novamente"
    exit 1
fi

# 3. Verificar se é arquivo Markdown
if [[ ! "$selected_file" =~ \.(md|markdown)$ ]]; then
    echo "❌ Arquivo não é Markdown (.md ou .markdown)"
    echo "📄 Arquivo selecionado: $(basename "$selected_file")"
    exit 1
fi

echo "📄 Arquivo Markdown selecionado: $(basename "$selected_file")"

# 4. Navegar para o diretório do projeto
cd "$PROJECT_DIR"

# 5. Executar conversão Markdown → JSON → HTML → PDF
echo "⚙️ Executando conversão Markdown → PDF..."
if [ -f "$TABLECONVERT_SCRIPT" ]; then
    bash "$TABLECONVERT_SCRIPT" "$selected_file"
    conversion_result=$?
else
    echo "❌ Script TableConvert não encontrado"
    echo "💡 Verifique se o arquivo existe em: $TABLECONVERT_SCRIPT"
    exit 1
fi

# 6. Verificar resultado
if [ $conversion_result -eq 0 ]; then
    echo "✅ Conversão concluída com sucesso!"
    
    # Tentar abrir o arquivo HTML gerado
    base_name=$(basename "$selected_file" | sed 's/\.[^.]*$//')
    html_file="$PROJECT_DIR/pipeline/watchedFolders/input/${base_name}.html"
    
    if [ -f "$html_file" ]; then
        echo "📄 HTML gerado: $(basename "$html_file")"
        echo "💡 Use a GUI do Stirling-PDF para converter HTML → PDF:"
        echo "   $STIRLING_URL"
        
        # Abrir GUI do Stirling-PDF
        open "$STIRLING_URL"
    fi
else
    echo "❌ Erro na conversão"
    echo "💡 Verifique os logs em: $PROJECT_DIR/tableconvert/logs/"
fi

echo "🏁 Operação finalizada"
