#!/bin/bash

#################################################################################
# Script de Setup de Contexto para DevContainer
# Versão: 2.0.1
# Objetivo: Configurar contexto global no DevContainer
#################################################################################

set -e

DOTFILES_DIR="${HOME}/Dotfiles"
CONTEXT_DIR="${DOTFILES_DIR}/context"

log() {
    echo "🔵 [INFO] $1"
}

success() {
    echo "✅ [SUCCESS] $1"
}

# Criar estrutura de contexto no DevContainer
setup_context() {
    log "Configurando contexto global no DevContainer..."

    # Criar diretórios
    mkdir -p "${CONTEXT_DIR}"/{global,cursor,vscode,claude,gemini,chatgpt}

    # Copiar contexto global se existir
    if [ -f "${DOTFILES_DIR}/context/global/CONTEXTO_GLOBAL_COMPLETO.md" ]; then
        cp "${DOTFILES_DIR}/context/global/CONTEXTO_GLOBAL_COMPLETO.md" \
           "${CONTEXT_DIR}/global/" 2>/dev/null || true
        success "Contexto global copiado"
    fi

    # Criar link simbólico para fácil acesso
    ln -sf "${CONTEXT_DIR}/global/CONTEXTO_GLOBAL_COMPLETO.md" \
           "${HOME}/CONTEXTO_GLOBAL.md" 2>/dev/null || true

    success "Contexto configurado no DevContainer"
}

# Configurar variáveis de ambiente
setup_env_vars() {
    log "Configurando variáveis de ambiente..."

    cat >> "${HOME}/.bashrc" << 'EOF'

# Dotfiles Context
export DOTFILES_DIR="${HOME}/Dotfiles"
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"

# Context paths
export CONTEXT_GLOBAL="${DOTFILES_DIR}/context/global/CONTEXTO_GLOBAL_COMPLETO.md"
EOF

    if [ -f "${HOME}/.zshrc" ]; then
        cat >> "${HOME}/.zshrc" << 'EOF'

# Dotfiles Context
export DOTFILES_DIR="${HOME}/Dotfiles"
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"

# Context paths
export CONTEXT_GLOBAL="${DOTFILES_DIR}/context/global/CONTEXTO_GLOBAL_COMPLETO.md"
EOF
    fi

    success "Variáveis de ambiente configuradas"
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Setup de Contexto Global - DevContainer               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    setup_context
    setup_env_vars

    echo ""
    success "Contexto global configurado no DevContainer!"
    echo ""
    echo "📖 Contexto disponível em: ${CONTEXT_GLOBAL}"
    echo ""
}

main "$@"
