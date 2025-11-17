#!/bin/bash
# Script de Análise de Export 1Password
# Analisa CSVs exportados e identifica problemas de nomenclatura, categorias e duplicatas
#
# Uso: ./scripts/analyze-1password-export.sh <arquivo-csv> [--vault-name NOME]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

CSV_FILE="${1:-}"
VAULT_NAME="${2:-unknown}"

if [ -z "$CSV_FILE" ] || [ ! -f "$CSV_FILE" ]; then
    echo -e "${RED}❌ Erro: Arquivo CSV não fornecido ou não encontrado${NC}"
    echo "Uso: $0 <arquivo-csv> [--vault-name NOME]"
    exit 1
fi

# Parse --vault-name se fornecido
if [[ "$*" == *"--vault-name"* ]]; then
    VAULT_NAME=$(echo "$*" | sed -n 's/.*--vault-name \([^ ]*\).*/\1/p')
fi

REPORT_FILE="automation_1password/reports/analysis-$(basename "$CSV_FILE" .csv)-$(date +%Y%m%d_%H%M%S).md"
mkdir -p "$(dirname "$REPORT_FILE")"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ANÁLISE DE EXPORT 1PASSWORD         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Arquivo: ${CSV_FILE}${NC}"
echo -e "${CYAN}Vault: ${VAULT_NAME}${NC}"
echo ""

# Função para processar CSV
process_csv() {
    local csv="$1"

    # Pular header e processar linhas
    tail -n +2 "$csv" | while IFS=',' read -r id title category created updated; do
        # Remover aspas
        id=$(echo "$id" | tr -d '"')
        title=$(echo "$title" | tr -d '"')
        category=$(echo "$category" | tr -d '"')

        echo "$id|$title|$category"
    done
}

# Coletar dados
echo -e "${YELLOW}📊 Coletando dados...${NC}"
DATA=$(process_csv "$CSV_FILE")
TOTAL_ITEMS=$(echo "$DATA" | wc -l | tr -d ' ')

# Análise de problemas
echo -e "${YELLOW}🔍 Analisando problemas...${NC}"

# 1. Erros de digitação
TYPO_ERRORS=$(echo "$DATA" | grep -iE "(ANTRHOPIC|ANTHROPIC)" | grep -i "ANTRHOPIC" || true)

# 2. Nomenclaturas inconsistentes
INCONSISTENT_NAMES=$(echo "$DATA" | awk -F'|' '{print $2}' | grep -iE "(api_key|api-key|API_KEY|Api_Key)" | sort | uniq || true)

# 3. Categorias incorretas
WRONG_CATEGORIES=$(echo "$DATA" | awk -F'|' '$3 == "LOGIN" && ($2 ~ /API|TOKEN|KEY/) {print $0}' || true)

# 4. Duplicatas (mesmo nome, diferentes IDs)
DUPLICATES=$(echo "$DATA" | awk -F'|' '{print $2}' | sort | uniq -d || true)

# 5. Itens sem sufixo de ambiente mas que deveriam ter
MISSING_ENV=$(echo "$DATA" | awk -F'|' '$2 !~ /_(macos|vps|MACOS|VPS)$/ && $2 ~ /(API_KEY|TOKEN|PASSWORD)/ {print $0}' || true)

# 6. Categorias por tipo
CATEGORY_STATS=$(echo "$DATA" | awk -F'|' '{print $3}' | sort | uniq -c | sort -rn)

# Gerar relatório
cat > "$REPORT_FILE" <<EOF
# Relatório de Análise - 1Password Export

**Data:** $(date)
**Vault:** ${VAULT_NAME}
**Arquivo:** $(basename "$CSV_FILE")
**Total de Itens:** ${TOTAL_ITEMS}

---

## 📊 Estatísticas Gerais

### Distribuição por Categoria

