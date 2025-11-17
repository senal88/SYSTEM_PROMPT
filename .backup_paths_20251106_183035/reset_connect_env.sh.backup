#!/bin/bash
# ============================================================================
# ♻️ Reset 1Password Connect Environment
# Arquivo: scripts/secrets/reset_connect_env.sh
# Propósito: Remover variáveis que forçam uso do 1Password Connect, permitindo `op signin`.
# ============================================================================

_reset_env_is_sourced=0
if [ -n "${ZSH_VERSION:-}" ]; then
  case $ZSH_EVAL_CONTEXT in *:file) _reset_env_is_sourced=1;; esac
elif [ -n "${BASH_VERSION:-}" ]; then
  [[ "${BASH_SOURCE[0]:-}" != "$0" ]] && _reset_env_is_sourced=1
else
  # Fallback: assume sourced if 'return' works
  (return 0 2>/dev/null) && _reset_env_is_sourced=1
fi

if [ $_reset_env_is_sourced -eq 0 ]; then
  set -euo pipefail
fi

unset OP_CONNECT_HOST
unset OP_CONNECT_TOKEN
unset OP_CONNECT_TOKEN_MACOS
unset OP_CONNECT_TOKEN_VPS
unset OP_FORMAT

if [[ "${1:-}" != "--quiet" ]]; then
  echo "♻️  Variáveis do 1Password Connect limpas. CLI pronto para 'op signin'."
fi

if [ $_reset_env_is_sourced -eq 1 ]; then
  unset _reset_env_is_sourced
  return 0 2>/dev/null
fi

unset _reset_env_is_sourced
