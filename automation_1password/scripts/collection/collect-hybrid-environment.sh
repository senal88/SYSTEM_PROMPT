#!/bin/bash
# collect-hybrid-environment.sh
# Coleta dados do ambiente híbrido macOS → VPS Ubuntu
# Baseado em: Cursor_Coleta_Hibrido_macOS_VPS.md
# Last Updated: 2025-11-01
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/../lib/logging.sh"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
DATA_DIR="${REPO_ROOT}/dados"
PROD_DIR="${REPO_ROOT}/prod"
VAULT_MACOS="1p_macos"
VAULT_VPS="1p_vps"
VPS_HOST="147.79.81.59"
VPS_DOMAIN="senamfo.com.br"

# ============================================================================
# VERIFICAÇÕES
# ============================================================================

check_prerequisites() {
    log_section "🔍 Verificando Pré-requisitos"
    
    # Criar diretórios
    mkdir -p "${DATA_DIR}" "${PROD_DIR}"
    log_success "Diretórios criados"
    
    # Verificar Docker/Colima
    if command -v colima &>/dev/null; then
        if colima status &>/dev/null; then
            log_success "Colima está rodando"
        else
            log_warning "Colima não está rodando"
        fi
    fi
    
    # Verificar Docker
    if command -v docker &>/dev/null; then
        if docker ps &>/dev/null 2>&1; then
            log_success "Docker está acessível"
        else
            log_warning "Docker não está acessível"
        fi
    fi
    
    # Verificar 1Password
    if command -v op &>/dev/null; then
        if op whoami &>/dev/null 2>&1 || [ -n "${OP_CONNECT_HOST:-}" ]; then
            log_success "1Password CLI configurado"
        else
            log_warning "1Password CLI não autenticado"
        fi
    fi
    
    return 0
}

# ============================================================================
# COLETAS
# ============================================================================

collect_1_system_info() {
    log_section "📊 Coleta 1: Informações do Sistema"
    
    {
        echo "=== MACOS SYSTEM INFO ==="
        sw_vers
        echo ""
        echo "=== ARCHITECTURE ==="
        uname -m
        echo ""
        echo "=== CPU CORES ==="
        sysctl -n hw.physicalcpu
        echo ""
        echo "=== RAM ==="
        sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 " GB"}'
        echo ""
        echo "=== DISK ==="
        df -h / | tail -1
    } > "${DATA_DIR}/01_system_info.txt"
    
    log_success "Sistema: $(uname -m) $(sysctl -n hw.physicalcpu) cores"
}

collect_2_docker_colima() {
    log_section "🐳 Coleta 2: Status Docker + Colima"
    
    {
        echo "=== COLIMA STATUS ==="
        colima status 2>&1 || echo "Colima não disponível"
        echo ""
        echo "=== DOCKER VERSION ==="
        docker --version 2>&1 || echo "Docker não disponível"
        echo ""
        echo "=== COLIMA VERSION ==="
        colima --version 2>&1 || echo "Colima não disponível"
        echo ""
        echo "=== DOCKER PS ==="
        docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" 2>&1 || echo "Docker não disponível"
        echo ""
        echo "=== DOCKER IMAGES ==="
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>&1 | head -20 || echo "Docker não disponível"
    } > "${DATA_DIR}/02_docker_status.txt"
    
    log_success "Status Docker coletado"
}

collect_3_stacks_list() {
    log_section "📦 Coleta 3: Stacks Docker"
    
    {
        echo "=== DOCKER STACKS ==="
        docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}" 2>&1 || echo "Docker não disponível"
        echo ""
        echo "=== DOCKER VOLUMES ==="
        docker volume ls --format "table {{.Name}}\t{{.Driver}}" 2>&1 || echo "Docker não disponível"
        echo ""
        echo "=== DOCKER NETWORKS ==="
        docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}" 2>&1 || echo "Docker não disponível"
    } > "${DATA_DIR}/03_docker_stacks.txt"
    
    log_success "Stacks coletadas"
}

