#!/usr/bin/env bash
# =============================================================================
# Script: install_claude_perfect_config.sh
# Versão: 1.0.0
# Data: 2025-12-02
# Descrição: Instala configuração perfeita do Claude Desktop com zero erros
# Autor: Luiz Sena
# =============================================================================

# Anti-source protection
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -euo pipefail
else
    echo "❌ ERRO: Este script deve ser EXECUTADO, não 'source'd"
    echo "   Use: bash $0"
    return 1 2>/dev/null || exit 1
fi

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de log
log_info() { echo -e "${BLUE}ℹ ${NC}$1"; }
log_success() { echo -e "${GREEN}✅ ${NC}$1"; }
log_warning() { echo -e "${YELLOW}⚠️  ${NC}$1"; }
log_error() { echo -e "${RED}❌ ${NC}$1"; }

# Variáveis
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_CONFIG="$DOTFILES_ROOT/global/templates/claude_desktop_config_PERFEITO_v1.0.0_20251202.json"
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
BACKUP_DIR="$DOTFILES_ROOT/backups/claude"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# =============================================================================
# Função: check_prerequisites
# =============================================================================
check_prerequisites() {
    log_info "Verificando pré-requisitos..."

    # Verificar se está no macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "Este script é apenas para macOS"
        exit 1
    fi

    # Verificar se Claude Desktop está instalado
    if [[ ! -d "/Applications/Claude.app" ]]; then
        log_error "Claude Desktop não está instalado"
        log_info "Baixe em: https://claude.ai/download"
        exit 1
    fi

    # Verificar se template existe
    if [[ ! -f "$TEMPLATE_CONFIG" ]]; then
        log_error "Template de configuração não encontrado: $TEMPLATE_CONFIG"
        exit 1
    fi

    # Verificar se 1Password CLI está instalado
    if ! command -v op &> /dev/null; then
        log_warning "1Password CLI não está instalado"
        log_info "Instalando via Homebrew..."
        brew install 1password-cli || {
            log_error "Falha ao instalar 1Password CLI"
            exit 1
        }
    fi

    # Verificar se está autenticado no 1Password
    if ! op account get &> /dev/null; then
        log_warning "1Password CLI não está autenticado"
        log_info "Execute: eval \$(op signin)"
        exit 1
    fi

    # Verificar se npx está disponível
    if ! command -v npx &> /dev/null; then
        log_error "npx não está instalado (requer Node.js)"
        log_info "Instale Node.js: brew install node"
        exit 1
    fi

    # Verificar se bun está disponível
    if ! command -v bun &> /dev/null; then
        log_warning "Bun não está instalado (necessário para Obsidian MCP)"
        log_info "Instalando Bun..."
        curl -fsSL https://bun.sh/install | bash || {
            log_error "Falha ao instalar Bun"
            exit 1
        }
    fi

    log_success "Todos os pré-requisitos atendidos"
}

# =============================================================================
# Função: backup_current_config
# =============================================================================
backup_current_config() {
    log_info "Criando backup da configuração atual..."

    mkdir -p "$BACKUP_DIR"

    if [[ -f "$CLAUDE_CONFIG_FILE" ]]; then
        cp "$CLAUDE_CONFIG_FILE" "$BACKUP_DIR/claude_desktop_config_$TIMESTAMP.json"
        log_success "Backup criado: $BACKUP_DIR/claude_desktop_config_$TIMESTAMP.json"
    else
        log_info "Nenhuma configuração anterior encontrada"
    fi
}

