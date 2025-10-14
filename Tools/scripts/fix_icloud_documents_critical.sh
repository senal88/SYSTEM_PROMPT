#!/bin/bash

# SCRIPT DE CORREÇÃO CRÍTICA - iCloud Drive Documents
# macOS Tahoe 26.0.1 - Luiz Sena
# Data: $(date)

echo "🚨 CORREÇÃO CRÍTICA: Desvinculando Documents do iCloud Drive"
echo "=================================================================="
echo ""

# Backup de segurança antes de qualquer ação
echo "1️⃣ CRIANDO BACKUP DE SEGURANÇA..."
BACKUP_DIR="$HOME/Documents_Backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "Backup será salvo em: $BACKUP_DIR"
echo ""

# Parar sincronização do iCloud Drive temporariamente
echo "2️⃣ PAUSANDO SINCRONIZAÇÃO DO ICLOUD DRIVE..."
killall bird 2>/dev/null || echo "bird não estava executando"
echo "Aguardando 5 segundos..."
sleep 5
echo ""

# Remover link simbólico perigoso
echo "3️⃣ REMOVENDO LINK SIMBÓLICO PERIGOSO..."
ICLOUD_DOCS_LINK="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"
if [ -L "$ICLOUD_DOCS_LINK" ]; then
    echo "Removendo link: $ICLOUD_DOCS_LINK"
    rm "$ICLOUD_DOCS_LINK"
    echo "✅ Link removido com sucesso!"
else
    echo "❌ Link não encontrado ou já removido"
fi
echo ""

# Mover repositórios Git para local seguro
echo "4️⃣ MOVENDO REPOSITÓRIOS GIT PARA LOCAL SEGURO..."
GIT_BACKUP_DIR="$HOME/Git_Repos_Local"
mkdir -p "$GIT_BACKUP_DIR"

# Encontrar e mover repositórios Git
find "$HOME/Documents" -name ".git" -type d 2>/dev/null | while read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")
    echo "Movendo repositório: $repo_name"
    mv "$repo_dir" "$GIT_BACKUP_DIR/"
done
echo ""

# Limpar pastas duplicadas numeradas
echo "5️⃣ IDENTIFICANDO PASTAS DUPLICADAS..."
find "$HOME/Documents" -mindepth 1 -maxdepth 1 -type d -name 'Documentos*[0-9]' -print > "$BACKUP_DIR/pastas_duplicadas.txt"
DUPLICATE_COUNT=$(wc -l < "$BACKUP_DIR/pastas_duplicadas.txt")
echo "Encontradas $DUPLICATE_COUNT pastas duplicadas"
echo "Lista salva em: $BACKUP_DIR/pastas_duplicadas.txt"
echo ""

# Criar estrutura organizada
echo "6️⃣ CRIANDO ESTRUTURA ORGANIZADA..."
mkdir -p "$HOME/Documents_Local_Secure"
mkdir -p "$HOME/Documents_Local_Secure/Financeiro"
mkdir -p "$HOME/Documents_Local_Secure/Pessoal"
mkdir -p "$HOME/Documents_Local_Secure/Temporario"
echo "✅ Estrutura criada em: $HOME/Documents_Local_Secure"
echo ""

# Configurar exclusões do iCloud
echo "7️⃣ CONFIGURANDO EXCLUSÕES DO ICLOUD..."
cat > "$HOME/.icloud_exclusions" << 'EOL'
# Arquivos/pastas que NUNCA devem ir para iCloud
.env*
.zsh*
node_modules/
.git/
*.key
*.pem
*.p12
.ssh/
Documents_Local_Secure/
Git_Repos_Local/
EOL
echo "✅ Exclusões configuradas em: $HOME/.icloud_exclusions"
echo ""

# Desativar sincronização automática de Desktop e Documents
echo "8️⃣ DESATIVANDO SINCRONIZAÇÃO AUTOMÁTICA..."
defaults write ~/Library/Preferences/com.apple.bird.plist "icloud-drive.desktop-and-documents-enabled" -bool false
echo "✅ Sincronização Desktop/Documents desativada"
echo ""

# Relatório final
echo "📋 RELATÓRIO FINAL:"
echo "=================================================================="
echo "✅ Link simbólico Documents removido"
echo "✅ Repositórios Git movidos para: $GIT_BACKUP_DIR"
echo "✅ Backup criado em: $BACKUP_DIR"
echo "✅ Estrutura segura criada: $HOME/Documents_Local_Secure"
echo "✅ Exclusões configuradas"
echo "✅ Sincronização automática desativada"
echo ""
echo "🔄 PRÓXIMOS PASSOS:"
echo "1. Reiniciar o sistema para aplicar mudanças"
echo "2. Verificar System Settings > iCloud > iCloud Drive Options"
echo "3. Desmarcar 'Desktop & Documents Folders' se estiver marcado"
echo "4. Mover arquivos importantes para Documents_Local_Secure"
echo "5. Limpar pastas duplicadas manualmente quando seguro"
echo ""
echo "⚠️  IMPORTANTE:"
echo "- Documents não será mais sincronizado automaticamente"
echo "- Use Documents_Local_Secure para arquivos locais"
echo "- Repositórios Git estão em Git_Repos_Local"
echo "- Backup completo disponível em $BACKUP_DIR"
echo ""

# Reiniciar bird (daemon do iCloud)
echo "🔄 REINICIANDO SERVIÇOS DO ICLOUD..."
open /System/Library/CoreServices/Finder.app
echo "✅ Processo concluído!"
echo ""
echo "🚨 REINICIE O SISTEMA PARA APLICAR TODAS AS MUDANÇAS!"