#!/bin/bash

# MAPA VISUAL DA ARQUITETURA - macOS Tahoe 26.0.1
# Mostra onde estão os arquivos após a limpeza

echo "🏗️ MAPA VISUAL DA ARQUITETURA ATUAL"
echo "=================================="
echo ""

echo "📁 ESTRUTURA DE PASTAS PRINCIPAL:"
echo ""
echo "🏠 HOME ($HOME):"
echo "├── 📂 Documents/                    [VAZIA - 0B] ❌ NÃO USAR"
echo "├── 📂 Documents_Local_Secure/       [NOVA - 0B] ✅ USAR PARA DOCS"
echo "│   ├── 💰 Financeiro/"
echo "│   ├── 👤 Pessoal/"
echo "│   └── ⏱️  Temporario/"
echo "├── 📂 Git_Repos_Local/              [NOVA - 7.0M] ✅ USAR PARA GIT"
echo "│   ├── 📁 Documents/ (repos movidos)"
echo "│   └── 📁 setup-vidas/"
echo "├── 📂 Documents_Backup_*/           [BACKUP - 8.0K] 💾 SEGURANÇA"
echo "└── 📄 .icloud_exclusions_permanent  [CONFIG] 🛡️ PROTEÇÃO"
echo ""

echo "☁️ iCLOUD DRIVE:"
echo "$HOME/Library/Mobile Documents/com~apple~CloudDocs/ [4.1M]"
echo "├── ❌ [SEM LINK DOCUMENTS] ✅ REMOVIDO"
echo "├── 📂 export_documents/"
echo "└── 📂 [outros arquivos normais do iCloud]"
echo ""

echo "📊 COMPARAÇÃO ANTES vs DEPOIS:"
echo ""
printf "%-25s %-15s %-15s %-15s\n" "LOCAL" "ANTES" "DEPOIS" "STATUS"
echo "────────────────────────────────────────────────────────────"
printf "%-25s %-15s %-15s %-15s\n" "$HOME/Documents" "8.4M" "0B" "✅ LIMPO"
printf "%-25s %-15s %-15s %-15s\n" "iCloud Drive" "3.4M" "4.1M" "✅ SEM LINK"
printf "%-25s %-15s %-15s %-15s\n" "Repos Git" "100+" "0" "✅ MOVIDOS"
printf "%-25s %-15s %-15s %-15s\n" "Pastas duplicadas" "181+" "0" "✅ ELIMINADAS"
echo ""

echo "🎯 REGRAS DE USO:"
echo ""
echo "✅ SEMPRE USE:"
echo "   📂 $HOME/Documents_Local_Secure/    → Para documentos importantes"
echo "   📂 $HOME/Git_Repos_Local/           → Para repositórios Git"
echo "   💾 Time Machine                 → Para backup automático"
echo ""
echo "❌ NUNCA USE:"
echo "   📂 $HOME/Documents/                 → Manter vazio (não sincroniza)"
echo "   ☁️ iCloud para .git/            → Repositórios locais apenas"
echo "   ☁️ iCloud para .env             → Dados sensíveis locais"
echo ""

echo "🔧 VERIFICAÇÕES IMPORTANTES:"
echo ""

# Verificar se Documents está vazio
mapfile -t docs_items < <(find "$HOME/Documents" -mindepth 1 -maxdepth 1 2>/dev/null)
DOCS_COUNT=${#docs_items[@]}
if [ "$DOCS_COUNT" -eq 0 ]; then
    echo "✅ $HOME/Documents está vazio (correto)"
else
    echo "⚠️ $HOME/Documents tem $DOCS_COUNT itens (verificar!)"
fi

# Verificar se link iCloud foi removido
if [ ! -L "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" ]; then
    echo "✅ Link iCloud removido (correto)"
else
    echo "❌ Link iCloud ainda existe (PROBLEMA!)"
fi

# Verificar configuração Desktop/Documents
DESKTOP_DOCS=$(defaults read "$HOME/Library/Preferences/com.apple.bird.plist" "icloud-drive.desktop-and-documents-enabled" 2>/dev/null || echo "não configurado")
if [ "$DESKTOP_DOCS" = "0" ]; then
    echo "✅ Sincronização Desktop/Documents desativada (correto)"
else
    echo "⚠️ Sincronização Desktop/Documents: $DESKTOP_DOCS (verificar!)"
fi

echo ""
echo "📋 PRÓXIMAS AÇÕES RECOMENDADAS:"
echo "1. Reiniciar o sistema se ainda não reiniciou"
echo "2. Mover documentos importantes para ~/Documents_Local_Secure/"
echo "3. Configurar Time Machine para backup das novas pastas"
echo "4. Testar criação de arquivos na nova estrutura"
echo ""
echo "🚨 LEMBRETE: Sua pasta Documents não sincroniza mais com iCloud!"
echo "Use ~/Documents_Local_Secure/ para documentos importantes."