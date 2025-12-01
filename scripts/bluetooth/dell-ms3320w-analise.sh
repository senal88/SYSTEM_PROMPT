#!/bin/bash
# Script de Análise de Logs do Mouse Bluetooth Dell MS3320W
# Objetivo: Analisar padrões de desconexão e gerar relatório
# Autor: Sistema de Automação Dotfiles
# Data: $(date +%Y-%m-%d)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${HOME}/.local/logs/bluetooth"
REPORT_DIR="${LOG_DIR}/reports"
REPORT_FILE="${REPORT_DIR}/analise-$(date +%Y%m%d_%H%M%S).md"

# Criar diretórios
mkdir -p "${REPORT_DIR}"

# Função de logging
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}"
}

log "INFO" "=== INÍCIO DA ANÁLISE DE LOGS ==="

# Criar relatório
cat > "${REPORT_FILE}" <<EOF
# Análise de Logs - Mouse Bluetooth Dell MS3320W

**Data da Análise:** $(date '+%Y-%m-%d %H:%M:%S')
**Período Analisado:** Últimas 24 horas

---

## 1. Resumo Executivo

EOF

# Contar eventos de desconexão
DISCONNECT_COUNT=$(find "${LOG_DIR}" -name "dell-ms3320w-*.log" -mtime -1 -exec grep -c "DESCONEXÃO DETECTADA\|disconnected" {} \; 2>/dev/null | awk '{s+=$1} END {print s+0}')
RECONNECT_COUNT=$(find "${LOG_DIR}" -name "dell-ms3320w-*.log" -mtime -1 -exec grep -c "RECONEXÃO BEM-SUCEDIDA\|connected" {} \; 2>/dev/null | awk '{s+=$1} END {print s+0}')

cat >> "${REPORT_FILE}" <<EOF
- **Total de Desconexões Detectadas:** ${DISCONNECT_COUNT}
- **Total de Reconexões Bem-Sucedidas:** ${RECONNECT_COUNT}
- **Taxa de Sucesso de Reconexão:** $(if [ $DISCONNECT_COUNT -gt 0 ]; then echo "scale=2; $RECONNECT_COUNT * 100 / $DISCONNECT_COUNT" | bc; else echo "N/A"; fi)%

---

## 2. Padrões de Desconexão

EOF

# Analisar horários de desconexão
log "INFO" "Analisando padrões temporais..."
cat >> "${REPORT_FILE}" <<EOF
### 2.1 Distribuição por Horário

\`\`\`
EOF

find "${LOG_DIR}" -name "dell-ms3320w-*.log" -mtime -1 -exec grep -h "DESCONEXÃO DETECTADA" {} \; 2>/dev/null | \
    awk '{print $2}' | \
    cut -d: -f1 | \
    sort | \
    uniq -c | \
    sort -rn >> "${REPORT_FILE}" || echo "Nenhum dado disponível" >> "${REPORT_FILE}"

cat >> "${REPORT_FILE}" <<EOF
\`\`\`

---

## 3. Análise de Causas

EOF

# Analisar causas comuns
log "INFO" "Analisando causas de desconexão..."

cat >> "${REPORT_FILE}" <<EOF
### 3.1 Erros Mais Frequentes

\`\`\`
EOF

find "${LOG_DIR}" -name "dell-ms3320w-*.log" -mtime -1 -exec grep -h "ERROR\|WARN\|fail\|error" {} \; 2>/dev/null | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -20 >> "${REPORT_FILE}" || echo "Nenhum erro encontrado" >> "${REPORT_FILE}"

cat >> "${REPORT_FILE}" <<EOF
\`\`\`

---

## 4. Estatísticas de Conexão

EOF

# Analisar arquivo de status se existir
if [ -f "${LOG_DIR}/dell-ms3320w-status.json" ]; then
    log "INFO" "Analisando arquivo de status..."
    cat >> "${REPORT_FILE}" <<EOF
### 4.1 Status Atual

\`\`\`json
$(cat "${LOG_DIR}/dell-ms3320w-status.json")
\`\`\`

EOF
fi

cat >> "${REPORT_FILE}" <<EOF
---

## 5. Recomendações

EOF

# Gerar recomendações baseadas na análise
if [ $DISCONNECT_COUNT -gt 10 ]; then
    cat >> "${REPORT_FILE}" <<EOF
⚠️ **ALTA FREQUÊNCIA DE DESCONEXÕES DETECTADA**

**Ações Recomendadas:**
1. Verificar bateria do mouse
2. Verificar interferências de sinal (WiFi, outros dispositivos Bluetooth)
3. Atualizar firmware do mouse (se disponível)
4. Verificar distância entre mouse e computador
5. Considerar usar receptor USB (se disponível) em vez de Bluetooth

EOF
elif [ $DISCONNECT_COUNT -gt 5 ]; then
    cat >> "${REPORT_FILE}" <<EOF
⚠️ **FREQUÊNCIA MODERADA DE DESCONEXÕES**

**Ações Recomendadas:**
1. Monitorar padrões de desconexão
2. Verificar configurações de energia do macOS
3. Verificar se há outros dispositivos Bluetooth interferindo

EOF
else
    cat >> "${REPORT_FILE}" <<EOF
✅ **FREQUÊNCIA BAIXA DE DESCONEXÕES**

O sistema está funcionando dentro dos parâmetros esperados.

EOF
fi

cat >> "${REPORT_FILE}" <<EOF
---

## 6. Próximos Passos

1. Continuar monitoramento por mais 24-48 horas
2. Implementar melhorias baseadas nos padrões identificados
3. Ajustar intervalos de verificação se necessário
4. Considerar ajustes nas configurações de energia do sistema

---

**Relatório gerado automaticamente pelo sistema de monitoramento**
**Para mais detalhes, consulte os logs em:** \`${LOG_DIR}\`

EOF

log "INFO" "Relatório gerado: ${REPORT_FILE}"

# Exibir resumo
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  ANÁLISE CONCLUÍDA"
echo "═══════════════════════════════════════════════════════════════"
echo "Relatório completo: ${REPORT_FILE}"
echo ""
echo "Resumo:"
echo "  - Desconexões: ${DISCONNECT_COUNT}"
echo "  - Reconexões: ${RECONNECT_COUNT}"
echo "═══════════════════════════════════════════════════════════════"

# Abrir relatório se possível
if command -v open &> /dev/null; then
    open "${REPORT_FILE}"
fi

