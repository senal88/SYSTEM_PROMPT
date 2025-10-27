#!/bin/bash

# 🚀 Dotfiles Installation Script
# Baseado nas melhores práticas dos repositórios awesome-dotfiles

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configurações
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
INSTALL_LOG="$DOTFILES_DIR/install.log"

# Funções de log
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$INSTALL_LOG"
}

success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1" | tee -a "$INSTALL_LOG"
}

error() {
    echo -e "${RED}[ERRO]${NC} $1" | tee -a "$INSTALL_LOG"
    exit 1
}

warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1" | tee -a "$INSTALL_LOG"
}

info() {
    echo -e "${CYAN}[INFO]${NC} $1" | tee -a "$INSTALL_LOG"
}

# Banner
show_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 DOTFILES INSTALLER                       ║"
    echo "║                                                              ║"
    echo "║  Configurações centralizadas e automatizadas                ║"
    echo "║  para desenvolvimento produtivo                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    # Verificar sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        success "Sistema: macOS detectado"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        success "Sistema: Linux detectado"
    else
        error "Sistema operacional não suportado: $OSTYPE"
    fi
    
    # Verificar Git
    if command -v git >/dev/null 2>&1; then
        success "Git: $(git --version)"
    else
        error "Git não encontrado. Instale o Git primeiro."
    fi
    
    # Verificar Zsh
    if command -v zsh >/dev/null 2>&1; then
        success "Zsh: $(zsh --version | head -n1)"
    else
        error "Zsh não encontrado. Instale o Zsh primeiro."
    fi
    
    # Verificar Homebrew (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew >/dev/null 2>&1; then
            success "Homebrew: $(brew --version | head -n1)"
        else
            warning "Homebrew não encontrado. Instalando..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
}

# Criar backup das configurações existentes
create_backup() {
    log "Criando backup das configurações existentes..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Arquivos de configuração para backup
    config_files=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.gitconfig"
        "$HOME/.vimrc"
        "$HOME/.config/nvim"
    )
    
    for file in "${config_files[@]}"; do
        if [[ -e "$file" ]]; then
            cp -r "$file" "$BACKUP_DIR/"
            success "Backup: $file"
        fi
    done
    
    success "Backup criado em: $BACKUP_DIR"
}

# Instalar dependências
install_dependencies() {
    log "Instalando dependências..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Homebrew packages
        brew_packages=(
            "git"
            "zsh"
            "curl"
            "wget"
            "jq"
            "fzf"
            "ripgrep"
            "fd"
            "bat"
            "exa"
            "tree"
            "neovim"
            "node"
            "python"
            "rust"
        )
        
        for package in "${brew_packages[@]}"; do
            if ! brew list "$package" >/dev/null 2>&1; then
                log "Instalando $package..."
                brew install "$package"
            else
                success "$package já instalado"
            fi
        done
    fi
    
    # Node.js packages globais
    npm_packages=(
        "@google/gemini-cli"
        "typescript"
        "ts-node"
        "nodemon"
        "eslint"
        "prettier"
    )
    
    for package in "${npm_packages[@]}"; do
        if ! npm list -g "$package" >/dev/null 2>&1; then
            log "Instalando $package..."
            npm install -g "$package"
        else
            success "$package já instalado"
        fi
    done
}

# Configurar shell
setup_shell() {
    log "Configurando shell..."
    
    # Instalar Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        success "Oh My Zsh já instalado"
    fi
    
    # Configurar Zsh
    if [[ -f "$DOTFILES_DIR/modules/shell/zshrc" ]]; then
        cp "$DOTFILES_DIR/modules/shell/zshrc" "$HOME/.zshrc"
        success "Zsh configurado"
    fi
    
    # Configurar aliases
    if [[ -f "$DOTFILES_DIR/modules/shell/aliases" ]]; then
        cp "$DOTFILES_DIR/modules/shell/aliases" "$HOME/.aliases"
        success "Aliases configurados"
    fi
    
    # Configurar funções
    if [[ -f "$DOTFILES_DIR/modules/shell/functions" ]]; then
        cp "$DOTFILES_DIR/modules/shell/functions" "$HOME/.functions"
        success "Funções configuradas"
    fi
}

