#!/usr/bin/env bash
################################################################################
# 🚀 SETUP macOS SILICON - EXPERIÊNCIA TIPO WINDOWS
#
# DESCRIÇÃO:
#   Script completo para configurar macOS Silicon com experiência
#   similar ao Windows, incluindo lançador, gerenciamento de janelas,
#   snap de janelas, remapeamento de teclado e terminal avançado.
#
# VERSÃO: 1.0.0
# DATA: 2025-01-15
# STATUS: ATIVO
################################################################################

set -euo pipefail

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
LOG_FILE="${HOME}/.macos_windows_setup.log"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Funções de log
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[✅]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[⚠️]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "ERROR")
            echo -e "${RED}[❌]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "DEBUG")
            echo -e "${CYAN}[DEBUG]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
    esac

    echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Validar sistema
validate_system() {
    print_header "🔍 VALIDAÇÃO DO SISTEMA"

    log "INFO" "Verificando sistema operacional..."

    if [[ "$(uname)" != "Darwin" ]]; then
        log "ERROR" "Este script é apenas para macOS"
        exit 1
    fi

    local os_version=$(sw_vers -productVersion)
    log "SUCCESS" "macOS detectado: ${os_version}"

    log "INFO" "Verificando arquitetura..."
    local arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        log "SUCCESS" "Apple Silicon detectado"
    else
        log "WARNING" "Arquitetura detectada: ${arch} (não é Apple Silicon)"
    fi

    log "INFO" "Verificando Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        log "ERROR" "Homebrew não encontrado. Instale primeiro:"
        log "INFO" "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    local brew_version=$(brew --version | head -1)
    log "SUCCESS" "Homebrew instalado: ${brew_version}"
}

# Instalar ferramentas principais
install_tools() {
    print_header "📦 INSTALAÇÃO DE FERRAMENTAS"

    log "INFO" "Atualizando Homebrew..."
    brew update || log "WARNING" "Falha ao atualizar Homebrew"

    # Lista de ferramentas a instalar
    local tools=(
        "raycast"
        "alt-tab"
        "rectangle"
        "karabiner-elements"
        "iterm2"
    )

    log "INFO" "Instalando ferramentas de experiência Windows..."

    for tool in "${tools[@]}"; do
        log "INFO" "Instalando ${tool}..."

        if brew list --cask "${tool}" >/dev/null 2>&1; then
            log "SUCCESS" "${tool} já instalado"
        else
            if brew install --cask "${tool}" >/dev/null 2>&1; then
                log "SUCCESS" "${tool} instalado com sucesso"
            else
                log "ERROR" "Falha ao instalar ${tool}"
            fi
        fi
    done
}

# Configurar Raycast
configure_raycast() {
    print_header "🚀 CONFIGURAÇÃO DO RAYCAST"

    log "INFO" "Configurando Raycast como lançador central..."

    # Criar configuração básica
    local raycast_dir="${HOME}/Library/Application Support/Raycast"
    mkdir -p "${raycast_dir}"

    log "INFO" "Definindo atalho global (⌘ Space)..."

    # Configurar atalho via defaults (se aplicável)
    defaults write com.raycast.macos globalHotkey -string "cmd+space" 2>/dev/null || log "WARNING" "Não foi possível configurar atalho via defaults"

    log "SUCCESS" "Raycast configurado"
    log "INFO" "Abra o Raycast e configure manualmente:"
    log "INFO" "  - Atalho global: ⌘ Space (ou outro de sua preferência)"
    log "INFO" "  - Extensões úteis para desenvolvimento"
}

# Configurar AltTab
configure_alttab() {
    print_header "🪟 CONFIGURAÇÃO DO ALTTAB"

    log "INFO" "Configurando AltTab para alternância de janelas..."

    # Configurações via defaults
    defaults write com.lwouis.alt-tab-mac holdShortcut -string "alt" 2>/dev/null || log "WARNING" "Não foi possível configurar via defaults"

    log "SUCCESS" "AltTab configurado"
    log "INFO" "Abra o AltTab e configure manualmente:"
    log "INFO" "  - Atalho: Alt+Tab (padrão)"
    log "INFO" "  - Mostrar miniaturas de janelas"
    log "INFO" "  - Comportamento com Spaces"
}

# Configurar Rectangle
configure_rectangle() {
    print_header "📐 CONFIGURAÇÃO DO RECTANGLE"

    log "INFO" "Configurando Rectangle para snap de janelas..."

    # Configurações de atalhos padrão
    log "INFO" "Atalhos padrão do Rectangle:"
    log "INFO" "  - ⌃⌘← : Meia tela esquerda"
    log "INFO" "  - ⌃⌘→ : Meia tela direita"
    log "INFO" "  - ⌃⌘↑ : Maximizar"
    log "INFO" "  - ⌃⌘↓ : Minimizar/Restaurar"

    log "SUCCESS" "Rectangle configurado"
    log "INFO" "Abra o Rectangle e ajuste atalhos conforme preferência"
}

