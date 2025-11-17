# 🌍 Contexto Global Completo - Sistema de Desenvolvimento

**Versão**: 2.0.1
**Última Atualização**: 2025-01-17
**Localização**: `~/Dotfiles/context/global/`

---

## 📋 Visão Geral

Este documento fornece contexto completo sobre o ambiente de desenvolvimento, infraestrutura, credenciais e configurações para uso por todas as IAs (Cursor, VSCode, Claude, Gemini, ChatGPT).

---

## 🏗️ Arquitetura do Sistema

### Estrutura de Diretórios Global

```
~/Dotfiles/                    # ⭐ CENTRO DE GOVERANÇA GLOBAL
├── configs/                   # Configurações padronizadas
│   ├── cursor/               # Cursor 2.0
│   ├── vscode/               # VSCode
│   ├── mcp/                  # MCP Servers
│   ├── raycast/              # Raycast (macOS)
│   ├── karabiner/            # Karabiner (macOS)
│   └── extensions/           # Extensões universais
├── credentials/              # Credenciais locais (NUNCA commitar)
│   ├── oauth/                # OAuth credentials
│   ├── service-accounts/     # GCP Service Accounts
│   └── api-keys/             # API Keys locais
├── scripts/                  # Scripts de automação
│   ├── setup/                # Setup scripts
│   ├── install/              # Instalação
│   ├── sync/                 # Sincronização
│   ├── governance/           # Governança
│   └── context/              # Atualização de contexto
├── templates/                # Templates
│   ├── devcontainer/         # DevContainers
│   └── github/               # GitHub Actions
├── automation_1password/     # Automação 1Password
└── context/                  # Contexto para IAs
    ├── global/               # Contexto global
    ├── cursor/               # Contexto Cursor
    ├── vscode/               # Contexto VSCode
    ├── claude/               # Contexto Claude
    ├── gemini/               # Contexto Gemini
    └── chatgpt/              # Contexto ChatGPT
```

---

## 🖥️ Ambientes Suportados

### macOS Silicon (Tahoe 26.0.1)

**Localização Base**: `/Users/luiz.sena88/Dotfiles`

**Configurações**:

- Shell: zsh
- Editor: Cursor 2.0, VSCode
- Ferramentas: Raycast, Karabiner-Elements
- Homebrew: Gerenciador de pacotes
- 1Password CLI: Autenticação e credenciais

**Paths Importantes**:

- Cursor: `~/Library/Application Support/Cursor/User/`
- VSCode: `~/Library/Application Support/Code/User/`
- Raycast: `~/Library/Application Support/Raycast/`
- Karabiner: `~/.config/karabiner/`

### Ubuntu VPS 22.04+

**IP**: 147.79.81.59
**Domínio**: senamfo.com.br
**Provedor**: Hostinger

**Stack**:

- Coolify: Orquestração
- n8n: Automação
- Chatwoot: Atendimento
- Docker: Containers

**Configurações**:

- Shell: bash/zsh (configurado via `~/Dotfiles/scripts/shell/bashrc-ubuntu.sh`)
- Editor: VSCode Remote, Cursor Remote
- Docker: Instalado e configurado
- Firewall: UFW configurado

**Gerenciamento via API**:

- API Token: `HOSTINGER_API_TOKEN` (1Password: `API-VPS-HOSTINGER`)
- MCP Server: `hostinger-mcp` (configurado em `~/Dotfiles/configs/mcp-servers.json`)
- Documentação: `~/Dotfiles/docs/HOSTINGER_API_SETUP.md`
- Scripts Raycast: `~/Dotfiles/scripts/raycast/hostinger-api.sh`

### DevContainers

**Template**: `~/Dotfiles/templates/devcontainer/devcontainer.json`

**Features**:

- Node.js 20
- Python 3.11
- Docker-in-Docker
- Git, GitHub CLI

### GitHub Codespaces

**Workflow**: `~/Dotfiles/templates/github/workflows/codespace-setup.yml`

**Setup Automático**:

- Ferramentas base instaladas
- Node.js, Python, Docker
- Zsh + Oh My Zsh
- FZF, Ripgrep, Bat

