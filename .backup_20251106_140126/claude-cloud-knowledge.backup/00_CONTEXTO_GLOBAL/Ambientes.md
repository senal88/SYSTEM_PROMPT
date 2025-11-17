# Contexto Completo dos Ambientes - macOS Silicon + VPS Ubuntu

## 📋 Visão Geral

Este documento fornece contexto completo e detalhado dos ambientes de desenvolvimento e produção para estruturar o plano de ação final com melhores práticas e integrações.

---

## 🖥️ AMBIENTE 1: macOS Silicon (Dev)

### Identificação do Sistema

```
Hostname: MacBook-Pro
OS: macOS (darwin 25.0.0)
Architecture: arm64 (Apple Silicon)
Shell: Zsh (/bin/zsh)
User: luiz.sena88
Home: /Users/luiz.sena88
```

### Estrutura de Diretórios

```
/Users/luiz.sena88/
├── Dotfiles/                    # Configurações versionadas
│   ├── automation_1password/    # Automação 1Password
│   ├── context-engineering/    # Engenharia de contexto
│   ├── vscode/                 # Configurações VSCode/Cursor
│   └── raycast/                # Snippets Raycast
├── .config/
│   └── op/                     # Configuração 1Password
│       ├── op_config.sh
│       ├── vault_config.json
│       └── vault_data/
├── .zshrc                      # Configuração shell principal
├── .zprofile                   # Configuração shell (carregado primeiro)
└── database/
    └── BNI_DOCUMENTOS_BRUTOS/  # Projeto atual
```

### Configurações de Shell

**Arquivo: `~/.zprofile`**
- Homebrew: `/opt/homebrew/bin/brew`
- OP_CONNECT_*: Comentado (movido para op_config.sh)

**Arquivo: `~/.zshrc`**
- DOTFILES_HOME: `$HOME/Dotfiles`
- Módulos modulares: path.zsh, aliases.zsh, functions.zsh, keys.zsh
- Pyenv: Inicializado
- NVM: Bash completion
- Micromamba: Inicializado
- 1Password: Wrapper inteligente e funções
- Raycast: Aliases integrados

### 1Password - Configuração macOS

**Vault Padrão:** `1p_macos` (ID: `gkpsbgizlks2zknwzqpppnb2ze`)

**Configuração:**
- Arquivo: `~/.config/op/op_config.sh`
- Vault Mapping: Configurado
- CLI: Padrão (Connect desativado)
- Funções disponíveis:
  - `op-signin-auto()` - Login automático
  - `op-vault-switch()` - Trocar vault
  - `op-connect-enable()` - Ativar Connect
  - `op-connect-disable()` - Desativar Connect
  - `op-config-check()` - Verificar configuração

**Scripts:**
- `op-export-vault.sh` - Exportar dados das vaults
- `op-init.sh` - Inicialização automática

### Ferramentas Instaladas

**Gerenciadores de Pacotes:**
- Homebrew: `/opt/homebrew`
- Pyenv: Gerenciamento Python
- NVM: Gerenciamento Node.js
- Micromamba: Gerenciamento conda

**Editores:**
- VSCode: Instalado
- Cursor: Instalado
- Raycast: Instalado e configurado

**Automação:**
- Raycast: Snippets e shortcuts configurados
- 1Password CLI: v2.24.0+
- Scripts de automação em `~/Dotfiles/automation_1password/scripts/`

### Variáveis de Ambiente Importantes

```bash
DOTFILES_HOME="$HOME/Dotfiles"
OP_CONFIG_DIR="$HOME/.config/op"
OP_DEFAULT_VAULT="gkpsbgizlks2zknwzqpppnb2ze"  # 1p_macos
PATH="/opt/homebrew/bin:$PATH"
```

### Portas e Serviços Locais

**Docker Compose (stack-local):**
- Traefik: 80, 443, 8080
- Portainer: 9443
- PostgreSQL: 5432
- NocoDB: 8081
- n8n: 5678
- Grafana: 3000
- Redis: 6379
- Dify API: 5001
- Dify Web: 3001

**1Password Connect (se ativo):**
- Host: http://localhost:8080
- Token: Armazenado em vault_config.json

### Integrações Configuradas

**Raycast:**
- 1Password: Extensões instaladas
- Snippets: 1Password, Shell, Python
- Shortcuts: Configurados

**VSCode/Cursor:**
- Extensões: 1Password, Python, Docker, GitLens
- Snippets: 1Password, Python, Shell
- Settings: Configurados

---

## 🖥️ AMBIENTE 2: VPS Ubuntu (Prod)

### Identificação do Sistema

```
OS: Ubuntu Linux (versão a confirmar)
Architecture: x86_64 ou arm64
Shell: Bash (padrão) ou Zsh (se instalado)
User: A configurar
Home: /home/[user]/
```

### Estrutura de Diretórios Proposta

