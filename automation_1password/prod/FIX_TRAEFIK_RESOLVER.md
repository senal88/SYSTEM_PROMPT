# 🔧 Fix: Traefik Resolver "letsencrypt" não existe

**Erro:** `the router n8n@docker uses a non-existent resolver: letsencrypt`

---

## 🔍 Problema

O Traefik v2.10 existente não tem o resolver `letsencrypt` configurado, mas as labels do n8n estão tentando usá-lo.

---

## ✅ Soluções

### Opção 1: Remover Referência ao Resolver (Mais Simples)

**Editar docker-compose.traefik-existing.yml:**

Remover ou comentar:
```yaml
# - "traefik.http.routers.n8n.tls.certresolver=letsencrypt"
```

E usar apenas:
```yaml
- "traefik.http.routers.n8n.tls=true"
```

O Traefik usará certificados existentes ou gerará automaticamente.

### Opção 2: Verificar Resolver do Traefik Existente

```bash
# Ver configuração do Traefik
docker inspect traefik | grep -i cert

# Ver logs para identificar resolver
docker logs traefik 2>&1 | grep -i resolver

# Ver comandos do Traefik
docker inspect traefik --format '{{range .Config.Cmd}}{{println .}}{{end}}'
```

Se encontrar outro nome de resolver (ex: `acme`, `cloudflare`), usar esse.

### Opção 3: Usar Sem TLS (Temporário)

Se não precisa de SSL agora:

**Remover labels de TLS:**
```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.n8n.rule=Host(`n8n.senamfo.com.br`)"
  - "traefik.http.routers.n8n.entrypoints=web"  # HTTP apenas
  - "traefik.http.services.n8n.loadbalancer.server.port=5678"
```

---

## 🚀 Correção Rápida

**Já aplicada no arquivo `docker-compose.traefik-existing.yml`:**

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.n8n.rule=Host(`n8n.senamfo.com.br`)"
  - "traefik.http.routers.n8n.entrypoints=websecure"
  - "traefik.http.routers.n8n.tls=true"  # Sem resolver específico
  - "traefik.http.services.n8n.loadbalancer.server.port=5678"
```

---

## 🔄 Aplicar Correção

```bash
# Na VPS
cd ~/automation_1password/prod

# Atualizar container n8n com novas labels
docker compose -f docker-compose.traefik-existing.yml up -d --force-recreate n8n

# Verificar logs do Traefik (não deve mais dar erro)
docker logs traefik --tail=20 | grep -i n8n
```

---

## ✅ Após Correção

**Status esperado:**
- ✅ n8n detectado pelo Traefik
- ✅ Sem erro de resolver
- ✅ Rota funcionando (HTTP ou HTTPS dependendo do Traefik)

**Testar:**
```bash
curl -I http://n8n.senamfo.com.br
# ou
curl -I https://n8n.senamfo.com.br
```

---

**Arquivo já corrigido - basta recriar o container n8n!**

