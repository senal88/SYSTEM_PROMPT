#!/usr/bin/env bash

################################################################################
# 📅 ATUALIZAR VERSÕES E DATAS
# Atualiza versão e data em todos os arquivos seguindo padrão do llms-full.txt
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Padronizar versão e data em todos os arquivos
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
VERSION="2.0.0"
DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Padrão de versão e data (baseado em llms-full.txt)
VERSION_PATTERN="\*\*Versão:\*\*"
DATE_PATTERN="\*\*Data:\*\*"
LAST_UPDATE_PATTERN="\*\*Última Atualização:\*\*"

# Atualizar arquivos markdown
find "${GLOBAL_DIR}" -type f -name "*.md" ! -path "*/prompts_temp/*" ! -path "*/audit/*" | while read -r file; do
    # Verificar se arquivo tem cabeçalho de versão/data
    if grep -q "${VERSION_PATTERN}\|${DATE_PATTERN}\|${LAST_UPDATE_PATTERN}" "${file}" 2>/dev/null; then
        # Atualizar versão
        sed -i '' "s/${VERSION_PATTERN}.*/${VERSION_PATTERN} ${VERSION}/g" "${file}" 2>/dev/null || \
        sed -i "s/${VERSION_PATTERN}.*/${VERSION_PATTERN} ${VERSION}/g" "${file}"

        # Atualizar data
        sed -i '' "s/${DATE_PATTERN}.*/${DATE_PATTERN} ${DATE}/g" "${file}" 2>/dev/null || \
        sed -i "s/${DATE_PATTERN}.*/${DATE_PATTERN} ${DATE}/g" "${file}"

        # Atualizar última atualização
        sed -i '' "s/${LAST_UPDATE_PATTERN}.*/${LAST_UPDATE_PATTERN} ${DATE}/g" "${file}" 2>/dev/null || \
        sed -i "s/${LAST_UPDATE_PATTERN}.*/${LAST_UPDATE_PATTERN} ${DATE}/g" "${file}"

        echo "✅ Atualizado: ${file}"
    fi
done

echo ""
echo "✅ Versões e datas atualizadas!"

