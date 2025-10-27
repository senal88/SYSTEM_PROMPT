#!/bin/bash

echo "🔍 VALIDAÇÃO DA ORGANIZAÇÃO DO REPOSITÓRIO 1PASSWORD"
echo "=================================================="

# Verificar estrutura de pastas
echo "📁 Verificando estrutura de pastas..."
required_dirs=("docs" "scripts" "configs" "extensions" "archives")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ Pasta $dir existe"
    else
        echo "❌ Pasta $dir NÃO existe"
    fi
done

echo ""
echo "📄 Verificando arquivos essenciais..."

# Verificar arquivos de documentação
echo "📚 Documentação:"
docs_files=("docs/README.md" "docs/AGENT_EXPERT_1PASSWORD.md" "docs/1. Visão Geral.md")
for file in "${docs_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file NÃO encontrado"
    fi
done

# Verificar scripts
echo ""
echo "🔧 Scripts:"
scripts_files=("scripts/init_1password_macos.sh" "scripts/init_1password_ubuntu.sh" "scripts/inject_secrets_macos.sh" "scripts/inject_secrets_ubuntu.sh")
for file in "${scripts_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file NÃO encontrado"
    fi
done

# Verificar configurações
echo ""
echo "⚙️ Configurações:"
configs_files=("configs/1password_automation_complete.json" "configs/1password-credentials.json" "configs/template.env.op")
for file in "${configs_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file NÃO encontrado"
    fi
done

# Verificar extensão
echo ""
echo "🔌 Extensões:"
if [ -d "extensions/op-vscode" ]; then
    echo "✅ Extensão op-vscode existe"
else
    echo "❌ Extensão op-vscode NÃO encontrada"
fi

# Verificar se não há duplicatas
echo ""
echo "🔍 Verificando duplicatas..."
duplicate_count=$(find . -name "*.json" -o -name "*.md" -o -name "*.sh" | sort | uniq -d | wc -l)
if [ "$duplicate_count" -eq 0 ]; then
    echo "✅ Nenhuma duplicata encontrada"
else
    echo "❌ $duplicate_count duplicatas encontradas"
fi

# Contar arquivos por categoria
echo ""
echo "📊 Estatísticas:"
echo "📚 Documentos: $(find docs -type f | wc -l)"
echo "🔧 Scripts: $(find scripts -type f | wc -l)"
echo "⚙️ Configurações: $(find configs -type f | wc -l)"
echo "🔌 Extensões: $(find extensions -type f | wc -l)"
echo "📦 Arquivos: $(find archives -type f | wc -l)"

echo ""
echo "🎯 ORGANIZAÇÃO CONCLUÍDA COM SUCESSO!"
echo "📋 Próximos passos:"
echo "   1. Leia a documentação em docs/"
echo "   2. Configure as credenciais em configs/"
echo "   3. Execute os scripts em scripts/"
echo "   4. Valide o ambiente antes de finalizar"
