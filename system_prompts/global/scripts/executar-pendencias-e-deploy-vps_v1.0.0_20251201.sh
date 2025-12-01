#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🚀 EXECUÇÃO COMPLETA DE PENDÊNCIAS E DEPLOY VPS
#
# Objetivo:
#   - Executar todas as pendências pendentes localmente
#   - Verificar status antes de criar pastas duplicadas
#   - Preparar e executar deploy completo na VPS Ubuntu
#   - Seguir melhores práticas: coleta → análise → desenvolvimento → implantação
#
# Uso: ./executar-pendencias-e-deploy-vps_v1.0.0_20251201.sh [--dry-run] [--skip-local] [--skip-vps]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
INFRA_VPS_DIR="${DOTFILES_DIR}/infra-vps"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Configuração VPS
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_DOTFILES="${VPS_DOTFILES:-/home/admin/Dotfiles}"
VPS_SYSTEM_PROMPTS="${VPS_DOTFILES}/system_prompts/global"
VPS_INFRA_VPS="${VPS_DOTFILES}/infra-vps"

# Flags
DRY_RUN=false
SKIP_LOCAL=false
SKIP_VPS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --skip-local)
            SKIP_LOCAL=true
            shift
            ;;
        --skip-vps)
            SKIP_VPS=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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

log_error() {
    echo -e "${RED}❌${NC} $@"
}

log_step() {
    echo -e "${CYAN}▶${NC} $@"
}

log_section() {
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} $@"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Verificar se diretório existe antes de criar
check_and_create_dir() {
    local dir="$1"
    local description="${2:-Diretório}"

    if [[ -d "${dir}" ]]; then
        log_info "${description} já existe: ${dir}"
        return 0
    fi

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Criaria: ${dir}"
        return 0
    fi

    mkdir -p "${dir}"
    log_success "${description} criado: ${dir}"
    return 0
}

# Verificar status Git
check_git_status() {
    local dir="$1"
    local name="$2"

    if [[ ! -d "${dir}/.git" ]]; then
        log_warning "${name} não é um repositório Git"
        return 1
    fi

    cd "${dir}"
    local status=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    local branch=$(git branch --show-current 2>/dev/null || echo "unknown")

    log_info "${name} - Branch: ${branch}, Arquivos modificados: ${status}"

    if [[ "${status}" -gt 0 ]]; then
        log_warning "${name} tem ${status} arquivo(s) não commitado(s)"
        return 1
    fi

    return 0
}

# Validar conexão SSH com VPS
validate_vps_connection() {
    log_step "Validando conexão SSH com VPS..."

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Pulando validação SSH"
        return 0
    fi

    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_success "Conexão SSH estabelecida com ${VPS_USER}@${VPS_HOST}"
        return 0
    else
        log_error "Não foi possível conectar via SSH"
        log_info "Verifique:"
        log_info "  - Alias SSH configurado: ssh ${VPS_HOST}"
        log_info "  - Chaves SSH autorizadas na VPS"
        log_info "  - Host acessível"
        return 1
    fi
}

# Verificar estrutura na VPS antes de criar
check_vps_structure() {
    log_step "Verificando estrutura na VPS..."

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Pulando verificação de estrutura VPS"
        return 0
    fi

    ssh "${VPS_USER}@${VPS_HOST}" "
        if [[ -d '${VPS_SYSTEM_PROMPTS}' ]]; then
            echo 'EXISTS:${VPS_SYSTEM_PROMPTS}'
        else
            echo 'NOT_EXISTS:${VPS_SYSTEM_PROMPTS}'
        fi

        if [[ -d '${VPS_INFRA_VPS}' ]]; then
            echo 'EXISTS:${VPS_INFRA_VPS}'
        else
            echo 'NOT_EXISTS:${VPS_INFRA_VPS}'
        fi
    " | while IFS=':' read -r status path; do
        if [[ "${status}" == "EXISTS" ]]; then
            log_info "Diretório já existe na VPS: ${path}"
        else
            log_info "Diretório não existe na VPS: ${path}"
        fi
    done
}

# ============================================================================
# FASE 1: COLETA - Verificar Status Atual
# ============================================================================

