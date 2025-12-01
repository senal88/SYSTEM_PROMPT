# 🔍 AUDITORIA 1PASSWORD - Secrets e Variáveis de Ambiente

**Data:** 2025-11-28 08:37:37  
**Sistema:** macOS $(sw_vers -productVersion)  
**Usuário:** $(whoami)

---

## 📦 INSTALAÇÕES E DEPENDÊNCIAS

### Ferramentas Base

| Ferramenta | Versão | Status | Path |
|------------|--------|--------|------|
| Homebrew | - | ❌ Não instalado | - |
| Node.js | - | ❌ Não instalado | - |
| Python 3 | Python 3.9.6 | ✅ Instalado | /usr/bin/python3 |
| Git | git version 2.50.1 (Apple Git-155) | ✅ Instalado | /usr/bin/git |
| Docker | Docker version 28.5.1, build e180ab8 | ✅ Instalado | /usr/local/bin/docker |
| 1Password CLI | - | ❌ Não instalado | - |

### Ambientes Virtuais

| pyenv | - | ❌ Não instalado | - |
| nvm | lts/* | ✅ Instalado | /Users/luiz.sena88/.nvm |
| virtualenv | - | ❌ Não instalado | - |

---

## 🤖 LLMs E FERRAMENTAS DE IA

### Instalações Desktop

| Ferramenta | Status | Path/Config |
|------------|--------|------------|
| Cursor | ✅ Instalado | /Applications/Cursor.app (v2.1.39) |
| VSCode | ✅ Instalado | /Applications/Visual Studio Code.app (v1.106.3) |
| Raycast | ✅ Instalado | /Applications/Raycast.app (v1.103.8) |
| Ollama | ❌ Não instalado | - |
| LM Studio | ✅ Instalado | /Applications/LM Studio.app |

### Configurações Web

| Plataforma | Status | Configuração |
|------------|--------|--------------|
| ChatGPT Plus | ⚠️ Verificar manualmente | Custom Instructions em ~/Dotfiles/system_prompts/global/ |
| Claude.ai | ⚠️ Verificar manualmente | Custom Instructions em ~/Dotfiles/system_prompts/global/ |
| Gemini | ⚠️ Verificar manualmente | API configurada via variáveis de ambiente |
| Perplexity | ⚠️ Verificar manualmente | - |

---

## 🔐 VARIÁVEIS DE AMBIENTE E SECRETS

### Variáveis Críticas para 1Password

| Variável | Status Atual | Deve Estar no 1Password | Vault Sugerido |
|----------|--------------|-------------------------|----------------|
| GITHUB_TOKEN | ❌ Não definida | ✅ Sim | 1p_macos |
| GITHUB_USER | ❌ Não definida | ⚠️ Opcional | 1p_macos |
| HUGGINGFACE_API_TOKEN | ❌ Não definida | ✅ Sim | 1p_macos |
| HF_HOME | ❌ Não definida | ⚠️ Opcional | - |
| OPENAI_API_KEY | ✅ Definida | ✅ Sim | 1p_macos |
| ANTHROPIC_API_KEY | ✅ Definida | ✅ Sim | 1p_macos |
| GOOGLE_API_KEY | ❌ Não definida | ✅ Sim | 1p_macos |
| DOTFILES_DIR | ✅ Definida (/Users/luiz.sena88/Dotfiles) | ⚠️ Opcional | - |
| VPS_HOST | ❌ Não definida | ⚠️ Opcional | - |
| OP_VAULT_MACOS | ❌ Não definida | ⚠️ Opcional | - |

---

## ⚙️ CONFIGURAÇÕES DE FERRAMENTAS

### Cursor 2.0

| Item | Status | Localização |
|------|--------|-------------|
| Diretório .cursor | ✅ Existe | /Users/luiz.sena88/.cursor |
| Rules | ✅ Existe (5 arquivos) | /Users/luiz.sena88/.cursor/rules |
| MCP Config | ✅ Existe | /Users/luiz.sena88/.cursor/mcp.json |

### VSCode

| Item | Status | Localização |
|------|--------|-------------|
| Config VSCode | ✅ Existe | /Users/luiz.sena88/.vscode ou ~/Library/Application Support/Code |
| settings.json | ✅ Existe | /Users/luiz.sena88/.vscode/settings.json |

### GitHub Copilot

| Item | Status | Notas |
|------|--------|-------|
| GitHub CLI | ❌ Não instalado | - |

### Raycast

| Item | Status | Localização |
|------|--------|-------------|
| Config Raycast | ✅ Existe | /Users/luiz.sena88/.config/raycast |
| Raycast Extensions | ✅ Existe (20 arquivos) | /Users/luiz.sena88/Dotfiles/raycast-profile |

---

## 🔌 MCP SERVERS

| Server | Status | Configuração |
|--------|--------|--------------|
| Cursor MCP Config | ✅ Existe | /Users/luiz.sena88/.cursor/mcp.json |
| claude-mcp | ✅ Configurado | mcp.json |
| context7 | ✅ Configurado | mcp.json |
| hostinger-mcp | ✅ Configurado | mcp.json |
| notion | ✅ Configurado | mcp.json |

---

## 📋 RECOMENDAÇÕES PARA 1PASSWORD

### Secrets que DEVEM estar no 1Password

1. **GITHUB_TOKEN** (vault: 1p_macos)
   - Token para GitHub API e Copilot
   - Escopo: repo, read:org, copilot

2. **OPENAI_API_KEY** (vault: 1p_macos)
   - Chave API OpenAI para ChatGPT Plus
   - Uso: Integração com OpenAI

3. **ANTHROPIC_API_KEY** (vault: 1p_macos)
   - Chave API Anthropic para Claude
   - Uso: Claude Code e Claude.ai

4. **GOOGLE_API_KEY** (vault: 1p_macos)
   - Chave API Google para Gemini
   - Uso: Gemini desktop e web

5. **HUGGINGFACE_API_TOKEN** (vault: 1p_macos)
   - Token Hugging Face
   - Uso: MCP Server, modelos HF

### Variáveis de Ambiente Recomendadas

Adicionar ao `~/.zshrc` ou `~/.zshenv`:

```bash
# Dotfiles
export DOTFILES_DIR="${HOME}/Dotfiles"
export SYSTEM_PROMPTS_DIR="${DOTFILES_DIR}/system_prompts/global"

# GitHub
export GITHUB_USER="senal88"
export GITHUB_TOKEN="$(op read op://1p_macos/GitHub/copilot_token)"

# Hugging Face
export HF_HOME="${HOME}/.cache/huggingface"
export HUGGINGFACE_API_TOKEN="$(op read op://1p_macos/HuggingFace/token)"

# OpenAI
export OPENAI_API_KEY="$(op read op://1p_macos/OpenAI/api_key)"

# Anthropic
export ANTHROPIC_API_KEY="$(op read op://1p_macos/Anthropic/api_key)"

# Google/Gemini
export GOOGLE_API_KEY="$(op read op://1p_macos/Google/gemini_api_key)"

# 1Password Vaults
export OP_VAULT_MACOS="1p_macos"
export OP_VAULT_VPS="1p_vps"
```

### Configurações que DEVEM estar documentadas

1. **Cursor 2.0**
   - System prompts em `~/.cursor/rules/`
   - MCP servers configurados
   - Extensões instaladas

2. **VSCode**
   - Extensões GitHub Copilot
   - Configurações de workspace
   - Settings personalizados

3. **Raycast**
   - Extensões instaladas
   - Workflows configurados
   - Atalhos personalizados

4. **MCP Servers**
   - Servers instalados e configurados
   - Tokens e credenciais necessárias
   - Configuração em `~/.cursor/mcp.json`

---

## ✅ CHECKLIST DE ATUALIZAÇÃO 1PASSWORD

- [ ] Verificar se todos os tokens API estão no 1Password
- [ ] Criar entries faltantes no vault `1p_macos`
- [ ] Atualizar variáveis de ambiente no shell config
- [ ] Documentar configurações de ferramentas
- [ ] Verificar sincronização entre macOS e VPS
- [ ] Testar acesso via `op read` para cada secret

---

**Relatório gerado em:** 2025-11-28 08:37:37  
**Próxima auditoria recomendada:** Após atualizações no 1Password