# Configurar Karabiner-Elements
configure_karabiner() {
    print_header "⌨️  CONFIGURAÇÃO DO KARABINER-ELEMENTS"

    log "INFO" "Configurando Karabiner-Elements para remapeamento de teclado..."

    local karabiner_dir="${HOME}/.config/karabiner"
    mkdir -p "${karabiner_dir}"

    log "INFO" "Criando configuração básica..."

    # Criar configuração básica (JSON mínimo)
    cat > "${karabiner_dir}/karabiner.json" << 'EOF'
{
  "global": {
    "check_for_updates_on_startup": true,
    "show_in_menu_bar": true,
    "show_profile_name_in_menu_bar": false
  },
  "profiles": [
    {
      "name": "Default profile",
      "selected": true,
      "simple_modifications": [],
      "fn_function_keys": [],
      "complex_modifications": {
        "rules": []
      }
    }
  ]
}
EOF

    log "SUCCESS" "Karabiner-Elements configurado"
    log "INFO" "Abra o Karabiner-Elements e configure:"
    log "INFO" "  - Remapeamento de modificadores"
    log "INFO" "  - Hyper key (se necessário)"
    log "INFO" "  - Atalhos específicos tipo Windows"
}

# Configurar iTerm2
configure_iterm2() {
    print_header "💻 CONFIGURAÇÃO DO ITERM2"

    log "INFO" "Configurando iTerm2 como terminal padrão..."

    # Configurar iTerm2 como terminal padrão
    if [[ -d "/Applications/iTerm.app" ]]; then
        log "INFO" "Configurando iTerm2..."

        # Criar diretório de configurações
        local iterm_dir="${HOME}/.iterm2"
        mkdir -p "${iterm_dir}"

        log "SUCCESS" "iTerm2 configurado"
        log "INFO" "Configure iTerm2 manualmente:"
        log "INFO" "  - Perfis com temas adequados"
        log "INFO" "  - Fontes para desenvolvimento"
        log "INFO" "  - Atalhos para abas e splits"
    else
        log "WARNING" "iTerm2 não encontrado em /Applications/iTerm.app"
    fi
}

# Configurar Finder
configure_finder() {
    print_header "📁 CONFIGURAÇÃO DO FINDER"

    log "INFO" "Configurando Finder para experiência similar ao Windows..."

    # Mostrar barras de caminho
    defaults write com.apple.finder ShowPathbar -bool true

    # Mostrar barra de status
    defaults write com.apple.finder ShowStatusBar -bool true

    # Mostrar extensões de arquivo
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Visualização de coluna como padrão
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

    # Não mostrar avisos ao alterar extensão
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Desabilitar aviso de alteração de arquivo
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Mostrar todos os arquivos ocultos
    defaults write com.apple.finder AppleShowAllFiles -bool true

    log "SUCCESS" "Finder configurado"

    log "INFO" "Reiniciando Finder..."
    killall Finder 2>/dev/null || true

    log "SUCCESS" "Configurações do Finder aplicadas"
}

# Configurar Dock
configure_dock() {
    print_header "📊 CONFIGURAÇÃO DO DOCK"

    log "INFO" "Configurando Dock minimalista..."

    # Ocultar Dock automaticamente
    defaults write com.apple.dock autohide -bool true

    # Reduzir tamanho do Dock
    defaults write com.apple.dock tilesize -int 36

    # Minimizar janelas no ícone da aplicação
    defaults write com.apple.dock minimize-to-application -bool true

    # Não mostrar aplicativos recentes
    defaults write com.apple.dock show-recents -bool false

    # Remover delay ao mostrar Dock
    defaults write com.apple.dock autohide-delay -float 0

    # Remover animação ao mostrar Dock
    defaults write com.apple.dock autohide-time-modifier -float 0

    log "SUCCESS" "Dock configurado"

    log "INFO" "Reiniciando Dock..."
    killall Dock 2>/dev/null || true

    log "SUCCESS" "Configurações do Dock aplicadas"
}

# Configurar Mission Control
configure_mission_control() {
    print_header "🪟 CONFIGURAÇÃO DO MISSION CONTROL"

    log "INFO" "Configurando Mission Control para experiência tipo Windows..."

    # Desabilitar reorganização automática de Spaces
    defaults write com.apple.dock mru-spaces -bool false

    # Não agrupar janelas por aplicação
    defaults write com.apple.dock expose-group-by-app -bool false

    log "SUCCESS" "Mission Control configurado"
}

