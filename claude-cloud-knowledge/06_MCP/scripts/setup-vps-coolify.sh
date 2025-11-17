#!/bin/bash
set -euo pipefail

# Script de setup para VPS Ubuntu com Coolify
# Este script prepara o ambiente para rodar servidores MCP no Coolify

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setup MCP Server no Coolify${NC}\n"

# Variáveis (ajustar conforme necessário)
MCP_DIR="${MCP_DIR:-/data/coolify/applications/mcp-server-production}"
REPO_URL="https://github.com/modelcontextprotocol/servers.git"
DOMAIN="${DOMAIN:-mcp.seu-dominio.com}"

# Verificar se está rodando como root ou com sudo
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Executando como root${NC}"
fi

# Criar diretório
echo -e "${YELLOW}📁 Criando estrutura de diretórios...${NC}"
mkdir -p "$MCP_DIR"/{servers,data,logs,config}
cd "$MCP_DIR"

# Clonar repositório de servidores MCP
if [ ! -d "servers" ] || [ -z "$(ls -A servers)" ]; then
    echo -e "${YELLOW}📦 Clonando repositório MCP...${NC}"
    git clone "$REPO_URL" servers-tmp
    mv servers-tmp/* servers/ 2>/dev/null || true
    rm -rf servers-tmp
else
    echo -e "${GREEN}✅ Repositório já existe${NC}"
fi

# Instalar Node.js se não estiver instalado
if ! command -v node >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Instalando Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi

# Instalar dependências
cd "$MCP_DIR/servers/src/everything"
echo -e "${YELLOW}📦 Instalando dependências Node.js...${NC}"
npm install
npm run build

# Criar arquivo docker-compose.yml
echo -e "${YELLOW}📝 Criando docker-compose.yml...${NC}"
cat > "$MCP_DIR/docker-compose.yml" << 'DOCKER_COMPOSE_EOF'
version: '3.8'

services:
  mcp-http:
    image: node:20-alpine
    container_name: mcp-http-server
    working_dir: /app
    volumes:
      - ./servers:/app/servers
      - ./data:/app/data
      - ./logs:/app/logs
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
      - MCP_TOKEN=${MCP_TOKEN}
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
    command: >
      sh -c "
        cd /app/servers/src/everything &&
        npm install &&
        node dist/streamableHttp.js
      "
    restart: unless-stopped
    networks:
      - mcp-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  mcp-sse:
    image: node:20-alpine
    container_name: mcp-sse-server
    working_dir: /app
    volumes:
      - ./servers:/app/servers
      - ./data:/app/data
      - ./logs:/app/logs
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - PORT=3001
      - MCP_TOKEN=${MCP_TOKEN}
    command: >
      sh -c "
        cd /app/servers/src/everything &&
        npm install &&
        node dist/sse.js
      "
    restart: unless-stopped
    networks:
      - mcp-network

  postgres:
    image: postgres:16-alpine
    container_name: mcp-postgres
    environment:
      - POSTGRES_DB=${POSTGRES_DB:-mcp}
      - POSTGRES_USER=${POSTGRES_USER:-mcp}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - mcp-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-mcp}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: mcp-redis
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - mcp-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

volumes:
  postgres-data:
  redis-data:

networks:
  mcp-network:
    driver: bridge
DOCKER_COMPOSE_EOF

# Criar arquivo .env.example
echo -e "${YELLOW}📝 Criando .env.example...${NC}"
cat > "$MCP_DIR/.env.example" << 'ENV_EOF'
# MCP Server Configuration
MCP_TOKEN=seu-token-secreto-aqui

# Database
POSTGRES_DB=mcp
POSTGRES_USER=mcp
POSTGRES_PASSWORD=senha-segura-aqui
DATABASE_URL=postgresql://mcp:senha-segura-aqui@postgres:5432/mcp

# Redis
REDIS_URL=redis://redis:6379

# Domain
DOMAIN=mcp.seu-dominio.com
ENV_EOF

# Criar arquivo nginx.conf para Coolify
echo -e "${YELLOW}📝 Criando configuração Nginx...${NC}"
cat > "$MCP_DIR/nginx.conf" << NGINX_EOF
server {
    listen 443 ssl http2;
    server_name ${DOMAIN};

    ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    # Rate limiting
    limit_req_zone \$binary_remote_addr zone=mcp_limit:10m rate=10r/s;
    limit_req zone=mcp_limit burst=20 nodelay;

    # MCP HTTP endpoint
    location /mcp {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }

    # SSE endpoint
    location /sse {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_buffering off;
        proxy_read_timeout 24h;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:3000/health;
        access_log off;
    }
}
NGINX_EOF

# Configurar permissões
echo -e "${YELLOW}🔐 Configurando permissões...${NC}"
chown -R 1000:1000 "$MCP_DIR" 2>/dev/null || true
chmod -R 755 "$MCP_DIR"

# Gerar token MCP se não existir
if [ ! -f "$MCP_DIR/.env" ]; then
    echo -e "${YELLOW}🔑 Gerando token MCP...${NC}"
    MCP_TOKEN=$(openssl rand -hex 32)
    echo "MCP_TOKEN=$MCP_TOKEN" > "$MCP_DIR/.env"
    echo -e "${GREEN}✅ Token gerado e salvo em .env${NC}"
    echo -e "${YELLOW}⚠️  IMPORTANTE: Salve este token em local seguro:${NC}"
    echo -e "${BLUE}   $MCP_TOKEN${NC}"
fi

echo -e "\n${GREEN}✅ Setup concluído!${NC}"
echo -e "\n${YELLOW}📝 Próximos passos no Coolify:${NC}"
echo "  1. Importe o docker-compose.yml no Coolify"
echo "  2. Configure as variáveis de ambiente:"
echo "     - MCP_TOKEN"
echo "     - POSTGRES_PASSWORD"
echo "     - DATABASE_URL"
echo "     - REDIS_URL"
echo "  3. Configure o domínio e SSL"
echo "  4. Configure o Nginx conforme nginx.conf"
echo ""
echo -e "${BLUE}💡 Use o token MCP gerado para configurar o Claude Desktop${NC}"

