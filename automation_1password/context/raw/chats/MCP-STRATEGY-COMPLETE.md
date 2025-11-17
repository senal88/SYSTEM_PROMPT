# 🎯 Estratégia MCP Servers - Curadoria Profunda & Implementação
## macOS Silicon (DEV) + VPS Ubuntu (PROD) + 1Password + Traefik + AI/LLM

**Data:** 29 de Outubro de 2025  
**Versão:** 2.0.0  
**Base:** INDEX.md + PLANO_ACAO_COMPLETO.md + Pesquisa Web 2025

---

## 📊 Matriz de Priorização MCP Servers

### 🔴 **Críticos (Implementar Primeiro)**

| Server | Repo/Source | Propósito | Integração 1Password |
|--------|-------------|-----------|----------------------|
| **filesystem** | `modelcontextprotocol/servers` | Leitura estrutura repo, Context Engineering | Paths via `OP_ALLOWED_DIRS` |
| **huggingface** | `huggingface.co/mcp` | Busca modelos/datasets/spaces | Token via `op://1p_macos/huggingface/token` |
| **github** | `modelcontextprotocol/servers` | Issues/PRs/CodeSearch | PAT via `op://1p_macos/github/pat` |
| **git** | `modelcontextprotocol/servers` | Git ops locais | SSH key via 1Password SSH Agent |

### 🟡 **Importantes (Segunda Fase)**

| Server | Repo/Source | Propósito | Integração 1Password |
|--------|-------------|-----------|----------------------|
| **cloudflare** | Community | DNS/ACME/TLS/rotas | API Token via `op://1p_vps/cloudflare/api_token` |
| **docker** | Community | Logs/status containers | Docker context via SSH |
| **postgres** | `modelcontextprotocol/servers` | Query dados/telemetria | Connection string via 1Password |
| **slack** | Community | Busca threads/decisões | Bot token via 1Password |

### 🟢 **Úteis (Terceira Fase)**

| Server | Repo/Source | Propósito | Integração 1Password |
|--------|-------------|-----------|----------------------|
| **notion** | Community | Knowledge base/runbooks | Integration token via 1Password |
| **gcp** | Community | GCS/BigQuery (se usar) | Service Account JSON via 1Password |
| **memory** | `modelcontextprotocol/servers` | Knowledge graph persistente | - |
| **time** | `modelcontextprotocol/servers` | Timezone/scheduling | - |

---

## 🏗️ Arquitetura de Implementação

### Estrutura no Repositório

```
automation_1password/
├── mcp/
│   ├── config/
│   │   ├── macos.mcp.json         # Config Cursor IDE
│   │   ├── claude.mcp.json        # Config Claude Desktop
│   │   └── vscode.mcp.json        # Config VSCode
│   │
│   ├── servers/                   # Wrappers locais
│   │   ├── filesystem.sh
│   │   ├── huggingface.sh
│   │   ├── github.sh
│   │   ├── cloudflare.sh
│   │   └── docker.sh
│   │
│   ├── secrets/
│   │   ├── mcp.secrets.env.op     # Template 1Password
│   │   └── load-mcp-secrets.sh    # Loader seguro
│   │
│   └── docker-compose/            # Stack MCP como sidecars
│       ├── docker-compose.mcp.yml
│       └── configs/
```

---

## 🔐 Template de Secrets 1Password

### `mcp/secrets/mcp.secrets.env.op`

