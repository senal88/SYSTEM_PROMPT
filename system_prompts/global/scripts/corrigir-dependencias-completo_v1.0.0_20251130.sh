#!/usr/bin/env bash

################################################################################
# 🔧 CORREÇÃO COMPLETA DE DEPENDÊNCIAS
# Corrige Homebrew PATH, instala dependências faltantes e configura tudo
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Correção completa e imediata de todas as dependências
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# PASSO 1: CARREGAR HOMEBREW NO PATH ATUAL
# ============================================================================

load_homebrew() {
    print_header "🔧 PASSO 1: CARREGANDO HOMEBREW NO PATH ATUAL"

    # Detectar onde está o Homebrew
    if [ -f "/opt/homebrew/bin/brew" ]; then
        BREW_DIR="/opt/homebrew"
        log_success "Homebrew encontrado em: ${BREW_DIR}"
    elif [ -f "/usr/local/bin/brew" ]; then
        BREW_DIR="/usr/local"
        log_success "Homebrew encontrado em: ${BREW_DIR}"
    else
        log_error "Homebrew não encontrado"
        return 1
    fi

    # Carregar Homebrew no shell atual
    eval "$(${BREW_DIR}/bin/brew shellenv)"

    if command -v brew >/dev/null 2>&1; then
        BREW_VERSION=$(brew --version | head -1)
        log_success "Homebrew carregado: ${BREW_VERSION}"
        return 0
    else
        log_error "Falha ao carregar Homebrew"
        return 1
    fi
}

# ============================================================================
# PASSO 2: VERIFICAR E INSTALAR DEPENDÊNCIAS
# ============================================================================

check_and_install() {
    local tool="$1"
    local install_cmd="${2:-}"
    local check_cmd="${3:-command -v $tool}"

    if eval "$check_cmd" >/dev/null 2>&1; then
        local version=$($tool --version 2>/dev/null | head -1 || echo "instalado")
        log_success "${tool}: ${version}"
        return 0
    else
        log_warning "${tool}: não instalado"
        if [ -n "$install_cmd" ]; then
            log_info "Instalando ${tool}..."
            if eval "$install_cmd"; then
                log_success "${tool} instalado com sucesso"
                return 0
            else
                log_error "Falha ao instalar ${tool}"
                return 1
            fi
        else
            log_warning "Comando de instalação não fornecido para ${tool}"
            return 1
        fi
    fi
}

install_dependencies() {
    print_header "📦 PASSO 2: VERIFICANDO E INSTALANDO DEPENDÊNCIAS"

    # 1Password CLI
    check_and_install "op" "brew install --cask 1password-cli"

    # tree
    check_and_install "tree" "brew install tree"

    # GitHub CLI (opcional mas útil)
    check_and_install "gh" "brew install gh" || log_warning "GitHub CLI não instalado (opcional)"

    # jq (útil para scripts)
    check_and_install "jq" "brew install jq" || log_warning "jq não instalado (opcional)"

    # Node.js (se não estiver instalado)
    if ! command -v node >/dev/null 2>&1; then
        log_warning "Node.js não encontrado"
        log_info "Para instalar Node.js, use: brew install node"
        log_info "Ou use nvm se já tiver instalado"
    else
        NODE_VERSION=$(node --version)
        log_success "Node.js: ${NODE_VERSION}"
    fi
}

# ============================================================================
# PASSO 3: CONFIGURAR SHELL PARA CARREGAR HOMEBREW AUTOMATICAMENTE
# ============================================================================

configure_shell() {
    print_header "⚙️ PASSO 3: CONFIGURANDO SHELL"

    SHELL_CONFIG="$HOME/.zshrc"

    # Verificar se Homebrew já está configurado
    if grep -q "eval.*homebrew\|HOMEBREW\|brew shellenv" "$SHELL_CONFIG" 2>/dev/null; then
        log_success "Homebrew já está configurado em ${SHELL_CONFIG}"
    else
        log_info "Adicionando Homebrew ao ${SHELL_CONFIG}..."

        cat >> "$SHELL_CONFIG" << 'EOF'

# Homebrew - Carregar automaticamente
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
EOF

        log_success "Homebrew adicionado ao ${SHELL_CONFIG}"
    fi

    # Adicionar função tree se não existir
    if ! grep -q "^tree()" "$SHELL_CONFIG" 2>/dev/null; then
        log_info "Adicionando função tree alternativa..."

        cat >> "$SHELL_CONFIG" << 'EOF'

# Função tree alternativa (se tree não estiver instalado)
if ! command -v tree >/dev/null 2>&1; then
    tree() {
        local dir="${1:-.}"
        local depth="${2:-3}"
        ~/Dotfiles/system_prompts/global/scripts/tree-simple.sh "$dir" "$depth"
    }
fi
EOF

        log_success "Função tree alternativa adicionada"
    fi
}

# ============================================================================
# PASSO 4: VERIFICAR 1PASSWORD CLI E CONFIGURAÇÃO
# ============================================================================

