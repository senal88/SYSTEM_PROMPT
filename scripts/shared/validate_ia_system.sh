#!/bin/bash

# ============================================
# Script de Validação: Sistema IA Completo
# ============================================
# Valida todas as configurações de IA
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_validation}"
TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)

mkdir -p "$OUTPUT_DIR"

# Detectar plataforma
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    COLLECT_SCRIPT="$PROMPT_DIR/scripts/macos/collect_all_ia_macos.sh"
else
    PLATFORM="ubuntu"
    COLLECT_SCRIPT="$PROMPT_DIR/scripts/ubuntu/collect_all_ia_ubuntu.sh"
fi

VALIDATION_REPORT="$OUTPUT_DIR/validation_${TIMESTAMP}.md"

echo "============================================"
echo "🔍 Validação Completa do Sistema IA"
echo "============================================"
echo ""
echo "🖥️  Plataforma: $PLATFORM"
echo "📁 Relatório: $VALIDATION_REPORT"
echo ""

# Inicializar relatório
cat > "$VALIDATION_REPORT" << EOF
# Relatório de Validação - Sistema IA

**Timestamp:** $TIMESTAMP
**Platform:** $PLATFORM
**Hostname:** $(hostname)

---

## Resultados da Validação

EOF

ERRORS=0
WARNINGS=0
SUCCESS=0

# Função para adicionar resultado
add_result() {
    local status=$1
    local message=$2
    local category=$3

    if [ "$status" = "success" ]; then
        echo "✅ $message" | tee -a "$VALIDATION_REPORT"
        ((SUCCESS++))
    elif [ "$status" = "warning" ]; then
        echo "⚠️  $message" | tee -a "$VALIDATION_REPORT"
        ((WARNINGS++))
    else
        echo "❌ $message" | tee -a "$VALIDATION_REPORT"
        ((ERRORS++))
    fi
}

# 1. Validar System Prompt Global
echo ""
echo "1️⃣  Validando System Prompt Global..."
echo "### 1. System Prompt Global" >> "$VALIDATION_REPORT"
echo "" >> "$VALIDATION_REPORT"

GLOBAL_PROMPT="$PROMPT_DIR/system_prompt_global.txt"
if [ -f "$GLOBAL_PROMPT" ]; then
    SIZE=$(stat -c%s "$GLOBAL_PROMPT" 2>/dev/null || stat -f%z "$GLOBAL_PROMPT" 2>/dev/null || echo "0")
    if [ "$SIZE" -gt 100 ]; then
        add_result "success" "System Prompt Global existe e tem conteúdo válido ($SIZE bytes)" "system_prompt"
        echo "- ✅ Arquivo existe: $GLOBAL_PROMPT" >> "$VALIDATION_REPORT"
        echo "- ✅ Tamanho: $SIZE bytes" >> "$VALIDATION_REPORT"
    else
        add_result "error" "System Prompt Global existe mas está vazio ou muito pequeno" "system_prompt"
        echo "- ❌ Arquivo muito pequeno: $SIZE bytes" >> "$VALIDATION_REPORT"
    fi
else
    add_result "error" "System Prompt Global não encontrado" "system_prompt"
    echo "- ❌ Arquivo não encontrado: $GLOBAL_PROMPT" >> "$VALIDATION_REPORT"
fi

# 2. Validar Cursor IDE
echo ""
echo "2️⃣  Validando Cursor IDE..."
echo "" >> "$VALIDATION_REPORT"
echo "### 2. Cursor IDE" >> "$VALIDATION_REPORT"
echo "" >> "$VALIDATION_REPORT"

if [[ "$PLATFORM" == "macos" ]]; then
    CURSOR_RULES="$HOME/.cursorrules"
    CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
else
    CURSOR_RULES="$HOME/.cursorrules"
    CURSOR_SETTINGS="$HOME/.config/Cursor/User/settings.json"
fi

if [ -f "$CURSOR_RULES" ]; then
    add_result "success" ".cursorrules existe" "cursor"
    echo "- ✅ .cursorrules existe" >> "$VALIDATION_REPORT"
else
    add_result "warning" ".cursorrules não encontrado" "cursor"
    echo "- ⚠️  .cursorrules não encontrado" >> "$VALIDATION_REPORT"
fi

