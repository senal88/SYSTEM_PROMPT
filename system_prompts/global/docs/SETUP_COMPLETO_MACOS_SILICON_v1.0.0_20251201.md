# 🚀 Setup Completo macOS Silicon - Like Windows (Execução Automática)

**Versão:** 1.0.0
**Data:** 2025-12-01
**Status:** ✅ Pronto para Execução Automática
**Sistema:** macOS Silicon (Tahoe 26.0.1)

---

## 📋 Visão Geral

Este documento fornece um **setup completo e automatizado** do macOS Silicon, similar à experiência Windows Setup Manager, integrado com seu contexto atual:

- ✅ **1Password CLI** - Gestão automática de secrets
- ✅ **Dotfiles** - Configurações versionadas
- ✅ **Raycast** - Launcher e automação
- ✅ **Homebrew Bundle** - Instalação automática de apps
- ✅ **Scripts de Automação** - Setup completo em um comando

---

## 🎯 Objetivo

Criar um sistema de setup automático que:

1. **Instala tudo automaticamente** (como Windows Setup Manager)
2. **Configura ambiente completo** (Homebrew, apps, ferramentas)
3. **Integra com 1Password** (secrets automáticos)
4. **Configura Raycast** (produtividade máxima)
5. **Versiona tudo** (replicável e rastreável)

---

## 🏗️ Arquitetura do Setup

```
┌─────────────────────────────────────────────────────────────┐
│         SETUP AUTOMÁTICO macOS SILICON                      │
│         (Like Windows Setup Manager)                        │
└─────────────────────────────────────────────────────────────┘

FASE 1: PRÉ-REQUISITOS
├── Verificar macOS Silicon
├── Instalar Xcode Command Line Tools
└── Instalar Homebrew

FASE 2: INSTALAÇÃO DE APPS
├── Homebrew Bundle (Brewfile)
├── Apps essenciais (Raycast, VS Code, Docker, etc)
└── Ferramentas CLI (Git, Node, Python, etc)

FASE 3: CONFIGURAÇÃO DO SISTEMA
├── Configurações macOS (preferências do sistema)
├── Shell (zsh + Oh-My-Zsh)
└── Terminal (iTerm2)

FASE 4: INTEGRAÇÃO COM DOTFILES
├── Clonar repositório Dotfiles
├── Configurar symlinks
└── Carregar configurações

FASE 5: CONFIGURAÇÃO 1PASSWORD
├── Instalar 1Password CLI
├── Configurar autenticação
└── Carregar secrets do vault 1p_macos

FASE 6: CONFIGURAÇÃO RAYCAST
├── Instalar extensões essenciais
├── Configurar atalhos
└── Integrar com scripts

FASE 7: VALIDAÇÃO E TESTES
├── Verificar instalações
├── Testar comandos
└── Validar configurações
```

---

## 📦 Estrutura de Arquivos

```
~/Dotfiles/
├── Brewfile                          # Lista completa de apps/packages
├── setup-macos-completo.sh          # Script principal (execução única)
├── config/
│   ├── macos/
│   │   ├── defaults.sh              # Configurações macOS
│   │   ├── dock.sh                  # Configuração Dock
│   │   └── finder.sh                # Configuração Finder
│   ├── shell/
│   │   ├── .zshrc                   # Configuração zsh
│   │   └── .zshenv                  # Variáveis de ambiente
│   └── raycast/
│       └── settings.json             # Configurações Raycast
└── scripts/
    └── setup/
        ├── install-homebrew.sh      # Instalação Homebrew
        ├── install-apps.sh          # Instalação via Brewfile
        ├── configure-system.sh      # Configuração sistema
        ├── setup-1password.sh       # Configuração 1Password
        └── setup-raycast.sh         # Configuração Raycast
```

---

## 🚀 Execução Automática Completa

### Opção 1: Setup Completo (Recomendado)

```bash
# Clonar Dotfiles (se ainda não tiver)
git clone https://github.com/senal88/SYSTEM_PROMPT.git ~/Dotfiles

# Executar setup completo
cd ~/Dotfiles/system_prompts/global/scripts
./setup-macos-completo-automatico_v1.0.0_20251201.sh
```

**Tempo estimado:** 30-60 minutos (dependendo da conexão)

### Opção 2: Setup por Fases

```bash
# Fase 1: Pré-requisitos
./setup-macos-fase1-pre-requisitos.sh

# Fase 2: Instalação de Apps
./setup-macos-fase2-apps.sh

# Fase 3: Configuração Sistema
./setup-macos-fase3-configuracao.sh

# Fase 4: Integração Dotfiles
./setup-macos-fase4-dotfiles.sh

# Fase 5: 1Password
./setup-macos-fase5-1password.sh

# Fase 6: Raycast
./setup-macos-fase6-raycast.sh

# Fase 7: Validação
./setup-macos-fase7-validacao.sh
```