---

## 🔐 Credenciais e Segurança

### 1Password - Fonte de Verdade

**Vault Principal**: `1p_macos` (macOS) ou `Personal` (fallback)

**Itens Padronizados**:

- `Gemini_API_Keys`: GEMINI_API_KEY, GOOGLE_API_KEY
- `GCP_Service_Account_gcp-ai-setup-24410`: Service Account JSON
- `API-VPS-HOSTINGER`: Hostinger API Token para gerenciamento de VPS
- Outros itens conforme necessário

**Sincronização**: `~/Dotfiles/scripts/sync/sync-1password-to-dotfiles.sh`

### Credenciais Locais (Governança)

**Localização**: `~/Dotfiles/credentials/`

**Estrutura**:

- `api-keys/*.local`: API keys locais (chmod 600)
- `service-accounts/*.json`: Service accounts (chmod 600)
- `oauth/*/oauth-client-secret.json`: OAuth credentials (chmod 600)
- `.env.local`: Variáveis de ambiente (chmod 600)

**⚠️ IMPORTANTE**: Todos os arquivos em `credentials/` estão no `.gitignore` e NUNCA devem ser commitados.

---

## 🔧 Configurações por Ferramenta

### Cursor 2.0

**Settings**: `~/Dotfiles/configs/cursor/settings.json`
**Keybindings**: `~/Dotfiles/configs/cursor/keybindings.json`
**Contexto**: `~/Dotfiles/context/cursor/CONTEXTO_CURSOR.md`

**Configurações Principais**:

- Projeto GCP: `gcp-ai-setup-24410`
- Gemini Code Assist: Configurado
- Extensões: Perfil universal instalado

### VSCode

**Settings**: `~/Dotfiles/configs/vscode/settings.json`
**Contexto**: `~/Dotfiles/context/vscode/CONTEXTO_VSCODE.md`

**Configurações Principais**:

- GitHub Copilot: Habilitado
- Gemini Code Assist: Configurado
- Extensões: Perfil universal instalado

### MCP Servers

**Config**: `~/Dotfiles/configs/mcp/servers.json`

**Servers Configurados**:

- filesystem, git, github, docker, kubernetes
- postgres, sqlite, memory
- brave-search, puppeteer
- Opcionais: slack, google-drive, gmail, notion, obsidian

---

## 🌐 Projeto GCP

**ID do Projeto**: `gcp-ai-setup-24410`
**Número**: `501288307921`
**Região**: `us-central1`

**Service Account**:

- Email: `gemini-vps-agent@gcp-ai-setup-24410.iam.gserviceaccount.com`
- Papel: `roles/aiplatform.user`
- Arquivo: `~/Dotfiles/credentials/service-accounts/gcp-ai-setup-24410.json`

**APIs Habilitadas**:

- Gemini API
- Google Sheets API
- Google Drive API

---

## 📦 Stack de Desenvolvimento

### Linguagens e Ferramentas

- **Node.js**: 20.x
- **Python**: 3.11
- **Docker**: Latest
- **Git**: Configurado globalmente
- **Terraform**: Instalado (Ubuntu)
- **Kubectl**: Instalado (Ubuntu)
- **Helm**: Instalado (Ubuntu)

### Extensões Universais

**Perfil**: `~/Dotfiles/configs/extensions/recommended.json`

**Categorias**:

- Formatters e Linters
- Linguagens (Python, TypeScript, Go, Rust, etc.)
- Web Development
- Remote e Containers
- Version Control
- DevOps
- IA e Automação

---

## 🔄 Fluxos de Trabalho

### Setup Inicial (Novo Ambiente)

1. **Clonar Dotfiles**:

   ```bash
   git clone <repo> ~/Dotfiles
   cd ~/Dotfiles
   ```

2. **Executar Setup Master**:

   ```bash
   ./scripts/setup/master.sh
   ```

3. **Sincronizar Credenciais**:

   ```bash
   ./scripts/sync/sync-1password-to-dotfiles.sh
   ```

4. **Configurar OAuth Local**:
   ```bash
   ./scripts/governance/setup-oauth-local.sh
   ```

