#!/bin/bash

# ============================================
# Script de Auditoria: System Prompts
# ============================================
# Auditoria completa de todos os system prompts
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_audit}"
TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)

mkdir -p "$OUTPUT_DIR"

# Detectar plataforma
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    CHECKSUM_CMD="shasum -a 256"
else
    PLATFORM="ubuntu"
    CHECKSUM_CMD="sha256sum"
fi

AUDIT_REPORT="$OUTPUT_DIR/audit_${TIMESTAMP}.md"

echo "============================================"
echo "🔍 Auditoria Completa de System Prompts"
echo "============================================"
echo ""
echo "🖥️  Plataforma: $PLATFORM"
echo "📁 Relatório: $AUDIT_REPORT"
echo ""

# Inicializar relatório
cat > "$AUDIT_REPORT" << EOF
# Auditoria de System Prompts

**Timestamp:** $TIMESTAMP
**Platform:** $PLATFORM
**Hostname:** $(hostname)

---

## Arquivos Auditados

EOF

# 1. System Prompt Global
echo "1️⃣  Auditando System Prompt Global..."
GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"

if [ -f "$GLOBAL_PROMPT" ]; then
    CHECKSUM=$($CHECKSUM_CMD "$GLOBAL_PROMPT" | cut -d' ' -f1)
    SIZE=$(stat -c%s "$GLOBAL_PROMPT" 2>/dev/null || stat -f%z "$GLOBAL_PROMPT" 2>/dev/null || echo "0")
    MODIFIED=$(stat -c%y "$GLOBAL_PROMPT" 2>/dev/null || stat -f%Sm "$GLOBAL_PROMPT" 2>/dev/null || echo "unknown")

    cat >> "$AUDIT_REPORT" << EOF
### System Prompt Global

