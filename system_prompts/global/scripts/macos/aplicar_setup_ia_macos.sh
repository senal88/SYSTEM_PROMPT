#!/usr/bin/env bash
set -euo pipefail

# Script: aplicar_setup_ia_macos.sh
# Objetivo:
# - Orquestrador de alto nível para configurar o ambiente de IA no macOS.
# - Guia o usuário e executa outros scripts de setup e validação.
#
# Versão: 1.0.0
# Data: 2025-11-30

# --- Funções de Log ---
log_info() {
    echo "🔵 [INFO] $@"
}

log_success() {
    echo "✅ [SUCESSO] $@"
}

log_step() {
    echo ""
    echo "--- ETAPA $1: $2 ---"
}

# --- Execução Principal ---
main() {
    log_info "Iniciando o Setup e Validação do Ambiente de IA no macOS."

    # ETAPA 1: Validar dependências básicas
    log_step 1 "Verificando dependências básicas (Homebrew, Git, 1Password)"
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew não encontrado. Por favor, instale-o antes de continuar."
        exit 1
    fi
    if ! command -v git &> /dev/null; then
        log_error "Git não encontrado. Por favor, instale-o."
        exit 1
    fi
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI (op) não encontrado. Instale-o a partir do site do 1Password."
        exit 1
    fi
    log_success "Dependências básicas encontradas."

    # ETAPA 2: Autenticar 1Password
    log_step 2 "Verificando autenticação do 1Password"
    if ! op account list &> /dev/null || ! op whoami &> /dev/null; then
        log_info "Sessão do 1Password não está ativa. Por favor, execute 'op signin' em outro terminal."
        read -p "Pressione [Enter] após concluir o login para continuar..."
    fi
    log_success "Sessão do 1Password está ativa."

    # ETAPA 3: Validar Estrutura do Repositório
    log_step 3 "Validando a estrutura e governança do repositório"
    local script_path="${HOME}/Dotfiles/system_prompts/global/scripts/shared/validar_estrutura_system_prompt.sh"
    if [ -f "$script_path" ]; then
        bash "$script_path"
    else
        log_error "Script de validação não encontrado em ${script_path}"
        exit 1
    fi
    log_success "Validação da estrutura concluída. Verifique o relatório gerado."

    # ETAPA 4: Testar Conexões
    log_step 4 "Testando conexões críticas (GitHub)"
    log_info "Testando conexão SSH com o GitHub..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        log_success "Autenticação SSH com o GitHub bem-sucedida."
    else
        log_warn "Falha na autenticação SSH com o GitHub. Verifique suas chaves no 1Password e a configuração do SSH."
    fi

    # ETAPA 5: Próximos Passos
    echo ""
    log_info "Setup e validação concluídos."
    log_info "Próximos passos recomendados:"
    echo "  - Revise o relatório de validação gerado em 'reports/'."
    echo "  - Certifique-se de que as extensões recomendadas (Claude, Copilot, etc.) estão instaladas no Cursor e VS Code."
    echo "  - Abra o Cursor a partir de um terminal com a sessão do 1Password ativa para que ele herde as chaves de API."
}

# Inicia a execução
main
