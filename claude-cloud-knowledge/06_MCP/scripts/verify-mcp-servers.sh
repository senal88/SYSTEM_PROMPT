#!/bin/bash

CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Verificando Configuração MCP${NC}\n"

# Verificar se arquivo existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}❌ Arquivo de configuração não encontrado: $CONFIG_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Arquivo encontrado${NC}"

# Verificar JSON válido
if ! python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
    echo -e "${RED}❌ JSON inválido${NC}"
    exit 1
fi

echo -e "${GREEN}✅ JSON válido${NC}"

# Contar e listar servidores
python3 << EOF
import json
import os
from pathlib import Path

config_file = Path("$CONFIG_FILE")
with open(config_file) as f:
    config = json.load(f)
    servers = config.get('mcpServers', {})

    print(f"\n📊 Total de servidores configurados: {len(serviders)}\n")

    if servers:
        print("📋 Servidores:")
        for name, server_config in servers.items():
            desc = server_config.get('description', 'Sem descrição')
            transport = server_config.get('transport', 'stdio')
            command = server_config.get('command', 'N/A')

            print(f"\n  • ${name}")
            print(f"    Descrição: {desc}")
            print(f"    Transport: {transport}")
            if transport == 'stdio':
                print(f"    Comando: {command}")
                args = server_config.get('args', [])
                if args:
                    print(f"    Args: {' '.join(str(a) for a in args[:3])}{'...' if len(args) > 3 else ''}")

            # Verificar variáveis de ambiente
            env_vars = server_config.get('env', {})
            if env_vars:
                print(f"    Variáveis de ambiente:")
                for key, value in env_vars.items():
                    if isinstance(value, str) and value.startswith('\${'):
                        print(f"      {key}: [Variável de ambiente]")
                    else:
                        masked = '*' * min(len(str(value)), 8) if value else 'Não definido'
                        print(f"      {key}: {masked}")
    else:
        print("⚠️  Nenhum servidor configurado")
EOF

# Verificar variáveis de ambiente necessárias
echo -e "\n${YELLOW}🔐 Verificando variáveis de ambiente...${NC}"

ENV_VARS=(
    "GITHUB_TOKEN"
    "BRAVE_API_KEY"
    "POSTGRES_CONNECTION_STRING"
    "AWS_ACCESS_KEY_ID"
    "AWS_SECRET_ACCESS_KEY"
    "AWS_REGION"
    "NOTION_API_KEY"
    "SLACK_BOT_TOKEN"
    "VPS_MCP_URL"
    "VPS_MCP_TOKEN"
)

MISSING_VARS=()

for var in "${ENV_VARS[@]}"; do
    if [ -z "${!var:-}" ]; then
        MISSING_VARS+=("$var")
    else
        echo -e "${GREEN}  ✅ $var${NC}"
    fi
done

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}⚠️  Variáveis não definidas:${NC}"
    for var in "${MISSING_VARS[@]}"; do
        echo -e "${YELLOW}  • $var${NC}"
    fi
    echo -e "\n${BLUE}💡 Configure essas variáveis no ~/.zshrc ou ~/.env.local${NC}"
else
    echo -e "\n${GREEN}✅ Todas as variáveis de ambiente estão definidas${NC}"
fi

# Verificar logs
LOG_DIR="$HOME/Library/Logs/Claude"
if [ -d "$LOG_DIR" ]; then
    echo -e "\n${BLUE}📋 Logs disponíveis em: $LOG_DIR${NC}"
    LOG_FILES=$(find "$LOG_DIR" -name "*mcp*" -type f 2>/dev/null | head -5)
    if [ -n "$LOG_FILES" ]; then
        echo -e "${YELLOW}  Arquivos de log encontrados:${NC}"
        echo "$LOG_FILES" | while read -r log; do
            echo "    • $(basename "$log")"
        done
    fi
fi

echo -e "\n${GREEN}✅ Verificação concluída${NC}"