- **Caminho:** \`$GLOBAL_PROMPT\`
- **Checksum:** \`$CHECKSUM\`
- **Tamanho:** $SIZE bytes
- **Modificado:** $MODIFIED
- **Status:** ✅ Existe

EOF
    echo "   ✅ $GLOBAL_PROMPT"
    echo "      Checksum: $CHECKSUM"
    echo "      Tamanho: $SIZE bytes"
else
    echo "   ❌ $GLOBAL_PROMPT não encontrado"
    echo "### System Prompt Global" >> "$AUDIT_REPORT"
    echo "- **Status:** ❌ Não encontrado" >> "$AUDIT_REPORT"
    echo "" >> "$AUDIT_REPORT"
fi

# 2. .cursorrules
echo ""
echo "2️⃣  Auditando .cursorrules..."
CURSOR_RULES="$HOME/.cursorrules"

if [ -f "$CURSOR_RULES" ]; then
    CHECKSUM=$($CHECKSUM_CMD "$CURSOR_RULES" | cut -d' ' -f1)
    SIZE=$(stat -c%s "$CURSOR_RULES" 2>/dev/null || stat -f%z "$CURSOR_RULES" 2>/dev/null || echo "0")
    MODIFIED=$(stat -c%y "$CURSOR_RULES" 2>/dev/null || stat -f%Sm "$CURSOR_RULES" 2>/dev/null || echo "unknown")

    cat >> "$AUDIT_REPORT" << EOF
### .cursorrules

- **Caminho:** \`$CURSOR_RULES\`
- **Checksum:** \`$CHECKSUM\`
- **Tamanho:** $SIZE bytes
- **Modificado:** $MODIFIED
- **Status:** ✅ Existe

EOF
    echo "   ✅ $CURSOR_RULES"
    echo "      Checksum: $CHECKSUM"

    # Comparar com system prompt global
    if [ -f "$GLOBAL_PROMPT" ]; then
        GLOBAL_CHECKSUM=$($CHECKSUM_CMD "$GLOBAL_PROMPT" | cut -d' ' -f1)
        if [ "$CHECKSUM" = "$GLOBAL_CHECKSUM" ]; then
            echo "      ✅ Sincronizado com system prompt global"
            echo "- **Sincronização:** ✅ Sincronizado com system prompt global" >> "$AUDIT_REPORT"
        else
            echo "      ⚠️  Diferente do system prompt global"
            echo "- **Sincronização:** ⚠️  Diferente do system prompt global" >> "$AUDIT_REPORT"
        fi
    fi
else
    echo "   ❌ $CURSOR_RULES não encontrado"
    echo "### .cursorrules" >> "$AUDIT_REPORT"
    echo "- **Status:** ❌ Não encontrado" >> "$AUDIT_REPORT"
    echo "" >> "$AUDIT_REPORT"
fi

# 3. Configurações do Cursor
echo ""
echo "3️⃣  Auditando configurações do Cursor..."
if [[ "$PLATFORM" == "macos" ]]; then
    CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
else
    CURSOR_SETTINGS="$HOME/.config/Cursor/User/settings.json"
fi

if [ -f "$CURSOR_SETTINGS" ]; then
    SYSTEM_PROMPT_ENABLED=$(grep -o '"cursor.systemPrompt.enabled":\s*true' "$CURSOR_SETTINGS" 2>/dev/null && echo "true" || echo "false")
    SYSTEM_PROMPT_PATH=$(grep -o '"cursor.systemPrompt":\s*"[^"]*"' "$CURSOR_SETTINGS" 2>/dev/null | cut -d'"' -f4 || echo "")

    cat >> "$AUDIT_REPORT" << EOF
### Configurações Cursor

- **Arquivo:** \`$CURSOR_SETTINGS\`
- **System Prompt Habilitado:** $SYSTEM_PROMPT_ENABLED
- **Caminho do Prompt:** \`$SYSTEM_PROMPT_PATH\`
- **Status:** ✅ Configurado

EOF
    echo "   ✅ Settings.json encontrado"
    echo "      System Prompt Habilitado: $SYSTEM_PROMPT_ENABLED"
else
    echo "   ⚠️  Settings.json não encontrado"
    echo "### Configurações Cursor" >> "$AUDIT_REPORT"
    echo "- **Status:** ⚠️  Não encontrado" >> "$AUDIT_REPORT"
    echo "" >> "$AUDIT_REPORT"
fi

# 4. Arquivos de configuração gerados
echo ""
echo "4️⃣  Auditando arquivos de configuração gerados..."
CONFIGS_DIR="$PROMPT_DIR/configs"

if [ -d "$CONFIGS_DIR" ]; then
    CONFIG_FILES=$(find "$CONFIGS_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "   ✅ $CONFIG_FILES arquivos de configuração encontrados"

    cat >> "$AUDIT_REPORT" << EOF
### Arquivos de Configuração

- **Diretório:** \`$CONFIGS_DIR\`
- **Arquivos:** $CONFIG_FILES

EOF

    for config_file in "$CONFIGS_DIR"/*; do
        if [ -f "$config_file" ]; then
            FILENAME=$(basename "$config_file")
            SIZE=$(stat -c%s "$config_file" 2>/dev/null || stat -f%z "$config_file" 2>/dev/null || echo "0")
            echo "   - $FILENAME ($SIZE bytes)"
            echo "- \`$FILENAME\`: $SIZE bytes" >> "$AUDIT_REPORT"
        fi
    done
else
    echo "   ⚠️  Diretório de configurações não encontrado"
    echo "### Arquivos de Configuração" >> "$AUDIT_REPORT"
    echo "- **Status:** ⚠️  Diretório não encontrado" >> "$AUDIT_REPORT"
    echo "" >> "$AUDIT_REPORT"
fi

# Resumo
cat >> "$AUDIT_REPORT" << EOF

---

## Recomendações

1. Verificar se todos os system prompts estão sincronizados
2. Validar checksums regularmente
3. Manter backup dos arquivos de configuração
4. Revisar configurações do Cursor periodicamente

---

*Auditoria gerada automaticamente*
EOF

echo ""
echo "============================================"
echo "✅ Auditoria concluída!"
echo "============================================"
echo ""
echo "📄 Relatório: $AUDIT_REPORT"
echo ""

