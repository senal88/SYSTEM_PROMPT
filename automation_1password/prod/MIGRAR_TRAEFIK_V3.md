# 🔄 Migração: Traefik v2.10 → v3.1

**Objetivo:** Substituir Traefik antigo por v3.1 completo com todos os resolvers

---

## ⚠️ Pré-requisitos

- ✅ Backup dos certificados existentes
- ✅ Parar Traefik v2.10
- ✅ Manter rede Docker (`stack-prod_traefik_net`)
- ✅ Não afetar outros containers

---

## 🚀 Migração Passo a Passo

### Passo 1: Backup dos Certificados

```bash
# Na VPS
cd ~/automation_1password/prod

# Backup dos certificados existentes
sudo cp -r /home/luiz.sena88/infra/stack-prod/data/letsencrypt /tmp/letsencrypt_backup_$(date +%Y%m%d)
```

### Passo 2: Parar Traefik v2.10

```bash
# Parar Traefik antigo
docker stop traefik

# Verificar que porta 80/443 está livre
docker ps | grep -E '80|443|traefik'
```

### Passo 3: Iniciar Traefik v3.1

```bash
cd ~/automation_1password/prod

# Validar configuração
docker compose -f TRAEFIK_V3_COMPLETO.yml config

# Iniciar Traefik v3.1
docker compose -f TRAEFIK_V3_COMPLETO.yml up -d
```

### Passo 4: Verificar Funcionamento

```bash
# Status
docker compose -f TRAEFIK_V3_COMPLETO.yml ps

# Logs
docker compose -f TRAEFIK_V3_COMPLETO.yml logs traefik

# Testar endpoints
curl -I http://localhost:8080  # Dashboard
curl -I https://n8n.senamfo.com.br
```

### Passo 5: Recriar n8n com Labels Corretas

```bash
# n8n deve detectar automaticamente, mas recriar para garantir
docker compose -f docker-compose.traefik-existing.yml up -d --force-recreate n8n
```

---

## ✅ Vantagens do Traefik v3.1

### Resolvers Disponíveis

1. **letsencrypt** (TLS Challenge)
   - Para validação direta via porta 80
   - Funciona sem Cloudflare

2. **cloudflare** (DNS Challenge)
   - Para uso com Cloudflare DNS
   - Mais confiável em ambientes com proxy

### Funcionalidades Adicionais

- ✅ Dashboard melhorado
- ✅ Melhor logging
- ✅ Middlewares mais flexíveis
- ✅ Suporte completo a HTTP/3
- ✅ Melhor performance

---

## 🔄 Rollback (Se Necessário)

```bash
# Parar Traefik v3.1
docker compose -f TRAEFIK_V3_COMPLETO.yml down

# Restaurar Traefik v2.10
docker start traefik

# Verificar
docker ps | grep traefik
```

---

## 📋 Checklist de Migração

- [ ] Backup dos certificados feito
- [ ] Traefik v2.10 parado
- [ ] Portas 80/443 livres
- [ ] Traefik v3.1 iniciado
- [ ] Logs sem erros críticos
- [ ] Dashboard acessível
- [ ] n8n funcionando via Traefik v3
- [ ] URLs testadas e OK

---

## 🎯 Resultado Esperado

Após migração:

✅ Traefik v3.1 rodando  
✅ Resolvers `letsencrypt` e `cloudflare` disponíveis  
✅ n8n funcionando sem erro 504  
✅ Certificados válidos  
✅ Dashboard acessível

---

**Pronto para migração quando você quiser!**