# =============================================================================
# Função: load_credentials
# =============================================================================
load_credentials() {
    log_info "Carregando credenciais do 1Password..."

    # Carregar script de API keys
    if [[ -f "$SCRIPT_DIR/load_ai_keys.sh" ]]; then
        source "$SCRIPT_DIR/load_ai_keys.sh"
    else
        log_error "Script load_ai_keys.sh não encontrado"
        exit 1
    fi

    # Verificar se as principais credenciais foram carregadas
    local missing_creds=()

    [[ -z "${GITHUB_TOKEN:-}" ]] && missing_creds+=("GITHUB_TOKEN")
    [[ -z "${ANTHROPIC_API_KEY:-}" ]] && missing_creds+=("ANTHROPIC_API_KEY")

    if [[ ${#missing_creds[@]} -gt 0 ]]; then
        log_warning "Credenciais não encontradas: ${missing_creds[*]}"
        log_info "Continuando sem essas credenciais..."
    else
        log_success "Credenciais carregadas com sucesso"
    fi

    # Buscar credenciais adicionais opcionais
    export OBSIDIAN_API_KEY=$(op read "op://Development/Obsidian API Key/credential" 2>/dev/null || echo "")
    export BRAVE_API_KEY=$(op read "op://Development/Brave Search API Key/credential" 2>/dev/null || echo "")
    export GOOGLE_API_KEY=$(op read "op://Development/Google API Key/credential" 2>/dev/null || echo "")
    export GOOGLE_CSE_ID=$(op read "op://Development/Google CSE ID/credential" 2>/dev/null || echo "")
    export SLACK_BOT_TOKEN=$(op read "op://Development/Slack Bot Token/credential" 2>/dev/null || echo "")
}

# =============================================================================
# Função: install_config
# =============================================================================
install_config() {
    log_info "Instalando configuração perfeita do Claude Desktop..."

    # Criar diretório se não existir
    mkdir -p "$CLAUDE_CONFIG_DIR"

    # Copiar template
    cp "$TEMPLATE_CONFIG" "$CLAUDE_CONFIG_FILE"

    # Substituir variáveis de ambiente
    log_info "Substituindo variáveis de ambiente..."

    # Usar perl para substituição in-place (compatível com macOS)
    perl -pi -e "s|\\\${GITHUB_TOKEN}|$GITHUB_TOKEN|g" "$CLAUDE_CONFIG_FILE"
    perl -pi -e "s|\\\${ANTHROPIC_API_KEY}|$ANTHROPIC_API_KEY|g" "$CLAUDE_CONFIG_FILE"
    perl -pi -e "s|\\\${OBSIDIAN_API_KEY}|$OBSIDIAN_API_KEY|g" "$CLAUDE_CONFIG_FILE"
    perl -pi -e "s|\\\${BRAVE_API_KEY}|$BRAVE_API_KEY|g" "$CLAUDE_CONFIG_FILE"
    perl -pi -e "s|\\\${GOOGLE_API_KEY}|$GOOGLE_API_KEY|g" "$CLAUDE_CONFIG_FILE"
    perl -pi -e "s|\\\${GOOGLE_CSE_ID}|$GOOGLE_CSE_ID|g" "$CLAUDE_CONFIG_FILE"
    perl -pi -e "s|\\\${SLACK_BOT_TOKEN}|$SLACK_BOT_TOKEN|g" "$CLAUDE_CONFIG_FILE"

    # Substituir caminhos do usuário
    perl -pi -e "s|/Users/luiz.sena88|$HOME|g" "$CLAUDE_CONFIG_FILE"

    log_success "Configuração instalada: $CLAUDE_CONFIG_FILE"
}

# =============================================================================
# Função: validate_config
# =============================================================================
validate_config() {
    log_info "Validando configuração JSON..."

    # Verificar se é um JSON válido
    if ! python3 -m json.tool "$CLAUDE_CONFIG_FILE" &> /dev/null; then
        log_error "Configuração JSON inválida!"
        log_info "Restaurando backup..."
        cp "$BACKUP_DIR/claude_desktop_config_$TIMESTAMP.json" "$CLAUDE_CONFIG_FILE"
        exit 1
    fi

    log_success "Configuração JSON válida"
}

# =============================================================================
# Função: restart_claude
# =============================================================================
restart_claude() {
    log_info "Reiniciando Claude Desktop..."

    # Matar processo Claude se estiver rodando
    if pgrep -x "Claude" > /dev/null; then
        log_info "Fechando Claude Desktop..."
        killall Claude 2>/dev/null || true
        sleep 2
    fi

    # Abrir Claude Desktop
    log_info "Abrindo Claude Desktop..."
    open -a Claude

    # Aguardar inicialização
    sleep 5

    # Verificar se está rodando
    if pgrep -x "Claude" > /dev/null; then
        log_success "Claude Desktop iniciado com sucesso"
    else
        log_error "Claude Desktop não iniciou"
        log_info "Tente abrir manualmente: open -a Claude"
        exit 1
    fi
}

# =============================================================================
# Função: test_mcp_servers
# =============================================================================
test_mcp_servers() {
    log_info "Testando conectividade dos MCP servers..."

    # Aguardar mais tempo para MCP servers inicializarem
    log_info "Aguardando inicialização dos MCP servers (15s)..."
    sleep 15

    # Verificar processos MCP
    local mcp_count=$(ps aux | grep -E "mcp-server|@modelcontextprotocol" | grep -v grep | wc -l)

    if [[ $mcp_count -gt 0 ]]; then
        log_success "$mcp_count MCP server(s) detectado(s)"
    else
        log_warning "Nenhum processo MCP detectado ainda"
        log_info "Pode levar alguns minutos para iniciar..."
    fi

    # Listar processos MCP (se existirem)
    log_info "Processos MCP ativos:"
    ps aux | grep -E "mcp-server|@modelcontextprotocol" | grep -v grep | awk '{print "  - " $11 " " $12 " " $13}' || echo "  (nenhum ainda)"
}

# =============================================================================
# Função: show_next_steps
# =============================================================================
show_next_steps() {
    echo ""
    log_success "============================================"
    log_success "  INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
    log_success "============================================"
    echo ""
    log_info "Próximos Passos:"
    echo ""
    echo "  1. Verifique se Claude Desktop abriu corretamente"
    echo "  2. No Claude, teste os MCP servers:"
    echo "     - 'List files in ~/Dotfiles'"
    echo "     - 'Show my GitHub repositories'"
    echo "     - 'Create a note in Obsidian'"
    echo ""
    echo "  3. Se houver erros de MCP server:"
    echo "     - Aguarde 2-3 minutos para inicialização completa"
    echo "     - Reinicie Claude: killall Claude && open -a Claude"
    echo "     - Veja logs: tail -f ~/Library/Logs/Claude/mcp*.log"
    echo ""
    echo "  4. Documentação completa em:"
    echo "     $DOTFILES_ROOT/global/docs/CLAUDE_DESKTOP_CONFIG_PERFEITA_v1.0.0_20251202.md"
    echo ""
    log_info "Backup da config anterior:"
    echo "  $BACKUP_DIR/claude_desktop_config_$TIMESTAMP.json"
    echo ""
}

# =============================================================================
# Main
# =============================================================================
main() {
    echo ""
    log_info "============================================"
    log_info "  Claude Desktop - Instalação Perfeita"
    log_info "  Versão: 1.0.0 | Data: 2025-12-02"
    log_info "============================================"
    echo ""

    check_prerequisites
    backup_current_config
    load_credentials
    install_config
    validate_config
    restart_claude
    test_mcp_servers
    show_next_steps
}

# Executar
main "$@"
