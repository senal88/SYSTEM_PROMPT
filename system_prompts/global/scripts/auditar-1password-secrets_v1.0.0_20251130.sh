#!/usr/bin/env bash

################################################################################
# 🔐 AUDITORIA 1PASSWORD - Secrets e Variáveis de Ambiente
# Verifica instalações, configurações e gera relatório para 1Password
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Auditoria completa de secrets e variáveis de ambiente
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
AUDIT_BASE="${DOTFILES_DIR}/system_prompts/global/audit"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
AUDIT_DIR="${AUDIT_BASE}/${TIMESTAMP}/1password"
REPORT_FILE="${AUDIT_DIR}/relatorio_1password_${TIMESTAMP}.md"

mkdir -p "${AUDIT_DIR}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

get_version() {
    local cmd="$1"
    local version_flag="${2:---version}"
    if check_command "$cmd"; then
        $cmd $version_flag 2>/dev/null | head -1 | tr -d '\n' || echo "instalado"
    else
        echo "não instalado"
    fi
}

check_env_var() {
    local var="$1"
    if [ -n "${!var:-}" ]; then
        echo "✅ Definida: ${!var:0:20}..."
    else
        echo "❌ Não definida"
    fi
}

# ============================================================================
# AUDITORIA DE INSTALAÇÕES
# ============================================================================

audit_installations() {
    log_info "Auditando instalações..."

    cat >> "${REPORT_FILE}" << 'EOF'
# 🔍 AUDITORIA 1PASSWORD - Secrets e Variáveis de Ambiente

**Data:** $(date +"%Y-%m-%d %H:%M:%S")
**Sistema:** macOS $(sw_vers -productVersion)
**Usuário:** $(whoami)

---

## 📦 INSTALAÇÕES E DEPENDÊNCIAS

EOF

    {
        echo "### Ferramentas Base"
        echo ""
        echo "| Ferramenta | Versão | Status | Path |"
        echo "|------------|--------|--------|------|"

        # Homebrew
        if check_command brew; then
            BREW_VERSION=$(brew --version | head -1)
            BREW_PREFIX=$(brew --prefix)
            echo "| Homebrew | ${BREW_VERSION} | ✅ Instalado | ${BREW_PREFIX} |"
        else
            echo "| Homebrew | - | ❌ Não instalado | - |"
        fi

        # Node.js
        if check_command node; then
            NODE_VERSION=$(node --version)
            NODE_PATH=$(which node)
            echo "| Node.js | ${NODE_VERSION} | ✅ Instalado | ${NODE_PATH} |"
        else
            echo "| Node.js | - | ❌ Não instalado | - |"
        fi

        # Python
        if check_command python3; then
            PYTHON_VERSION=$(python3 --version)
            PYTHON_PATH=$(which python3)
            echo "| Python 3 | ${PYTHON_VERSION} | ✅ Instalado | ${PYTHON_PATH} |"
        else
            echo "| Python 3 | - | ❌ Não instalado | - |"
        fi

        # Git
        if check_command git; then
            GIT_VERSION=$(git --version)
            GIT_PATH=$(which git)
            echo "| Git | ${GIT_VERSION} | ✅ Instalado | ${GIT_PATH} |"
        else
            echo "| Git | - | ❌ Não instalado | - |"
        fi

        # Docker
        if check_command docker; then
            DOCKER_VERSION=$(docker --version)
            DOCKER_PATH=$(which docker)
            echo "| Docker | ${DOCKER_VERSION} | ✅ Instalado | ${DOCKER_PATH} |"
        else
            echo "| Docker | - | ❌ Não instalado | - |"
        fi

        # 1Password CLI
        if check_command op; then
            OP_VERSION=$(op --version 2>/dev/null || echo "instalado")
            OP_PATH=$(which op)
            echo "| 1Password CLI | ${OP_VERSION} | ✅ Instalado | ${OP_PATH} |"
        else
            echo "| 1Password CLI | - | ❌ Não instalado | - |"
        fi

        echo ""
        echo "### Ambientes Virtuais"
        echo ""

        # pyenv
        if check_command pyenv; then
            PYENV_VERSION=$(pyenv --version)
            PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
            echo "| pyenv | ${PYENV_VERSION} | ✅ Instalado | ${PYENV_ROOT} |"
        else
            echo "| pyenv | - | ❌ Não instalado | - |"
        fi

        # nvm
        if [ -d "$HOME/.nvm" ]; then
            echo "| nvm | $(cat $HOME/.nvm/alias/default 2>/dev/null || echo 'instalado') | ✅ Instalado | $HOME/.nvm |"
        else
            echo "| nvm | - | ❌ Não instalado | - |"
        fi

        # venv/virtualenv
        if check_command virtualenv; then
            echo "| virtualenv | $(virtualenv --version) | ✅ Instalado | $(which virtualenv) |"
        else
            echo "| virtualenv | - | ❌ Não instalado | - |"
        fi

    } >> "${REPORT_FILE}"
}