\`\`\`
${CATEGORY_STATS}
\`\`\`

---

## ❌ Problemas Identificados

### 1. Erros de Digitação

$(if [ -n "$TYPO_ERRORS" ]; then
    echo "$TYPO_ERRORS" | while IFS='|' read -r id title category; do
        echo "- **$title** (ID: $id)"
        echo "  - Categoria atual: $category"
        echo "  - Problema: Erro de digitação (ANTRHOPIC → ANTHROPIC)"
        echo "  - Ação: Renomear para ANTHROPIC_API_KEY"
    done
else
    echo "✅ Nenhum erro de digitação encontrado"
fi)

### 2. Nomenclaturas Inconsistentes

$(if [ -n "$INCONSISTENT_NAMES" ]; then
    echo "Itens com variações de nomenclatura:"
    echo ""
    echo "$INCONSISTENT_NAMES" | while read name; do
        echo "- $name"
    done
else
    echo "✅ Nomenclaturas consistentes"
fi)

### 3. Categorias Incorretas

$(if [ -n "$WRONG_CATEGORIES" ]; then
    echo "$WRONG_CATEGORIES" | while IFS='|' read -r id title category; do
        echo "- **$title** (ID: $id)"
        echo "  - Categoria atual: $category"
        echo "  - Problema: API Key/Token classificado como LOGIN"
        echo "  - Ação: Alterar categoria para API_CREDENTIAL"
    done
else
    echo "✅ Categorias corretas"
fi)

### 4. Duplicatas

$(if [ -n "$DUPLICATES" ]; then
    echo "Itens com nomes duplicados:"
    echo ""
    echo "$DUPLICATES" | while read name; do
        echo "- **$name**"
        echo "$DATA" | grep "|$name|" | while IFS='|' read -r id title category; do
            echo "  - ID: $id, Categoria: $category"
        done
    done
else
    echo "✅ Nenhuma duplicata encontrada"
fi)

### 5. Itens Sem Sufixo de Ambiente

$(if [ -n "$MISSING_ENV" ]; then
    echo "$MISSING_ENV" | head -10 | while IFS='|' read -r id title category; do
        echo "- **$title** (ID: $id)"
        echo "  - Categoria: $category"
        echo "  - Problema: Falta sufixo de ambiente (_macos ou _vps)"
        echo "  - Recomendação: Adicionar sufixo ou usar tags"
    done
    if [ $(echo "$MISSING_ENV" | wc -l) -gt 10 ]; then
        echo ""
        echo "... e mais $(($(echo "$MISSING_ENV" | wc -l) - 10)) itens"
    fi
else
    echo "✅ Todos os itens têm sufixo de ambiente ou são compartilhados"
fi)

---

## 📋 Recomendações

### Prioridade Alta
1. Corrigir erros de digitação (ANTRHOPIC → ANTHROPIC)
2. Consolidar duplicatas (GOOGLE_API_KEY vs GEMINI_API_KEY)
3. Corrigir categorias incorretas (LOGIN → API_CREDENTIAL)

### Prioridade Média
4. Padronizar nomenclaturas (usar SERVICE_TYPE_ENV)
5. Adicionar sufixos de ambiente onde necessário
6. Implementar sistema de tags

### Prioridade Baixa
7. Revisar e consolidar itens similares
8. Documentar padrões estabelecidos

---

## 🔄 Próximos Passos

1. Revisar este relatório
2. Executar script de migração para corrigir problemas
3. Validar itens após migração
4. Documentar padrões finais

---

**Relatório gerado em:** $(date)
EOF

echo -e "${GREEN}✅ Relatório gerado: ${REPORT_FILE}${NC}"
echo ""
echo -e "${CYAN}📊 Resumo:${NC}"
echo -e "   Total de itens: ${TOTAL_ITEMS}"
echo -e "   Erros de digitação: $(echo "$TYPO_ERRORS" | wc -l | tr -d ' ')"
echo -e "   Categorias incorretas: $(echo "$WRONG_CATEGORIES" | wc -l | tr -d ' ')"
echo -e "   Duplicatas: $(echo "$DUPLICATES" | wc -l | tr -d ' ')"
echo ""