# Configurar Git
setup_git() {
    log "Configurando Git..."
    
    if [[ -f "$DOTFILES_DIR/modules/git/gitconfig" ]]; then
        cp "$DOTFILES_DIR/modules/git/gitconfig" "$HOME/.gitconfig"
        success "Git configurado"
    fi
    
    # Configurar hooks
    if [[ -d "$DOTFILES_DIR/modules/git/hooks" ]]; then
        mkdir -p "$HOME/.git_template/hooks"
        cp -r "$DOTFILES_DIR/modules/git/hooks"/* "$HOME/.git_template/hooks/"
        chmod +x "$HOME/.git_template/hooks"/*
        success "Git hooks configurados"
    fi
}

# Configurar aplicações
setup_apps() {
    log "Configurando aplicações..."
    
    # VSCode/Cursor
    if [[ -d "$DOTFILES_DIR/modules/apps/vscode" ]]; then
        mkdir -p "$HOME/.vscode"
        cp -r "$DOTFILES_DIR/modules/apps/vscode"/* "$HOME/.vscode/"
        success "VSCode configurado"
    fi
    
    # Neovim
    if [[ -d "$DOTFILES_DIR/modules/apps/nvim" ]]; then
        mkdir -p "$HOME/.config/nvim"
        cp -r "$DOTFILES_DIR/modules/apps/nvim"/* "$HOME/.config/nvim/"
        success "Neovim configurado"
    fi
}

# Configurar ferramentas de IA
setup_ai() {
    log "Configurando ferramentas de IA..."
    
    # Gemini CLI
    if command -v gemini >/dev/null 2>&1; then
        success "Gemini CLI já instalado"
    else
        log "Instalando Gemini CLI..."
        npm install -g @google/gemini-cli
    fi
    
    # Configurar variáveis de ambiente para IA
    if [[ -f "$DOTFILES_DIR/env/ai.env" ]]; then
        source "$DOTFILES_DIR/env/ai.env"
        success "Variáveis de IA configuradas"
    fi
}

# Configurar desenvolvimento
setup_dev() {
    log "Configurando ambiente de desenvolvimento..."
    
    # Node.js (NVM)
    if [[ ! -d "$HOME/.nvm" ]]; then
        log "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    else
        success "NVM já instalado"
    fi
    
    # Python (Pyenv)
    if [[ ! -d "$HOME/.pyenv" ]]; then
        log "Instalando Pyenv..."
        curl https://pyenv.run | bash
    else
        success "Pyenv já instalado"
    fi
    
    # Rust
    if ! command -v rustc >/dev/null 2>&1; then
        log "Instalando Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else
        success "Rust já instalado"
    fi
}

# Configurar segurança
setup_security() {
    log "Configurando segurança..."
    
    # 1Password CLI
    if command -v op >/dev/null 2>&1; then
        success "1Password CLI já instalado"
    else
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install --cask 1password-cli
        fi
    fi
    
    # Configurar secrets
    if [[ -d "$DOTFILES_DIR/credentials" ]]; then
        log "Configurando credenciais..."
        # Aqui você pode adicionar lógica para configurar secrets
        success "Credenciais configuradas"
    fi
}

# Criar links simbólicos
create_symlinks() {
    log "Criando links simbólicos..."
    
    # Arquivos de configuração para linkar
    config_files=(
        ".zshrc"
        ".bashrc"
        ".gitconfig"
        ".vimrc"
        ".aliases"
        ".functions"
    )
    
    for file in "${config_files[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            if [[ -L "$HOME/$file" ]]; then
                success "$file já é um link simbólico"
            else
                mv "$HOME/$file" "$HOME/${file}.backup"
                ln -sf "$DOTFILES_DIR/modules/shell/$file" "$HOME/$file"
                success "Link simbólico criado: $file"
            fi
        fi
    done
}

# Configurar permissões
setup_permissions() {
    log "Configurando permissões..."
    
    # Scripts executáveis
    find "$DOTFILES_DIR/scripts" -name "*.sh" -exec chmod +x {} \;
    success "Permissões de scripts configuradas"
    
    # Diretórios
    chmod 755 "$DOTFILES_DIR"
    success "Permissões de diretórios configuradas"
}

# Validar instalação
validate_installation() {
    log "Validando instalação..."
    
    # Verificar arquivos de configuração
    config_files=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
    )
    
    for file in "${config_files[@]}"; do
        if [[ -f "$file" ]]; then
            success "✅ $file"
        else
            error "❌ $file não encontrado"
        fi
    done
    
    # Verificar comandos
    commands=("git" "zsh" "node" "python3")
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            success "✅ $cmd disponível"
        else
            warning "⚠️ $cmd não encontrado"
        fi
    done
}

# Função principal
main() {
    show_banner
    
    log "Iniciando instalação do Dotfiles..."
    log "Diretório: $DOTFILES_DIR"
    log "Backup: $BACKUP_DIR"
    log "Log: $INSTALL_LOG"
    
    # Verificar argumentos
    case "${1:-}" in
        --minimal)
            log "Modo: Instalação mínima"
            INSTALL_MODE="minimal"
            ;;
        --dev)
            log "Modo: Instalação para desenvolvimento"
            INSTALL_MODE="dev"
            ;;
        --ai)
            log "Modo: Instalação com foco em IA"
            INSTALL_MODE="ai"
            ;;
        *)
            log "Modo: Instalação completa"
            INSTALL_MODE="full"
            ;;
    esac
    
    # Executar etapas
    check_prerequisites
    create_backup
    install_dependencies
    
    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        setup_shell
        setup_git
        setup_apps
    fi
    
    if [[ "$INSTALL_MODE" == "dev" || "$INSTALL_MODE" == "full" ]]; then
        setup_dev
    fi
    
    if [[ "$INSTALL_MODE" == "ai" || "$INSTALL_MODE" == "full" ]]; then
        setup_ai
    fi
    
    if [[ "$INSTALL_MODE" == "full" ]]; then
        setup_security
    fi
    
    create_symlinks
    setup_permissions
    validate_installation
    
    # Finalização
    echo ""
    success "🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
    echo ""
    echo "📁 Configurações instaladas em: $DOTFILES_DIR"
    echo "💾 Backup criado em: $BACKUP_DIR"
    echo "📝 Log da instalação: $INSTALL_LOG"
    echo ""
    echo "🔄 Para aplicar as configurações, execute:"
    echo "   source ~/.zshrc"
    echo ""
    echo "📚 Documentação: $DOTFILES_DIR/docs/"
    echo "🔧 Scripts: $DOTFILES_DIR/scripts/"
    echo ""
    echo "✨ Aproveite seu novo ambiente de desenvolvimento!"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
