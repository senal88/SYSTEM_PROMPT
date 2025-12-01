#!/usr/bin/env bash
set -euo pipefail

# Script: atualizar-nomes-governanca.sh (v1.1.0)
# Objetivo:
# - Renomear arquivos sob governança para incluir versão e data.
# - Versão refatorada para maior robustez e cobertura de caminhos.
#
# Comportamento:
# - DRY_RUN=1 (ou não definido): apenas exibe comandos.
# - DRY_RUN=0: aplica as renomeações.

# --- Configuração ---
BASE_DIR="${HOME}/dotfiles/system_prompts/global"
DRY_RUN="${DRY_RUN:-1}" # Default to 1 (dry run) if not set externally

# Leia a versão e a data do arquivo de versão central, se existir
# Isso centraliza a lógica de versioning.
VERSAO_REF="1.0.0"
DATA_REF="20251130"

# Padrões de arquivos alvo (versão corrigida e expandida)
# Adicionado "audit/*/*.md" e "audit/*/*.txt" para cobrir arquivos na raiz dos runs de auditoria.
TARGET_PATTERNS=(
  "docs/*.md"
  "docs/checklists/*.md"
  "docs/corrections/*.md"
  "docs/summaries/*.md"
  "consolidated/*.txt"
  "audit/*/*.md" # Padrão corrigido
  "audit/*/*.txt" # Padrão corrigido
  "audit/*/*/*.md"
  "audit/*/*/*.txt"
  "scripts/*.sh"
  "scripts/shared/*.sh"
  "scripts/macos/*.sh"
  "scripts/ubuntu/*.sh"
  "prompts/system/*.md"
  "*.md" # Arquivos .md na raiz
)

echo "=================================================="
echo "ATUALIZAÇÃO DE NOMES SOB GOVERNANÇA (v1.1.0)"
echo "  BASE_DIR=${BASE_DIR}"
echo "  VERSAO_REF=v${VERSAO_REF}"
echo "  DATA_REF=${DATA_REF}"
echo "  DRY_RUN=${DRY_RUN}"
echo "=================================================="
echo

for pattern in "${TARGET_PATTERNS[@]}"; do
  # Usar 'find' é mais seguro do que expansão de glob em loop
  # 'shopt -s globstar' também seria uma opção, mas 'find' é mais portável.
  find "${BASE_DIR}" -path "*/${pattern}" -type f 2>/dev/null | while read -r file; do
    
    if [ ! -f "${file}" ]; then
      continue
    fi

    filename="$(basename "${file}")"
    dir="$(dirname "${file}")"

    # Ignorar arquivos que já parecem estar no formato correto
    if [[ "${filename}" =~ _v[0-9]+\.[0-9]+\.[0-9]+_[0-9]{8}\. ]]; then
      continue
    fi
    
    # Ignorar o próprio script
    if [[ "${filename}" == "atualizar-nomes-governanca.sh" ]]; then
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
      if [ -f "${new_path}" ]; then
        echo "AVISO: O arquivo de destino '${new_path}' já existe. Pulando renomeação de '${file}'."
      else
        mv "${file}" "${new_path}"
        echo "RENOMEADO: \"${file}\" -> \"${new_path}\""
      fi
    fi
  done
done

echo

echo "=================================================="
echo "Processo de atualização de nomes concluído."
echo "=================================================="
