#!/bin/bash

#################################################################################
# Script de Atualização de Contexto Global
# Versão: 2.0.1
# Objetivo: Atualizar contexto para todas as IAs (Cursor, VSCode, Claude, Gemini, ChatGPT)
#################################################################################

set -e

DOTFILES_DIR="$HOME/Dotfiles"
CONTEXT_DIR="$DOTFILES_DIR/context"
GLOBAL_CONTEXT="$CONTEXT_DIR/global/CONTEXTO_GLOBAL_COMPLETO.md"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Coletar informações do sistema
collect_system_info() {
    log "Coletando informações do sistema..."

    local info_file="$CONTEXT_DIR/global/system-info.json"

    cat > "$info_file" << EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "system": {
    "os": "$(uname -s)",
    "arch": "$(uname -m)",
    "hostname": "$(hostname)",
    "user": "$(whoami)",
    "home": "$HOME"
  },
  "dotfiles": {
    "path": "$DOTFILES_DIR",
    "version": "2.0.1"
  },
  "tools": {
    "git": "$(git --version 2>/dev/null | cut -d' ' -f3 || echo 'not installed')",
    "docker": "$(docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1 || echo 'not installed')",
    "node": "$(node --version 2>/dev/null || echo 'not installed')",
    "python": "$(python3 --version 2>/dev/null | cut -d' ' -f2 || echo 'not installed')",
    "gcloud": "$(gcloud --version 2>/dev/null | head -1 | cut -d' ' -f4 || echo 'not installed')"
  },
  "gcp": {
    "project_id": "gcp-ai-setup-24410",
    "project_number": "501288307921",
    "region": "us-central1"
  }
}
EOF

    success "Informações do sistema coletadas"
}

# Atualizar contexto Cursor
update_cursor_context() {
    log "Atualizando contexto Cursor..."

    local cursor_context="$CONTEXT_DIR/cursor/CONTEXTO_CURSOR.md"

    cat > "$cursor_context" << 'EOFCURSOR'
# 🎯 Contexto Cursor 2.0

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Configurações Aplicadas

- Settings: `~/Dotfiles/configs/cursor/settings.json`
- Keybindings: `~/Dotfiles/configs/cursor/keybindings.json`
- Extensões: `~/Dotfiles/configs/extensions/recommended.json`

## Projeto GCP

- ID: `gcp-ai-setup-24410`
- Região: `us-central1`

## Credenciais

- Fonte: 1Password (vault: 1p_macos ou Personal)
- Local: `~/Dotfiles/credentials/` (não versionado)
- Sincronização: `~/Dotfiles/scripts/sync/sync-1password-to-dotfiles.sh`

## Comandos Úteis

```bash
# Aplicar configurações
cd ~/Dotfiles && ./scripts/install/cursor.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Atualizar contexto
./scripts/context/update-global-context.sh
```

## Referências

- **System Prompt Cursor**: `~/Dotfiles/prompts/system_prompts/4.3.prompt_cursor_infraestrutura.md`
- **Configurações Cursor**: `~/Dotfiles/configs/cursor/`

**Última atualização**: $(date +%Y-%m-%d)
EOFCURSOR

    success "Contexto Cursor atualizado"
}

# Atualizar contexto VSCode
update_vscode_context() {
    log "Atualizando contexto VSCode..."

    local vscode_context="$CONTEXT_DIR/vscode/CONTEXTO_VSCODE.md"

    cat > "$vscode_context" << 'EOFVSCODE'
# 💻 Contexto VSCode

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Configurações Aplicadas

- Settings: `~/Dotfiles/configs/vscode/settings.json`
- Extensões: `~/Dotfiles/configs/extensions/recommended.json`

## Integrações

- GitHub Copilot: Habilitado
- Gemini Code Assist: Configurado
- MCP Servers: Configurados

## Projeto GCP

- ID: `gcp-ai-setup-24410`
- Região: `us-central1`

## Referências

- **System Prompt GitHub Copilot**: `~/Dotfiles/prompts/system_prompts/4.4.prompt_github-copilot_infraestrutura.md`
- **Configurações VSCode**: `~/Dotfiles/configs/vscode/`

**Última atualização**: $(date +%Y-%m-%d)
EOFVSCODE

    success "Contexto VSCode atualizado"
}

