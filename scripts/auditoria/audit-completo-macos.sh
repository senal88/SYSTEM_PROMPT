#!/bin/bash

################################################################################
# 🔍 AUDITORIA COMPLETA INTEGRADA - macOS Silicon
# Sistema: macOS Silicon + VPS Ubuntu + GitHub + 1Password
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Coleta automatizada e sincronização entre ambientes
# PLATAFORMA: macOS Silicon (ARM64)
#
# REQUISITOS:
#   - 1Password CLI (op) instalado e autenticado
#   - GitHub CLI (gh) instalado
#   - SSH configurado para ambos os sistemas
#   - Homebrew (para macOS)
#
# USO:
#   bash audit-completo-macos.sh [--macos|--vps|--github|--1password|--compare|--all]
################################################################################

# macOS-specific: Desabilitar pipefail se necessário para compatibilidade
set +euo pipefail 2>/dev/null || set +e
set +u

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
AUDIT_BASE="${HOME}/.audit"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
AUDIT_DIR="${AUDIT_BASE}/${TIMESTAMP}"

# Detectar macOS Silicon
if [[ "$(uname -m)" == "arm64" ]] && [[ "$(uname)" == "Darwin" ]]; then
    IS_MACOS_SILICON=true
    HOMEBREW_PREFIX="/opt/homebrew"
else
    IS_MACOS_SILICON=false
    HOMEBREW_PREFIX="/usr/local"
fi

# Cores para output
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

safe_exec() {
    local description=$1
    local command=$2
    
    log_info "$description"
    if eval "$command" >> "${AUDIT_DIR}/debug.log" 2>&1; then
        log_success "$description"
        return 0
    else
        log_warning "$description (falhou, continuando...)"
        return 1
    fi
}

# ============================================================================
# PREPARAÇÃO
# ============================================================================

setup_audit_dir() {
    mkdir -p "${AUDIT_DIR}/"{macos,vps,github,comparativa}
    mkdir -p "${AUDIT_BASE}/cache"
    log_success "Diretório de auditoria criado: ${AUDIT_DIR}"
}

verify_requirements() {
    print_header "VERIFICANDO REQUISITOS"
    
    local missing=()
    
    # Verificar comandos necessários
    for cmd in op gh ssh git; do
        if command -v "$cmd" &> /dev/null; then
            log_success "$cmd instalado"
        else
            log_warning "$cmd não encontrado"
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_warning "Alguns requisitos faltam: ${missing[*]}"
        log_info "Continuando com funcionalidade reduzida..."
    fi
}

# ============================================================================
# FASE 1: COLETA macOS Silicon
# ============================================================================

