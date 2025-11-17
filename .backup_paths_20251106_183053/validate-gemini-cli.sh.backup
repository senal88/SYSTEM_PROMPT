#!/usr/bin/env bash
set -euo pipefail

# Script de Validação do Gemini CLI
# Valida instalação, configuração e autenticação do Gemini CLI
#
# Uso: ./validate-gemini-cli.sh

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Contador de erros
ERRORS=0
WARNINGS=0

# Funções de logging
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠️${NC} $1"
    ((WARNINGS++))
}

error() {
    echo -e "${RED}❌${NC} $1"
    ((ERRORS++))
}

# Verificar instalação do Gemini CLI
check_installation() {
    log "Verificando instalação do Gemini CLI..."
    
    if command -v gemini &> /dev/null; then
        local version=$(gemini --version 2>/dev/null || echo "desconhecida")
        success "Gemini CLI instalado (versão: $version)"
        return 0
    else
        error "Gemini CLI não está instalado"
        return 1
    fi
}

# Verificar configuração da API key
check_api_key() {
    log "Verificando configuração da API key..."
    
    # Verificar variável de ambiente
    if [ -n "${GEMINI_API_KEY:-}" ]; then
        success "GEMINI_API_KEY está configurada (${#GEMINI_API_KEY} caracteres)"
    else
        warn "GEMINI_API_KEY não está configurada no ambiente atual"
        info "  Tentando obter do 1Password..."
        
        if command -v op &> /dev/null; then
            if op read "op://shared_infra/gemini/api_key" &> /dev/null; then
                success "API key disponível no 1Password"
                export GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key")
            else
                error "API key não encontrada no 1Password"
                return 1
            fi
        else
            error "1Password CLI não está instalado"
            return 1
        fi
    fi
    
    # Validar formato da API key (deve começar com AIza)
    if [[ "$GEMINI_API_KEY" =~ ^AIza ]]; then
        success "Formato da API key válido"
    else
        warn "Formato da API key pode estar incorreto (deve começar com 'AIza')"
    fi
}

# Verificar autenticação
check_authentication() {
    log "Verificando autenticação..."
    
    # Tentar autenticar
    if gemini auth login --api-key "${GEMINI_API_KEY:-}" 2>/dev/null; then
        success "Autenticação bem-sucedida"
        return 0
    else
        warn "Não foi possível verificar autenticação automaticamente"
        info "  Execute manualmente: gemini auth login"
        return 1
    fi
}

# Verificar configuração do diretório
check_config_directory() {
    log "Verificando diretório de configuração..."
    
    local config_dir="$HOME/.config/gemini-cli"
    if [ -d "$config_dir" ]; then
        success "Diretório de configuração existe: $config_dir"
        
        if [ -f "$config_dir/config.json" ]; then
            success "Arquivo de configuração existe"
        else
            warn "Arquivo de configuração não encontrado"
        fi
    else
        warn "Diretório de configuração não existe: $config_dir"
    fi
}

# Verificar ferramentas disponíveis
check_tools() {
    log "Verificando ferramentas disponíveis..."
    
    # Listar ferramentas disponíveis (se o comando existir)
    if gemini tools list &> /dev/null; then
        local tool_count=$(gemini tools list 2>/dev/null | wc -l || echo "0")
        success "Ferramentas disponíveis: $tool_count"
    else
        warn "Não foi possível listar ferramentas"
    fi
}

# Testar comando básico
test_basic_command() {
    log "Testando comando básico..."
    
    if gemini --help &> /dev/null; then
        success "Comando 'gemini --help' funciona corretamente"
        return 0
    else
        error "Comando 'gemini --help' falhou"
        return 1
    fi
}

# Resumo final
print_summary() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║                    RESUMO DA VALIDAÇÃO                        ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        success "🎉 Todas as verificações passaram!"
        echo ""
        info "O Gemini CLI está pronto para uso."
        echo "  Execute: gemini"
        echo ""
    elif [ $ERRORS -eq 0 ]; then
        warn "⚠️  Validação concluída com $WARNINGS aviso(s)"
        echo ""
        info "O Gemini CLI está funcional, mas algumas configurações podem ser melhoradas."
        echo ""
    else
        error "❌ Validação falhou com $ERRORS erro(s) e $WARNINGS aviso(s)"
        echo ""
        error "Corrija os erros antes de usar o Gemini CLI."
        echo ""
        exit 1
    fi
}

# Função principal
main() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║              VALIDAÇÃO DO GEMINI CLI                            ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_installation
    check_api_key
    check_authentication
    check_config_directory
    check_tools
    test_basic_command
    
    print_summary
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

