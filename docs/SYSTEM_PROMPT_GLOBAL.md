# System Prompt Global Unificado - Stack Completo de Desenvolvimento

> **Versão**: 2.0.1  
> **Compatibilidade**: macOS Tahoe 26.0.1, Ubuntu 22.04+, DevContainers, Codespaces  
> **Última Atualização**: $(date +%Y-%m-%d)

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Princípios Fundamentais](#princípios-fundamentais)
3. [Regras de Comportamento Universal](#regras-de-comportamento-universal)
4. [Configurações por Ambiente](#configurações-por-ambiente)
5. [Padrões de Engenharia](#padrões-de-engenharia)
6. [Integrações e Ferramentas](#integrações-e-ferramentas)
7. [Templates e Scripts](#templates-e-scripts)

---

## 🎯 Visão Geral

Este System Prompt Global unifica e centraliza toda a configuração do stack de desenvolvimento, incluindo:

- ✅ **Editores**: Cursor 2.0, VSCode + GitHub Copilot Pro
- ✅ **Agentes IA**: Claude Pro, Gemini 2.5 Pro, ChatGPT 5 Codex
- ✅ **Ferramentas**: Raycast, Karabiner-Elements, CLI Tools
- ✅ **Ambientes**: macOS Silicon, Ubuntu VPS, DevContainers, Codespaces
- ✅ **Protocolos**: MCP Servers, GitHub Actions, Docker
- ✅ **Extensões**: Perfis universais para todos os editores

### Objetivo Principal

**Centralizar, unificar e globalizar** todo o stack de configuração em um único blueprint universal, pronto para aplicar em qualquer workspace, perfil, CLI, editor ou ambiente.

---

## 🧭 Princípios Fundamentais

### 1. **Consistência Universal**

- Mesmas configurações em todos os ambientes
- Mesmos atalhos e padrões de código
- Mesma estrutura de diretórios e arquivos

### 2. **Automação Total**

- Scripts de instalação para cada plataforma
- Configuração automática de extensões
- Setup de ambiente com um único comando

### 3. **Modularidade e Flexibilidade**

- Componentes independentes e reutilizáveis
- Configurações por ambiente específicas
- Fácil customização sem quebrar o sistema

### 4. **Documentação Integrada**

- Cada configuração documentada inline
- Guias de troubleshooting por ambiente
- Exemplos práticos e casos de uso

### 5. **Versionamento e Backup**

- Todas as configurações versionadas
- Backups automáticos antes de mudanças
- Histórico de alterações rastreável

---

## 📜 Regras de Comportamento Universal

### Para Todos os Agentes IA (Claude, GPT-5, Gemini)

#### **Comunicação**

- ✅ Sempre responder em **Português** (conforme preferência do usuário)
- ✅ Usar linguagem clara, técnica mas acessível
- ✅ Fornecer exemplos práticos quando relevante
- ✅ Citar código existente usando formato `startLine:endLine:filepath`

#### **Código e Arquivos**

- ✅ **SEMPRE** editar arquivos existentes ao invés de criar novos
- ✅ Preservar indentação e formatação original
- ✅ Validar sintaxe antes de aplicar mudanças
- ✅ Criar backups automáticos antes de edições críticas

#### **Ferramentas e Comandos**

- ✅ Preferir comandos nativos do sistema quando possível
- ✅ Usar ferramentas instaladas via Homebrew/apt antes de instalar novas
- ✅ Validar permissões antes de executar comandos administrativos
- ✅ Explicar o que cada comando faz antes de executar

#### **Contexto e Memória**

- ✅ Coletar contexto completo do sistema antes de configurar
- ✅ Manter histórico de configurações aplicadas
- ✅ Documentar decisões e escolhas técnicas
- ✅ Atualizar contexto após mudanças significativas

### Para Editores (Cursor, VSCode)

#### **Configurações**

- ✅ Usar configurações idênticas entre Cursor e VSCode quando possível
- ✅ Manter keybindings consistentes
- ✅ Instalar extensões via perfil recomendado
- ✅ Configurar formatters por linguagem

#### **Performance**

- ✅ Desabilitar extensões não utilizadas
- ✅ Configurar watchers para excluir node_modules/.git
- ✅ Usar auto-save com delay mínimo
- ✅ Habilitar inlay hints e IntelliSense completo

### Para CLI e Scripts

#### **Shell**

- ✅ Usar zsh como shell padrão no macOS
- ✅ Usar bash como shell padrão no Ubuntu
- ✅ Configurar completions para todas as ferramentas
- ✅ Criar aliases úteis e documentados

#### **Scripts**

- ✅ Sempre usar `set -e` para parar em erros
- ✅ Validar pré-requisitos antes de executar
- ✅ Criar logs informativos com cores
- ✅ Ser idempotente (pode executar múltiplas vezes)

---

## 🖥️ Configurações por Ambiente

### macOS Tahoe 26.0.1 (Silicon)

#### **Sistema Base**

```bash
# Dock sem apps recentes
defaults write com.apple.dock show-recents -bool FALSE

# Spaces separados por monitor
defaults write com.apple.spaces spans-displays -bool false

# Desativar animações
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1

# Teclas F1-F12 como padrão
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
```

#### **Ferramentas Essenciais**

- **Homebrew**: Gerenciador de pacotes
- **Raycast**: Launcher (substitui Spotlight)
- **Karabiner-Elements**: Remapeamento de teclas
- **Rectangle**: Gerenciamento de janelas estilo Windows

#### **Atalhos Globais**

- `Cmd + Space`: Raycast Launcher
- `F3`: Mission Control (todas janelas)
- `Option + F3`: Application Exposé (janelas do app)
- `Cmd + Tab`: Alternar aplicativos
- `Cmd + \``: Alternar janelas do mesmo app

### Ubuntu VPS 22.04+

#### **Sistema Base**

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar ferramentas essenciais
sudo apt install -y \
  git curl wget vim nano \
  build-essential \
  zsh bash-completion \
  docker.io docker-compose \
  nodejs npm python3 python3-pip
```

#### **Configuração Shell**

- **Zsh + Oh My Zsh**: Shell melhorado
- **Powerlevel10k**: Tema para zsh
- **FZF**: Busca fuzzy
- **Ripgrep**: Busca rápida em arquivos

#### **Docker e Containers**

- Docker instalado e configurado
- Docker Compose para orquestração
- Usuário adicionado ao grupo docker
- Configuração de devcontainers pronta

### DevContainers

#### **Estrutura Base**

```json
{
  "name": "Development Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/devcontainers/features/python:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "esbenp.prettier-vscode",
        "ms-python.python",
        "ms-vscode-remote.remote-containers"
      ]
    }
  }
}
```

### GitHub Codespaces

#### **Configuração**

- Usar `.devcontainer/devcontainer.json` existente
- Configurar secrets para APIs e tokens
- Habilitar GitHub Copilot
- Configurar port forwarding automático

---

## 🏗️ Padrões de Engenharia

### Estrutura de Diretórios

```
$HOME/
├── .config/
│   ├── cursor/              # Configurações Cursor 2.0
│   ├── vscode/              # Configurações VSCode
│   ├── karabiner/           # Configurações Karabiner
│   └── raycast/             # Configurações Raycast
├── .devcontainer/           # DevContainers templates
├── .github/                  # GitHub Actions e Codespaces
├── scripts/                  # Scripts de instalação
└── system_prompt_tahoe_26.0.1/  # Este repositório
```

### Convenções de Código

#### **Nomenclatura**

- **Arquivos**: kebab-case (`system-context-collector.sh`)
- **Diretórios**: kebab-case (`dev-containers/`)
- **Variáveis**: UPPER_SNAKE_CASE (`SYSTEM_CONTEXT_DIR`)
- **Funções**: camelCase (`collectSystemInfo`)

#### **Documentação**

- Comentários em português
- README.md em cada diretório importante
- Documentação inline para funções complexas
- Exemplos de uso em cada script

#### **Versionamento**

- Usar Git para versionamento
- Commits descritivos e atômicos
- Tags semânticas para releases
- CHANGELOG.md atualizado

---

## 🔌 Integrações e Ferramentas

### MCP Servers (Model Context Protocol)

#### **Servers Recomendados**

- **filesystem**: Acesso a arquivos do sistema
- **git**: Operações Git via MCP
- **github**: Integração com GitHub API
- **docker**: Gerenciamento de containers
- **kubernetes**: Operações K8s

#### **Configuração Base**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    }
  }
}
```

### GitHub Copilot Pro

#### **Configuração**

- Ativar em Settings → GitHub Copilot
- Habilitar Copilot Chat
- Configurar atalhos personalizados
- Integrar com extensões de linguagem

### Raycast

#### **Extensões Essenciais**

- GitHub
- VS Code / Cursor
- Clipboard Manager
- Snippets
- Script Commands
- AI Search (ChatGPT/Gemini)

#### **Atalhos Configurados**

- `Cmd + Space`: Launcher principal
- `Cmd + V`: Clipboard Manager
- `Cmd + X`: Power Menu
- `Cmd + Shift + S`: Scripts
- `Cmd + Shift + ;`: Snippets

### Karabiner-Elements

#### **Regras Base**

- **Caps Lock → Control**: Remapeamento padrão
- **F3 → Mission Control**: Tecla de função
- **Option + F3 → Application Windows**: Modificador
- **Cmd ↔ Option**: Troca de modificadores (opcional)

---

## 📦 Templates e Scripts

### Scripts de Instalação

#### **macOS**

- `setup-macos.sh`: Setup completo do macOS
- `cursor-2.0-setup.sh`: Configuração Cursor
- `system-context-collector.sh`: Coleta de contexto

#### **Ubuntu**

- `setup-ubuntu.sh`: Setup completo Ubuntu VPS
- `install-docker.sh`: Instalação Docker
- `install-dev-tools.sh`: Ferramentas de desenvolvimento

#### **Universal**

- `install-extensions.sh`: Instala extensões em qualquer editor
- `sync-configs.sh`: Sincroniza configurações entre ambientes
- `backup-configs.sh`: Backup de todas as configurações

### Templates

#### **DevContainer**

- `.devcontainer/devcontainer.json`: Template base
- `.devcontainer/docker-compose.yml`: Orquestração
- `.devcontainer/Dockerfile`: Imagem customizada

#### **GitHub Actions**

- `.github/workflows/ci.yml`: CI básico
- `.github/workflows/codespace-setup.yml`: Setup Codespaces

#### **MCP**

- `mcp-servers.json`: Configuração MCP servers
- `mcp-manifest.json`: Manifesto MCP

---

## 🚀 Quick Start

### Instalação Rápida (macOS)

```bash
# Clone o repositório
git clone <repo-url> ~/system_prompt_tahoe_26.0.1
cd ~/system_prompt_tahoe_26.0.1

# Execute setup completo
./init-cursor-macos.sh
```

### Instalação Rápida (Ubuntu)

```bash
# Clone o repositório
git clone <repo-url> ~/system_prompt_tahoe_26.0.1
cd ~/system_prompt_tahoe_26.0.1

# Execute setup completo
./setup-ubuntu.sh
```

### Aplicar Configurações em Novo Workspace

```bash
# Copiar configurações para novo projeto
./scripts/sync-configs.sh /path/to/new/project

# Ou usar template
cp -r templates/devcontainer-template .devcontainer
```

---

## 📚 Referências e Documentação

### Documentação Externa

- [Cursor 2.0 Docs](https://cursor.sh/docs)
- [VSCode Settings](https://code.visualstudio.com/docs/getstarted/settings)
- [MCP Protocol](https://modelcontextprotocol.io)
- [DevContainers](https://containers.dev)
- [GitHub Codespaces](https://docs.github.com/codespaces)

### Documentação Interna

- `README.md`: Visão geral do projeto
- `SETUP_GUIDE.md`: Guia de instalação completo
- `TROUBLESHOOTING.md`: Solução de problemas
- `CHANGELOG.md`: Histórico de mudanças

---

## 🔄 Manutenção e Atualização

### Atualizar Configurações

```bash
# Recoletar contexto do sistema
./system-context-collector.sh

# Reaplicar configurações
./cursor-2.0-setup.sh  # ou setup-ubuntu.sh

# Sincronizar entre ambientes
./scripts/sync-configs.sh
```

### Backup e Restore

```bash
# Criar backup
./scripts/backup-configs.sh

# Restaurar backup
./scripts/restore-configs.sh <backup-date>
```

---

## ✅ Checklist de Configuração

### macOS

- [ ] Homebrew instalado
- [ ] Raycast instalado e configurado
- [ ] Karabiner-Elements instalado
- [ ] Cursor 2.0 instalado
- [ ] VSCode instalado
- [ ] Extensões instaladas
- [ ] Atalhos configurados
- [ ] Contexto coletado

### Ubuntu VPS

- [ ] Sistema atualizado
- [ ] Docker instalado
- [ ] DevTools instalados
- [ ] Zsh configurado
- [ ] SSH configurado
- [ ] Git configurado

### DevContainers

- [ ] `.devcontainer/devcontainer.json` criado
- [ ] Features configuradas
- [ ] Extensões definidas
- [ ] Docker Compose configurado

### MCP Servers

- [ ] Servers instalados
- [ ] Configuração criada
- [ ] Testado e funcionando

---

**Fim do System Prompt Global**

_Este documento é vivo e deve ser atualizado conforme novas configurações e ferramentas são adicionadas ao stack._
