#!/usr/bin/env bash

################################################################################
# 🔍 COLETA COMPLETA VPS - Ubuntu 24.04 LTS
# Sistema de coleta automatizada para gerar system_prompt VPS consolidado
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Coletar dados da VPS Ubuntu para system prompts
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
AUDIT_BASE="${DOTFILES_DIR}/system_prompts/global/audit"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
AUDIT_DIR="${AUDIT_BASE}/${TIMESTAMP}/vps"

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
# PREPARAÇÃO
# ============================================================================

setup_directories() {
    mkdir -p "${AUDIT_DIR}"
    log_success "Diretório de auditoria criado: ${AUDIT_DIR}"
}

# ============================================================================
# COLETA VPS UBUNTU
# ============================================================================

collect_vps_complete() {
    print_header "COLETA COMPLETA VPS Ubuntu 24.04 LTS"

    log_info "Iniciando coleta completa da VPS..."

    # 1. Sistema e Hardware
    {
        echo "======================================="
        echo "AUDITORIA VPS - ${TIMESTAMP}"
        echo "BASE: ${AUDIT_DIR}"
        echo "======================================="
        echo ""
        echo "### SISTEMA OPERACIONAL"
        echo "uname -a:"
        uname -a
        echo ""
        echo "### /etc/os-release"
        [ -f /etc/os-release ] && cat /etc/os-release || echo "N/A"
        echo ""
        echo "### uptime"
        uptime || true
        echo ""
        echo "### Kernel Version"
        uname -r
        echo ""
    } > "${AUDIT_DIR}/01_sistema_hardware.txt"
    log_success "Sistema e hardware coletados"

    # 2. Recursos do Sistema
    {
        echo "### DISCO (df -h)"
        df -h
        echo ""
        echo "### MEMÓRIA (free -h)"
        free -h || true
        echo ""
        echo "### CPU INFO"
        lscpu 2>/dev/null || grep -E "model name|processor|cores" /proc/cpuinfo | head -5
        echo ""
    } > "${AUDIT_DIR}/02_recursos_sistema.txt"
    log_success "Recursos do sistema coletados"

    # 3. Processos
    {
        echo "### TOP 25 PROCESSOS POR MEMÓRIA"
        ps aux --sort=-%mem | head -n 25
        echo ""
        echo "### TOP 25 PROCESSOS POR CPU"
        ps aux --sort=-%cpu | head -n 25
        echo ""
    } > "${AUDIT_DIR}/03_processos_top.txt"
    log_success "Processos coletados"

    # 4. Serviços Systemd
    if command -v systemctl >/dev/null 2>&1; then
        {
            echo "### SERVIÇOS ATIVOS (systemctl list-units --type=service --state=running)"
            systemctl list-units --type=service --state=running --no-pager || true
            echo ""
            echo "### SERVIÇOS FALHADOS"
            systemctl list-units --type=service --state=failed --no-pager || true
            echo ""
        } > "${AUDIT_DIR}/04_servicos_ativos.txt"
        log_success "Serviços systemd coletados"
    fi

    # 5. Docker Geral
    if command -v docker >/dev/null 2>&1; then
        {
            echo "### DOCKER INFO"
            docker info 2>/dev/null || true
            echo ""
            echo "### DOCKER VERSION"
            docker --version || true
            echo ""
            echo "### DOCKER COMPOSE VERSION"
            docker compose version 2>/dev/null || docker-compose --version 2>/dev/null || echo "N/A"
            echo ""
        } > "${AUDIT_DIR}/05_docker_geral.txt"
        log_success "Docker geral coletado"

        {
            echo "### DOCKER PS -A"
            docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' || docker ps -a
            echo ""
            echo "### DOCKER IMAGES"
            docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}' || docker images
            echo ""
        } > "${AUDIT_DIR}/06_docker_containers.txt"
        log_success "Containers Docker coletados"

        {
            echo "### DOCKER STACK LS"
            docker stack ls 2>/dev/null || echo "Docker Swarm não configurado"
            echo ""
            echo "### DOCKER SERVICE LS"
            docker service ls 2>/dev/null || echo "Docker Swarm não configurado"
            echo ""
            echo "### DOCKER NODE LS"
            docker node ls 2>/dev/null || echo "Docker Swarm não configurado"
            echo ""
        } > "${AUDIT_DIR}/07_docker_swarm_stacks.txt"
        log_success "Docker Swarm coletado"

        {
            echo "### DOCKER NETWORKS"
            docker network ls
            echo ""
            echo "### DOCKER VOLUMES"
            docker volume ls
            echo ""
        } > "${AUDIT_DIR}/08_docker_networks_volumes.txt"
        log_success "Redes e volumes Docker coletados"
    else
        log_warning "Docker não encontrado"
    fi

    # 6. Rede
    {
        echo "### INTERFACES DE REDE"
        if command -v ip >/dev/null 2>&1; then
            ip addr show
        elif command -v ifconfig >/dev/null 2>&1; then
            ifconfig
        else
            echo "ip/ifconfig não encontrados"
        fi
        echo ""
        echo "### ROUTING TABLE"
        ip route show 2>/dev/null || route -n 2>/dev/null || echo "N/A"
        echo ""
    } > "${AUDIT_DIR}/09_rede_interfaces.txt"
    log_success "Interfaces de rede coletadas"

    if command -v ss >/dev/null 2>&1; then
        ss -tulpn > "${AUDIT_DIR}/10_rede_portas_ativas.txt" 2>/dev/null || true
        log_success "Portas ativas coletadas"
    fi

    # 7. Estrutura de Diretórios Críticos
    {
        echo "### TREE SIMPLIFICADO - ~/Dotfiles (maxdepth 3)"
        find "${HOME}/Dotfiles" -maxdepth 3 -print 2>/dev/null | head -50 || echo "N/A"
        echo ""
        echo "### TREE SIMPLIFICADO - ~/infra-vps (maxdepth 3)"
        find "${HOME}/infra-vps" -maxdepth 3 -print 2>/dev/null | head -50 || echo "N/A"
        echo ""
        echo "### TREE SIMPLIFICADO - ~/scripts (maxdepth 2)"
        find "${HOME}/scripts" -maxdepth 2 -print 2>/dev/null | head -30 || echo "N/A"
        echo ""
    } > "${AUDIT_DIR}/11_estrutura_diretorios.txt"
    log_success "Estrutura de diretórios coletada"

    # 8. Git Repositories
    {
        echo "### REPOSITÓRIO infra-vps"
        if [ -d "${HOME}/infra-vps/.git" ]; then
            cd "${HOME}/infra-vps"
            echo "Remote:"
            git remote -v 2>/dev/null || echo "N/A"
            echo ""
            echo "Branch atual:"
            git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A"
            echo ""
            echo "Últimos 5 commits:"
            git log --oneline -5 2>/dev/null || echo "N/A"
            echo ""
            echo "Status:"
            git status --short 2>/dev/null | head -20 || echo "N/A"
        else
            echo "Repositório Git não encontrado em ~/infra-vps"
        fi
        echo ""
    } > "${AUDIT_DIR}/12_git_repos.txt"
    log_success "Repositórios Git coletados"

    # 9. Shell Configuration
    {
        echo "### .bashrc"
        [ -f "${HOME}/.bashrc" ] && cat "${HOME}/.bashrc" || echo "N/A"
        echo ""
        echo "### .bash_profile"
        [ -f "${HOME}/.bash_profile" ] && cat "${HOME}/.bash_profile" || echo "N/A"
        echo ""
        echo "### Variáveis de Ambiente Importantes"
        env | grep -E "DOTFILES|PATH|HOME|USER" | sort || echo "N/A"
        echo ""
    } > "${AUDIT_DIR}/13_shell_config.txt"
    log_success "Configuração shell coletada"

    # 10. Pacotes Instalados (APT)
    if command -v dpkg >/dev/null 2>&1; then
        {
            echo "### PACOTES INSTALADOS (dpkg -l | head -50)"
            dpkg -l | head -50
            echo ""
            echo "### CONTAGEM TOTAL DE PACOTES"
            dpkg -l | wc -l
            echo ""
        } > "${AUDIT_DIR}/14_pacotes_apt.txt"
        log_success "Pacotes APT coletados"
    fi

    # 11. Firewall (UFW)
    if command -v ufw >/dev/null 2>&1; then
        {
            echo "### UFW STATUS"
            sudo ufw status verbose 2>/dev/null || ufw status 2>/dev/null || echo "UFW não configurado ou sem permissão"
            echo ""
        } > "${AUDIT_DIR}/15_firewall.txt"
        log_success "Firewall coletado"
    fi

    log_success "Coleta completa da VPS concluída!"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🔍 AUDITORIA COMPLETA VPS Ubuntu 24.04 LTS"

    setup_directories
    collect_vps_complete

    echo ""
    log_success "✅ Auditoria da VPS concluída com sucesso!"
    log_info "📁 Diretório de auditoria: ${AUDIT_DIR}"
    echo ""
}

main "$@"

