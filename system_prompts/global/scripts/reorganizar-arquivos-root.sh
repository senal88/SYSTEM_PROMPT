#!/usr/bin/env bash

################################################################################
# 📁 REORGANIZAR ARQUIVOS DA ROOT
# Move arquivos da root para subdiretórios apropriados
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Manter apenas arquivos padrão na root
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Arquivos permitidos na root
ROOT_ALLOWED=("README.md" ".gitignore" ".git" "CHANGELOG.md")

# Criar estrutura de diretórios
mkdir -p "${GLOBAL_DIR}/docs"
mkdir -p "${GLOBAL_DIR}/docs/checklists"
mkdir -p "${GLOBAL_DIR}/docs/summaries"
mkdir -p "${GLOBAL_DIR}/docs/corrections"
mkdir -p "${GLOBAL_DIR}/prompts"
mkdir -p "${GLOBAL_DIR}/prompts/system"
mkdir -p "${GLOBAL_DIR}/prompts/audit"
mkdir -p "${GLOBAL_DIR}/prompts/revision"
mkdir -p "${GLOBAL_DIR}/consolidated"
mkdir -p "${GLOBAL_DIR}/scripts/legacy"

# Função para obter diretório destino
get_target_dir() {
    local file="$1"
    case "$file" in
        CHECKLIST_*.md)
            echo "docs/checklists/"
            ;;
        RESUMO_*.txt|ESTRUTURA_COMPLETA.txt)
            echo "docs/summaries/"
            ;;
        CORRECAO_*.md|SOLUCAO_*.md)
            echo "docs/corrections/"
            ;;
        INCORPORACAO_*.md)
            echo "docs/"
            ;;
        CURSOR_2.0_SYSTEM_PROMPT_FINAL.md|universal.md|icloud_protection.md)
            echo "prompts/system/"
            ;;
        PROMPT_AUDITORIA_*.md)
            echo "prompts/audit/"
            ;;
        PROMPT_REVISAO_*.md)
            echo "prompts/revision/"
            ;;
        README_VPS.md|README_ARQUITETURA.md|README_COLETAS.md)
            echo "docs/"
            ;;
        ANALISE_ARQUITETURA.md|ARQUITETURA_COLETAS.md)
            echo "docs/"
            ;;
        COMANDOS_FINAIS_*.sh|COMANDOS_FINAIS_*.txt)
            echo "scripts/legacy/"
            ;;
        llms-full.txt|arquitetura-estrutura.txt)
            echo "consolidated/"
            ;;
        GOVERNANCA_E_EXPANSAO.md)
            echo "docs/"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Mover arquivos
cd "${GLOBAL_DIR}"

# Lista de arquivos para mover
FILES_TO_MOVE=(
    "CHECKLIST_1PASSWORD_ATUALIZACAO.md"
    "CHECKLIST_APRIMORAMENTO_PROMPT.md"
    "RESUMO_AUDITORIA_1PASSWORD.txt"
    "RESUMO_INCORPORACAO.txt"
    "ESTRUTURA_COMPLETA.txt"
    "CORRECAO_DEPENDENCIAS_COMPLETA.md"
    "SOLUCAO_HOMEBREW.md"
    "INCORPORACAO_PROMPTS_REVISADOS.md"
    "CURSOR_2.0_SYSTEM_PROMPT_FINAL.md"
    "universal.md"
    "icloud_protection.md"
    "PROMPT_AUDITORIA_VPS.md"
    "PROMPT_REVISAO_MEMORIAS.md"
    "PROMPT_REVISAO_MEMORIAS_CONCISO.md"
    "README_VPS.md"
    "README_ARQUITETURA.md"
    "README_COLETAS.md"
    "ANALISE_ARQUITETURA.md"
    "ARQUITETURA_COLETAS.md"
    "COMANDOS_FINAIS_EXECUTAVEIS.sh"
    "COMANDOS_FINAIS_NORMALIZADOS.txt"
    "llms-full.txt"
    "arquitetura-estrutura.txt"
    "GOVERNANCA_E_EXPANSAO.md"
)

for file in "${FILES_TO_MOVE[@]}"; do
    if [ -f "${file}" ]; then
        target_dir=$(get_target_dir "${file}")
        if [ -n "${target_dir}" ]; then
            full_target="${GLOBAL_DIR}/${target_dir}"
            mkdir -p "${full_target}"
            mv "${file}" "${full_target}/"
            echo "✅ Movido: ${file} → ${target_dir}"
        fi
    fi
done

echo ""
echo "✅ Reorganização concluída!"
echo "📁 Estrutura atualizada"
