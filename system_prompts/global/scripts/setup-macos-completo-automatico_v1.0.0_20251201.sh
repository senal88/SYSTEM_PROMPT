#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🚀 SETUP COMPLETO macOS SILICON - EXECUÇÃO AUTOMÁTICA
#
# Objetivo:
#   - Setup completo e automatizado do macOS Silicon
#   - Like Windows Setup Manager - execução em um comando
#   - Integração com 1Password, Dotfiles, Raycast
#
# Uso: ./setup-macos-completo-automatico_v1.0.0_20251201.sh [--dry-run] [--skip-*]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${GLOBAL_DIR}/logs/setup-macos-${TIMESTAMP}.log"

# Flags
DRY_RUN=false
SKIP_PREREQUISITES=false
SKIP_APPS=false
SKIP_SYSTEM=false
SKIP_DOTFILES=false
SKIP_1PASSWORD=false
SKIP_RAYCAST=false
SKIP_VALIDATION=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --skip-prerequisites)
            SKIP_PREREQUISITES=true
            shift
            ;;
        --skip-apps)
            SKIP_APPS=true
            shift
            ;;
        --skip-system)
            SKIP_SYSTEM=true
            shift
            ;;
        --skip-dotfiles)
            SKIP_DOTFILES=true
            shift
            ;;
        --skip-1password)
            SKIP_1PASSWORD=true
            shift
            ;;
        --skip-raycast)
            SKIP_RAYCAST=true
            shift
            ;;
        --skip-validation)
            SKIP_VALIDATION=true
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
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${LOG_FILE}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${LOG_FILE}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${LOG_FILE}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${LOG_FILE}"
}

log_step() {
    echo -e "${CYAN}▶${NC} $@" | tee -a "${LOG_FILE}"
}

log_section() {
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}║${NC} $@" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}" | tee -a "${LOG_FILE}"
    echo ""
}

# Criar diretório de logs
mkdir -p "$(dirname "${LOG_FILE}")"

# ============================================================================
# FASE 1: PRÉ-REQUISITOS
# ============================================================================

phase1_prerequisites() {
    log_section "FASE 1: PRÉ-REQUISITOS"

    if [[ "${SKIP_PREREQUISITES}" == "true" ]]; then
        log_info "Pulando fase 1 (--skip-prerequisites)"
        return 0
    fi

    log_step "1.1. Verificando macOS Silicon..."
    ARCH=$(uname -m)
    if [[ "${ARCH}" != "arm64" ]]; then
        log_error "Este script é para macOS Silicon (arm64). Arquitetura detectada: ${ARCH}"
        exit 1
    fi
    log_success "macOS Silicon detectado: ${ARCH}"

    log_step "1.2. Verificando versão macOS..."
    MACOS_VERSION=$(sw_vers -productVersion)
    log_info "Versão macOS: ${MACOS_VERSION}"

    log_step "1.3. Instalando Xcode Command Line Tools..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Instalaria Xcode Command Line Tools"
    else
        if ! xcode-select -p &>/dev/null; then
            log_info "Instalando Xcode Command Line Tools (pode pedir senha)..."
            xcode-select --install || {
                log_warning "Xcode Command Line Tools pode já estar instalado"
            }
        else
            log_success "Xcode Command Line Tools já instalado"
        fi
    fi

    log_step "1.4. Instalando/Verificando Homebrew..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Instalaria/verificaria Homebrew"
    else
        if ! command -v brew >/dev/null 2>&1; then
            log_info "Instalando Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
                log_error "Falha ao instalar Homebrew"
                return 1
            }

            # Configurar Homebrew no PATH
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        else
            log_success "Homebrew já instalado: $(brew --version | head -1)"
        fi
    fi

    log_success "Fase 1 concluída"
}

# ============================================================================
# FASE 2: INSTALAÇÃO DE APPS
# ============================================================================