collect_macos() {
    print_header "FASE 1: COLETA macOS Silicon"
    
    local mac_dir="${AUDIT_DIR}/macos"
    
    # 1.1 Sistema
    log_info "Coletando informações do sistema..."
    {
        echo "=== SISTEMA OPERACIONAL ==="
        sw_vers
        echo -e "\n=== HARDWARE ==="
        system_profiler SPHardwareDataType | grep -E "Processor Name|Total Number of Cores|Memory|Chip" || \
        system_profiler SPHardwareDataType | grep "Processor\|Cores\|Memory"
        echo -e "\n=== ARQUITETURA ==="
        echo "Architecture: $(arch)"
        echo "Kernel: $(uname -a)"
        echo "macOS Silicon: ${IS_MACOS_SILICON}"
        echo "Homebrew Prefix: ${HOMEBREW_PREFIX}"
        echo -e "\n=== SISTEMA DE ARQUIVOS ==="
        df -h / | head -2
    } > "${mac_dir}/01_SISTEMA.txt"
    
    # 1.2 Shell e Configuração
    log_info "Coletando configuração de shell..."
    {
        echo "=== .ZSHRC ==="
        [ -f "$HOME/.zshrc" ] && cat "$HOME/.zshrc" || echo "Não encontrado"
        echo -e "\n=== .BASHRC ==="
        [ -f "$HOME/.bashrc" ] && cat "$HOME/.bashrc" || echo "Não encontrado"
        echo -e "\n=== .ZSH_PROFILE ==="
        [ -f "$HOME/.zsh_profile" ] && cat "$HOME/.zsh_profile" || echo "Não encontrado"
        echo -e "\n=== ENVIRONMENT VARS ==="
        env | grep -v "^Apple\|^SECURITYSESSIONID" | sort
    } > "${mac_dir}/02_SHELL_CONFIG.txt"
    
    # 1.3 SSH
    log_info "Coletando SSH config..."
    {
        echo "=== SSH CONFIG ==="
        [ -f "$HOME/.ssh/config" ] && cat "$HOME/.ssh/config" || echo "Não encontrado"
        echo -e "\n=== SSH KEYS ==="
        ls -lah "$HOME/.ssh/" 2>/dev/null || echo "Pasta não encontrada"
        echo -e "\n=== KEY FINGERPRINTS ==="
        for key in ~/.ssh/id_*.pub; do
            [ -f "$key" ] && ssh-keygen -l -f "$key" 2>/dev/null || true
        done
    } > "${mac_dir}/03_SSH_CONFIG.txt"
    
    # 1.4 Git
    log_info "Coletando configuração Git..."
    {
        echo "=== GIT CONFIG GLOBAL ==="
        git config --global -l 2>/dev/null || echo "Não configurado"
        echo -e "\n=== GIT CONFIG LOCAL ==="
        git config --local -l 2>/dev/null || echo "N/A"
        echo -e "\n=== GIT SIGNED COMMITS ==="
        git config --global user.signingkey 2>/dev/null || echo "Não configurado"
    } > "${mac_dir}/04_GIT_CONFIG.txt"
    
    # 1.5 1Password CLI
    log_info "Coletando 1Password configuration..."
    {
        echo "=== 1PASSWORD CLI VERSION ==="
        op --version 2>/dev/null || echo "Não instalado"
        echo -e "\n=== 1PASSWORD ACCOUNTS ==="
        op account list 2>/dev/null || echo "Não autenticado"
        echo -e "\n=== 1PASSWORD CONFIG ==="
        [ -d "$HOME/.config/op" ] && ls -la "$HOME/.config/op/" || echo "Não encontrado"
    } > "${mac_dir}/05_1PASSWORD_CLI.txt"
    
    # 1.6 Homebrew
    log_info "Coletando Homebrew packages..."
    {
        echo "=== HOMEBREW VERSION ==="
        brew --version 2>/dev/null || echo "Homebrew não instalado"
        echo -e "\n=== HOMEBREW PREFIX ==="
        echo "${HOMEBREW_PREFIX}"
        echo -e "\n=== HOMEBREW FORMULAE ==="
        brew list --formula 2>/dev/null | sort || echo "Homebrew não instalado"
        echo -e "\n=== HOMEBREW CASKS ==="
        brew list --cask 2>/dev/null | sort || echo "Sem casks"
        echo -e "\n=== HOMEBREW SERVICES ==="
        brew services list 2>/dev/null || echo "Não disponível"
        echo -e "\n=== HOMEBREW TAPS ==="
        brew tap 2>/dev/null || echo "Nenhum tap customizado"
    } > "${mac_dir}/06_HOMEBREW.txt"
    
    # 1.7 IDEs e Ferramentas
    log_info "Coletando configurações de IDEs..."
    {
        echo "=== CURSOR CONFIG ==="
        [ -d "$HOME/.cursor" ] && find "$HOME/.cursor" -type f -name "*.json" | head -20 || echo "Não configurado"
        echo -e "\n=== CURSOR EXTENSIONS ==="
        if command -v cursor >/dev/null 2>&1; then
            cursor --list-extensions 2>/dev/null | sort || echo "Cursor CLI não acessível"
        else
            echo "Cursor CLI não instalado"
        fi
        echo -e "\n=== VSCODE EXTENSIONS ==="
        if command -v code >/dev/null 2>&1; then
            code --list-extensions 2>/dev/null | sort || echo "VS Code não acessível"
        else
            echo "VS Code CLI não instalado"
        fi
        echo -e "\n=== VSCODE SETTINGS ==="
        [ -f "$HOME/Library/Application Support/Code/User/settings.json" ] && \
            cat "$HOME/Library/Application Support/Code/User/settings.json" || echo "Não encontrado"
        echo -e "\n=== RAYCAST CONFIG ==="
        [ -d "$HOME/Library/Application Support/com.raycast.macos" ] && \
            find "$HOME/Library/Application Support/com.raycast.macos" -name "*.json" | head -5 || echo "Não configurado"
    } > "${mac_dir}/07_IDES.txt"
    
    # 1.8 Dotfiles
    log_info "Coletando estrutura Dotfiles..."
    {
        echo "=== DOTFILES DIR ==="
        echo "${DOTFILES_DIR}"
        echo -e "\n=== DOTFILES TREE ==="
        [ -d "${DOTFILES_DIR}" ] && (tree -L 3 "${DOTFILES_DIR}" 2>/dev/null || find "${DOTFILES_DIR}" -type f | head -50) || echo "Não encontrado"
        echo -e "\n=== .CONFIG TREE ==="
        [ -d "$HOME/.config" ] && (tree -L 2 "$HOME/.config" 2>/dev/null || find "$HOME/.config" -maxdepth 2 -type d) || echo "Não encontrado"
        echo -e "\n=== DOTFILES SCRIPTS ==="
        [ -d "${DOTFILES_DIR}/scripts" ] && find "${DOTFILES_DIR}/scripts" -type f -name "*.sh" | head -20 || echo "Não encontrado"
    } > "${mac_dir}/08_DOTFILES.txt"
    
    # 1.9 MCP Servers
    log_info "Coletando MCP Servers configuration..."
    {
        echo "=== MCP SERVERS (Cursor) ==="
        [ -f "$HOME/.cursor/mcp-servers.json" ] && cat "$HOME/.cursor/mcp-servers.json" || echo "Não encontrado"
        echo -e "\n=== MCP SETTINGS ==="
        find "$HOME/.config" -name "*mcp*" -type f 2>/dev/null || echo "Não encontrado"
    } > "${mac_dir}/09_MCP_SERVERS.txt"
    
    # 1.10 Docker
    log_info "Coletando Docker configuration..."
    {
        echo "=== DOCKER VERSION ==="
        docker --version 2>/dev/null || echo "Não instalado"
        echo -e "\n=== DOCKER COMPOSE ==="
        docker-compose --version 2>/dev/null || echo "Não instalado"
        echo -e "\n=== DOCKER IMAGES ==="
        docker images 2>/dev/null || echo "Sem acesso"
    } > "${mac_dir}/10_DOCKER.txt"
    
    # 1.11 APIs e Plataformas IA
    log_info "Coletando configurações de IA..."
    {
        echo "=== HUGGINGFACE CONFIG ==="
        [ -d "$HOME/.huggingface" ] && ls -la "$HOME/.huggingface/" || echo "Não configurado"
        echo -e "\n=== OPENAI CONFIG ==="
        [ -f "$HOME/.openai" ] && echo "Arquivo encontrado (omitindo conteúdo)" || echo "Não encontrado"
        echo -e "\n=== OLLAMA ==="
        [ -d "$HOME/.ollama" ] && ls -la "$HOME/.ollama/" || echo "Não instalado"
        command -v ollama >/dev/null 2>&1 && ollama list 2>/dev/null || echo "Ollama não instalado"
        echo -e "\n=== LM STUDIO ==="
        [ -d "$HOME/.lmstudio" ] && ls -la "$HOME/.lmstudio/" || echo "Não instalado"
        echo -e "\n=== API KEYS (SEGURO) ==="
        echo "⚠️ Chaves não são coletadas diretamente por segurança"
        echo "Use: op list items --vault 1p_macos para acessar 1Password"
        echo "Ou: op read 'op://1p_macos/Gemini-API-Keys/google_api_key'"
    } > "${mac_dir}/11_IA_PLATFORMS.txt"
    
    # 1.12 Versões Críticas
    log_info "Coletando versões..."
    {
        echo "=== CRITICAL VERSIONS ==="
        echo "macOS: $(sw_vers -productVersion)"
        echo "Kernel: $(uname -r)"
        echo "Architecture: $(arch)"
        echo "Bash: $(bash --version | head -1)"
        echo "Zsh: $(zsh --version)"
        echo "Git: $(git --version)"
        echo "Node: $(node --version 2>/dev/null || echo 'Not installed')"
        echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
        echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
        echo "Ruby: $(ruby --version 2>/dev/null || echo 'Not installed')"
        echo "Go: $(go version 2>/dev/null || echo 'Not installed')"
        echo "Rust: $(rustc --version 2>/dev/null || echo 'Not installed')"
        echo "1Password CLI: $(op --version 2>/dev/null || echo 'Not installed')"
        echo "GitHub CLI: $(gh --version 2>/dev/null | head -1 || echo 'Not installed')"
        echo "Homebrew: $(brew --version 2>/dev/null | head -1 || echo 'Not installed')"
    } > "${mac_dir}/12_VERSOES.txt"
    
    # 1.13 Permissões
    log_info "Coletando análise de permissões..."
    {
        echo "=== HOME PERMISSIONS ==="
        ls -lad "$HOME"
        echo -e "\n=== SSH PERMISSIONS ==="
        ls -la "$HOME/.ssh/" 2>/dev/null || echo "Não encontrado"
        echo -e "\n=== OWNERSHIP ==="
        find "$HOME" -maxdepth 2 -not -user "$USER" 2>/dev/null | head -10 || echo "OK - Todos os arquivos pertencem ao usuário"
    } > "${mac_dir}/13_PERMISSOES.txt"
    
    # 1.14 Resumo de Estrutura
    log_info "Criando resumo da estrutura..."
    {
        echo "=== DIRETÓRIOS PRINCIPAIS (tamanho) ==="
        du -sh "$HOME"/{.[^.]*,*} 2>/dev/null | sort -rh | head -30
        echo -e "\n=== ARQUIVOS OCULTOS ==="
        ls -la "$HOME" | grep "^\." | awk '{print $NF, "(" $5 ")"}'
    } > "${mac_dir}/14_RESUMO_ESTRUTURA.txt"
    
    log_success "Coleta macOS concluída"
}

