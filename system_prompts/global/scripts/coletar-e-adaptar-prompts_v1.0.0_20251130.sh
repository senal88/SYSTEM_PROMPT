#!/usr/bin/env bash

################################################################################
# 🔄 COLETAR E ADAPTAR PROMPTS - Sistema Automatizado
# Coleta prompts existentes e adapta para diferentes engines
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Automatizar coleta e adaptação de prompts
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
GLOBAL_DIR="${DOTFILES_DIR}/system_prompts/global"
PROMPTS_TEMP="${GLOBAL_DIR}/prompts_temp"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# COLETA DE PROMPTS EXISTENTES
# ============================================================================

collect_existing_prompts() {
    print_header "📥 COLETA DE PROMPTS EXISTENTES"

    local STAGE_00="${PROMPTS_TEMP}/stage_00_coleta"
    local COLLECT_LOG="${STAGE_00}/coleta_${TIMESTAMP}.log"

    log_info "Coletando prompts existentes..."

    # Lista de prompts para coletar
    local prompts=(
        "universal.md:Prompt Universal Base"
        "CURSOR_2.0_SYSTEM_PROMPT_FINAL.md:Prompt Cursor 2.0 Completo"
        "PROMPT_REVISAO_MEMORIAS.md:Prompt Revisão Memórias Completo"
        "PROMPT_REVISAO_MEMORIAS_CONCISO.md:Prompt Revisão Memórias Conciso"
        "PROMPT_AUDITORIA_VPS.md:Prompt Auditoria VPS"
        "icloud_protection.md:Política Proteção iCloud"
    )

    {
        echo "======================================="
        echo "COLETA DE PROMPTS - ${TIMESTAMP}"
        echo "======================================="
        echo ""

        for prompt_entry in "${prompts[@]}"; do
            IFS=':' read -r file desc <<< "$prompt_entry"
            local source_file="${GLOBAL_DIR}/${file}"

            if [ -f "${source_file}" ]; then
                log_info "Coletando: ${file} - ${desc}"
                cp "${source_file}" "${STAGE_00}/${file}"
                echo "✅ ${file} - ${desc}" >> "${COLLECT_LOG}"
            else
                log_warning "Arquivo não encontrado: ${file}"
                echo "⚠️ ${file} - NÃO ENCONTRADO" >> "${COLLECT_LOG}"
            fi
        done

        echo ""
        echo "======================================="
        echo "Coleta concluída: $(date)"
        echo "======================================="
    } | tee "${COLLECT_LOG}"

    log_success "Coleta concluída: ${STAGE_00}"
}

# ============================================================================
# ADAPTAÇÃO PARA ENGINES
# ============================================================================

