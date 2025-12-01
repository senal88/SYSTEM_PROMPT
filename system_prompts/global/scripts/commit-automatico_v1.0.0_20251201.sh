#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔄 COMMIT AUTOMÁTICO - Sistema de Commits Sem Intervenção
#
# Realiza commits automáticos de todas as mudanças pendentes
# Agrupa por tipo de mudança e cria commits semânticos
#
# Uso: ./commit-automatico_v1.0.0_20251201.sh [--push] [--dry-run]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Flags
PUSH=false
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --push)
            PUSH=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

cd "${DOTFILES_DIR}"

# Verificar se há mudanças
if [[ -z "$(git status --porcelain)" ]]; then
    log_success "Nenhuma mudança pendente"
    exit 0
fi

log_info "Preparando commits automáticos..."

# Agrupar mudanças por tipo
FEAT_FILES=()
FIX_FILES=()
DOCS_FILES=()
CHORE_FILES=()
SCRIPT_FILES=()
CONFIG_FILES=()

while IFS= read -r file; do
    if [[ -z "${file}" ]]; then
        continue
    fi
    
    status="${file:0:2}"
    filepath="${file:3}"
    
    # Classificar por tipo
    if [[ "${filepath}" =~ \.(sh|py|js|ts)$ ]] || [[ "${filepath}" =~ /scripts/ ]]; then
        if [[ "${filepath}" =~ fix|corrigir|correcao ]]; then
            FIX_FILES+=("${filepath}")
        else
            SCRIPT_FILES+=("${filepath}")
        fi
    elif [[ "${filepath}" =~ \.(md|txt)$ ]] || [[ "${filepath}" =~ /docs/ ]]; then
        DOCS_FILES+=("${filepath}")
    elif [[ "${filepath}" =~ \.(json|yaml|yml|toml|conf|config)$ ]] || [[ "${filepath}" =~ /configs/ ]]; then
        CONFIG_FILES+=("${filepath}")
    elif [[ "${filepath}" =~ feat|feature|novo ]]; then
        FEAT_FILES+=("${filepath}")
    else
        CHORE_FILES+=("${filepath}")
    fi
done <<< "$(git status --porcelain)"

# Fazer commits agrupados
COMMIT_COUNT=0

# Commits de scripts
if [[ ${#SCRIPT_FILES[@]} -gt 0 ]]; then
    log_info "Commitando scripts (${#SCRIPT_FILES[@]} arquivos)..."
    for file in "${SCRIPT_FILES[@]}"; do
        git add "${file}"
    done
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "feat: adicionar/atualizar scripts de automação" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${#SCRIPT_FILES[@]} scripts"
    fi
fi

# Commits de correções
if [[ ${#FIX_FILES[@]} -gt 0 ]]; then
    log_info "Commitando correções (${#FIX_FILES[@]} arquivos)..."
    for file in "${FIX_FILES[@]}"; do
        git add "${file}"
    done
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "fix: corrigir problemas identificados" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${#FIX_FILES[@]} correções"
    fi
fi

# Commits de documentação
if [[ ${#DOCS_FILES[@]} -gt 0 ]]; then
    log_info "Commitando documentação (${#DOCS_FILES[@]} arquivos)..."
    for file in "${DOCS_FILES[@]}"; do
        git add "${file}"
    done
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "docs: atualizar documentação" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${#DOCS_FILES[@]} documentos"
    fi
fi

# Commits de configuração
if [[ ${#CONFIG_FILES[@]} -gt 0 ]]; then
    log_info "Commitando configurações (${#CONFIG_FILES[@]} arquivos)..."
    for file in "${CONFIG_FILES[@]}"; do
        git add "${file}"
    done
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "config: atualizar configurações e integrações" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${#CONFIG_FILES[@]} configurações"
    fi
fi

# Commits de features
if [[ ${#FEAT_FILES[@]} -gt 0 ]]; then
    log_info "Commitando features (${#FEAT_FILES[@]} arquivos)..."
    for file in "${FEAT_FILES[@]}"; do
        git add "${file}"
    done
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "feat: adicionar novas funcionalidades" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${#FEAT_FILES[@]} features"
    fi
fi

# Commits de chore (restante)
if [[ ${#CHORE_FILES[@]} -gt 0 ]]; then
    log_info "Commitando outras mudanças (${#CHORE_FILES[@]} arquivos)..."
    for file in "${CHORE_FILES[@]}"; do
        git add "${file}"
    done
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "chore: atualizar arquivos diversos" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${#CHORE_FILES[@]} arquivos"
    fi
fi

# Commit de tudo que sobrou
REMAINING=$(git status --porcelain | wc -l | tr -d ' ')
if [[ "${REMAINING}" -gt 0 ]]; then
    log_info "Commitando mudanças restantes (${REMAINING} arquivos)..."
    git add -A
    if [[ "${DRY_RUN}" == "false" ]]; then
        git commit -m "chore: atualizar arquivos pendentes - ${TIMESTAMP}" || true
        COMMIT_COUNT=$((COMMIT_COUNT + 1))
    else
        log_warning "[DRY-RUN] Commitaria: ${REMAINING} arquivos restantes"
    fi
fi

# Push se solicitado
if [[ "${PUSH}" == "true" ]] && [[ "${DRY_RUN}" == "false" ]]; then
    log_info "Fazendo push para GitHub..."
    git push origin main 2>&1 || log_warning "Push falhou ou não há mudanças remotas"
fi

log_success "Commits concluídos: ${COMMIT_COUNT}"
if [[ "${DRY_RUN}" == "true" ]]; then
    log_warning "MODO DRY-RUN - Nenhum commit foi realizado"
fi

