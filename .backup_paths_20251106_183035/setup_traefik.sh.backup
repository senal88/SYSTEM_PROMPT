#!/bin/bash
# setup_traefik.sh
# Configuração Traefik com ACME
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

echo "🌐 Configurando Traefik com Let's Encrypt"

# Criar volume para certificados
docker volume create traefik_certs 2>/dev/null || true

# Criar acme.json com permissões corretas
COMPOSE_DIR="${HOME}/Dotfiles/automation_1password/compose"

# Verificar se compose/docker-compose.yml existe
if [ -f "${COMPOSE_DIR}/docker-compose.yml" ]; then
    echo "✅ docker-compose.yml encontrado"
    echo ""
    echo "Para completar configuração:"
    echo "1. Edite env.template e adicione TRAEFIK_EMAIL"
    echo "2. Execute: make compose.env"
    echo "3. Execute: make deploy.local"
else
    echo "❌ docker-compose.yml não encontrado em ${COMPOSE_DIR}"
    exit 1
fi

echo "✅ Traefik pronto para uso"