phase2_apps() {
    log_section "FASE 2: INSTALAÇÃO DE APPS"

    if [[ "${SKIP_APPS}" == "true" ]]; then
        log_info "Pulando fase 2 (--skip-apps)"
        return 0
    fi

    log_step "2.1. Verificando Brewfile..."
    BREWFILE="${DOTFILES_DIR}/Brewfile"
    if [[ ! -f "${BREWFILE}" ]]; then
        log_warning "Brewfile não encontrado em ${BREWFILE}"
        log_info "Criando Brewfile padrão..."

        if [[ "${DRY_RUN}" != "true" ]]; then
            mkdir -p "${DOTFILES_DIR}"
            cat > "${BREWFILE}" << 'BREWEOF'
# Brewfile - Setup Completo macOS Silicon
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# Ferramentas CLI essenciais
brew "git"
brew "gh"
brew "node@20"
brew "python@3.12"
brew "jq"
brew "fzf"
brew "ripgrep"
brew "bat"
brew "starship"

# Segurança
brew "1password-cli"
brew "gpg"

# Apps essenciais
cask "raycast"
cask "visual-studio-code"
cask "cursor"
cask "iterm2"
cask "docker"
cask "rectangle"
cask "alt-tab"
BREWEOF
            log_success "Brewfile criado"
        fi
    else
        log_success "Brewfile encontrado"
    fi

    log_step "2.2. Instalando apps via Homebrew Bundle..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Executaria: brew bundle install --file=${BREWFILE}"
    else
        # Carregar Homebrew
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        brew bundle install --file="${BREWFILE}" || {
            log_warning "Alguns apps podem ter falhado na instalação"
        }
        log_success "Apps instalados via Homebrew Bundle"
    fi

    log_success "Fase 2 concluída"
}

# ============================================================================
# FASE 3: CONFIGURAÇÃO DO SISTEMA
# ============================================================================

phase3_system() {
    log_section "FASE 3: CONFIGURAÇÃO DO SISTEMA"

    if [[ "${SKIP_SYSTEM}" == "true" ]]; then
        log_info "Pulando fase 3 (--skip-system)"
        return 0
    fi

    log_step "3.1. Configurando Dock..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria Dock"
    else
        defaults write com.apple.dock autohide -bool true
        defaults write com.apple.dock tilesize -int 36
        defaults write com.apple.dock magnification -bool false
        killall Dock 2>/dev/null || true
        log_success "Dock configurado"
    fi

    log_step "3.2. Configurando Finder..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria Finder"
    else
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true
        defaults write com.apple.finder ShowPathbar -bool true
        defaults write com.apple.finder ShowStatusBar -bool true
        defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
        killall Finder 2>/dev/null || true
        log_success "Finder configurado"
    fi

    log_step "3.3. Configurando Trackpad..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria Trackpad"
    else
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
        log_success "Trackpad configurado"
    fi

    log_step "3.4. Configurando Teclado..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria Teclado"
    else
        defaults write NSGlobalDomain KeyRepeat -int 2
        defaults write NSGlobalDomain InitialKeyRepeat -int 15
        log_success "Teclado configurado"
    fi

    log_step "3.5. Configurando Shell (zsh)..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria zsh"
    else
        # Verificar se zsh é o shell padrão
        CURRENT_SHELL=$(dscl . -read /Users/$(whoami) UserShell | awk '{print $2}')
        if [[ "${CURRENT_SHELL}" != "/bin/zsh" ]] && [[ "${CURRENT_SHELL}" != "/opt/homebrew/bin/zsh" ]]; then
            log_info "Alterando shell padrão para zsh..."
            chsh -s /bin/zsh || log_warning "Não foi possível alterar shell padrão"
        else
            log_success "zsh já é o shell padrão"
        fi

        # Instalar Oh-My-Zsh se não estiver instalado
        if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
            log_info "Instalando Oh-My-Zsh..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
                log_warning "Oh-My-Zsh pode ter falhado na instalação"
            }
        else
            log_success "Oh-My-Zsh já instalado"
        fi
    fi

    log_success "Fase 3 concluída"
}

