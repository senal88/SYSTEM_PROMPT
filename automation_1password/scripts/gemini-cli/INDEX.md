# Gemini CLI - Índice de Arquivos

Este diretório contém todos os scripts e documentação relacionados ao Gemini CLI.

## 📁 Estrutura

```
scripts/gemini-cli/
├── install-gemini-cli.sh          # Instalação do Gemini CLI
├── validate-gemini-cli.sh         # Validação da instalação
├── install-mcp-extensions.sh      # ⭐ Instalação inteligente de extensões MCP
├── README.md                      # Documentação dos scripts
└── INDEX.md                       # Este arquivo

docs/gemini-cli/
├── README.md                      # Guia completo do Gemini CLI
├── QUICK_START.md                 # Início rápido
├── EXTENSIONS.md                  # ⭐ Guia completo de extensões MCP
└── RESUMO_EXECUTIVO.md            # ⭐ Resumo executivo
```

## 🚀 Fluxo de Instalação Recomendado

### 1. Instalação Base

```bash
./install-gemini-cli.sh
```

**O que faz:**
- Verifica pré-requisitos (Node.js, npm, 1Password CLI)
- Instala o Gemini CLI globalmente
- Configura autenticação via 1Password
- Cria arquivo de configuração básico

### 2. Instalação de Extensões MCP

```bash
./install-mcp-extensions.sh --essential
```

**O que faz:**
- Instala extensões essenciais (GitHub, Chrome DevTools, Database Toolbox)
- Respeita limites de performance (máx. 8 servidores)
- Configura autenticação via 1Password
- Gera relatório de instalação

### 3. Validação

```bash
./validate-gemini-cli.sh
```

**O que faz:**
- Verifica instalação do Gemini CLI
- Valida configuração da API key
- Testa autenticação
- Lista ferramentas disponíveis

## 📚 Documentação

### Guias

- **[README.md](../../docs/gemini-cli/README.md)** - Guia completo e detalhado
- **[QUICK_START.md](../../docs/gemini-cli/QUICK_START.md)** - Início rápido (5 minutos)
- **[EXTENSIONS.md](../../docs/gemini-cli/EXTENSIONS.md)** - Guia completo de extensões MCP
- **[RESUMO_EXECUTIVO.md](../../docs/gemini-cli/RESUMO_EXECUTIVO.md)** - Resumo executivo

### Documentação dos Scripts

- **[README.md](README.md)** - Documentação dos scripts neste diretório

## 🔌 Extensões MCP Instaláveis

### Essenciais (3)

1. **GitHub MCP Server** - 24,220+ downloads
2. **Chrome DevTools MCP** - 13,822+ downloads
3. **Database Toolbox** - 11,279+ downloads

### Altamente Recomendadas (5)

4. **Context7** - 36,095+ downloads
5. **Terraform MCP** - 1,035+ downloads
6. **Grafana MCP** - 1,791+ downloads
7. **MongoDB MCP** - 790+ downloads
8. **Neo4j MCP** - 790+ downloads (se necessário)

## ⚙️ Configuração

### Variáveis de Ambiente (via 1Password)

```bash
# Gemini API Key
GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key")

# GitHub Token
GITHUB_TOKEN=$(op read "op://shared_infra/github/cli_token")

# MongoDB
MONGODB_URI=$(op read "op://macos_silicon_workspace/mongodb/connection_string")
```

### Arquivo de Configuração

Localização: `~/.config/gemini-cli/config.json`

```json
{
  "theme": "default",
  "editor": {
    "vimMode": false
  },
  "telemetry": {
    "enabled": false
  }
}
```

## 🎯 Contexto do Ambiente

As extensões foram selecionadas considerando:

- ✅ macOS Silicon (Tahoe 26.0.1)
- ✅ VPS Ubuntu
- ✅ Hugging Face
- ✅ GitHub + Codespaces
- ✅ LLMs (OpenAI, Anthropic, Gemini, Ollama, LM Studio)
- ✅ Stacks Docker (Traefik, Redis, Postgres, MongoDB)
- ✅ IDE Cursor

## ⚠️ Limites de Uso

- **Ideal:** 5-6 servidores MCP
- **Recomendado:** Máximo de 8 servidores
- **Máximo absoluto:** 12 servidores

## 🔗 Links Úteis

- [Catálogo Oficial de Extensões](https://geminicli.com/extensions/)
- [Documentação MCP](https://modelcontextprotocol.io/)
- [GitHub do Gemini CLI](https://github.com/google-gemini/gemini-cli)

---

**Última atualização:** 2025-11-03

