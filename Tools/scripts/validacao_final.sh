#!/bin/bash

# SCRIPT FINAL DE VALIDAÇÃO - macOS Tahoe 26.0.1
# Verifica se todas as soluções estão funcionando corretamente

echo "🎯 VALIDAÇÃO FINAL - SOLUÇÃO DEFINITIVA"
echo "======================================="
echo "Data: $(date)"
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    if [ "$1" -eq 0 ]; then
        echo -e "${GREEN}✅ ${2}${NC}"
    else
        echo -e "${RED}❌ ${2}${NC}"
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

echo "🔍 VERIFICANDO SOLUÇÕES IMPLEMENTADAS..."
echo ""

# 1. Verificar se Documents está vazio
echo "1️⃣ VERIFICAÇÃO: Pasta Documents"
DOCS_COUNT=$(find "$HOME/Documents" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | awk '{print $1}')
DOCS_COUNT=${DOCS_COUNT:-0}
if [ "$DOCS_COUNT" -eq 0 ]; then
    print_status 0 "$HOME/Documents está vazia (CORRETO)"
else
    print_status 1 "$HOME/Documents tem $DOCS_COUNT itens (VERIFICAR!)"
    ls -la "$HOME/Documents"
fi
echo ""

# 2. Verificar link iCloud
echo "2️⃣ VERIFICAÇÃO: Link iCloud Documents"
if [ ! -L "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" ]; then
    print_status 0 "Link simbólico removido (CORRETO)"
else
    print_status 1 "Link ainda existe (PROBLEMA!)"
    ls -la "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"
fi
echo ""

# 3. Verificar configuração iCloud
echo "3️⃣ VERIFICAÇÃO: Configurações iCloud"
DESKTOP_DOCS=$(defaults read "$HOME/Library/Preferences/com.apple.bird.plist" "icloud-drive.desktop-and-documents-enabled" 2>/dev/null || echo "não configurado")
if [ "$DESKTOP_DOCS" = "0" ]; then
    print_status 0 "Sincronização Desktop/Documents desativada (CORRETO)"
elif [ "$DESKTOP_DOCS" = "não configurado" ]; then
    print_warning "Configuração não encontrada - pode estar desativada"
else
    print_status 1 "Sincronização ativa: $DESKTOP_DOCS (VERIFICAR!)"
fi
echo ""

# 4. Verificar estrutura nova
echo "4️⃣ VERIFICAÇÃO: Nova estrutura de pastas"
if [ -d "$HOME/Documents_Local_Secure" ]; then
    print_status 0 "Documents_Local_Secure criada"
    ls -la "$HOME/Documents_Local_Secure"
else
    print_status 1 "Documents_Local_Secure não encontrada"
fi

if [ -d "$HOME/Git_Repos_Local" ]; then
    print_status 0 "Git_Repos_Local criada"
    REPO_COUNT=$(find "$HOME/Git_Repos_Local" -name ".git" -type d 2>/dev/null | wc -l | awk '{print $1}')
    REPO_COUNT=${REPO_COUNT:-0}
    print_info "Contém ${REPO_COUNT:-0} repositórios Git"
else
    print_status 1 "Git_Repos_Local não encontrada"
fi
echo ""

# 5. Verificar backup
echo "5️⃣ VERIFICAÇÃO: Backup de segurança"
if [ -d "$HOME/Documents_Backup_20251013_195437" ]; then
    print_status 0 "Backup criado e disponível"
    BACKUP_SIZE=$(du -sh "$HOME/Documents_Backup_20251013_195437" | cut -f1)
    print_info "Tamanho do backup: $BACKUP_SIZE"
else
    print_status 1 "Backup não encontrado"
fi
echo ""

# 6. Verificar exclusões permanentes
echo "6️⃣ VERIFICAÇÃO: Exclusões permanentes"
if [ -f "$HOME/.icloud_exclusions_permanent" ]; then
    print_status 0 "Arquivo de exclusões criado"
    EXCLUSIONS_COUNT=$(wc -l < "$HOME/.icloud_exclusions_permanent")
    print_info "Contém $EXCLUSIONS_COUNT regras de exclusão"
else
    print_status 1 "Arquivo de exclusões não encontrado"
fi
echo ""

# 7. Verificar tamanhos
echo "7️⃣ VERIFICAÇÃO: Tamanhos das pastas"
DOCS_SIZE=$(du -sh "$HOME/Documents" 2>/dev/null | cut -f1)
ICLOUD_SIZE=$(du -sh "$HOME/Library/Mobile Documents/com~apple~CloudDocs" 2>/dev/null | cut -f1)
GIT_SIZE=$(du -sh "$HOME/Git_Repos_Local" 2>/dev/null | cut -f1)

echo "📊 Tamanhos atuais:"
echo "   ~/Documents: $DOCS_SIZE"
echo "   iCloud Drive: $ICLOUD_SIZE"
echo "   Git_Repos_Local: $GIT_SIZE"
echo ""

# 8. Verificar processos relacionados
echo "8️⃣ VERIFICAÇÃO: Processos do sistema"
if command -v pgrep >/dev/null 2>&1; then
    BIRD_RUNNING=$(pgrep -f "bird" 2>/dev/null | wc -l | awk '{print $1}')
else
    BIRD_RUNNING=0
fi
if [ "${BIRD_RUNNING:-0}" -gt 0 ]; then
    print_info "bird (iCloud daemon) está executando (${BIRD_RUNNING} processos)"
else
    print_warning "bird não está executando (pode ser normal)"
fi
echo ""

# 9. Status geral
echo "📋 RESUMO FINAL:"
echo "==============="

ALL_GOOD=true

# Verificações críticas
if [ "$DOCS_COUNT" -ne 0 ]; then ALL_GOOD=false; fi
if [ -L "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" ]; then ALL_GOOD=false; fi
if [ "$DESKTOP_DOCS" != "0" ] && [ "$DESKTOP_DOCS" != "não configurado" ]; then ALL_GOOD=false; fi
if [ ! -d "$HOME/Documents_Local_Secure" ]; then ALL_GOOD=false; fi
if [ ! -d "$HOME/Git_Repos_Local" ]; then ALL_GOOD=false; fi

if $ALL_GOOD; then
    echo -e "${GREEN}🎉 TODAS AS VERIFICAÇÕES PASSARAM!${NC}"
    echo -e "${GREEN}✅ Sistema completamente seguro e organizado${NC}"
    echo ""
    echo "📋 PRÓXIMOS PASSOS:"
    echo "1. ✅ Continuar usando ~/Documents_Local_Secure para documentos"
    echo "2. ✅ Continuar usando ~/Git_Repos_Local para repositórios"
    echo "3. ✅ Monitorar semanalmente com este script"
    echo "4. ✅ Fazer backup regular em SSD externa"
else
    echo -e "${RED}⚠️ ALGUMAS VERIFICAÇÕES FALHARAM${NC}"
    echo -e "${YELLOW}📋 AÇÕES RECOMENDADAS:${NC}"
    echo "1. Revisar itens marcados com ❌"
    echo "2. Re-executar scripts de correção se necessário"
    echo "3. Verificar System Settings → iCloud manualmente"
    echo "4. Reiniciar sistema se ainda não reiniciou"
fi

echo ""
echo "🔄 Para monitoramento contínuo, execute este script semanalmente:"
echo "   ./validacao_final.sh"
echo ""
echo "📖 Documentação completa disponível em:"
echo "   RESUMO_FINAL_SOLUCAO_DEFINITIVA.md"
echo "   ARQUITETURA_GLOBAL_POS_LIMPEZA.md"
