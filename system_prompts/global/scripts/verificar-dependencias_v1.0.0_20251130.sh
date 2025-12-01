#!/bin/bash

################################################################################
# 🔍 VERIFICAÇÃO E INSTALAÇÃO DE DEPENDÊNCIAS
# Verifica e instala dependências necessárias para os scripts de auditoria
################################################################################

set +euo pipefail 2>/dev/null || set +e
set +u

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# VERIFICAÇÃO DE FERRAMENTAS BÁSICAS
# ============================================================================

check_basic_tools() {
    print_header "VERIFICAÇÃO DE FERRAMENTAS BÁSICAS"

    local missing_tools=()

    # Ferramentas essenciais
    local essential_tools=("bash" "grep" "awk" "sed" "git" "ssh" "scp")

    for tool in "${essential_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            log_success "$tool: instalado"
        else
            log_error "$tool: NÃO ENCONTRADO"
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Ferramentas essenciais faltando: ${missing_tools[*]}"
        log_warning "Algumas ferramentas são parte do sistema macOS e não podem ser instaladas separadamente"
        return 1
    fi

    return 0
}

# ============================================================================
# VERIFICAÇÃO DE HOMEBREW
# ============================================================================

check_homebrew() {
    print_header "VERIFICAÇÃO DE HOMEBREW"

    if command -v brew &> /dev/null; then
        log_success "Homebrew: instalado"
        brew --version | head -1
        return 0
    else
        log_warning "Homebrew: NÃO INSTALADO"
        read -p "Deseja instalar o Homebrew? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[SsYy]$ ]]; then
            log_info "Instalando Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if [ $? -eq 0 ]; then
                log_success "Homebrew instalado com sucesso"
                return 0
            else
                log_error "Falha na instalação do Homebrew"
                return 1
            fi
        else
            log_warning "Homebrew não instalado. Algumas funcionalidades podem não estar disponíveis."
            return 1
        fi
    fi
}

# ============================================================================
# VERIFICAÇÃO DE PACOTES HOMEBREW
# ============================================================================

