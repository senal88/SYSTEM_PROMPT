#!/bin/bash

################################################################################
# 🔍 AUDITORIA COMPLETA - macOS Silicon + VPS Ubuntu
# Sistema de coleta automatizada para gerar system_prompt_global consolidado
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Coletar, analisar e sintetizar dados para system prompts
################################################################################

set +euo pipefail 2>/dev/null || set +e
set +u

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
AUDIT_BASE="${DOTFILES_DIR}/system_prompts/global/audit"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
AUDIT_DIR="${AUDIT_BASE}/${TIMESTAMP}"

# Detectar VPS do SSH config
VPS_HOST="${VPS_HOST:-$(
    if [ -f "$HOME/.ssh/config" ]; then
        grep -A 5 "^Host vps\|^Host admin-vps" "$HOME/.ssh/config" 2>/dev/null | \
        grep -i HostName | head -1 | awk '{print $2}' || echo "admin@senamfo.com.br"
    else
        echo "admin@senamfo.com.br"
    fi
)}"

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
    mkdir -p "${AUDIT_DIR}"/{macos,vps,analysis,consolidated}
    log_success "Diretório de auditoria criado: ${AUDIT_DIR}"
}

# ============================================================================
# FASE 1: COLETA macOS SILICON
# ============================================================================