adapt_for_cli() {
    local source="$1"
    local target="$2"
    local name="$3"

    cat > "${target}" << EOF
# ${name} - CLI/Terminal Optimized

**Versão:** 1.0.0
**Engine:** CLI/Terminal
**Data:** $(date '+%Y-%m-%d')
**Status:** Adaptado

---

## 🎯 CONTEXTO DE USO

Este prompt foi adaptado para uso em:
- Shell scripts (bash/zsh)
- Terminal automation
- MCP agents
- CLI tools

## 📋 PROMPT

$(cat "${source}")

---

**Adaptado para:** CLI/Terminal
**Versão Original:** $(basename "${source}")
**Data de Adaptação:** $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

adapt_for_ide_ext() {
    local source="$1"
    local target="$2"
    local name="$3"

    cat > "${target}" << EOF
# ${name} - IDE Extension Optimized

**Versão:** 1.0.0
**Engine:** IDE Extensions (Cursor, VSCode, JetBrains AI)
**Data:** $(date '+%Y-%m-%d')
**Status:** Adaptado

---

## 🎯 CONTEXTO DE USO

Este prompt foi adaptado para uso em:
- Cursor 2.x
- VSCode Copilot
- JetBrains AI
- Raycast AI
- Extensões de IDE

## 📋 PROMPT

$(cat "${source}")

---

**Adaptado para:** IDE Extensions
**Versão Original:** $(basename "${source}")
**Data de Adaptação:** $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

adapt_for_offline_llms() {
    local source="$1"
    local target="$2"
    local name="$3"

    cat > "${target}" << EOF
# ${name} - Offline LLMs Optimized

**Versão:** 1.0.0
**Engine:** Offline LLMs (Ollama, LM Studio, llama.cpp)
**Data:** $(date '+%Y-%m-%d')
**Status:** Adaptado

---

## 🎯 CONTEXTO DE USO

Este prompt foi adaptado para uso em:
- Ollama (modelos locais)
- LM Studio
- llama.cpp
- GPTQ models
- LLMs offline/privados

## 📋 PROMPT

$(cat "${source}")

---

**Adaptado para:** Offline LLMs
**Versão Original:** $(basename "${source}")
**Data de Adaptação:** $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

adapt_for_web_platforms() {
    local source="$1"
    local target="$2"
    local name="$3"

    cat > "${target}" << EOF
# ${name} - Web Platforms Optimized

**Versão:** 1.0.0
**Engine:** Web Platforms (ChatGPT, Claude, Gemini, Perplexity)
**Data:** $(date '+%Y-%m-%d')
**Status:** Adaptado

---

## 🎯 CONTEXTO DE USO

Este prompt foi adaptado para uso em:
- ChatGPT Plus 5.1
- Claude Code (Sonnet/Opus)
- Gemini Pro
- Perplexity Pro
- Plataformas web de LLMs

## 📋 PROMPT

$(cat "${source}")

---

**Adaptado para:** Web Platforms
**Versão Original:** $(basename "${source}")
**Data de Adaptação:** $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

adapt_for_desktop_llms() {
    local source="$1"
    local target="$2"
    local name="$3"

    cat > "${target}" << EOF
# ${name} - Desktop LLMs Optimized

**Versão:** 1.0.0
**Engine:** Desktop LLMs e Agentes Locais
**Data:** $(date '+%Y-%m-%d')
**Status:** Adaptado

---

## 🎯 CONTEXTO DE USO

Este prompt foi adaptado para uso em:
- Aplicativos macOS
- Aplicativos Windows
- Aplicativos Linux
- Agentes locais desktop

## 📋 PROMPT

$(cat "${source}")

---

**Adaptado para:** Desktop LLMs
**Versão Original:** $(basename "${source}")
**Data de Adaptação:** $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

adapt_for_multi_agent() {
    local source="$1"
    local target="$2"
    local name="$3"

    cat > "${target}" << EOF
# ${name} - Multi-Agent Optimized

**Versão:** 1.0.0
**Engine:** Multi-Agent Coordination
**Data:** $(date '+%Y-%m-%d')
**Status:** Adaptado

---

## 🎯 CONTEXTO DE USO

Este prompt foi adaptado para uso em:
- Coordenação entre múltiplos modelos
- Pipeline de agentes
- Orquestração inteligente
- Sistemas multi-agente

## 📋 PROMPT

$(cat "${source}")

---

**Adaptado para:** Multi-Agent
**Versão Original:** $(basename "${source}")
**Data de Adaptação:** $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

# ============================================================================
# PROCESSAR E ADAPTAR
# ============================================================================

process_and_adapt() {
    print_header "🔄 PROCESSAMENTO E ADAPTAÇÃO"

    local STAGE_00="${PROMPTS_TEMP}/stage_00_coleta"
    local STAGE_01="${PROMPTS_TEMP}/stage_01_interpretacao"
    local STAGE_02="${PROMPTS_TEMP}/stage_02_estrutura"

    # Processar cada prompt coletado
    for source_file in "${STAGE_00}"/*.md; do
        if [ ! -f "${source_file}" ]; then
            continue
        fi

        local basename_file=$(basename "${source_file}" .md)
        local name=$(echo "${basename_file}" | sed 's/_/ /g' | sed 's/\b\w/\u&/g')

        log_info "Processando: ${basename_file}"

        # Stage 01: Interpretação (cópia inicial)
        cp "${source_file}" "${STAGE_01}/${basename_file}_interpretado.md"

        # Stage 02: Estrutura (cópia estruturada)
        cp "${source_file}" "${STAGE_02}/${basename_file}_estruturado.md"

        # Adaptar para cada engine
        adapt_for_cli "${source_file}" "${PROMPTS_TEMP}/engines/cli/${basename_file}_cli.md" "${name}"
        adapt_for_ide_ext "${source_file}" "${PROMPTS_TEMP}/engines/ide_ext/${basename_file}_ide.md" "${name}"
        adapt_for_offline_llms "${source_file}" "${PROMPTS_TEMP}/engines/offline_llms/${basename_file}_offline.md" "${name}"
        adapt_for_web_platforms "${source_file}" "${PROMPTS_TEMP}/engines/web_platforms/${basename_file}_web.md" "${name}"
        adapt_for_desktop_llms "${source_file}" "${PROMPTS_TEMP}/engines/desktop_llms/${basename_file}_desktop.md" "${name}"
        adapt_for_multi_agent "${source_file}" "${PROMPTS_TEMP}/engines/multi_agent/${basename_file}_multi.md" "${name}"

        log_success "Adaptado: ${basename_file}"
    done

    log_success "Processamento concluído"
}

# ============================================================================
# VALIDAÇÃO
# ============================================================================

validate_structure() {
    print_header "✅ VALIDAÇÃO DA ESTRUTURA"

    local errors=0

    # Validar diretórios
    local dirs=(
        "stage_00_coleta"
        "stage_01_interpretacao"
        "stage_02_estrutura"
        "stage_03_refinamento"
        "stage_04_pre_release"
        "checklists"
        "engines/cli"
        "engines/ide_ext"
        "engines/offline_llms"
        "engines/web_platforms"
        "engines/desktop_llms"
        "engines/multi_agent"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "${PROMPTS_TEMP}/${dir}" ]; then
            log_success "Diretório existe: ${dir}"
        else
            log_error "Diretório não encontrado: ${dir}"
            ((errors++))
        fi
    done

    # Validar arquivos essenciais
    if [ -f "${PROMPTS_TEMP}/_index_manifest.yaml" ]; then
        log_success "Manifest existe"
    else
        log_error "Manifest não encontrado"
        ((errors++))
    fi

    if [ -f "${PROMPTS_TEMP}/checklists/lifecycle_checklist.md" ]; then
        log_success "Lifecycle checklist existe"
    else
        log_error "Lifecycle checklist não encontrado"
        ((errors++))
    fi

    if [ -f "${PROMPTS_TEMP}/checklists/llm_eval_matrix.md" ]; then
        log_success "LLM eval matrix existe"
    else
        log_error "LLM eval matrix não encontrado"
        ((errors++))
    fi

    # Contar arquivos gerados
    local stage_00_count=$(find "${PROMPTS_TEMP}/stage_00_coleta" -name "*.md" -o -name "*.log" 2>/dev/null | wc -l | tr -d ' ')
    local engines_count=$(find "${PROMPTS_TEMP}/engines" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    log_info "Arquivos em stage_00_coleta: ${stage_00_count}"
    log_info "Arquivos em engines: ${engines_count}"

    if [ "${errors}" -eq 0 ]; then
        log_success "✅ Validação concluída sem erros"
        return 0
    else
        log_error "❌ Validação encontrou ${errors} erro(s)"
        return 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🔄 COLETAR E ADAPTAR PROMPTS AUTOMATIZADO"

    collect_existing_prompts
    process_and_adapt
    validate_structure

    echo ""
    log_success "✅ Processo completo concluído!"
    log_info "📁 Estrutura: ${PROMPTS_TEMP}"
    echo ""
}

main "$@"

