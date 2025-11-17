#!/bin/bash

#################################################################################
# Script de Verificação e Configuração do Projeto GCP
# Versão: 2.0.1
# Objetivo: Verificar e configurar o projeto GCP correto
#################################################################################

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuração do Projeto
PROJECT_ID="gcp-ai-setup-24410"
PROJECT_NUMBER="501288307921"
REGION="us-central1"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se gcloud está instalado
check_gcloud() {
    if ! command -v gcloud &> /dev/null; then
        error "gcloud CLI não está instalado"
        echo ""
        echo "Instale com:"
        echo "  brew install --cask google-cloud-sdk"
        echo ""
        return 1
    fi
    success "gcloud CLI encontrado"
    return 0
}

# Verificar autenticação
check_auth() {
    AUTH_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | head -1)
    if [ -n "$AUTH_ACCOUNT" ]; then
        success "Autenticado como: $AUTH_ACCOUNT"
        return 0
    else
        warning "Nenhuma conta autenticada"
        echo ""
        echo "Execute: gcloud auth login"
        return 1
    fi
}

# Verificar projeto configurado
check_project() {
    CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null)
    if [ "$CURRENT_PROJECT" = "$PROJECT_ID" ]; then
        success "Projeto configurado corretamente: $PROJECT_ID"
        return 0
    else
        if [ -z "$CURRENT_PROJECT" ]; then
            warning "Nenhum projeto configurado"
        else
            warning "Projeto incorreto: $CURRENT_PROJECT"
        fi
        echo ""
        echo "Configurando para: $PROJECT_ID"
        if gcloud config set project "$PROJECT_ID" 2>/dev/null; then
            success "Projeto configurado: $PROJECT_ID"
            return 0
        else
            error "Não foi possível configurar o projeto"
            return 1
        fi
    fi
}

# Verificar acesso ao projeto
check_access() {
    if gcloud projects describe "$PROJECT_ID" &>/dev/null; then
        success "Acesso ao projeto confirmado"

        # Verificar número do projeto
        ACTUAL_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)" 2>/dev/null)
        if [ "$ACTUAL_NUMBER" = "$PROJECT_NUMBER" ]; then
            success "Número do projeto confirmado: $PROJECT_NUMBER"
        else
            warning "Número do projeto diferente: $ACTUAL_NUMBER (esperado: $PROJECT_NUMBER)"
        fi

        return 0
    else
        error "Sem acesso ao projeto $PROJECT_ID"
        echo ""
        echo "Possíveis causas:"
        echo "1. Conta não tem permissões no projeto"
        echo "2. Projeto não existe ou foi deletado"
        echo "3. Problema de autenticação"
        echo ""
        echo "Verifique permissões com:"
        echo "  gcloud projects get-iam-policy $PROJECT_ID"
        return 1
    fi
}

# Verificar arquivos de configuração
check_config_files() {
    log "Verificando arquivos de configuração..."

    local errors=0

    # Verificar gemini config
    if [ -f "$HOME/Dotfiles/gemini/.gemini/config.yaml" ]; then
        if grep -q "project: gcp-ai-setup-24410" "$HOME/Dotfiles/gemini/.gemini/config.yaml"; then
            success "gemini/.gemini/config.yaml: OK"
        else
            error "gemini/.gemini/config.yaml: projeto incorreto"
            errors=$((errors + 1))
        fi
    fi

    # Verificar gemini_config.json
    if [ -f "$HOME/Dotfiles/configs/gemini_config.json" ]; then
        if grep -q "\"gcp_project_id\": \"gcp-ai-setup-24410\"" "$HOME/Dotfiles/configs/gemini_config.json"; then
            success "configs/gemini_config.json: OK"
        else
            error "configs/gemini_config.json: projeto incorreto"
            errors=$((errors + 1))
        fi
    fi

    # Verificar google-ai config
    if [ -f "$HOME/Dotfiles/cursor/config/google-ai/google-ai.config.example.json" ]; then
        if grep -q "\"project_id\": \"gcp-ai-setup-24410\"" "$HOME/Dotfiles/cursor/config/google-ai/google-ai.config.example.json"; then
            success "cursor/config/google-ai/google-ai.config.example.json: OK"
        else
            error "cursor/config/google-ai/google-ai.config.example.json: projeto incorreto"
            errors=$((errors + 1))
        fi
    fi

    if [ $errors -eq 0 ]; then
        success "Todos os arquivos de configuração estão corretos"
        return 0
    else
        error "Encontrados $errors arquivo(s) com configuração incorreta"
        return 1
    fi
}

main() {
    clear

    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Verificação e Configuração do Projeto GCP            ║"
    echo "║              Projeto: $PROJECT_ID              ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    local all_ok=true

    # Verificar gcloud
    if ! check_gcloud; then
        all_ok=false
        exit 1
    fi

    echo ""

    # Verificar autenticação
    if ! check_auth; then
        all_ok=false
    fi

    echo ""

    # Verificar projeto
    if ! check_project; then
        all_ok=false
    fi

    echo ""

    # Verificar acesso
    if ! check_access; then
        all_ok=false
    fi

    echo ""

    # Verificar arquivos de configuração
    if ! check_config_files; then
        all_ok=false
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    if [ "$all_ok" = true ]; then
        echo "║              VERIFICAÇÃO CONCLUÍDA COM SUCESSO              ║"
        echo "╚═══════════════════════════════════════════════════════════════╝"
        echo ""
        success "Todas as verificações passaram!"
    else
        echo "║              VERIFICAÇÃO ENCONTROU PROBLEMAS                ║"
        echo "╚═══════════════════════════════════════════════════════════════╝"
        echo ""
        warning "Alguns problemas foram encontrados. Revise as mensagens acima."
    fi

    echo ""
    echo "Informações do Projeto:"
    echo "  ID: $PROJECT_ID"
    echo "  Número: $PROJECT_NUMBER"
    echo "  Região: $REGION"
    echo ""
}

main "$@"