---

## 📋 Brewfile Completo

### Estrutura do Brewfile

```brewfile
# ============================================================================
# Brewfile - Setup Completo macOS Silicon
# Versão: 1.0.0
# Data: 2025-12-01
# ============================================================================

# Taps
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"
tap "homebrew/services"

# ============================================================================
# FERRAMENTAS DE DESENVOLVIMENTO
# ============================================================================

# Version Control
brew "git"
brew "gh"                    # GitHub CLI
brew "git-lfs"              # Git Large File Storage

# Linguagens e Runtimes
brew "node@20"               # Node.js LTS
brew "python@3.12"           # Python
brew "go"                    # Go
brew "rust"                  # Rust

# Build Tools
brew "cmake"
brew "pkg-config"
brew "make"

# ============================================================================
# FERRAMENTAS CLI ESSENCIAIS
# ============================================================================

brew "curl"
brew "wget"
brew "jq"                    # JSON processor
brew "yq"                    # YAML processor
brew "fzf"                   # Fuzzy finder
brew "ripgrep"               # rg - grep melhorado
brew "fd"                    # find melhorado
brew "bat"                   # cat melhorado
brew "exa"                   # ls melhorado
brew "zoxide"                # cd inteligente
brew "starship"              # Prompt shell moderno
brew "htop"                  # Monitor de processos
brew "btop"                  # Monitor sistema moderno

# ============================================================================
# SEGURANÇA E SECRETS
# ============================================================================

brew "1password-cli"         # 1Password CLI
brew "gpg"                   # GPG encryption
brew "pass"                  # Password manager CLI

# ============================================================================
# APPS ESSENCIAIS (CASKS)
# ============================================================================

# Produtividade e Launcher
cask "raycast"               # Launcher principal
cask "alfred"                # Alternativa Raycast (opcional)

# Editores e IDEs
cask "visual-studio-code"    # VS Code
cask "cursor"                # Cursor IDE
cask "sublime-text"          # Editor rápido
cask "vim"                    # Editor terminal

# Terminal
cask "iterm2"                # Terminal moderno
cask "warp"                   # Terminal moderno alternativo

# Navegação de Arquivos
cask "forklift"              # File manager dual-pane
cask "path-finder"           # Finder avançado
cask "finder"                 # Finder nativo (já instalado)

# Gerenciamento de Janelas
cask "rectangle"             # Window management (gratuito)
cask "magnet"                 # Window management (pago)
cask "alt-tab"                # Alt+Tab como Windows

# Automação
cask "keyboard-maestro"       # Automação avançada
cask "hazel"                  # Automação de arquivos
cask "shortcuts"              # Atalhos macOS

# Monitoramento
cask "istat-menus"           # Monitor sistema completo
cask "monitorcontrol"         # Controle de monitores

# Cloud e Sincronização
cask "dropbox"               # Cloud storage
cask "google-drive"          # Google Drive
cask "onedrive"              # OneDrive

# Comunicação
cask "slack"                 # Comunicação equipe
cask "discord"               # Comunicação
cask "zoom"                  # Video conferência
cask "teams"                 # Microsoft Teams

# Navegadores
cask "google-chrome"         # Chrome
cask "firefox"               # Firefox
cask "brave-browser"        # Brave
cask "arc"                   # Arc browser

# ============================================================================
# FERRAMENTAS DE DESENVOLVIMENTO
# ============================================================================

# Containers e Virtualização
cask "docker"                # Docker Desktop
cask "orbstack"              # Docker alternativo (mais leve)
cask "vagrant"               # Virtualização
cask "utm"                   # Virtualização macOS

# Banco de Dados
cask "postgres-unofficial"   # PostgreSQL
cask "tableplus"             # Database client
cask "sequel-ace"            # MySQL client
cask "mongodb-compass"       # MongoDB client
cask "redis-insight"         # Redis client

# API e Testes
cask "postman"               # API testing
cask "insomnia"              # API client alternativo
cask "httpie"                # HTTP client CLI

# ============================================================================
# FERRAMENTAS DE IA E ML
# ============================================================================

cask "ollama"                # LLM local
cask "lm-studio"             # LLM Studio
cask "cursor"                # AI IDE (já listado acima)

# ============================================================================
# DESIGN E MÍDIA
# ============================================================================

cask "figma"                 # Design
cask "sketch"                # Design
cask "adobe-creative-cloud"  # Adobe Suite
cask "gimp"                  # Editor imagem gratuito
cask "imageoptim"            # Otimização imagens

# ============================================================================
# FONTES
# ============================================================================

cask "font-fira-code"        # Font para código
cask "font-jetbrains-mono"   # Font JetBrains
cask "font-meslo-lg-nerd-font" # Font Nerd Fonts

# ============================================================================
# OUTRAS FERRAMENTAS ÚTEIS
# ============================================================================

cask "the-unarchiver"        # Descompactar arquivos
cask "cheatsheet"           # Ver atalhos de teclado
cask "cleanmymac"           # Limpeza sistema
cask "little-snitch"         # Firewall
cask "bartender"             # Organizar menu bar
cask "hiddenbar"            # Esconder menu bar (gratuito)
```