collect_6_1password_inventory() {
    log_section "🔐 Coleta 6: 1Password Inventory (SEM VALORES!)"
    
    if command -v op &>/dev/null; then
        # Listar items (sem valores)
        if [ -n "${OP_CONNECT_HOST:-}" ]; then
            # Usando Connect
            curl -s -H "Authorization: Bearer ${OP_CONNECT_TOKEN}" \
                 "${OP_CONNECT_HOST}/v1/vaults" 2>/dev/null | jq '.[] | {id, name}' > "${DATA_DIR}/06_vaults.json" 2>&1 || true
        else
            # CLI direto
            op vault list --format json 2>&1 | jq '.[] | {id, name}' > "${DATA_DIR}/06_vaults.json" 2>&1 || true
        fi
        
        # Listar items do vault 1p_macos (apenas metadata)
        op item list --vault "${VAULT_MACOS}" --format json 2>&1 | \
            jq '.[] | {id, title, category, updated_at}' > "${DATA_DIR}/06_1password_inventory.json" 2>&1 || {
            log_warning "Vault ${VAULT_MACOS} não encontrado ou não acessível"
            echo "[]" > "${DATA_DIR}/06_1password_inventory.json"
        }
        
        log_success "Inventory coletado (SEM valores de secrets)"
    else
        log_warning "1Password CLI não disponível"
        echo "[]" > "${DATA_DIR}/06_1password_inventory.json"
    fi
}

collect_7_env_vars() {
    log_section "🔑 Coleta 7: Variáveis de Ambiente (APENAS KEYS!)"
    
    {
        echo "=== ENVIRONMENT VARIABLES (KEYS ONLY) ==="
        env | grep -E "API|SECRET|TOKEN|DB|REDIS|AWS|OP_" | cut -d= -f1 | sort | uniq || true
        echo ""
        echo "=== .env FILES STRUCTURE ==="
        find "${REPO_ROOT}" -name ".env*" -type f 2>/dev/null | while read -r file; do
            echo "File: ${file}"
            wc -l "${file}" || true
        done
    } > "${DATA_DIR}/07_env_vars_keys.txt"
    
    log_success "Variáveis coletadas (sem valores)"
}

collect_8_git_info() {
    log_section "📝 Coleta 8: Informações Git"
    
    {
        echo "=== GIT REMOTE ==="
        git remote -v 2>&1 || echo "Não é um repositório Git"
        echo ""
        echo "=== GIT STATUS ==="
        git status --short 2>&1 || echo "Não é um repositório Git"
        echo ""
        echo "=== GIT BRANCHES ==="
        git branch -a 2>&1 || echo "Não é um repositório Git"
        echo ""
        echo "=== RECENT COMMITS ==="
        git log --oneline -10 2>&1 || echo "Não é um repositório Git"
    } > "${DATA_DIR}/08_git_info.txt"
    
    log_success "Info Git coletada"
}

collect_9_network_config() {
    log_section "🌐 Coleta 9: Configuração de Rede"
    
    {
        echo "=== PORTS MAPPED ==="
        docker ps --format "{{.Names}}\t{{.Ports}}" 2>&1 || echo "Docker não disponível"
        echo ""
        echo "=== DOCKER NETWORKS ==="
        docker network ls --format "table {{.Name}}\t{{.Driver}}" 2>&1 || echo "Docker não disponível"
    } > "${DATA_DIR}/09_ports_mapping.txt"
    
    log_success "Configuração de rede coletada"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🚀 Coleta de Ambiente Híbrido macOS → VPS"
    
    check_prerequisites
    echo ""
    
    collect_1_system_info
    echo ""
    
    collect_2_docker_colima
    echo ""
    
    collect_3_stacks_list
    echo ""
    
    collect_6_1password_inventory
    echo ""
    
    collect_7_env_vars
    echo ""
    
    collect_8_git_info
    echo ""
    
    collect_9_network_config
    echo ""
    
    log_section "✅ Coleta Completa"
    log_success "Dados coletados em: ${DATA_DIR}/"
    echo ""
    echo "Arquivos gerados:"
    ls -lh "${DATA_DIR}"/0*.txt "${DATA_DIR}"/06*.json 2>/dev/null | awk '{print "  - " $9 " (" $5 ")"}'
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar dados coletados"
    echo "  2. Executar análise: scripts/collection/analyze-collected-data.sh"
    echo "  3. Preparar deployment: scripts/collection/prepare-vps-deployment.sh"
    
    return 0
}

main "$@"

