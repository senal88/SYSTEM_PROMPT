#!/usr/bin/env bash
# sync-profiles.sh
# Sincroniza perfis do Cursor, VSCode e outras configurações entre ambientes

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Diretórios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$DOTFILES_HOME"
SOURCE_DIR="$DOTFILES_DIR/vscode"
SOURCE_CONTEXT_DIR="$DOTFILES_DIR/context-engineering"

# Detectar sistema operacional
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

# Paths específicos por OS
if [ "$OS" == "macos" ]; then
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
    CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
elif [ "$OS" == "linux" ]; then
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    CURSOR_USER_DIR="$HOME/.config/Cursor/User"
    CLAUDE_DESKTOP_CONFIG=""
else
    echo -e "${RED}❌ Sistema operacional não suportado: $OSTYPE${NC}"
    exit 1
fi

# Funções de logging
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_error() {
    echo -e "${RED}❌${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

log_section() {
    echo ""
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
}

# Função para criar backup
create_backup() {
    local target_dir="$1"
    local backup_dir="${target_dir}.backup.$(date +%Y%m%d_%H%M%S)"

    if [ -d "$target_dir" ] || [ -f "$target_dir" ]; then
        log_info "Criando backup: $backup_dir"
        cp -r "$target_dir" "$backup_dir" 2>/dev/null || cp "$target_dir" "$backup_dir" 2>/dev/null
        log_success "Backup criado"
    fi
}

# Função para sincronizar VSCode
sync_vscode() {
    log_section "📝 Sincronizando VSCode"

    if [ ! -d "$SOURCE_DIR" ]; then
        log_warning "Diretório fonte não encontrado: $SOURCE_DIR"
        return 1
    fi

    # Criar diretório se não existir
    mkdir -p "$VSCODE_USER_DIR"

    # Backup
    create_backup "$VSCODE_USER_DIR"

    # Sincronizar settings.json
    if [ -f "$SOURCE_DIR/settings.json" ]; then
        log_info "Sincronizando settings.json"
        cp "$SOURCE_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
        log_success "settings.json sincronizado"
    fi

    # Sincronizar keybindings.json
    if [ -f "$SOURCE_DIR/keybindings.json" ]; then
        log_info "Sincronizando keybindings.json"
        cp "$SOURCE_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
        log_success "keybindings.json sincronizado"
    fi

    # Sincronizar extensions.json
    if [ -f "$SOURCE_DIR/extensions.json" ]; then
        log_info "Sincronizando extensions.json"
        cp "$SOURCE_DIR/extensions.json" "$VSCODE_USER_DIR/extensions.json"
        log_success "extensions.json sincronizado"
    fi

    # Sincronizar snippets
    if [ -d "$SOURCE_DIR/snippets" ]; then
        log_info "Sincronizando snippets"
        mkdir -p "$VSCODE_USER_DIR/snippets"
        cp -r "$SOURCE_DIR/snippets/"* "$VSCODE_USER_DIR/snippets/" 2>/dev/null || true
        log_success "Snippets sincronizados ($(ls -1 "$VSCODE_USER_DIR/snippets" | wc -l) arquivos)"
    fi

    log_success "VSCode sincronizado"
}

# Função para sincronizar Cursor
sync_cursor() {
    log_section "🎯 Sincronizando Cursor"

    if [ ! -d "$SOURCE_DIR" ]; then
        log_warning "Diretório fonte não encontrado: $SOURCE_DIR"
        return 1
    fi

    # Criar diretório se não existir
    mkdir -p "$CURSOR_USER_DIR"

    # Backup
    create_backup "$CURSOR_USER_DIR"

    # Sincronizar settings.json
    if [ -f "$SOURCE_DIR/settings.json" ]; then
        log_info "Sincronizando settings.json"
        cp "$SOURCE_DIR/settings.json" "$CURSOR_USER_DIR/settings.json"
        log_success "settings.json sincronizado"
    fi

    # Sincronizar keybindings.json
    if [ -f "$SOURCE_DIR/keybindings.json" ]; then
        log_info "Sincronizando keybindings.json"
        cp "$SOURCE_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
        log_success "keybindings.json sincronizado"
    fi

    # Sincronizar extensions.json
    if [ -f "$SOURCE_DIR/extensions.json" ]; then
        log_info "Sincronizando extensions.json"
        cp "$SOURCE_DIR/extensions.json" "$CURSOR_USER_DIR/extensions.json"
        log_success "extensions.json sincronizado"
    fi

    # Sincronizar snippets
    if [ -d "$SOURCE_DIR/snippets" ]; then
        log_info "Sincronizando snippets"
        mkdir -p "$CURSOR_USER_DIR/snippets"
        cp -r "$SOURCE_DIR/snippets/"* "$CURSOR_USER_DIR/snippets/" 2>/dev/null || true
        log_success "Snippets sincronizados ($(ls -1 "$CURSOR_USER_DIR/snippets" | wc -l) arquivos)"
    fi

    # Sincronizar .cursorrules
    if [ -f "$SOURCE_CONTEXT_DIR/.cursorrules" ]; then
        log_info "Sincronizando .cursorrules"
        cp "$SOURCE_CONTEXT_DIR/.cursorrules" "$HOME/.cursorrules"
        log_success ".cursorrules sincronizado"
    fi

    log_success "Cursor sincronizado"
}

# Função para sincronizar Claude Desktop
sync_claude_desktop() {
    log_section "🤖 Sincronizando Claude Desktop"

    if [ -z "$CLAUDE_DESKTOP_CONFIG" ]; then
        log_warning "Claude Desktop não disponível neste sistema"
        return 0
    fi

    CLAUDE_CONFIG_SOURCE="$DOTFILES_DIR/claude-cloud-knowledge/01_CONFIGURACOES/claude_desktop_config.json"

    if [ ! -f "$CLAUDE_CONFIG_SOURCE" ]; then
        log_warning "Arquivo de configuração não encontrado: $CLAUDE_CONFIG_SOURCE"
        return 1
    fi

    # Criar diretório se não existir
    mkdir -p "$(dirname "$CLAUDE_DESKTOP_CONFIG")"

    # Backup
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        create_backup "$CLAUDE_DESKTOP_CONFIG"
    fi

    log_info "Sincronizando claude_desktop_config.json"
    cp "$CLAUDE_CONFIG_SOURCE" "$CLAUDE_DESKTOP_CONFIG"
    log_success "Claude Desktop sincronizado"
}

# Função para sincronizar Git config
sync_git() {
    log_section "📦 Sincronizando Git"

    GIT_CONFIG_SOURCE="$DOTFILES_DIR/vscode/.gitconfig"

    if [ -f "$GIT_CONFIG_SOURCE" ]; then
        log_info "Sincronizando .gitconfig"
        create_backup "$HOME/.gitconfig"
        cp "$GIT_CONFIG_SOURCE" "$HOME/.gitconfig"
        log_success ".gitconfig sincronizado"
    else
        log_warning ".gitconfig não encontrado em $GIT_CONFIG_SOURCE"
    fi

    # Sincronizar .gitignore_global se existir
    GITIGNORE_SOURCE="$DOTFILES_DIR/vscode/.gitignore_global"
    if [ -f "$GITIGNORE_SOURCE" ]; then
        log_info "Sincronizando .gitignore_global"
        cp "$GITIGNORE_SOURCE" "$HOME/.gitignore_global"
        log_success ".gitignore_global sincronizado"
    fi
}

# Função para sincronizar SSH config
sync_ssh() {
    log_section "🔐 Sincronizando SSH"

    SSH_CONFIG_SOURCE="$DOTFILES_DIR/vscode/.ssh/config"

    if [ -f "$SSH_CONFIG_SOURCE" ]; then
        log_info "Sincronizando SSH config"
        mkdir -p "$HOME/.ssh"
        create_backup "$HOME/.ssh/config"
        cp "$SSH_CONFIG_SOURCE" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
        log_success "SSH config sincronizado"
    else
        log_warning "SSH config não encontrado em $SSH_CONFIG_SOURCE"
    fi
}

# Função para sincronizar Cursor Rules específicas por ambiente
sync_cursor_rules() {
    log_section "📋 Sincronizando Cursor Rules"

    if [ ! -d "$SOURCE_CONTEXT_DIR/cursor-rules" ]; then
        log_warning "Diretório cursor-rules não encontrado"
        return 1
    fi

    # Determinar qual arquivo usar baseado no OS
    if [ "$OS" == "macos" ]; then
        RULES_FILE="$SOURCE_CONTEXT_DIR/cursor-rules/.cursorrules.macos"
    elif [ "$OS" == "linux" ]; then
        RULES_FILE="$SOURCE_CONTEXT_DIR/cursor-rules/.cursorrules.vps"
    fi

    if [ -f "$RULES_FILE" ]; then
        log_info "Sincronizando Cursor Rules para $OS"
        create_backup "$HOME/.cursorrules"
        cp "$RULES_FILE" "$HOME/.cursorrules"
        log_success "Cursor Rules sincronizado"
    else
        log_warning "Arquivo de regras não encontrado: $RULES_FILE"
    fi
}

# Função para listar diferenças
show_diff() {
    log_section "🔍 Verificando Diferenças"

    if [ ! -d "$SOURCE_DIR" ]; then
        log_error "Diretório fonte não encontrado: $SOURCE_DIR"
        return 1
    fi

    echo -e "${BLUE}Diferenças encontradas:${NC}"
    echo ""

    # VSCode settings
    if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ -f "$SOURCE_DIR/settings.json" ]; then
        if ! diff -q "$VSCODE_USER_DIR/settings.json" "$SOURCE_DIR/settings.json" &>/dev/null; then
            echo -e "${YELLOW}⚠️  VSCode settings.json tem diferenças${NC}"
        fi
    fi

    # Cursor settings
    if [ -f "$CURSOR_USER_DIR/settings.json" ] && [ -f "$SOURCE_DIR/settings.json" ]; then
        if ! diff -q "$CURSOR_USER_DIR/settings.json" "$SOURCE_DIR/settings.json" &>/dev/null; then
            echo -e "${YELLOW}⚠️  Cursor settings.json tem diferenças${NC}"
        fi
    fi

    log_success "Verificação concluída"
}

# Função principal
main() {
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${CYAN}🔄 Sincronização de Perfis${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}Sistema:${NC} $OS"
    echo -e "${BLUE}Dotfiles:${NC} $DOTFILES_DIR"
    echo ""

    # Verificar se está no modo diff
    if [ "${1:-}" == "--diff" ] || [ "${1:-}" == "-d" ]; then
        show_diff
        exit 0
    fi

    # Sincronizar tudo
    sync_vscode
    sync_cursor
    sync_claude_desktop
    sync_cursor_rules
    sync_git
    sync_ssh

    log_section "✅ Sincronização Concluída"

    echo -e "${GREEN}✅ Todos os perfis foram sincronizados${NC}"
    echo ""
    echo -e "${BLUE}📝 Próximos passos:${NC}"
    echo "   1. Reinicie VSCode/Cursor para aplicar mudanças"
    echo "   2. Verifique se as extensões estão instaladas"
    echo "   3. Teste os snippets e keybindings"
    echo ""
}

# Executar função principal
main "$@"