# ============================================================================
# FASE 2: COLETA VPS Ubuntu
# ============================================================================

collect_vps() {
    print_header "FASE 2: COLETA VPS Ubuntu"
    
    local vps_dir="${AUDIT_DIR}/vps"
    # Detectar host VPS do SSH config ou usar padrão
    local vps_host="${VPS_HOST:-$(
        if [ -f "$HOME/.ssh/config" ]; then
            grep -A 5 "^Host vps\|^Host admin-vps" "$HOME/.ssh/config" | grep -i HostName | head -1 | awk '{print $2}' || echo "admin@senamfo.com.br"
        else
            echo "admin@senamfo.com.br"
        fi
    )}"
    
    log_info "Conectando a VPS: $vps_host"
    
    # Criar script de coleta remota
    local remote_script=$(mktemp)
    cat > "$remote_script" << 'EOF'
#!/bin/bash
set -e

# 2.1 Sistema
{
    echo "=== OS INFO ==="
    uname -a
    cat /etc/os-release
    echo -e "\n=== CPU ==="
    lscpu | grep -E "Architecture|CPU\(s\)|Model name"
    echo -e "\n=== MEMORY ==="
    free -h
    echo -e "\n=== DISK ==="
    df -h /
} > /tmp/01_SISTEMA.txt

