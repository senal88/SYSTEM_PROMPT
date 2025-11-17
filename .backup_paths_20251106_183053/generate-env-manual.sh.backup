#!/bin/bash
# generate-env-manual.sh
# Gera .env manualmente com secrets aleatórios quando 1Password não está disponível
# Last Updated: 2025-11-03
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
ENV_FILE="${1:-.env}"

# ============================================================================
# FUNÇÕES SIMPLES (standalone)
# ============================================================================

log_info() {
    echo "ℹ️  $*" >&2
}

log_success() {
    echo "✅ $*" >&2
}

log_warning() {
    echo "⚠️  $*" >&2
}

log_error() {
    echo "❌ $*" >&2
}

generate_random_string() {
    local length="${1:-32}"
    openssl rand -base64 "${length}" 2>/dev/null | tr -d '\n' | tr -d '/'
}

generate_env_file() {
    log_info "Gerando .env com secrets aleatórios..."
    
    local postgres_pass=$(generate_random_string 24)
    local n8n_key=$(generate_random_string 32)
    local n8n_jwt=$(generate_random_string 32)
    local n8n_pass=$(generate_random_string 16)
    
    cat > "${ENV_FILE}" << EOF
# Environment Variables - AI Stack Production (VPS)
# Gerado automaticamente em $(date)
# AVISO: Secrets gerados aleatoriamente - armazene em 1Password para produção

# === Project ===
PROJECT_SLUG=platform

# === PostgreSQL ===
POSTGRES_USER=n8n
POSTGRES_PASSWORD=${postgres_pass}
POSTGRES_DB=n8n

# === n8n Security ===
N8N_ENCRYPTION_KEY=${n8n_key}
N8N_USER_MANAGEMENT_JWT_SECRET=${n8n_jwt}
N8N_USER=admin
N8N_PASSWORD=${n8n_pass}

# === API Keys (Opcional - configure manualmente se necessário) ===
# OPENAI_API_KEY=
# ANTHROPIC_API_KEY=
# HUGGINGFACE_TOKEN=
# PERPLEXITY_API_KEY=

EOF
    
    chmod 600 "${ENV_FILE}"
    
    log_success ".env criado em ${ENV_FILE}"
    log_info "Secrets gerados aleatoriamente"
    log_warning "IMPORTANTE: Salve estes secrets em 1Password para backup!"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    if [ -f "${ENV_FILE}" ]; then
        echo "⚠️  Arquivo ${ENV_FILE} já existe"
        read -p "Deseja sobrescrever? (s/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log_info "Abortado"
            return 0
        fi
    fi
    
    generate_env_file
    
    echo ""
    log_success "✅ .env criado com sucesso!"
    echo ""
    log_info "Próximos passos:"
    echo "  1. docker compose -f docker-compose.yml config  # Validar"
    echo "  2. docker compose -f docker-compose.yml up -d   # Iniciar"
    echo ""
    log_warning "Lembre-se de salvar os secrets em 1Password!"
    
    return 0
}

main "$@"