---

## 🔧 Scripts de Automação

### Script Principal: `setup-macos-completo-automatico_v1.0.0_20251201.sh`

Este script executa **tudo automaticamente** em sequência:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Executa todas as fases automaticamente
./setup-macos-fase1-pre-requisitos.sh
./setup-macos-fase2-apps.sh
./setup-macos-fase3-configuracao.sh
./setup-macos-fase4-dotfiles.sh
./setup-macos-fase5-1password.sh
./setup-macos-fase6-raycast.sh
./setup-macos-fase7-validacao.sh
```

---

## 📝 Configurações macOS Automáticas

### Preferências do Sistema

O script configura automaticamente:

- ✅ **Dock:** Ocultar automaticamente, tamanho mínimo
- ✅ **Finder:** Mostrar extensões, caminhos, sidebar
- ✅ **Trackpad:** Gestos otimizados
- ✅ **Teclado:** Atalhos personalizados
- ✅ **Segurança:** Firewall, Gatekeeper
- ✅ **Energia:** Prevenção de sleep durante uso

### Configurações Específicas

```bash
# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock magnification -bool false

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Teclado
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

---

## 🔐 Integração com 1Password

### Configuração Automática

O script configura automaticamente:

1. **Instalação 1Password CLI**
   ```bash
   brew install 1password-cli
   ```

2. **Autenticação**
   ```bash
   op signin
   ```

3. **Configuração de Variáveis**
   ```bash
   # Adiciona ao .zshrc
   export OP_VAULT_MACOS="1p_macos"
   ```

4. **Carregamento Automático de Secrets**
   ```bash
   # Exemplo de uso em scripts
   export GITHUB_TOKEN=$(op read 'op://1p_macos/GitHub/copilot_token')
   export OPENAI_API_KEY=$(op read 'op://1p_macos/OpenAI/api_key')
   ```

---

## 🎯 Configuração Raycast

### Extensões Essenciais

O script instala e configura:

- ✅ **1Password** - Integração com vaults
- ✅ **GitHub** - Acesso rápido a repositórios
- ✅ **Spotify** - Controle de música
- ✅ **System** - Comandos do sistema
- ✅ **Scripts** - Execução de scripts customizados

### Atalhos Configurados

- `⌘ + Space` - Abrir Raycast (substitui Spotlight)
- `⌘ + Shift + P` - Command Palette
- `⌘ + E` - Quick Links

---

## ✅ Checklist de Validação

Após execução, o script valida:

- [ ] Homebrew instalado e funcionando
- [ ] Apps essenciais instalados
- [ ] 1Password CLI configurado
- [ ] Raycast instalado e configurado
- [ ] Dotfiles clonados e configurados
- [ ] Shell (zsh) configurado
- [ ] Terminal (iTerm2) configurado
- [ ] Variáveis de ambiente carregadas
- [ ] Secrets do 1Password acessíveis

---

## 🛠️ Troubleshooting

### Problema: Homebrew não instala

**Solução:**
```bash
# Instalar Xcode Command Line Tools primeiro
xcode-select --install

# Depois instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Problema: Apps não instalam via Cask

**Solução:**
```bash
# Verificar permissões
sudo chown -R $(whoami) /opt/homebrew

# Reinstalar Homebrew
brew doctor
```

### Problema: 1Password CLI não autentica

**Solução:**
```bash
# Verificar se 1Password Desktop está instalado
# Se não, usar Service Account Token
op signin --account my
```

---

## 📚 Documentação Relacionada

- **Organização Secrets:** `ORGANIZACAO_SECRETS_1PASSWORD_v1.0.0_20251201.md`
- **Configuração VPS:** `CONFIGURACAO_1PASSWORD_CONNECT_VPS_v1.0.0_20251201.md`
- **Scripts de Automação:** `system_prompts/global/scripts/`

---

## 🚀 Próximos Passos

1. **Executar Setup Completo**
   ```bash
   ./setup-macos-completo-automatico_v1.0.0_20251201.sh
   ```

2. **Personalizar Brewfile**
   - Adicionar/remover apps conforme necessidade
   - Versionar no Git

3. **Configurar Raycast**
   - Instalar extensões adicionais
   - Criar scripts customizados

4. **Manter Atualizado**
   - Executar `brew bundle` periodicamente
   - Atualizar Dotfiles regularmente

---

**Última Atualização:** 2025-12-01
**Versão:** 1.0.0
**Status:** ✅ Pronto para Execução