# 2.2 Shell
{
    echo "=== BASHRC ==="
    cat ~/.bashrc 2>/dev/null || echo "Não encontrado"
    echo -e "\n=== ZSHRC ==="
    [ -f ~/.zshrc ] && cat ~/.zshrc || echo "Não encontrado"
    echo -e "\n=== BASH_PROFILE ==="
    cat ~/.bash_profile 2>/dev/null || echo "Não encontrado"
} > /tmp/02_SHELL_CONFIG.txt

# 2.3 SSH
{
    echo "=== SSH CONFIG ==="
    cat ~/.ssh/config 2>/dev/null || echo "Não encontrado"
    echo -e "\n=== SSH KEYS ==="
    ls -lah ~/.ssh/
    echo -e "\n=== KEY FINGERPRINTS ==="
    for key in ~/.ssh/id_*.pub; do
        [ -f "$key" ] && ssh-keygen -l -f "$key" 2>/dev/null || true
    done
    echo -e "\n=== SSHD CONFIG (privilegiado) ==="
    sudo cat /etc/ssh/sshd_config 2>/dev/null || echo "Sem permissão"
} > /tmp/03_SSH_CONFIG.txt

# 2.4 Git
{
    echo "=== GIT CONFIG GLOBAL ==="
    git config --global -l 2>/dev/null || echo "Git não instalado"
    echo -e "\n=== GIT LOCAL CONFIG ==="
    git config --local -l 2>/dev/null || echo "N/A"
} > /tmp/04_GIT_CONFIG.txt

