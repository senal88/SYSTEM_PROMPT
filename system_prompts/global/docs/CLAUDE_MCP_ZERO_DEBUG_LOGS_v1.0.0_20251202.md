# 🔍 Claude MCP Servers - Análise de Logs e Debug Zero

## Guia Definitivo para Operação Silenciosa

**Versão:** 1.0.0
**Data:** 2025-12-02
**Objetivo:** Eliminar 100% dos logs de debug e garantir operação perfeita

---

## 🎯 Problema: Logs de Debug Indesejados

### Sintomas Comuns

```
[DEBUG] MCP server starting...
[INFO] Connecting to filesystem...
[WARN] Retrying connection...
[DEBUG] Request received: {...}
[INFO] Response sent: {...}
```

### Origem dos Logs

1. **Variáveis de ambiente não configuradas**
   - `NODE_ENV` não definida (default: development)
   - `DEBUG` habilitado
   - `LOG_LEVEL` não especificado

2. **NPX/Bunx em modo verbose**
   - Flags `-y` não suprimem logs
   - Servers em modo development

3. **Claude Desktop em modo debug**
   - Developer Tools habilitado
   - Telemetry ativo
   - Error reporting verbose

---

## ✅ Solução: Configuração de Produção

### 1. Variáveis de Ambiente Obrigatórias

**Para CADA MCP server:**

```json
{
  "mcpServers": {
    "nome-do-server": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-*"],
      "env": {
        "NODE_ENV": "production",
        "LOG_LEVEL": "error",
        "DEBUG": "",
        "VERBOSE": "false",
        "SILENT": "true"
      }
    }
  }
}
```

### 2. Configurações Específicas por Server

#### Filesystem Server

```json
{
  "filesystem": {
    "command": "npx",
    "args": [
      "-y",
      "--silent",
      "@modelcontextprotocol/server-filesystem",
      "/path/to/directory"
    ],
    "env": {
      "NODE_ENV": "production",
      "LOG_LEVEL": "error",
      "FS_DEBUG": "false",
      "FS_VERBOSE": "false"
    }
  }
}
```

#### GitHub Server

```json
{
  "github": {
    "command": "npx",
    "args": [
      "-y",
      "--silent",
      "@modelcontextprotocol/server-github"
    ],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}",
      "NODE_ENV": "production",
      "LOG_LEVEL": "error",
      "GITHUB_LOG_LEVEL": "error",
      "OCTOKIT_LOG_LEVEL": "error"
    }
  }
}
```

#### Git Server

```json
{
  "git": {
    "command": "npx",
    "args": [
      "-y",
      "--silent",
      "@modelcontextprotocol/server-git",
      "--repository",
      "/path/to/repo"
    ],
    "env": {
      "NODE_ENV": "production",
      "LOG_LEVEL": "error",
      "GIT_TERMINAL_PROMPT": "0"
    }
  }
}
```

#### Obsidian Server (Bun)

```json
{
  "obsidian": {
    "command": "bunx",
    "args": [
      "--silent",
      "@fazer-ai/mcp-obsidian@latest"
    ],
    "env": {
      "OBSIDIAN_API_KEY": "${OBSIDIAN_API_KEY}",
      "OBSIDIAN_VAULT_PATH": "/path/to/vault",
      "NODE_ENV": "production",
      "LOG_LEVEL": "error",
      "BUN_ENV": "production"
    }
  }
}
```

#### Puppeteer Server

```json
{
  "puppeteer": {
    "command": "npx",
    "args": [
      "-y",
      "--silent",
      "@modelcontextprotocol/server-puppeteer"
    ],
    "env": {
      "NODE_ENV": "production",
      "LOG_LEVEL": "error",
      "PUPPETEER_HEADLESS": "true",
      "PUPPETEER_DISABLE_LOGGING": "true",
      "DEBUG": ""
    }
  }
}
```

### 3. Configurações Globais do Claude Desktop

