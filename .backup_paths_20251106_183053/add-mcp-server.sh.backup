#!/usr/bin/env bash
# add-mcp-server.sh
# Adiciona servidor MCP HTTP ao Claude Desktop

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuração
CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
CONFIG_DIR="$(dirname "$CONFIG_FILE")"

# Função de ajuda
show_help() {
    cat << EOF
Uso: $0 <nome-servidor> <url> [bearer-token] [api-key]

Adiciona um servidor MCP HTTP ao Claude Desktop.

Argumentos:
  nome-servidor    Nome do servidor (ex: my-server)
  url              URL do servidor MCP (ex: https://example.com/mcp)
  bearer-token     Token de autenticação Bearer (opcional)
  api-key          API Key para header X-API-Key (opcional)

Exemplos:
  $0 my-server https://example.com/mcp
  $0 my-server https://example.com/mcp "Bearer token123"
  $0 my-server https://example.com/mcp "Bearer token123" "api-key-456"

EOF
}

# Verificar argumentos
if [ $# -lt 2 ]; then
    show_help
    exit 1
fi

SERVER_NAME="$1"
SERVER_URL="$2"
AUTH_TOKEN="${3:-}"
API_KEY="${4:-}"

# Criar diretório se não existir
mkdir -p "$CONFIG_DIR"

echo -e "${BLUE}🔧 Configurando servidor MCP HTTP...${NC}"
echo "   Nome: $SERVER_NAME"
echo "   URL: $SERVER_URL"

# Ler configuração existente ou criar nova
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${BLUE}📄 Arquivo de configuração encontrado${NC}"
    # Backup
    cp "$CONFIG_FILE" "$CONFIG_FILE.bak" 2>/dev/null || true
    CONFIG=$(cat "$CONFIG_FILE")
else
    echo -e "${YELLOW}📄 Criando nova configuração${NC}"
    CONFIG='{"preferences": {"quickEntryShortcut": "double-tap-option"}, "mcpServers": {}}'
fi

# Adicionar servidor usando jq (preferido) ou Python
if command -v jq &> /dev/null; then
    echo -e "${BLUE}✅ Usando jq para atualizar configuração${NC}"

    # Construir objeto de headers
    HEADERS_JSON="{}"
    if [ -n "$AUTH_TOKEN" ]; then
        HEADERS_JSON=$(echo "$HEADERS_JSON" | jq --arg token "$AUTH_TOKEN" '. + {"Authorization": $token}')
    fi
    if [ -n "$API_KEY" ]; then
        HEADERS_JSON=$(echo "$HEADERS_JSON" | jq --arg key "$API_KEY" '. + {"X-API-Key": $key}')
    fi

    # Adicionar servidor
    NEW_CONFIG=$(echo "$CONFIG" | jq --arg name "$SERVER_NAME" \
        --arg url "$SERVER_URL" \
        --argjson headers "$HEADERS_JSON" \
        '.mcpServers[$name] = {
            "type": "http",
            "url": $url,
            "headers": $headers
        }')

    echo "$NEW_CONFIG" | jq '.' > "$CONFIG_FILE"
    echo -e "${GREEN}✅ Servidor MCP '$SERVER_NAME' adicionado com sucesso${NC}"

elif command -v python3 &> /dev/null; then
    echo -e "${BLUE}✅ Usando Python para atualizar configuração${NC}"

    python3 << EOF
import json
import sys
import os

config_file = "$CONFIG_FILE"
server_name = "$SERVER_NAME"
server_url = "$SERVER_URL"
auth_token = "$AUTH_TOKEN"
api_key = "$API_KEY"

# Ler configuração existente
try:
    with open(config_file, 'r') as f:
        config = json.load(f)
except FileNotFoundError:
    config = {"preferences": {"quickEntryShortcut": "double-tap-option"}, "mcpServers": {}}

# Garantir que mcpServers existe
if "mcpServers" not in config:
    config["mcpServers"] = {}

# Construir headers
headers = {}
if auth_token:
    headers["Authorization"] = auth_token
if api_key:
    headers["X-API-Key"] = api_key

# Adicionar servidor
config["mcpServers"][server_name] = {
    "type": "http",
    "url": server_url,
    "headers": headers
}

# Salvar configuração
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ Servidor MCP '{}' adicionado com sucesso".format(server_name))
EOF

else
    echo -e "${RED}❌ Erro: jq ou python3 não encontrado${NC}"
    echo "   Instale jq: brew install jq"
    echo "   Ou use Python para editar manualmente: $CONFIG_FILE"
    exit 1
fi

echo ""
echo -e "${BLUE}📋 Configuração atualizada:${NC}"
echo "   Arquivo: $CONFIG_FILE"
echo ""
echo -e "${BLUE}🔄 Próximos passos:${NC}"
echo "   1. Reinicie o Claude Desktop para aplicar mudanças"
echo "   2. Verifique se o servidor aparece nas configurações"
echo "   3. Teste usando o servidor MCP no Claude"
echo ""

# Mostrar configuração do servidor adicionado
if command -v jq &> /dev/null; then
    echo -e "${BLUE}📄 Configuração do servidor:${NC}"
    cat "$CONFIG_FILE" | jq ".mcpServers[\"$SERVER_NAME\"]"
fi