# Atualizar contexto Claude
update_claude_context() {
    log "Atualizando contexto Claude..."

    local claude_context="$CONTEXT_DIR/claude/CONTEXTO_CLAUDE.md"

    cat > "$claude_context" << 'EOFCLAUDE'
# 🤖 Contexto Claude

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Ambiente de Desenvolvimento

- **Base**: `~/Dotfiles` (governança centralizada)
- **Sistema**: macOS Silicon ou Ubuntu VPS
- **Stack**: Node.js 20, Python 3.11, Docker

## Estrutura de Diretórios

```
~/Dotfiles/
├── configs/          # Configurações padronizadas
├── credentials/       # Credenciais locais (não versionado)
├── scripts/          # Scripts de automação
├── templates/        # Templates
└── context/          # Contexto para IAs
```

## Credenciais

- **Fonte**: 1Password (vault: 1p_macos ou Personal)
- **Sincronização**: `~/Dotfiles/scripts/sync/sync-1password-to-dotfiles.sh`
- **Local**: `~/Dotfiles/credentials/` (chmod 600)

## Projeto GCP

- ID: `gcp-ai-setup-24410`
- Service Account: `~/Dotfiles/credentials/service-accounts/gcp-ai-setup-24410.json`

## Comandos Importantes

```bash
# Setup completo
cd ~/Dotfiles && ./scripts/setup/master.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Configurar OAuth local
./scripts/governance/setup-oauth-local.sh
```

## Referências

- **System Prompt Claude**: `~/Dotfiles/prompts/system_prompts/4.0.prompt_claude_infraestrutura.md`
- **Documentação**: `~/Dotfiles/docs/`

**Última atualização**: $(date +%Y-%m-%d)
EOFCLAUDE

    success "Contexto Claude atualizado"
}

# Atualizar contexto Gemini
update_gemini_context() {
    log "Atualizando contexto Gemini..."

    local gemini_context="$CONTEXT_DIR/gemini/CONTEXTO_GEMINI.md"

    cat > "$gemini_context" << 'EOFGEMINI'
# 🌟 Contexto Gemini

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Configuração Gemini

- **Projeto GCP**: `gcp-ai-setup-24410` (501288307921)
- **Região**: `us-central1`
- **Service Account**: `gemini-vps-agent@gcp-ai-setup-24410.iam.gserviceaccount.com`

## Credenciais

- **API Key**: Sincronizada via 1Password → `~/Dotfiles/credentials/api-keys/GEMINI_API_KEY.local`
- **Google API Key**: Sincronizada via 1Password → `~/Dotfiles/credentials/api-keys/GOOGLE_API_KEY.local`
- **Service Account**: `~/Dotfiles/credentials/service-accounts/gcp-ai-setup-24410.json`

## Configurações Aplicadas

- **VSCode**: Gemini Code Assist configurado
- **Cursor**: Gemini Code Assist configurado
- **CLI**: `~/.config/gemini/config.yaml`

## Sincronização

```bash
# Sincronizar credenciais do 1Password
cd ~/Dotfiles && ./scripts/sync/sync-1password-to-dotfiles.sh

# Instalar extensões e configurar
./scripts/install/google-extensions.sh
```

**Última atualização**: $(date +%Y-%m-%d)
EOFGEMINI

    success "Contexto Gemini atualizado"
}

