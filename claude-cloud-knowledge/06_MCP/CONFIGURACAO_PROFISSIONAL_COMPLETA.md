# 🚀 Configuração Profissional Completa - Claude Desktop MCP

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Ambiente macOS Silicon](#ambiente-macos-silicon)
3. [Ambiente VPS Ubuntu com Coolify](#ambiente-vps-ubuntu-com-coolify)
4. [Servidores MCP por Categoria](#servidores-mcp-por-categoria)
5. [Scripts de Instalação](#scripts-de-instalação)
6. [Segurança e Boas Práticas](#segurança-e-boas-práticas)
7. [Troubleshooting Avançado](#troubleshooting-avançado)

---

## 🎯 Visão Geral

Esta configuração profissional maximiza todas as funcionalidades do Model Context Protocol (MCP) no Claude Desktop, organizando servidores por categoria e otimizando para uso em produção.

### Arquitetura

```
Claude Desktop (macOS Silicon)
├── Servidores Locais (stdio)
│   ├── Filesystem
│   ├── Git
│   ├── Memory
│   └── Sequential Thinking
├── Servidores Remotos (HTTP/SSE)
│   ├── VPS Ubuntu (Coolify)
│   ├── Databases
│   └── Cloud Services
└── Servidores Especializados
    ├── Development Tools
    ├── DevOps
    └── AI/ML Services
```

---

## 🖥️ Ambiente macOS Silicon

### Pré-requisitos Verificados

```bash
✅ Node.js v25.1.0 (via Homebrew)
✅ Python 3.14.0 (via Homebrew)
✅ uv 0.9.8 (gerenciador Python moderno)
✅ Homebrew instalado e atualizado
```

### Estrutura de Diretórios

```bash
~/Dotfiles/claude-cloud-knowledge/06_MCP/
├── configuracoes/
│   ├── claude_desktop_config.json          # Config principal
│   ├── claude_desktop_config.production.json
│   └── claude_desktop_config.development.json
├── scripts/
│   ├── install-mcp-servers.sh              # Instalação automática
│   ├── update-mcp-config.sh                # Atualização de config
│   └── verify-mcp-servers.sh               # Verificação de saúde
├── env/
│   ├── .env.example                        # Template de variáveis
│   └── .env.local                          # Variáveis locais (gitignored)
└── docs/
    ├── CONFIGURACAO_PROFISSIONAL_COMPLETA.md
    └── SERVIDORES_DISPONIVEIS.md
```

### Configuração Completa para macOS Silicon

**Localização:** `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "preferences": {
    "quickEntryShortcut": "double-tap-option",
    "theme": "auto",
    "fontSize": 14
  },
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/luiz.sena88/Documents",
        "/Users/luiz.sena88/Projetos",
        "/Users/luiz.sena88/Dotfiles"
      ],
      "description": "Acesso seguro ao sistema de arquivos"
    },
    "git": {
      "command": "uvx",
      "args": [
        "mcp-server-git",
        "--repository",
        "/Users/luiz.sena88/Projetos"
      ],
      "description": "Integração Git completa"
    },
    "memory": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-memory"
      ],
      "description": "Memória persistente entre sessões"
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ],
      "description": "Raciocínio sequencial avançado"
    },
    "fetch": {
      "command": "uvx",
      "args": [
        "mcp-server-fetch"
      ],
      "description": "Busca e conversão de conteúdo web"
    },
    "time": {
      "command": "uvx",
      "args": [
        "mcp-server-time"
      ],
      "description": "Utilitários de tempo e fusos horários"
    },
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      },
      "description": "Integração GitHub (PRs, Issues, Repos)"
    },
    "brave-search": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-brave-search"
      ],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      },
      "description": "Busca web avançada via Brave Search API"
    },
    "postgres": {
      "command": "uvx",
      "args": [
        "mcp-server-postgres"
      ],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${POSTGRES_CONNECTION_STRING}"
      },
      "description": "Acesso a bancos PostgreSQL"
    },
    "sqlite": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sqlite",
        "/Users/luiz.sena88/Dotfiles/database"
      ],
      "description": "Acesso a bancos SQLite locais"
    },
    "docker": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-docker"
      ],
      "description": "Gerenciamento de containers Docker"
    },
    "kubernetes": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-kubernetes"
      ],
      "env": {
        "KUBECONFIG": "${KUBECONFIG}"
      },
      "description": "Gerenciamento de clusters Kubernetes"
    },
    "aws": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-aws"
      ],
      "env": {
        "AWS_ACCESS_KEY_ID": "${AWS_ACCESS_KEY_ID}",
        "AWS_SECRET_ACCESS_KEY": "${AWS_SECRET_ACCESS_KEY}",
        "AWS_REGION": "${AWS_REGION}"
      },
      "description": "Gerenciamento AWS (EC2, S3, Lambda, etc)"
    },
    "notion": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-notion"
      ],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      },
      "description": "Integração com Notion"
    },
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-slack"
      ],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      },
      "description": "Integração com Slack"
    },
    "python-exec": {
      "command": "uvx",
      "args": [
        "mcp-server-python-sandbox"
      ],
      "description": "Execução segura de código Python"
    },
    "puppeteer": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-puppeteer"
      ],
      "description": "Automação de navegador (scraping, testes)"
    },
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-playwright"
      ],
      "description": "Automação de navegador avançada"
    },
    "obsidian": {
      "command": "node",
      "args": [
        "/Users/luiz.sena88/mcp-obsidian/dist/index.js",
        "/Users/luiz.sena88/VAULT_OBSIDIAN"
      ],
      "description": "Integração com Obsidian Vault"
    },
    "vps-ubuntu-coolify": {
      "transport": "sse",
      "url": "${VPS_MCP_URL}/sse",
      "headers": {
        "Authorization": "Bearer ${VPS_MCP_TOKEN}"
      },
      "description": "Servidor MCP remoto no VPS Ubuntu via Coolify"
    }
  }
}
```

---

## 🐧 Ambiente VPS Ubuntu com Coolify

### Arquitetura no Coolify

```
Coolify Stack
├── mcp-server-http (Porta 3000)
│   ├── Servidores de Banco de Dados
│   ├── Servidores de Cloud
│   └── Servidores Especializados
├── mcp-server-sse (Porta 3001)
│   └── Stream de eventos em tempo real
└── Nginx Reverse Proxy
    ├── SSL/TLS (Let's Encrypt)
    └── Rate Limiting
```

### Configuração do Coolify

#### 1. Criar Aplicação no Coolify

**Nome:** `mcp-server-production`

**Tipo:** Docker Compose

**docker-compose.yml:**

```yaml
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

  redis:
    image: redis:7-alpine
    container_name: mcp-redis
    volumes:
      - redis-data:/data
    networks:
      - mcp-network
    restart: unless-stopped

volumes:
  postgres-data:
  redis-data:

networks:
  mcp-network:
    driver: bridge
```

#### 2. Script de Setup no VPS

**setup-mcp-coolify.sh:**

```bash
#!/bin/bash
set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Setup MCP Server no Coolify${NC}"

# Variáveis
MCP_DIR="/data/coolify/applications/mcp-server-production"
REPO_URL="https://github.com/modelcontextprotocol/servers.git"

# Criar diretório
mkdir -p "$MCP_DIR"
cd "$MCP_DIR"

# Clonar repositório de servidores MCP
if [ ! -d "servers" ]; then
    echo -e "${YELLOW}📦 Clonando repositório MCP...${NC}"
    git clone "$REPO_URL" servers
fi

cd servers/src/everything

# Instalar dependências
echo -e "${YELLOW}📦 Instalando dependências...${NC}"
npm install
npm run build

# Criar estrutura de diretórios
mkdir -p "$MCP_DIR/data" "$MCP_DIR/logs"

# Configurar permissões
chown -R 1000:1000 "$MCP_DIR"

echo -e "${GREEN}✅ Setup concluído!${NC}"
echo -e "${YELLOW}📝 Configure as variáveis de ambiente no Coolify:${NC}"
echo "  - MCP_TOKEN"
echo "  - DATABASE_URL"
echo "  - POSTGRES_PASSWORD"
echo "  - REDIS_URL"
```

#### 3. Servidor MCP HTTP Customizado

**server.js:**

```javascript
const express = require('express');
const cors = require('cors');
const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');

const app = express();
const PORT = process.env.PORT || 3000;
const MCP_TOKEN = process.env.MCP_TOKEN;

// Middleware
app.use(cors());
app.use(express.json());

// Autenticação
const authenticate = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const token = authHeader.substring(7);
  if (token !== MCP_TOKEN) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  next();
};

// Endpoint MCP
app.post('/mcp', authenticate, async (req, res) => {
  try {
    const { method, params } = req.body;

    // Processar requisição MCP
    // Implementar lógica específica aqui

    res.json({
      jsonrpc: '2.0',
      id: req.body.id,
      result: {}
    });
  } catch (error) {
    res.status(500).json({
      jsonrpc: '2.0',
      id: req.body.id,
      error: {
        code: -32603,
        message: error.message
      }
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`🚀 MCP Server HTTP rodando na porta ${PORT}`);
});
```

#### 4. Configuração Nginx no Coolify

**nginx.conf:**

```nginx
server {
    listen 443 ssl http2;
    server_name mcp.seu-dominio.com;

    ssl_certificate /etc/letsencrypt/live/mcp.seu-dominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mcp.seu-dominio.com/privkey.pem;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=mcp_limit:10m rate=10r/s;
    limit_req zone=mcp_limit burst=20 nodelay;

    # MCP HTTP endpoint
    location /mcp {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }

    # SSE endpoint
    location /sse {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_buffering off;
        proxy_read_timeout 24h;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:3000/health;
        access_log off;
    }
}
```

---

## 📦 Servidores MCP por Categoria

### 🔧 Desenvolvimento

| Servidor | Comando | Descrição |
|----------|---------|-----------|
| **filesystem** | `@modelcontextprotocol/server-filesystem` | Acesso seguro a arquivos |
| **git** | `mcp-server-git` | Operações Git completas |
| **github** | `@modelcontextprotocol/server-github` | API GitHub (PRs, Issues) |
| **docker** | `@modelcontextprotocol/server-docker` | Gerenciamento Docker |
| **kubernetes** | `@modelcontextprotocol/server-kubernetes` | Gerenciamento K8s |
| **python-exec** | `mcp-server-python-sandbox` | Execução Python segura |
| **puppeteer** | `@modelcontextprotocol/server-puppeteer` | Automação navegador |
| **playwright** | `@modelcontextprotocol/server-playwright` | Automação avançada |

### 💾 Bancos de Dados

| Servidor | Comando | Variáveis de Ambiente |
|----------|---------|----------------------|
| **postgres** | `mcp-server-postgres` | `POSTGRES_CONNECTION_STRING` |
| **mysql** | `mcp-server-mysql` | `MYSQL_CONNECTION_STRING` |
| **mongodb** | `mcp-server-mongodb` | `MONGODB_URI` |
| **sqlite** | `@modelcontextprotocol/server-sqlite` | Caminho do arquivo |
| **redis** | `mcp-server-redis` | `REDIS_URL` |

### ☁️ Cloud Services

| Servidor | Comando | Variáveis de Ambiente |
|----------|---------|----------------------|
| **aws** | `@modelcontextprotocol/server-aws` | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |
| **azure** | `mcp-server-azure` | `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET` |
| **gcp** | `mcp-server-gcp` | `GOOGLE_APPLICATION_CREDENTIALS` |
| **cloudflare** | `mcp-server-cloudflare` | `CLOUDFLARE_API_TOKEN` |

### 🔍 Busca e Web

| Servidor | Comando | Variáveis de Ambiente |
|----------|---------|----------------------|
| **brave-search** | `@modelcontextprotocol/server-brave-search` | `BRAVE_API_KEY` |
| **fetch** | `mcp-server-fetch` | - |
| **web-search** | `mcp-server-web-search` | `SERPER_API_KEY` |

### 🧠 AI e Memória

| Servidor | Comando | Descrição |
|----------|---------|-----------|
| **memory** | `@modelcontextprotocol/server-memory` | Memória persistente |
| **sequential-thinking** | `@modelcontextprotocol/server-sequential-thinking` | Raciocínio sequencial |
| **time** | `mcp-server-time` | Utilitários de tempo |

### 📝 Produtividade

| Servidor | Comando | Variáveis de Ambiente |
|----------|---------|----------------------|
| **notion** | `@modelcontextprotocol/server-notion` | `NOTION_API_KEY` |
| **slack** | `@modelcontextprotocol/server-slack` | `SLACK_BOT_TOKEN` |
| **obsidian** | Custom | Caminho do vault |
| **gmail** | `mcp-server-gmail` | `GMAIL_CREDENTIALS` |

---

## 🛠️ Scripts de Instalação

### Script Principal: install-mcp-servers.sh

```bash
#!/bin/bash
set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
BACKUP_DIR="$HOME/Dotfiles/claude-cloud-knowledge/06_MCP/configuracoes/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo -e "${BLUE}🚀 Instalação Profissional de Servidores MCP${NC}\n"

# Criar backup
mkdir -p "$BACKUP_DIR"
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_DIR/claude_desktop_config.json.backup.$TIMESTAMP"
    echo -e "${GREEN}✅ Backup criado${NC}"
fi

# Verificar dependências
echo -e "${YELLOW}📦 Verificando dependências...${NC}"
command -v node >/dev/null 2>&1 || { echo -e "${RED}❌ Node.js não encontrado${NC}"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo -e "${RED}❌ Python3 não encontrado${NC}"; exit 1; }
command -v uv >/dev/null 2>&1 || { echo -e "${YELLOW}⚠️  uv não encontrado, instalando...${NC}"; brew install uv; }

# Instalar servidores Node.js
echo -e "${YELLOW}📦 Instalando servidores Node.js...${NC}"
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @modelcontextprotocol/server-docker
npm install -g @modelcontextprotocol/server-kubernetes
npm install -g @modelcontextprotocol/server-aws
npm install -g @modelcontextprotocol/server-notion
npm install -g @modelcontextprotocol/server-slack
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @modelcontextprotocol/server-playwright

# Instalar servidores Python via uvx
echo -e "${YELLOW}📦 Instalando servidores Python...${NC}"
uvx install mcp-server-git
uvx install mcp-server-fetch
uvx install mcp-server-time
uvx install mcp-server-postgres
uvx install mcp-server-mysql
uvx install mcp-server-mongodb
uvx install mcp-server-redis
uvx install mcp-server-python-sandbox

echo -e "${GREEN}✅ Todos os servidores instalados!${NC}"
echo -e "${BLUE}📝 Configure as variáveis de ambiente em ~/.zshrc ou ~/.env.local${NC}"
```

### Script de Verificação: verify-mcp-servers.sh

```bash
#!/bin/bash

CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

echo "🔍 Verificando configuração MCP..."

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Arquivo de configuração não encontrado"
    exit 1
fi

# Verificar JSON válido
if ! python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
    echo "❌ JSON inválido"
    exit 1
fi

# Contar servidores
SERVER_COUNT=$(python3 << EOF
import json
with open("$CONFIG_FILE") as f:
    config = json.load(f)
    servers = config.get('mcpServers', {})
    print(len(servers))
EOF
)

echo "✅ JSON válido"
echo "📊 Servidores configurados: $SERVER_COUNT"

# Listar servidores
python3 << EOF
import json
with open("$CONFIG_FILE") as f:
    config = json.load(f)
    servers = config.get('mcpServers', {})
    print("\n📋 Servidores:")
    for name, config in servers.items():
        desc = config.get('description', 'Sem descrição')
        print(f"  • {name}: {desc}")
EOF
```

---

## 🔒 Segurança e Boas Práticas

### 1. Gerenciamento de Secrets

**Nunca commitar secrets no JSON!**

Use variáveis de ambiente:

```bash
# ~/.zshrc ou ~/.env.local
export GITHUB_TOKEN="ghp_..."
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export POSTGRES_CONNECTION_STRING="postgresql://..."
```

### 2. Controle de Acesso a Arquivos

```json
{
  "filesystem": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-filesystem",
      "/caminho/permitido",
      "--readonly"  // Somente leitura quando apropriado
    ]
  }
}
```

### 3. Autenticação em Servidores Remotos

- Sempre use HTTPS
- Tokens Bearer obrigatórios
- Rate limiting configurado
- Logs de acesso

### 4. Monitoramento

```bash
# Logs do Claude Desktop (macOS)
tail -f ~/Library/Logs/Claude/mcp*.log

# Logs do servidor remoto (VPS)
journalctl -u mcp-server -f
```

---

## 🐛 Troubleshooting Avançado

### Problema: Servidor não inicia

```bash
# Verificar logs
cat ~/Library/Logs/Claude/mcp*.log

# Testar comando manualmente
npx -y @modelcontextprotocol/server-filesystem /tmp

# Verificar permissões
ls -la ~/Library/Application\ Support/Claude/
```

### Problema: Conexão remota falha

```bash
# Testar conectividade
curl -X POST "https://mcp.seu-dominio.com/mcp" \
     -H "Authorization: Bearer $VPS_MCP_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"initialize","id":1}'

# Verificar firewall
sudo ufw status

# Verificar DNS
nslookup mcp.seu-dominio.com
```

### Problema: Variáveis de ambiente não carregadas

```bash
# Verificar se variáveis estão definidas
env | grep -E "(GITHUB|AWS|POSTGRES)"

# Recarregar shell
source ~/.zshrc

# Reiniciar Claude Desktop completamente
killall Claude
open -a Claude
```

---

## 📚 Recursos Adicionais

- **Documentação Oficial MCP**: https://modelcontextprotocol.io
- **Repositório de Servidores**: https://github.com/modelcontextprotocol/servers
- **SDKs Disponíveis**: TypeScript, Python, C#, Go, Java, Kotlin, PHP, Ruby, Rust, Swift
- **Coolify Documentation**: https://coolify.io/docs

---

**Versão**: 2.0 Professional
**Última Atualização**: Janeiro 2025
**Compatível com**: Claude Desktop, Claude Pro, macOS Silicon, Ubuntu 22.04+, Coolify 4.x

