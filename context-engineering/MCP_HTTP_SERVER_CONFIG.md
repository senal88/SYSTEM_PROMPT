# Configuração de Servidores MCP HTTP

## 📋 Visão Geral

Esta documentação descreve como configurar servidores MCP (Model Context Protocol) via HTTP no Claude Desktop e Claude Code.

## 🔧 Configuração no Claude Desktop

### Localização do Arquivo de Configuração

**macOS:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:**
```
%AppData%\Claude\claude_desktop_config.json
```

### Estrutura de Configuração para Servidor HTTP

```json
{
  "mcpServers": {
    "my-server": {
      "type": "http",
      "url": "https://example.com/mcp",
      "headers": {
        "Authorization": "Bearer token",
        "X-API-Key": "key"
      }
    }
  }
}
```

### Exemplo Completo

```json
{
  "preferences": {
    "quickEntryShortcut": "double-tap-option"
  },
  "mcpServers": {
    "my-server": {
      "type": "http",
      "url": "https://example.com/mcp",
      "headers": {
        "Authorization": "Bearer token",
        "X-API-Key": "key"
      }
    },
    "task-master-ai": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "task-master-ai"]
    }
  }
}
```

## 🚀 Script de Configuração Automática

### Script para Adicionar Servidor MCP HTTP

O script `add-mcp-server.sh` está disponível em `scripts/add-mcp-server.sh`.

**Uso:**
```bash
cd ~/Dotfiles/context-engineering
./scripts/add-mcp-server.sh <nome-servidor> <url> [bearer-token] [api-key]
```

**Exemplos:**
```bash
# Servidor simples
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp"

# Com token Bearer
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer token123"

# Com token Bearer e API Key
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer token123" "api-key-456"

# Usando tokens do 1Password
TOKEN=$(op item get "mcp-token" --vault "1p_macos" --fields "credential" --reveal)
KEY=$(op item get "mcp-api-key" --vault "1p_macos" --fields "credential" --reveal)
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer $TOKEN" "$KEY"
```

## 🔐 Segurança

### Usar 1Password para Secrets

```bash
# Obter headers do 1Password
AUTH_TOKEN=$(op item get "mcp-auth-token" --vault "1p_macos" --fields "credential" --reveal)
API_KEY=$(op item get "mcp-api-key" --vault "1p_macos" --fields "credential" --reveal)

# Configurar servidor
./add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer $AUTH_TOKEN" "$API_KEY"
```

### Headers Sensíveis

⚠️ **Nunca commitar** arquivos de configuração com secrets hardcoded.

Use sempre 1Password ou variáveis de ambiente.

## 🛠️ Configuração Manual

### Passo a Passo

1. **Localizar arquivo de configuração:**
   ```bash
   # macOS
   open "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
   ```

2. **Adicionar servidor MCP:**
   ```json
   {
     "mcpServers": {
       "my-server": {
         "type": "http",
         "url": "https://example.com/mcp",
         "headers": {
           "Authorization": "Bearer token",
           "X-API-Key": "key"
         }
       }
     }
   }
   ```

3. **Reiniciar Claude Desktop** para aplicar mudanças

## 🔍 Verificar Configuração

### Listar Servidores Configurados

```bash
# Ver configuração atual
cat "$HOME/Library/Application Support/Claude/claude_desktop_config.json" | jq '.mcpServers'

# Ou usar Python
python3 << EOF
import json
import os

config_file = os.path.expanduser("~/Library/Application Support/Claude/claude_desktop_config.json")
if os.path.exists(config_file):
    with open(config_file) as f:
        config = json.load(f)
        print(json.dumps(config.get('mcpServers', {}), indent=2))
EOF
```

### Testar Conexão

```bash
# Testar URL do servidor MCP
curl -X POST "https://example.com/mcp" \
     -H "Authorization: Bearer token" \
     -H "X-API-Key: key" \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc": "2.0", "method": "initialize", "id": 1}'
```

## 📚 Referências

- [MCP Complete Guide](../claude-cloud-knowledge/06_MCP/MCP_COMPLETE_GUIDE.md)
- [MCP Specification](https://modelcontextprotocol.io/specification)
- [Claude Desktop Config](https://docs.anthropic.com/claude/docs/claude-desktop)

---

**Última atualização**: 2025-01-15
**Formato**: JSON
**Aplicação**: Claude Desktop