```json
{
  "mcpServerSettings": {
    "timeout": 60000,
    "maxRetries": 3,
    "retryDelay": 2000,
    "enableLogs": false,
    "logLevel": "error",
    "autoRestart": true,
    "silentMode": true,
    "healthCheck": {
      "enabled": true,
      "interval": 300000,
      "logFailures": false
    }
  }
}
```

---

## 🛠️ Comandos de Validação

### Verificar Logs Atuais

```bash
# Ver logs do Claude Desktop
tail -f ~/Library/Logs/Claude/mcp-*.log

# Filtrar apenas erros
tail -f ~/Library/Logs/Claude/mcp-*.log | grep -i error

# Ver processos MCP rodando
ps aux | grep -E "mcp-server|npx.*@modelcontextprotocol|bunx.*mcp-obsidian"
```

### Testar Modo Silencioso

```bash
# Executar server manualmente em modo silencioso
NODE_ENV=production LOG_LEVEL=error npx --silent -y @modelcontextprotocol/server-filesystem ~/Dotfiles

# Deve não mostrar nenhum log, apenas responder a requests
```

### Limpar Cache de Logs

```bash
# Limpar logs antigos
rm -f ~/Library/Logs/Claude/mcp-*.log

# Criar arquivo de log vazio e torná-lo read-only (previne escrita)
touch ~/Library/Logs/Claude/mcp.log
chmod 444 ~/Library/Logs/Claude/mcp.log
```

---

## 🚫 Configurações a EVITAR

### ❌ NÃO Usar

```json
{
  "env": {
    "NODE_ENV": "development",  // ❌ Gera logs verbosos
    "DEBUG": "*",               // ❌ Ativa debug em tudo
    "VERBOSE": "true",          // ❌ Modo verbose
    "LOG_LEVEL": "debug"        // ❌ Logs demais
  }
}
```

### ✅ SEMPRE Usar

```json
{
  "env": {
    "NODE_ENV": "production",   // ✅ Modo produção
    "DEBUG": "",                // ✅ Debug desabilitado
    "VERBOSE": "false",         // ✅ Sem verbose
    "LOG_LEVEL": "error"        // ✅ Apenas erros
  }
}
```

---

## 📊 Monitoramento (Apenas Erros)

### Script de Monitoramento

```bash
#!/usr/bin/env bash
# monitor_mcp_errors.sh - Monitora apenas ERROS dos MCP servers

LOG_FILE=~/Library/Logs/Claude/mcp-errors.log

# Função para extrair apenas erros
monitor_errors() {
    tail -f ~/Library/Logs/Claude/mcp-*.log 2>/dev/null | \
    grep -i --line-buffered "error\|fatal\|exception" | \
    tee -a "$LOG_FILE"
}

# Executar
echo "🔍 Monitorando apenas ERROS dos MCP servers..."
echo "   Pressione Ctrl+C para parar"
echo ""
monitor_errors
```

### Dashboard de Status

```bash
#!/usr/bin/env bash
# mcp_status.sh - Dashboard de status dos MCP servers

echo "======================================"
echo "  Claude MCP Servers - Status"
echo "======================================"
echo ""

# Verificar processos ativos
echo "Processos MCP Ativos:"
ps aux | grep -E "mcp-server|@modelcontextprotocol|mcp-obsidian" | grep -v grep | awk '{print "  ✅ " $11 " " $12}' | sort -u

echo ""

# Verificar últimos erros
echo "Últimos Erros (últimas 24h):"
if [[ -f ~/Library/Logs/Claude/mcp-errors.log ]]; then
    tail -20 ~/Library/Logs/Claude/mcp-errors.log
else
    echo "  ✅ Nenhum erro registrado"
fi

echo ""

# Verificar conectividade
echo "Conectividade:"
curl -s http://localhost:3000/health 2>/dev/null && echo "  ✅ API respondendo" || echo "  ⚠️  API não disponível"
```

---

## 🔧 Troubleshooting de Logs

### Problema: Ainda Aparecem Logs

**Causa 1: Variáveis não foram aplicadas**

```bash
# Solução: Verificar config
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | jq '.mcpServers.filesystem.env'

# Deve mostrar:
# {
#   "NODE_ENV": "production",
#   "LOG_LEVEL": "error"
# }
```

