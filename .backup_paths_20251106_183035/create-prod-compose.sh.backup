#!/bin/bash
# create-prod-compose.sh
# Cria docker-compose.yml otimizado para produção VPS
# Last Updated: 2025-11-02
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/../lib/logging.sh"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
COMPOSE_DIR="${REPO_ROOT}/compose"
PROD_DIR="${REPO_ROOT}/prod"
SOURCE_COMPOSE="${COMPOSE_DIR}/docker-compose-ai-stack.yml"

# ============================================================================
# FUNÇÕES
# ============================================================================

create_prod_compose() {
    log_section "🐳 Criando docker-compose.yml para PROD"
    
    if [ ! -f "${SOURCE_COMPOSE}" ]; then
        log_error "Arquivo fonte não encontrado: ${SOURCE_COMPOSE}"
        return 1
    fi
    
    # Ler compose original e adaptar para produção
    log_info "Adaptando compose para produção VPS..."
    
    # Copiar e adaptar
    cat > "${PROD_DIR}/docker-compose.yml" << 'EOF'
# Docker Compose - AI Stack para Produção VPS Ubuntu
# Baseado em: docker-compose-ai-stack.yml
# Adaptado para: VPS Ubuntu 24.04.3 LTS (147.79.81.59)

services:
  # === n8n ===
  n8n:
    image: n8nio/n8n:latest
    container_name: platform_n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_USER:-admin}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_PASSWORD}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_USER_MANAGEMENT_JWT_SECRET=${N8N_USER_MANAGEMENT_JWT_SECRET}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres-ai
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB:-n8n}
      - DB_POSTGRESDB_USER=${POSTGRES_USER:-n8n}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      postgres-ai:
        condition: service_healthy
    networks:
      - app_network
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:5678/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  # === PostgreSQL (com pgvector) ===
  postgres-ai:
    image: pgvector/pgvector:pg16
    container_name: platform_postgres_ai
    restart: unless-stopped
    environment:
      - POSTGRES_USER=${POSTGRES_USER:-n8n}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB:-n8n}
    volumes:
      - postgres_ai_data:/var/lib/postgresql/data
    networks:
      - app_network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-n8n}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

  # === Qdrant (Vector Store) ===
  qdrant:
    image: qdrant/qdrant:latest
    container_name: platform_qdrant
    restart: unless-stopped
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_data:/qdrant/storage
    networks:
      - app_network
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:6333/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s

volumes:
  n8n_data:
    driver: local
  postgres_ai_data:
    driver: local
  qdrant_data:
    driver: local

networks:
  app_network:
    driver: bridge
    name: platform_net

EOF
    
    log_success "docker-compose.yml criado: ${PROD_DIR}/docker-compose.yml"
}

create_prod_env_template() {
    log_section "📝 Criando .env.template para PROD"
    
    cat > "${PROD_DIR}/.env.template" << 'EOF'
# Environment Variables - AI Stack Production (VPS)
# Injetar: op inject -i .env.template -o .env
# Last Updated: 2025-11-02

# === Project ===
PROJECT_SLUG=platform

# === PostgreSQL ===
POSTGRES_USER=op://1p_vps/PostgreSQL/username
POSTGRES_PASSWORD=op://1p_vps/PostgreSQL/password
POSTGRES_DB=op://1p_vps/PostgreSQL/database

# === n8n Security ===
N8N_ENCRYPTION_KEY=op://1p_vps/n8n/encryption_key
N8N_USER_MANAGEMENT_JWT_SECRET=op://1p_vps/n8n/jwt_secret
N8N_USER=op://1p_vps/n8n/admin_username
N8N_PASSWORD=op://1p_vps/n8n/admin_password

# === API Keys (Opcional) ===
OPENAI_API_KEY=op://1p_vps/OpenAI-API/credential
ANTHROPIC_API_KEY=op://1p_vps/Anthropic-API/credential
HUGGINGFACE_TOKEN=op://1p_vps/HuggingFace-Token/credential
PERPLEXITY_API_KEY=op://1p_vps/Perplexity-API/credential

EOF
    
    log_success ".env.template criado: ${PROD_DIR}/.env.template"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "📦 Criando Docker Compose para Produção"
    
    create_prod_compose
    echo ""
    
    create_prod_env_template
    echo ""
    
    log_section "✅ Concluído"
    log_success "Docker Compose criado para produção"
    log_success "Template .env criado (usa vault 1p_vps)"
    echo ""
    echo "Arquivos criados:"
    echo "  - ${PROD_DIR}/docker-compose.yml"
    echo "  - ${PROD_DIR}/.env.template"
    echo ""
    echo "Próximos passos na VPS:"
    echo "  1. Copiar docker-compose.yml para VPS"
    echo "  2. Criar .env: op inject -i .env.template -o .env"
    echo "  3. Validar: docker compose config"
    echo "  4. Iniciar: docker compose up -d"
    
    return 0
}

main "$@"