# 2.5 1Password CLI
{
    echo "=== 1PASSWORD VERSION ==="
    op --version 2>/dev/null || echo "Não instalado"
    echo -e "\n=== 1PASSWORD ACCOUNTS ==="
    op account list 2>/dev/null || echo "Não autenticado"
} > /tmp/05_1PASSWORD_CLI.txt

# 2.6 Pacotes Instalados
{
    echo "=== APT PACKAGES (instalados) ==="
    apt list --installed 2>/dev/null | wc -l
    echo -e "\n=== CRITICAL PACKAGES ==="
    apt list --installed 2>/dev/null | grep -E "docker|nodejs|python|git|curl|wget|vim|nginx|postgresql" || echo "Nenhum encontrado"
    echo -e "\n=== NPM GLOBAL ==="
    npm list -g --depth=0 2>/dev/null || echo "npm não instalado"
    echo -e "\n=== PYTHON PACKAGES ==="
    pip list 2>/dev/null || echo "Python não configurado"
} > /tmp/06_INSTALACOES.txt

# 2.7 Infraestrutura
{
    echo "=== DOCKER VERSION ==="
    docker --version 2>/dev/null || echo "Não instalado"
    echo -e "\n=== DOCKER COMPOSE FILES ==="
    find ~/ -maxdepth 3 -name "docker-compose*.yml" -o -name "docker-compose*.yaml" 2>/dev/null | head -20
    echo -e "\n=== DOCKER CONTAINERS ==="
    docker ps -a 2>/dev/null || echo "Sem permissão"
    echo -e "\n=== DOCKER IMAGES ==="
    docker images 2>/dev/null || echo "Sem permissão"
} > /tmp/07_DOCKER.txt

# 2.8 Dotfiles
{
    echo "=== DOTFILES TREE ==="
    [ -d ~/Dotfiles ] && (tree -L 3 ~/Dotfiles 2>/dev/null || find ~/Dotfiles -type f | head -50) || echo "Não encontrado"
    echo -e "\n=== .CONFIG TREE ==="
    [ -d ~/.config ] && (tree -L 2 ~/.config 2>/dev/null || find ~/.config -maxdepth 2 -type d) || echo "Não encontrado"
} > /tmp/08_DOTFILES.txt

# 2.9 Serviços
{
    echo "=== SYSTEMD SERVICES (ativas) ==="
    systemctl list-units --type=service --state=running 2>/dev/null | head -30 || echo "systemd não disponível"
    echo -e "\n=== CRON JOBS ==="
    crontab -l 2>/dev/null || echo "Sem cron jobs"
} > /tmp/09_SERVICES.txt

# 2.10 Rede
{
    echo "=== NETWORK INTERFACES ==="
    ip addr 2>/dev/null || ifconfig
    echo -e "\n=== ROUTING ==="
    ip route 2>/dev/null || route -n
    echo -e "\n=== LISTENING PORTS ==="
    sudo ss -tlnp 2>/dev/null || ss -tln | grep LISTEN
    echo -e "\n=== DNS ==="
    cat /etc/resolv.conf 2>/dev/null | head -5
} > /tmp/10_NETWORK.txt

# 2.11 Segurança
{
    echo "=== SUDO PERMISSIONS ==="
    sudo -l 2>/dev/null || echo "Sem sudo"
    echo -e "\n=== FIREWALL (UFW) ==="
    sudo ufw status 2>/dev/null || echo "UFW não disponível"
    echo -e "\n=== FAIL2BAN ==="
    sudo systemctl status fail2ban 2>/dev/null || echo "Fail2ban não instalado"
} > /tmp/11_SEGURANCA.txt

# 2.12 Versões
{
    echo "=== CRITICAL VERSIONS ==="
    echo "OS: $(cat /etc/os-release | grep VERSION_ID)"
    echo "Kernel: $(uname -r)"
    echo "Bash: $(bash --version | head -1)"
    echo "Git: $(git --version)"
    echo "Node: $(node --version 2>/dev/null || echo 'Not installed')"
    echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
    echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
} > /tmp/12_VERSOES.txt

