#!/bin/bash
set -euo pipefail

# ============================================================================
# 1Password - Exportação Completa de Inventário (com UUIDs) + Bootstrap VPS
# Ambiente: VPS Ubuntu (headless, Service Account Token)
# Requisitos: 1Password CLI (op), jq
# Execução: não-interativa, segura e idempotente
# ----------------------------------------------------------------------------
# Funcionalidades:
# - Persiste OP_SERVICE_ACCOUNT_TOKEN em /etc/op/op.env com permissões 600
# - Define OP_VAULT padrão para '1p_vps' (ajuste via flag)
# - Coleta inventário completo (vault_id, item_id, field_id, op_reference)
# - Gera: JSONL, JSON, CSV, Markdown
# - Gera generated_with_uuid.env.op e injeta .env automaticamente
# - Saídas em: ~/1password_inventory/YYYYMMDD_HHMMSS
# ----------------------------------------------------------------------------
# Uso:
#   sudo -E bash scripts/security/export_1password_inventory.sh \
#       --vault-ids "gkps... oa3t... syz4... 7bgo..." \
#       --default-vault "1p_vps" \
#       --token-source env \
#       --inject
#
# Flags:
#   --vault-ids        Lista de IDs de cofres separados por espaço (opcional: se omitido, usa todos visíveis)
#   --default-vault    Nome do vault padrão (default: 1p_vps)
#   --token-source     env|file  (default: env)
#   --token-file       Caminho do arquivo contendo o token (se --token-source file)
#   --inject           Gera e injeta .env a partir do generated_with_uuid.env.op
#   --no-bootstrap     Não persiste variáveis em /etc/op/op.env
#   --output-dir       Diretório base para saídas (default: ~/1password_inventory)
# ============================================================================

# ---------- Configuração padrão ----------
DEFAULT_VAULT_NAME="1p_vps"
TOKEN_SOURCE="env"
TOKEN_FILE=""
BOOTSTRAP="yes"
INJECT_ENV="no"
VAULT_IDS=""
OUTPUT_BASE_DIR="${HOME}/1password_inventory"

# ---------- Utilitários ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info(){ echo -e "${BLUE}[INFO]${NC} $*"; }

# ---------- Parse de argumentos ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault-ids)        VAULT_IDS="$2"; shift 2 ;;
    --default-vault)    DEFAULT_VAULT_NAME="$2"; shift 2 ;;
    --token-source)     TOKEN_SOURCE="$2"; shift 2 ;;
    --token-file)       TOKEN_FILE="$2"; shift 2 ;;
    --inject)           INJECT_ENV="yes"; shift 1 ;;
    --no-bootstrap)     BOOTSTRAP="no"; shift 1 ;;
    --output-dir)       OUTPUT_BASE_DIR="$2"; shift 2 ;;
    *)                  err "Flag desconhecida: $1"; exit 1 ;;
  esac
done

# ---------- Pré-checagens ----------
require_cmd() { command -v "$1" >/dev/null 2>&1 || { err "Comando '$1' não encontrado"; exit 1; }; }
require_cmd op
require_cmd jq

if [[ "${EUID:-$(id -u)}" -ne 0 && "${BOOTSTRAP}" == "yes" ]]; then
  warn "Para persistir variáveis em /etc/op/op.env, execute com sudo -E. Prosseguindo mesmo assim."
fi

# ---------- Resolver token ----------
resolve_token() {
  local token=""
  case "${TOKEN_SOURCE}" in
    env)
      token="${OP_SERVICE_ACCOUNT_TOKEN:-}"
      ;;
    file)
      [[ -n "${TOKEN_FILE}" ]] || { err "--token-file é obrigatório quando --token-source file"; exit 1; }
      [[ -r "${TOKEN_FILE}" ]] || { err "Arquivo de token não legível: ${TOKEN_FILE}"; exit 1; }
      token="$(cat "${TOKEN_FILE}")"
      ;;
    *)
      err "TOKEN_SOURCE inválido: ${TOKEN_SOURCE}"
      exit 1
      ;;
  esac
  [[ -n "${token}" ]] || { err "OP_SERVICE_ACCOUNT_TOKEN ausente"; exit 1; }
  echo "${token}"
}

OP_TOKEN="$(resolve_token)"

# ---------- Bootstrap /etc/op/op.env ----------
bootstrap_env() {
  [[ "${BOOTSTRAP}" == "yes" ]] || { info "Bootstrap desabilitado (--no-bootstrap)"; return; }
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    warn "Sem privilégio root; pulando persistência em /etc/op/op.env"
    return
  fi
  info "Persistindo variáveis em /etc/op/op.env"
  mkdir -p /etc/op && chmod 755 /etc/op
  umask 077
  cat >/etc/op/op.env <<EOF
export OP_SERVICE_ACCOUNT_TOKEN='${OP_TOKEN}'
export OP_VAULT='${DEFAULT_VAULT_NAME}'
EOF
  chmod 600 /etc/op/op.env
  chown root:root /etc/op/op.env
  # /etc/environment (sem export)
  if ! grep -q '^OP_SERVICE_ACCOUNT_TOKEN=' /etc/environment 2>/dev/null || ! grep -q '^OP_VAULT=' /etc/environment 2>/dev/null; then
    info "Atualizando /etc/environment"
    grep -q '^OP_SERVICE_ACCOUNT_TOKEN=' /etc/environment 2>/dev/null || echo "OP_SERVICE_ACCOUNT_TOKEN='${OP_TOKEN}'" >> /etc/environment
    grep -q '^OP_VAULT=' /etc/environment 2>/dev/null || echo "OP_VAULT='${DEFAULT_VAULT_NAME}'" >> /etc/environment
  fi
}

