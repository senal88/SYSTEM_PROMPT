# 🔒 Fix SSL - Site Perigoso Chrome

**Problema:** Chrome mostra "Site perigoso" ao acessar n8n

---

## ✅ Diagnóstico Realizado

**Status do servidor:**
- ✅ Certificado Let's Encrypt gerado
- ✅ HTTP/HTTPS respondendo (200/301)
- ✅ Traefik funcionando
- ⚠️ Chrome não confia no certificado

---

## 🎯 Causa e Solução

### Causa Mais Provável

**Proxy Cloudflare não está ativado ou SSL Mode incorreto**

### Solução Imediata

**1. Ativar Proxy Cloudflare (CRÍTICO):**

```
Cloudflare Dashboard:
→ DNS → Records
→ n8n.senamfo.com.br
→ Clicar no ícone de nuvem
→ Deve ficar LARANJA 🟠 (proxy ativado)
```

**2. Configurar SSL Mode:**

```
Cloudflare Dashboard:
→ SSL/TLS → Overview
→ Modo: Flexible (recomendado para início)
```

**3. Aguardar e Testar:**

- Aguardar 1-2 minutos
- Limpar cache do navegador (Ctrl+Shift+Delete)
- Testar em modo anônimo (Ctrl+Shift+N)

---

## 📋 Arquivos de Ajuda

- `FIX_SSL_CERTIFICADO.md` - Guia completo
- `SOLUCAO_CLOUDFLARE_SSL.md` - Solução detalhada
- `COMANDO_FIX_SSL.sh` - Script de diagnóstico

---

## ✅ Status

**Diagnóstico:** Completo  
**Solução:** Configurar Cloudflare  
**Ação:** Manual no Dashboard Cloudflare

**Após ativar proxy, o aviso deve desaparecer!**

