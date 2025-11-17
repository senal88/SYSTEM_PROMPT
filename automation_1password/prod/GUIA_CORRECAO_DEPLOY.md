# 🔧 Guia de Correção: Deploy VPS

**Problema:** 1Password CLI não autenticado → variáveis não injetadas → stack sem secrets

---

## ⚠️ Problema Identificado

Ao executar `op inject`, o erro foi:
```
[ERROR] You are not currently signed in. Please run `op signin --help`
```

**Consequências:**
- `.env` não foi criado ou está vazio
- Docker Compose iniciou sem variáveis críticas
- Containers podem não funcionar corretamente

---

## ✅ Solução Passo a Passo

### Passo 1: Autenticar 1Password na VPS

```bash
ssh vps
op signin
```

Ou com conta específica:
```bash
op signin --account senamfo
```

**Siga as instruções na tela para autenticar.**

### Passo 2: Validar Vault 1p_vps

```bash
# Verificar se vault existe
op vault get 1p_vps

# Listar items
op item list --vault 1p_vps

# Verificar items críticos
op item get "PostgreSQL" --vault 1p_vps
op item get "n8n" --vault 1p_vps
```

**Se o vault não existir:**
1. Criar no 1Password app
2. Sincronizar items essenciais de `1p_macos`

### Passo 3: Reinjetar Variáveis

```bash
cd ~/automation_1password/prod

# Reinjetar
op inject -i .env.template -o .env

# Proteger arquivo
chmod 600 .env

# Validar (verificar que tem conteúdo)
wc -l .env
# Deve ter pelo menos 10 linhas
```

### Passo 4: Parar Stack Atual (sem variáveis)

```bash
docker compose -f docker-compose.yml down
```

### Passo 5: Validar Compose

```bash
docker compose -f docker-compose.yml config
```

**Não deve ter warnings sobre variáveis não definidas.**

### Passo 6: Reiniciar Stack

```bash
docker compose -f docker-compose.yml up -d

# Verificar status
docker compose -f docker-compose.yml ps

# Verificar logs
docker compose -f docker-compose.yml logs -f
```

---

## 🛠️ Script Automático

**Ou usar o script criado:**

```bash
# No macOS
./scripts/deployment/setup-vps-1password.sh
```

Este script:
- Verifica autenticação
- Valida vault
- Injeta variáveis
- Valida .env

---

## 📋 Checklist de Validação

Após correção, verificar:

- [ ] 1Password autenticado: `op whoami`
- [ ] Vault existe: `op vault get 1p_vps`
- [ ] Items sincronizados: `op item list --vault 1p_vps`
- [ ] .env criado: `test -f .env && wc -l .env`
- [ ] Variáveis presentes: `grep -q POSTGRES_PASSWORD .env`
- [ ] Compose válido: `docker compose config`
- [ ] Containers rodando: `docker compose ps`
- [ ] Health checks OK: `docker compose ps` (verificar status)

---

## 🎯 Status Atual

- ⚠️ **1Password:** Não autenticado (corrigir)
- ⚠️ **.env:** Não criado ou vazio (corrigir)
- ⚠️ **Stack:** Parada ou rodando sem variáveis (reiniciar após correção)

---

**Ação:** Execute Passos 1-6 acima para corrigir antes de continuar.

