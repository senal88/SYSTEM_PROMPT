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

# Infraestrutura Completa

## Stack Tecnológica

### Backend
- Python 3.11+
- Node.js LTS
- Docker & Docker Compose

### Banco de Dados
- PostgreSQL 16-alpine
- Redis alpine

### Serviços
- Traefik v2.10 (reverse proxy)
- Portainer (gerenciamento Docker)
- NocoDB (base de dados no-code)
- n8n (automação)
- Grafana (monitoramento)
- Dify (LLM platform)

## Portas e Serviços

### macOS Local
- Traefik: 80, 443, 8080
- Portainer: 9443
- PostgreSQL: 5432
- NocoDB: 8081
- n8n: 5678
- Grafana: 3000
- Redis: 6379
- Dify API: 5001
- Dify Web: 3001

## Arquitetura

```
macOS (Dev) → Docker Compose → Serviços Locais
VPS (Prod) → Docker Compose → Serviços Produção
Codespace → DevContainer → Ambiente Isolado
```
# Stack Tecnológica Completa

## Desenvolvimento
- macOS Silicon (Apple M-series)
- Zsh shell
- VSCode/Cursor
- Raycast

## DevOps
- 1Password CLI v2.24.0+
- GitHub CLI
- Hugging Face CLI
- Docker & Docker Compose

## Integrações
- 1Password (vaults separados por ambiente)
- GitHub (repositórios e Codespaces)
- Hugging Face (modelos e datasets)
- Cloudflare (DNS e SSL)

## Automação
- Scripts bash/zsh
- n8n workflows
- GitHub Actions (planejado)
# Automação Completa 1Password - macOS + VPS

Sistema completo de automação e gerenciamento do 1Password CLI para macOS Silicon e VPS Ubuntu.

## 🎯 Objetivo

Resolver definitivamente o conflito entre 1Password CLI e Connect, parametrizar secrets das vaults e automatizar a configuração em ambos os ambientes.

## 📋 Problema Resolvido

**Antes:** As variáveis `OP_CONNECT_HOST` e `OP_CONNECT_TOKEN` estavam sendo exportadas no `.zprofile`, causando conflito quando se tentava usar o 1Password CLI diretamente.

**Depois:** Sistema inteligente que separa CLI e Connect, com CLI como padrão e Connect disponível quando necessário.

## 🏗️ Estrutura

```
~/.config/op/
├── op_config.sh              # Configuração centralizada
├── vault_config.json          # Mapeamento de vaults e configurações
└── vault_data/               # Dados exportados das vaults
    ├── vault_1p_macos.json
    ├── vault_1p_vps.json
    ├── vault_personal.json
    └── vault_default_importado.json

~/Dotfiles/automation_1password/scripts/
├── op-export-vault.sh         # Exportar dados das vaults
└── op-init.sh                # Inicialização automática
```

## 🚀 Início Rápido

### 1. Inicialização Automática

```bash
# Carrega nova configuração no shell atual
source ~/.zshrc

# Ou execute o script de inicialização
op-init.sh
```

### 2. Verificar Configuração

```bash
op-config-check
```

Este comando verifica:
- ✅ Status de autenticação
- ✅ Configuração CLI/Connect
- ✅ Vault padrão configurado
- ✅ Vaults disponíveis

## 📖 Funções Disponíveis

### `op-signin-auto`
Auto-login com vault padrão baseado no contexto (macOS ou VPS).

```bash
op-signin-auto
```

### `op-vault-switch`
Trocar vault padrão dinamicamente.

```bash
# Por ID
op-vault-switch gkpsbgizlks2zknwzqpppnb2ze

# Por nome
op-vault-switch 1p_macos

# Listar vaults disponíveis
op-vault-switch
```

### `op-connect-enable`
Ativar modo Connect temporariamente (quando necessário).

```bash
op-connect-enable
```

### `op-connect-disable`
Desativar Connect e usar CLI (padrão).

```bash
op-connect-disable
```

### `op-config-check`
Verificar e corrigir configuração automaticamente.

```bash
op-config-check
```

## 🔧 Scripts

### `gh-setup.sh`
Configura GitHub CLI e Git com autenticação via 1Password.

**Uso:**
```bash
./gh-setup.sh
```

**Funcionalidades:**
- Configura GitHub CLI com token do 1Password
- Configura Git (user.name, user.email, branch padrão)
- Configura SSH para GitHub
- Configura repositório dotfiles

**Documentação:** Ver `scripts/UPDATE_DATASETS.md`

### `hf-setup.sh`
Configura Hugging Face CLI com autenticação via 1Password.

**Uso:**
```bash
./hf-setup.sh
```

**Funcionalidades:**
- Configura Hugging Face CLI com token do 1Password
- Cria funções helper para gerenciamento
- Configura variáveis de ambiente
- Integra com shell config

**Funções disponíveis após setup:**
- `hf-login` - Login automático
- `hf-deploy-model` - Deploy de modelo
- `hf-upload-dataset` - Upload de dataset
- `hf-query-endpoint` - Query no endpoint
- `hf-list-models` - Listar modelos
- `hf-list-datasets` - Listar datasets
- `hf-status` - Status do Hugging Face

**Documentação:** Ver `scripts/UPDATE_DATASETS.md`

### `op-export-vault.sh`

Exporta e parametriza dados de todas as vaults.

**Uso:**
```bash
# Exportar todas as vaults (padrão: JSON)
op-export-vault.sh

# Exportar vault específica
op-export-vault.sh --vault gkpsbgizlks2zknwzqpppnb2ze

# Exportar em formato YAML
op-export-vault.sh --format yaml

# Exportar todas em YAML
op-export-vault.sh --all --format yaml
```

**Saída:**
- Arquivos JSON/YAML em `~/.config/op/vault_data/`
- Um arquivo por vault
- Estrutura organizada por categoria e tipo de item

### `op-init.sh`

Script de inicialização automática que:
- Verifica estrutura de diretórios
- Verifica autenticação
- Configura CLI/Connect
- Configura vault padrão
- Lista vaults disponíveis

**Uso:**
```bash
op-init.sh
```

## 📦 Vaults Configuradas

| ID | Nome | Contexto |
|----|------|----------|
| `gkpsbgizlks2zknwzqpppnb2ze` | `1p_macos` | macOS (padrão) |
| `oa3tidekmeu26nxiier2qbi7v4` | `1p_vps` | VPS Ubuntu (padrão) |
| `syz4hgfg6c62ndrxjmoortzhia` | `default_importado` | Vault importada |
| `7bgov3zmccio5fxc5v7irhy5k4` | `Personal` | Vault pessoal |

## 🔄 Como Funciona

### Wrapper Inteligente do `op`

O comando `op` agora é uma função wrapper que:
1. **Sempre desativa Connect** antes de executar comandos CLI
2. Executa o comando `op` real
3. Restaura Connect se estava ativo (para compatibilidade)

Isso garante que o CLI funcione sempre, sem conflitos.

### Detecção Automática de Contexto

O sistema detecta automaticamente o ambiente:
- **macOS**: Usa vault `1p_macos` como padrão
- **VPS Ubuntu**: Usa vault `1p_vps` como padrão

### Configuração Centralizada

Todas as configurações estão centralizadas em:
- `~/.config/op/op_config.sh` - Variáveis e funções
- `~/.config/op/vault_config.json` - Mapeamento de vaults

## 🛠️ Troubleshooting

### Erro: "op signin doesn't work with Connect"

**Solução:** O wrapper já resolve isso automaticamente. Se ainda ocorrer:

```bash
# Desativar Connect manualmente
op-connect-disable

# Verificar configuração
op-config-check
```

### Erro: "Vault padrão não configurado"

**Solução:**
```bash
# Carregar configuração
source ~/.config/op/op_config.sh

# Ou executar inicialização
op-init.sh
```

### Erro: "Arquivo de configuração não encontrado"

**Solução:** Verifique se os arquivos existem:
```bash
ls -la ~/.config/op/
```

Se não existirem, recrie:
```bash
mkdir -p ~/.config/op/vault_data
# Os arquivos devem ser criados automaticamente
```

### Erro ao exportar vaults

**Solução:**
```bash
# Verificar se está logado
op whoami

# Se não estiver, fazer login
op-signin-auto

# Tentar exportar novamente
op-export-vault.sh
```

## 📝 Exemplos de Uso

### Exemplo 1: Uso Básico do CLI

```bash
# Listar vaults
op vault list

# Listar items de uma vault
op item list --vault 1p_macos

# Obter item específico
op item get "Nome do Item" --vault 1p_macos
```

### Exemplo 2: Trocar Vault Padrão

```bash
# Trocar para vault VPS
op-vault-switch 1p_vps

# Verificar vault atual
op-config-check
```

### Exemplo 3: Exportar e Usar Dados

```bash
# Exportar todas as vaults
op-export-vault.sh

# Ver dados exportados
cat ~/.config/op/vault_data/vault_1p_macos.json | jq '.[0]'

# Usar em script
jq -r '.[] | select(.title == "Meu Item") | .fields[0].value' \
  ~/.config/op/vault_data/vault_1p_macos.json
```

### Exemplo 4: Usar Connect Quando Necessário

```bash
# Ativar Connect
op-connect-enable

# Usar comandos Connect
op item list

# Desativar Connect
op-connect-disable
```

## 🔐 Segurança

- **Tokens Connect**: Armazenados em `~/.config/op/vault_config.json`
- **Dados Exportados**: Armazenados em `~/.config/op/vault_data/`
- **Permissões**: Arquivos com permissões restritas (600)

**Recomendação:** Não commitar arquivos de configuração em repositórios públicos.

## 🚀 Implantação na VPS Ubuntu

Para replicar na VPS:

1. **Copiar arquivos:**
```bash
# Do macOS
scp -r ~/.config/op user@vps:~/.config/
scp -r ~/Dotfiles/automation_1password user@vps:~/Dotfiles/
```

2. **Adicionar ao `.zshrc` ou `.bashrc` na VPS:**
```bash
# Carregar configuração 1Password
if [ -f "$HOME/.config/op/op_config.sh" ]; then
    source "$HOME/.config/op/op_config.sh"
fi

# Funções do .zshrc (copiar seção completa)
```

3. **Inicializar:**
```bash
op-init.sh
```

## 📚 Referências

