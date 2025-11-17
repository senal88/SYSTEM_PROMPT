# 🚀 Configurar Traefik para n8n.senamfo.com.br

**Objetivo:** Acessar n8n via `https://n8n.senamfo.com.br` com SSL automático

---

## 📋 Pré-requisitos

- ✅ DNS configurado (`n8n.senamfo.com.br` → CNAME manager)
- ✅ Cloudflare proxy ativado para `n8n.senamfo.com.br`
- ✅ VPS acessível (147.79.81.59)
- ✅ Portas 80 e 443 abertas no firewall

---

## 🔧 Passo a Passo

### 1. Adicionar Variável ao .env

```bash
# Na VPS
cd ~/automation_1password/prod

# Adicionar email do Traefik
echo "TRAEFIK_EMAIL=luizfernandomoreirasena@gmail.com" >> .env
```

### 2. Ativar Proxy no Cloudflare

**No Dashboard Cloudflare:**

1. Acessar: https://dash.cloudflare.com
2. Selecionar domínio: `senamfo.com.br`
3. Ir em **DNS → Records**
4. Encontrar: `n8n.senamfo.com.br`
5. Clicar no ícone de nuvem cinza → Vira laranja (proxy ativado)
6. Salvar

**Status esperado:** 🟠 Nuvem laranja (proxy ativo)

### 3. Migrar para docker-compose com Traefik

```bash
# Na VPS
cd ~/automation_1password/prod

# Parar stack atual
docker compose -f docker-compose.yml down

# Usar novo compose com Traefik
docker compose -f docker-compose.traefik.yml config  # Validar

# Iniciar com Traefik
docker compose -f docker-compose.traefik.yml up -d
```

### 4. Verificar Status

```bash
# Ver containers
docker compose -f docker-compose.traefik.yml ps

# Ver logs do Traefik
docker compose -f docker-compose.traefik.yml logs traefik

# Verificar certificado SSL
docker exec platform_traefik ls -la /letsencrypt/acme.json
```

### 5. Testar Acesso

**URLs:**
- ✅ `https://n8n.senamfo.com.br` (com SSL)
- ✅ `http://n8n.senamfo.com.br` (redireciona para HTTPS)
- ✅ `https://traefik.senamfo.com.br` (Dashboard Traefik)

---

## ⚠️ Troubleshooting

### Certificado SSL não gerado

**Verificar logs:**
```bash
docker compose -f docker-compose.traefik.yml logs traefik | grep -i acme
```

**Possíveis causas:**
- Porta 80/443 bloqueada no firewall
- DNS não propagado
- Cloudflare proxy bloqueando validação ACME

**Solução:**
- Verificar firewall: `sudo ufw allow 80/tcp && sudo ufw allow 443/tcp`
- Usar DNS challenge se TLS challenge falhar

### n8n não acessível via domínio

**Verificar:**
```bash
# Ver rotas Traefik
docker exec platform_traefik traefik version

# Ver logs n8n
docker compose -f docker-compose.traefik.yml logs n8n

# Testar porta interna
docker exec platform_n8n wget -O- http://localhost:5678/healthz
```

**Verificar DNS:**
```bash
dig n8n.senamfo.com.br
nslookup n8n.senamfo.com.br
```

---

## 🔐 Segurança

### Firewall Rules Cloudflare

**Configurar regras no Cloudflare:**
1. Security → WAF → Rules
2. Criar regra para `n8n.senamfo.com.br`:
   - Rate limiting
   - Geo-blocking (se necessário)
   - Bot protection

### Autenticação Traefik Dashboard (Opcional)

Adicionar basic auth ao Traefik:

```yaml
# Em docker-compose.traefik.yml, adicionar:
labels:
  - "traefik.http.middlewares.traefik-auth.basicauth.users=admin:$$apr1$$senha_hash"
  - "traefik.http.routers.traefik-dashboard.middlewares=traefik-auth"
```

Gerar hash:
```bash
htpasswd -nb admin senha
```

---

## 📊 Checklist Final

- [ ] Email adicionado ao .env (`TRAEFIK_EMAIL`)
- [ ] Proxy Cloudflare ativado para `n8n.senamfo.com.br`
- [ ] Stack migrada para `docker-compose.traefik.yml`
- [ ] Traefik iniciado e healthy
- [ ] Certificado SSL gerado
- [ ] Acesso via `https://n8n.senamfo.com.br` funcionando
- [ ] Redirecionamento HTTP→HTTPS funcionando

---

## 🎯 Resultado Esperado

Após configuração:

✅ **n8n:** `https://n8n.senamfo.com.br` (SSL automático)  
✅ **Traefik:** `https://traefik.senamfo.com.br` (Dashboard)  
✅ **SSL:** Let's Encrypt automático via Traefik  
✅ **Segurança:** Cloudflare proxy ativo

---

**Próximo passo:** Executar passos acima para ativar Traefik! 🚀

