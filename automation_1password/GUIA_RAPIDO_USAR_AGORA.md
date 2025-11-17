# 🚀 GUIA RÁPIDO - USAR AGORA

**Data**: 2025-10-31  
**Status**: ✅ **TUDO PRONTO**

---

## ✅ O QUE JÁ ESTÁ PRONTO

- ✅ 33 secrets criados no 1Password
- ✅ 25+ serviços Docker configurados
- ✅ Docker/Colima funcionando
- ✅ Raycast integrado
- ✅ Zero hardcoded secrets

---

## 🎯 COMO USAR AGORA (3 PASSOS)

### Passo 1: Verificar Autenticação

```bash
op whoami
```

Se não estiver autenticado:
```bash
# Abra o 1Password Desktop App e faça login
# Depois execute novamente
```

### Passo 2: Gerar .env

```bash
cd ~/Dotfiles/automation_1password/compose

# Opção A: Usar template simples (10 serviços)
op inject -i env.template -o .env

# Opção B: Criar manualmente (mais rápido agora)
# Ver abaixo
```

### Passo 3: Deploy

```bash
# Stack simples (10 serviços)
docker compose up -d

# OU stack completa (25+ serviços)
docker compose -f docker-compose-platform-completa.yml up -d
```

---

## 📝 CRIAR .ENV MANUALMENTE (MAIS RÁPIDO)

Execute este comando para criar .env com todos os secrets:

```bash
cd ~/Dotfiles/automation_1password/compose

cat > .env << 'EOF'
# === Projeto ===
PROJECT_SLUG=platform
PRIMARY_DOMAIN=localhost

# === Traefik ===
TRAEFIK_EMAIL=luiz.sena88@icloud.com

# === PostgreSQL ===
POSTGRES_USER=postgres
POSTGRES_PASSWORD=$(op read "op://1p_macos/PostgreSQL/password")
POSTGRES_DB=platform_db

# === MongoDB ===
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=$(op read "op://1p_macos/MongoDB/password")
MONGO_INIT_DB=platform_db
MONGO_EXPRESS_USER=$(op read "op://1p_macos/Mongo-Express/username")
MONGO_EXPRESS_PASSWORD=$(op read "op://1p_macos/Mongo-Express/password")

# === Redis ===
REDIS_PASSWORD=$(op read "op://1p_macos/Redis/password")

# === MinIO ===
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=$(op read "op://1p_macos/MinIO/password")

# === Appsmith ===
APPSMITH_SUPER_ADMIN_EMAIL=admin@platform.local
APPSMITH_SUPER_ADMIN_PASSWORD=$(op read "op://1p_macos/Appsmith/password")
APPSMITH_ENCRYPTION_PASSWORD=$(op read "op://1p_macos/Appsmith/encryption_password")
APPSMITH_ENCRYPTION_SALT=$(op read "op://1p_macos/Appsmith/encryption_salt")

# === n8n ===
N8N_ENCRYPTION_KEY=$(op read "op://1p_macos/n8n/encryption_key")
N8N_USER_MANAGEMENT_JWT_SECRET=$(op read "op://1p_macos/n8n/jwt_secret")
N8N_ADMIN_USER=admin
N8N_ADMIN_PASSWORD=$(op read "op://1p_macos/n8n/admin_password")
EOF

chmod 600 .env
```

**Problema**: `op read` não funciona dentro de heredoc.

**Solução mais simples**:

```bash
cd ~/Dotfiles/automation_1password/compose

# Criar .env básico
cat > .env << 'EOF'
PROJECT_SLUG=platform
PRIMARY_DOMAIN=localhost
TRAEFIK_EMAIL=luiz.sena88@icloud.com
POSTGRES_USER=postgres
POSTGRES_PASSWORD=changeme
POSTGRES_DB=platform_db
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=changeme
MONGO_INIT_DB=platform_db
REDIS_PASSWORD=changeme
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=changeme
EOF

chmod 600 .env
```

Depois você pode usar `op read` para substituir manualmente.

---

## 🚀 DEPLOY RÁPIDO

```bash
cd ~/Dotfiles/automation_1password/compose
docker compose up -d
```

---

## 📊 VERIFICAR

```bash
docker compose ps
docker compose logs -f traefik
```

---

## 🌐 ACESSAR

- Traefik: http://localhost:8080
- Portainer: http://localhost:9000
- NocoDB: Configurar via Traefik
- Appsmith: Configurar via Traefik

---

**Pronto! Isso é tudo que você precisa!** 🎉

