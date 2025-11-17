#!/bin/bash
# ============================================================================
# 🔐 Load Secure Environment
# Arquivo: scripts/secrets/load-secure-env.sh
# Propósito: Carregar variáveis de ambiente de forma segura via 1Password CLI
# ============================================================================

set -euo pipefail

ENVIRONMENT="${1:-auto}"
AUTOMATION_ROOT="${AUTOMATION_ROOT:-$HOME/Dotfiles/automation_1password}"
TEMPLATE_ROOT="${TEMPLATE_ROOT:-$AUTOMATION_ROOT/templates/env}"
ENV_DIR="$AUTOMATION_ROOT/env"

if [[ "$ENVIRONMENT" == "auto" ]]; then
  if [[ "$OSTYPE" == darwin* ]]; then
    ENVIRONMENT="macos"
  else
    ENVIRONMENT="vps"
  fi
fi

SHARED_FILE="$ENV_DIR/shared.env"
ENV_FILE="$ENV_DIR/${ENVIRONMENT}.env"
SECRET_TEMPLATE="$TEMPLATE_ROOT/${ENVIRONMENT}.secrets.env.op"

echo "🔐 Carregando variáveis para ambiente: ${ENVIRONMENT^^}"

if ! command -v op >/dev/null 2>&1; then
  echo "❌ 1Password CLI (op) não encontrado no PATH. Instale antes de prosseguir."
  exit 1
fi

if ! op whoami >/dev/null 2>&1; then
  echo "❌ Sessão do 1Password CLI inválida. Execute: eval \"\$(op signin)\""
  exit 1
fi

if [[ ! -f "$SECRET_TEMPLATE" ]]; then
  echo "❌ Template não encontrado: $SECRET_TEMPLATE"
  echo "   → Utilize os arquivos em templates/env/ para definir os itens do vault ${ENVIRONMENT}."
  exit 1
fi

if [[ ! -f "$SHARED_FILE" || ! -f "$ENV_FILE" ]]; then
  echo "❌ Arquivos base de ambiente não encontrados em $ENV_DIR"
  exit 1
fi

TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/op-${ENVIRONMENT}.XXXXXX.env")"
trap 'rm -f "$TEMP_FILE"' EXIT

op inject -i "$SECRET_TEMPLATE" -o "$TEMP_FILE" >/dev/null

set -a
source "$SHARED_FILE"
source "$ENV_FILE"
source "$TEMP_FILE"
set +a

case "$ENVIRONMENT" in
  macos)
    if [[ -n "${OP_CONNECT_TOKEN_MACOS:-}" ]]; then
      export OP_CONNECT_TOKEN="$OP_CONNECT_TOKEN_MACOS"
    fi
    ;;
  vps)
    if [[ -n "${OP_CONNECT_TOKEN_VPS:-}" ]]; then
      export OP_CONNECT_TOKEN="$OP_CONNECT_TOKEN_VPS"
    fi
    ;;
esac

if [[ -n "${OP_CONNECT_TOKEN:-}" && ${#OP_CONNECT_TOKEN} -gt 10 ]]; then
  MASKED_TOKEN="${OP_CONNECT_TOKEN:0:6}********${OP_CONNECT_TOKEN: -4}"
else
  MASKED_TOKEN="(não definido)"
fi
echo "✅ Variáveis carregadas com sucesso!"
echo "   • Vault ativo ..........: $OP_VAULT"
echo "   • Host Connect .........: $OP_CONNECT_HOST"
echo "   • Token (mascarado) ....: $MASKED_TOKEN"
