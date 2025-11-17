Last Updated: 2025-10-30
Version: 2.0.0

# 🧩 `README.md` – Diretório `/env`

## 📖 Visão Geral

Este diretório contém todas as **configurações de ambiente (.env)** utilizadas pelo sistema **Automation 1Password**, integrando:

* **1Password Environments** (via `op inject` e `.env.op`)
* **Vaults dedicados** para macOS (DEV) e VPS Ubuntu (PROD)
* **Segregação total** de credenciais, secrets e tokens
* **Integração automática** com o `1Password Connect` e `Traefik`

---

## 🧱 Estrutura

```
env/
├── README.md                 # Este arquivo
├── shared.env                # Variáveis globais comuns a todos os ambientes
├── macos.env                 # Variáveis específicas de desenvolvimento (macOS)
├── vps.env                   # Variáveis específicas de produção (VPS)
├── macos.secrets.env.real    # Gerado automaticamente a partir do .op
├── vps.secrets.env.real      # Gerado automaticamente a partir do .op
└── .env                      # Ambiente ativo (gitignored)
```

| Arquivo/Template | Descrição |
| --- | --- |
| `env/shared.env` | Variáveis comuns a qualquer ambiente (paths, vaults, defaults). |
| `env/macos.env` | Especializações para desenvolvimento local (Apple Silicon). |
| `env/vps.env` | Especializações para produção na VPS. |
| `templates/env/macos.secrets.env.op` | Template de secrets (`op://`) para o cofre `1p_macos`. |
| `templates/env/vps.secrets.env.op` | Template de secrets (`op://`) para o cofre `1p_vps`. |

> **⚠️ Importante:** Nenhum arquivo `.env.real` é versionado. Gere-os dinamicamente com o 1Password CLI sempre que necessário.

---

## 🔐 Integração com 1Password Environments

