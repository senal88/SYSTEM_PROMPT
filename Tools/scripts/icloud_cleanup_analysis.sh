#!/bin/bash

echo "�� ANÁLISE CRÍTICA: iCloud Drive e SSD Internal - macOS Tahoe 26.0.1"
echo "Data: $(date)"
echo "=================================================================="
echo ""

# 1. Status do iCloud Drive
echo "📊 STATUS DO ICLOUD DRIVE:"
echo "Optimize Storage ATIVO: $(defaults read ~/Library/Preferences/com.apple.bird.plist optimize-storage 2>/dev/null || echo 'não configurado')"
echo ""

# 2. Verificar link simbólico perigoso
echo "🚨 PROBLEMA CRÍTICO DETECTADO:"
if [ -L ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents ]; then
    echo "✅ CONFIRMADO: Documents está linkado ao iCloud Drive!"
    echo "   Link: $(ls -la ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents)"
    echo "   ISSO SIGNIFICA: Sua pasta Documents está sendo sincronizada!"
else
    echo "❌ Link não encontrado (pode ter sido removido)"
fi
echo ""

# 3. Análise de tamanhos
echo "📏 ANÁLISE DE TAMANHOS:"
DOCS_SIZE=$(du -sh /Users/luiz.sena88/Documents 2>/dev/null | cut -f1)
ICLOUD_SIZE=$(du -sh ~/Library/Mobile\ Documents/com~apple~CloudDocs/ 2>/dev/null | cut -f1)
echo "Documents local: $DOCS_SIZE"
echo "iCloud Drive local: $ICLOUD_SIZE"
echo ""

# 4. Arquivos problemáticos
echo "⚠️  ARQUIVOS PROBLEMÁTICOS ENCONTRADOS:"
PROBLEM_COUNT=$(find /Users/luiz.sena88/Documents -name "*.env*" -o -name ".zsh*" -o -name "node_modules" -o -name ".git" -o -name "*.key" -o -name "*.pem" -o -name "*.p12" 2>/dev/null | wc -l)
echo "Total de arquivos/pastas problemáticas: $PROBLEM_COUNT"
echo ""

# 5. Repositórios Git
GIT_REPOS=$(find /Users/luiz.sena88/Documents -name ".git" -type d 2>/dev/null | wc -l)
echo "🔀 REPOSITÓRIOS GIT DETECTADOS: $GIT_REPOS"
echo "PERIGO: Repositórios Git NÃO devem estar no iCloud!"
echo ""

# 6. Pastas duplicadas suspeitas
echo "🔄 PASTAS DUPLICADAS/SUSPEITAS:"
mapfile -t duplicate_dirs < <(find /Users/luiz.sena88/Documents -mindepth 1 -maxdepth 1 -type d -name 'Documentos*[0-9]' 2>/dev/null)
echo "Pastas com numeração (possíveis duplicatas): ${#duplicate_dirs[@]}"
echo ""

# 7. Recomendações
echo "💡 RECOMENDAÇÕES CRÍTICAS:"
echo "1. REMOVER link simbólico Documents do iCloud imediatamente"
echo "2. MOVER repositórios Git para pasta local segura"
echo "3. LIMPAR pastas duplicadas numeradas"
echo "4. CONFIGURAR exclusões no iCloud Drive"
echo "5. DESATIVAR sincronização da pasta Documents"
echo ""

echo "🚨 AÇÃO IMEDIATA NECESSÁRIA!"
echo "Sua pasta Documents está sendo sincronizada com iCloud!"
echo "Isso pode causar problemas de segurança e ocupar SSD desnecessariamente."
