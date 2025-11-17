# 🍪 Fix: N8N_SECURE_COOKIE para Setup via HTTP

**Problema:** n8n exigindo cookies seguros (HTTPS) mas acesso é via HTTP temporário

---

## ✅ Correção Aplicada

**Variável adicionada:**
```yaml
- N8N_SECURE_COOKIE=false
```

**Por quê:** Permite cookies não seguros para setup inicial via HTTP

---

## 🚀 Status

**Container recriado com:**
- ✅ `N8N_SECURE_COOKIE=false`
- ✅ Porta 5678 exposta
- ✅ Trust proxy configurado

---

## ✅ Testar Setup Agora

**Acessar no navegador:**
```
http://147.79.81.59:5678/setup
```

**Agora deve funcionar sem erro de cookies!**

---

## ⚠️ IMPORTANTE: Após Setup

**Quando mudar para HTTPS via Traefik:**

1. **Alterar para:**
   ```yaml
   - N8N_SECURE_COOKIE=true  # ou remover (padrão é true)
   ```

2. **Remover porta exposta:**
   ```yaml
   # ports:
   #   - "5678:5678"
   ```

3. **Recriar:**
   ```bash
   docker compose -f docker-compose.traefik-existing-FIXED.yml up -d --force-recreate n8n
   ```

---

**Agora tente criar a conta owner novamente!**