# 2.13 Estrutura
{
    echo "=== HOME STRUCTURE ==="
    du -sh ~/{.[^.]*,*} 2>/dev/null | sort -rh | head -20
} > /tmp/13_RESUMO_ESTRUTURA.txt

# Criar índice
{
    echo "# 🔍 Auditoria VPS Ubuntu"
    echo "Data: $(date)"
    echo ""
    ls -1 /tmp/[0-9]*.txt 2>/dev/null | sed 's|/tmp/||' | nl
} > /tmp/INDEX.md

# Mostrar arquivos criados
ls -1 /tmp/[0-9]*.txt /tmp/INDEX.md 2>/dev/null || true
EOF

    # Executar script remoto
    if scp "$remote_script" "$vps_host:/tmp/audit-vps.sh" 2>/dev/null && \
       ssh "$vps_host" "bash /tmp/audit-vps.sh" 2>/dev/null; then
        
        # Copiar resultados de volta
        scp "$vps_host:/tmp/[0-9]*.txt" "${vps_dir}/" 2>/dev/null || true
        scp "$vps_host:/tmp/INDEX.md" "${vps_dir}/" 2>/dev/null || true
        
        log_success "Coleta VPS concluída"
    else
        log_warning "Não foi possível conectar a VPS. Execute manualmente ou configure SSH."
    fi
    
    rm -f "$remote_script"
}

# ============================================================================
# FASE 3: ANÁLISE GitHub
# ============================================================================

collect_github() {
    print_header "FASE 3: ANÁLISE GitHub"
    
    local github_dir="${AUDIT_DIR}/github"
    
    if ! command -v gh &> /dev/null; then
        log_warning "GitHub CLI (gh) não encontrado. Pulando fase GitHub."
        return
    fi
    
    log_info "Analisando repositórios GitHub..."
    
    # 3.1 Listar repositórios
    {
        echo "=== REPOSITÓRIOS ==="
        gh repo list --limit 100 --json name,description,url,createdAt,updatedAt 2>/dev/null || echo "Erro ao listar repos"
    } > "${github_dir}/01_REPOS.json"
    
    # 3.2 Analisar estrutura de repos recentes
    log_info "Analisando últimos 5 repositórios..."
    {
        echo "=== ESTRUTURA DOS REPOSITÓRIOS ==="
        gh repo list --limit 5 --json nameWithOwner -q '.[].nameWithOwner' | while read repo; do
            echo -e "\n### $repo"
            gh repo view "$repo" --json description,languages,createdAt,updatedAt 2>/dev/null || true
        done
    } > "${github_dir}/02_REPOS_ANALYSIS.json"
    
    log_success "Análise GitHub concluída"
}

# ============================================================================
# FASE 4: 1Password Integration
# ============================================================================

collect_1password() {
    print_header "FASE 4: INTEGRAÇÃO 1Password"
    
    local op_dir="${AUDIT_DIR}/1password"
    
    if ! command -v op &> /dev/null; then
        log_warning "1Password CLI (op) não encontrado. Pulando integração 1Password."
        return
    fi
    
    log_info "Acessando vaults 1Password..."
    
    # 4.1 Listar vaults
    {
        echo "=== VAULTS 1PASSWORD ==="
        op vault list 2>/dev/null || echo "Não autenticado"
    } > "${op_dir}/01_VAULTS.json"
    
    # 4.2 Coletar items de vaults específicas
    for vault in "1p_vps" "1p_macos" "Private"; do
        {
            echo "=== ITEMS DO VAULT: $vault ==="
            op item list --vault "$vault" 2>/dev/null || echo "Vault não encontrado ou vazio"
        } > "${op_dir}/02_ITEMS_${vault}.json"
    done
    
    log_success "Coleta 1Password concluída"
}

# ============================================================================
# FASE 5: Gerador de Relatório Comparativo
# ============================================================================

