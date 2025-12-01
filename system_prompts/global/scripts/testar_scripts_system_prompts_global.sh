#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# TESTE BÁSICO DE SCRIPTS EM system_prompts/global/scripts/
#
# Objetivo:
#   - Listar scripts .sh no diretório system_prompts/global/scripts/
#   - Fazer verificação sintática básica:
#       - Se shebang contiver bash  -> usar "bash -n"
#       - Se shebang contiver zsh   -> usar "zsh -n"
#       - Caso não haja shebang ou seja diferente, apenas listar.
###############################################################################

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPTS_DIR="${ROOT_DIR}/system_prompts/global/scripts"

echo "=================================================="
echo "TESTE DE SCRIPTS – system_prompts/global/scripts"
echo "Root do repositório : ${ROOT_DIR}"
echo "Diretório de scripts: ${SCRIPTS_DIR}"
echo "Data/Hora           : $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="
echo

if [ ! -d "${SCRIPTS_DIR}" ]; then
  echo "[ERRO] Diretório ${SCRIPTS_DIR} não existe."
  exit 1
fi

shopt -s nullglob

SCRIPT_FILES=( "${SCRIPTS_DIR}"/*.sh )

if [ ${#SCRIPT_FILES[@]} -eq 0 ]; then
  echo "[INFO] Nenhum arquivo .sh encontrado em ${SCRIPTS_DIR}."
  exit 0
fi

for script in "${SCRIPT_FILES[@]}"; do
  echo "--------------------------------------------------"
  echo "[ANÁLISE] ${script}"
  echo "--------------------------------------------------"

  # Detectar shebang
  first_line="$(head -n 1 "${script}" || true)"

  if [[ "${first_line}" == "#!"*bash* ]]; then
    echo "[INFO] Shebang detectado: bash"
    if command -v bash >/dev/null 2>&1; then
      if bash -n "${script}"; then
        echo "[OK] Sintaxe bash válida."
      else
        echo "[ERRO] Problema de sintaxe detectado (bash -n)."
      fi
    else
      echo "[AVISO] bash não encontrado no PATH; teste sintático não executado."
    fi
  elif [[ "${first_line}" == "#!"*zsh* ]]; then
    echo "[INFO] Shebang detectado: zsh"
    if command -v zsh >/dev/null 2>&1; then
      if zsh -n "${script}"; then
        echo "[OK] Sintaxe zsh válida."
      else
        echo "[ERRO] Problema de sintaxe detectado (zsh -n)."
      fi
    else
      echo "[AVISO] zsh não encontrado no PATH; teste sintático não executado."
    fi
  else
    echo "[INFO] Shebang não indica bash/zsh ou está ausente. Arquivo apenas listado."
  fi

  echo
done

echo "=================================================="
echo "VERIFICAÇÃO BÁSICA DE SCRIPTS CONCLUÍDA"
echo "=================================================="
