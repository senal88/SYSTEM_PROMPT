#!/bin/bash
set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
BACKUP_DIR="$HOME/Dotfiles/claude-cloud-knowledge/06_MCP/configuracoes/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Instalação Profissional de Servidores MCP${NC}\n"

# Criar backup
mkdir -p "$BACKUP_DIR"
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_DIR/claude_desktop_config.json.backup.$TIMESTAMP"
    echo -e "${GREEN}✅ Backup criado: $TIMESTAMP${NC}"
fi

# Verificar dependências
echo -e "${YELLOW}📦 Verificando dependências...${NC}"

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $1 encontrado${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 não encontrado${NC}"
        return 1
    fi
}

check_command node || { echo -e "${RED}❌ Node.js é obrigatório. Instale via: brew install node${NC}"; exit 1; }
check_command python3 || { echo -e "${RED}❌ Python3 é obrigatório. Instale via: brew install python@3.14${NC}"; exit 1; }

if ! check_command uv; then
    echo -e "${YELLOW}⚠️  uv não encontrado, instalando...${NC}"
    brew install uv
fi

# Verificar versões
echo -e "\n${YELLOW}📊 Versões instaladas:${NC}"
echo "  Node.js: $(node --version)"
echo "  Python: $(python3 --version)"
echo "  uv: $(uv --version)"

# Instalar servidores Node.js
echo -e "\n${YELLOW}📦 Instalando servidores Node.js (via npm global)...${NC}"

NODE_SERVERS=(
    "@modelcontextprotocol/server-filesystem"
    "@modelcontextprotocol/server-memory"
    "@modelcontextprotocol/server-sequential-thinking"
    "@modelcontextprotocol/server-github"
    "@modelcontextprotocol/server-brave-search"
    "@modelcontextprotocol/server-sqlite"
    "@modelcontextprotocol/server-docker"
    "@modelcontextprotocol/server-kubernetes"
    "@modelcontextprotocol/server-aws"
    "@modelcontextprotocol/server-notion"
    "@modelcontextprotocol/server-slack"
    "@modelcontextprotocol/server-puppeteer"
    "@modelcontextprotocol/server-playwright"
)

for server in "${NODE_SERVERS[@]}"; do
    echo -e "${BLUE}  Instalando $server...${NC}"
    npm install -g "$server" || echo -e "${YELLOW}  ⚠️  Falha ao instalar $server (pode já estar instalado)${NC}"
done

# Instalar servidores Python via uvx
echo -e "\n${YELLOW}📦 Instalando servidores Python (via uvx)...${NC}"

PYTHON_SERVERS=(
    "mcp-server-git"
    "mcp-server-fetch"
    "mcp-server-time"
    "mcp-server-postgres"
    "mcp-server-mysql"
    "mcp-server-mongodb"
    "mcp-server-redis"
    "mcp-server-python-sandbox"
)

for server in "${PYTHON_SERVERS[@]}"; do
    echo -e "${BLUE}  Instalando $server...${NC}"
    uvx install "$server" || echo -e "${YELLOW}  ⚠️  Falha ao instalar $server${NC}"
done

# Copiar configuração de produção
echo -e "\n${YELLOW}📝 Configurando arquivo de configuração...${NC}"
PROD_CONFIG="$SCRIPT_DIR/../configuracoes/claude_desktop_config.production.json"

if [ -f "$PROD_CONFIG" ]; then
    # Criar diretório se não existir
    mkdir -p "$(dirname "$CONFIG_FILE")"

    # Copiar configuração
    cp "$PROD_CONFIG" "$CONFIG_FILE"
    echo -e "${GREEN}✅ Configuração copiada${NC}"

    echo -e "\n${YELLOW}⚠️  IMPORTANTE: Configure as variáveis de ambiente:${NC}"
    echo -e "${BLUE}  Adicione ao ~/.zshrc ou ~/.env.local:${NC}"
    echo ""
    echo "  export GITHUB_TOKEN=\"ghp_...\""
    echo "  export BRAVE_API_KEY=\"...\""
    echo "  export POSTGRES_CONNECTION_STRING=\"postgresql://...\""
    echo "  export AWS_ACCESS_KEY_ID=\"...\""
    echo "  export AWS_SECRET_ACCESS_KEY=\"...\""
    echo "  export AWS_REGION=\"us-east-1\""
    echo "  export NOTION_API_KEY=\"...\""
    echo "  export SLACK_BOT_TOKEN=\"...\""
    echo "  export VPS_MCP_URL=\"https://mcp.seu-dominio.com\""
    echo "  export VPS_MCP_TOKEN=\"...\""
    echo ""
else
    echo -e "${RED}❌ Arquivo de configuração não encontrado: $PROD_CONFIG${NC}"
fi

# Verificar configuração
echo -e "\n${YELLOW}🔍 Verificando configuração...${NC}"
if command -v python3 >/dev/null 2>&1; then
    if python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
        SERVER_COUNT=$(python3 << EOF
import json
with open("$CONFIG_FILE") as f:
    config = json.load(f)
    servers = config.get('mcpServers', {})
    print(len(servers))
EOF
)
        echo -e "${GREEN}✅ JSON válido${NC}"
        echo -e "${GREEN}📊 Servidores configurados: $SERVER_COUNT${NC}"
    else
        echo -e "${RED}❌ JSON inválido${NC}"
    fi
fi

echo -e "\n${GREEN}✅ Instalação concluída!${NC}"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo "  1. Configure as variáveis de ambiente"
echo "  2. Reinicie o Claude Desktop completamente"
echo "  3. Verifique os logs em ~/Library/Logs/Claude/"
echo ""
echo -e "${BLUE}💡 Dica: Use o script verify-mcp-servers.sh para verificar a configuração${NC}"

