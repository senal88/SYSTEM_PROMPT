#!/bin/bash

# SCRIPT DE VERIFICAÇÃO PÓS-ELIMINAÇÃO
# Verifica se tudo foi limpo corretamente

echo "🔍 VERIFICAÇÃO PÓS-ELIMINAÇÃO - iCloud Drive Documents"
echo "======================================================"
echo ""

# Verificar se link foi removido
echo "1️⃣ VERIFICANDO LINK SIMBÓLICO:"
ICLOUD_DOCS_LINK="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"
if [ -L "$ICLOUD_DOCS_LINK" ]; then
    echo "❌ PROBLEMA: Link ainda existe!"
    ls -la "$ICLOUD_DOCS_LINK"
else
    echo "✅ Link simbólico removido com sucesso"
fi
echo ""

# Verificar tamanhos atuais
echo "2️⃣ VERIFICANDO TAMANHOS:"
DOCS_SIZE=$(du -sh "$HOME/Documents" 2>/dev/null | cut -f1)
ICLOUD_SIZE=$(du -sh "$HOME/Library/Mobile Documents/com~apple~CloudDocs" 2>/dev/null | cut -f1)
echo "Documents local: $DOCS_SIZE"
echo "iCloud Drive local: $ICLOUD_SIZE"
echo ""

# Contar pastas duplicadas restantes
echo "3️⃣ VERIFICANDO PASTAS DUPLICADAS:"
if shopt -q nullglob; then
    NULLGLOB_WAS_SET=true
else
    NULLGLOB_WAS_SET=false
    shopt -s nullglob
fi
DUPLICATE_DIRS=("$HOME/Documents"/Documentos*[0-9])
if [ "$NULLGLOB_WAS_SET" = false ]; then
    shopt -u nullglob
fi
DUPLICATES_COUNT=${#DUPLICATE_DIRS[@]}
echo "Pastas duplicadas restantes: $DUPLICATES_COUNT"
if [ "$DUPLICATES_COUNT" -eq 0 ]; then
    echo "✅ Todas as duplicatas foram eliminadas"
else
    echo "⚠️ Ainda existem $DUPLICATES_COUNT pastas duplicadas"
    printf '%s\n' "${DUPLICATE_DIRS[@]:0:5}"
fi
echo ""

# Verificar repositórios Git
echo "4️⃣ VERIFICANDO REPOSITÓRIOS GIT:"
GIT_COUNT=$(find "$HOME/Documents" -name ".git" -type d 2>/dev/null | wc -l | tr -d ' ')
echo "Repositórios Git em Documents: $GIT_COUNT"
if [ "$GIT_COUNT" -eq 0 ]; then
    echo "✅ Nenhum repositório Git em Documents"
else
    echo "⚠️ Ainda existem $GIT_COUNT repositórios Git"
fi
echo ""

# Verificar backups criados
echo "5️⃣ VERIFICANDO BACKUPS CRIADOS:"
BACKUP_TARGETS=(
  "$HOME/Documents_Backup"
  "$HOME/Git_Repos_Local"
  "$HOME/Documents_Local_Secure"
)
FOUND_BACKUP=false
for TARGET in "${BACKUP_TARGETS[@]}"; do
    if [ -e "$TARGET" ]; then
        FOUND_BACKUP=true
        ls -ld "$TARGET"
    fi
done
if [ "$FOUND_BACKUP" = false ]; then
    echo "❌ Backups não encontrados"
fi
echo ""

# Verificar configurações do iCloud
echo "6️⃣ VERIFICANDO CONFIGURAÇÕES DO ICLOUD:"
if ! DESKTOP_DOCS_ENABLED=$(defaults read "$HOME/Library/Preferences/com.apple.bird.plist" "icloud-drive.desktop-and-documents-enabled" 2>/dev/null); then
    DESKTOP_DOCS_ENABLED="não configurado"
fi
echo "Desktop & Documents sincronização: $DESKTOP_DOCS_ENABLED"
if [ "$DESKTOP_DOCS_ENABLED" = "0" ]; then
    echo "✅ Sincronização Desktop/Documents desativada"
else
    echo "⚠️ Sincronização ainda pode estar ativa"
fi
echo ""

# Status geral
echo "📊 STATUS GERAL:"
if [ ! -L "$ICLOUD_DOCS_LINK" ] && [ "$DUPLICATES_COUNT" -eq 0 ] && [ "$GIT_COUNT" -eq 0 ]; then
    echo "🎉 ELIMINAÇÃO COMPLETA BEM-SUCEDIDA!"
    echo "✅ Todos os problemas foram resolvidos"
else
    echo "⚠️ ELIMINAÇÃO PARCIAL - Alguns itens precisam de atenção"
fi
echo ""

echo "💡 LEMBRETES IMPORTANTES:"
echo "1. Use $HOME/Documents_Local_Secure para novos documentos"
echo "2. Repositórios Git estão em $HOME/Git_Repos_Local"
echo "3. Backups estão disponíveis se necessário"
echo "4. Reinicie o sistema se ainda não reiniciou"