- [1Password CLI Documentation](https://developer.1password.com/docs/cli)
- [1Password Connect Documentation](https://support.1password.com/connect/)

## 🔗 Integrações

### GitHub
- Script: `gh-setup.sh`
- Configuração completa via 1Password
- SSH keys gerenciadas via 1Password
- Ver `scripts/UPDATE_DATASETS.md` para detalhes

### Hugging Face
- Script: `hf-setup.sh`
- Funções helper para gerenciamento
- Endpoint configurado automaticamente
- Ver `scripts/UPDATE_DATASETS.md` para detalhes

## 🔄 Changelog

### 2025-11-05
- ✅ Adicionado `gh-setup.sh` - Setup completo do GitHub
- ✅ Adicionado `hf-setup.sh` - Setup completo do Hugging Face
- ✅ Criado `hf-functions.sh` - Funções helper Hugging Face
- ✅ Documentação atualizada em `scripts/UPDATE_DATASETS.md`

### 2025-11-04
- ✅ Resolvido conflito CLI/Connect definitivamente
- ✅ Criado wrapper inteligente do `op`
- ✅ Implementado sistema de configuração centralizada
- ✅ Criado script de exportação de vaults
- ✅ Criado script de inicialização automática
- ✅ Documentação completa

## 📞 Suporte

Para problemas ou dúvidas:
1. Execute `op-config-check` para diagnóstico
2. Verifique logs de erro
3. Consulte esta documentação

---

**Status:** ✅ Completo e Funcional
**Última atualização:** 2025-11-04

# Contexto Completo do Projeto - BNI Documentos e Infraestrutura

**Data de Criação:** 2025-11-04
**Horário:** 12:20 UTC / 09:20 BRT
**Última Atualização:** 2025-11-04 12:20 UTC
**Data de Obsoleto:** 2025-11-11 (Temporário - 7 dias)
**Status:** ⚠️ TEMPORÁRIO - Documento de contexto para deploy inicial

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Diretrizes para LLMs](#diretrizes-para-llms)
3. [Diretrizes para Humanos](#diretrizes-para-humanos)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Configuração Atual](#configuração-atual)
6. [Estado do Deploy](#estado-do-deploy)
7. [Variáveis e Segredos](#variáveis-e-segredos)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

### Projeto Principal

- **Repositório:** `BNI_DOCUMENTOS_BRUTOS`
- **Propósito:** Gestão documental para BNI (Banco Nacional de Imóveis)
- **Localização:** `/Users/luiz.sena88/database/BNI_DOCUMENTOS_BRUTOS`
- **GitHub:** `https://github.com/senal88/gestao-documentos-digitais.git`

### Infraestrutura

- **Ambiente Local:** macOS Silicon (`/Users/luiz.sena88/infra/stack-local`)
- **Ambiente Produção:** VPS Ubuntu (`/home/luiz.sena88/infra/stack-prod`)
- **Domínio:** `senamfo.com.br`
- **IP VPS:** `147.79.81.59`

### Stack de Serviços

- **Traefik:** Reverse proxy com SSL Let's Encrypt
- **Dify:** Plataforma LLM (API + Web)
- **N8N:** Automação de workflows
- **Grafana:** Monitoramento e dashboards
- **Nocodb:** Banco de dados NoSQL
- **Portainer:** Gerenciamento Docker
- **PostgreSQL:** Banco de dados principal
- **Redis:** Cache e filas

---

## 🤖 Diretrizes para LLMs

### Regras de Cursor (.cursorrules)

```markdown
# Cursor Rules - BNI Documentos
# Estas regras também funcionam com GitHub Copilot no Codespaces

## Linguagem e Estilo
- Sempre responder em **português**
- Usar português brasileiro
- Código deve ter comentários em português quando necessário

## Python
- Usar Python 3.11+
- Formatação: Black com linha máxima de 100 caracteres
- Imports organizados com isort
- Type hints quando apropriado
- Docstrings em português para funções públicas

## Estrutura de Arquivos
- Seguir a política de governança documental
- Nomes de arquivos sem espaços ou acentos
- Formato: `TIPO_ANO_MES_DESCRITOR.ext`

## Convenções
- Variáveis e funções em snake_case
- Classes em PascalCase
- Constantes em UPPER_SNAKE_CASE
- CSV encoding: UTF-8
- Datas: formato ISO 8601 (YYYY-MM-DD)

## Governança
- Sempre verificar POLITICA_GESTAO_DOCUMENTAL_BNI.md antes de criar arquivos
- Registrar mudanças em LOG_RENOMEACOES.csv quando renomear arquivos
- Manter consistência com TEMPLATE_NOME_ARQUIVO.md
```

### Comportamento Esperado de LLMs

1. **Sempre responder em português brasileiro**
2. **Respeitar estrutura de diretórios** conforme política documental
3. **Verificar políticas** antes de criar/modificar arquivos
4. **Usar snake_case** para variáveis Python
5. **Comentar código** em português quando necessário
6. **Validar formato** de nomes de arquivos (sem espaços/acentos)

### Contexto de Deploy Atual (Temporário)

⚠️ **IMPORTANTE:** Este documento é temporário e reflete o estado durante o deploy inicial.

**Status Atual:**

- Deploy em andamento na VPS Ubuntu
- Certificados SSL Let's Encrypt sendo obtidos
- Proxy Cloudflare desabilitado temporariamente
- 8/9 containers healthy (78% operacional)

**Ações Pendentes:**

- Obter certificados SSL para todos os domínios
- Reativar proxy Cloudflare após certificados
- Configurar Portainer (primeiro acesso)
- Resolver saúde do Portainer

---

## 👥 Diretrizes para Humanos

### Estrutura de Trabalho

1. **Documentação:** Sempre em `00_DOCUMENTACAO_POLITICAS/`
2. **Dados:** Em `00_ANALISES_E_DADOS/`
3. **Templates:** Consultar antes de criar novos arquivos
4. **Logs:** Registrar mudanças em `LOG_RENOMEACOES.csv`

### Política de Nomenclatura

- **Formato:** `TIPO_ANO_MES_DESCRITOR.ext`
- **Exemplo:** `RELATORIO_2025_11_ANALISE_DOCUMENTOS.pdf`
- **Sem espaços:** Usar underscore `_`
- **Sem acentos:** Remover acentuação

### Versionamento

- **Git:** Usar commits descritivos em português
- **Datas:** Sempre formato ISO 8601 (YYYY-MM-DD)
- **Logs:** Registrar todas as mudanças significativas

### Segurança

- **1Password:** Usar para todos os segredos
- **Vaults:** `1p_macos` (local) e `1p_vps` (produção)
- **Service Account Tokens:** Configurados globalmente, não em 1Password
- **Nunca commitar:** `.env`, tokens, senhas, chaves privadas

---

## 📁 Estrutura do Projeto

### BNI_DOCUMENTOS_BRUTOS

```
BNI_DOCUMENTOS_BRUTOS/
├── 00_DOCUMENTACAO_POLITICAS/
│   ├── POLITICA_GESTAO_DOCUMENTAL_BNI.md
│   ├── TEMPLATE_NOME_ARQUIVO.md
│   ├── LOG_RENOMEACOES.csv
│   └── GUIA_*.md (vários guias)
├── 00_ANALISES_E_DADOS/
│   ├── DADOS_VALIDADOS_PARA_DASHBOARD/
│   └── NOCODB_IMPORT/
├── .cursorrules
├── .gitignore
└── [outros diretórios conforme política]
```

### Infraestrutura

```
infra/
├── stack-local/          # macOS Silicon
│   ├── docker-compose.yml
│   └── .env
├── stack-prod/           # VPS Ubuntu
│   ├── docker-compose.yml
│   ├── .env
│   ├── scripts/
│   │   ├── deploy.sh
│   │   ├── inject-env.sh
│   │   └── healthcheck.sh
│   └── docs/
└── README.md
```

### hf_workspace (Hugging Face)

```
hf_workspace/
├── docs/                 # Documentação completa
├── scripts/              # Scripts de automação
├── config/               # Configurações
└── requirements.txt
```

---

## ⚙️ Configuração Atual

### Ambientes

#### macOS Silicon (Local)

- **Localização:** `/Users/luiz.sena88/infra/stack-local`
- **1Password Vault:** `1p_macos`
- **Domínio:** `localhost` (variável `DOMAIN_LOCAL`)
- **Status:** Funcional

#### VPS Ubuntu (Produção)

- **Localização:** `/home/luiz.sena88/infra/stack-prod`
- **1Password Vault:** `1p_vps`
- **Domínio:** `senamfo.com.br` (variável `DOMAIN_PROD`)
- **IP:** `147.79.81.59`
- **Status:** Deploy em andamento

### DNS e Cloudflare

**Domínio:** `senamfo.com.br`

**Registros Principais:**

- `senamfo.com.br` → A → 147.79.81.59
- `manager.senamfo.com.br` → A → 147.79.81.59
- Subdomínios → CNAME → manager.senamfo.com.br

**Status Atual (Temporário):**

- ⚠️ Proxy Cloudflare DESABILITADO (para obter certificados SSL)
- ⚠️ Todos os domínios devem estar com nuvem cinza (DNS only)
- ✅ Após certificados: Reativar proxy (nuvem laranja)

**Registros CAA:**

- `0 issue "letsencrypt.org"` ✅
- `0 issuewild "letsencrypt.org"` ✅
- ⚠️ Remover: `0 issue "mailto:..."` (incorreto)

### Docker Stacks

#### Stack Produção (stack-prod)

**Containers:**

1. **traefik** - Reverse proxy (unhealthy - aguardando certificados)
2. **dify-api** - API Dify (healthy)
3. **dify-web** - Web Dify (healthy)
4. **n8n** - Automação (healthy)
5. **grafana** - Monitoramento (healthy)
6. **nocodb** - Banco NoSQL (healthy)
7. **portainer** - Gerenciamento Docker (unhealthy - primeiro acesso)
8. **postgres** - PostgreSQL (healthy)
9. **redis** - Redis (healthy)

**Status:** 8/9 healthy (78% operacional)

**Networks:**

- `traefik_net` (bridge)

**Volumes:**

- `postgres_data`
- `redis_data`
- `grafana_data`
- `n8n_data`
- `dify_data`
- `nocodb_data`
- `data/letsencrypt` (certificados SSL)
- `data/portainer` (dados Portainer)

---

## 🔐 Variáveis e Segredos

### Gerenciamento de Segredos

**Ferramenta:** 1Password CLI (`op`)

**Vaults:**

- `1p_macos`: Segredos para ambiente local (macOS)
- `1p_vps`: Segredos para ambiente produção (VPS Ubuntu)

**Service Account Tokens:**

- **macOS:** `OP_SERVICE_ACCOUNT_TOKEN` configurado globalmente
- **VPS:** `OP_SERVICE_ACCOUNT_TOKEN` configurado globalmente
- ⚠️ **NUNCA** armazenar em 1Password (dependência circular)

### Variáveis Críticas (Produção)

**Cloudflare:**

- `CF_EMAIL` - Email do Cloudflare
- `CF_API_TOKEN` - Token API Cloudflare (op://1p_vps/Cloudflare API Token/credential)

**SMTP (Gmail):**

- `SMTP_HOST` - smtp.gmail.com
- `SMTP_PORT` - 587
- `SMTP_USER` - Email Gmail
- `SMTP_PASSWORD` - Senha de app Gmail (op://1p_vps/SMTP Gmail Prod/password)

**PostgreSQL:**

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

**Redis:**

- `REDIS_PASSWORD`

**Dify:**

- `CELERY_BROKER_URL` - redis://:password@redis:6379/0

**Traefik:**

- `TRAEFIK_DASHBOARD_AUTH` - Autenticação básica

**Domínio:**

- `DOMAIN_PROD` - senamfo.com.br

### Injeção de Variáveis

**Script:** `infra/stack-prod/scripts/inject-env.sh`

**Processo:**

1. Lê `env.op.template`
2. Resolve referências `op://` via 1Password CLI
3. Gera `.env` com valores reais
4. Docker Compose usa `.env`

**Template:** `infra/stack-prod/env.op.template`

---

## 🚀 Estado do Deploy

### Status Atual (2025-11-04 12:20 UTC)

**Fase:** Deploy em andamento - Aguardando certificados SSL

**Containers:**

- ✅ 8/9 healthy (88% operacional)
- ⚠️ Traefik: unhealthy (aguardando certificados)
- ⚠️ Portainer: unhealthy (requer primeiro acesso)

**Certificados SSL:**

- ⚠️ Em processo de obtenção
- ⚠️ Proxy Cloudflare desabilitado temporariamente
- ⏳ Aguardando Let's Encrypt emitir certificados

**DNS:**

- ✅ Todos apontando para 147.79.81.59
- ✅ /etc/hosts limpo na VPS
- ✅ Propagação completa

**Rate Limit Let's Encrypt:**

- ✅ Expirado (último erro às 10:31 UTC)
- ✅ Aguardando tentativas automáticas do Traefik

### Ações Pendentes

1. **Imediatas:**
   - ✅ Proxy Cloudflare desabilitado
   - ✅ DNS configurado
   - ⏳ Aguardar certificados SSL (5-20 minutos)

2. **Após Certificados:**
   - Reativar proxy Cloudflare (nuvem laranja)
   - Verificar saúde do Traefik
   - Configurar Portainer (primeiro acesso)

3. **Configurações:**
   - Portainer: Acessar e configurar ambiente Docker
   - Nocodb: Primeiro acesso e configuração inicial
   - Dify: Configuração de workspaces

### URLs de Acesso (Após Certificados)

- `https://senamfo.com.br` - Dify Web
- `https://api.senamfo.com.br` - Dify API
- `https://n8n.senamfo.com.br` - N8N
- `https://grafana.senamfo.com.br` - Grafana
- `https://traefik.senamfo.com.br` - Traefik Dashboard
- `https://portainer.senamfo.com.br` - Portainer
- `https://nocodb.senamfo.com.br` - Nocodb

---

## 🔧 Troubleshooting

### Problemas Comuns

#### 1. Certificados SSL Não Obtidos

**Sintomas:**

- Traefik unhealthy
- Logs: "Unable to obtain ACME certificate"
- Logs: "Cannot retrieve the ACME challenge"

**Soluções:**

1. Verificar proxy Cloudflare (deve estar desabilitado)
2. Verificar DNS (deve apontar para 147.79.81.59)
3. Verificar /etc/hosts na VPS (não deve ter entradas senamfo.com.br)
4. Limpar acme.json: `sudo rm -f data/letsencrypt/acme.json`
5. Reiniciar Traefik: `docker compose restart traefik`
6. Aguardar 5-20 minutos

#### 2. Portainer Unhealthy

**Sintomas:**

- Container restartando
- Erro: "database schema mismatch"

**Soluções:**

1. Remover banco antigo: `sudo rm -f data/portainer/portainer.db`
2. Reiniciar: `docker compose up -d portainer`
3. Acessar e configurar primeiro acesso

#### 3. 1Password CLI Não Autenticado

**Sintomas:**

- `op: command not found`
- `no active session found`

**Soluções:**

1. Instalar 1Password CLI
2. Configurar `OP_SERVICE_ACCOUNT_TOKEN` globalmente
3. Verificar: `op vault list`
4. NUNCA usar `op://` para Service Account Token

#### 4. DNS Resolvendo Incorretamente

**Sintomas:**

- `dig senamfo.com.br` retorna localhost
- Traefik não consegue validar domínios

**Soluções:**

1. Verificar /etc/hosts: `cat /etc/hosts | grep senamfo`
2. Remover entradas: `amfo.com.br/d"sudo sed -i "/sen /etc/hosts`
3. Verificar DNS externo: `dig +short senamfo.com.br A @8.8.8.8`

### Comandos Úteis

```bash
# Status dos containers
docker compose ps

# Logs do Traefik
docker compose logs traefik --tail 50

# Verificar certificados
dockcertificateer compose logs traefik | grep -i

# Reiniciar Traefik
docker compose restart traefik

# Verificar DNS
dig +short senamfo.com.br A

# Verificar 1Password
op vault list
op item get "Cloudflare API Token" --vault 1p_vps

# Injetar variáveis
cd ~/infra/stack-prod
bash scripts/inject-env.sh
```

---

## 📝 Notas Importantes

### Temporário vs Permanente

**Este documento é TEMPORÁRIO** e reflete o estado durante o deploy inicial.

**Data de Obsoleto:** 2025-11-11 (7 dias)

**Após obsoleto:**

- Atualizar com estado final do deploy
- Remover seções temporárias
- Manter apenas informações permanentes

### Próximas Atualizações

1. **Após certificados obtidos:**
   - Atualizar status do Traefik
   - Documentar processo de reativação do proxy
   - Adicionar URLs finais

2. **Após configuração completa:**
   - Remover seções temporárias
   - Documentar configurações finais
   - Adicionar procedimentos de manutenção

3. **Documentação permanente:**
   - Criar versão final do documento
   - Integrar com política documental
   - Manter atualizado

---

## 📚 Referências

### Documentação Interna

- `POLITICA_GESTAO_DOCUMENTAL_BNI.md` - Política de governança
- `TEMPLATE_NOME_ARQUIVO.md` - Template para novos arquivos
- `LOG_RENOMEACOES.csv` - Log de mudanças

### Documentação Externa

- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Let's Encrypt](https://letsencrypt.org/docs/)
- [Cloudflare DNS](https://developers.cloudflare.com/dns/)
- [1Password CLI](https://developer.1password.com/docs/cli/)

### Scripts e Automação

- `infra/stack-prod/scripts/deploy.sh` - Deploy completo
- `infra/stack-prod/scripts/inject-env.sh` - Injeção de variáveis
- `infra/stack-prod/scripts/healthcheck.sh` - Verificação de saúde
- `hf_workspace/scripts/` - Scripts diversos

---

## ✅ Checklist Final

### Para LLMs

- [x] Documento criado com data/horário
- [x] Diretrizes do .cursorrules incluídas
- [x] Contexto de deploy atual documentado
- [x] Estrutura de projeto mapeada
- [x] Variáveis e segredos documentados
- [x] Troubleshooting incluído

### Para Humanos

- [x] Visão geral do projeto
- [x] Estrutura de diretórios
- [x] Configurações atuais
- [x] Estado do deploy
- [x] Comandos úteis
- [x] Referências externas

### Próximos Passos

- [ ] Aguardar certificados SSL
- [ ] Reativar proxy Cloudflare
- [ ] Atualizar documento após deploy completo
- [ ] Criar versão permanente

---

**Documento criado em:** 2025-11-04 12:20 UTC
**Próxima revisão:** 2025-11-11
**Status:** ⚠️ TEMPORÁRIO - Deploy em andamento
# Credenciais NocoDB e PostgreSQL - 1Password

**Data:** 2025-11-04
**Gerenciador:** 1Password

---

## 🔐 Credenciais para Armazenar no 1Password

### 1. PostgreSQL - Banco de Dados

**Item:** `BNI - PostgreSQL Database`

**Campos:**

```
Host: postgres (ou nome do container)
Porta: 5432
Usuário: [seu_usuario_postgres]
Senha: [sua_senha_postgres]
Base de Dados: nocodb (ou nome da base)
Tipo: PostgreSQL
```

**URL de Conexão:**
```
postgresql://[usuario]:[senha]@[host]:5432/[base_dados]
```

**Notas:**
- Usado para conectar NocoDB ao banco de dados
- Mesmas credenciais usadas por outros serviços (n8n, etc.)

---

### 2. NocoDB - Token de API

**Item:** `BNI - NocoDB API Token`

**Campos:**

```
Nome: NOCODB-TOKEN-BNI-1
Token: S4yy49wsOsOh1zdL-_tnSL8I52Mc1xu6VP_rDnAl
URL: http://localhost:8081
Tipo: API Token
```

**Notas:**
- Usado para automações e scripts
- Não expor em repositórios públicos
- Token criado em: Account → Tokens

---

### 3. NocoDB - Conta de Administrador

**Item:** `BNI - NocoDB Admin`

**Campos:**

```
URL: http://localhost:8081
Email: [seu_email_admin]
Senha: [sua_senha_admin]
Tipo: Admin Account
```

**Notas:**
- Primeira conta criada no NocoDB
- Acesso completo ao projeto BNI_GESTAO_IMOBILIARIA

---

## 📋 Checklist de Segurança

- [ ] Credenciais PostgreSQL armazenadas no 1Password
- [ ] Token NocoDB armazenado no 1Password
- [ ] Conta admin NocoDB armazenada no 1Password
- [ ] Arquivo `nocodb_config.json` local (não versionado)
- [ ] Token adicionado ao `.gitignore`

---

## 🔗 Links 1Password

### Credenciais PostgreSQL

**Link direto:** [1Password - PostgreSQL](https://start.1password.com/open/i?a=RTTW3QYD6FGSBFTMETM63HNNO4&v=gkpsbgizlks2zknwzqpppnb2ze&i=ligf3nolmzjg7xqxswjs4uyowy&h=my.1password.com)

**Item no 1Password:** Procure por "BNI - PostgreSQL Database" ou "PostgreSQL"

**Campos disponíveis:**
- Host
- Porta
- Usuário
- Senha
- Base de Dados
- String de Conexão

### Outros Links Úteis

- **Token NocoDB:** [1Password - NocoDB Token](https://start.1password.com/open/i?a=RTTW3QYD6FGSBFTMETM63HNNO4&v=gkpsbgizlks2zknwzqpppnb2ze&i=wgtqezuczcjn6hv54g6g4b3l74&h=my.1password.com)

> **Nota:** Se os links não funcionarem, acesse o 1Password diretamente e procure por:
> - "BNI PostgreSQL"
> - "BNI NocoDB"
> - "PostgreSQL Database"

---

## 💡 Dicas

1. **Organização:** Crie uma pasta "BNI" no 1Password para todas as credenciais
2. **Tags:** Use tags como `database`, `api`, `nocodb` para facilitar busca
3. **Backup:** Certifique-se de que o 1Password está sincronizado
4. **Compartilhamento:** Se necessário, compartilhe apenas com membros da equipe autorizados

---

**Última atualização:** 2025-11-04

# Agent Skills

> Agent Skills are modular capabilities that extend Claude's functionality. Each Skill packages instructions, metadata, and optional resources (scripts, templates) that Claude uses automatically when relevant.

## Why use Skills

Skills are reusable, filesystem-based resources that provide Claude with domain-specific expertise: workflows, context, and best practices that transform general-purpose agents into specialists. Unlike prompts (conversation-level instructions for one-off tasks), Skills load on-demand and eliminate the need to repeatedly provide the same guidance across multiple conversations.

**Key benefits**:

* **Specialize Claude**: Tailor capabilities for domain-specific tasks
* **Reduce repetition**: Create once, use automatically
* **Compose capabilities**: Combine Skills to build complex workflows

<Note>
  For a deep dive into the architecture and real-world applications of Agent Skills, read our engineering blog: [Equipping agents for the real world with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills).
</Note>

## Using Skills

Anthropic provides pre-built Agent Skills for common document tasks (PowerPoint, Excel, Word, PDF), and you can create your own custom Skills. Both work the same way. Claude automatically uses them when relevant to your request.

**Pre-built Agent Skills** are available to all users on claude.ai and via the Claude API. See the [Available Skills](#available-skills) section below for the complete list.

**Custom Skills** let you package domain expertise and organizational knowledge. They're available across Claude's products: create them in Claude Code, upload them via the API, or add them in claude.ai settings.

<Note>
  **Get started:**

* For pre-built Agent Skills: See the [quickstart tutorial](/en/docs/agents-and-tools/agent-skills/quickstart) to start using PowerPoint, Excel, Word, and PDF skills in the API
* For custom Skills: See the [Agent Skills Cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills) to learn how to create your own Skills
</Note>

## How Skills work

Skills leverage Claude's VM environment to provide capabilities beyond what's possible with prompts alone. Claude operates in a virtual machine with filesystem access, allowing Skills to exist as directories containing instructions, executable code, and reference materials, organized like an onboarding guide you'd create for a new team member.

This filesystem-based architecture enables **progressive disclosure**: Claude loads information in stages as needed, rather than consuming context upfront.

### Three types of Skill content, three levels of loading

Skills can contain three types of content, each loaded at different times:

### Level 1: Metadata (always loaded)

**Content type: Instructions**. The Skill's YAML frontmatter provides discovery information:

```yaml  theme={null}
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---
```

Claude loads this metadata at startup and includes it in the system prompt. This lightweight approach means you can install many Skills without context penalty; Claude only knows each Skill exists and when to use it.

### Level 2: Instructions (loaded when triggered)

**Content type: Instructions**. The main body of SKILL.md contains procedural knowledge: workflows, best practices, and guidance:

````markdown  theme={null}
# PDF Processing

## Quick start

Use pdfplumber to extract text from PDFs:

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For advanced form filling, see [FORMS.md](FORMS.md).
````

When you request something that matches a Skill's description, Claude reads SKILL.md from the filesystem via bash. Only then does this content enter the context window.

### Level 3: Resources and code (loaded as needed)

**Content types: Instructions, code, and resources**. Skills can bundle additional materials:

```
pdf-skill/
├── SKILL.md (main instructions)
├── FORMS.md (form-filling guide)
├── REFERENCE.md (detailed API reference)
└── scripts/
    └── fill_form.py (utility script)
```

**Instructions**: Additional markdown files (FORMS.md, REFERENCE.md) containing specialized guidance and workflows

**Code**: Executable scripts (fill\_form.py, validate.py) that Claude runs via bash; scripts provide deterministic operations without consuming context

**Resources**: Reference materials like database schemas, API documentation, templates, or examples

Claude accesses these files only when referenced. The filesystem model means each content type has different strengths: instructions for flexible guidance, code for reliability, resources for factual lookup.

| Level                     | When Loaded             | Token Cost             | Content                                                               |
| ------------------------- | ----------------------- | ---------------------- | --------------------------------------------------------------------- |
| **Level 1: Metadata**     | Always (at startup)     | \~100 tokens per Skill | `name` and `description` from YAML frontmatter                        |
| **Level 2: Instructions** | When Skill is triggered | Under 5k tokens        | SKILL.md body with instructions and guidance                          |
| **Level 3+: Resources**   | As needed               | Effectively unlimited  | Bundled files executed via bash without loading contents into context |

Progressive disclosure ensures only relevant content occupies the context window at any given time.

### The Skills architecture

Skills run in a code execution environment where Claude has filesystem access, bash commands, and code execution capabilities. Think of it like this: Skills exist as directories on a virtual machine, and Claude interacts with them using the same bash commands you'd use to navigate files on your computer.

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=44c5eab950e209f613a5a47f712550dc" alt="Agent Skills Architecture - showing how Skills integrate with the agent's configuration and virtual machine" data-og-width="2048" width="2048" data-og-height="1153" height="1153" data-path="images/agent-skills-architecture.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=fc06568b957c9c3617ea341548799568 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=5569fe72706deda67658467053251837 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=83c04e9248de7082971d623f835c2184 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=d8e1900f8992d435088a565e098fd32a 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=b03b4a5df2a08f4be86889e6158975ee 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=b9cab267c168f6a480ba946b6558115c 2500w" />

**How Claude accesses Skill content:**

When a Skill is triggered, Claude uses bash to read SKILL.md from the filesystem, bringing its instructions into the context window. If those instructions reference other files (like FORMS.md or a database schema), Claude reads those files too using additional bash commands. When instructions mention executable scripts, Claude runs them via bash and receives only the output (the script code itself never enters context).

**What this architecture enables:**

**On-demand file access**: Claude reads only the files needed for each specific task. A Skill can include dozens of reference files, but if your task only needs the sales schema, Claude loads just that one file. The rest remain on the filesystem consuming zero tokens.

**Efficient script execution**: When Claude runs `validate_form.py`, the script's code never loads into the context window. Only the script's output (like "Validation passed" or specific error messages) consumes tokens. This makes scripts far more efficient than having Claude generate equivalent code on the fly.

**No practical limit on bundled content**: Because files don't consume context until accessed, Skills can include comprehensive API documentation, large datasets, extensive examples, or any reference materials you need. There's no context penalty for bundled content that isn't used.

This filesystem-based model is what makes progressive disclosure work. Claude navigates your Skill like you'd reference specific sections of an onboarding guide, accessing exactly what each task requires.

### Example: Loading a PDF processing skill

Here's how Claude loads and uses a PDF processing skill:

1. **Startup**: System prompt includes: `PDF Processing - Extract text and tables from PDF files, fill forms, merge documents`
2. **User request**: "Extract the text from this PDF and summarize it"
3. **Claude invokes**: `bash: read pdf-skill/SKILL.md` → Instructions loaded into context
4. **Claude determines**: Form filling is not needed, so FORMS.md is not read
5. **Claude executes**: Uses instructions from SKILL.md to complete the task

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0127e014bfc3dd3c86567aad8609111b" alt="Skills loading into context window - showing the progressive loading of skill metadata and content" data-og-width="2048" width="2048" data-og-height="1154" height="1154" data-path="images/agent-skills-context-window.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=a17315d47b7c5a85b389026b70676e98 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=267349b063954588d4fae2650cb90cd8 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0864972aba7bcb10bad86caf82cb415f 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=631d661cbadcbdb62fd0935b91bd09f8 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=c1f80d0e37c517eb335db83615483ae0 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=4b6d0f1baf011ff9b49de501d8d83cc7 2500w" />

The diagram shows:

1. Default state with system prompt and skill metadata pre-loaded
2. Claude triggers the skill by reading SKILL.md via bash
3. Claude optionally reads additional bundled files like FORMS.md as needed
4. Claude proceeds with the task

This dynamic loading ensures only relevant skill content occupies the context window.

## Where Skills work

Skills are available across Claude's agent products:

### Claude API

The Claude API supports both pre-built Agent Skills and custom Skills. Both work identically: specify the relevant `skill_id` in the `container` parameter along with the code execution tool.

**Prerequisites**: Using Skills via the API requires three beta headers:

* `code-execution-2025-08-25` - Skills run in the code execution container
* `skills-2025-10-02` - Enables Skills functionality
* `files-api-2025-04-14` - Required for uploading/downloading files to/from the container

Use pre-built Agent Skills by referencing their `skill_id` (e.g., `pptx`, `xlsx`), or create and upload your own via the Skills API (`/v1/skills` endpoints). Custom Skills are shared organization-wide.

To learn more, see [Use Skills with the Claude API](/en/api/skills-guide).

### Claude Code

[Claude Code](/en/docs/claude-code/overview) supports only Custom Skills.

**Custom Skills**: Create Skills as directories with SKILL.md files. Claude discovers and uses them automatically.

Custom Skills in Claude Code are filesystem-based and don't require API uploads.

To learn more, see [Use Skills in Claude Code](/en/docs/claude-code/skills).

### Claude Agent SDK

The [Claude Agent SDK](/en/api/agent-sdk/overview) supports custom Skills through filesystem-based configuration.

**Custom Skills**: Create Skills as directories with SKILL.md files in `.claude/skills/`. Enable Skills by including `"Skill"` in your `allowed_tools` configuration.

Skills in the Agent SDK are then automatically discovered when the SDK runs.

To learn more, see [Agent Skills in the SDK](/en/api/agent-sdk/skills).

### Claude.ai

[Claude.ai](https://claude.ai) supports both pre-built Agent Skills and custom Skills.

**Pre-built Agent Skills**: These Skills are already working behind the scenes when you create documents. Claude uses them without requiring any setup.

**Custom Skills**: Upload your own Skills as zip files through Settings > Features. Available on Pro, Max, Team, and Enterprise plans with code execution enabled. Custom Skills are individual to each user; they are not shared organization-wide and cannot be centrally managed by admins.

To learn more about using Skills in Claude.ai, see the following resources in the Claude Help Center:

* [What are Skills?](https://support.claude.com/en/articles/12512176-what-are-skills)
* [Using Skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
* [How to create custom Skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
* [Teach Claude your way of working using Skills](https://support.claude.com/en/articles/12580051-teach-claude-your-way-of-working-using-skills)

## Skill structure

Every Skill requires a `SKILL.md` file with YAML frontmatter:

```yaml  theme={null}
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
[Clear, step-by-step guidance for Claude to follow]

## Examples
[Concrete examples of using this Skill]
```

**Required fields**: `name` and `description`

**Field requirements**:

`name`:

* Maximum 64 characters
* Must contain only lowercase letters, numbers, and hyphens
* Cannot contain XML tags
* Cannot contain reserved words: "anthropic", "claude"

`description`:

* Must be non-empty
* Maximum 1024 characters
* Cannot contain XML tags

The `description` should include both what the Skill does and when Claude should use it. For complete authoring guidance, see the [best practices guide](/en/docs/agents-and-tools/agent-skills/best-practices).

## Security considerations

We strongly recommend using Skills only from trusted sources: those you created yourself or obtained from Anthropic. Skills provide Claude with new capabilities through instructions and code, and while this makes them powerful, it also means a malicious Skill can direct Claude to invoke tools or execute code in ways that don't match the Skill's stated purpose.

<Warning>
  If you must use a Skill from an untrusted or unknown source, exercise extreme caution and thoroughly audit it before use. Depending on what access Claude has when executing the Skill, malicious Skills could lead to data exfiltration, unauthorized system access, or other security risks.
</Warning>

**Key security considerations**:

* **Audit thoroughly**: Review all files bundled in the Skill: SKILL.md, scripts, images, and other resources. Look for unusual patterns like unexpected network calls, file access patterns, or operations that don't match the Skill's stated purpose
* **External sources are risky**: Skills that fetch data from external URLs pose particular risk, as fetched content may contain malicious instructions. Even trustworthy Skills can be compromised if their external dependencies change over time
* **Tool misuse**: Malicious Skills can invoke tools (file operations, bash commands, code execution) in harmful ways
* **Data exposure**: Skills with access to sensitive data could be designed to leak information to external systems
* **Treat like installing software**: Only use Skills from trusted sources. Be especially careful when integrating Skills into production systems with access to sensitive data or critical operations

## Available Skills

### Pre-built Agent Skills

The following pre-built Agent Skills are available for immediate use:

* **PowerPoint (pptx)**: Create presentations, edit slides, analyze presentation content
* **Excel (xlsx)**: Create spreadsheets, analyze data, generate reports with charts
* **Word (docx)**: Create documents, edit content, format text
* **PDF (pdf)**: Generate formatted PDF documents and reports

These Skills are available on the Claude API and claude.ai. See the [quickstart tutorial](/en/docs/agents-and-tools/agent-skills/quickstart) to start using them in the API.

### Custom Skills examples

For complete examples of custom Skills, see the [Skills cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills).

## Limitations and constraints

Understanding these limitations helps you plan your Skills deployment effectively.

### Cross-surface availability

**Custom Skills do not sync across surfaces**. Skills uploaded to one surface are not automatically available on others:

* Skills uploaded to Claude.ai must be separately uploaded to the API
* Skills uploaded via the API are not available on Claude.ai
* Claude Code Skills are filesystem-based and separate from both Claude.ai and API

You'll need to manage and upload Skills separately for each surface where you want to use them.

### Sharing scope

Skills have different sharing models depending on where you use them:

* **Claude.ai**: Individual user only; each team member must upload separately
* **Claude API**: Workspace-wide; all workspace members can access uploaded Skills
* **Claude Code**: Personal (`~/.claude/skills/`) or project-based (`.claude/skills/`); can also be shared via Claude Code Plugins

Claude.ai does not currently support centralized admin management or org-wide distribution of custom Skills.

### Runtime environment constraints

The exact runtime environment available to your skill depends on the product surface where you use it.

* **Claude.ai**:
  * **Varying network access**: Depending on user/admin settings, Skills may have full, partial, or no network access. For more details, see the [Create and Edit Files](https://support.claude.com/en/articles/12111783-create-and-edit-files-with-claude#h_6b7e833898) support article.
* **Claude API**:
  * **No network access**: Skills cannot make external API calls or access the internet
  * **No runtime package installation**: Only pre-installed packages are available. You cannot install new packages during execution.
  * **Pre-configured dependencies only**: Check the [code execution tool documentation](/en/docs/agents-and-tools/tool-use/code-execution-tool) for the list of available packages
* **Claude Code**:
  * **Full network access**: Skills have the same network access as any other program on the user's computer
  * **Global package installation discouraged**: Skills should only install packages locally in order to avoid interfering with the user's computer

Plan your Skills to work within these constraints.

## Next steps

<CardGroup cols={2}>
  <Card title="Get started with Agent Skills" icon="graduation-cap" href="/en/docs/agents-and-tools/agent-skills/quickstart">
    Create your first Skill
  </Card>

  <Card title="API Guide" icon="code" href="/en/api/skills-guide">
    Use Skills with the Claude API
  </Card>

  <Card title="Use Skills in Claude Code" icon="terminal" href="/en/docs/claude-code/skills">
    Create and manage custom Skills in Claude Code
  </Card>

  <Card title="Use Skills in the Agent SDK" icon="cube" href="/en/api/agent-sdk/skills">
    Use Skills programmatically in TypeScript and Python
  </Card>

  <Card title="Authoring best practices" icon="lightbulb" href="/en/docs/agents-and-tools/agent-skills/best-practices">
    Write Skills that Claude can use effectively
  </Card>
</CardGroup>
## FASE 3: Automação e Deploy ⚠️ (PENDENTE)

### 3.1 Scripts de Deploy para VPS

#### 3.1.1 Deploy Principal

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/deploy-to-vps.sh`

```bash
#!/bin/bash
# Deploy automatizado para VPS

set -euo pipefail

VPS_HOST="${1:-vps-hostname}"
VPS_USER="${2:-user}"
PROJECT_DIR="${3:-~/infra/stack-prod}"

# Validar pré-requisitos
op-config-check || exit 1

# Obter secrets do 1Password
export POSTGRES_PASSWORD=$(op item get "PostgreSQL Password" --vault 1p_vps --field password)
export GRAFANA_PASSWORD=$(op item get "Grafana Password" --vault 1p_vps --field password)

# Deploy via SSH
ssh "$VPS_USER@$VPS_HOST" << EOF
cd $PROJECT_DIR
git pull
docker-compose down
docker-compose up -d --build
docker-compose ps
EOF

echo "✅ Deploy concluído"
```

#### 3.1.2 Validação Pré-Deploy

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/validate-deploy.sh`

```bash
#!/bin/bash
# Validar ambiente antes de deploy

set -euo pipefail

# Verificar 1Password
op-config-check || exit 1

# Verificar Docker
docker ps > /dev/null || exit 1

# Verificar Git
git status > /dev/null || exit 1

# Verificar conexão VPS
ssh -o ConnectTimeout=5 "$VPS_USER@$VPS_HOST" echo "OK" || exit 1

echo "✅ Validação passou"
```

### 3.2 Backup Automatizado

#### 3.2.1 Script de Backup

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/backup-all.sh`

```bash
#!/bin/bash
# Backup completo de configurações

set -euo pipefail

BACKUP_DIR="$HOME/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup 1Password
op-export-vault.sh --all
cp -r ~/.config/op/vault_data "$BACKUP_DIR/"

# Backup dotfiles
cp -r ~/Dotfiles "$BACKUP_DIR/"

# Backup configurações shell
cp ~/.zshrc ~/.zprofile "$BACKUP_DIR/"

# Compactar
tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"
rm -rf "$BACKUP_DIR"

echo "✅ Backup criado: $BACKUP_DIR.tar.gz"
```

---

## FASE 4: Monitoramento e Segurança ⚠️ (PENDENTE)
# Integrações Configuradas

## 1Password
- Vault macOS: 1p_macos
- Vault VPS: 1p_vps
- Wrapper inteligente do CLI
- Funções de gerenciamento

## GitHub
- CLI configurado
- SSH keys via 1Password
- Dotfiles sincronizados

## Hugging Face
- CLI configurado
- Endpoint: senal88/endpoints/all-minilm-l6-v2-bks
- Funções helper disponíveis

## Cloudflare
- DNS configurado
- SSL/TLS via Traefik
- Zero Trust (planejado)
# Scripts de Automação Disponíveis

## 1Password
- `op-init.sh` - Inicialização automática
- `op-export-vault.sh` - Exportar dados das vaults
- `op-config-check` - Verificar configuração

## GitHub
- `gh-setup.sh` - Setup completo do GitHub

## Hugging Face
- `hf-setup.sh` - Setup completo do Hugging Face
- Funções: hf-login, hf-deploy-model, hf-upload-dataset, etc.

## Setup de Ambientes
- `setup-macos.sh` - Setup macOS
- `setup-vps.sh` - Setup VPS
- `setup-codespace.sh` - Setup Codespace

## Localização
Todos os scripts em: `~/Dotfiles/automation_1password/scripts/`
# Referências de API

## 1Password CLI
- Docs: https://developer.1password.com/docs/cli
- Shell Plugins: https://developer.1password.com/docs/cli/shell-plugins

## GitHub CLI
- Docs: https://cli.github.com/manual/
- API: https://docs.github.com/en/rest

## Hugging Face
- Docs: https://huggingface.co/docs
- API: https://huggingface.co/docs/api-inference/index
- Perfil: https://huggingface.co/senal88

## Docker Compose
- Docs: https://docs.docker.com/compose/
- Reference: https://docs.docker.com/compose/compose-file/

## Traefik
- Docs: https://doc.traefik.io/traefik/
- Configuration: https://doc.traefik.io/traefik/routing/providers/docker/
# Guia Rápido - Context Engineering

## 🚀 Setup em 1 Minuto

### macOS
```bash
cd ~/Dotfiles/context-engineering/scripts && ./setup-macos.sh
```

### VPS Ubuntu
```bash
cd ~/Dotfiles/context-engineering/scripts && ./setup-vps.sh
```

### Codespace
Setup automático via `.devcontainer/` ou manualmente:
```bash
cd ~/Dotfiles/context-engineering/scripts && ./setup-codespace.sh
```

## 💡 Snippets Mais Usados

### 1Password
- `1p-get` → Obter item do 1Password
- `1p-pass` → Obter senha
- `1p-signin` → Login automático
- `1p-check` → Verificar configuração

### Python
- `py-template` → Template completo de script
- `py-func` → Função com docstring
- `py-class` → Classe Python

### Shell
- `sh-template` → Template completo de script
- `sh-colors` → Definir cores
- `sh-log` → Funções de logging

## 📝 Como Usar

1. **Digite o prefixo** do snippet (ex: `1p-get`)
2. **Pressione Tab** ou Enter
3. **Preencha os placeholders** (${1}, ${2}, etc.)

## 🎯 Cursor Rules

O arquivo `.cursorrules` é lido automaticamente pelo Cursor no diretório do projeto ou em `~/.cursorrules` para configuração global.

## 🔧 Troubleshooting Rápido

**Snippets não aparecem?**
→ Execute o script de setup novamente e recarregue o editor

**Cursor Rules não funcionam?**
→ Verifique se `.cursorrules` está no diretório raiz do projeto

**Raycast snippets?**
→ Configure manualmente via UI usando os arquivos JSON como referência

## 📚 Mais Informações

Veja `README.md` para documentação completa.

# Troubleshooting

## 1Password
- Verificar: `op-config-check`
- Login: `op-signin-auto`
- Exportar: `op-export-vault.sh`

## GitHub
- Verificar: `gh auth status`
- Setup: `./gh-setup.sh`

## Hugging Face
- Verificar: `hf-status`
- Setup: `./hf-setup.sh`

## Docker
- Status: `docker-compose ps`
- Logs: `docker-compose logs -f`
- Restart: `docker-compose restart`
# Skills - Documentação Completa

## 📚 Arquivos Disponíveis

### 1. SKILLS_COMPLETE_GUIDE.md
**Guia completo e detalhado** sobre Agent Skills:
- Visão geral e conceitos
- Arquitetura e funcionamento
- Níveis de carregamento
- Onde funcionam (API, Code, SDK, Claude.ai)
- Estrutura e criação
- Segurança
- Limitações
- Melhores práticas
- Exemplos completos

**Uso**: Referência completa para entender tudo sobre Skills

### 2. SKILLS_QUICK_REFERENCE.md
**Referência rápida** com:
- Conceitos-chave
- Estrutura mínima
- Tabela de níveis de carregamento
- Pre-built Skills
- Limitações principais
- Checklist de criação

**Uso**: Consulta rápida durante desenvolvimento

### 3. SKILLS_EXAMPLES.md
**Exemplos práticos** de:
- Estruturas de Skills
- Casos de uso comuns
- Código de exemplo
- Templates

**Uso**: Inspiração e referência para criar seus próprios Skills

---

## 🎯 Quando Consultar Cada Arquivo

### SKILLS_COMPLETE_GUIDE.md
- Quando precisa entender arquitetura completa
- Quando cria Skills complexos
- Quando precisa entender limitações
- Quando trabalha com segurança

### SKILLS_QUICK_REFERENCE.md
- Durante desenvolvimento
- Para consulta rápida
- Para validar estrutura
- Para checklist

### SKILLS_EXAMPLES.md
- Quando precisa de inspiração
- Para ver padrões de código
- Para entender estrutura prática
- Para começar um novo Skill

---

## 📋 Tópicos Principais

### Arquitetura
- Progressive Disclosure
- Filesystem-based
- Três níveis de carregamento
- Execução de scripts

### Criação
- Estrutura de diretórios
- Frontmatter YAML
- Instruções eficazes
- Scripts e recursos

### Segurança
- Fontes confiáveis
- Auditoria
- Riscos conhecidos
- Boas práticas

### Limitações
- Sincronização entre superfícies
- Restrições de rede
- Compartilhamento
- Ambiente de runtime

---

**Versão:** 1.0.0
**Baseado em:** Documentação oficial Anthropic

# Agent Skills - Guia Completo para Claude

## 📋 Visão Geral

**Agent Skills** são capacidades modulares que estendem a funcionalidade do Claude. Cada Skill empacota instruções, metadados e recursos opcionais (scripts, templates) que o Claude usa automaticamente quando relevante.

---

## 🎯 Por Que Usar Skills

Skills são recursos reutilizáveis baseados em filesystem que fornecem ao Claude expertise específica de domínio: workflows, contexto e melhores práticas que transformam agentes de propósito geral em especialistas.

### Benefícios Principais

* **Especializar Claude**: Adaptar capacidades para tarefas específicas de domínio
* **Reduzir repetição**: Criar uma vez, usar automaticamente
* **Compor capacidades**: Combinar Skills para construir workflows complexos

**Diferenciação**: Ao contrário de prompts (instruções de nível de conversa para tarefas únicas), Skills são carregados sob demanda e eliminam a necessidade de fornecer repetidamente a mesma orientação em múltiplas conversas.

---

## 🔧 Como Skills Funcionam

### Arquitetura Baseada em Filesystem

Skills aproveitam o ambiente VM do Claude para fornecer capacidades além do que é possível apenas com prompts. O Claude opera em uma máquina virtual com acesso a filesystem, permitindo que Skills existam como diretórios contendo instruções, código executável e materiais de referência.

### Progressive Disclosure (Divulgação Progressiva)

A arquitetura baseada em filesystem permite **divulgação progressiva**: Claude carrega informações em estágios conforme necessário, em vez de consumir contexto antecipadamente.

### Três Tipos de Conteúdo, Três Níveis de Carregamento

Skills podem conter três tipos de conteúdo, cada um carregado em momentos diferentes:

#### Level 1: Metadata (sempre carregado)

**Tipo de conteúdo**: Instruções. O frontmatter YAML do Skill fornece informações de descoberta:

```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---
```

**Carregamento**: O Claude carrega este metadata na inicialização e o inclui no system prompt. Esta abordagem leve significa que você pode instalar muitos Skills sem penalidade de contexto; o Claude só sabe que cada Skill existe e quando usá-lo.

**Custo de tokens**: ~100 tokens por Skill

#### Level 2: Instructions (carregado quando acionado)

**Tipo de conteúdo**: Instruções. O corpo principal de `SKILL.md` contém conhecimento processual: workflows, melhores práticas e orientações:

```markdown
# PDF Processing

## Quick start

Use pdfplumber to extract text from PDFs:

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For advanced form filling, see [FORMS.md](FORMS.md).
```

**Carregamento**: Quando você solicita algo que corresponde à descrição de um Skill, o Claude lê `SKILL.md` do filesystem via bash. Só então este conteúdo entra na janela de contexto.

**Custo de tokens**: Menos de 5K tokens

#### Level 3: Resources and Code (carregado conforme necessário)

**Tipos de conteúdo**: Instruções, código e recursos. Skills podem empacotar materiais adicionais:

```
pdf-skill/
├── SKILL.md (instruções principais)
├── FORMS.md (guia de preenchimento de formulários)
├── REFERENCE.md (referência detalhada de API)
└── scripts/
    └── fill_form.py (script utilitário)
```

**Conteúdo**:
- **Instruções**: Arquivos markdown adicionais (FORMS.md, REFERENCE.md) contendo orientações e workflows especializados
- **Código**: Scripts executáveis (fill_form.py, validate.py) que o Claude executa via bash; scripts fornecem operações determinísticas sem consumir contexto
- **Recursos**: Materiais de referência como schemas de banco de dados, documentação de API, templates ou exemplos

**Carregamento**: Claude acessa esses arquivos apenas quando referenciados. O modelo de filesystem significa que cada tipo de conteúdo tem diferentes pontos fortes: instruções para orientação flexível, código para confiabilidade, recursos para consulta factual.

**Custo de tokens**: Efetivamente ilimitado (código executado via bash não consome tokens)

### Tabela de Carregamento

| Nível | Quando Carregado | Custo de Tokens | Conteúdo |
|-------|------------------|-----------------|----------|
| **Level 1: Metadata** | Sempre (na inicialização) | ~100 tokens por Skill | `name` e `description` do frontmatter YAML |
| **Level 2: Instructions** | Quando Skill é acionado | Menos de 5K tokens | Corpo do SKILL.md com instruções e orientações |
| **Level 3+: Resources** | Conforme necessário | Efetivamente ilimitado | Arquivos empacotados executados via bash sem carregar conteúdo no contexto |

A divulgação progressiva garante que apenas conteúdo relevante ocupe a janela de contexto a qualquer momento.

---

## 🏗️ Arquitetura de Skills

### Ambiente de Execução

Skills executam em um ambiente de execução de código onde o Claude tem:
- Acesso a filesystem
- Comandos bash
- Capacidades de execução de código

**Analogia**: Skills existem como diretórios em uma máquina virtual, e o Claude interage com eles usando os mesmos comandos bash que você usaria para navegar arquivos no seu computador.

### Como Claude Acessa Conteúdo de Skill

Quando um Skill é acionado:

1. **Claude usa bash**: `bash: read pdf-skill/SKILL.md` → Instruções carregadas no contexto
2. **Claude determina**: Se precisa de arquivos adicionais (ex: FORMS.md não é necessário para extração simples)
3. **Claude executa**: Usa instruções do SKILL.md para completar a tarefa
4. **Se necessário**: Lê arquivos adicionais via bash
5. **Se scripts mencionados**: Executa via bash e recebe apenas a saída (o código do script nunca entra no contexto)

### O Que Esta Arquitetura Permite

**Acesso a arquivos sob demanda**: Claude lê apenas os arquivos necessários para cada tarefa específica. Um Skill pode incluir dezenas de arquivos de referência, mas se sua tarefa só precisa do schema de vendas, o Claude carrega apenas esse arquivo. O restante permanece no filesystem consumindo zero tokens.

**Execução eficiente de scripts**: Quando o Claude executa `validate_form.py`, o código do script nunca carrega na janela de contexto. Apenas a saída do script (como "Validação passou" ou mensagens de erro específicas) consome tokens. Isso torna scripts muito mais eficientes do que ter o Claude gerar código equivalente sob demanda.

**Sem limite prático em conteúdo empacotado**: Como arquivos não consomem contexto até serem acessados, Skills podem incluir documentação abrangente de API, grandes datasets, exemplos extensos ou quaisquer materiais de referência que você precise. Não há penalidade de contexto para conteúdo empacotado que não é usado.

---

## 📍 Onde Skills Funcionam

Skills estão disponíveis em todos os produtos de agentes Claude:

### Claude API

**Suporte**: Pre-built Agent Skills e Custom Skills

**Funcionamento**: Especifique o `skill_id` relevante no parâmetro `container` junto com a ferramenta de execução de código.

**Pré-requisitos**: Requer três headers beta:
- `code-execution-2025-08-25` - Skills executam no container de execução de código
- `skills-2025-10-02` - Habilita funcionalidade de Skills
- `files-api-2025-04-14` - Necessário para upload/download de arquivos para/do container

**Pre-built Skills**: Use referenciando seu `skill_id` (ex: `pptx`, `xlsx`)

**Custom Skills**: Crie e faça upload via Skills API (`/v1/skills` endpoints). Custom Skills são compartilhados em toda a organização.

**Documentação**: [Use Skills with the Claude API](/en/api/skills-guide)

### Claude Code

**Suporte**: Apenas Custom Skills

**Funcionamento**: Crie Skills como diretórios com arquivos `SKILL.md`. O Claude descobre e usa automaticamente.

**Características**: Custom Skills no Claude Code são baseados em filesystem e não requerem uploads de API.

**Documentação**: [Use Skills in Claude Code](/en/docs/claude-code/skills)

### Claude Agent SDK

**Suporte**: Custom Skills através de configuração baseada em filesystem

**Funcionamento**: Crie Skills como diretórios com arquivos `SKILL.md` em `.claude/skills/`. Habilite Skills incluindo `"Skill"` na configuração `allowed_tools`.

**Características**: Skills no Agent SDK são automaticamente descobertos quando o SDK executa.

**Documentação**: [Agent Skills in the SDK](/en/api/agent-sdk/skills)

### Claude.ai

**Suporte**: Pre-built Agent Skills e Custom Skills

**Pre-built Skills**: Funcionam automaticamente nos bastidores quando você cria documentos. Claude os usa sem requerer configuração.

**Custom Skills**: Faça upload como arquivos zip através de Settings > Features. Disponível em planos Pro, Max, Team e Enterprise com execução de código habilitada. Custom Skills são individuais para cada usuário; não são compartilhados em toda a organização e não podem ser gerenciados centralmente por admins.

**Documentação**: Ver recursos no Claude Help Center

---

## 📝 Estrutura de Skill

### Requisito Básico

Todo Skill requer um arquivo `SKILL.md` com frontmatter YAML:

```yaml
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
[Clear, step-by-step guidance for Claude to follow]

## Examples
[Concrete examples of using this Skill]
```

### Campos Obrigatórios

**`name`**:
- Máximo 64 caracteres
- Deve conter apenas letras minúsculas, números e hífens
- Não pode conter tags XML
- Não pode conter palavras reservadas: "anthropic", "claude"

**`description`**:
- Deve ser não vazio
- Máximo 1024 caracteres
- Não pode conter tags XML
- Deve incluir tanto o que o Skill faz quanto quando o Claude deve usá-lo

### Estrutura de Diretório Recomendada

```
your-skill/
├── SKILL.md (obrigatório - instruções principais)
├── EXAMPLES.md (opcional - exemplos adicionais)
├── REFERENCE.md (opcional - referência detalhada)
├── scripts/
│   ├── validate.py (opcional - scripts executáveis)
│   └── process.py (opcional - scripts executáveis)
└── resources/
    ├── schema.json (opcional - recursos de referência)
    └── templates/ (opcional - templates)
```

---

## 🔒 Considerações de Segurança

### Aviso Importante

**Use Skills apenas de fontes confiáveis**: Aqueles que você criou ou obteve da Anthropic. Skills fornecem ao Claude novas capacidades através de instruções e código, e embora isso os torne poderosos, também significa que um Skill malicioso pode direcionar o Claude a invocar ferramentas ou executar código de maneiras que não correspondem ao propósito declarado do Skill.

### Principais Considerações de Segurança

* **Audite completamente**: Revise todos os arquivos empacotados no Skill: SKILL.md, scripts, imagens e outros recursos. Procure padrões incomuns como chamadas de rede inesperadas, padrões de acesso a arquivos ou operações que não correspondem ao propósito declarado do Skill

* **Fontes externas são arriscadas**: Skills que buscam dados de URLs externas apresentam risco particular, pois o conteúdo buscado pode conter instruções maliciosas. Mesmo Skills confiáveis podem ser comprometidos se suas dependências externas mudarem ao longo do tempo

* **Uso indevido de ferramentas**: Skills maliciosos podem invocar ferramentas (operações de arquivo, comandos bash, execução de código) de maneiras prejudiciais

* **Exposição de dados**: Skills com acesso a dados sensíveis podem ser projetados para vazar informações para sistemas externos

* **Trate como instalar software**: Use apenas Skills de fontes confiáveis. Tenha especial cuidado ao integrar Skills em sistemas de produção com acesso a dados sensíveis ou operações críticas

---

## 📦 Skills Disponíveis

### Pre-built Agent Skills

Os seguintes Pre-built Agent Skills estão disponíveis para uso imediato:

* **PowerPoint (pptx)**: Criar apresentações, editar slides, analisar conteúdo de apresentação
* **Excel (xlsx)**: Criar planilhas, analisar dados, gerar relatórios com gráficos
* **Word (docx)**: Criar documentos, editar conteúdo, formatar texto
* **PDF (pdf)**: Gerar documentos PDF formatados e relatórios

**Disponibilidade**: Claude API e claude.ai

**Tutorial**: [Quickstart tutorial](/en/docs/agents-and-tools/agent-skills/quickstart)

### Custom Skills

Para exemplos completos de Custom Skills, consulte o [Skills cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills).

---

## ⚠️ Limitações e Restrições

### Disponibilidade Entre Superfícies

**Custom Skills não sincronizam entre superfícies**. Skills enviados para uma superfície não estão automaticamente disponíveis em outras:

* Skills enviados para Claude.ai devem ser separadamente enviados para a API
* Skills enviados via API não estão disponíveis no Claude.ai
* Skills do Claude Code são baseados em filesystem e separados tanto do Claude.ai quanto da API

Você precisará gerenciar e enviar Skills separadamente para cada superfície onde deseja usá-los.

### Escopo de Compartilhamento

Skills têm diferentes modelos de compartilhamento dependendo de onde você os usa:

* **Claude.ai**: Apenas usuário individual; cada membro da equipe deve enviar separadamente
* **Claude API**: Em toda a workspace; todos os membros da workspace podem acessar Skills enviados
* **Claude Code**: Pessoal (`~/.claude/skills/`) ou baseado em projeto (`.claude/skills/`); também pode ser compartilhado via Claude Code Plugins

Claude.ai atualmente não suporta gerenciamento centralizado de admin ou distribuição organizacional de Custom Skills.

### Restrições de Ambiente de Runtime

O ambiente de runtime exato disponível para seu Skill depende da superfície do produto onde você o usa:

#### Claude.ai
* **Acesso à rede variável**: Dependendo das configurações de usuário/admin, Skills podem ter acesso total, parcial ou nenhum acesso à rede

#### Claude API
* **Sem acesso à rede**: Skills não podem fazer chamadas de API externas ou acessar a internet
* **Sem instalação de pacotes em runtime**: Apenas pacotes pré-instalados estão disponíveis. Você não pode instalar novos pacotes durante a execução
* **Apenas dependências pré-configuradas**: Verifique a [documentação da ferramenta de execução de código](/en/docs/agents-and-tools/tool-use/code-execution-tool) para a lista de pacotes disponíveis

#### Claude Code
* **Acesso total à rede**: Skills têm o mesmo acesso à rede que qualquer outro programa no computador do usuário
* **Instalação global de pacotes desencorajada**: Skills devem instalar pacotes apenas localmente para evitar interferir com o computador do usuário

**Planeje seus Skills para funcionar dentro dessas restrições.**

---

## 🎓 Melhores Práticas de Criação

### Escrevendo Descrições Eficazes

A `description` deve:
1. **Explicar o que o Skill faz**: Seja específico sobre as capacidades
2. **Indicar quando usar**: Inclua palavras-chave que acionam o Skill
3. **Ser concisa**: Máximo 1024 caracteres, mas seja direto

**Exemplo bom**:
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Exemplo ruim**:
```yaml
description: PDF stuff
```

### Estruturando Instruções

1. **Comece com Quick Start**: Seção rápida para tarefas comuns
2. **Organize por casos de uso**: Agrupe instruções relacionadas
3. **Inclua exemplos**: Código e exemplos concretos
4. **Referencie arquivos adicionais**: Use links para recursos adicionais quando apropriado

### Criando Scripts Eficientes

1. **Seja determinístico**: Scripts devem produzir resultados consistentes
2. **Forneça saída útil**: Mensagens de erro claras, saída formatada
3. **Documente dependências**: Liste pacotes necessários
4. **Teste antes de empacotar**: Certifique-se de que scripts funcionam

### Organizando Recursos

1. **Separe por tipo**: Instruções, scripts, recursos em subdiretórios
2. **Nomeie claramente**: Nomes de arquivos descritivos
3. **Documente estrutura**: README ou comentários explicando organização

---

## 📚 Exemplo Completo de Skill

### Estrutura

```
devops-automation/
├── SKILL.md
├── EXAMPLES.md
├── scripts/
│   ├── deploy.sh
│   └── validate.sh
└── resources/
    └── docker-compose.template.yml
```

### SKILL.md

```yaml
---
name: devops-automation
description: Automate DevOps tasks including deployment, validation, and infrastructure management. Use when working with Docker, deployment scripts, or infrastructure automation.
---

# DevOps Automation

## Quick Start

Deploy a service using Docker Compose:

```bash
bash scripts/deploy.sh production
```

## Common Tasks

### Deployment
See [EXAMPLES.md](EXAMPLES.md) for deployment scenarios.

### Validation
Run validation before deployment:
```bash
bash scripts/validate.sh
```

## Resources
- Docker Compose template: [resources/docker-compose.template.yml](resources/docker-compose.template.yml)
```

---

## 🔄 Fluxo de Uso Típico

1. **Claude detecta necessidade**: Baseado na descrição do Skill
2. **Claude carrega SKILL.md**: Via bash `read devops-automation/SKILL.md`
3. **Claude segue instruções**: Executa tarefas conforme SKILL.md
4. **Se necessário**: Carrega arquivos adicionais (EXAMPLES.md, etc.)
5. **Se scripts necessários**: Executa via bash e usa saída
6. **Completa tarefa**: Usando conhecimento do Skill

---

## 📊 Resumo de Decisões

### Quando Criar um Skill

✅ **Crie um Skill quando**:
- Você tem workflows repetitivos
- Precisa de conhecimento específico de domínio
- Quer compartilhar expertise entre conversas
- Precisa executar código determinístico

❌ **Não crie um Skill quando**:
- Tarefa é única e não será repetida
- Prompt simples é suficiente
- Não há código ou recursos complexos

### Quando Usar Pre-built vs Custom

**Use Pre-built**:
- Tarefas comuns (PowerPoint, Excel, Word, PDF)
- Quando pre-built já existe para sua necessidade

**Use Custom**:
- Workflows específicos da organização
- Conhecimento de domínio especializado
- Integrações com sistemas internos
- Processos únicos do seu ambiente

---

## 🔗 Recursos Adicionais

### Documentação Oficial
- [Quickstart Tutorial](/en/docs/agents-and-tools/agent-skills/quickstart)
- [API Guide](/en/api/skills-guide)
- [Best Practices](/en/docs/agents-and-tools/agent-skills/best-practices)

### Exemplos
- [Skills Cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills)

### Suporte
- Claude Help Center: Skills articles
- Community resources

---

**Última atualização:** 2025-11-05
**Versão:** 1.0.0
**Baseado em:** SKILLS.md oficial da Anthropic

# Skills - Exemplos Práticos

## 📚 Exemplos de Estrutura

### Exemplo 1: Skill Simples

```
simple-skill/
└── SKILL.md
```

**SKILL.md**:
```yaml
---
name: git-helper
description: Common Git operations and workflows. Use when user needs Git commands, branching strategies, or repository management.
---

# Git Helper

## Quick Commands

```bash
# Status
git status

# Create branch
git checkout -b feature/new-feature

# Commit
git commit -m "Description"
```
```

---

### Exemplo 2: Skill com Scripts

```
deployment-skill/
├── SKILL.md
└── scripts/
    ├── deploy.sh
    └── validate.sh
```

**SKILL.md**:
```yaml
---
name: deployment-automation
description: Automate deployment processes for applications. Use when deploying, validating infrastructure, or managing releases.
---

# Deployment Automation

## Deploy

Use the deployment script:
```bash
bash scripts/deploy.sh [environment]
```

## Validate

Validate before deploying:
```bash
bash scripts/validate.sh
```
```

---

### Exemplo 3: Skill com Recursos

```
api-integration/
├── SKILL.md
├── REFERENCE.md
├── scripts/
│   └── api-call.py
└── resources/
    ├── schema.json
    └── examples/
        └── request.json
```

**SKILL.md**:
```yaml
---
name: api-integration
description: Integrate with REST APIs, handle authentication, and process responses. Use when working with APIs, webhooks, or external services.
---

# API Integration

## Quick Start

See [REFERENCE.md](REFERENCE.md) for API documentation.

## Make API Call

```bash
python scripts/api-call.py --endpoint /users --method GET
```

## Schema

API schema: [resources/schema.json](resources/schema.json)
```

---

## 🎯 Casos de Uso Comuns

### DevOps Automation

```yaml
---
name: devops-tasks
description: Common DevOps operations including Docker, deployment, monitoring. Use when managing infrastructure, containers, or CI/CD pipelines.
---
```

### Data Processing

```yaml
---
name: data-processing
description: Process and analyze data files (CSV, JSON, Excel). Use when working with datasets, data transformation, or analysis.
---
```

### Documentation

```yaml
---
name: documentation-generator
description: Generate and format documentation from code or specifications. Use when creating docs, README files, or technical documentation.
---
```

---

**Versão:** 1.0.0

# Skills - Referência Rápida

## 🎯 Conceitos-Chave

**Skills** = Capacidades modulares que estendem Claude
**Progressive Disclosure** = Carregamento sob demanda (economia de tokens)
**Filesystem-based** = Skills existem como diretórios com arquivos

---

## 📋 Estrutura Mínima

```yaml
---
name: skill-name
description: O que faz e quando usar
---

# Conteúdo do Skill
```

---

## 🔄 Níveis de Carregamento

| Nível | Quando | Tokens | Conteúdo |
|-------|--------|--------|----------|
| 1. Metadata | Sempre | ~100 | name + description |
| 2. Instructions | Quando acionado | <5K | SKILL.md |
| 3. Resources | Conforme necessário | Ilimitado* | Scripts, recursos |

*Scripts executados via bash não consomem tokens

---

## 📦 Pre-built Skills Disponíveis

- `pptx` - PowerPoint
- `xlsx` - Excel
- `docx` - Word
- `pdf` - PDF

---

## 🎨 Onde Funcionam

- ✅ Claude API (pre-built + custom)
- ✅ Claude Code (custom apenas)
- ✅ Claude Agent SDK (custom)
- ✅ Claude.ai (pre-built + custom)

---

## ⚠️ Limitações

- Custom Skills NÃO sincronizam entre superfícies
- Compartilhamento varia por superfície
- Restrições de rede dependem do produto
- API: Sem acesso à rede
- Claude Code: Acesso total à rede

---

## 🔒 Segurança

- Use apenas Skills de fontes confiáveis
- Audite todos os arquivos antes de usar
- Cuidado com Skills que buscam dados externos
- Trate como instalar software

---

## 📝 Checklist de Criação

- [ ] SKILL.md com frontmatter YAML
- [ ] name válido (64 chars, lowercase, hyphens)
- [ ] description clara (o que + quando)
- [ ] Instruções organizadas
- [ ] Exemplos incluídos
- [ ] Scripts testados (se aplicável)
- [ ] Recursos documentados

---

**Versão:** 1.0.0

# Model Context Protocol (MCP) - Guia Completo para Claude

## 📋 Visão Geral

**Model Context Protocol (MCP)** é um protocolo padrão que permite que LLMs como Claude acessem informações e capacidades externas de forma segura e estruturada através de servidores MCP.

---

## 🎯 Conceitos Fundamentais

### O Que é MCP?

MCP é um protocolo que permite:
- **Servers** fornecem capacidades (tools, resources, prompts)
- **Clients** (como Claude) consomem essas capacidades
- **Comunicação** via JSON-RPC sobre STDIO ou HTTP

### Três Tipos de Capacidades

MCP servers podem fornecer três tipos principais de capacidades:

1. **Resources**: Dados tipo arquivo que podem ser lidos por clients (como respostas de API ou conteúdo de arquivos)
2. **Tools**: Funções que podem ser chamadas pelo LLM (com aprovação do usuário)
3. **Prompts**: Templates pré-escritos que ajudam usuários a realizar tarefas específicas

---

## 🏗️ Arquitetura MCP

### Componentes

```
┌─────────────┐
│   Client    │  (Claude, Claude for Desktop, etc.)
│  (LLM)      │
└──────┬──────┘
       │ JSON-RPC
       │ (STDIO ou HTTP)
       ▼
┌─────────────┐
│ MCP Server  │  (Fornece tools, resources, prompts)
│             │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ External    │  (APIs, Databases, Filesystems)
│ Services    │
└─────────────┘
```

### Protocolo de Comunicação

- **Transport**: STDIO (padrão) ou HTTP
- **Protocolo**: JSON-RPC 2.0
- **Formato**: Mensagens JSON estruturadas

---

## 🔧 Como Construir um MCP Server

### Tipos de Transport

#### STDIO (Standard Input/Output)
- **Padrão** para servidores MCP
- Comunicação via stdin/stdout
- **Importante**: Nunca escrever em stdout (apenas stderr)
- Ideal para scripts e processos locais

#### HTTP
- Comunicação via HTTP/HTTPS
- Logging em stdout permitido
- Ideal para serviços web e APIs remotas

---

## 📝 Implementação por Linguagem

### Python (Recomendado para Início)

#### Requisitos
- Python 3.10 ou superior
- MCP SDK 1.2.0 ou superior
- `uv` para gerenciamento de pacotes

#### Estrutura Básica

```python
from mcp.server.fastmcp import FastMCP

# Inicializar servidor
mcp = FastMCP("nome-do-servidor")

# Registrar tool
@mcp.tool()
async def minha_tool(parametro: str) -> str:
    """Descrição do que a tool faz.
    
    Args:
        parametro: Descrição do parâmetro
    """
    # Lógica da tool
    return "resultado"

# Executar servidor
def main():
    mcp.run(transport='stdio')

if __name__ == "__main__":
    main()
```

#### Logging em STDIO

**❌ NUNCA FAÇA:**
```python
print("Mensagem")  # Quebra JSON-RPC!
```

**✅ FAÇA:**
```python
import logging
logging.info("Mensagem")  # Vai para stderr
```

### Node.js/TypeScript

#### Requisitos
- Node.js 16 ou superior
- TypeScript
- `@modelcontextprotocol/sdk`

#### Estrutura Básica

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "nome-do-servidor",
  version: "1.0.0",
  capabilities: {
    tools: {},
  },
});

// Registrar tool
server.tool(
  "minha_tool",
  "Descrição da tool",
  {
    parametro: z.string().describe("Descrição")
  },
  async ({ parametro }) => {
    return {
      content: [{
        type: "text",
        text: "resultado"
      }]
    };
  }
);

// Executar servidor
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Servidor rodando");
}

main();
```

#### Logging em STDIO

**❌ NUNCA FAÇA:**
```javascript
console.log("Mensagem");  // Quebra JSON-RPC!
```

**✅ FAÇA:**
```javascript
console.error("Mensagem");  // stderr é seguro
```

### Java/Kotlin

#### Requisitos
- Java 17 ou superior
- Spring Boot 3.3.x (para Java)
- Kotlin SDK (para Kotlin)

#### Estrutura Básica (Java com Spring AI)

```java
@Service
public class MeuServico {
    
    @Tool(description = "Descrição da tool")
    public String minhaTool(
        @ToolParam(description = "Descrição") String parametro
    ) {
        // Lógica da tool
        return "resultado";
    }
}
```

### C#

#### Requisitos
- .NET 8 SDK ou superior
- `ModelContextProtocol` NuGet package

#### Estrutura Básica

```csharp
using ModelContextProtocol;

var builder = Host.CreateEmptyApplicationBuilder(settings: null);

builder.Services.AddMcpServer()
    .WithStdioServerTransport()
    .WithToolsFromAssembly();

var app = builder.Build();
await app.RunAsync();
```

---

## 🛠️ Exemplo Completo: Weather Server

### Estrutura do Projeto

```
weather-server/
├── weather.py (ou index.ts, etc.)
├── requirements.txt (ou package.json)
└── README.md
```

### Implementação Python Completa

```python
from typing import Any
import httpx
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("weather")

NWS_API_BASE = "https://api.weather.gov"
USER_AGENT = "weather-app/1.0"

async def make_nws_request(url: str) -> dict[str, Any] | None:
    """Fazer requisição à API NWS."""
    headers = {
        "User-Agent": USER_AGENT,
        "Accept": "application/geo+json"
    }
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(url, headers=headers, timeout=30.0)
            response.raise_for_status()
            return response.json()
        except Exception:
            return None

@mcp.tool()
async def get_alerts(state: str) -> str:
    """Obter alertas meteorológicos para um estado dos EUA.
    
    Args:
        state: Código de duas letras do estado (ex: CA, NY)
    """
    url = f"{NWS_API_BASE}/alerts/active/area/{state}"
    data = await make_nws_request(url)
    
    if not data or "features" not in data:
        return "Não foi possível buscar alertas."
    
    if not data["features"]:
        return "Nenhum alerta ativo para este estado."
    
    alerts = []
    for feature in data["features"]:
        props = feature["properties"]
        alert = f"""
Event: {props.get('event', 'Unknown')}
Area: {props.get('areaDesc', 'Unknown')}
Severity: {props.get('severity', 'Unknown')}
Description: {props.get('description', 'No description')}
"""
        alerts.append(alert)
    
    return "\n---\n".join(alerts)

@mcp.tool()
async def get_forecast(latitude: float, longitude: float) -> str:
    """Obter previsão do tempo para uma localização.
    
    Args:
        latitude: Latitude da localização
        longitude: Longitude da localização
    """
    points_url = f"{NWS_API_BASE}/points/{latitude},{longitude}"
    points_data = await make_nws_request(points_url)
    
    if not points_data:
        return "Não foi possível buscar dados para esta localização."
    
    forecast_url = points_data["properties"]["forecast"]
    forecast_data = await make_nws_request(forecast_url)
    
    if not forecast_data:
        return "Não foi possível buscar previsão detalhada."
    
    periods = forecast_data["properties"]["periods"]
    forecasts = []
    
    for period in periods[:5]:
        forecast = f"""
{period['name']}:
Temperature: {period['temperature']}°{period['temperatureUnit']}
Wind: {period['windSpeed']} {period['windDirection']}
Forecast: {period['detailedForecast']}
"""
        forecasts.append(forecast)
    
    return "\n---\n".join(forecasts)

def main():
    mcp.run(transport='stdio')

if __name__ == "__main__":
    main()
```

---

## 🔌 Configuração no Claude for Desktop

### Localização do Arquivo de Configuração

**macOS:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:**
```
%AppData%\Claude\claude_desktop_config.json
```

### Estrutura de Configuração

```json
{
  "mcpServers": {
    "weather": {
      "command": "uv",
      "args": [
        "--directory",
        "/ABSOLUTE/PATH/TO/weather",
        "run",
        "weather.py"
      ]
    }
  }
}
```

### Configuração por Linguagem

#### Python (uv)
```json
{
  "mcpServers": {
    "weather": {
      "command": "uv",
      "args": [
        "--directory",
        "/ABSOLUTE/PATH/TO/weather",
        "run",
        "weather.py"
      ]
    }
  }
}
```

#### Node.js
```json
{
  "mcpServers": {
    "weather": {
      "command": "node",
      "args": ["/ABSOLUTE/PATH/TO/weather/build/index.js"]
    }
  }
}
```

#### Java
```json
{
  "mcpServers": {
    "weather": {
      "command": "java",
      "args": [
        "-jar",
        "/ABSOLUTE/PATH/TO/weather.jar"
      ]
    }
  }
}
```

#### C#
```json
{
  "mcpServers": {
    "weather": {
      "command": "dotnet",
      "args": [
        "run",
        "--project",
        "/ABSOLUTE/PATH/TO/PROJECT"
      ]
    }
  }
}
```

---

## ⚠️ Regras Críticas de Logging

### STDIO Servers

**NUNCA escreva em stdout:**
- `print()` em Python
- `console.log()` em JavaScript
- `fmt.Println()` em Go
- Qualquer função que escreva em stdout

**Por quê?** Isso corrompe mensagens JSON-RPC e quebra o servidor.

**✅ Use stderr:**
- `logging` em Python
- `console.error()` em JavaScript
- Logging em arquivos

### HTTP Servers

- Logging em stdout é permitido
- Não interfere com respostas HTTP

---

## 🎯 Best Practices

### Nomenclatura de Tools

Siga o formato especificado na especificação:
- Use snake_case
- Seja descritivo
- Evite abreviações ambíguas

### Tratamento de Erros

```python
@mcp.tool()
async def minha_tool(param: str) -> str:
    try:
        # Lógica
        return resultado
    except SpecificError as e:
        return f"Erro: {str(e)}"
    except Exception as e:
        logging.error(f"Erro inesperado: {e}")
        return "Erro ao processar requisição"
```

### Documentação de Tools

```python
@mcp.tool()
async def minha_tool(
    param1: str,
    param2: int
) -> str:
    """Descrição clara do que a tool faz.
    
    Args:
        param1: Descrição detalhada do parâmetro 1
        param2: Descrição detalhada do parâmetro 2
    
    Returns:
        Descrição do que é retornado
    
    Raises:
        ExceptionType: Quando isso acontece
    """
    # Implementação
```

### Validação de Entrada

```python
from typing import Annotated
from annotated_types import Gt, Lt

@mcp.tool()
async def minha_tool(
    valor: Annotated[float, Gt(0), Lt(100)]
) -> str:
    """Tool com validação de entrada."""
    # valor sempre será entre 0 e 100
```

---

## 🧪 Testando seu Servidor

### Verificar se Servidor está Funcionando

1. **Claude for Desktop**:
   - Procure pelo ícone "Search and tools"
   - Deve mostrar suas tools listadas
   - Teste fazendo uma pergunta que use a tool

2. **Logs**:
   ```bash
   # macOS
   tail -f ~/Library/Logs/Claude/mcp*.log
   ```

### Comandos de Teste

Após configurar no Claude for Desktop:
- "Qual é o tempo em Sacramento?"
- "Quais são os alertas meteorológicos ativos no Texas?"

---

## 🐛 Troubleshooting

### Servidor não aparece no Claude

**Verificar:**
1. Sintaxe do `claude_desktop_config.json`
2. Caminho absoluto (não relativo)
3. Comando e argumentos corretos
4. Reiniciar Claude for Desktop completamente (Cmd+Q, não apenas fechar janela)

### Tool calls falhando silenciosamente

**Verificar:**
1. Logs do Claude (`~/Library/Logs/Claude/`)
2. Servidor compila e executa sem erros
3. Reiniciar Claude for Desktop

### Erros de JSON-RPC

**Causa comum**: Escrevendo em stdout

**Solução**: Usar apenas stderr para logging

### Servidor não inicia

**Verificar:**
1. Dependências instaladas
2. Caminho do executável correto
3. Permissões de execução
4. Ambiente virtual ativado (se Python)

---

## 📚 Recursos e Exemplos

### Repositórios Oficiais

- **Python**: https://github.com/modelcontextprotocol/quickstart-resources/tree/main/weather-server-python
- **TypeScript**: https://github.com/modelcontextprotocol/quickstart-resources/tree/main/weather-server-typescript
- **Java**: https://github.com/spring-projects/spring-ai-examples/tree/main/model-context-protocol/weather
- **Kotlin**: https://github.com/modelcontextprotocol/kotlin-sdk/tree/main/samples/weather-stdio-server
- **C#**: https://github.com/modelcontextprotocol/csharp-sdk/tree/main/samples/QuickstartWeatherServer

### Documentação

- **Especificação MCP**: https://modelcontextprotocol.io/specification
- **SDKs Disponíveis**: Ver documentação oficial
- **Exemplos**: Gallery de servidores MCP oficiais

---

## 🔄 Fluxo de Execução

### Quando o Claude Usa uma Tool

1. **Usuário faz pergunta**: "Qual é o tempo em Sacramento?"
2. **Claude analisa**: Identifica que precisa de previsão do tempo
3. **Claude escolhe tool**: `get_forecast`
4. **Client executa tool**: Via MCP server
5. **Server processa**: Faz requisição à API
6. **Resultado retorna**: Para o Claude
7. **Claude formula resposta**: Em linguagem natural
8. **Resposta exibida**: Para o usuário

---

## 🔐 Segurança

### Considerações Importantes

1. **Validação de entrada**: Sempre valide parâmetros
2. **Rate limiting**: Implemente limites de taxa
3. **Autenticação**: Use tokens/secrets quando necessário
4. **Sanitização**: Limpe dados de entrada
5. **Logging seguro**: Não logue informações sensíveis

### Gerenciamento de Secrets

**✅ Use 1Password:**
```python
from mcp.server.fastmcp import FastMCP
import subprocess

mcp = FastMCP("meu-servidor")

def get_secret(key: str) -> str:
    """Obter secret do 1Password."""
    result = subprocess.run(
        ["op", "item", "get", key, "--field", "password"],
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

@mcp.tool()
async def minha_tool() -> str:
    api_key = get_secret("API Key")
    # Usar api_key
```

---

## 📊 Comparação de Linguagens

| Linguagem | Facilidade | Performance | SDK Mature | Recomendado Para |
|-----------|-----------|-------------|------------|-------------------|
| **Python** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | Início rápido, prototipagem |
| **TypeScript** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Aplicações web, Node.js |
| **Java** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Aplicações enterprise |
| **Kotlin** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Android, JVM |
| **C#** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | .NET ecosystem |

---

## 🎓 Próximos Passos

### Aprendizado Progressivo

1. **Comece simples**: Tool única com lógica básica
2. **Adicione validação**: Valide entradas
3. **Trate erros**: Implemente tratamento robusto
4. **Adicione resources**: Se necessário
5. **Adicione prompts**: Para templates

### Recursos Avançados

- **Resources**: Dados que podem ser lidos
- **Prompts**: Templates pré-escritos
- **Sampling**: Para recursos grandes
- **Streaming**: Para respostas longas

---

## 📋 Checklist de Implementação

### Setup Inicial
- [ ] Escolher linguagem
- [ ] Instalar SDK MCP
- [ ] Criar estrutura básica do projeto
- [ ] Configurar logging (stderr)

### Desenvolvimento
- [ ] Implementar tool(s)
- [ ] Adicionar validação de entrada
- [ ] Implementar tratamento de erros
- [ ] Documentar tools adequadamente
- [ ] Testar localmente

### Integração
- [ ] Configurar `claude_desktop_config.json`
- [ ] Testar no Claude for Desktop
- [ ] Verificar logs
- [ ] Validar funcionamento

### Produção
- [ ] Revisar segurança
- [ ] Implementar rate limiting
- [ ] Documentar uso
- [ ] Testar com casos reais

---

**Última atualização:** 2025-11-05
**Versão:** 1.0.0
**Baseado em:** Documentação oficial MCP