O projeto utiliza a integração nativa com o **1Password Environments API** e o novo formato de arquivo **`.env.op`**,
conforme documentação oficial: [developer.1password.com/docs/environments/local-env-file](https://developer.1password.com/docs/environments/local-env-file)

### 📍 Configuração do Destino Local (.env) no macOS Silicon

Conforme a [documentação oficial da 1Password](https://developer.1password.com/docs/environments/local-env-file/), você pode montar automaticamente arquivos `.env` locais diretamente do 1Password Desktop App, sem precisar manter os valores em texto plano no disco.

#### Passo a Passo Detalhado

**1. Abrir 1Password Desktop App**
- Certifique-se de estar usando a versão mais recente do 1Password para Mac
- Faça login na sua conta (luiz.sena88@icloud.com)

**2. Acessar Environments**
- No menu lateral, procure por **"Environments"** (ou "Ambientes")
- Se não encontrar, vá em: **Settings** → **Developer** → **Environments**

**3. Criar ou Selecionar Environment**
- Para desenvolvimento macOS, crie/selecione um environment chamado: **`macOS Development`** ou **`1p_macos_dev`**
- Você pode usar o environment existente **`1p_macos`** se já tiver um

**4. Configurar Local .env File Destination**
- Dentro do environment, clique na aba **"Destinations"**
- Clique em **"Configure destination"**
- Selecione **"Local .env file"** como tipo de destino

**5. Definir Path Local no macOS**

**Nomenclatura recomendada:**
```
/Users/luiz.sena88/Dotfiles/automation_1password/env/macos.secrets.env.op
```

**OU (alternativa compatível com op inject):**
```
/Users/luiz.sena88/Dotfiles/automation_1password/connect/.env
```

**📋 Notas Importantes:**
- ⚠️ Use **caminho completo absoluto** (não caminho relativo)
- ⚠️ Escolha **UM caminho** e mantenha consistente
- ⚠️ O arquivo **não deve existir previamente** (ou seja, não deve estar no Git)

**6. Selecionar o Arquivo**
- Clique em **"Choose file path"**
- Navegue até o diretório: `/Users/luiz.sena88/Dotfiles/automation_1password/env/`
- **Não selecione um arquivo existente**, mas sim o diretório
- O 1Password criará automaticamente o arquivo `.env` no local especificado

**7. Mount .env File**
- Após escolher o path, clique em **"Mount .env file"**
- Você verá uma autorização solicitando permissão
- Clique em **"Authorize"** para permitir

**8. Verificar Montagem**
- No terminal, navegue até o diretório e execute:
```bash
cd ~/Dotfiles/automation_1password/env
cat macos.secrets.env.op
```
- Se configurado corretamente, você verá os valores do environment
- ⚠️ **Primeiro acesso requer autorização** - clique em "Authorize" no prompt

---

### ⚙️ Como Funciona Internamente

Segundo a [documentação 1Password](https://developer.1password.com/docs/environments/local-env-file/):

1. **1Password monta o arquivo** no path especificado usando um **UNIX named pipe**
2. **Conteúdo NÃO é escrito em disco** - valores são passados diretamente ao processo leitor
3. **Auto-remount** - arquivo é remontado automaticamente quando 1Password reinicia
4. **Segurança** - arquivo trava novamente quando o 1Password é bloqueado
5. **Git-safe** - arquivos montados **NÃO são tracked pelo Git**, mantendo secrets seguros

---

### 🔒 Limitações Importantes

**Conforme documentação 1Password:**

| Limitação | Impacto | Solução |
|-----------|---------|---------|
| **Apenas Mac/Linux** | Não funciona no Windows | Use Mac ou Linux |
| **Sem acesso concorrente** | Múltiplos processos podem conflitar | Feche IDE ao acessar via terminal |
| **Offline limitado** | Apenas últimos valores sincronizados | Mantenha online para atualizações |
| **Máx. 10 arquivos por device** | Limite de mount points | Gerencie prioridades |

**⚠️ CENÁRIO CRÍTICO - Conflito de Acesso:**
Se você tiver o arquivo `.env` aberto no Cursor/VSCode enquanto outro processo tenta lê-lo:
```bash
# ❌ PROBLEMA: IDE pode bloquear acesso terminal
cursor env/macos.secrets.env.op  # Arquivo aberto na IDE

# Tentar ler no terminal causa falha:
cat env/macos.secrets.env.op     # ❌ Falha - arquivo bloqueado
```

**SOLUÇÃO:**
```bash
# ✅ FECHAR arquivo na IDE antes de usar no terminal
# Depois de fechar, pode ler normalmente:
cat env/macos.secrets.env.op     # ✅ Funciona
```

---

### 📚 Compatibilidade com Bibliotecas Dotenv

**Segundo [documentação 1Password](https://developer.1password.com/docs/environments/local-env-file/), o arquivo montado é compatível com:**

| Linguagem/Tool | Biblioteca | Status |
|----------------|------------|--------|
| **Docker Compose** | Built-in | ✅ Funciona direto |
| **JavaScript/Node.js** | dotenv | ✅ Compatível |
| **Python** | python-dotenv | ⚠️ Exige passar conteúdo diretamente |
| **Ruby** | dotenv | ✅ Compatível |
| **Go** | godotenv | ✅ Compatível |
| **C#** | DotNetEnv | ✅ Compatível |
| **Java** | dotenv-java | ✅ Compatível |
| **PHP** | phpdotenv | ✅ Compatível |
| **Rust** | dotenvy | ⚠️ Exige passar filename/path |

**Exemplo Docker Compose:**
```yaml
# connect/docker-compose.yml
services:
  my-app:
    env_file:
      - ./env/macos.secrets.env.op  # 1Password montado automaticamente
```

---

## 🎯 Vale a Pena Utilizar? Análise Completa

### ✅ **SIM! VALE MUITO A PENA**

Especialmente para sua stack completa de infraestrutura (Traefik, Redis, Portainer, PostgreSQL, MongoDB, ChromaDB, pgvector, Dify, HuggingFace, Appsmith, Next.js, n8n, Streamlit, etc.).

#### 💡 Por que vale a pena?

1. **Segurança Total**
   - Secrets **nunca** em disco
   - Valores via UNIX named pipe
   - Bloqueio automático quando 1Password trava

2. **Automação Real**
   - Sincronização automática com 1Password
   - Sem intervenção manual
   - Git-safe automático

3. **Docker Compose Nativo**
   ```yaml
   # Funciona direto no docker-compose.yml
   services:
     traefik:
       env_file:
         - ./env/infra.secrets.env.op
     postgres:
       env_file:
         - ./env/infra.secrets.env.op
     redis:
       env_file:
         - ./env/infra.secrets.env.op
   ```

4. **Escalável para Múltiplos Serviços**
   - Um único environment com todos os secrets infra
   - Reutilizável em todos os containers
   - Fácil gerenciamento centralizado

---

### 🔧 Resolvendo a Limitação de Conflito IDE/Terminal

**Problema:** IDE e terminal não podem ler simultaneamente.

**Solução Empresarial:**

#### Opção 1: Workflow Separado (Recomendado)

```bash
# 1. Abra o .env NA IDE quando for editar configurações
cursor env/infra.secrets.env.op

# 2. Para usar com Docker Compose, NÃO abra o arquivo na IDE
# Apenas referencie no docker-compose.yml
docker compose up -d  # Funciona automático!

# 3. Para scripts shell, exporte variáveis UMA VEZ e reutilize
source env/infra.secrets.env.op
export $(cat env/infra.secrets.env.op | xargs)
```

#### Opção 2: Variáveis de Ambiente Persistentes

```bash
# 1. Criar script helper
cat > scripts/secrets/load-infra-env.sh << 'EOF'
#!/bin/bash
# Carregar variáveis infra UMA VEZ
source env/shared.env
source env/infra.secrets.env.op  # Montado pelo 1Password
EOF

chmod +x scripts/secrets/load-infra-env.sh

# 2. Usar em qualquer lugar
bash scripts/secrets/load-infra-env.sh
docker compose up -d  # Usa variáveis já carregadas
```

#### Opção 3: Múltiplos Environment Files

```bash
# Criar environments separados por categoria
env/
├── infra.secrets.env.op      # Traefik, Redis, Portainer, DBs
├── app.secrets.env.op        # Next.js, n8n, Streamlit
└── ai.secrets.env.op         # Dify, HuggingFace, ChromaDB
```

---

### 📊 Comparação: Com vs Sem 1Password Environments

| Aspecto | Sem 1Password Environments | Com 1Password Environments |
|---------|---------------------------|---------------------------|
| **Segurança** | Arquivos `.env` no disco | Values nunca em disco |
| **Git** | Precisa `.gitignore` manual | Git-safe automático |
| **Sincronização** | Manual (copiar/colar) | Automática com 1Password |
| **Múltiplos Ambientes** | Múltiplos arquivos | Um environment reutilizável |
| **Rotação de Secrets** | Atualizar manualmente | Atualiza em um lugar |
| **Docker Compose** | Funciona | Funciona + mais seguro |
| **Limitação IDE** | Não aplicável | Exige workflow organizado |

**Veredito:** ✅ **Vale a pena**, especialmente para stacks complexas como a sua.

---

## 🚀 Workflow Infra Implementado - Zero Conflitos

Implementamos um **workflow automatizado** que elimina conflitos IDE/Terminal.

### 📋 Setup Rápido (Uma Vez)

1. **Configure 1Password Environment:**
   - Crie environment chamado: `macOS Infrastructure`
   - Configure Local .env file destination
   - Path: `/Users/luiz.sena88/Dotfiles/automation_1password/env/infra.secrets.env.op`

2. **Adicione Secrets ao 1Password:**
   - Use o template: `env/infra.example.env.op`
   - Crie cada secret como item no vault `1p_macos`
   - Format: `op://1p_macos/item_name/field_name`

3. **Mount .env File:**
   - Clique em "Mount .env file" no 1Password
   - Autorize quando solicitado

### 🎯 Uso Diário (Workflow Organizado)

```bash
# 1️⃣ Carregar variáveis de ambiente
bash scripts/secrets/load-infra-env.sh

# 2️⃣ Verificar que funcionou
echo $OP_CONNECT_TOKEN

# 3️⃣ Usar com Docker Compose
docker compose up -d

# 4️⃣ NUNCA abra o arquivo na IDE quando for usar no terminal
# ✅ O script já faz isso por você!
```

### 🔄 Fluxo Completo

```bash
# ┌─────────────────────────────────────────┐
# │  Workflow Infra - Zero Conflitos        │
# └─────────────────────────────────────────┘
#
# Terminal aberto
#   ↓
# bash scripts/secrets/load-infra-env.sh
#   ↓
# [Lê env/infra.secrets.env.op UMA VEZ]
#   ↓
# [Exporta variáveis para shell]
#   ↓
# docker compose up -d
#   ↓
# ✅ Funciona! Sem conflito IDE/Terminal
```

### 🛡️ Vantagens do Workflow

| Vantagem | Benefício |
|----------|-----------|
| **Zero Conflitos** | Script sempre fecha arquivo após ler |
| **Autorização Única** | Prompt apenas na primeira execução |
| **Reutilizável** | Variáveis exportadas ficam no shell |
| **Seguro** | Secrets nunca escritos em disco |
| **Automatizado** | Um comando carrega tudo |

### 📊 Comparação: Workflow Manual vs Automatizado

| Aspecto | Manual | Automatizado (este) |
|---------|--------|-------------------|
| **Conflito IDE/Terminal** | ⚠️ Provável | ✅ Eliminado |
| **Autorizações** | Múltiplas | Uma vez |
| **Complexidade** | Alta | Baixa |
| **Chance de erro** | Alta | Baixa |
| **Manutenção** | Difícil | Fácil |

---

### 📦 Estrutura do Template

Cada arquivo `.env.op` define variáveis seguras que são injetadas diretamente do 1Password:

**Exemplo: `templates/env/macos.secrets.env.op`**

```bash
# MacOS Secure Environment (Development)
OP_CONNECT_TOKEN={{op://1p_macos/connect_token_macos__2025_10_29/token}}
DATABASE_PASSWORD={{op://1p_macos/database_dev/password}}
GITHUB_PAT={{op://1p_macos/github_pat/token}}
HUGGINGFACE_TOKEN={{op://1p_macos/huggingface_token/token}}
```

### ⚙️ Materializar Variáveis

Gerar o arquivo `.env.real` com valores em tempo de execução:

```bash
# macOS
op inject -i templates/env/macos.secrets.env.op -o env/macos.secrets.env.real

# VPS
op inject -i templates/env/vps.secrets.env.op -o env/vps.secrets.env.real
```

---

## 🔄 Carregamento Automático

### 1️⃣ Via Shell

```bash
# Carregar variáveis do ambiente ativo
source env/macos.env
source env/macos.secrets.env.real
```

### 2️⃣ Via Docker Compose

No `connect/docker-compose.yml`:

```yaml
services:
  connect-api:
    env_file:
      - ../env/shared.env
      - ../env/macos.env
      - ../env/macos.secrets.env.real
```

---

## 🧮 Variáveis Padrão

**shared.env**

```bash
ENVIRONMENT=shared
PROJECT_NAME=automation_1password
LOG_LEVEL=info
TIMEZONE=America/Sao_Paulo
```

**macos.env**

```bash
ENVIRONMENT=development
VAULT=1p_macos
LOCAL_DOMAIN=localhost
DOCKER_NETWORK=automation_1password_net
```

**vps.env**

```bash
ENVIRONMENT=production
VAULT=1p_vps
PUBLIC_DOMAIN=connect.senamfo.com.br
TRAEFIK_NETWORK=automation_1password_prod
```

---

## 🧰 Automação e Validação

Scripts relacionados (executar na raiz do repositório):

```bash
# Validar variáveis de ambiente (macOS)
bash scripts/validation/validate_environment_macos.sh

# Validar organização de envs e templates
bash scripts/validation/validate_organization.sh
```

---

## 📋 Boas Práticas

✅ Sempre manter os arquivos `.env.real` e `.env` no `.gitignore`  
✅ Seguir nomenclatura `{{op://VAULT/item/field}}`  
✅ Regerar `.env.real` após cada rotação de token  
✅ Usar apenas `op inject` para materialização — nunca `op read` manual  
✅ Configurar `SSH_AUTH_SOCK` quando usar 1Password SSH Agent

---

## 🔑 Integração SSH Agent (Opcional)

1. Ativar o agente SSH no 1Password:

```bash
op settings set use_ssh_agent true
```

2. Adicionar a variável no ambiente:

```bash
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
```

3. Validar chaves disponíveis:

```bash
ssh-add -l
```

---

## 🧾 Exemplo Completo de Uso (macOS)

```bash
# 1. Autenticar 1Password
eval $(op signin)

# 2. Materializar variáveis seguras
op inject -i templates/env/macos.secrets.env.op -o env/macos.secrets.env.real

# 3. Carregar variáveis
source env/shared.env
source env/macos.env
source env/macos.secrets.env.real

# 4. Verificar Connect Server
curl -fsS http://127.0.0.1:8080/health
```

---

## 🧱 Relação com a Arquitetura

| Ambiente      | Arquivo `.env`                         | Vault      | Uso                   |
| ------------- | -------------------------------------- | ---------- | --------------------- |
| macOS (DEV)   | `macos.env` + `macos.secrets.env.real` | `1p_macos` | Desenvolvimento local |
| VPS (PROD)    | `vps.env` + `vps.secrets.env.real`     | `1p_vps`   | Produção              |
| Compartilhado | `shared.env`                           | —          | Configurações comuns  |

---

## 🔐 Tokens e Credenciais

### 1Password Connect (JWT)
- **Geração:** [1Password Connect → Tokens](https://my.1password.com/developer-tools/infrastructure-secrets/connect/)
- **Convenção recomendada:** `connect__<ambiente>__<contexto>__<data>`
  - Ex.: `connect__macos_dev__local__29OUT2025`, `connect__vps_prod__local__29OUT2025`
- **⚠️ Importante:** Tokens não devem ser persistidos em arquivos `.env`. Mantenha-os no 1Password e injete via CLI.

### Service Accounts
- **Geração:** [1Password Service Accounts](https://my.1password.com/developer-tools/infrastructure-secrets/serviceaccount/)
- **Convenção recomendada:** `svc__<ambiente>__<função>__<escopo>`
  - Ex.: `svc__macos_dev__maintenance`, `svc__vps_prod__deploy_appstack`
- **Uso:** Use o token (`OP_SERVICE_ACCOUNT_TOKEN`) apenas temporariamente para automações headless.

---

## 📘 Referências

* [1Password Environments Docs](https://developer.1password.com/docs/environments)
* [Local .env Destination](https://developer.1password.com/docs/environments/local-env-file)
* [1Password CLI Reference](https://developer.1password.com/docs/cli)
* [SSH Agent Integration](https://developer.1password.com/docs/ssh/agent)
* [Automation 1Password README-COMPLETE.md](../README-COMPLETE.md)

---

## ✅ Conclusão

Este diretório mantém a **camada mais sensível da automação — o ambiente**.

Todos os arquivos `.env` são **segregados, injetados via 1Password**, e **validados automaticamente** nos scripts de ambiente e deploy.

A estrutura foi validada conforme `ARCHITECTURE_REPORT.md` e `RESUMO_CORRECOES_ARQUITETURA.md`.

Não há variáveis fixas em código; toda autenticação e materialização é feita dinamicamente.

✅ **Infraestrutura de ambiente 100% segura e validada.**

---

**Data de criação:** 29 de Outubro de 2025  
**Última atualização:** 29 de Outubro de 2025  
**Versão:** 2.0.0