bootstrap_env

# ---------- Preparar ambiente de execução ----------
export OP_SERVICE_ACCOUNT_TOKEN="${OP_TOKEN}"
export OP_VAULT="${DEFAULT_VAULT_NAME}"

# ---------- Resolver VAULT_IDS ----------
if [[ -z "${VAULT_IDS}" ]]; then
  info "Coletando todos os cofres visíveis…"
  VAULT_IDS="$(op vault list --format json | jq -r '.[].id')"
fi

timestamp="$(date +%Y%m%d_%H%M%S)"
OUT_DIR="${OUTPUT_BASE_DIR}/${timestamp}"
mkdir -p "${OUT_DIR}"
info "Diretório de saída: ${OUT_DIR}"

# ---------- Inventário com UUIDs ----------
JSONL="${OUT_DIR}/1p_inventory_uuid.jsonl"
JSON="${OUT_DIR}/1p_inventory_uuid.json"
CSV="${OUT_DIR}/1p_inventory_uuid.csv"
MD="${OUT_DIR}/1p_inventory_uuid.md"
ENV_OP="${OUT_DIR}/generated_with_uuid.env.op"
ENV_FILE="${OUT_DIR}/.env"

: > "${JSONL}"

log "Iniciando coleta de inventário…"
for VAULT_ID in ${VAULT_IDS}; do
  VAULT_NAME="$(op vault get "${VAULT_ID}" --format json | jq -r '.name')"
  info "Vault: ${VAULT_NAME} (${VAULT_ID})"
  op item list --vault "${VAULT_ID}" --format json | jq -cr '.[] | {item_id:.id,item_title:.title}' | \
  while read -r ITEM; do
    IID="$(jq -r '.item_id'   <<<"${ITEM}")"
    ITITLE="$(jq -r '.item_title' <<<"${ITEM}")"
    op item get "${IID}" --vault "${VAULT_ID}" --format json | \
    jq -cr --arg vid "${VAULT_ID}" --arg vname "${VAULT_NAME}" --arg iid "${IID}" --arg ititle "${ITITLE}" '
      (.fields // [])[]? as $f |
      {
        vault_id:   $vid,
        vault_name: $vname,
        item_id:    $iid,
        item_title: $ititle,
        field_id:   ($f.id // ""),
        field_label:($f.label // ""),
        field_purpose:($f.purpose // ""),
        op_reference: ("op://" + $vname + "/" + $ititle + "/" + ($f.label // $f.id // "field"))
      }' >> "${JSONL}"
  done
done

jq -s '.' "${JSONL}" > "${JSON}"
log "Inventário JSON consolidado: ${JSON}"

# ---------- CSV ----------
jq -r '
  ["vault_id","vault_name","item_id","item_title","field_id","field_label","field_purpose","op_reference"],
  (.[] | [
    .vault_id, .vault_name, .item_id, .item_title, .field_id, .field_label, .field_purpose, .op_reference
  ])
  | @csv
' "${JSON}" > "${CSV}"
log "Inventário CSV: ${CSV}"

# ---------- Markdown ----------
jq -r '
  group_by(.vault_name)[] as $vgroup |
  "## Vault: " + ($vgroup[0].vault_name) + " (" + ($vgroup[0].vault_id) + ")\n"
  +
  ( $vgroup
    | group_by(.item_id)[]
    | "### Item: " + (.[0].item_title) + " (" + (.[0].item_id) + ")\n"
      + ( .[]
          | "- " + (.field_label // .field_id)
            + " (" + (.field_id) + ", purpose=" + (.field_purpose) + "): `"
            + (.op_reference) + "`\n"
        ) | add
  ) | @text
' "${JSON}" > "${MD}"
log "Inventário Markdown: ${MD}"

# ---------- generated_with_uuid.env.op ----------
cat > "${ENV_OP}" << 'EOF'
# Gerado automaticamente a partir do inventário 1Password (UUIDs)
# Use: op inject -i generated_with_uuid.env.op -o .env
EOF

jq -r '
  .[] |
  (.item_title | ascii_upcase | gsub("[^A-Z0-9]+";"_")) as $ITEM |
  ((.field_label // .field_id // "FIELD") | ascii_upcase | gsub("[^A-Z0-9]+";"_")) as $FIELD |
  ($ITEM + "_" + $FIELD) as $ENV |
  $ENV + "=" + .op_reference
' "${JSON}" >> "${ENV_OP}"
log "Template .env.op: ${ENV_OP}"

# ---------- Injeção opcional ----------
if [[ "${INJECT_ENV}" == "yes" ]]; then
  info "Injetando variáveis para ${ENV_FILE}"
  op inject -i "${ENV_OP}" -o "${ENV_FILE}"
  chmod 600 "${ENV_FILE}"
  log "Arquivo .env gerado: ${ENV_FILE}"
else
  info "Injeção .env desabilitada (use --inject para habilitar)"
fi

echo
log "Concluído."
info "Saídas:"
echo "  - ${JSONL}"
echo "  - ${JSON}"
echo "  - ${CSV}"
echo "  - ${MD}"
echo "  - ${ENV_OP}"
[[ "${INJECT_ENV}" == "yes" ]] && echo "  - ${ENV_FILE}"
echo
info "Dica: para reutilizar variáveis da service account na sessão atual:"
echo "  source /etc/op/op.env  # se criado com privilégio root"