# Atualizar contexto ChatGPT
update_chatgpt_context() {
    log "Atualizando contexto ChatGPT..."

    local chatgpt_context="$CONTEXT_DIR/chatgpt/CONTEXTO_CHATGPT.md"

    cat > "$chatgpt_context" << 'EOFCHATGPT'
# 💬 Contexto ChatGPT

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Ambiente de Desenvolvimento

- **Base**: `~/Dotfiles` (governança centralizada)
- **Sistema**: macOS Silicon ou Ubuntu VPS
- **Stack**: Node.js 20, Python 3.11, Docker

## Estrutura de Diretórios

```
~/Dotfiles/
├── configs/          # Configurações padronizadas
├── credentials/       # Credenciais locais (não versionado)
├── scripts/          # Scripts de automação
├── templates/        # Templates
└── context/          # Contexto para IAs
```

## Credenciais

- **Fonte**: 1Password (vault: 1p_macos ou Personal)
- **Sincronização**: `~/Dotfiles/scripts/sync/sync-1password-to-dotfiles.sh`
- **Local**: `~/Dotfiles/credentials/` (chmod 600)

## Projeto GCP

- ID: `gcp-ai-setup-24410`
- Service Account: `~/Dotfiles/credentials/service-accounts/gcp-ai-setup-24410.json`

## Comandos Importantes

```bash
# Setup completo
cd ~/Dotfiles && ./scripts/setup/master.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Atualizar contexto
./scripts/context/update-global-context.sh
```

## Ambientes Suportados

- macOS Silicon
- Ubuntu VPS (147.79.81.59)
- DevContainers
- GitHub Codespaces

**Última atualização**: $(date +%Y-%m-%d)
EOFCHATGPT

    success "Contexto ChatGPT atualizado"
}

# Copiar contexto para locais de uso
copy_context_to_editors() {
    log "Copiando contexto para editores..."

    # Cursor
    if [ -d "$HOME/Library/Application Support/Cursor/User" ]; then
        mkdir -p "$HOME/Library/Application Support/Cursor/User/context"
        cp "$GLOBAL_CONTEXT" "$HOME/Library/Application Support/Cursor/User/context/" 2>/dev/null || true
        cp "$CONTEXT_DIR/cursor/CONTEXTO_CURSOR.md" "$HOME/Library/Application Support/Cursor/User/context/" 2>/dev/null || true
    fi

    # VSCode
    if [ -d "$HOME/Library/Application Support/Code/User" ]; then
        mkdir -p "$HOME/Library/Application Support/Code/User/context"
        cp "$GLOBAL_CONTEXT" "$HOME/Library/Application Support/Code/User/context/" 2>/dev/null || true
        cp "$CONTEXT_DIR/vscode/CONTEXTO_VSCODE.md" "$HOME/Library/Application Support/Code/User/context/" 2>/dev/null || true
    fi

    success "Contexto copiado para editores"
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Atualização de Contexto Global                         ║"
    echo "║              Versão 2.0.1 - Todas as IAs                    ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    collect_system_info
    update_cursor_context
    update_vscode_context
    update_claude_context
    update_gemini_context
    update_chatgpt_context
    copy_context_to_editors

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              CONTEXTO ATUALIZADO COM SUCESSO                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Contexto global atualizado para todas as IAs!"
    echo ""
    echo "Arquivos atualizados:"
    echo "  - Global: $GLOBAL_CONTEXT"
    echo "  - Cursor: $CONTEXT_DIR/cursor/CONTEXTO_CURSOR.md"
    echo "  - VSCode: $CONTEXT_DIR/vscode/CONTEXTO_VSCODE.md"
    echo "  - Claude: $CONTEXT_DIR/claude/CONTEXTO_CLAUDE.md"
    echo "  - Gemini: $CONTEXT_DIR/gemini/CONTEXTO_GEMINI.md"
    echo "  - ChatGPT: $CONTEXT_DIR/chatgpt/CONTEXTO_CHATGPT.md"
    echo ""
}

main "$@"