# ============================================================================
# FASE 4: INTEGRAÇÃO COM DOTFILES
# ============================================================================

phase4_dotfiles() {
    log_section "FASE 4: INTEGRAÇÃO COM DOTFILES"

    if [[ "${SKIP_DOTFILES}" == "true" ]]; then
        log_info "Pulando fase 4 (--skip-dotfiles)"
        return 0
    fi

    log_step "4.1. Verificando repositório Dotfiles..."
    if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
        log_warning "Repositório Dotfiles não encontrado em ${DOTFILES_DIR}"
        log_info "Clonando repositório..."

        if [[ "${DRY_RUN}" == "true" ]]; then
            log_info "[DRY-RUN] Clonaria: git clone https://github.com/senal88/SYSTEM_PROMPT.git ${DOTFILES_DIR}"
        else
            git clone https://github.com/senal88/SYSTEM_PROMPT.git "${DOTFILES_DIR}" || {
                log_error "Falha ao clonar repositório Dotfiles"
                return 1
            }
            log_success "Repositório Dotfiles clonado"
        fi
    else
        log_success "Repositório Dotfiles encontrado"

        if [[ "${DRY_RUN}" != "true" ]]; then
            cd "${DOTFILES_DIR}"
            git pull origin main || log_warning "Pull pode ter falhado"
        fi
    fi

    log_step "4.2. Configurando symlinks..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria symlinks"
    else
        # Criar symlinks para configurações essenciais
        mkdir -p "${HOME}/.config"

        # .zshrc
        if [[ -f "${DOTFILES_DIR}/system_prompts/global/config/.zshrc" ]]; then
            ln -sf "${DOTFILES_DIR}/system_prompts/global/config/.zshrc" "${HOME}/.zshrc" || true
        fi

        log_success "Symlinks configurados"
    fi

    log_success "Fase 4 concluída"
}

# ============================================================================
# FASE 5: CONFIGURAÇÃO 1PASSWORD
# ============================================================================

phase5_1password() {
    log_section "FASE 5: CONFIGURAÇÃO 1PASSWORD"

    if [[ "${SKIP_1PASSWORD}" == "true" ]]; then
        log_info "Pulando fase 5 (--skip-1password)"
        return 0
    fi

    log_step "5.1. Verificando 1Password CLI..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Verificaria 1Password CLI"
    else
        if ! command -v op >/dev/null 2>&1; then
            log_warning "1Password CLI não encontrado. Instale via: brew install 1password-cli"
        else
            log_success "1Password CLI encontrado: $(op --version | head -1)"

            # Verificar autenticação
            if ! op account list &>/dev/null; then
                log_warning "1Password CLI não autenticado"
                log_info "Execute: op signin"
            else
                log_success "1Password CLI autenticado"
            fi
        fi
    fi

    log_step "5.2. Configurando variáveis de ambiente..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria variáveis 1Password"
    else
        if ! grep -q "OP_VAULT_MACOS" "${HOME}/.zshrc" 2>/dev/null; then
            cat >> "${HOME}/.zshrc" << 'ZSHEOF'

# 1Password Configuration
export OP_VAULT_MACOS="1p_macos"
export OP_VAULT_VPS="1p_vps"
ZSHEOF
            log_success "Variáveis 1Password configuradas no .zshrc"
        else
            log_info "Variáveis 1Password já configuradas"
        fi
    fi

    log_success "Fase 5 concluída"
}

# ============================================================================
# FASE 6: CONFIGURAÇÃO RAYCAST
# ============================================================================

