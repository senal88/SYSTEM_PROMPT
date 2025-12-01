#!/usr/bin/env bash
set -euo pipefail

# Script: aplicar_setup_ia_ubuntu.sh
# Objetivo:
# - Orquestrador de alto nível para configurar o ambiente de IA em uma VPS Ubuntu.
# - Focado em um ambiente não-gráfico (headless).
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
    log_info "Iniciando o Setup e Validação do Ambiente de IA na VPS Ubuntu."

    # ETAPA 1: Validar dependências básicas
    log_step 1 "Verificando dependências básicas (Git, 1Password CLI)"
    if ! command -v git &> /dev/null; then
        log_error "Git não encontrado. Execute: sudo apt update && sudo apt install git -y"
        exit 1
    fi
    if ! command -v op &> /dev/null;then
        log_error "1Password CLI (op) não encontrado. Siga o guia de instalação do 1Password para Linux."
        exit 1
    fi
    log_success "Dependências básicas encontradas."

    # ETAPA 2: Autenticar 1Password
    log_step 2 "Verificando autenticação do 1Password"
    if ! op account list &> /dev/null || ! op whoami &> /dev/null; then
        log_info "Sessão do 1Password não está ativa. Por favor, execute 'op signin' e siga as instruções."
        # Em um ambiente de servidor, a interatividade pode ser limitada.
        # O usuário pode precisar fazer isso em uma sessão de terminal separada.
        echo "Aguardando login do 1Password. Pressione [Enter] para tentar novamente."
        read -n 1
    fi
    log_success "Sessão do 1Password está ativa."

    # ETAPA 3: Validar Estrutura do Repositório
    log_step 3 "Validando a estrutura e governança do repositório"
    local script_path="${HOME}/Dotfiles/system_prompts/global/scripts/shared/validar_estrutura_system_prompt.sh"
    if [ -f "$script_path" ]; then
        # Garante que o script de validação seja executável
        chmod +x "$script_path"
        bash "$script_path"
    else
        log_error "Script de validação não encontrado em ${script_path}"
        exit 1
    fi
    log_success "Validação da estrutura concluída. Verifique o relatório gerado."

    # ETAPA 4: Configurar o Shell (Bash)
    log_step 4 "Configurando o ambiente do Bash"
    local bashrc_path="${HOME}/.bashrc"
    local dotfiles_bash_source="source ${HOME}/Dotfiles/system_prompts/global/templates/vps-ubuntu/.bashrc"
    
    if ! grep -qF "${dotfiles_bash_source}" "${bashrc_path}"; then
        log_info "Adicionando 'source' do .bashrc dos dotfiles ao seu ~/.bashrc principal."
        echo "" >> "${bashrc_path}"
        echo "# Carrega as configurações do repositório de dotfiles" >> "${bashrc_path}"
        echo "${dotfiles_bash_source}" >> "${bashrc_path}"
        log_success "Configuração do .bashrc concluída. Por favor, reinicie seu shell ou execute 'source ~/.bashrc'."
    else
        log_success "Configuração do .bashrc já existe."
    fi
    
    # ETAPA 5: Próximos Passos
    echo ""
    log_info "Setup e validação concluídos na VPS."
    log_info "Próximos passos recomendados:"
    echo "  - Reinicie sua sessão de terminal para carregar o novo .bashrc."
    echo "  - Use o VS Code com a extensão Remote-SSH para se conectar a esta VPS e ter uma experiência de IDE completa."
}

# Inicia a execução
main
