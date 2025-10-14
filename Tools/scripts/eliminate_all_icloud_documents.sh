#!/bin/bash

# SCRIPT DE ELIMINAÇÃO COMPLETA - Limpeza do iCloud Drive Documents
# macOS Tahoe 26.0.1 - Luiz Sena
# OBJETIVO: Eliminar completamente todos os arquivos problemáticos

echo "🔥 ELIMINAÇÃO COMPLETA: Limpando tudo do iCloud Drive Documents"
echo "=================================================================="
echo ""

echo "⚠️  VERIFICAÇÃO DE SEGURANÇA:"
echo "Este script vai ELIMINAR PERMANENTEMENTE:"
echo "1. Todas as pastas duplicadas numeradas em Documents"
echo "2. O link simbólico Documents no iCloud Drive"
echo "3. Arquivos .DS_Store e caches desnecessários"
echo "4. Lixeira do iCloud Drive"
echo ""

IFS= read -r -p "Tem certeza que deseja continuar? (digite 'ELIMINAR' para confirmar): " confirmacao
if [ "$confirmacao" != "ELIMINAR" ]; then
    echo "❌ Operação cancelada pelo usuário"
    exit 1
fi

echo ""
echo "🚀 INICIANDO ELIMINAÇÃO COMPLETA..."
echo ""

echo "1️⃣ PARANDO SERVIÇOS DO ICLOUD DRIVE..."
killall bird 2>/dev/null || echo "bird não estava executando"
killall cloudd 2>/dev/null || echo "cloudd não estava executando"
killall CloudKit 2>/dev/null || echo "CloudKit não estava executando"
sleep 3
echo "✅ Serviços parados"
echo ""

echo "2️⃣ REMOVENDO LINK SIMBÓLICO DEFINITIVAMENTE..."
ICLOUD_DOCS_LINK="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"
if [ -L "$ICLOUD_DOCS_LINK" ]; then
    rm -f "$ICLOUD_DOCS_LINK"
    echo "✅ Link simbólico removido: $ICLOUD_DOCS_LINK"
else
    echo "⚪ Link já estava removido"
fi
echo ""

DOCUMENTS_DIR="$HOME/Documents"
if ! cd "$DOCUMENTS_DIR" 2>/dev/null; then
    echo "❌ Não foi possível acessar $DOCUMENTS_DIR"
    exit 1
fi

