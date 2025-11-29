# ✅ CHECKLIST DE ATUALIZAÇÃO 1PASSWORD

**Data:** 2025-11-28
**Status:** Auditoria Completa
**Relatório Completo:** `audit/20251128_083737/1password/relatorio_1password_20251128_083737.md`

---

## 🔍 RESUMO EXECUTIVO

### ✅ O QUE ESTÁ FUNCIONANDO

- ✅ **Cursor 2.0** instalado e configurado (v2.1.39)
  - Rules: 5 arquivos em `~/.cursor/rules/`
  - MCP Config: `~/.cursor/mcp.json` existe
  - MCP Servers configurados: claude-mcp, context7, hostinger-mcp, notion

- ✅ **VSCode** instalado (v1.106.3)
  - Configurações existem
  - settings.json presente

- ✅ **Raycast** instalado (v1.103.8)
  - Config existe em `~/.config/raycast`
  - 20 extensões em `~/Dotfiles/raycast-profile`

- ✅ **LM Studio** instalado

- ✅ **Variáveis de Ambiente Definidas:**
  - `OPENAI_API_KEY` ✅
  - `ANTHROPIC_API_KEY` ✅
  - `DOTFILES_DIR` ✅

### ❌ O QUE PRECISA SER ATUALIZADO NO 1PASSWORD

#### Secrets Faltantes (CRÍTICO)

1. **GITHUB_TOKEN** ❌
   - **Vault:** `1p_macos`
   - **Path sugerido:** `op://1p_macos/GitHub/copilot_token`
   - **Escopo necessário:** repo, read:org, copilot
   - **Uso:** GitHub API, GitHub Copilot, repositórios

2. **HUGGINGFACE_API_TOKEN** ❌
   - **Vault:** `1p_macos`
   - **Path sugerido:** `op://1p_macos/HuggingFace/token`
   - **Uso:** MCP Server Hugging Face, modelos HF

3. **GOOGLE_API_KEY** ❌
   - **Vault:** `1p_macos`
   - **Path sugerido:** `op://1p_macos/Google/gemini_api_key`
   - **Uso:** Gemini desktop e web, Google APIs

#### Secrets que DEVEM estar no 1Password (mas já definidas localmente)

4. **OPENAI_API_KEY** ⚠️
   - **Status:** Definida localmente, mas deve estar no 1Password
   - **Vault:** `1p_macos`
   - **Path sugerido:** `op://1p_macos/OpenAI/api_key`
   - **Ação:** Mover para 1Password e atualizar shell config

5. **ANTHROPIC_API_KEY** ⚠️
   - **Status:** Definida localmente, mas deve estar no 1Password
   - **Vault:** `1p_macos`
   - **Path sugerido:** `op://1p_macos/Anthropic/api_key`
   - **Ação:** Mover para 1Password e atualizar shell config

#### Variáveis Opcionais (Recomendadas)

6. **GITHUB_USER** ⚠️
   - **Valor sugerido:** `senal88`
   - **Pode estar no 1Password ou definida diretamente**

7. **HF_HOME** ⚠️
   - **Valor sugerido:** `~/.cache/huggingface`
   - **Não precisa estar no 1Password**

8. **VPS_HOST** ⚠️
   - **Valor sugerido:** `admin@senamfo.com.br` ou `147.79.81.59`
   - **Pode estar no 1Password ou definida diretamente**

9. **OP_VAULT_MACOS** ⚠️
   - **Valor sugerido:** `1p_macos`
   - **Não precisa estar no 1Password**

---

## 📋 CHECKLIST DE AÇÃO

### Passo 1: Verificar 1Password CLI

- [ ] Instalar 1Password CLI se não estiver instalado
- [ ] Autenticar: `op signin`
- [ ] Verificar vaults disponíveis: `op vault list`
- [ ] Confirmar que `1p_macos` existe

### Passo 2: Criar/Atualizar Secrets no 1Password

#### GitHub

- [ ] Criar entry `GitHub` no vault `1p_macos`
- [ ] Adicionar campo `copilot_token` com token GitHub
- [ ] Adicionar campo `user` com valor `senal88` (opcional)
- [ ] Verificar escopo do token: repo, read:org, copilot

#### Hugging Face

- [ ] Criar entry `HuggingFace` no vault `1p_macos`
- [ ] Adicionar campo `token` com API token Hugging Face
- [ ] Verificar permissões do token

#### Google/Gemini

- [ ] Criar entry `Google` no vault `1p_macos`
- [ ] Adicionar campo `gemini_api_key` com API key Google
- [ ] Verificar que a key tem acesso a Gemini API

#### OpenAI

- [ ] Verificar se entry `OpenAI` existe no vault `1p_macos`
- [ ] Se não existir, criar entry `OpenAI`
- [ ] Adicionar/atualizar campo `api_key` com chave OpenAI
- [ ] Remover `OPENAI_API_KEY` do shell config atual

#### Anthropic

- [ ] Verificar se entry `Anthropic` existe no vault `1p_macos`
- [ ] Se não existir, criar entry `Anthropic`
- [ ] Adicionar/atualizar campo `api_key` com chave Anthropic
- [ ] Remover `ANTHROPIC_API_KEY` do shell config atual

### Passo 3: Atualizar Shell Config (~/.zshrc)

