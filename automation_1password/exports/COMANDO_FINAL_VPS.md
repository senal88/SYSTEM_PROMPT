# 🚀 Comando Final: Deploy VPS

**Execute estes comandos na VPS para completar o deploy:**

---

## ✅ Comandos (Copiar e Colar)

```bash
cd ~/automation_1password/prod

# Opção A: Gerar .env automaticamente (RECOMENDADO)
~/automation_1password/scripts/deployment/generate-env-manual.sh .env

# OU Opção B: Gerar manualmente
cat > .env << 'EOF'
PROJECT_SLUG=platform
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$(openssl rand -base64 24 | tr -d '/')
POSTGRES_DB=n8n
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32 | tr -d '/')
N8N_USER_MANAGEMENT_JWT_SECRET=$(openssl rand -base64 32 | tr -d '/')
N8N_USER=admin
N8N_PASSWORD=$(openssl rand -base64 16 | tr -d '/')
EOF

# Expandir variáveis
POSTGRES_PASS=$(openssl rand -base64 24 | tr -d '/\n')
N8N_KEY=$(openssl rand -base64 32 | tr -d '/\n')
N8N_JWT=$(openssl rand -base64 32 | tr -d '/\n')
N8N_PASS=$(openssl rand -base64 16 | tr -d '/\n')

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

# Verificar
docker compose -f docker-compose.yml ps
```

---

## 📋 Explicação

1. **Gerar .env:** Cria arquivo com secrets aleatórios
2. **Validar:** Verifica se docker-compose está correto
3. **Iniciar:** Sobe os containers
4. **Verificar:** Confere status dos containers

---

**Status:** Execute na VPS agora! 🚀