if [ -f "$CURSOR_SETTINGS" ]; then
    if grep -q '"cursor.systemPrompt.enabled":\s*true' "$CURSOR_SETTINGS" 2>/dev/null; then
        add_result "success" "System Prompt habilitado no Cursor" "cursor"
        echo "- ✅ System Prompt habilitado" >> "$VALIDATION_REPORT"
    else
        add_result "warning" "System Prompt não habilitado no Cursor" "cursor"
        echo "- ⚠️  System Prompt não habilitado" >> "$VALIDATION_REPORT"
    fi
else
    add_result "warning" "settings.json do Cursor não encontrado" "cursor"
    echo "- ⚠️  settings.json não encontrado" >> "$VALIDATION_REPORT"
fi

# 3. Validar API Keys
echo ""
echo "3️⃣  Validando API Keys..."
echo "" >> "$VALIDATION_REPORT"
echo "### 3. API Keys" >> "$VALIDATION_REPORT"
echo "" >> "$VALIDATION_REPORT"

API_KEYS=("OPENAI_API_KEY" "ANTHROPIC_API_KEY" "GEMINI_API_KEY")
CONFIGURED_KEYS=0

for key in "${API_KEYS[@]}"; do
    if [ -n "${!key}" ]; then
        add_result "success" "$key configurada" "api_keys"
        echo "- ✅ $key configurada" >> "$VALIDATION_REPORT"
        ((CONFIGURED_KEYS++))
    else
        add_result "warning" "$key não configurada" "api_keys"
        echo "- ⚠️  $key não configurada" >> "$VALIDATION_REPORT"
    fi
done

# 4. Validar Ferramentas CLI
echo ""
echo "4️⃣  Validando Ferramentas CLI..."
echo "" >> "$VALIDATION_REPORT"
echo "### 4. Ferramentas CLI" >> "$VALIDATION_REPORT"
echo "" >> "$VALIDATION_REPORT"

if command -v python3 &> /dev/null; then
    add_result "success" "python3 instalado" "tools"
    echo "- ✅ python3 instalado" >> "$VALIDATION_REPORT"

    # Verificar bibliotecas
    for lib in openai anthropic; do
        if python3 -c "import $lib" 2>/dev/null; then
            add_result "success" "Biblioteca $lib instalada" "tools"
            echo "- ✅ Biblioteca $lib instalada" >> "$VALIDATION_REPORT"
        else
            add_result "warning" "Biblioteca $lib não instalada" "tools"
            echo "- ⚠️  Biblioteca $lib não instalada" >> "$VALIDATION_REPORT"
        fi
    done
else
    add_result "error" "python3 não instalado" "tools"
    echo "- ❌ python3 não instalado" >> "$VALIDATION_REPORT"
fi

# 5. Executar coleta completa
echo ""
echo "5️⃣  Executando coleta completa..."
if [ -f "$COLLECT_SCRIPT" ]; then
    bash "$COLLECT_SCRIPT" > "$OUTPUT_DIR/collection_${TIMESTAMP}.log" 2>&1
    add_result "success" "Coleta completa executada" "collection"
    echo "- ✅ Coleta completa executada" >> "$VALIDATION_REPORT"
else
    add_result "error" "Script de coleta não encontrado" "collection"
    echo "- ❌ Script não encontrado: $COLLECT_SCRIPT" >> "$VALIDATION_REPORT"
fi

# Resumo
echo ""
echo "============================================"
echo "📊 Resumo da Validação"
echo "============================================"
echo ""

cat >> "$VALIDATION_REPORT" << EOF

---

## Resumo

- ✅ Sucessos: $SUCCESS
- ⚠️  Avisos: $WARNINGS
- ❌ Erros: $ERRORS

EOF

echo "✅ Sucessos: $SUCCESS"
echo "⚠️  Avisos: $WARNINGS"
echo "❌ Erros: $ERRORS"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo "✅ Validação concluída com sucesso!"
    echo "**Status:** ✅ Aprovado" >> "$VALIDATION_REPORT"
elif [ $ERRORS -le 2 ]; then
    echo "⚠️  Validação concluída com avisos"
    echo "**Status:** ⚠️  Parcial" >> "$VALIDATION_REPORT"
else
    echo "❌ Validação falhou"
    echo "**Status:** ❌ Falhou" >> "$VALIDATION_REPORT"
fi

echo ""
echo "📄 Relatório completo: $VALIDATION_REPORT"
echo ""