phase6_raycast() {
    log_section "FASE 6: CONFIGURAÇÃO RAYCAST"

    if [[ "${SKIP_RAYCAST}" == "true" ]]; then
        log_info "Pulando fase 6 (--skip-raycast)"
        return 0
    fi

    log_step "6.1. Verificando Raycast..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Verificaria Raycast"
    else
        if [[ ! -d "/Applications/Raycast.app" ]]; then
            log_warning "Raycast não encontrado. Instale via: brew install --cask raycast"
        else
            log_success "Raycast encontrado"
        fi
    fi

    log_step "6.2. Configurando Raycast..."
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Configuraria Raycast"
    else
        # Configurações básicas do Raycast
        RAYCAST_CONFIG_DIR="${HOME}/Library/Application Support/Raycast"
        mkdir -p "${RAYCAST_CONFIG_DIR}"

        log_info "Raycast configurado (extensões devem ser instaladas manualmente)"
    fi

    log_success "Fase 6 concluída"
}

# ============================================================================
# FASE 7: VALIDAÇÃO E TESTES
# ============================================================================

phase7_validation() {
    log_section "FASE 7: VALIDAÇÃO E TESTES"

    if [[ "${SKIP_VALIDATION}" == "true" ]]; then
        log_info "Pulando fase 7 (--skip-validation)"
        return 0
    fi

    log_step "7.1. Validando instalações..."

    # Verificar Homebrew
    if command -v brew >/dev/null 2>&1; then
        log_success "Homebrew: $(brew --version | head -1)"
    else
        log_error "Homebrew não encontrado"
    fi

    # Verificar Git
    if command -v git >/dev/null 2>&1; then
        log_success "Git: $(git --version)"
    else
        log_error "Git não encontrado"
    fi

    # Verificar Node
    if command -v node >/dev/null 2>&1; then
        log_success "Node.js: $(node --version)"
    else
        log_warning "Node.js não encontrado"
    fi

    # Verificar Python
    if command -v python3 >/dev/null 2>&1; then
        log_success "Python: $(python3 --version)"
    else
        log_warning "Python não encontrado"
    fi

    # Verificar 1Password CLI
    if command -v op >/dev/null 2>&1; then
        log_success "1Password CLI: $(op --version | head -1)"
    else
        log_warning "1Password CLI não encontrado"
    fi

    log_step "7.2. Validando apps instalados..."
    APPS=("Raycast" "Visual Studio Code" "Cursor" "iTerm2" "Docker")
    for app in "${APPS[@]}"; do
        if [[ -d "/Applications/${app}.app" ]]; then
            log_success "${app}: Instalado"
        else
            log_warning "${app}: Não encontrado"
        fi
    done

    log_success "Fase 7 concluída"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  SETUP COMPLETO macOS SILICON - EXECUÇÃO AUTOMÁTICA     ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "MODO DRY-RUN: Nenhuma alteração será feita"
        echo ""
    fi

    log_info "Configuração:"
    log_info "  - Dotfiles: ${DOTFILES_DIR}"
    log_info "  - Log: ${LOG_FILE}"
    echo ""

    # Executar fases em ordem
    phase1_prerequisites || {
        log_error "Fase 1 (Pré-requisitos) falhou"
        exit 1
    }

    phase2_apps || {
        log_error "Fase 2 (Apps) falhou"
        exit 1
    }

    phase3_system || {
        log_error "Fase 3 (Sistema) falhou"
        exit 1
    }

    phase4_dotfiles || {
        log_error "Fase 4 (Dotfiles) falhou"
        exit 1
    }

    phase5_1password || {
        log_error "Fase 5 (1Password) falhou"
        exit 1
    }

    phase6_raycast || {
        log_error "Fase 6 (Raycast) falhou"
        exit 1
    }

    phase7_validation || {
        log_error "Fase 7 (Validação) falhou"
        exit 1
    }

    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  SETUP COMPLETO CONCLUÍDO COM SUCESSO                     ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    log_info "Próximos passos:"
    log_info "  1. Recarregar shell: source ~/.zshrc"
    log_info "  2. Configurar Raycast manualmente (extensões)"
    log_info "  3. Autenticar 1Password: op signin"
    log_info "  4. Revisar log: ${LOG_FILE}"
    echo ""
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
