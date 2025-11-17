# 🔄 PLANO B - Trabalhando SEM 1Password Connect Server
**Data:** 2025-10-31  
**Objetivo:** Estruturar automação completa usando APENAS 1Password CLI

---

## 🎯 PRINCÍPIO FUNDAMENTAL

**Não dependemos do Connect Server para ter automação real.**

O Connect Server é útil para integrações via API REST, mas:
- ✅ 1Password CLI já funciona perfeitamente
- ✅ `op inject` funciona sem Connect Server
- ✅ Podemos automatizar TUDO com scripts
- ✅ Raycast funciona com CLI

---

## 📋 ARQUITETURA SEM CONNECT

### Componentes Funcionais
```
1Password Desktop App
        ↓
1Password CLI (op-cli)
        ↓
Scripts Automation
        ↓
   Raycast
        ↓
   Docker
        ↓
  Stack Completa
```

### Fluxo de Trabalho
1. **Shell inicia** → Carrega `env/macos.env`
2. **Op-cli** → Autentica via desktop app (biometria)
3. **Scripts** → Usam `op inject` para templates
4. **Raycast** → Executa comandos com CLI
5. **Docker** → Recebe secrets via `.env` injetado

---

## ✅ PRIMEIROS PASSOS AGORA

### 1. Configurar Automação CLI Completa

```bash
# Criar função helper no .zshrc
function op-auto() {
  # Verifica se tem sessão ativa
  if ! op-cli whoami &>/dev/null; then
    echo "🔐 Autenticando 1Password..."
    op-cli signin
  fi
  op-cli "$@"
}

alias op='op-auto'
```

### 2. Scripts Essenciais

#### op-inject-env.sh
```bash
#!/bin/bash
# Injetar secrets em arquivo .env
op-cli inject -i compose/env.template -o compose/.env
```

#### op-get-secret.sh
```bash
#!/bin/bash
# Buscar secret específico
VAULT=${1:-1p_macos}
ITEM=${2}
FIELD=${3:-password}

op-cli item get "$ITEM" --vault "$VAULT" --field "$FIELD"
```

### 3. Raycast Scripts Imediatos

#### Comando: Deploy Stack
```bash
#!/bin/bash
# Raycast: Deploy Platform Stack

cd ~/Dotfiles/automation_1password

# Injetar secrets
echo "🔐 Carregando secrets..."
op-cli inject -i compose/env-platform-completa.template -o compose/.env

# Deploy
echo "🚀 Iniciando deployment..."
docker compose -f compose/docker-compose-platform-completa.yml up -d

echo "✅ Deploy concluído!"
echo ""
docker compose ps
```

#### Comando: Ver Logs Stack
```bash
#!/bin/bash
# Raycast: Ver Logs
docker compose -f compose/docker-compose-platform-completa.yml logs -f
```

#### Comando: Parar Stack
```bash
#!/bin/bash
# Raycast: Parar Stack
docker compose -f compose/docker-compose-platform-completa.yml down
```

---

## 🐳 DEPLOY STACKS AGORA (SEM CONNECT)

### Passo 1: Injetar Secrets
```bash
cd ~/Dotfiles/automation_1password

# Criar .env com secrets injetados
op-cli inject -i compose/env-platform-completa.template -o compose/.env
```

### Passo 2: Ajustar Placeholders

Arquivo gerado terá `{{PLACEHOLDERS}}` que precisam ser substituídos:
- `{{PRIMARY_DOMAIN}}` → `localhost`
- `{{VAULT_DEVOPS}}` → `1p_macos` ou `1p_vps`
- `{{HF_HOME}}` → `~/huggingface`
- Etc.

### Passo 3: Deploy
```bash
docker compose -f compose/docker-compose-platform-completa.yml up -d
```

---

## 🤖 HUGGINGFACE INTEGRATION

### Configuração Básica

#### 1. Token
```bash
# Buscar token do 1Password
OP_CLI whoami &>/dev/null || op-cli signin
export HF_TOKEN=$(op-cli item get HuggingFace-Token --vault 1p_macos --field credential)

# Ou criar .env
echo "HF_TOKEN=$(op-cli item get HuggingFace-Token --vault 1p_macos --field credential)" >> .env
```

#### 2. Caches
```bash
export HF_HOME=~/huggingface
export HF_DATASETS_CACHE=~/huggingface/datasets
export HF_HUB_CACHE=~/huggingface/hub

mkdir -p $HF_HOME $HF_DATASETS_CACHE $HF_HUB_CACHE
```

#### 3. Login
```bash
# Instalar CLI
pip install huggingface_hub

# Login
huggingface-cli login --token $HF_TOKEN
```

---

## 📱 RAYCAST COMPLETO

### Scripts a Criar

#### 1. Open Services
```bash
#!/bin/bash
# Abrir todas as interfaces

open http://localhost:9000  # Portainer
open http://localhost:8080  # Traefik Dashboard
open http://localhost:3000  # Appsmith
open http://localhost:5678  # n8n
# etc.
```

