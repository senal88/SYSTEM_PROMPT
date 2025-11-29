#!/usr/bin/env bash

################################################################################
# 🗑️ REMOVER REFERÊNCIAS OBSOLETAS - icloud_control
# Remove todas as referências à pasta obsoleta icloud_control
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Limpar referências obsoletas e atualizar para estrutura centralizada
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

# Diretório centralizado para logs
LOGS_DIR="${HOME}/Dotfiles/logs"
ICLOUD_CONTROL_DIR="${HOME}/Dotfiles/icloud_control"

# Criar estrutura centralizada se não existir
mkdir -p "${LOGS_DIR}"
mkdir -p "${ICLOUD_CONTROL_DIR}"

# Padrão de substituição
OLD_PATTERN="/Users/luiz.sena88/icloud_control"
NEW_LOGS="${LOGS_DIR}"
NEW_CONTROL="${ICLOUD_CONTROL_DIR}"

# Encontrar e substituir
find "${GLOBAL_DIR}" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.sh" \) -exec grep -l "icloud_control" {} \; | while read -r file; do
    log_info "Atualizando: ${file}"

    # Substituir referências
    sed -i '' \
        -e "s|${OLD_PATTERN}/logs/|${NEW_LOGS}/|g" \
        -e "s|${OLD_PATTERN}/icloud_control/|${NEW_CONTROL}/|g" \
        -e "s|${OLD_PATTERN}/|${ICLOUD_CONTROL_DIR}/|g" \
        -e "s|icloud_control|icloud_control|g" \
        -e "s|iCloud Control|iCloud Control|g" \
        "${file}" 2>/dev/null || \
    sed -i \
        -e "s|${OLD_PATTERN}/logs/|${NEW_LOGS}/|g" \
        -e "s|${OLD_PATTERN}/icloud_control/|${NEW_CONTROL}/|g" \
        -e "s|${OLD_PATTERN}/|${ICLOUD_CONTROL_DIR}/|g" \
        -e "s|icloud_control|icloud_control|g" \
        -e "s|iCloud Control|iCloud Control|g" \
        "${file}"

    log_success "Atualizado: ${file}"
done

log_success "Todas as referências obsoletas foram removidas!"
log_info "Estrutura centralizada criada em:"
log_info "  - Logs: ${LOGS_DIR}"
log_info "  - iCloud Control: ${ICLOUD_CONTROL_DIR}"

