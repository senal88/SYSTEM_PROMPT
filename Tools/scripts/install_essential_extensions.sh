#!/bin/bash

# Script para instalação gradual de extensões essenciais do VS Code
# Baseado nas premissas de configuração cuidadosa macOS Tahoe 26.0.1
# Autor: Configuração personalizada
# Data: $(date)

echo "🚀 Instalação de Extensões Essenciais VS Code - macOS Tahoe 26.0.1"
echo "Seguindo abordagem gradual e com melhores práticas"
echo ""

# Verificar se VS Code está instalado
if ! command -v code &> /dev/null; then
    echo "❌ VS Code não encontrado. Instale primeiro:"
    echo "brew install --cask visual-studio-code"
    exit 1
fi

# Função para instalar extensão com confirmação
install_extension() {
    local extension_id=$1
    local extension_name=$2
    local phase=$3
    
    echo "📦 Fase $phase: $extension_name"
    echo "   ID: $extension_id"
    read -r -n 1 -p "   Instalar? (y/n): "
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   Instalando..."
        code --install-extension "$extension_id"
        echo "   ✅ Instalado: $extension_name"
    else
        echo "   ⏭️  Pulado: $extension_name"
    fi
    echo ""
}

# FASE 1: FUNDAÇÕES BÁSICAS
echo "🔥 FASE 1: FUNDAÇÕES BÁSICAS"
echo "Essenciais para começar com segurança"
echo ""

install_extension "GitHub.copilot" "GitHub Copilot" "1"
install_extension "eamodio.gitlens" "GitLens" "1" 
install_extension "ms-python.python" "Python" "1"

echo "⏸️  PAUSA RECOMENDADA"
echo "Configure e teste as extensões da Fase 1 antes de continuar"
read -r -p "Pressione Enter para continuar ou Ctrl+C para parar..."
echo ""

# FASE 2: ORGANIZAÇÃO E SEGURANÇA  
echo "🛡️ FASE 2: ORGANIZAÇÃO E SEGURANÇA"
echo "Para manter arquivos .env e estrutura organizadas"
echo ""

install_extension "mikestead.dotenv" "DotENV" "2"
install_extension "aaron-bond.better-comments" "Better Comments" "2"
install_extension "christian-kohler.path-intellisense" "Path Intellisense" "2"

echo "⏸️  PAUSA RECOMENDADA"
echo "Organize seus arquivos .env e teste os caminhos"
read -r -p "Pressione Enter para continuar ou Ctrl+C para parar..."
echo ""

# FASE 3: PRODUTIVIDADE COM IA
echo "🤖 FASE 3: PRODUTIVIDADE COM IA"
echo "Apenas quando dominar as ferramentas básicas"
echo ""

install_extension "GitHub.copilot-chat" "GitHub Copilot Chat" "3"

# Verificar se Cursor já está instalado
if command -v cursor &> /dev/null; then
    echo "✅ Cursor já detectado no sistema"
else
    echo "💡 Considere instalar Cursor separadamente se ainda não tiver"
fi

echo "⏸️  PAUSA RECOMENDADA" 
echo "Pratique com Copilot Chat e entenda bem como funciona"
read -r -p "Pressione Enter para continuar ou Ctrl+C para parar..."
echo ""

# FASE 4: QUALIDADE DE CÓDIGO
echo "✨ FASE 4: QUALIDADE DE CÓDIGO"
echo "Apenas quando estiver confiante com o workflow"
echo ""

install_extension "esbenp.prettier-vscode" "Prettier" "4"
install_extension "dbaeumer.vscode-eslint" "ESLint" "4"

echo "⏸️  PAUSA RECOMENDADA"
echo "Configure Prettier e ESLint por projeto, não globalmente"
read -r -p "Pressione Enter para continuar ou Ctrl+C para parar..."
echo ""

# FASE 5: SEGURANÇA (OPCIONAL)
echo "🔒 FASE 5: SEGURANÇA (OPCIONAL)"
echo "Instalar apenas quando necessário"
echo ""

install_extension "SonarSource.sonarlint-vscode" "SonarLint" "5"
install_extension "rangav.vscode-thunder-client" "Thunder Client" "5"

echo ""
echo "✅ INSTALAÇÃO CONCLUÍDA!"
echo ""
echo "📋 PRÓXIMOS PASSOS RECOMENDADOS:"
echo "1. Reinicie o VS Code"
echo "2. Configure cada extensão gradualmente"
echo "3. Teste em projeto pequeno antes de usar em projetos importantes"
echo "4. Leia a documentação de cada extensão"
echo "5. Configure apenas o que você entende"
echo ""
echo "🚨 LEMBRE-SE:"
echo "- Não configure tudo de uma vez"
echo "- Entenda cada ferramenta antes de automatizar"
echo "- Mantenha .env e arquivos sensíveis seguros"
echo "- Teste localmente antes de fazer deploy para VPS"
echo ""
echo "📖 Base de conhecimento disponível em:"
echo "$HOME/MacOS_Tahoe_26.0.1/ativos_perplexity_1/macos_tahoe_knowledge_base.json"