verify_1password() {
    print_header "🔐 PASSO 4: VERIFICANDO 1PASSWORD CLI"

    if command -v op >/dev/null 2>&1; then
        OP_VERSION=$(op --version 2>/dev/null || echo "instalado")
        log_success "1Password CLI: ${OP_VERSION}"

        # Verificar se está autenticado
        if op whoami >/dev/null 2>&1; then
            OP_USER=$(op whoami 2>/dev/null || echo "desconhecido")
            log_success "1Password CLI autenticado como: ${OP_USER}"

            # Listar vaults
            log_info "Vaults disponíveis:"
            op vault list 2>/dev/null | head -5 || log_warning "Não foi possível listar vaults"
        else
            log_warning "1Password CLI não está autenticado"
            log_info "Execute: op signin"
        fi
    else
        log_error "1Password CLI não está disponível"
        log_info "Tente instalar manualmente: brew install --cask 1password-cli"
    fi
}

# ============================================================================
# PASSO 5: CRIAR ALIASES E FUNÇÕES ÚTEIS
# ============================================================================

create_aliases() {
    print_header "🔗 PASSO 5: CRIANDO ALIASES E FUNÇÕES ÚTEIS"

    SHELL_CONFIG="$HOME/.zshrc"

    # Verificar se já existe seção de aliases do sistema
    if ! grep -q "# System Prompts Aliases" "$SHELL_CONFIG" 2>/dev/null; then
        log_info "Adicionando aliases úteis..."

        cat >> "$SHELL_CONFIG" << 'EOF'

# ============================================================================
# System Prompts Aliases
# ============================================================================

# Tree alternativo
alias tree-alt='~/Dotfiles/system_prompts/global/scripts/tree-simple.sh'

# Scripts úteis
alias audit-1p='cd ~/Dotfiles/system_prompts/global && ./scripts/auditar-1password-secrets.sh'
alias audit-completa='cd ~/Dotfiles/system_prompts/global && ./scripts/master-auditoria-completa.sh'
alias consolidar-llms='cd ~/Dotfiles/system_prompts/global && ./scripts/consolidar-llms-full.sh'

# Navegação rápida
alias sp='cd ~/Dotfiles/system_prompts/global'
alias sp-scripts='cd ~/Dotfiles/system_prompts/global/scripts'
EOF

        log_success "Aliases adicionados ao ${SHELL_CONFIG}"
    else
        log_info "Aliases já existem em ${SHELL_CONFIG}"
    fi
}

# ============================================================================
# PASSO 6: VERIFICAR VARIÁVEIS DE AMBIENTE
# ============================================================================

check_env_vars() {
    print_header "🌍 PASSO 6: VERIFICANDO VARIÁVEIS DE AMBIENTE"

    local vars=(
        "DOTFILES_DIR"
        "GITHUB_USER"
        "GITHUB_TOKEN"
        "OPENAI_API_KEY"
        "ANTHROPIC_API_KEY"
        "GOOGLE_API_KEY"
        "HUGGINGFACE_API_TOKEN"
    )

    for var in "${vars[@]}"; do
        if [ -n "${!var:-}" ]; then
            local value="${!var}"
            # Mostrar apenas primeiros caracteres por segurança
            if [[ "$var" == *"TOKEN"* ]] || [[ "$var" == *"KEY"* ]]; then
                log_success "${var}: ${value:0:10}... (definida)"
            else
                log_success "${var}: ${value}"
            fi
        else
            log_warning "${var}: não definida"
        fi
    done
}

# ============================================================================
# PASSO 7: TESTAR COMANDOS CRÍTICOS
# ============================================================================

test_commands() {
    print_header "🧪 PASSO 7: TESTANDO COMANDOS CRÍTICOS"

    local commands=("brew" "git" "docker" "python3")

    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            local version=$($cmd --version 2>/dev/null | head -1 || echo "disponível")
            log_success "${cmd}: ${version}"
        else
            log_error "${cmd}: não encontrado"
        fi
    done

    # Testar tree
    if command -v tree >/dev/null 2>&1; then
        log_success "tree: $(tree --version 2>/dev/null | head -1 || echo 'instalado')"
    elif [ -f "$HOME/Dotfiles/system_prompts/global/scripts/tree-simple.sh" ]; then
        log_success "tree: alternativa disponível (tree-simple.sh)"
    else
        log_warning "tree: não disponível"
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🔧 CORREÇÃO COMPLETA DE DEPENDÊNCIAS"

    log_step "Iniciando correção completa..."
    echo ""

    # Passo 1: Carregar Homebrew
    if ! load_homebrew; then
        log_error "Falha ao carregar Homebrew. Abortando."
        exit 1
    fi

    # Passo 2: Instalar dependências
    install_dependencies

    # Passo 3: Configurar shell
    configure_shell

    # Passo 4: Verificar 1Password
    verify_1password

    # Passo 5: Criar aliases
    create_aliases

    # Passo 6: Verificar variáveis de ambiente
    check_env_vars

    # Passo 7: Testar comandos
    test_commands

    # Resumo final
    print_header "✅ CORREÇÃO CONCLUÍDA"

    echo ""
    log_success "Todas as correções aplicadas!"
    echo ""
    log_info "Próximos passos:"
    echo ""
    echo "  1. Recarregue o shell: source ~/.zshrc"
    echo "  2. Teste os comandos:"
    echo "     - brew --version"
    echo "     - tree -L 2"
    echo "     - op --version"
    echo ""
    echo "  3. Se 1Password CLI não estiver autenticado:"
    echo "     - op signin"
    echo ""
    echo "  4. Execute auditoria completa:"
    echo "     - audit-1p"
    echo ""
}

main "$@"