```bash
# === MCP Servers - 1Password Template ===
# Materializar: op inject -i mcp/secrets/mcp.secrets.env.op -o mcp/secrets/.mcp.secrets.env

# GitHub
MCP_GITHUB_TOKEN={{op://1p_macos/github/pat}}
MCP_GITHUB_REPO_BASE={{op://1p_macos/github/default_repo}}

# Hugging Face
MCP_HF_TOKEN={{op://1p_macos/huggingface/token}}
MCP_HF_USERNAME={{op://1p_macos/huggingface/username}}

# Cloudflare (VPS)
MCP_CF_API_TOKEN={{op://1p_vps/cloudflare/api_token}}
MCP_CF_ACCOUNT_ID={{op://1p_vps/cloudflare/account_id}}
MCP_CF_ZONE_ID={{op://1p_vps/cloudflare/zone_id}}

# Slack (se usar)
MCP_SLACK_BOT_TOKEN={{op://1p_macos/slack/bot_token}}
MCP_SLACK_WORKSPACE={{op://1p_macos/slack/workspace_id}}

# Notion (se usar)
MCP_NOTION_TOKEN={{op://1p_macos/notion/integration_token}}
MCP_NOTION_DATABASE_ID={{op://1p_macos/notion/main_database_id}}

# Database (VPS)
MCP_POSTGRES_URL={{op://1p_vps/postgres/connection_url}}
MCP_REDIS_URL={{op://1p_vps/redis/connection_url}}

# 1Password Connect (custom MCP)
MCP_OP_CONNECT_URL={{op://1p_vps/op_connect/url}}
MCP_OP_CONNECT_TOKEN={{op://1p_vps/op_connect/token}}

# Docker/SSH para VPS
MCP_SSH_HOST={{op://1p_vps/ssh/hostname}}
MCP_SSH_USER={{op://1p_vps/ssh/username}}
MCP_SSH_KEY_PATH={{op://1p_vps/ssh/private_key_path}}

# Filesystem Paths (allowlist)
MCP_FS_ALLOWED_PATHS="/Users/luiz.sena88/Dotfiles/automation_1password,/Users/luiz.sena88/dev-prod"
MCP_FS_DENY_PATHS="connect/data/**,tokens/**,**/*.sqlite,**/*.opvault,**/.ssh/**"
```

---

## 🚀 Configurações por IDE

### Cursor IDE - `.cursor/mcp.json`

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "bash",
      "args": ["${workspaceRoot}/mcp/servers/filesystem.sh"],
      "env": {
        "FS_ALLOWED": "${env:MCP_FS_ALLOWED_PATHS}",
        "FS_DENY": "${env:MCP_FS_DENY_PATHS}",
        "FS_MAX_DEPTH": "6",
        "FS_MAX_FILES": "5000"
      }
    },
    "huggingface": {
      "command": "bash",
      "args": ["${workspaceRoot}/mcp/servers/huggingface.sh"],
      "env": {
        "HF_TOKEN": "${env:MCP_HF_TOKEN}",
        "HF_USERNAME": "${env:MCP_HF_USERNAME}"
      }
    },
    "github": {
      "command": "bash",
      "args": ["${workspaceRoot}/mcp/servers/github.sh"],
      "env": {
        "GITHUB_TOKEN": "${env:MCP_GITHUB_TOKEN}",
        "GITHUB_REPO": "${env:MCP_GITHUB_REPO_BASE}"
      }
    },
    "cloudflare": {
      "command": "bash",
      "args": ["${workspaceRoot}/mcp/servers/cloudflare.sh"],
      "env": {
        "CF_API_TOKEN": "${env:MCP_CF_API_TOKEN}",
        "CF_ACCOUNT_ID": "${env:MCP_CF_ACCOUNT_ID}",
        "CF_ZONE_ID": "${env:MCP_CF_ZONE_ID}"
      }
    },
    "docker": {
      "command": "bash",
      "args": ["${workspaceRoot}/mcp/servers/docker.sh"],
      "env": {
        "DOCKER_HOST": "ssh://${env:MCP_SSH_USER}@${env:MCP_SSH_HOST}",
        "SSH_KEY_PATH": "${env:MCP_SSH_KEY_PATH}"
      }
    }
  }
}
```

### Claude Desktop - `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "/Users/luiz.sena88/Dotfiles/automation_1password/mcp/servers/filesystem.sh",
      "args": [],
      "env": {
        "FS_ALLOWED": "/Users/luiz.sena88/Dotfiles/automation_1password,/Users/luiz.sena88/dev-prod",
        "FS_DENY": "connect/data/**,tokens/**,**/*.sqlite,**/*.opvault,**/.ssh/**"
      }
    },
    "huggingface": {
      "command": "/Users/luiz.sena88/Dotfiles/automation_1password/mcp/servers/huggingface.sh",
      "args": [],
      "env": {
        "HF_TOKEN": "${env:MCP_HF_TOKEN}"
      }
    },
    "github": {
      "command": "/Users/luiz.sena88/Dotfiles/automation_1password/mcp/servers/github.sh", 
      "args": [],
      "env": {
        "GITHUB_TOKEN": "${env:MCP_GITHUB_TOKEN}"
      }
    }
  }
}
```

---

## 🛠️ Scripts de Wrapper (Seguros)

### `mcp/servers/filesystem.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Carregar secrets se necessário
if [[ -z "${FS_ALLOWED:-}" ]]; then
    source "$(dirname "$0")/../secrets/load-mcp-secrets.sh"