# ============================================================================
# AUDITORIA DE LLMs E FERRAMENTAS
# ============================================================================

audit_llms_tools() {
    log_info "Auditando LLMs e ferramentas..."

    cat >> "${REPORT_FILE}" << 'EOF'

---

## 🤖 LLMs E FERRAMENTAS DE IA

### Instalações Desktop

| Ferramenta | Status | Path/Config |
|------------|--------|------------|
EOF

    # Cursor
    if [ -d "/Applications/Cursor.app" ]; then
        CURSOR_VERSION=$(defaults read /Applications/Cursor.app/Contents/Info.plist CFBundleShortVersionString 2>/dev/null || echo "instalado")
        echo "| Cursor | ✅ Instalado | /Applications/Cursor.app (v${CURSOR_VERSION}) |" >> "${REPORT_FILE}"
    else
        echo "| Cursor | ❌ Não instalado | - |" >> "${REPORT_FILE}"
    fi

    # VSCode
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        VSCODE_VERSION=$(defaults read "/Applications/Visual Studio Code.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "instalado")
        echo "| VSCode | ✅ Instalado | /Applications/Visual Studio Code.app (v${VSCODE_VERSION}) |" >> "${REPORT_FILE}"
    else
        echo "| VSCode | ❌ Não instalado | - |" >> "${REPORT_FILE}"
    fi

    # Raycast
    if [ -d "/Applications/Raycast.app" ]; then
        RAYCAST_VERSION=$(defaults read /Applications/Raycast.app/Contents/Info.plist CFBundleShortVersionString 2>/dev/null || echo "instalado")
        echo "| Raycast | ✅ Instalado | /Applications/Raycast.app (v${RAYCAST_VERSION}) |" >> "${REPORT_FILE}"
    else
        echo "| Raycast | ❌ Não instalado | - |" >> "${REPORT_FILE}"
    fi

    # Ollama
    if check_command ollama; then
        OLLAMA_VERSION=$(ollama --version 2>/dev/null || echo "instalado")
        echo "| Ollama | ✅ Instalado | $(which ollama) (${OLLAMA_VERSION}) |" >> "${REPORT_FILE}"
    else
        echo "| Ollama | ❌ Não instalado | - |" >> "${REPORT_FILE}"
    fi

    # LM Studio
    if [ -d "/Applications/LM Studio.app" ]; then
        echo "| LM Studio | ✅ Instalado | /Applications/LM Studio.app |" >> "${REPORT_FILE}"
    else
        echo "| LM Studio | ❌ Não instalado | - |" >> "${REPORT_FILE}"
    fi

    cat >> "${REPORT_FILE}" << 'EOF'

### Configurações Web

| Plataforma | Status | Configuração |
|------------|--------|--------------|
EOF

    # Verificar configurações de LLMs web
    echo "| ChatGPT Plus | ⚠️ Verificar manualmente | Custom Instructions em ~/Dotfiles/system_prompts/global/ |" >> "${REPORT_FILE}"
    echo "| Claude.ai | ⚠️ Verificar manualmente | Custom Instructions em ~/Dotfiles/system_prompts/global/ |" >> "${REPORT_FILE}"
    echo "| Gemini | ⚠️ Verificar manualmente | API configurada via variáveis de ambiente |" >> "${REPORT_FILE}"
    echo "| Perplexity | ⚠️ Verificar manualmente | - |" >> "${REPORT_FILE}"
}

# ============================================================================
# AUDITORIA DE VARIÁVEIS DE AMBIENTE
# ============================================================================

audit_env_vars() {
    log_info "Auditando variáveis de ambiente..."

    cat >> "${REPORT_FILE}" << 'EOF'

---

## 🔐 VARIÁVEIS DE AMBIENTE E SECRETS

### Variáveis Críticas para 1Password

| Variável | Status Atual | Deve Estar no 1Password | Vault Sugerido |
|----------|--------------|-------------------------|----------------|
EOF

    # GitHub
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        echo "| GITHUB_TOKEN | ✅ Definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    else
        echo "| GITHUB_TOKEN | ❌ Não definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    fi

    if [ -n "${GITHUB_USER:-}" ]; then
        echo "| GITHUB_USER | ✅ Definida (${GITHUB_USER}) | ⚠️ Opcional | 1p_macos |" >> "${REPORT_FILE}"
    else
        echo "| GITHUB_USER | ❌ Não definida | ⚠️ Opcional | 1p_macos |" >> "${REPORT_FILE}"
    fi

    # Hugging Face
    if [ -n "${HUGGINGFACE_API_TOKEN:-}" ]; then
        echo "| HUGGINGFACE_API_TOKEN | ✅ Definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    else
        echo "| HUGGINGFACE_API_TOKEN | ❌ Não definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    fi

    if [ -n "${HF_HOME:-}" ]; then
        echo "| HF_HOME | ✅ Definida (${HF_HOME}) | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    else
        echo "| HF_HOME | ❌ Não definida | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    fi

    # OpenAI
    if [ -n "${OPENAI_API_KEY:-}" ]; then
        echo "| OPENAI_API_KEY | ✅ Definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    else
        echo "| OPENAI_API_KEY | ❌ Não definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    fi

    # Anthropic
    if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
        echo "| ANTHROPIC_API_KEY | ✅ Definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    else
        echo "| ANTHROPIC_API_KEY | ❌ Não definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    fi

    # Google/Gemini
    if [ -n "${GOOGLE_API_KEY:-}" ]; then
        echo "| GOOGLE_API_KEY | ✅ Definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    else
        echo "| GOOGLE_API_KEY | ❌ Não definida | ✅ Sim | 1p_macos |" >> "${REPORT_FILE}"
    fi

    # Dotfiles
    if [ -n "${DOTFILES_DIR:-}" ]; then
        echo "| DOTFILES_DIR | ✅ Definida (${DOTFILES_DIR}) | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    else
        echo "| DOTFILES_DIR | ❌ Não definida | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    fi

    # VPS
    if [ -n "${VPS_HOST:-}" ]; then
        echo "| VPS_HOST | ✅ Definida (${VPS_HOST}) | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    else
        echo "| VPS_HOST | ❌ Não definida | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    fi

    # 1Password Vaults
    if [ -n "${OP_VAULT_MACOS:-}" ]; then
        echo "| OP_VAULT_MACOS | ✅ Definida (${OP_VAULT_MACOS}) | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    else
        echo "| OP_VAULT_MACOS | ❌ Não definida | ⚠️ Opcional | - |" >> "${REPORT_FILE}"
    fi
}

# ============================================================================
# AUDITORIA DE CONFIGURAÇÕES
# ============================================================================

audit_configurations() {
    log_info "Auditando configurações..."

    cat >> "${REPORT_FILE}" << 'EOF'

---

## ⚙️ CONFIGURAÇÕES DE FERRAMENTAS

### Cursor 2.0

| Item | Status | Localização |
|------|--------|-------------|
EOF

    # Cursor config
    if [ -d "$HOME/.cursor" ]; then
        echo "| Diretório .cursor | ✅ Existe | $HOME/.cursor |" >> "${REPORT_FILE}"

        if [ -d "$HOME/.cursor/rules" ]; then
            RULES_COUNT=$(find "$HOME/.cursor/rules" -type f 2>/dev/null | wc -l | tr -d ' ')
            echo "| Rules | ✅ Existe (${RULES_COUNT} arquivos) | $HOME/.cursor/rules |" >> "${REPORT_FILE}"
        else
            echo "| Rules | ❌ Não existe | - |" >> "${REPORT_FILE}"
        fi

        if [ -f "$HOME/.cursor/mcp.json" ]; then
            echo "| MCP Config | ✅ Existe | $HOME/.cursor/mcp.json |" >> "${REPORT_FILE}"
        else
            echo "| MCP Config | ❌ Não existe | - |" >> "${REPORT_FILE}"
        fi
    else
        echo "| Diretório .cursor | ❌ Não existe | - |" >> "${REPORT_FILE}"
    fi

    cat >> "${REPORT_FILE}" << 'EOF'

### VSCode

| Item | Status | Localização |
|------|--------|-------------|
EOF

    if [ -d "$HOME/.vscode" ] || [ -d "$HOME/Library/Application Support/Code" ]; then
        echo "| Config VSCode | ✅ Existe | $HOME/.vscode ou ~/Library/Application Support/Code |" >> "${REPORT_FILE}"

        if [ -f "$HOME/.vscode/settings.json" ]; then
            echo "| settings.json | ✅ Existe | $HOME/.vscode/settings.json |" >> "${REPORT_FILE}"
        fi
    else
        echo "| Config VSCode | ❌ Não existe | - |" >> "${REPORT_FILE}"
    fi

    cat >> "${REPORT_FILE}" << 'EOF'

### GitHub Copilot

| Item | Status | Notas |
|------|--------|-------|
EOF

    if check_command gh; then
        GH_AUTH=$(gh auth status 2>&1 | grep -q "Logged in" && echo "✅ Autenticado" || echo "❌ Não autenticado")
        echo "| GitHub CLI | ${GH_AUTH} | $(which gh) |" >> "${REPORT_FILE}"
    else
        echo "| GitHub CLI | ❌ Não instalado | - |" >> "${REPORT_FILE}"
    fi

    cat >> "${REPORT_FILE}" << 'EOF'

### Raycast

| Item | Status | Localização |
|------|--------|-------------|
EOF

    if [ -d "$HOME/.config/raycast" ]; then
        echo "| Config Raycast | ✅ Existe | $HOME/.config/raycast |" >> "${REPORT_FILE}"
    else
        echo "| Config Raycast | ❌ Não existe | - |" >> "${REPORT_FILE}"
    fi

    # Verificar extensões Raycast
    if [ -d "$HOME/Dotfiles/raycast-profile" ]; then
        EXT_COUNT=$(find "$HOME/Dotfiles/raycast-profile" -type f 2>/dev/null | wc -l | tr -d ' ')
        echo "| Raycast Extensions | ✅ Existe (${EXT_COUNT} arquivos) | $HOME/Dotfiles/raycast-profile |" >> "${REPORT_FILE}"
    fi
}

# ============================================================================
# AUDITORIA DE MCP SERVERS
# ============================================================================

audit_mcp_servers() {
    log_info "Auditando MCP Servers..."

    cat >> "${REPORT_FILE}" << 'EOF'

---

## 🔌 MCP SERVERS

| Server | Status | Configuração |
|--------|--------|--------------|
EOF

    # Verificar MCP config do Cursor
    if [ -f "$HOME/.cursor/mcp.json" ]; then
        echo "| Cursor MCP Config | ✅ Existe | $HOME/.cursor/mcp.json |" >> "${REPORT_FILE}"

        # Tentar ler servidores configurados
        if command -v jq >/dev/null 2>&1; then
            MCP_SERVERS=$(jq -r '.mcpServers | keys[]' "$HOME/.cursor/mcp.json" 2>/dev/null || echo "")
            if [ -n "$MCP_SERVERS" ]; then
                echo "$MCP_SERVERS" | while read -r server; do
                    echo "| $server | ✅ Configurado | mcp.json |" >> "${REPORT_FILE}"
                done
            fi
        fi
    else
        echo "| Cursor MCP Config | ❌ Não existe | - |" >> "${REPORT_FILE}"
    fi

    # Verificar se MCP servers estão instalados
    if check_command npm; then
        # Verificar se há pacotes MCP instalados globalmente
        MCP_PACKAGES=$(npm list -g --depth=0 2>/dev/null | grep -i mcp || echo "")
        if [ -n "$MCP_PACKAGES" ]; then
            echo "$MCP_PACKAGES" | while read -r pkg; do
                echo "| $pkg | ✅ Instalado (npm global) | - |" >> "${REPORT_FILE}"
            done
        fi
    fi
}

# ============================================================================
# RELATÓRIO FINAL E RECOMENDAÇÕES
# ============================================================================

generate_recommendations() {
    log_info "Gerando recomendações..."

    cat >> "${REPORT_FILE}" << 'EOF'

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

**Relatório gerado em:** $(date +"%Y-%m-%d %H:%M:%S")
**Próxima auditoria recomendada:** Após atualizações no 1Password

EOF

    # Substituir variáveis no arquivo
    sed -i '' "s/\$(date +\"%Y-%m-%d %H:%M:%S\")/$(date +"%Y-%m-%d %H:%M:%S")/g" "${REPORT_FILE}" 2>/dev/null || \
    sed -i "s/\$(date +\"%Y-%m-%d %H:%M:%S\")/$(date +"%Y-%m-%d %H:%M:%S")/g" "${REPORT_FILE}"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ 🔐 AUDITORIA 1PASSWORD - Secrets e Variáveis de Ambiente"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    audit_installations
    audit_llms_tools
    audit_env_vars
    audit_configurations
    audit_mcp_servers
    generate_recommendations

    log_success "✅ Auditoria concluída!"
    log_info "📄 Relatório em: ${REPORT_FILE}"
    echo ""
    echo "Próximos passos:"
    echo "1. Revisar o relatório: ${REPORT_FILE}"
    echo "2. Atualizar secrets faltantes no 1Password"
    echo "3. Atualizar variáveis de ambiente no shell config"
    echo ""
}

main "$@"