check_homebrew_packages() {
    print_header "VERIFICAÇÃO DE PACOTES HOMEBREW"

    if ! command -v brew &> /dev/null; then
        log_warning "Homebrew não disponível. Pulando verificação de pacotes."
        return 1
    fi

    local optional_packages=("jq" "yq" "tree")
    local missing_packages=()

    for pkg in "${optional_packages[@]}"; do
        if brew list "$pkg" &> /dev/null 2>&1; then
            log_success "$pkg: instalado"
        else
            log_warning "$pkg: não instalado (opcional)"
            missing_packages+=("$pkg")
        fi
    done

    if [ ${#missing_packages[@]} -gt 0 ]; then
        read -p "Deseja instalar pacotes opcionais faltantes? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[SsYy]$ ]]; then
            for pkg in "${missing_packages[@]}"; do
                log_info "Instalando $pkg..."
                brew install "$pkg" 2>&1 | grep -v "Warning\|Error" || true
                if brew list "$pkg" &> /dev/null 2>&1; then
                    log_success "$pkg: instalado com sucesso"
                else
                    log_error "$pkg: falha na instalação"
                fi
            done
        fi
    fi

    return 0
}

# ============================================================================
# VERIFICAÇÃO DE ESTRUTURA DE DIRETÓRIOS
# ============================================================================

check_directory_structure() {
    print_header "VERIFICAÇÃO DE ESTRUTURA DE DIRETÓRIOS"

    local DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
    local AUDIT_BASE="${DOTFILES_DIR}/system_prompts/global/audit"
    local SCRIPTS_DIR="${DOTFILES_DIR}/system_prompts/global/scripts"
    local TEMPLATES_DIR="${DOTFILES_DIR}/system_prompts/global/templates"
    local OUTPUT_DIR="${DOTFILES_DIR}/system_prompts/global"

    local dirs=(
        "$DOTFILES_DIR"
        "$AUDIT_BASE"
        "$SCRIPTS_DIR"
        "$TEMPLATES_DIR"
        "$OUTPUT_DIR"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_success "Diretório existe: $dir"
        else
            log_warning "Diretório não existe: $dir"
            log_info "Criando diretório..."
            mkdir -p "$dir"
            if [ -d "$dir" ]; then
                log_success "Diretório criado: $dir"
            else
                log_error "Falha ao criar diretório: $dir"
                return 1
            fi
        fi
    done

    return 0
}

# ============================================================================
# VERIFICAÇÃO DE PERMISSÕES
# ============================================================================

check_permissions() {
    print_header "VERIFICAÇÃO DE PERMISSÕES"

    local SCRIPTS_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}/system_prompts/global/scripts"

    if [ -d "$SCRIPTS_DIR" ]; then
        local scripts=(
            "master-auditoria-completa.sh"
            "analise-e-sintese.sh"
            "consolidar-llms-full.sh"
        )

        for script in "${scripts[@]}"; do
            local script_path="${SCRIPTS_DIR}/${script}"
            if [ -f "$script_path" ]; then
                if [ -x "$script_path" ]; then
                    log_success "$script: executável"
                else
                    log_warning "$script: não executável"
                    log_info "Adicionando permissão de execução..."
                    chmod +x "$script_path"
                    if [ -x "$script_path" ]; then
                        log_success "$script: permissão adicionada"
                    else
                        log_error "$script: falha ao adicionar permissão"
                    fi
                fi
            fi
        done
    fi

    return 0
}

# ============================================================================
# VERIFICAÇÃO DE SSH (PARA VPS)
# ============================================================================

check_ssh_config() {
    print_header "VERIFICAÇÃO DE CONFIGURAÇÃO SSH"

    if [ -f "$HOME/.ssh/config" ]; then
        log_success "SSH config encontrado: ~/.ssh/config"

        # Verificar se há configuração para VPS
        if grep -q "Host vps\|Host admin-vps" "$HOME/.ssh/config" 2>/dev/null; then
            log_success "Configuração VPS encontrada no SSH config"
        else
            log_warning "Nenhuma configuração VPS encontrada no SSH config"
        fi
    else
        log_warning "SSH config não encontrado: ~/.ssh/config"
    fi

    # Verificar chaves SSH
    if [ -d "$HOME/.ssh" ]; then
        local key_count=$(find "$HOME/.ssh" -name "id_*" -not -name "*.pub" -type f 2>/dev/null | wc -l | tr -d ' ')
        if [ "$key_count" -gt 0 ]; then
            log_success "Chaves SSH encontradas: $key_count"
        else
            log_warning "Nenhuma chave SSH encontrada"
        fi
    fi

    return 0
}

# ============================================================================
# RESUMO FINAL
# ============================================================================

print_summary() {
    print_header "RESUMO DA VERIFICAÇÃO"

    local all_ok=true

    # Verificar ferramentas básicas
    if ! check_basic_tools > /dev/null 2>&1; then
        all_ok=false
    fi

    # Verificar Homebrew
    if ! check_homebrew > /dev/null 2>&1; then
        all_ok=false
    fi

    # Verificar estrutura
    if ! check_directory_structure > /dev/null 2>&1; then
        all_ok=false
    fi

    if [ "$all_ok" = true ]; then
        log_success "Todas as verificações passaram!"
        echo ""
        echo "Próximos passos:"
        echo "  1. Execute: ./master-auditoria-completa.sh"
        echo "  2. Execute: ./analise-e-sintese.sh"
        echo "  3. Execute: ./consolidar-llms-full.sh"
        return 0
    else
        log_warning "Algumas verificações falharam. Revise os erros acima."
        return 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🔍 VERIFICAÇÃO DE DEPENDÊNCIAS - System Prompts Globais"

    check_basic_tools
    check_homebrew
    check_homebrew_packages
    check_directory_structure
    check_permissions
    check_ssh_config

    print_summary
}

main "$@"