#### 2. Status All
```bash
#!/bin/bash
# Status de todos os serviços

echo "📊 Status da Stack"
echo ""
docker compose ps
echo ""
echo "🔐 1Password Status"
op-cli whoami 2>/dev/null || echo "❌ Not signed in"
```

#### 3. Backup Stack
```bash
#!/bin/bash
# Backup completo

BACKUP_DIR=~/backups/stack-$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Backup volumes
docker run --rm \
  -v compose_postgres_data:/data \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/postgres.tar.gz /data

echo "✅ Backup salvo em $BACKUP_DIR"
```

---

## 📝 ARQUIVOS A CRIAR AGORA

### 1. scripts/op-helpers.sh
```bash
#!/bin/bash
# Helper functions para 1Password CLI

function op-inject() {
  op-cli inject -i "$1" -o "$2"
}

function op-secret() {
  op-cli item get "$1" --vault "${2:-1p_macos}" --field "${3:-password}"
}

function op-signin-check() {
  if ! op-cli whoami &>/dev/null; then
    echo "🔐 Authenticating..."
    op-cli signin
  fi
}
```

### 2. Makefile Adicional

```makefile
# Deploy
deploy.local:
	@echo "🚀 Deploying local stack..."
	@cd compose && op-cli inject -i env-platform-completa.template -o .env
	@docker compose -f docker-compose-local.yml up -d

# Secrets
secrets.inject:
	@echo "🔐 Injecting secrets..."
	@op-cli inject -i compose/env-platform-completa.template -o compose/.env

# Status
status:
	@docker compose ps
	@echo ""
	@echo "🔐 1Password: $$(op-cli whoami 2>/dev/null || echo 'Not signed in')"

# Logs
logs:
	@docker compose logs -f

# Clean
clean:
	@docker compose down -v
```

### 3. .zshrc Addition
```bash
# Carregar helpers
[ -f ~/Dotfiles/automation_1password/scripts/op-helpers.sh ] && \
  source ~/Dotfiles/automation_1password/scripts/op-helpers.sh

# Alias
alias op-deploy='cd ~/Dotfiles/automation_1password && make deploy.local'
alias op-status='cd ~/Dotfiles/automation_1password && make status'
alias op-logs='cd ~/Dotfiles/automation_1password && make logs'
```

---

## 🎯 VANTAGENS DO PLANO B

### ✅ Mais Simples
- Não precisa gerenciar Connect Server
- Menos containers rodando
- Menos pontos de falha

### ✅ Mais Seguro
- Autenticação via desktop app
- Biometria em cada sessão
- Secrets nunca em containers long-lived

### ✅ Mais Produtivo
- Scripts mais diretos
- Debug mais fácil
- Menos configuração complexa

---

## ⚠️ DESVANTAGENS DO PLANO B

### ❌ Requer Desktop App
- Precisa 1Password app instalado
- Não funciona em servidores headless sem GUI

### ❌ Precisa Sessão Ativa
- `op signin` necessário periodicamente
- Timeout de sessão

### ❌ Integração via API
- Apps externos não podem acessar via REST
- MCP servers precisam CLI

---

## 🔄 MIGRAÇÃO FUTURA PARA CONNECT

Quando Connect estiver funcionando:
1. Apenas trocar `op-cli` por `curl http://localhost:8081/v1/...`
2. Scripts permanecem similares
3. Infraestrutura Docker igual

---

## ✅ CHECKLIST PLANO B

### Imediato (Hoje)
- [ ] Criar `scripts/op-helpers.sh`
- [ ] Adicionar ao `.zshrc`
- [ ] Criar Makefile targets
- [ ] Criar 3 scripts Raycast básicos

### Curto Prazo
- [ ] Deploy stack local completa
- [ ] Configurar HuggingFace
- [ ] Criar todos Raycast scripts
- [ ] Documentar workflow

### Médio Prazo
- [ ] VPS setup (usa mesma arquitetura)
- [ ] MCP servers com CLI
- [ ] Automação completa

---

## 🚀 AÇÃO IMEDIATA

**Vamos começar AGORA:**

```bash
cd ~/Dotfiles/automation_1password

# 1. Criar helpers
cat > scripts/op-helpers.sh << 'EOF'
#!/bin/bash
function op-auto() {
  if ! op-cli whoami &>/dev/null; then
    op-cli signin
  fi
  op-cli "$@"
}
alias op='op-auto'
EOF

# 2. Adicionar ao .zshrc
echo "source ~/Dotfiles/automation_1password/scripts/op-helpers.sh" >> ~/.zshrc

# 3. Injetar secrets
op-auto inject -i compose/env-platform-completa.template -o compose/.env

# 4. Deploy Portainer (já funciona!)
docker compose -f compose/docker-compose-local.yml up -d portainer
```

---

**Resultado:** Stack funcionando HOJE, sem esperar Connect Server! 🎉

