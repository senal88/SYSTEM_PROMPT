# 🔐 Guia: Primeiro Acesso Portainer

**Data**: 2025-10-31  
**Status**: ✅ **Pronto para primeiro acesso**

---

## 🎯 COMO SALVAR SENHA DO PRIMEIRO ACESSO

### 1️⃣ Acesse Portainer

Abra: **http://localhost:9000**

### 2️⃣ Crie o Admin User

Na primeira tela, você verá:

```
Welcome to Portainer
┌─────────────────────────────────────┐
│                                     │
│  Create your admin user             │
│                                     │
│  Username: ____________________     │
│  Password: ____________________     │
│  Confirm:  ____________________     │
│                                     │
│  [Create the user]                  │
└─────────────────────────────────────┘
```

### 3️⃣ Salve no 1Password

**IMPORTANTE**: Use o Raycast para salvar rapidamente!

1. Pressione **CMD+Space** (Raycast)
2. Digite: `1Password`
3. Selecione: `Create`
4. Preencha:
   - **Title**: `Portainer Admin`
   - **Username**: (o que você escolher)
   - **Password**: (a senha que você criou)
   - **Vault**: `1p_macos`
   - **Category**: `Password`
5. Salve

### 4️⃣ OU Use CLI

Após criar o usuário, salve via CLI:

```bash
op item create --vault 1p_macos \
  --category password \
  --title "Portainer Admin" \
  username=admin \
  password=SUA_SENHA_AQUI
```

---

## ⚠️ IMPORTANTE

- O Portainer **EXPIRA** se você não acessar em 5 minutos
- Após expirar, você precisa recriar o volume
- **SEMPRE** salve a senha no 1Password imediatamente!

---

## 🚀 COMANDO RÁPIDO

Se expirar novamente:

```bash
# Recriar Portainer
docker compose -f compose/docker-compose-local.yml down portainer
docker volume rm compose_portainer_data
docker compose -f compose/docker-compose-local.yml up -d portainer

# Aguardar
sleep 30

# Acessar
open http://localhost:9000
```

---

## 📋 CHECKLIST

- [x] Portainer recriado
- [ ] Primeiro acesso realizado
- [ ] Senha salva no 1Password
- [ ] Login testado

---

**Pronto para primeiro acesso!** 🎉

