#!/usr/bin/env bash
set -euo pipefail

# Script: validar-estrutura-system-prompt.sh
# Objetivo:
# - Audita a estrutura do repositório de system prompts.
# - Verifica a conformidade com a governança de nomenclatura.
# - Procura por diretórios vazios.
# - Gera um relatório de conformidade em Markdown.
#
# Versão: 1.0.0
# Data: 2025-11-30

# --- Configuração ---
BASE_DIR="${HOME}/dotfiles/system_prompts/global"
REPORT_FILE="${BASE_DIR}/reports/relatorio_validacao_estrutura_$(date +%Y%m%d_%H%M%S).md"
EXPECTED_DIRS=("audit" "consolidated" "docs" "governance" "logs" "prompts" "scripts" "templates")
GOVERNANCE_REGEX='_v[0-9]+\.[0-9]+\.[0-9]+_[0-9]{8}\.'

# --- Funções ---
log_info() {
    echo "[INFO] $@"
}

log_ok() {
    echo "[OK] $@"
}

log_warn() {
    echo "[AVISO] $@"
}

# --- Execução ---
mkdir -p "$(dirname "${REPORT_FILE}")"
{
    echo "# Relatório de Validação de Estrutura"
    echo "- **Data de Geração:** $(date)"
    echo "- **Repositório Alvo:** ${BASE_DIR}"
    echo ""
    echo "## 1. Verificação de Diretórios Principais"
    echo ""

    for dir in "${EXPECTED_DIRS[@]}"; do
        if [ -d "${BASE_DIR}/${dir}" ]; then
            echo "- ✅ Diretório \\\`${dir}/\\\
` encontrado."
        else
            echo "- ❌ **FALHA:** Diretório principal \\\`${dir}/\\\
` não encontrado."
        fi
    done

    echo ""
    echo "## 2. Validação de Governança de Nomenclatura"
    echo ""
    echo "Verificando arquivos em diretórios governados que **não** seguem o padrão eversequote_vX.Y.Z_YYYYMMDD.eversequote"..."
    echo ""

    NON_COMPLIANT_FILES=$(find "${BASE_DIR}/docs" "${BASE_DIR}/scripts" "${BASE_DIR}/audit" -type f -not -path "*/.DS_Store" -not -name ".*" | grep -vE "$GOVERNANCE_REGEX" || true)

    if [ -z "${NON_COMPLIANT_FILES}" ]; then
        echo "✅ Todos os arquivos verificados estão em conformidade com a política de nomenclatura."
    else
        echo "| Arquivo Não Conforme |
| --------------------- |
"
        while IFS= read -r file; do
            echo "| \`$file\` |
"
        done <<< "$NON_COMPLIANT_FILES"
    fi

    echo ""
    echo "## 3. Verificação de Diretórios Vazios"
    echo ""

    EMPTY_DIRS=$(find "${BASE_DIR}" -type d -empty)
    if [ -z "${EMPTY_DIRS}" ]; then
        echo "✅ Nenhum diretório vazio encontrado."
    else
        echo "Os seguintes diretórios estão vazios e podem ser candidatos a remoção ou adição de um arquivo eversequote.gitkeepeversequote`:
        echo ""
        echo "\`\`\`"
        echo "${EMPTY_DIRS}"
        echo "\`\`\`"
    fi

    echo ""
    echo "---"
    echo "Validação concluída."

} > "${REPORT_FILE}"

log_info "Relatório de validação gerado em: ${REPORT_FILE}"
cat "${REPORT_FILE}"