collect_macos_complete() {
    print_header "FASE 1: COLETA COMPLETA macOS Silicon"
    
    local mac_dir="${AUDIT_DIR}/macos"
    
    log_info "Iniciando coleta completa do macOS..."
    
    # 1.1 Sistema e Hardware
    {
        echo "=== SISTEMA OPERACIONAL ==="
        sw_vers
        echo -e "\n=== HARDWARE ==="
        system_profiler SPHardwareDataType | grep -E "Processor Name|Chip|Total Number of Cores|Memory|Model Identifier" || \
        system_profiler SPHardwareDataType | grep "Processor\|Cores\|Memory"
        echo -e "\n=== ARQUITETURA ==="
        echo "Architecture: $(arch)"
        echo "Kernel: $(uname -a)"
        echo -e "\n=== CPU INFO ==="
        sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "N/A"
        echo -e "\n=== MEMORY ==="
        sysctl hw.memsize | awk '{print $2/1024/1024/1024 " GB"}' 2>/dev/null || echo "N/A"
        echo -e "\n=== DISK ==="
        df -h / | tail -1
    } > "${mac_dir}/01_sistema_hardware.txt" 2>&1
    
    # 1.2 Versões de Ferramentas
    {
        echo "=== VERSÕES DE FERRAMENTAS ==="
        echo ""
        echo "--- Python ---"
        python3 --version 2>&1
        which python3 2>&1
        echo ""
        echo "--- Node.js ---"
        node --version 2>&1
        npm --version 2>&1
        which node 2>&1
        echo ""
        echo "--- Docker ---"
        docker --version 2>&1
        docker compose version 2>&1 || docker-compose --version 2>&1
        echo ""
        echo "--- Git ---"
        git --version 2>&1
        git config --global --list 2>&1 | head -10
        echo ""
        echo "--- Ollama ---"
        ollama --version 2>&1
        ollama list 2>&1 | head -20
        echo ""
        echo "--- 1Password CLI ---"
        op --version 2>&1
        echo ""
        echo "--- NordVPN ---"
        nordvpn --version 2>&1 || echo "Não instalado"
        echo ""
        echo "--- Cursor ---"
        cursor --version 2>&1 || echo "CLI não disponível"
        echo ""
        echo "--- VS Code ---"
        code --version 2>&1 | head -1
        code --list-extensions 2>&1 | head -20
        echo ""
        echo "--- Raycast ---"
        defaults read com.raycast.macos version 2>&1 || echo "Versão não disponível"
        echo ""
        echo "--- Homebrew ---"
        brew --version 2>&1 | head -1
    } > "${mac_dir}/02_versoes_ferramentas.txt" 2>&1
    
    # 1.3 Homebrew Packages
    {
        echo "=== HOMEBREW FORMULAE ==="
        brew list --formula 2>/dev/null | sort || echo "Homebrew não instalado"
        echo -e "\n=== HOMEBREW CASKS ==="
        brew list --cask 2>/dev/null | sort || echo "Sem casks"
        echo -e "\n=== HOMEBREW SERVICES ==="
        brew services list 2>/dev/null || echo "Não disponível"
        echo -e "\n=== HOMEBREW TAPS ==="
        brew tap 2>/dev/null || echo "Nenhum tap"
    } > "${mac_dir}/03_homebrew.txt" 2>&1
    
    # 1.4 Shell Configuration
    {
        echo "=== .ZSHRC ==="
        [ -f "$HOME/.zshrc" ] && cat "$HOME/.zshrc" || echo "Não encontrado"
        echo -e "\n=== .BASHRC ==="
        [ -f "$HOME/.bashrc" ] && cat "$HOME/.bashrc" || echo "Não encontrado"
        echo -e "\n=== ALIASES ==="
        alias 2>&1 | head -50
        echo -e "\n=== ENV VARIABLES ==="
        env | grep -v "^Apple\|^SECURITYSESSIONID" | sort
        echo -e "\n=== PATH ==="
        echo "$PATH" | tr ':' '\n'
        echo -e "\n=== SHELL FUNCTIONS ==="
        declare -f 2>&1 | grep -E "^[a-zA-Z_].*\(\)" | head -30
    } > "${mac_dir}/04_shell_config.txt" 2>&1
    
    # 1.5 Aplicativos
    {
        echo "=== APLICATIVOS EM /Applications ==="
        ls -la /Applications 2>/dev/null | head -50
        echo -e "\n=== APLICATIVOS EM ~/Applications ==="
        ls -la ~/Applications 2>/dev/null | head -20
        echo -e "\n=== LOGIN ITEMS ==="
        osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || echo "Não disponível"
    } > "${mac_dir}/05_aplicativos.txt" 2>&1
    
    # 1.6 IDEs e Editores
    {
        echo "=== VS CODE SETTINGS ==="
        [ -f "$HOME/Library/Application Support/Code/User/settings.json" ] && \
            cat "$HOME/Library/Application Support/Code/User/settings.json" || echo "Não encontrado"
        echo -e "\n=== VS CODE EXTENSIONS ==="
        code --list-extensions --show-versions 2>/dev/null | head -30 || echo "Não disponível"
        echo -e "\n=== CURSOR SETTINGS ==="
        [ -f "$HOME/Library/Application Support/Cursor/User/settings.json" ] && \
            cat "$HOME/Library/Application Support/Cursor/User/settings.json" || echo "Não encontrado"
        echo -e "\n=== CURSOR EXTENSIONS ==="
        cursor --list-extensions --show-versions 2>/dev/null | head -30 || echo "Não disponível"
        echo -e "\n=== RAYCAST CONFIG ==="
        [ -d "$HOME/Library/Application Support/com.raycast.macos" ] && \
            find "$HOME/Library/Application Support/com.raycast.macos" -name "*.json" -o -name "*.plist" 2>/dev/null | head -10 || echo "Não encontrado"
    } > "${mac_dir}/06_ides_editores.txt" 2>&1
    
    # 1.7 Projetos e Repositórios Git
    {
        echo "=== ESTRUTURA DE PROJETOS ==="
        for dir in ~/Projects ~/Developer ~/Documents/Projects "$DOTFILES_DIR" ~/infra-vps; do
            if [ -d "$dir" ]; then
                echo -e "\n--- $dir ---"
                ls -la "$dir" 2>/dev/null | head -20
            fi
        done
        echo -e "\n=== REPOSITÓRIOS GIT ==="
        find ~ -name ".git" -type d -maxdepth 5 2>/dev/null | while read gitdir; do
            repo=$(dirname "$gitdir")
            echo -e "\n--- $repo ---"
            cd "$repo" 2>/dev/null && git remote -v 2>/dev/null | head -3
            cd "$repo" 2>/dev/null && echo "Branch: $(git branch --show-current 2>/dev/null)"
        done | head -100
    } > "${mac_dir}/07_projetos_repos.txt" 2>&1
    
    # 1.8 LLMs Locais
    {
        echo "=== OLLAMA MODELOS ==="
        ollama list 2>&1
        echo -e "\n=== LM STUDIO ==="
        ls -lah ~/.cache/lm-studio/models 2>/dev/null || echo "Não encontrado"
        echo -e "\n=== CHROMADB ==="
        find ~ -name "chroma.sqlite3" -type f 2>/dev/null | head -10
        echo -e "\n=== PYTHON ENVS ==="
        if command -v pyenv &> /dev/null; then
            pyenv versions 2>&1
        fi
        if command -v conda &> /dev/null; then
            conda env list 2>&1
        fi
    } > "${mac_dir}/08_llms_locais.txt" 2>&1
    
    # 1.9 Segurança e Acesso
    {
        echo "=== SSH KEYS ==="
        ls -la ~/.ssh/ 2>/dev/null | head -20
        echo -e "\n=== SSH CONFIG ==="
        [ -f ~/.ssh/config ] && cat ~/.ssh/config || echo "Não encontrado"
        echo -e "\n=== 1PASSWORD VAULTS ==="
        op vault list 2>/dev/null || echo "Não autenticado"
        echo -e "\n=== 1PASSWORD ITEMS (1p_macos) ==="
        op item list --vault 1p_macos 2>/dev/null | head -30 || echo "Não disponível"
        echo -e "\n=== 1PASSWORD ITEMS (1p_vps) ==="
        op item list --vault 1p_vps 2>/dev/null | head -30 || echo "Não disponível"
    } > "${mac_dir}/09_seguranca_acesso.txt" 2>&1
    
    # 1.10 Cloud Sync
    {
        echo "=== iCLOUD DRIVE ==="
        ls -la ~/Library/Mobile\ Documents/com~apple~CloudDocs 2>/dev/null | head -20 || echo "Não encontrado"
        echo -e "\n=== GOOGLE DRIVE ==="
        ls -la ~/Google\ Drive 2>/dev/null | head -10 || echo "Não instalado"
        echo -e "\n=== DROPBOX ==="
        ls -la ~/Dropbox 2>/dev/null | head -10 || echo "Não instalado"
        echo -e "\n=== ONEDRIVE ==="
        ls -la ~/OneDrive 2>/dev/null | head -10 || echo "Não instalado"
    } > "${mac_dir}/10_cloud_sync.txt" 2>&1
    
    # 1.11 Dotfiles Structure
    {
        echo "=== DOTFILES STRUCTURE ==="
        if [ -d "$DOTFILES_DIR" ]; then
            find "$DOTFILES_DIR" -maxdepth 3 -type d | head -50
            echo -e "\n=== DOTFILES SCRIPTS ==="
            find "$DOTFILES_DIR/scripts" -type f -name "*.sh" 2>/dev/null | head -30
        fi
        echo -e "\n=== .CONFIG STRUCTURE ==="
        [ -d ~/.config ] && find ~/.config -maxdepth 2 -type d | head -30
    } > "${mac_dir}/11_dotfiles_structure.txt" 2>&1
    
    # 1.12 Atalhos e Automações
    {
        echo "=== ATALHOS (Shortcuts.app) ==="
        shortcuts list 2>/dev/null | head -20 || echo "Não disponível"
        echo -e "\n=== AUTOMATOR SERVICES ==="
        ls -la ~/Library/Services 2>/dev/null | head -20 || echo "Não encontrado"
    } > "${mac_dir}/12_atalhos_automacoes.txt" 2>&1
    
    log_success "Coleta macOS concluída"
}