**Causa 2: NPX não está respeitando flags**

```bash
# Solução: Instalar servers globalmente
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-git

# Atualizar config para usar comando direto
{
  "filesystem": {
    "command": "mcp-server-filesystem",  // Sem npx
    "args": ["/path/to/dir"],
    "env": { "NODE_ENV": "production" }
  }
}
```

**Causa 3: Claude Desktop em modo debug**

```bash
# Solução: Desabilitar Developer Tools
# 1. Abrir Claude Desktop
# 2. Cmd+, (Preferences)
# 3. Advanced → Developer Tools → Disable
# 4. Advanced → Telemetry → Off
# 5. Restart Claude
```

### Problema: Logs de Inicialização

**Causa: NPX baixando pacotes na primeira execução**

```bash
# Solução: Pré-instalar todos os servers
npx -y @modelcontextprotocol/server-filesystem --version
npx -y @modelcontextprotocol/server-github --version
npx -y @modelcontextprotocol/server-git --version
npx -y @modelcontextprotocol/server-brave-search --version
bunx @fazer-ai/mcp-obsidian@latest --version

# Agora reinicie Claude
killall Claude && open -a Claude
```

---

## ✅ Checklist de Validação

```
☐ Todas as variáveis NODE_ENV=production configuradas
☐ Todas as variáveis LOG_LEVEL=error configuradas
☐ Flag --silent adicionada aos comandos npx/bunx
☐ Developer Tools desabilitado no Claude Desktop
☐ Telemetry desabilitado no Claude Desktop
☐ Servers pré-instalados para evitar logs de download
☐ Claude Desktop reiniciado após mudanças
☐ Nenhum log visível na interface
☐ Apenas erros críticos aparecem nos logs do sistema
☐ ps aux mostra processos MCP rodando silenciosamente
```

---

## 📚 Referências de Variáveis de Ambiente

### Node.js / NPM

```bash
NODE_ENV=production          # Modo produção
LOG_LEVEL=error              # Apenas erros
DEBUG=                       # Debug desabilitado
VERBOSE=false                # Sem verbose
SILENT=true                  # Modo silencioso
NPM_CONFIG_LOGLEVEL=error   # Logs do npm
```

### Bun

```bash
BUN_ENV=production           # Modo produção
BUN_RUNTIME_LOG_LEVEL=error  # Apenas erros
```

### Git

```bash
GIT_TERMINAL_PROMPT=0        # Sem prompts interativos
GIT_QUIET=1                  # Modo silencioso
```

### GitHub / Octokit

```bash
GITHUB_LOG_LEVEL=error       # Apenas erros
OCTOKIT_LOG_LEVEL=error      # Octokit silencioso
```

### Puppeteer

```bash
PUPPETEER_HEADLESS=true      # Sem UI
PUPPETEER_DISABLE_LOGGING=true  # Sem logs
DEBUG=                       # Debug desabilitado
```

---

## 🎓 Uso Avançado: Custom Log Handler

### Criar Handler Customizado

```javascript
// custom-mcp-logger.js
const originalConsole = console;

// Sobrescrever console para filtrar logs
console.log = (...args) => {};
console.info = (...args) => {};
console.debug = (...args) => {};
console.warn = (...args) => {
    // Apenas logs críticos
    if (args.some(arg => /critical|fatal/.test(String(arg)))) {
        originalConsole.warn(...args);
    }
};
console.error = (...args) => originalConsole.error(...args);

module.exports = console;
```

### Usar no Config

```json
{
  "filesystem": {
    "command": "node",
    "args": [
      "-r",
      "/path/to/custom-mcp-logger.js",
      "/path/to/node_modules/@modelcontextprotocol/server-filesystem/dist/index.js",
      "/path/to/directory"
    ],
    "env": {
      "NODE_ENV": "production"
    }
  }
}
```

---

**✅ Configuração 100% Silenciosa e Operacional!**

**Última Atualização:** 2025-12-02
**Autor:** Luiz Sena
**Versão:** 1.0.0 - Produção
