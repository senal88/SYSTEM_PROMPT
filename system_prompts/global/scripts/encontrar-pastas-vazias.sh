#!/usr/bin/env bash
set -euo pipefail

# Script: encontrar-pastas-vazias.sh
# Objetivo:
# - Identificar e listar todos os diretórios vazios no projeto.
# - Isso ajuda a manter a estrutura do projeto limpa e organizada.

BASE_DIR="${HOME}/dotfiles/system_prompts/global"

echo "=================================================="
echo "Buscando por diretórios vazios em: ${BASE_DIR}"
echo "=================================================="
echo

EMPTY_DIRS=$(find "${BASE_DIR}" -type d -empty)

if [ -z "${EMPTY_DIRS}" ]; then
  echo "Nenhum diretório vazio encontrado."
else
  echo "Os seguintes diretórios estão vazios:"
  echo "${EMPTY_DIRS}"
fi

echo
echo "=================================================="
echo "Busca por diretórios vazios concluída."
echo "=================================================="
