#!/usr/bin/env bash
set -euo pipefail

# Script de Instalação do Gemini CLI
# Instala e configura o Gemini CLI para macOS Silicon (M1/M2/M3)
#
# Uso: ./install-gemini-cli.sh
#
# Pré-requisitos:
# - Node.js 18+ instalado
# - npm ou yarn instalado
# - 1Password CLI autenticado

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Funções de logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        error "Node.js não está instalado. Instale com: brew install node"
        exit 1
    fi
    
    local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 18 ]; then
        error "Node.js 18+ é necessário. Versão atual: $(node -v)"
        exit 1
    fi
    success "Node.js $(node -v) instalado"
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        error "npm não está instalado"
        exit 1
    fi
    success "npm $(npm -v) instalado"
    
    # Verificar 1Password CLI
    if ! command -v op &> /dev/null; then
        error "1Password CLI não está instalado. Instale com: brew install 1password-cli"
        exit 1
    fi
    success "1Password CLI instalado"
    
    # Verificar autenticação 1Password
    if ! op account list &> /dev/null; then
        error "1Password CLI não está autenticado. Execute: op signin"
        exit 1
    fi
    success "1Password CLI autenticado"
}

# Instalar Gemini CLI globalmente
install_gemini_cli() {
    log "Instalando Gemini CLI..."
    
    info "Instalando @google/gemini-cli globalmente..."
    if npm install -g @google/gemini-cli; then
        success "Gemini CLI instalado com sucesso"
    else
        error "Falha ao instalar Gemini CLI"
        exit 1
    fi
    
    # Verificar instalação
    if command -v gemini &> /dev/null; then
        local version=$(gemini --version 2>/dev/null || echo "instalado")
        success "Gemini CLI instalado (versão: $version)"
    else
        error "Gemini CLI não foi encontrado no PATH"
        exit 1
    fi
}

# Configurar autenticação usando 1Password
configure_authentication() {
    log "Configurando autenticação com 1Password..."
    
    # Obter API key do 1Password
    info "Obtendo GEMINI_API_KEY do 1Password..."
    
    local api_key
    if api_key=$(op read "op://shared_infra/gemini/api_key" 2>/dev/null); then
        success "API key obtida do 1Password"
        
        # Configurar variável de ambiente
        info "Configurando GEMINI_API_KEY..."
        export GEMINI_API_KEY="$api_key"
        
        # Adicionar ao shell profile (zsh para macOS)
        local profile_file="$HOME/.zshrc"
        if [ -f "$profile_file" ]; then
            # Verificar se já existe
            if ! grep -q "GEMINI_API_KEY" "$profile_file"; then
                info "Adicionando GEMINI_API_KEY ao $profile_file via 1Password..."
                cat >> "$profile_file" << 'EOF'

# Gemini CLI - Configuração via 1Password
export GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key" 2>/dev/null)
EOF
                success "Configuração adicionada ao $profile_file"
            else
                warn "GEMINI_API_KEY já está configurado no $profile_file"
            fi
        fi
        
        # Testar autenticação
        info "Testando autenticação..."
        if gemini auth login --api-key "$api_key" 2>/dev/null; then
            success "Autenticação configurada com sucesso"
        else
            warn "Não foi possível testar autenticação automaticamente. Execute manualmente: gemini auth login"
        fi
    else
        error "Não foi possível obter API key do 1Password"
        error "Certifique-se de que o item 'gemini' existe no vault 'shared_infra' com o campo 'api_key'"
        exit 1
    fi
}

# Configurar temas e personalização (opcional)
configure_themes() {
    log "Configurando temas e personalização..."
    
    # Criar diretório de configuração se não existir
    local config_dir="$HOME/.config/gemini-cli"
    mkdir -p "$config_dir"
    
    # Criar arquivo de configuração básico
    if [ ! -f "$config_dir/config.json" ]; then
        info "Criando arquivo de configuração..."
        cat > "$config_dir/config.json" << 'EOF'
{
  "theme": "default",
  "editor": {
    "vimMode": false
  },
  "telemetry": {
    "enabled": false
  }
}
EOF
        success "Arquivo de configuração criado em $config_dir/config.json"
    else
        warn "Arquivo de configuração já existe"
    fi
}

# Função principal
main() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║           INSTALAÇÃO E CONFIGURAÇÃO DO GEMINI CLI               ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_prerequisites
    install_gemini_cli
    configure_authentication
    configure_themes
    
    echo ""
    success "🎉 Instalação concluída com sucesso!"
    echo ""
    info "Próximos passos:"
    echo "  1. Recarregue seu shell: source ~/.zshrc"
    echo "  2. Teste o CLI: gemini --version"
    echo "  3. Inicie uma sessão interativa: gemini"
    echo "  4. Execute o script de validação: ./validate-gemini-cli.sh"
    echo ""
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

