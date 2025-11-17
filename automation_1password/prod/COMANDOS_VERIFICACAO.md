# 🔍 Comandos de Verificação - VPS

**Após deploy:** Use estes comandos para verificar o status da stack

---

## 📊 Status Geral

```bash
cd ~/automation_1password/prod

# Status dos containers
docker compose -f docker-compose.yml ps

# Status com recursos
docker stats --no-stream
```

---

## 📝 Logs

```bash
# Todos os containers
docker compose -f docker-compose.yml logs -f

# Container específico
docker compose -f docker-compose.yml logs -f n8n
docker compose -f docker-compose.yml logs -f postgres-ai
docker compose -f docker-compose.yml logs -f qdrant

# Últimas 50 linhas
docker compose -f docker-compose.yml logs --tail=50
```

---

## 🏥 Health Checks

```bash
# Verificar health status
docker inspect platform_n8n | jq '.[0].State.Health.Status'
docker inspect platform_postgres_ai | jq '.[0].State.Health.Status'
docker inspect platform_qdrant | jq '.[0].State.Health.Status'

# Ou simplificado
docker inspect --format='{{.State.Health.Status}}' platform_n8n
docker inspect --format='{{.State.Health.Status}}' platform_postgres_ai
docker inspect --format='{{.State.Health.Status}}' platform_qdrant
```

---

## 🌐 Testar Endpoints

```bash
# n8n Health
curl -f http://localhost:5678/healthz && echo "✅ n8n OK" || echo "❌ n8n erro"

# Qdrant Health
curl -f http://localhost:6333/health && echo "✅ Qdrant OK" || echo "❌ Qdrant erro"

# PostgreSQL
docker exec -it platform_postgres_ai pg_isready -U n8n && echo "✅ PostgreSQL OK"
```

---

## 🔐 Verificar .env

```bash
# Verificar que .env existe e tem conteúdo
test -f .env && echo "✅ .env existe" || echo "❌ .env não existe"
wc -l .env

# Ver variáveis (sem valores)
grep -E '^[A-Z_]+=' .env | cut -d= -f1
```

---

## 🛑 Parar/Reiniciar

```bash
# Parar
docker compose -f docker-compose.yml down

# Reiniciar
docker compose -f docker-compose.yml restart

# Recriar (mantém volumes)
docker compose -f docker-compose.yml up -d --force-recreate

# Remover tudo (CUIDADO: remove volumes!)
docker compose -f docker-compose.yml down -v
```

---

## 🧹 Limpeza

```bash
# Remover containers parados
docker compose -f docker-compose.yml down

# Limpar imagens não usadas
docker image prune -a

# Ver uso de disco
docker system df
```

---

**Use estes comandos para monitorar a stack após o deploy!**