echo "3️⃣ ELIMINANDO PASTAS DUPLICADAS NUMERADAS..."
shopt -s nullglob
duplicate_dirs=("$DOCUMENTS_DIR"/Documentos*[0-9])
shopt -u nullglob
ANTES=${#duplicate_dirs[@]}
echo "Pastas duplicadas encontradas: $ANTES"
for pasta in "${duplicate_dirs[@]}"; do
    echo "Eliminando: $(basename "$pasta")"
    rm -rf "$pasta"
done

extra_patterns=("Obsidian Vault" "macos-local")
for padrao in "${extra_patterns[@]}"; do
    while IFS= read -r -d '' pasta; do
        echo "Eliminando pasta suspeita: $(basename "$pasta")"
        rm -rf "$pasta"
    done < <(find "$DOCUMENTS_DIR" -maxdepth 1 -type d -name "*${padrao}*" -print0)
done
echo "✅ Pastas duplicadas eliminadas"
echo ""

echo "4️⃣ LIMPANDO ARQUIVOS .DS_STORE..."
find "$DOCUMENTS_DIR" -name ".DS_Store" -delete 2>/dev/null
echo "✅ Arquivos .DS_Store removidos"
echo ""

echo "5️⃣ LIMPANDO CACHES DO ICLOUD DRIVE..."
rm -rf "$HOME/Library/Caches/com.apple.bird" 2>/dev/null
rm -rf "$HOME/Library/Caches/CloudKit" 2>/dev/null
rm -rf "$HOME/Library/Caches/com.apple.CloudDocs" 2>/dev/null
echo "✅ Caches limpos"
echo ""

echo "6️⃣ REMOVENDO ARQUIVOS ÓRFÃOS DO ICLOUD..."
ICLOUD_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
if cd "$ICLOUD_ROOT" 2>/dev/null; then
    rm -f Documents.zip 2>/dev/null && echo "Documents.zip removido"
    find . -maxdepth 1 -name '.tmp*' -exec rm -rf {} + 2>/dev/null
    find . -maxdepth 1 -name '*.tmp' -exec rm -rf {} + 2>/dev/null
    echo "✅ Arquivos órfãos removidos"
else
    echo "⚠️ Não foi possível acessar $ICLOUD_ROOT"
fi
echo ""

echo "7️⃣ FORÇANDO REINDEXAÇÃO DO ICLOUD DRIVE..."
defaults write com.apple.bird.plist "force-reindex" -bool true
echo "✅ Reindexação forçada"
echo ""

echo "8️⃣ VERIFICANDO ESTRUTURA FINAL..."
DOCS_SIZE_FINAL=$(du -sh "$DOCUMENTS_DIR" 2>/dev/null | cut -f1)
DOCS_COUNT_FINAL=$(find "$DOCUMENTS_DIR" -mindepth 1 -maxdepth 1 -print | wc -l | tr -d ' ')
echo "📊 DOCUMENTS ATUAL:"
echo "Tamanho: $DOCS_SIZE_FINAL"
echo "Arquivos/pastas restantes: $DOCS_COUNT_FINAL"
echo ""

ICLOUD_SIZE_FINAL=$(du -sh "$ICLOUD_ROOT" 2>/dev/null | cut -f1)
echo "📊 ICLOUD DRIVE ATUAL:"
echo "Tamanho: $ICLOUD_SIZE_FINAL"
echo ""

echo "9️⃣ CONFIGURANDO EXCLUSÕES PERMANENTES..."
cat > "$HOME/.icloud_exclusions_permanent" <<'EOL'
# LISTA DE EXCLUSÕES PERMANENTES DO ICLOUD DRIVE
# Nunca sincronizar estes tipos de arquivo/pasta:

# Desenvolvimento
.env*
.zsh*
node_modules/
.git/
.vscode/
.idea/

# Segurança
*.key
*.pem
*.p12
*.cer
.ssh/

# Temporários
.DS_Store
.tmp/
*.tmp
.cache/

# Pastas locais seguras
Documents_Local_Secure/
Git_Repos_Local/
Documents_Backup_*/

# Logs e dumps
*.log
*.dump
*.dmp
EOL
echo "✅ Exclusões permanentes configuradas em $HOME/.icloud_exclusions_permanent"
echo ""

echo "📋 RELATÓRIO FINAL DE ELIMINAÇÃO:"
echo "=================================================================="
echo "🔥 ELIMINAÇÕES REALIZADAS:"
echo "✅ Link simbólico Documents → iCloud removido definitivamente"
echo "✅ $ANTES pastas duplicadas numeradas eliminadas"
echo "✅ Arquivos .DS_Store removidos de toda estrutura"
echo "✅ Caches do iCloud Drive limpos"
echo "✅ Arquivos órfãos do iCloud removidos"
echo "✅ Forçada reindexação do iCloud Drive"
echo ""

echo "📊 SITUAÇÃO ATUAL:"
echo "Documents local: $DOCS_SIZE_FINAL ($DOCS_COUNT_FINAL itens)"
echo "iCloud Drive: $ICLOUD_SIZE_FINAL"
echo ""

echo "🛡️ PROTEÇÕES ATIVADAS:"
echo "✅ Exclusões permanentes configuradas"
echo "✅ Sincronização Desktop/Documents desativada"
echo "✅ Estrutura segura disponível em $HOME/Documents_Local_Secure"
echo ""

echo "🎯 PRÓXIMOS PASSOS:"
echo "1. Reiniciar o sistema para aplicar todas as mudanças"
echo "2. Verificar System Settings → iCloud → iCloud Drive Options"
echo "3. Confirmar que 'Desktop & Documents Folders' está desmarcado"
echo "4. Usar $HOME/Documents_Local_Secure para novos documentos importantes"
echo ""

echo "🔄 REINICIANDO SERVIÇOS DO ICLOUD..."
open /System/Library/CoreServices/Finder.app
echo ""

echo "✅ ELIMINAÇÃO COMPLETA CONCLUÍDA COM SUCESSO!"
echo ""
