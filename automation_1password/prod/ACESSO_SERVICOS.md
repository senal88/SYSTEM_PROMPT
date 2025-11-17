# 🌐 Acesso aos Serviços - VPS

**VPS:** 147.79.81.59 (senamfo.com.br)

---

## 🔗 URLs de Acesso

### n8n (Workflow Automation)

**Local (na VPS):**
```
http://localhost:5678
```

**Externo:**
```
http://147.79.81.59:5678
http://senamfo.com.br:5678
```

**Credenciais:**
- Usuário: `admin`
- Senha: Verificar em `~/.env` (campo `N8N_PASSWORD`)

**Ver senha:**
```bash
cd ~/automation_1password/prod
grep N8N_PASSWORD .env
```

---

### Qdrant (Vector Store)

**REST API:**
```
http://147.79.81.59:6333
http://senamfo.com.br:6333
```

**gRPC:**
```
147.79.81.59:6334
senamfo.com.br:6334
```

**Health Check:**
```
curl http://147.79.81.59:6333/health
```

**Dashboard (se habilitado):**
```
http://147.79.81.59:6333/dashboard
```

---

### PostgreSQL (Database)

**Conexão Interna (de containers):**
```
Host: postgres-ai
Port: 5432
Database: n8n
User: n8n
Password: (ver .env → POSTGRES_PASSWORD)
```

**Conexão Externa (se porta exposta):**
```
Host: 147.79.81.59
Port: 5432 (se exposta)
Database: n8n
User: n8n
Password: (ver .env → POSTGRES_PASSWORD)
```

**Testar conexão:**
```bash
docker exec -it platform_postgres_ai psql -U n8n -d n8n
```

---

## 🔐 Como Ver Secrets

```bash
cd ~/automation_1password/prod

# Ver todas as variáveis (sem valores)
grep -E '^[A-Z_]+=' .env | cut -d= -f1

# Ver valores específicos
grep POSTGRES_PASSWORD .env
grep N8N_PASSWORD .env
grep N8N_ENCRYPTION_KEY .env
```

---

## 🛡️ Segurança

**IMPORTANTE:** 
- As portas estão expostas publicamente
- Configure firewall se necessário
- Considere usar Traefik com SSL
- Não compartilhe URLs publicamente sem autenticação adequada

**Firewall (UFW) recomendado:**
```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 5678/tcp   # n8n (ou apenas se necessário)
sudo ufw allow 6333/tcp   # Qdrant (ou apenas se necessário)
sudo ufw enable
```

---

**Use estas URLs para acessar os serviços!**