fi

# Verificar se MCP filesystem server está instalado
if ! command -v mcp-filesystem-server >/dev/null 2>&1; then
    echo "❌ MCP filesystem server não instalado" >&2
    echo "💡 Instale com: npm install -g @modelcontextprotocol/server-filesystem" >&2
    exit 1
fi

# Executar com configurações seguras
exec mcp-filesystem-server \
    --allowed-paths "${FS_ALLOWED:-$HOME/Dotfiles/automation_1password}" \
    --denied-patterns "${FS_DENY:-**/*.sqlite,**/.ssh/**}" \
    --max-depth "${FS_MAX_DEPTH:-6}" \
    --max-files "${FS_MAX_FILES:-5000}" \
    --read-only="${FS_READ_ONLY:-false}"
```

### `mcp/servers/huggingface.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Verificar token
if [[ -z "${HF_TOKEN:-}" ]]; then
    source "$(dirname "$0")/../secrets/load-mcp-secrets.sh"
fi

[[ -n "${HF_TOKEN:-}" ]] || {
    echo "❌ HF_TOKEN não configurado" >&2
    exit 1
}

# Usar servidor oficial Hugging Face MCP
if command -v hf-mcp-server >/dev/null 2>&1; then
    exec hf-mcp-server --token "$HF_TOKEN"
else
    # Usar via HTTP (servidor remoto oficial)
    echo "🌐 Usando Hugging Face MCP Server remoto" >&2
    exec curl -X POST https://huggingface.co/mcp \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json" \
        --data @-
fi
```

### `mcp/servers/github.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Verificar token
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    source "$(dirname "$0")/../secrets/load-mcp-secrets.sh"
fi

[[ -n "${GITHUB_TOKEN:-}" ]] || {
    echo "❌ GITHUB_TOKEN não configurado" >&2
    exit 1
}

# Verificar se servidor está instalado
if ! command -v mcp-github-server >/dev/null 2>&1; then
    echo "❌ MCP GitHub server não instalado" >&2
    echo "💡 Instale com: npm install -g @modelcontextprotocol/server-github" >&2
    exit 1
fi

exec mcp-github-server \
    --token "$GITHUB_TOKEN" \
    --default-repo "${GITHUB_REPO:-automation_1password}"
```

### `mcp/servers/cloudflare.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Verificar tokens
if [[ -z "${CF_API_TOKEN:-}" ]]; then
    source "$(dirname "$0")/../secrets/load-mcp-secrets.sh"
fi

[[ -n "${CF_API_TOKEN:-}" ]] || {
    echo "❌ CF_API_TOKEN não configurado" >&2
    exit 1
}

# Servidor Cloudflare MCP (community)
if ! command -v mcp-cloudflare-server >/dev/null 2>&1; then
    echo "❌ MCP Cloudflare server não instalado" >&2
    echo "💡 Instale com: npm install -g mcp-cloudflare-server" >&2
    exit 1
fi

exec mcp-cloudflare-server \
    --api-token "$CF_API_TOKEN" \
    --account-id "${CF_ACCOUNT_ID:-}" \
    --zone-id "${CF_ZONE_ID:-}"
