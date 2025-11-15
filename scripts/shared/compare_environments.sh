#!/bin/bash

# ============================================
# Script de Comparação: Mac vs VPS
# ============================================
# Compara configurações entre macOS e Ubuntu
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_comparison}"
TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)

mkdir -p "$OUTPUT_DIR"

COMPARISON_REPORT="$OUTPUT_DIR/comparison_${TIMESTAMP}.md"

echo "============================================"
echo "🔍 Comparação Mac ↔ VPS"
echo "============================================"
echo ""
echo "📁 Relatório: $COMPARISON_REPORT"
echo ""
echo "⚠️  Este script requer acesso a ambos os ambientes"
echo "    Execute no ambiente atual e compare manualmente"
echo ""

# Detectar plataforma atual
if [[ "$OSTYPE" == "darwin"* ]]; then
    CURRENT_PLATFORM="macos"
    OTHER_PLATFORM="ubuntu"
else
    CURRENT_PLATFORM="ubuntu"
    OTHER_PLATFORM="macos"
fi

# Inicializar relatório
cat > "$COMPARISON_REPORT" << EOF
# Comparação de Ambientes - Mac vs VPS

**Timestamp:** $TIMESTAMP
**Ambiente Atual:** $CURRENT_PLATFORM
**Ambiente Comparado:** $OTHER_PLATFORM

---

## Informações do Ambiente Atual

**Plataforma:** $CURRENT_PLATFORM
**Hostname:** $(hostname)
**Timestamp:** $(date)

EOF

# Coletar informações do ambiente atual
echo "Coletando informações do ambiente atual ($CURRENT_PLATFORM)..."

# System Prompt Global
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
if [ -f "$GLOBAL_PROMPT" ]; then
    if [[ "$CURRENT_PLATFORM" == "macos" ]]; then
        CHECKSUM=$(shasum -a 256 "$GLOBAL_PROMPT" | cut -d' ' -f1)
    else
        CHECKSUM=$(sha256sum "$GLOBAL_PROMPT" | cut -d' ' -f1)
    fi
    SIZE=$(stat -c%s "$GLOBAL_PROMPT" 2>/dev/null || stat -f%z "$GLOBAL_PROMPT" 2>/dev/null || echo "0")

    cat >> "$COMPARISON_REPORT" << EOF
### System Prompt Global ($CURRENT_PLATFORM)

- **Caminho:** \`$GLOBAL_PROMPT\`
- **Checksum:** \`$CHECKSUM\`
- **Tamanho:** $SIZE bytes
- **Status:** ✅ Existe

EOF
else
    cat >> "$COMPARISON_REPORT" << EOF
### System Prompt Global ($CURRENT_PLATFORM)

- **Status:** ❌ Não encontrado

EOF
fi

# .cursorrules
CURSOR_RULES="$HOME/.cursorrules"
if [ -f "$CURSOR_RULES" ]; then
    if [[ "$CURRENT_PLATFORM" == "macos" ]]; then
        CHECKSUM=$(shasum -a 256 "$CURSOR_RULES" | cut -d' ' -f1)
    else
        CHECKSUM=$(sha256sum "$CURSOR_RULES" | cut -d' ' -f1)
    fi

    cat >> "$COMPARISON_REPORT" << EOF
### .cursorrules ($CURRENT_PLATFORM)

- **Caminho:** \`$CURSOR_RULES\`
- **Checksum:** \`$CHECKSUM\`
- **Status:** ✅ Existe

EOF
fi

# API Keys (apenas status)
cat >> "$COMPARISON_REPORT" << EOF
### API Keys ($CURRENT_PLATFORM)

EOF

for key in OPENAI_API_KEY ANTHROPIC_API_KEY GEMINI_API_KEY; do
    if [ -n "${!key}" ]; then
        echo "- **$key:** ✅ Configurada" >> "$COMPARISON_REPORT"
    else
        echo "- **$key:** ❌ Não configurada" >> "$COMPARISON_REPORT"
    fi
done

# Instruções para comparação
cat >> "$COMPARISON_REPORT" << EOF

---

## Instruções para Comparação

### No Ambiente $OTHER_PLATFORM:

1. Execute o script de coleta:
   \`\`\`bash
   # No Mac:
   ~/SYSTEM_PROMPT/scripts/macos/collect_all_ia_macos.sh

   # No VPS:
   ~/SYSTEM_PROMPT/scripts/ubuntu/collect_all_ia_ubuntu.sh
   \`\`\`

2. Compare os checksums dos arquivos:
   - System Prompt Global
   - .cursorrules
   - Configurações do Cursor

3. Verifique se as API keys estão configuradas em ambos os ambientes

4. Use o script de sincronização se necessário:
   \`\`\`bash
   ~/SYSTEM_PROMPT/scripts/shared/sync_system_prompt.sh
   \`\`\`

---

## Checklist de Sincronização

- [ ] System Prompt Global tem mesmo checksum em ambos ambientes
- [ ] .cursorrules está sincronizado
- [ ] Configurações do Cursor são consistentes
- [ ] API keys estão configuradas em ambos ambientes
- [ ] Scripts de coleta funcionam em ambos ambientes
- [ ] Sincronização automática está configurada (se aplicável)

---

*Comparação gerada automaticamente*
EOF

echo ""
echo "============================================"
echo "✅ Comparação gerada!"
echo "============================================"
echo ""
echo "📄 Relatório: $COMPARISON_REPORT"
echo ""
echo "📋 Próximos passos:"
echo "   1. Execute o script de coleta no outro ambiente"
echo "   2. Compare os checksums manualmente"
echo "   3. Use sync_system_prompt.sh para sincronizar se necessário"
echo ""