# ============================================================================
# FASE 2: COLETA VPS UBUNTU
# ============================================================================

collect_vps_complete() {
    print_header "FASE 2: COLETA COMPLETA VPS Ubuntu"
    
    local vps_dir="${AUDIT_DIR}/vps"
    
    log_info "Conectando a VPS: $VPS_HOST"
    
    # Criar script remoto de coleta
    local remote_script=$(mktemp)
    cat > "$remote_script" << 'VPS_SCRIPT_EOF'
#!/bin/bash
set +e

VPS_AUDIT_DIR="/tmp/audit_vps_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$VPS_AUDIT_DIR"
cd "$VPS_AUDIT_DIR"

# 2.1 Sistema
{
    echo "=== SISTEMA ==="
    uname -a
    cat /etc/os-release
    hostnamectl
    echo -e "\n=== CPU ==="
    lscpu | head -20
    echo -e "\n=== MEMORY ==="
    free -h
    echo -e "\n=== DISK ==="
    df -h
    echo -e "\n=== IP PÚBLICO ==="
    curl -s ifconfig.me || echo "N/A"
} > 01_sistema.txt 2>&1

# 2.2 Docker
{
    echo "=== DOCKER VERSION ==="
    docker --version 2>&1
    docker compose version 2>&1 || docker-compose --version 2>&1
    echo -e "\n=== DOCKER INFO ==="
    docker info 2>&1 | head -50
    echo -e "\n=== DOCKER SWARM ==="
    docker info 2>&1 | grep -A 10 "Swarm:" || echo "Swarm não ativo"
    docker node ls 2>&1 || echo "Não é Swarm"
    echo -e "\n=== CONTAINERS ==="
    docker ps -a 2>&1
    echo -e "\n=== SERVICES ==="
    docker service ls 2>&1 || echo "N/A"
    echo -e "\n=== STACKS ==="
    docker stack ls 2>&1 || echo "N/A"
    echo -e "\n=== NETWORKS ==="
    docker network ls 2>&1
    echo -e "\n=== VOLUMES ==="
    docker volume ls 2>&1
} > 02_docker.txt 2>&1

# 2.3 Estrutura
{
    echo "=== /ROOT STRUCTURE ==="
    ls -la /root 2>/dev/null | head -30
    echo -e "\n=== DEPLOY_SENAMFO ==="
    [ -d "/root/deploy_senamfo" ] && find /root/deploy_senamfo -maxdepth 2 -type d 2>/dev/null | head -30 || echo "Não encontrado"
    echo -e "\n=== STACKS-VPS ==="
    [ -d "/root/stacks-vps" ] && find /root/stacks-vps -maxdepth 2 -type d 2>/dev/null | head -30 || echo "Não encontrado"
    echo -e "\n=== GIT REPOS ==="
    find /root -name ".git" -type d -maxdepth 3 2>/dev/null | while read gitdir; do
        repo=$(dirname "$gitdir")
        echo "--- $repo ---"
        cd "$repo" 2>/dev/null && git remote -v 2>/dev/null | head -2
    done
} > 03_estrutura.txt 2>&1

# 2.4 Shell Config
{
    echo "=== .BASHRC ==="
    cat ~/.bashrc 2>/dev/null || echo "Não encontrado"
    echo -e "\n=== ALIASES ==="
    alias 2>&1 | head -30
    echo -e "\n=== ENV ==="
    env | sort | head -50
    echo -e "\n=== CRON JOBS ==="
    crontab -l 2>/dev/null || echo "Sem cron jobs"
} > 04_shell_config.txt 2>&1

# 2.5 Traefik
{
    if docker ps | grep -q traefik; then
        TRAEFIK_CONTAINER=$(docker ps -qf "name=traefik")
        echo "=== TRAEFIK CONFIG ==="
        docker exec "$TRAEFIK_CONTAINER" cat /etc/traefik/traefik.yml 2>/dev/null || echo "Não acessível"
        echo -e "\n=== TRAEFIK DYNAMIC ==="
        docker exec "$TRAEFIK_CONTAINER" cat /etc/traefik/dynamic.yml 2>/dev/null || echo "Não encontrado"
    else
        echo "Traefik não está em execução"
    fi
} > 05_traefik.txt 2>&1

# 2.6 Serviços
{
    echo "=== SYSTEMD SERVICES (ativas) ==="
    systemctl list-units --type=service --state=running 2>/dev/null | head -30 || echo "systemd não disponível"
    echo -e "\n=== ENABLED SERVICES ==="
    systemctl list-unit-files --type=service --state=enabled 2>/dev/null | head -30 || echo "N/A"
} > 06_servicos.txt 2>&1

# 2.7 Rede
{
    echo "=== NETWORK INTERFACES ==="
    ip addr 2>/dev/null || ifconfig
    echo -e "\n=== LISTENING PORTS ==="
    ss -tlnp 2>/dev/null | head -30 || netstat -tulpn 2>/dev/null | head -30
    echo -e "\n=== FIREWALL ==="
    ufw status verbose 2>/dev/null || echo "UFW não configurado"
} > 07_rede.txt 2>&1

# 2.8 Pacotes
{
    echo "=== APT PACKAGES (críticos) ==="
    dpkg -l 2>/dev/null | grep -E "docker|nodejs|python|git|curl|wget|vim|nginx" | head -30 || echo "N/A"
    echo -e "\n=== NPM GLOBAL ==="
    npm list -g --depth=0 2>/dev/null | head -20 || echo "npm não instalado"
} > 08_pacotes.txt 2>&1

echo "Coleta VPS concluída em: $VPS_AUDIT_DIR"
echo "$VPS_AUDIT_DIR"
VPS_SCRIPT_EOF
    
    # Executar no VPS
    if scp "$remote_script" "${VPS_HOST}:/tmp/audit-vps-remote.sh" 2>/dev/null && \
       ssh "${VPS_HOST}" "bash /tmp/audit-vps-remote.sh" 2>/dev/null; then
        
        # Obter diretório de resultado
        VPS_RESULT_DIR=$(ssh "${VPS_HOST}" "bash /tmp/audit-vps-remote.sh 2>&1 | tail -1")
        
        # Copiar resultados
        scp -r "${VPS_HOST}:${VPS_RESULT_DIR}/*" "${vps_dir}/" 2>/dev/null || true
        
        log_success "Coleta VPS concluída"
    else
        log_warning "Não foi possível conectar a VPS. Pule esta fase ou configure SSH."
    fi
    
    rm -f "$remote_script"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🔍 AUDITORIA COMPLETA - System Prompt Global"
    
    setup_directories
    collect_macos_complete
    
    # Perguntar sobre VPS (ou pular se não configurado)
    if [ -n "$VPS_HOST" ] && [ "$VPS_HOST" != "admin@senamfo.com.br" ]; then
        read -p "Executar coleta do VPS? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[SsYy]$ ]]; then
            collect_vps_complete
        fi
    else
        log_warning "VPS não configurado. Pulando coleta VPS."
    fi
    
    print_header "✅ AUDITORIA CONCLUÍDA"
    echo "📁 Resultados em: ${AUDIT_DIR}"
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar dados coletados em: ${AUDIT_DIR}"
    echo "  2. Executar script de análise: ${SCRIPT_DIR}/analise-e-sintese.sh"
    echo "  3. Gerar system_prompt_global consolidado"
}

main "$@"

