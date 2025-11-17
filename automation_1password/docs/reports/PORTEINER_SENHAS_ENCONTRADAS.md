# 🔍 Portainer - Senhas Encontradas

**Data**: 2025-10-31  
**Status**: ⚠️ **Múltiplas senhas encontradas**

---

## 📋 SENHAS NO VAULT "default importado"

Encontrei estas senhas salvas do Portainer:

| Item | Username | Password |
|------|----------|----------|
| `portainer localhost` | admin | admin |
| `Portainer_new \| macos` | admin | 88Fernando88@ |
| `portainer.senamfo.com.br:9443` | admin | 88Fernando88@ |
| `Portainer:9443` | admin | 88Fernando88@ |
| `portainer.senamfo.com.br` | admin | PortainerAdmin2025 |

---

## ⚠️ PROBLEMA IDENTIFICADO

O primeiro acesso foi salvo no vault **"default importado"** em vez de **"1p_macos"**.

---

## ✅ SOLUÇÃO

### Opção 1: Mover para o vault correto

```bash
# Mover o mais recente
op item move "Portainer_new | macos" --vault-from "default importado" --vault-to "1p_macos" --title "Portainer Admin"
```

### Opção 2: Criar no vault correto

```bash
# Criar no vault 1p_macos
op item create --vault 1p_macos \
  --category password \
  --title "Portainer Admin" \
  username=admin \
  password=SUA_SENHA_ESCOLHIDA
```

---

## 🎯 RECOMENDAÇÃO

Use **`88Fernando88@`** que é a senha mais recente e parece ser a que você usou!

---

**Execute**: `op item move "Portainer_new | macos" --vault-from "default importado" --vault-to "1p_macos" --title "Portainer Admin"`

