#!/bin/bash
# =============================================================================
# 🔐 Setup 1Password Connect - Estrutura Segura
# Arquivo: scripts/connect/setup-1password-connect-secure.sh
# Propósito: Preparar diretórios, arquivos e verificações básicas sem gravar
#            segredos em disco. Os segredos devem ser mantidos no 1Password
#            (vaults 1p_macos e 1p_vps) e carregados via load-secure-env.sh.
# =============================================================================

set -euo pipefail

AUTOMATION_ROOT="${AUTOMATION_ROOT:-$HOME/Dotfiles/automation_1password}"
CONNECT_ROOT="$AUTOMATION_ROOT/connect"
TEMPLATE_ROOT="$AUTOMATION_ROOT/templates/env"
ENV_ROOT="$AUTOMATION_ROOT/env"
LOG_ROOT="$AUTOMATION_ROOT/logs"
TOKEN_ROOT="$AUTOMATION_ROOT/tokens"

info()  { printf '\033[0;34mℹ️  %s\033[0m\n' "$1"; }
success(){ printf '\033[0;32m✅ %s\033[0m\n' "$1"; }
warn()  { printf '\033[1;33m⚠️  %s\033[0m\n' "$1"; }

info "Preparando estrutura do 1Password Connect em: $AUTOMATION_ROOT"

# 1. Diretórios-base -----------------------------------------------------------------
mkdir -p "$CONNECT_ROOT" "$CONNECT_ROOT/certs" "$CONNECT_ROOT/data"
mkdir -p "$ENV_ROOT" "$TEMPLATE_ROOT" "$LOG_ROOT" "$TOKEN_ROOT"

printf '' > "$CONNECT_ROOT/certs/.gitkeep"
printf '' > "$CONNECT_ROOT/data/.gitkeep"
printf '' > "$LOG_ROOT/.gitkeep"
printf '' > "$TOKEN_ROOT/.gitkeep"

success "Diretórios criados com .gitkeep para evitar vazamento de arquivos sensíveis."

# 2. Docker Compose (somente se ainda não existir) -----------------------------------
COMPOSE_FILE="$CONNECT_ROOT/docker-compose.yml"
if [[ ! -f "$COMPOSE_FILE" ]]; then
  cat <<'EOF_COMPOSE' > "$COMPOSE_FILE"
# =============================================================================
# 🐳 Docker Compose - 1Password Connect Server (exemplo)
# As variáveis abaixo são preenchidas após executar scripts/secrets/load-secure-env.sh
# =============================================================================

services:
  connect-api:
    image: 1password/connect-api:1.7.2
    platform: linux/arm64
    container_name: op-connect-api
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      - OP_CONNECT_TOKEN=${OP_CONNECT_TOKEN:?Execute scripts/secrets/load-secure-env.sh primeiro}
    volumes:
      - ./data:/home/op/data
      - ./credentials.json:/home/opuser/credentials.json:ro
      - ./certs:/home/op/certs:ro
    networks:
      - connect_net
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  connect-sync:
    image: 1password/connect-sync:1.7.2
    platform: linux/arm64
    container_name: op-connect-sync
    restart: unless-stopped
    depends_on:
      - connect-api
    environment:
      - OP_CONNECT_TOKEN=${OP_CONNECT_TOKEN:?Execute scripts/secrets/load-secure-env.sh primeiro}
    volumes:
      - ./data:/home/op/data
      - ./credentials.json:/home/opuser/credentials.json:ro
    networks:
      - connect_net

networks:
  connect_net:
    driver: bridge
EOF_COMPOSE
  success "Docker Compose de exemplo criado em connect/docker-compose.yml."
else
  warn "connect/docker-compose.yml já existe; nenhuma alteração realizada."
fi

# 3. Templates de variáveis ----------------------------------------------------------
declare -A REQUIRED_TEMPLATES=(
  ["$TEMPLATE_ROOT/macos.secrets.env.op"]="# Template macOS"
  ["$TEMPLATE_ROOT/vps.secrets.env.op"]="# Template VPS"
)

for template in "${!REQUIRED_TEMPLATES[@]}"; do
  if [[ ! -f "$template" ]]; then
    warn "Template ausente: $template"
    warn "Crie o arquivo baseado nos exemplos deste repositório para mapear os itens do vault." 
  fi
done

success "Verificação de templates concluída."

# 4. Arquivos de ambiente base --------------------------------------------------------
for file in "$ENV_ROOT/shared.env" "$ENV_ROOT/macos.env" "$ENV_ROOT/vps.env"; do
  if [[ ! -f "$file" ]]; then
    warn "Arquivo de configuração ausente: $file"
    warn "Execute git pull ou copie os modelos padrões para restaurá-los."
  fi
done

success "Arquivos de ambiente verificados."

# 5. Resumo de próximos passos --------------------------------------------------------
cat <<'EOF_NEXT'

📌 Próximos passos recomendados
------------------------------
1. Abra os templates em templates/env/*.secrets.env.op e ajuste os paths para os itens dos vaults:
   - 1p_macos → Connect Server, Service Account, APIs locais
   - 1p_vps   → Connect Server, Service Account e integrações de produção
2. Autentique-se no 1Password CLI:  eval "$(op signin)"
3. Carregue o ambiente desejado:
   scripts/secrets/load-secure-env.sh macos   # ou vps
4. Gere o arquivo credentials.json diretamente pelo 1Password (download) e salve em connect/ (permissão 600).
5. Inicie o Connect Server com Docker Compose:
   (cd connect && docker compose up -d)
6. Valide: scripts/validation/validate-setup.sh

Nenhum segredo foi gravado em disco durante esta preparação. Todos os dados sensíveis
continuam no 1Password e são injetados apenas em memória com op inject.
EOF_NEXT

success "Bootstrap seguro concluído."