phase1_collect() {
    log_section "FASE 1: COLETA - Verificar Status Atual"

    log_step "1.1. Verificando estrutura local..."
    check_and_create_dir "${DOTFILES_DIR}" "Dotfiles root"
    check_and_create_dir "${GLOBAL_DIR}" "System Prompts Global"
    check_and_create_dir "${INFRA_VPS_DIR}" "Infra VPS"
    check_and_create_dir "${GLOBAL_DIR}/logs" "Logs"

    log_step "1.2. Verificando status Git..."
    check_git_status "${DOTFILES_DIR}" "Dotfiles"
    check_git_status "${INFRA_VPS_DIR}" "infra-vps" || true

    log_step "1.3. Verificando scripts disponíveis..."
    local scripts_count=$(find "${GLOBAL_DIR}/scripts" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')
    log_info "Scripts encontrados: ${scripts_count}"

    log_step "1.4. Verificando pendências críticas..."

    # Verificar secrets hardcoded em infra-vps
    if [[ -d "${INFRA_VPS_DIR}" ]]; then
        cd "${INFRA_VPS_DIR}"
        if grep -r "XZH_qrf3qgr" . --exclude-dir=.git 2>/dev/null | head -1 > /dev/null; then
            log_warning "Secrets hardcoded encontrados em infra-vps"
        else
            log_success "Nenhum secret hardcoded encontrado em infra-vps"
        fi
    fi

    echo ""
    log_success "Fase 1 (Coleta) concluída"
}

# ============================================================================
# FASE 2: ANÁLISE - Processar Pendências Locais
# ============================================================================

phase2_analyze() {
    log_section "FASE 2: ANÁLISE - Processar Pendências Locais"

    if [[ "${SKIP_LOCAL}" == "true" ]]; then
        log_info "Pulando processamento local (--skip-local)"
        return 0
    fi

    log_step "2.1. Executando correções em infra-vps..."
    if [[ -f "${INFRA_VPS_DIR}/scripts/executar-correcoes-completas.sh" ]]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            log_info "[DRY-RUN] Executaria: ${INFRA_VPS_DIR}/scripts/executar-correcoes-completas.sh --dry-run"
        else
            cd "${INFRA_VPS_DIR}"
            bash scripts/executar-correcoes-completas.sh --skip-git || log_warning "Algumas correções podem ter falhado"
        fi
    else
        log_warning "Script de correções não encontrado em infra-vps"
    fi

    log_step "2.2. Organizando secrets no 1Password..."
    if [[ -f "${GLOBAL_DIR}/scripts/organizar-secrets-1password_v1.0.0_20251201.sh" ]]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            log_info "[DRY-RUN] Executaria organização de secrets"
        else
            cd "${GLOBAL_DIR}"
            bash scripts/organizar-secrets-1password_v1.0.0_20251201.sh || log_warning "Organização de secrets pode ter falhado"
        fi
    fi

    log_step "2.3. Validando scripts..."
    if [[ -f "${GLOBAL_DIR}/scripts/testar_scripts_system_prompts_global.sh" ]]; then
        if [[ "${DRY_RUN}" != "true" ]]; then
            cd "${GLOBAL_DIR}"
            bash scripts/testar_scripts_system_prompts_global.sh || log_warning "Alguns scripts podem ter problemas"
        fi
    fi

    echo ""
    log_success "Fase 2 (Análise) concluída"
}

# ============================================================================
# FASE 3: DESENVOLVIMENTO - Preparar Deploy
# ============================================================================

phase3_develop() {
    log_section "FASE 3: DESENVOLVIMENTO - Preparar Deploy"

    log_step "3.1. Criando estrutura de logs..."
    check_and_create_dir "${GLOBAL_DIR}/logs/deploy" "Logs de deploy"
    check_and_create_dir "${GLOBAL_DIR}/logs/auditoria" "Logs de auditoria"

    log_step "3.2. Preparando scripts para VPS..."
    if [[ "${DRY_RUN}" != "true" ]]; then
        # Garantir que scripts têm permissão de execução
        find "${GLOBAL_DIR}/scripts" -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
        log_success "Permissões de execução verificadas"
    fi

    log_step "3.3. Validando conexão VPS..."
    if ! validate_vps_connection; then
        log_error "Não é possível prosseguir sem conexão VPS"
        return 1
    fi

    log_step "3.4. Verificando estrutura na VPS..."
    check_vps_structure

    echo ""
    log_success "Fase 3 (Desenvolvimento) concluída"
}

# ============================================================================
# FASE 4: IMPLANTAÇÃO - Deploy na VPS
# ============================================================================

phase4_deploy() {
    log_section "FASE 4: IMPLANTAÇÃO - Deploy na VPS"

    if [[ "${SKIP_VPS}" == "true" ]]; then
        log_info "Pulando deploy VPS (--skip-vps)"
        return 0
    fi

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Simulando deploy na VPS..."
        log_info "  - Criaria estrutura em: ${VPS_SYSTEM_PROMPTS}"
        log_info "  - Enviaria arquivos de: ${GLOBAL_DIR}"
        log_info "  - Configuraria scripts na VPS"
        return 0
    fi

    log_step "4.1. Criando estrutura na VPS (verificando antes)..."
    ssh "${VPS_USER}@${VPS_HOST}" "
        set -e
        mkdir -p ${VPS_DOTFILES}/system_prompts/global/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections},consolidated,scripts,governance,audit,prompts_temp,logs/{deploy,auditoria}}
        mkdir -p ${VPS_INFRA_VPS}/{infraestrutura,scripts,vaults-1password/docs,logs}
        echo 'Estrutura criada/verificada'
    " || {
        log_error "Falha ao criar estrutura na VPS"
        return 1
    }
    log_success "Estrutura na VPS verificada/criada"

    log_step "4.2. Clonando/Atualizando repositório SYSTEM_PROMPT na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "
        set -e
        if [[ -d '${VPS_DOTFILES}/.git' ]]; then
            cd ${VPS_DOTFILES}
            git pull origin main || echo 'Pull pode ter falhado, continuando...'
        else
            cd $(dirname ${VPS_DOTFILES})
            git clone https://github.com/senal88/SYSTEM_PROMPT.git $(basename ${VPS_DOTFILES}) || echo 'Clone pode ter falhado'
        fi
    " || log_warning "Git clone/pull pode ter problemas"

    log_step "4.3. Sincronizando infra-vps (se existir)..."
    if [[ -d "${INFRA_VPS_DIR}/.git" ]]; then
        ssh "${VPS_USER}@${VPS_HOST}" "
            set -e
            if [[ -d '${VPS_INFRA_VPS}/.git' ]]; then
                cd ${VPS_INFRA_VPS}
                git pull origin main || echo 'Pull infra-vps pode ter falhado'
            else
                cd $(dirname ${VPS_INFRA_VPS})
                git clone https://github.com/senal88/infra-vps.git $(basename ${VPS_INFRA_VPS}) || echo 'Clone infra-vps pode ter falhado'
            fi
        " || log_warning "Sincronização infra-vps pode ter problemas"
    fi

    log_step "4.4. Configurando permissões de execução na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "
        find ${VPS_SYSTEM_PROMPTS}/scripts -name '*.sh' -type f -exec chmod +x {} \; 2>/dev/null || true
        find ${VPS_INFRA_VPS}/scripts -name '*.sh' -type f -exec chmod +x {} \; 2>/dev/null || true
        echo 'Permissões configuradas'
    " || log_warning "Configuração de permissões pode ter falhado"

    log_step "4.5. Validando instalação na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "
        echo '=== ESTRUTURA VPS ==='
        ls -la ${VPS_SYSTEM_PROMPTS}/scripts/*.sh 2>/dev/null | head -5 || echo 'Nenhum script encontrado'
        echo ''
        echo '=== INFRA-VPS ==='
        ls -la ${VPS_INFRA_VPS}/scripts/*.sh 2>/dev/null | head -5 || echo 'Nenhum script encontrado'
    "

    echo ""
    log_success "Fase 4 (Implantação) concluída"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  EXECUÇÃO COMPLETA - PENDÊNCIAS E DEPLOY VPS             ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "MODO DRY-RUN: Nenhuma alteração será feita"
        echo ""
    fi

    log_info "Configuração:"
    log_info "  - Dotfiles: ${DOTFILES_DIR}"
    log_info "  - System Prompts: ${GLOBAL_DIR}"
    log_info "  - Infra VPS: ${INFRA_VPS_DIR}"
    log_info "  - VPS Host: ${VPS_USER}@${VPS_HOST}"
    log_info "  - VPS Dotfiles: ${VPS_DOTFILES}"
    echo ""

    # Executar fases em ordem
    phase1_collect || {
        log_error "Fase 1 (Coleta) falhou"
        exit 1
    }

    phase2_analyze || {
        log_error "Fase 2 (Análise) falhou"
        exit 1
    }

    phase3_develop || {
        log_error "Fase 3 (Desenvolvimento) falhou"
        exit 1
    }

    phase4_deploy || {
        log_error "Fase 4 (Implantação) falhou"
        exit 1
    }

    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  EXECUÇÃO COMPLETA CONCLUÍDA COM SUCESSO                   ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    log_info "Próximos passos:"
    log_info "  1. Verificar logs em: ${GLOBAL_DIR}/logs/"
    log_info "  2. Conectar na VPS: ssh ${VPS_HOST}"
    log_info "  3. Executar scripts na VPS: cd ${VPS_SYSTEM_PROMPTS}/scripts"
    echo ""
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
