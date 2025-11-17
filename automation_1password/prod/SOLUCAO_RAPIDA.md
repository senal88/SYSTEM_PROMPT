# ⚡ Solução Rápida: Deploy VPS

**Problema:** Items não encontrados no vault → `op inject` falha

---

## ✅ Solução Imediata

### Opção 1: Usar .env.example (Mais Rápido)

```bash
# Na VPS
cd ~/automation_1password/prod

# Copiar exemplo
cp .env.example .env

# Editar manualmente
nano .env
# Preencher valores:
# - POSTGRES_PASSWORD (gerar senha forte)
# - N8N_ENCRYPTION_KEY (32 caracteres aleatórios)
# - N8N_USER_MANAGEMENT_JWT_SECRET (gerar JWT secret)
# - N8N_PASSWORD (senha admin n8n)

# Proteger
chmod 600 .env
```

### Opção 2: Verificar Items Disponíveis

```bash
# Verificar quais items existem
cd ~/automation_1password/scripts/deployment
./check-vault-items.sh

# Ajustar .env.template para usar items que existem
# OU criar items faltantes no 1Password app
```

### Opção 3: Gerar Secrets Temporários

```bash
cd ~/automation_1password/prod

# Gerar secrets temporários
cat > .env << 'EOF'
PROJECT_SLUG=platform
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -d '\n')
POSTGRES_DB=n8n
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32 | tr -d '\n')
N8N_USER_MANAGEMENT_JWT_SECRET=$(openssl rand -base64 32 | tr -d '\n')
N8N_USER=admin
N8N_PASSWORD=$(openssl rand -base64 16 | tr -d '\n')
EOF

# Expandir variáveis
eval "echo \"$(cat .env)\"" > .env.final
mv .env.final .env
chmod 600 .env
```

---

## 🎯 Recomendação

**Para produção:** Use Opção 1 ou 2 (com 1Password)  
**Para teste rápido:** Use Opção 3 (secrets temporários)

---

## ✅ Após Criar .env

```bash
# Validar
docker compose -f docker-compose.yml config

# Iniciar
docker compose -f docker-compose.yml up -d

# Verificar
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs -f
```

---

**Escolha uma opção acima e execute na VPS.**