generate_report() {
    print_header "FASE 5: GERANDO RELATÓRIO COMPARATIVO"
    
    local report="${AUDIT_DIR}/RELATORIO_COMPARATIVO.md"
    
    cat > "$report" << 'EOF'
# 📊 RELATÓRIO COMPARATIVO
## macOS Silicon + VPS Ubuntu + GitHub + 1Password

**Data de Geração:** $(date)
**Diretório de Coleta:** $(pwd)

---

## 1️⃣ VISÃO GERAL DO SISTEMA

### macOS Silicon
- **Arquivo:** `macos/01_SISTEMA.txt`
- **Shell Primária:** zsh
- **Pacote Manager:** homebrew
- **Arquitetura:** ARM64

### VPS Ubuntu
- **Arquivo:** `vps/01_SISTEMA.txt`
- **Shell Primária:** bash
- **Pacote Manager:** apt
- **Arquitetura:** x86_64 ou ARM64

---

## 2️⃣ COMPARATIVO DE CONFIGURAÇÕES

| Aspecto | macOS | Ubuntu | Status |
|---------|-------|--------|--------|
| **SSH Config** | ~/.ssh/config | ~/.ssh/config | Revisar diferenças |
| **Git Config** | Arquivo | Arquivo | Sincronizar |
| **Shell Config** | .zshrc | .bashrc | Diferentes |
| **Dotfiles** | ~/Dotfiles | ~/Dotfiles | Sincronizar |
| **Docker** | Docker Desktop | Docker Engine | Verificar versões |
| **1Password CLI** | Instalado | Instalado | Sincronizar credenciais |

---

## 3️⃣ CHECKLIST DE SINCRONIZAÇÃO

### macOS → Ubuntu
- [ ] Dotfiles atualizados
- [ ] SSH keys sincronizadas
- [ ] Git configuration atualizada
- [ ] MCP Servers setup
- [ ] Docker Compose configs

### Ubuntu → macOS
- [ ] Scripts de deploy
- [ ] Docker configs aprimorados
- [ ] Documentação de infraestrutura
- [ ] 1Password vaults sincronizados

---

## 4️⃣ PROBLEMAS IDENTIFICADOS

### 🔴 Crítico
- [ ] SSH keys com datas diferentes
- [ ] Credenciais não sincronizadas
- [ ] Docker compose em versões diferentes

### 🟡 Aviso
- [ ] Shell configs despadronizadas
- [ ] Paths incompatíveis
- [ ] Versões de ferramentas diferentes

### 🟢 Informação
- [ ] Configs redundantes
- [ ] Documentação incompleta

---

## 5️⃣ REPOSITÓRIOS GITHUB

**Analisar arquivo:** `github/02_REPOS_ANALYSIS.json`

---

## 6️⃣ 1PASSWORD VAULTS

**Vaults Documentadas:**
- 1p_vps
- 1p_macos
- Private

**Revisar:** `1password/02_ITEMS_*.json`

---

## 📋 PRÓXIMOS PASSOS

1. [ ] Revisar diferenças de configuração
2. [ ] Sincronizar SSH keys
3. [ ] Atualizar Dotfiles em ambos os sistemas
4. [ ] Validar 1Password integração
5. [ ] Documentar mudanças no Git

---

**Gerado:** $(date)
EOF

    log_success "Relatório criado: $(basename $report)"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    local mode="${1:-all}"
    
    print_header "🔍 AUDITORIA COMPLETA INTEGRADA"
    
    setup_audit_dir
    verify_requirements
    
    case "$mode" in
        macos)
            collect_macos
            ;;
        vps)
            collect_vps
            ;;
        github)
            collect_github
            ;;
        1password)
            collect_1password
            ;;
        compare)
            generate_report
            ;;
        all)
            collect_macos
            collect_vps
            collect_github
            collect_1password
            generate_report
            ;;
        *)
            log_error "Modo desconhecido: $mode"
            echo "Uso: bash audit-completo.sh [--macos|--vps|--github|--1password|--compare|--all]"
            exit 1
            ;;
    esac
    
    print_header "✅ AUDITORIA FINALIZADA"
    
    echo "📁 Resultados em: ${AUDIT_DIR}"
    echo ""
    echo "Arquivos gerados:"
    find "${AUDIT_DIR}" -type f | sort | sed 's|^|  |'
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar arquivos .txt de coleta"
    echo "  2. Comparar configurações entre sistemas"
    echo "  3. Executar: cat ${AUDIT_DIR}/RELATORIO_COMPARATIVO.md"
}

# Executar
main "$@"