### Atualização de Contexto

**Script**: `~/Dotfiles/scripts/context/update-global-context.sh`

**O que faz**:

- Coleta informações do sistema
- Atualiza contexto para todas as IAs
- Sincroniza configurações
- Gera relatórios

---

## 📝 Convenções e Padrões

### Nomenclatura

- **Arquivos**: kebab-case (`system-context-collector.sh`)
- **Diretórios**: kebab-case (`dev-containers/`)
- **Variáveis**: UPPER_SNAKE_CASE (`GCP_PROJECT_ID`)
- **Funções**: camelCase (`collectSystemInfo`)

### Paths Padronizados

- **Base**: `$HOME/Dotfiles` ou `~/Dotfiles`
- **Configs**: `~/Dotfiles/configs/`
- **Scripts**: `~/Dotfiles/scripts/`
- **Credentials**: `~/Dotfiles/credentials/` (local, não versionado)
- **Context**: `~/Dotfiles/context/`

### Versionamento

- Todas as configurações versionadas no Git
- Credenciais NUNCA versionadas
- Backups automáticos antes de mudanças
- Tags semânticas para releases

---

## 🚀 Comandos Rápidos

### macOS

```bash
# Setup completo
cd ~/Dotfiles && ./scripts/setup/master.sh

# Aplicar configurações Cursor
./scripts/install/cursor.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Atualizar contexto
./scripts/context/update-global-context.sh
```

### Ubuntu VPS

```bash
# Setup completo
cd ~/Dotfiles && ./scripts/setup/ubuntu.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Configurar OAuth local
./scripts/governance/setup-oauth-local.sh
```

---

## 🔍 Verificação de Configuração

### Checklist macOS

- [ ] Dotfiles em `~/Dotfiles`
- [ ] Cursor 2.0 instalado e configurado
- [ ] VSCode instalado e configurado
- [ ] Extensões instaladas
- [ ] 1Password CLI configurado
- [ ] Credenciais sincronizadas
- [ ] OAuth local configurado
- [ ] gcloud configurado com projeto correto

### Checklist Ubuntu VPS

- [ ] Dotfiles em `~/Dotfiles`
- [ ] Docker instalado
- [ ] Node.js e Python instalados
- [ ] Credenciais sincronizadas
- [ ] OAuth local configurado (se necessário)
- [ ] Firewall configurado

---

## 📚 Documentação Relacionada

- [System Prompt Global](../docs/SYSTEM_PROMPT_GLOBAL.md)
- [Padronização](../docs/PADRONIZACAO.md)
- [Governança de Dados](../../10_INFRAESTRUTURA_VPS/GOVERNANCA_DADOS.md)
- [GCP Project Config](../docs/GCP_PROJECT_CONFIG.md)
- [Gemini Code Assist Setup](../docs/GEMINI_CODE_ASSIST_SETUP.md)

### System Prompts Especializados

- **System Prompts**: `~/Dotfiles/prompts/system_prompts/` - Prompts especializados por IA
- **Claude**: `~/Dotfiles/prompts/system_prompts/4.0.prompt_claude_infraestrutura.md`
- **ChatGPT Codex**: `~/Dotfiles/prompts/system_prompts/4.1.prompt_chatgpt-codex_infraestrutura.md`
- **Gemini**: `~/Dotfiles/prompts/system_prompts/4.2.prompt_gemini_infraestrutura.md`
- **Cursor**: `~/Dotfiles/prompts/system_prompts/4.3.prompt_cursor_infraestrutura.md`
- **GitHub Copilot**: `~/Dotfiles/prompts/system_prompts/4.4.prompt_github-copilot_infraestrutura.md`

---

## 🔄 Atualização Automática

O contexto é atualizado automaticamente via:

- `~/Dotfiles/scripts/context/update-global-context.sh`
- Executado periodicamente ou manualmente
- Sincroniza com 1Password
- Atualiza todos os arquivos de contexto

---

**Última atualização**: 2025-01-17
**Versão**: 2.0.1
**Status**: ✅ Ativo e Mantido