```

### `mcp/servers/docker.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Verificar se Docker está disponível (local ou remoto)
if [[ -n "${DOCKER_HOST:-}" ]]; then
    # Docker remoto via SSH
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${DOCKER_HOST#ssh://}" "docker version" >/dev/null 2>&1; then
        echo "❌ Docker remoto não acessível: $DOCKER_HOST" >&2
        exit 1
    fi
else
    # Docker local
    if ! docker version >/dev/null 2>&1; then
        echo "❌ Docker local não disponível" >&2
        exit 1
    fi
fi

# Usar MCP Docker server (community)
if ! command -v mcp-docker-server >/dev/null 2>&1; then
    echo "❌ MCP Docker server não instalado" >&2
    echo "💡 Instale com: npm install -g mcp-docker-server" >&2
    exit 1
fi

exec mcp-docker-server \
    --docker-host "${DOCKER_HOST:-unix:///var/run/docker.sock}" \
    --allowed-commands "ps,logs,inspect,stats"
```

---

## 🔄 Loader de Secrets

### `mcp/secrets/load-mcp-secrets.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MODE="${1:-macos}"
TEMPLATE="$REPO_ROOT/mcp/secrets/mcp.secrets.env.op"
TEMP_FILE="$(mktemp)"

# Verificar 1Password CLI
command -v op >/dev/null || {
    echo "❌ 1Password CLI não encontrado" >&2
    exit 1
}

# Autenticar se necessário
if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
    if ! op whoami >/dev/null 2>&1; then
        echo "🔐 Autenticando 1Password..." >&2
        eval "$(op signin)"
    fi
fi

# Materializar secrets
echo "🔑 Carregando MCP secrets do 1Password..." >&2
op inject -i "$TEMPLATE" -o "$TEMP_FILE" >/dev/null

# Carregar no environment atual
set -a
source "$TEMP_FILE"
set +a

# Limpar arquivo temporário
shred -u "$TEMP_FILE" 2>/dev/null || rm -f "$TEMP_FILE"

echo "✅ MCP secrets carregados para [$MODE]" >&2
```

---

## 🐳 Docker Compose para MCP Sidecars

### `mcp/docker-compose/docker-compose.mcp.yml`

```yaml
version: '3.8'

services:
  # MCP Filesystem Server
  mcp-filesystem:
    image: gabrielmaialva33/mcp-filesystem:latest
    platform: linux/arm64
    volumes:
      - ${REPO_ROOT}:/workspace:ro
      - /Users/luiz.sena88/dev-prod:/dev-prod:ro
    environment:
      - FS_ALLOWED=/workspace,/dev-prod
      - FS_DENY=connect/data/**,tokens/**,**/*.sqlite
      - FS_MAX_DEPTH=6
    ports:
      - "8001:8000"
    restart: unless-stopped
    
  # MCP GitHub Server (se disponível como container)
  mcp-github:
    image: mcp-github-server:latest
    platform: linux/arm64
    environment:
      - GITHUB_TOKEN=${MCP_GITHUB_TOKEN}
      - GITHUB_REPO=${MCP_GITHUB_REPO_BASE}
    ports:
      - "8002:8000"
    restart: unless-stopped
    
  # MCP Cloudflare Server (custom)
  mcp-cloudflare:
    image: mcp-cloudflare-server:latest
    platform: linux/arm64
    environment:
      - CF_API_TOKEN=${MCP_CF_API_TOKEN}
      - CF_ACCOUNT_ID=${MCP_CF_ACCOUNT_ID}
      - CF_ZONE_ID=${MCP_CF_ZONE_ID}
    ports:
      - "8003:8000"
    restart: unless-stopped

networks:
  default:
    name: mcp_network
    external: false
```

---

## 📋 Workflow de Implantação

### Passo 1: Estrutura Inicial

```bash
cd ~/Dotfiles/automation_1password

# Criar estrutura MCP
mkdir -p mcp/{config,servers,secrets,docker-compose/configs}

# Copiar templates dos arquivos criados acima
```

### Passo 2: Instalar Servidores MCP

```bash
# Instalar servidores oficiais
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-time

# Instalar Hugging Face MCP (oficial)
# Já disponível via https://huggingface.co/mcp

# Instalar servidores community (conforme disponibilidade)
npm install -g mcp-cloudflare-server  # Se existir
npm install -g mcp-docker-server      # Se existir
```

### Passo 3: Configurar Secrets

```bash
# Adicionar secrets ao 1Password (exemplo GitHub)
op item create \
  --vault="1p_macos" \
  --category=api-credential \
  --title="github" \
  pat="ghp_xxxxxxxxxxxx"

# Materializar secrets
source mcp/secrets/load-mcp-secrets.sh macos
```

### Passo 4: Testar MCP Servers

```bash
# Testar filesystem
echo '{"method": "list_directory", "params": {"path": "."}}' | bash mcp/servers/filesystem.sh

# Testar Hugging Face
echo '{"method": "search_models", "params": {"query": "llama"}}' | bash mcp/servers/huggingface.sh
```

### Passo 5: Configurar IDEs

```bash
# Cursor
cp mcp/config/macos.mcp.json .cursor/mcp.json

# Claude Desktop
cp mcp/config/claude.mcp.json ~/Library/Application\ Support/Claude/claude_desktop_config.json

# VSCode
cp mcp/config/vscode.mcp.json .vscode/mcp.json
```

---

## 🎯 Casos de Uso Específicos

### Context Engineering com Filesystem MCP

```markdown
**Prompt:** "Analise a estrutura do projeto automation_1password e gere um contexto resumido para IA"

**Resultado:** O filesystem MCP lerá automaticamente:
- README.md, INDEX.md, PLANO_ACAO_COMPLETO.md
- Scripts em scripts/
- Configurações em env/
- Documentação em docs/
- Gerará contexto estruturado
```

### Integração Hugging Face para Modelos

```markdown
**Prompt:** "Encontre modelos LLM otimizados para code generation com licença MIT"

**Resultado:** Hugging Face MCP buscará:
- Filtros: task=text-generation, license=mit
- Ordenação por downloads/likes
- Metadata dos modelos
- Links para model cards
```

### Gestão DNS via Cloudflare MCP

```markdown
**Prompt:** "Listar todos os registros DNS de senamfo.com.br e verificar se connect.senamfo.com.br aponta para o IP correto"

**Resultado:** Cloudflare MCP:
- Lista registros da zona
- Verifica apontamentos
- Sugere correções se necessário
```

### Monitoramento Docker via MCP

```markdown
**Prompt:** "Verificar status dos containers 1Password Connect no VPS e mostrar logs dos últimos 10 minutos"

**Resultado:** Docker MCP (remoto):
- `docker ps --filter name=1password`
- `docker logs --since=10m container_name`
- Status de health checks
```

---

## 🔒 Governança e Segurança

### Princípios de Segurança

1. **Secrets Zero-Disk:** Todos os tokens via 1Password, materialização temporária
2. **Path Allowlist:** Filesystem MCP limitado a diretórios específicos
3. **Least Privilege:** Cada MCP server com permissões mínimas necessárias
4. **Audit Trail:** Logs de todas as operações MCP
5. **Rate Limiting:** Limites por servidor para evitar abuse

### Validação Contínua

```bash
# Script de validação MCP
#!/usr/bin/env bash
# mcp/scripts/validate-mcp-security.sh

# Verificar se secrets não estão em disco
find . -name "*.secrets.env" -not -path "*/templates/*" && exit 1

# Verificar permissões dos wrappers
find mcp/servers -name "*.sh" -not -perm 755 && exit 1

# Testar conectividade de cada servidor
for server in mcp/servers/*.sh; do
    timeout 10s bash "$server" --health-check || echo "FAIL: $server"
done
```

---

## 📈 Métricas de Sucesso

| Métrica | Meta | Medição |
|---------|------|---------|
| **MCP Servers Funcionais** | 5+ | Health checks passando |
| **Context Pack Size** | <100MB | Filesystem MCP indexing |
| **Hugging Face Search** | <2s response | Tempo de resposta API |
| **GitHub Integration** | 100% repos | Acesso total via MCP |
| **Security Compliance** | 0 secrets em disco | Audit script |
| **IDE Integration** | 3 IDEs (Cursor/Claude/VSCode) | Configs funcionais |

---

## 🚀 Próximos Passos

### Fase 1: Core MCP Servers (Esta Semana)
- [ ] Instalar filesystem, huggingface, github, memory
- [ ] Configurar secrets templates 1Password
- [ ] Testar integração com Cursor IDE
- [ ] Validar security policies

### Fase 2: Cloud & Infrastructure (Próximas 2 Semanas)
- [ ] Implementar cloudflare, docker MCP servers
- [ ] Configurar postgres MCP para telemetria
- [ ] Integrar com monitoring stack
- [ ] Setup VPS remote MCP access

### Fase 3: Advanced Features (Próximo Mês)
- [ ] Custom 1Password Connect MCP server
- [ ] RAG integration com memory MCP
- [ ] Slack/Notion integration para knowledge base
- [ ] CI/CD pipeline com MCP servers

---

**Status:** ✅ **Pronto para Implementação**  
**Próximo Comando:** `bash mcp/scripts/bootstrap-mcp-stack.sh`

🎯 **Esta estratégia fornece uma base sólida para Context Engineering avançado com MCP Servers, integração segura com 1Password e máxima produtividade em ambiente híbrido.**