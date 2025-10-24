#!/bin/bash

################################################################################
# 🔐 init_1password_ubuntu.sh
# Script de Inicialização do 1Password CLI para VPS Ubuntu
# Propósito: Configurar o 1Password CLI em ambiente VPS Ubuntu 22.04 LTS
# Autor: Manus AI
# Data: 2025-10-22
################################################################################

set -euo pipefail

# ============================================================================
# CORES PARA OUTPUT
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================================================
# VERIFICAÇÃO DE PRÉ-REQUISITOS
# ============================================================================

check_prerequisites() {
    log_info "Verificando pré-requisitos..."

    # Verificar se está no Ubuntu/Linux
    if [[ ! -f /etc/os-release ]]; then
        log_error "Arquivo /etc/os-release não encontrado. Este script é para Linux."
        exit 1
    fi

    # Verificar versão do Ubuntu
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        log_warning "Este script foi testado no Ubuntu. Seu sistema é: $ID"
    fi

    log_success "Pré-requisitos verificados."
}

# ============================================================================
# INSTALAÇÃO DO 1PASSWORD CLI
# ============================================================================

install_1password_cli() {
    log_info "Verificando instalação do 1Password CLI..."

    if command -v op &> /dev/null; then
        OP_VERSION=$(op --version)
        log_success "1Password CLI já está instalado: $OP_VERSION"
        return 0
    fi

    log_info "Instalando 1Password CLI via APT..."

    # Adicionar repositório do 1Password
    log_info "Adicionando repositório do 1Password..."
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list

    # Atualizar índice de pacotes
    sudo apt-get update

    # Instalar 1Password CLI
    sudo apt-get install -y 1password-cli

    if command -v op &> /dev/null; then
        log_success "1Password CLI instalado com sucesso: $(op --version)"
    else
        log_error "Falha ao instalar 1Password CLI."
        exit 1
    fi
}

# ============================================================================
# CONFIGURAÇÃO DO SERVICE ACCOUNT TOKEN
# ============================================================================

configure_service_account() {
    log_info "Configurando Service Account Token para automação..."

    log_info "Para usar o 1Password CLI em um VPS sem interação interativa,"
    log_info "você precisa de um Service Account Token."
    log_info ""
    log_info "Passos para obter o token:"
    log_info "1. Acesse: https://start.1password.com/integrations/connect"
    log_info "2. Crie um novo Service Account"
    log_info "3. Copie o token fornecido"
    log_info ""
    log_info "Você pode definir o token como variável de ambiente:"
    log_info "export OP_SERVICE_ACCOUNT_TOKEN='seu_token_aqui'"
    log_info ""
    log_info "Ou adicionar ao arquivo ~/.bashrc ou ~/.zshrc"
}

# ============================================================================
# CONFIGURAÇÃO DO SHELL (BASH)
# ============================================================================

configure_shell() {
    log_info "Configurando shell (Bash)..."

    BASHRC="$HOME/.bashrc"

    # Verificar se .bashrc existe
    if [[ ! -f "$BASHRC" ]]; then
        log_warning "Arquivo .bashrc não encontrado. Criando..."
        touch "$BASHRC"
    fi

    # Adicionar configuração do 1Password se não existir
    if ! grep -q "# 1Password CLI Configuration" "$BASHRC"; then
        log_info "Adicionando configuração do 1Password ao .bashrc..."

        cat >> "$BASHRC" << 'EOF'

# ============================================================================
# 1Password CLI Configuration
# ============================================================================

# Função para fazer signin com Service Account Token
op_signin_service_account() {
    if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
        echo "❌ OP_SERVICE_ACCOUNT_TOKEN não está definido."
        echo "Execute: export OP_SERVICE_ACCOUNT_TOKEN='seu_token_aqui'"
        return 1
    fi
    echo "✅ Service Account Token configurado."
}

# Função para verificar status da sessão
op_status() {
    if op whoami &>/dev/null; then
        echo "✅ Conectado ao 1Password"
        op whoami
    else
        echo "❌ Não conectado ao 1Password"
        echo "Configure o OP_SERVICE_ACCOUNT_TOKEN"
    fi
}

# Alias para leitura rápida de segredos
alias op_read='op read'
alias op_list='op item list'

# Função para injetar segredos em um arquivo .env.op
op_inject_env() {
    if [[ -z "$1" ]]; then
        echo "Uso: op_inject_env <arquivo.env.op>"
        return 1
    fi
    op inject -i "$1" -o .env
    echo "✅ Arquivo .env gerado a partir de $1"
}

EOF

        log_success "Configuração do 1Password adicionada ao .bashrc."
    else
        log_success "Configuração do 1Password já existe no .bashrc."
    fi

    # Recarregar .bashrc
    source "$BASHRC"
}

# ============================================================================
# CRIAÇÃO DE ESTRUTURA DE DIRETÓRIOS
# ============================================================================

create_directory_structure() {
    log_info "Criando estrutura de diretórios..."

    SCRIPTS_DIR="$HOME/1password_automation"
    OP_ENV_DIR="$HOME/.config/1password"

    # Criar diretórios se não existirem
    mkdir -p "$SCRIPTS_DIR"
    mkdir -p "$OP_ENV_DIR"

    log_success "Estrutura de diretórios criada:"
    log_info "  - Scripts: $SCRIPTS_DIR"
    log_info "  - Configuração: $OP_ENV_DIR"
}

# ============================================================================
# TESTE DE FUNCIONAMENTO
# ============================================================================

test_functionality() {
    log_info "Testando funcionalidade do 1Password CLI..."

    # Tentar executar um comando simples
    if op --version &>/dev/null; then
        log_success "1Password CLI está funcionando corretamente."
    else
        log_error "Falha ao executar 1Password CLI."
        return 1
    fi

    # Tentar listar vaults (requer autenticação)
    if [[ -n "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
        if op vault list &>/dev/null; then
            log_success "Acesso aos vaults está funcionando."
            log_info "Vaults disponíveis:"
            op vault list --format json | jq -r '.[] | "  - \(.name)"'
        else
            log_warning "Não foi possível listar os vaults. Verifique o token."
        fi
    else
        log_warning "OP_SERVICE_ACCOUNT_TOKEN não está definido. Não é possível listar vaults."
    fi
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🔐 Inicialização do 1Password CLI para VPS Ubuntu             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    check_prerequisites
    install_1password_cli
    configure_service_account
    configure_shell
    create_directory_structure
    test_functionality

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ Inicialização Concluída!                                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_info "Próximos passos:"
    log_info "1. Configure o OP_SERVICE_ACCOUNT_TOKEN em ~/.bashrc ou ~/.zshrc"
    log_info "2. Execute: source ~/.bashrc (ou ~/.zshrc)"
    log_info "3. Execute: op_status (para verificar a conexão)"
    log_info "4. Crie vaults e itens no 1Password conforme necessário"
    echo ""
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

main "$@"

