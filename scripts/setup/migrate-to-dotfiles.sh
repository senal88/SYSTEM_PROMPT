#!/bin/bash

#################################################################################
# Script de Migração e Padronização para ~/Dotfiles
# Versão: 2.0.1
# Objetivo: Migrar e padronizar todas as configurações para ~/Dotfiles
#################################################################################

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Paths
DOTFILES_DIR="$HOME/Dotfiles"
OLD_SYSTEM_PROMPT="/Users/luiz.sena88/system_prompt_tahoe_26.0.1"
OLD_VPS="/Users/luiz.sena88/10_INFRAESTRUTURA_VPS"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Criar estrutura de diretórios
create_structure() {
    log "Criando estrutura de diretórios..."
    
    mkdir -p "$DOTFILES_DIR"/{configs/{cursor,vscode,mcp,raycast,karabiner,extensions},scripts/{setup,install,sync,backup},templates/{devcontainer,github/workflows},docs}
    
    success "Estrutura criada"
}

# Migrar configurações
migrate_configs() {
    log "Migrando configurações..."
    
    # Cursor
    if [ -f "$OLD_SYSTEM_PROMPT/configs/cursor-settings.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/cursor-settings.json" "$DOTFILES_DIR/configs/cursor/settings.json"
        success "Cursor settings migrado"
    fi
    
    if [ -f "$OLD_SYSTEM_PROMPT/configs/cursor-keybindings.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/cursor-keybindings.json" "$DOTFILES_DIR/configs/cursor/keybindings.json"
        success "Cursor keybindings migrado"
    fi
    
    # VSCode
    if [ -f "$OLD_SYSTEM_PROMPT/configs/vscode-settings.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/vscode-settings.json" "$DOTFILES_DIR/configs/vscode/settings.json"
        success "VSCode settings migrado"
    fi
    
    # MCP
    if [ -f "$OLD_SYSTEM_PROMPT/configs/mcp-servers.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/mcp-servers.json" "$DOTFILES_DIR/configs/mcp/servers.json"
        success "MCP servers migrado"
    fi
    
    # Raycast
    if [ -f "$OLD_SYSTEM_PROMPT/configs/raycast-config.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/raycast-config.json" "$DOTFILES_DIR/configs/raycast/config.json"
        success "Raycast config migrado"
    fi
    
    # Karabiner
    if [ -f "$OLD_SYSTEM_PROMPT/configs/karabiner-config.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/karabiner-config.json" "$DOTFILES_DIR/configs/karabiner/config.json"
        success "Karabiner config migrado"
    fi
    
    # Extensions
    if [ -f "$OLD_SYSTEM_PROMPT/configs/extensions-universal.json" ]; then
        cp "$OLD_SYSTEM_PROMPT/configs/extensions-universal.json" "$DOTFILES_DIR/configs/extensions/recommended.json"
        success "Extensions migrado"
    fi
}

# Migrar scripts
migrate_scripts() {
    log "Migrando scripts..."
    
    # Setup scripts
    if [ -f "$OLD_SYSTEM_PROMPT/scripts/setup-master.sh" ]; then
        cp "$OLD_SYSTEM_PROMPT/scripts/setup-master.sh" "$DOTFILES_DIR/scripts/setup/master.sh"
        chmod +x "$DOTFILES_DIR/scripts/setup/master.sh"
        success "Setup master migrado"
    fi
    
    if [ -f "$OLD_SYSTEM_PROMPT/scripts/setup-ubuntu.sh" ]; then
        cp "$OLD_SYSTEM_PROMPT/scripts/setup-ubuntu.sh" "$DOTFILES_DIR/scripts/setup/ubuntu.sh"
        chmod +x "$DOTFILES_DIR/scripts/setup/ubuntu.sh"
        success "Setup Ubuntu migrado"
    fi
    
    # Install scripts
    if [ -f "$OLD_SYSTEM_PROMPT/scripts/apply-cursor-config.sh" ]; then
        cp "$OLD_SYSTEM_PROMPT/scripts/apply-cursor-config.sh" "$DOTFILES_DIR/scripts/install/cursor.sh"
        chmod +x "$DOTFILES_DIR/scripts/install/cursor.sh"
        success "Install Cursor migrado"
    fi
    
    # Sync scripts
    if [ -f "$OLD_SYSTEM_PROMPT/scripts/sync-configs.sh" ]; then
        cp "$OLD_SYSTEM_PROMPT/scripts/sync-configs.sh" "$DOTFILES_DIR/scripts/sync/configs.sh"
        chmod +x "$DOTFILES_DIR/scripts/sync/configs.sh"
        success "Sync configs migrado"
    fi
    
    # Backup scripts
    if [ -f "$OLD_SYSTEM_PROMPT/scripts/backup-configs.sh" ]; then
        cp "$OLD_SYSTEM_PROMPT/scripts/backup-configs.sh" "$DOTFILES_DIR/scripts/backup/configs.sh"
        chmod +x "$DOTFILES_DIR/scripts/backup/configs.sh"
        success "Backup configs migrado"
    fi
}

# Migrar templates
migrate_templates() {
    log "Migrando templates..."
    
    if [ -d "$OLD_SYSTEM_PROMPT/templates" ]; then
        cp -r "$OLD_SYSTEM_PROMPT/templates/"* "$DOTFILES_DIR/templates/"
        success "Templates migrados"
    fi
}

# Migrar documentação
migrate_docs() {
    log "Migrando documentação..."
    
    if [ -f "$OLD_SYSTEM_PROMPT/SYSTEM_PROMPT_GLOBAL.md" ]; then
        cp "$OLD_SYSTEM_PROMPT/SYSTEM_PROMPT_GLOBAL.md" "$DOTFILES_DIR/docs/SYSTEM_PROMPT_GLOBAL.md"
        success "System Prompt Global migrado"
    fi
    
    if [ -f "$OLD_SYSTEM_PROMPT/RESUMO_EXECUCOES_COMPLEMENTADAS.md" ]; then
        cp "$OLD_SYSTEM_PROMPT/RESUMO_EXECUCOES_COMPLEMENTADAS.md" "$DOTFILES_DIR/docs/RESUMO_EXECUCOES.md"
        success "Resumo migrado"
    fi
    
    if [ -f "$OLD_SYSTEM_PROMPT/README.md" ]; then
        cp "$OLD_SYSTEM_PROMPT/README.md" "$DOTFILES_DIR/docs/README_SYSTEM_PROMPT.md"
        success "README migrado"
    fi
}

# Atualizar scripts para usar DOTFILES_DIR
update_scripts() {
    log "Atualizando scripts para usar ~/Dotfiles..."
    
    # Atualizar master.sh
    if [ -f "$DOTFILES_DIR/scripts/setup/master.sh" ]; then
        sed -i '' "s|system_prompt_tahoe_26.0.1|Dotfiles|g" "$DOTFILES_DIR/scripts/setup/master.sh" 2>/dev/null || \
        sed -i "s|system_prompt_tahoe_26.0.1|Dotfiles|g" "$DOTFILES_DIR/scripts/setup/master.sh"
        sed -i '' "s|REPO_ROOT=.*|REPO_ROOT=\"\$HOME/Dotfiles\"|g" "$DOTFILES_DIR/scripts/setup/master.sh" 2>/dev/null || \
        sed -i "s|REPO_ROOT=.*|REPO_ROOT=\"\$HOME/Dotfiles\"|g" "$DOTFILES_DIR/scripts/setup/master.sh"
    fi
    
    # Atualizar cursor.sh
    if [ -f "$DOTFILES_DIR/scripts/install/cursor.sh" ]; then
        sed -i '' "s|system_prompt_tahoe_26.0.1|Dotfiles|g" "$DOTFILES_DIR/scripts/install/cursor.sh" 2>/dev/null || \
        sed -i "s|system_prompt_tahoe_26.0.1|Dotfiles|g" "$DOTFILES_DIR/scripts/install/cursor.sh"
        sed -i '' "s|REPO_ROOT=.*|REPO_ROOT=\"\$HOME/Dotfiles\"|g" "$DOTFILES_DIR/scripts/install/cursor.sh" 2>/dev/null || \
        sed -i "s|REPO_ROOT=.*|REPO_ROOT=\"\$HOME/Dotfiles\"|g" "$DOTFILES_DIR/scripts/install/cursor.sh"
    fi
    
    success "Scripts atualizados"
}

# Criar README principal
create_readme() {
    log "Criando README principal..."
    
    cat > "$DOTFILES_DIR/README.md" << 'EOF'
# 🎯 Dotfiles - Configurações Globais Padronizadas

> **Versão**: 2.0.1  
> **Última Atualização**: 2025-01-17

## 📋 Visão Geral

Este repositório centraliza todas as configurações do ambiente de desenvolvimento, incluindo:

- ✅ **Editores**: Cursor 2.0, VSCode
- ✅ **Ferramentas**: Raycast, Karabiner-Elements
- ✅ **Protocolos**: MCP Servers
- ✅ **Ambientes**: macOS, Ubuntu VPS, DevContainers, Codespaces
- ✅ **Scripts**: Setup, instalação, sincronização e backup

## 📁 Estrutura

```
~/Dotfiles/
├── configs/
│   ├── cursor/          # Configurações Cursor 2.0
│   ├── vscode/          # Configurações VSCode
│   ├── mcp/             # MCP Servers
│   ├── raycast/         # Raycast
│   ├── karabiner/       # Karabiner-Elements
│   └── extensions/      # Extensões universais
├── scripts/
│   ├── setup/           # Scripts de setup
│   ├── install/         # Scripts de instalação
│   ├── sync/            # Scripts de sincronização
│   └── backup/          # Scripts de backup
├── templates/
│   ├── devcontainer/    # Templates DevContainer
│   └── github/          # GitHub Actions
└── docs/                # Documentação
```

## 🚀 Quick Start

### Instalação Completa (macOS)

```bash
cd ~/Dotfiles
./scripts/setup/master.sh
```

### Aplicar Configurações do Cursor

```bash
./scripts/install/cursor.sh
```

### Setup Ubuntu VPS

```bash
./scripts/setup/ubuntu.sh
```

## 📚 Documentação

- [System Prompt Global](docs/SYSTEM_PROMPT_GLOBAL.md)
- [Resumo de Execuções](docs/RESUMO_EXECUCOES.md)

## 🔄 Migração

Este repositório foi criado migrando configurações de:
- `~/system_prompt_tahoe_26.0.1`
- `~/10_INFRAESTRUTURA_VPS`

Todas as configurações foram padronizadas e centralizadas aqui.

---

**Mantido por**: Sistema de Configuração Global  
**Versão**: 2.0.1
EOF

    success "README criado"
}

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Migração e Padronização para ~/Dotfiles              ║"
    echo "║              Versão 2.0.1 - Global Setup                    ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    create_structure
    migrate_configs
    migrate_scripts
    migrate_templates
    migrate_docs
    update_scripts
    create_readme
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              MIGRAÇÃO CONCLUÍDA COM SUCESSO                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Todas as configurações foram migradas para ~/Dotfiles"
    echo ""
    echo "Próximos passos:"
    echo "1. Revise a estrutura em ~/Dotfiles"
    echo "2. Execute: cd ~/Dotfiles && ./scripts/setup/master.sh"
    echo "3. Configure tokens e secrets conforme necessário"
    echo ""
}

main "$@"

