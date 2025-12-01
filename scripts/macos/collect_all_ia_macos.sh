#!/bin/bash

# ============================================
# Script Master: Coleta Completa IA - macOS
# ============================================
# Consolida todas as coletas e gera JSON/Markdown
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-/tmp/ia_collection}"
REPORTS_DIR="$OUTPUT_DIR/reports"
TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)

mkdir -p "$OUTPUT_DIR"
mkdir -p "$REPORTS_DIR"

echo "============================================"
echo "🔍 Coleta Completa de IA - macOS"
echo "============================================"
echo ""
echo "📁 Diretório de saída: $OUTPUT_DIR"
echo "🕐 Timestamp: $TIMESTAMP"
echo ""

# Executar todos os scripts de coleta
echo "Executando coletas individuais..."
echo ""

"$SCRIPT_DIR/collect_system_prompt_macos.sh" > "$REPORTS_DIR/system_prompt_${TIMESTAMP}.json" 2>&1
echo "✅ System Prompt coletado"

"$SCRIPT_DIR/collect_cursor_config_macos.sh" > "$REPORTS_DIR/cursor_config_${TIMESTAMP}.json" 2>&1
echo "✅ Cursor Config coletado"

"$SCRIPT_DIR/collect_chatgpt_config_macos.sh" > "$REPORTS_DIR/chatgpt_config_${TIMESTAMP}.json" 2>&1
echo "✅ ChatGPT Config coletado"

"$SCRIPT_DIR/collect_ia_tools_macos.sh" > "$REPORTS_DIR/ia_tools_${TIMESTAMP}.json" 2>&1
echo "✅ IA Tools coletado"

"$SCRIPT_DIR/collect_api_keys_macos.sh" > "$REPORTS_DIR/api_keys_${TIMESTAMP}.json" 2>&1
echo "✅ API Keys coletado"

"$SCRIPT_DIR/collect_environment_macos.sh" > "$REPORTS_DIR/environment_${TIMESTAMP}.json" 2>&1
echo "✅ Environment coletado"

"$SCRIPT_DIR/collect_ide_extensions_macos.sh" > "$REPORTS_DIR/ide_extensions_${TIMESTAMP}.json" 2>&1
echo "✅ IDE Extensions coletado"

echo ""
echo "Consolidando relatórios..."

# Consolidar em um único JSON
CONSOLIDATED_JSON="$REPORTS_DIR/consolidated_${TIMESTAMP}.json"

echo "{" > "$CONSOLIDATED_JSON"
echo "  \"metadata\": {" >> "$CONSOLIDATED_JSON"
echo "    \"timestamp\": \"$TIMESTAMP\"," >> "$CONSOLIDATED_JSON"
echo "    \"platform\": \"macOS\"," >> "$CONSOLIDATED_JSON"
echo "    \"hostname\": \"$(hostname)\"," >> "$CONSOLIDATED_JSON"
echo "    \"collection_version\": \"1.0\"" >> "$CONSOLIDATED_JSON"
echo "  }," >> "$CONSOLIDATED_JSON"

# Mesclar todos os JSONs
jq -s '.[0] * .[1] * .[2] * .[3] * .[4] * .[5] * .[6]' \
    "$REPORTS_DIR/system_prompt_${TIMESTAMP}.json" \
    "$REPORTS_DIR/cursor_config_${TIMESTAMP}.json" \
    "$REPORTS_DIR/chatgpt_config_${TIMESTAMP}.json" \
    "$REPORTS_DIR/ia_tools_${TIMESTAMP}.json" \
    "$REPORTS_DIR/api_keys_${TIMESTAMP}.json" \
    "$REPORTS_DIR/environment_${TIMESTAMP}.json" \
    "$REPORTS_DIR/ide_extensions_${TIMESTAMP}.json" 2>/dev/null >> "$CONSOLIDATED_JSON" || {
    # Fallback se jq não estiver disponível
    echo "  \"note\": \"jq não disponível, usando merge manual\"," >> "$CONSOLIDATED_JSON"
    echo "  \"reports\": {" >> "$CONSOLIDATED_JSON"
    echo "    \"system_prompt\": $(cat $REPORTS_DIR/system_prompt_${TIMESTAMP}.json)," >> "$CONSOLIDATED_JSON"
    echo "    \"cursor_config\": $(cat $REPORTS_DIR/cursor_config_${TIMESTAMP}.json)," >> "$CONSOLIDATED_JSON"
    echo "    \"chatgpt_config\": $(cat $REPORTS_DIR/chatgpt_config_${TIMESTAMP}.json)," >> "$CONSOLIDATED_JSON"
    echo "    \"ia_tools\": $(cat $REPORTS_DIR/ia_tools_${TIMESTAMP}.json)," >> "$CONSOLIDATED_JSON"
    echo "    \"api_keys\": $(cat $REPORTS_DIR/api_keys_${TIMESTAMP}.json)," >> "$CONSOLIDATED_JSON"
    echo "    \"environment\": $(cat $REPORTS_DIR/environment_${TIMESTAMP}.json)," >> "$CONSOLIDATED_JSON"
    echo "    \"ide_extensions\": $(cat $REPORTS_DIR/ide_extensions_${TIMESTAMP}.json)" >> "$CONSOLIDATED_JSON"
    echo "  }" >> "$CONSOLIDATED_JSON"
}

echo "}" >> "$CONSOLIDATED_JSON"

# Gerar relatório Markdown
MARKDOWN_REPORT="$REPORTS_DIR/report_${TIMESTAMP}.md"

cat > "$MARKDOWN_REPORT" << EOF
# Relatório de Coleta IA - macOS

**Timestamp:** $TIMESTAMP
**Hostname:** $(hostname)
**Platform:** macOS

## Resumo Executivo

Este relatório contém a coleta completa de configurações de IA no sistema macOS.

## Relatórios Individuais

- System Prompt: \`system_prompt_${TIMESTAMP}.json\`
- Cursor Config: \`cursor_config_${TIMESTAMP}.json\`
- ChatGPT Config: \`chatgpt_config_${TIMESTAMP}.json\`
- IA Tools: \`ia_tools_${TIMESTAMP}.json\`
- API Keys: \`api_keys_${TIMESTAMP}.json\`
- Environment: \`environment_${TIMESTAMP}.json\`
- IDE Extensions: \`ide_extensions_${TIMESTAMP}.json\`

## Relatório Consolidado

\`consolidated_${TIMESTAMP}.json\`

## Próximos Passos

1. Revisar configurações coletadas
2. Aplicar system prompt onde necessário
3. Configurar ferramentas faltantes
4. Validar configurações

---
*Gerado automaticamente pelo sistema de coleta IA*
EOF

echo ""
echo "============================================"
echo "✅ Coleta completa finalizada!"
echo "============================================"
echo ""
echo "📄 Relatórios gerados em: $REPORTS_DIR"
echo "📊 JSON Consolidado: consolidated_${TIMESTAMP}.json"
echo "📝 Markdown Report: report_${TIMESTAMP}.md"
echo ""

