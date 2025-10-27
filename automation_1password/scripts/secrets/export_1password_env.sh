#!/bin/bash
# =====================================================
# 🧩 export_1password_env.sh
# Reconstrói arquivos .env utilizando placeholders OP://
# Compatível com macOS e Ubuntu, sem expor credenciais.
# =====================================================

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="${ROOT_DIR}/configs/template.env.op"
OUTPUT_ENV="${ROOT_DIR}/configs/.env.generated"
OUTPUT_BASE64="${ROOT_DIR}/configs/.env.generated.base64"

log() {
  printf '[%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

require_cli() {
  if ! command -v op >/dev/null 2>&1; then
    log "❌ 1Password CLI não encontrado. Instale em https://developer.1password.com/docs/cli/get-started/"
    exit 1
  fi
}

require_session() {
  if ! op account list >/dev/null 2>&1; then
    log "⚠️ Nenhuma sessão ativa. Execute 'op signin --account <apelido>' antes de rodar este script."
    exit 2
  fi
}

inject_env() {
  if [[ ! -f "$TEMPLATE" ]]; then
    log "❌ Template ${TEMPLATE} não localizado."
    exit 3
  fi

  local tmp_file
  tmp_file="$(mktemp)"
  op inject -i "$TEMPLATE" -o "$tmp_file"
  mv "$tmp_file" "$OUTPUT_ENV"
  chmod 600 "$OUTPUT_ENV"

  base64 "$OUTPUT_ENV" > "$OUTPUT_BASE64"
}

require_cli
require_session
inject_env

log "✅ Variáveis exportadas para:"
log "   - ${OUTPUT_ENV}"
log "   - ${OUTPUT_BASE64}"
log "Use 'source ${OUTPUT_ENV}' ou 'op run --env-file ${OUTPUT_ENV}' nos scripts locais."
