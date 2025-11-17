# 🚨 Fix Imediato: VPS Deploy

**Problema:** `op inject` falhou - items não encontrados no vault

---

## ✅ SOLUÇÃO RÁPIDA (Execute na VPS)

### Comando Único para .env Manual

```bash
cd ~/automation_1password/prod

# Gerar .env com secrets aleatórios
cat > .env << 'EOFENV'
PROJECT_SLUG=platform
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$(openssl rand -base64 24)
POSTGRES_DB=n8n
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
N8N_USER_MANAGEMENT_JWT_SECRET=$(openssl rand -base64 32)
N8N_USER=admin
N8N_PASSWORD=$(openssl rand -base64 16)
EOFENV

# Expandir variáveis com openssl
POSTGRES_PASS=$(openssl rand -base64 24 | tr -d '\n')
N8N_KEY=$(openssl rand -base64 32 | tr -d '\n')
N8N_JWT=$(openssl rand -base64 32 | tr -d '\n')
N8N_PASS=$(openssl rand -base64 16 | tr -d '\n')

cat > .env << EOF
PROJECT_SLUG=platform
POSTGRES_USER=n8n
POSTGRES_PASSWORD=${POSTGRES_PASS}
POSTGRES_DB=n8n
N8N_ENCRYPTION_KEY=${N8N_KEY}
N8N_USER_MANAGEMENT_JWT_SECRET=${N8N_JWT}
N8N_USER=admin
N8N_PASSWORD=${N8N_PASS}
EOF

chmod 600 .env

# Validar
docker compose -f docker-compose.yml config

# Iniciar
docker compose -f docker-compose.yml up -d
```

---

## 📋 Verificar Items Disponíveis

Se quiser usar 1Password depois:

```bash
# Listar vaults
op vault list

# Ver items em um vault específico
op item list --vault <nome-vault>

# Se encontrar o vault correto, ajustar .env.template
```

---

## 🎯 Status

- ✅ 1Password autenticado
- ❌ Vault `1p_vps` não encontrado ou sem items
- ✅ Solução: .env manual com secrets gerados

**Execute o comando acima na VPS para continuar deploy.**