- [ ] Adicionar variáveis de ambiente usando `op read`
- [ ] Usar template fornecido no relatório
- [ ] Testar cada variável após adicionar
- [ ] Recarregar shell: `source ~/.zshrc`

### Passo 4: Verificar Configurações de Ferramentas

#### Cursor 2.0

- [ ] Verificar que system prompts estão em `~/.cursor/rules/`
- [ ] Verificar MCP config em `~/.cursor/mcp.json`
- [ ] Documentar extensões instaladas
- [ ] Verificar que MCP servers estão funcionando

#### VSCode

- [ ] Verificar extensão GitHub Copilot instalada
- [ ] Verificar configurações de workspace
- [ ] Documentar settings personalizados

#### Raycast

- [ ] Verificar extensões em `~/Dotfiles/raycast-profile`
- [ ] Documentar workflows configurados
- [ ] Documentar atalhos personalizados

### Passo 5: Testar Acesso aos Secrets

- [ ] Testar GitHub: `op read op://1p_macos/GitHub/copilot_token`
- [ ] Testar Hugging Face: `op read op://1p_macos/HuggingFace/token`
- [ ] Testar Google: `op read op://1p_macos/Google/gemini_api_key`
- [ ] Testar OpenAI: `op read op://1p_macos/OpenAI/api_key`
- [ ] Testar Anthropic: `op read op://1p_macos/Anthropic/api_key`

### Passo 6: Validar Variáveis de Ambiente

- [ ] Verificar `GITHUB_TOKEN` carrega do 1Password
- [ ] Verificar `HUGGINGFACE_API_TOKEN` carrega do 1Password
- [ ] Verificar `GOOGLE_API_KEY` carrega do 1Password
- [ ] Verificar `OPENAI_API_KEY` carrega do 1Password
- [ ] Verificar `ANTHROPIC_API_KEY` carrega do 1Password

### Passo 7: Documentar Configurações

- [ ] Documentar MCP Servers configurados
- [ ] Documentar tokens e credenciais necessárias
- [ ] Atualizar `CURSOR_2.0_SYSTEM_PROMPT_FINAL.md` se necessário
- [ ] Criar backup das configurações atuais

---

## 🔧 TEMPLATE DE VARIÁVEIS DE AMBIENTE

Adicionar ao `~/.zshrc`:

```bash
# ============================================================================
# DOTFILES E SYSTEM PROMPTS
# ============================================================================
export DOTFILES_DIR="${HOME}/Dotfiles"
export SYSTEM_PROMPTS_DIR="${DOTFILES_DIR}/system_prompts/global"

# ============================================================================
# 1PASSWORD VAULTS
# ============================================================================
export OP_VAULT_MACOS="1p_macos"
export OP_VAULT_VPS="1p_vps"

# ============================================================================
# GITHUB
# ============================================================================
export GITHUB_USER="senal88"
export GITHUB_TOKEN="$(op read op://1p_macos/GitHub/copilot_token 2>/dev/null || echo '')"

# ============================================================================
# HUGGING FACE
# ============================================================================
export HF_HOME="${HOME}/.cache/huggingface"
export HUGGINGFACE_API_TOKEN="$(op read op://1p_macos/HuggingFace/token 2>/dev/null || echo '')"

# ============================================================================
# OPENAI
# ============================================================================
export OPENAI_API_KEY="$(op read op://1p_macos/OpenAI/api_key 2>/dev/null || echo '')"

# ============================================================================
# ANTHROPIC
# ============================================================================
export ANTHROPIC_API_KEY="$(op read op://1p_macos/Anthropic/api_key 2>/dev/null || echo '')"

# ============================================================================
# GOOGLE/GEMINI
# ============================================================================
export GOOGLE_API_KEY="$(op read op://1p_macos/Google/gemini_api_key 2>/dev/null || echo '')"

# ============================================================================
# VPS
# ============================================================================
export VPS_HOST="${VPS_HOST:-admin@senamfo.com.br}"
```

---

## 📊 STATUS ATUAL DAS INSTALAÇÕES

### ✅ Instalado e Funcional

- Python 3.9.6
- Git 2.50.1
- Docker 28.5.1
- Cursor 2.1.39
- VSCode 1.106.3
- Raycast 1.103.8
- LM Studio
- nvm (Node Version Manager)

### ❌ Não Instalado (Opcional)

- Homebrew (não encontrado no PATH)
- Node.js (não encontrado no PATH)
- 1Password CLI (não encontrado no PATH)
- Ollama
- pyenv
- virtualenv

---

## 🎯 PRÓXIMOS PASSOS PRIORITÁRIOS

1. **CRÍTICO:** Instalar/configurar 1Password CLI
2. **CRÍTICO:** Adicionar secrets faltantes no 1Password:
   - GITHUB_TOKEN
   - HUGGINGFACE_API_TOKEN
   - GOOGLE_API_KEY
3. **IMPORTANTE:** Mover secrets existentes para 1Password:
   - OPENAI_API_KEY
   - ANTHROPIC_API_KEY
4. **IMPORTANTE:** Atualizar shell config com variáveis via `op read`
5. **RECOMENDADO:** Documentar configurações de MCP Servers
6. **OPCIONAL:** Instalar ferramentas faltantes se necessário

---

**Última Atualização:** 2025-11-28
**Próxima Revisão:** Após atualização no 1Password

