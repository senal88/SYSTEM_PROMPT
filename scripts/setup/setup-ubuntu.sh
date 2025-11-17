#!/bin/bash

#################################################################################
# Script de Setup Completo para Ubuntu VPS 22.04+
# Versão: 2.0.1
# Objetivo: Configurar ambiente de desenvolvimento completo no Ubuntu
#################################################################################

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

#################################################################################
# SEÇÃO 1: ATUALIZAÇÃO DO SISTEMA
#################################################################################

update_system() {
    log "Atualizando sistema..."
    sudo apt update && sudo apt upgrade -y
    success "Sistema atualizado"
}

#################################################################################
# SEÇÃO 2: INSTALAÇÃO DE FERRAMENTAS BASE
#################################################################################

install_base_tools() {
    log "Instalando ferramentas base..."
    
    sudo apt install -y \
        git curl wget vim nano \
        build-essential \
        zsh bash-completion \
        ca-certificates \
        gnupg lsb-release \
        software-properties-common \
        apt-transport-https \
        unzip zip \
        tree htop \
        net-tools \
        openssh-server \
        ufw

    success "Ferramentas base instaladas"
}

#################################################################################
# SEÇÃO 3: INSTALAÇÃO DO DOCKER
#################################################################################

install_docker() {
    log "Instalando Docker..."
    
    # Adicionar repositório Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Adicionar usuário ao grupo docker
    sudo usermod -aG docker $USER
    
    success "Docker instalado"
    warning "Faça logout/login para usar Docker sem sudo"
}

#################################################################################
# SEÇÃO 4: INSTALAÇÃO DO NODE.JS
#################################################################################

install_nodejs() {
    log "Instalando Node.js..."
    
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    
    success "Node.js $(node --version) instalado"
}

#################################################################################
# SEÇÃO 5: INSTALAÇÃO DO PYTHON E FERRAMENTAS
#################################################################################

install_python() {
    log "Instalando Python e ferramentas..."
    
    sudo apt install -y \
        python3 python3-pip python3-venv \
        python3-dev python3-setuptools
    
    # Instalar ferramentas Python úteis
    pip3 install --user --upgrade \
        pip setuptools wheel \
        black pylint flake8 mypy \
        pytest pytest-cov \
        ipython jupyter
    
    success "Python $(python3 --version) instalado"
}

#################################################################################
# SEÇÃO 6: CONFIGURAÇÃO DO ZSH E OH MY ZSH
#################################################################################

setup_zsh() {
    log "Configurando Zsh e Oh My Zsh..."
    
    # Instalar Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Instalar plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    # Configurar .zshrc
    cat >> ~/.zshrc << 'EOF'

# Custom configuration
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=vim

# Aliases
alias la='ls -lah'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias docker='sudo docker'  # Remove após logout/login

# Functions
mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Python virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
EOF
    
    success "Zsh configurado"
    warning "Execute 'chsh -s $(which zsh)' para mudar shell padrão"
}

#################################################################################
# SEÇÃO 7: CONFIGURAÇÃO DO GIT
#################################################################################

setup_git() {
    log "Configurando Git..."
    
    if [ -z "$(git config --global user.name)" ]; then
        read -p "Git user.name: " git_name
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        read -p "Git user.email: " git_email
        git config --global user.email "$git_email"
    fi
    
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor vim
    
    success "Git configurado"
}

#################################################################################
# SEÇÃO 8: CONFIGURAÇÃO DO SSH
#################################################################################

setup_ssh() {
    log "Configurando SSH..."
    
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f ~/.ssh/id_ed25519 -N ""
        success "Chave SSH gerada: ~/.ssh/id_ed25519.pub"
    fi
    
    # Configurar SSH server
    sudo systemctl enable ssh
    sudo systemctl start ssh
    
    success "SSH configurado"
}

#################################################################################
# SEÇÃO 9: INSTALAÇÃO DE FERRAMENTAS ADICIONAIS
#################################################################################

install_additional_tools() {
    log "Instalando ferramentas adicionais..."
    
    # FZF (fuzzy finder)
    if [ ! -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
    
    # Ripgrep
    sudo apt install -y ripgrep
    
    # Bat (cat melhorado)
    sudo apt install -y bat
    mkdir -p ~/.local/bin
    ln -sf /usr/batcat ~/.local/bin/bat || true
    
    # Exa (ls melhorado)
    sudo apt install -y exa || true
    
    success "Ferramentas adicionais instaladas"
}

#################################################################################
# SEÇÃO 10: CONFIGURAÇÃO DE FIREWALL
#################################################################################

setup_firewall() {
    log "Configurando firewall..."
    
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw --force enable
    
    success "Firewall configurado"
}

#################################################################################
# SEÇÃO 11: INSTALAÇÃO DE FERRAMENTAS DE MONITORAMENTO
#################################################################################

install_monitoring_tools() {
    log "Instalando ferramentas de monitoramento..."
    
    # Htop (já instalado)
    # Netdata (opcional, requer configuração adicional)
    # Prometheus Node Exporter (opcional)
    
    success "Ferramentas de monitoramento disponíveis"
}

#################################################################################
# SEÇÃO 12: CONFIGURAÇÃO DE TIMEZONE E LOCALE
#################################################################################

setup_locale() {
    log "Configurando timezone e locale..."
    
    # Configurar timezone (ajustar conforme necessário)
    sudo timedatectl set-timezone America/Sao_Paulo
    
    # Configurar locale
    sudo locale-gen pt_BR.UTF-8
    sudo update-locale LANG=pt_BR.UTF-8
    
    success "Timezone e locale configurados"
}

#################################################################################
# SEÇÃO 13: INSTALAÇÃO DE FERRAMENTAS DE DESENVOLVIMENTO ADICIONAIS
#################################################################################

install_dev_tools() {
    log "Instalando ferramentas de desenvolvimento adicionais..."
    
    # Terraform
    if ! command -v terraform &> /dev/null; then
        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt update
        sudo apt install -y terraform
    fi
    
    # Kubectl
    if ! command -v kubectl &> /dev/null; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    fi
    
    # Helm
    if ! command -v helm &> /dev/null; then
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi
    
    success "Ferramentas de desenvolvimento instaladas"
}

#################################################################################
# MAIN - EXECUÇÃO PRINCIPAL
#################################################################################

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Setup Completo Ubuntu VPS 22.04+                    ║"
    echo "║              Versão 2.0.1 - Universal Setup                ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    update_system
    install_base_tools
    install_docker
    install_nodejs
    install_python
    setup_zsh
    setup_git
    setup_ssh
    install_additional_tools
    install_monitoring_tools
    setup_locale
    install_dev_tools
    setup_firewall
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              SETUP COMPLETO E FUNCIONAL                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Todas as etapas completadas!"
    echo ""
    echo "Próximas ações:"
    echo "1. Faça logout/login para aplicar mudanças do Docker"
    echo "2. Execute 'chsh -s $(which zsh)' para mudar shell padrão"
    echo "3. Configure suas chaves SSH: cat ~/.ssh/id_ed25519.pub"
    echo "4. Instale VSCode Remote ou configure DevContainers"
    echo ""
}

main "$@"