# Criar aliases e funções úteis
create_shell_config() {
    print_header "🐚 CONFIGURAÇÃO DO SHELL"

    log "INFO" "Criando aliases e funções úteis..."

    local shell_config="${DOTFILES_DIR}/scripts/setup/macos-windows-aliases.sh"

    cat > "${shell_config}" << 'EOF'
#!/usr/bin/env bash
# Aliases e funções para experiência tipo Windows no macOS

# Abrir pasta atual no Finder (como Explorer)
alias openhere='open .'

# Abrir arquivo/pasta no Finder
alias explorer='open'

# Listar processos (como Task Manager)
alias tasklist='ps aux'

# Mostrar informações do sistema
alias systeminfo='system_profiler SPSoftwareDataType'

# Alternar visibilidade de arquivos ocultos
alias showhidden='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidehidden='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

# Reiniciar Finder
alias restartfinder='killall Finder'

# Reiniciar Dock
alias restartdock='killall Dock'

EOF

    chmod +x "${shell_config}"

    log "SUCCESS" "Aliases criados em: ${shell_config}"
    log "INFO" "Adicione ao seu .zshrc:"
    log "INFO" "  source ${shell_config}"
}

# Validar instalação
validate_installation() {
    print_header "✅ VALIDAÇÃO DA INSTALAÇÃO"

    local all_ok=true

    log "INFO" "Validando ferramentas instaladas..."

    local tools=(
        "raycast:Raycast"
        "alt-tab:AltTab"
        "rectangle:Rectangle"
        "karabiner-elements:Karabiner-Elements"
        "iterm2:iTerm"
    )

    for tool_info in "${tools[@]}"; do
        local tool_name="${tool_info%%:*}"
        local display_name="${tool_info##*:}"

        if brew list --cask "${tool_name}" >/dev/null 2>&1; then
            log "SUCCESS" "${display_name} instalado"
        else
            log "ERROR" "${display_name} NÃO instalado"
            all_ok=false
        fi
    done

    if [[ "$all_ok" == "true" ]]; then
        log "SUCCESS" "Todas as ferramentas instaladas com sucesso!"
        return 0
    else
        log "ERROR" "Algumas ferramentas não foram instaladas"
        return 1
    fi
}

# Gerar documentação
generate_documentation() {
    print_header "📚 GERANDO DOCUMENTAÇÃO"

    local docs_dir="${DOTFILES_DIR}/docs/macos-windows-experience"
    mkdir -p "${docs_dir}"

    log "INFO" "Criando documentação..."

    cat > "${docs_dir}/README.md" << 'EOF'
# 🚀 macOS Silicon - Experiência Tipo Windows

Configuração completa do macOS para ter experiência similar ao Windows.

## Ferramentas Instaladas

### Lançador
- **Raycast** - Central de comandos (⌘ Space)

### Gerenciamento de Janelas
- **AltTab** - Alternância de janelas (Alt+Tab)
- **Rectangle** - Snap de janelas

### Teclado
- **Karabiner-Elements** - Remapeamento de teclado

### Terminal
- **iTerm2** - Terminal avançado

## Atalhos Principais

### Rectangle (Snap de Janelas)
- `⌃⌘←` : Meia tela esquerda
- `⌃⌘→` : Meia tela direita
- `⌃⌘↑` : Maximizar
- `⌃⌘↓` : Minimizar/Restaurar

### AltTab
- `Alt+Tab` : Alternar entre janelas
- `Shift+Alt+Tab` : Alternar reverso

### Raycast
- `⌘ Space` : Abrir Raycast (configurável)

## Configurações Aplicadas

### Finder
- Barra de caminho visível
- Extensões de arquivo mostradas
- Visualização em colunas
- Arquivos ocultos visíveis

### Dock
- Ocultação automática
- Tamanho reduzido
- Sem aplicativos recentes

## Próximos Passos

1. Configurar atalhos personalizados no Raycast
2. Ajustar perfis do iTerm2
3. Configurar remapeamentos no Karabiner-Elements
4. Personalizar atalhos do Rectangle conforme preferência

EOF

    log "SUCCESS" "Documentação criada em: ${docs_dir}/README.md"
}

# Função principal
main() {
    print_header "🚀 SETUP macOS SILICON - EXPERIÊNCIA TIPO WINDOWS"

    log "INFO" "Iniciando setup completo..."

    validate_system
    install_tools
    configure_raycast
    configure_alttab
    configure_rectangle
    configure_karabiner
    configure_iterm2
    configure_finder
    configure_dock
    configure_mission_control
    create_shell_config
    generate_documentation

    print_header "✅ SETUP CONCLUÍDO"

    if validate_installation; then
        log "SUCCESS" "Setup completo concluído com sucesso!"
        log "INFO" "Log completo disponível em: ${LOG_FILE}"
        log "INFO" "Documentação disponível em: ${DOTFILES_DIR}/docs/macos-windows-experience/"
        echo ""
        echo "Próximos passos:"
        echo "1. Abrir Raycast e configurar atalho global"
        echo "2. Configurar AltTab conforme preferência"
        echo "3. Ajustar atalhos do Rectangle"
        echo "4. Configurar Karabiner-Elements"
        echo "5. Configurar perfis do iTerm2"
        echo ""
        return 0
    else
        log "ERROR" "Setup concluído com alguns erros. Verifique o log: ${LOG_FILE}"
        return 1
    fi
}

main "$@"












