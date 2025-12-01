#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# VERIFICAÇÃO DE SECRETS RESIDUAIS NO REPOSITÓRIO
#
# Objetivo:
#   - Procurar padrões típicos de secrets que não devem constar no repositório.
#   - Focar especialmente em:
#       - Stripe keys (sk_test_, sk_live_)
#       - Referências evidentes a tokens não protegidos
#       - Termos sensíveis em contexto de autenticação
#
# Observações:
#   - Referências op:// são consideradas seguras (padrão 1Password) e não são
#     tratadas como vazamento, mas ainda podem ser listadas para conferência.
###############################################################################

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

cd "${ROOT_DIR}"

echo "=================================================="
echo "VERIFICAÇÃO DE SECRETS RESIDUAIS"
echo "Root do repositório: ${ROOT_DIR}"
echo "Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="
echo

# Função auxiliar para escolher grep ou rg
run_search() {
  local pattern="$1"
  local description="$2"

  echo "--------------------------------------------------"
  echo "[PESQUISA] ${description}"
  echo "Padrão: ${pattern}"
  echo "--------------------------------------------------"

  if command -v rg >/dev/null 2>&1; then
    rg --hidden --glob '!.git' "${pattern}" || echo "[INFO] Nenhuma ocorrência encontrada para: ${pattern}"
  else
    # grep recursivo padrão, ignorando .git
    # shellcheck disable=SC2038
    find . -path ./.git -prune -o -type f -print0 \
      | xargs -0 grep -nH -E "${pattern}" || echo "[INFO] Nenhuma ocorrência encontrada para: ${pattern}"
  fi

  echo
}

###############################################################################
# Padrões específicos de interesse (ajustar conforme necessidade)
###############################################################################

# 1) Stripe keys típicas
run_search "sk_test_[0-9A-Za-z]+"        "Stripe Test Keys (sk_test_)"
run_search "sk_live_[0-9A-Za-z]+"        "Stripe Live Keys (sk_live_)"

# 2) Referências literais óbvias a 1Password token (caso tenham ficado)
run_search "1password"                   "Ocorrências de '1password' (case-insensitive possível vazamento)"
run_search "OP_SESSION_"                 "Possíveis variáveis de sessão do 1Password CLI"

# 3) Padrões genéricos de 'api_key' e 'token'
run_search "api[_-]?key"                 "Ocorrências genéricas de 'api_key'"
run_search "access[_-]?token"            "Ocorrências genéricas de 'access_token'"
run_search "secret[_-]?key"              "Ocorrências genéricas de 'secret_key'"

# 4) Referências op:// (para conferência – não são vazamento por si só)
run_search "op://[A-Za-z0-9_\-./]+"      "Referências op:// (devem ser 1Password, revisar apenas convenção)"

echo "=================================================="
echo "VERIFICAÇÃO DE SECRETS RESIDUAIS CONCLUÍDA"
echo "=================================================="
