#!/usr/bin/env bash
set -euo pipefail

# Script: atualizar-nomes-governanca.sh
# Objetivo:
# - Renomear arquivos sob governança para incluir:
#   - Versão explícita: vMAJOR.MINOR.PATCH
#   - Data de referência: AAAAMMDD
#
# Parâmetros a ajustar antes da execução:
#   - VERSAO_REF: versão que será aplicada na nomenclatura (ex.: 1.0.0)
#   - DATA_REF: data de referência na forma AAAAMMDD (ex.: 20251130)
#
# Comportamento:
#   - DRY_RUN=1: apenas exibe comandos de renomeação.
#   - DRY_RUN=0: aplica os renomes de fato.

BASE_DIR="${HOME}/dotfiles/system_prompts/global"

VERSAO_REF="1.0.0"            # ex.: 1.0.0
DATA_REF="20251130"       # ex.: 20251130

DRY_RUN="${DRY_RUN:-1}"  # Default to 1 (dry run) if not set externally

# Conjuntos de padrões de arquivos sob governança
# Ajuste conforme necessário, mantendo apenas caminhos existentes.
TARGET_PATTERNS=(
  "docs/*.md"
  "docs/checklists/*.md"
  "docs/corrections/*.md"
  "docs/summaries/*.md"
  "consolidated/*.txt"
  "audit/*/*/*.md"
  "audit/*/*/*.txt"
  "scripts/*.sh"
  "STATUS*.txt"
)

echo "=================================================="
echo "ATUALIZAÇÃO DE NOMES SOB GOVERNANÇA"
echo "BASE_DIR=${BASE_DIR}"
echo "VERSAO_REF=v${VERSAO_REF}"
echo "DATA_REF=${DATA_REF}"
echo "DRY_RUN=${DRY_RUN}"
echo "=================================================="
echo

for pattern in "${TARGET_PATTERNS[@]}"; do
  # Expansão de glob sob BASE_DIR
  for file in ${BASE_DIR}/${pattern}; do
    # Se o glob não bater em nada, o literal volta; ignorar não-arquivos
    if [ ! -f "${file}" ]; then
      continue
    fi

    filename="$(basename "${file}")"
    dir="$(dirname "${file}")"

    # Se já contém data e versão alvo, não renomear
    if [[ "${filename}" == *"${DATA_REF}"* && "${filename}" == *"v${VERSAO_REF}"* ]]; then
      echo "SKIP (já contém v${VERSAO_REF} e ${DATA_REF}): ${file}"
      continue
    fi

    # Separar base e extensão
    if [[ "${filename}" == *.* ]]; then
      base="${filename%.*}"
      ext=".${filename##*.}"
    else
      base="${filename}"
      ext=""
    fi

    # Novo nome: base_vVERSAO_REF_DATA_REF.ext
    new_name="${base}_v${VERSAO_REF}_${DATA_REF}${ext}"
    new_path="${dir}/${new_name}"

    if (( DRY_RUN )); then
      echo "DRY-RUN: mv \"${file}\" \"${new_path}\""
    else
      mv "${file}" "${new_path}"
      echo "RENOMEADO: \"${file}\" -> \"${new_path}\""
    fi
  done
done

echo
echo "=================================================="
echo "Processo de atualização de nomes concluído."
echo "DRY_RUN=${DRY_RUN}"
echo "=================================================="