```
/home/[user]/
├── Dotfiles/                    # Clone do repositório dotfiles
│   ├── automation_1password/    # Automação 1Password
│   ├── context-engineering/    # Engenharia de contexto
│   └── vscode/                 # Configurações VSCode Remote
├── .config/
│   └── op/                     # Configuração 1Password
│       ├── op_config.sh
│       ├── vault_config.json
│       └── vault_data/
├── .bashrc ou .zshrc           # Configuração shell
└── infra/                      # Infraestrutura
    └── stack-prod/             # Docker Compose produção
```

### 1Password - Configuração VPS

**Vault Padrão:** `1p_vps` (ID: `oa3tidekmeu26nxiier2qbi7v4`)

**Configuração:**
- Mesma estrutura do macOS
- Vault padrão diferente baseado em hostname
- CLI: Padrão (Connect disponível quando necessário)

### Serviços de Produção

**Docker Compose:**
- Traefik: Reverse proxy
- PostgreSQL: Banco de dados
- Redis: Cache
- NocoDB: Base de dados no-code
- n8n: Automação
- Grafana: Monitoramento
- Dify: LLM platform

**Portas:**
- 80, 443: HTTP/HTTPS
- 5432: PostgreSQL (interno)
- 6379: Redis (interno)
- Outras: Conforme necessário

### Segurança

**Firewall:**
- UFW: Configurado
- Portas abertas: 22 (SSH), 80, 443

**SSH:**
- Chaves SSH: `~/.ssh/`
- Config: `~/.ssh/config`
- Acesso: Via chave pública

### Acesso Remoto

**VSCode Remote SSH:**
- Extensão instalada
- Configuração em `~/.ssh/config`
- Snippets sincronizados automaticamente

---

## 🔗 Integrações e Serviços Externos

### 1Password Account

```
URL: https://my.1password.com/
Email: luiz.sena88@icloud.com
User ID: BOAC3NIIQZBF5CFNGZO36FBRIM
```

**Vaults Disponíveis:**
1. `1p_macos` (gkpsbgizlks2zknwzqpppnb2ze) - macOS
2. `1p_vps` (oa3tidekmeu26nxiier2qbi7v4) - VPS
3. `default_importado` (syz4hgfg6c62ndrxjmoortzhia) - Importado
4. `Personal` (7bgov3zmccio5fxc5v7irhy5k4) - Pessoal

### Hugging Face (senal88)

**Perfil:**
- Público: https://huggingface.co/senal88
- Space: https://huggingface.co/spaces/senal88/Qwen3-Coder-WebDev
- Endpoint: https://endpoints.huggingface.co/senal88/endpoints/all-minilm-l6-v2-bks

**Configurações:**
- Tokens: https://huggingface.co/settings/tokens
- SSH Keys: https://huggingface.co/settings/keys
- Billing: https://huggingface.co/settings/billing

### GitHub

**Repositórios:**
- Dotfiles: (a configurar)
- Projetos: (a configurar)

**Codespaces:**
- Configuração via `.devcontainer/`
- Setup automático via scripts

---

## 📊 Stack Tecnológica

### Backend
- Python: 3.11+
- Node.js: LTS (via nvm)
- Docker: Latest
- Docker Compose: v2+

### Banco de Dados
- PostgreSQL: 16-alpine
- Redis: alpine

### Infraestrutura
- Traefik: v2.10 (reverse proxy)
- Portainer: latest (gerenciamento Docker)
- NocoDB: latest (base de dados no-code)
- n8n: latest (automação)
- Grafana: latest (monitoramento)
- Dify: latest (LLM platform)

### DevOps
- 1Password CLI: v2.24.0+
- Git: Configurado
- SSH: Chaves configuradas

---

## 🔐 Segurança e Secrets

### Gerenciamento de Secrets
- **1Password CLI**: Padrão para todos os secrets
- **Vaults**: Separados por ambiente (macOS vs VPS)
- **Nunca hardcodar**: Secrets sempre via 1Password

### Configuração de Segurança
- SSH: Apenas chaves públicas
- Firewall: UFW configurado (VPS)
- Tokens: Armazenados em 1Password
- Credenciais: Via 1Password CLI

---

## 🚀 Fluxo de Trabalho

### Desenvolvimento Local (macOS)
1. Código em `~/database/BNI_DOCUMENTOS_BRUTOS/`
2. Testes locais via Docker Compose
3. Secrets via 1Password CLI (vault 1p_macos)
4. Deploy via scripts automatizados

### Produção (VPS)
1. Código deployado via Git
2. Secrets via 1Password CLI (vault 1p_vps)
3. Serviços via Docker Compose
4. Monitoramento via Grafana

### Codespaces
1. Setup automático via devcontainer
2. Configuração via dotfiles
3. Desenvolvimento colaborativo

---

## 📝 Observações Importantes

### Compatibilidade
- Scripts devem funcionar em bash e zsh
- Configurações devem ser portáveis
- Secrets nunca versionados

### Manutenção
- Atualizações via scripts de setup
- Backup automático de configurações
- Logs centralizados

### Extensibilidade
- Estrutura modular
- Fácil adicionar novos ambientes
- Templates reutilizáveis

---

**Última atualização:** 2025-11-04
**Versão:** 1.0.0

