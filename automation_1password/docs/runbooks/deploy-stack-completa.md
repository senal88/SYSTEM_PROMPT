# Deploy Stack Completa - Plataforma

**Last Updated**: 2025-10-31  
**Versão**: 2.1.0

---

## 🎯 Stack Completa

A stack inclui:
- **Traefik** - Reverse proxy com SSL automático
- **PostgreSQL + pgvector** - Banco relacional + vetores
- **MongoDB** - Banco NoSQL
- **Redis** - Cache e filas
- **NocoDB** - Airtable alternativo
- **Appsmith** - Low-code platform
- **n8n** - Automação workflows
- **Portainer** - Gestão Docker
- **LM Studio** - LLMs local
- **ChromaDB** - Vector database

---

## 🚀 Deploy Automatizado

### Setup Inicial

```bash
# 1. Autenticar 1Password
op signin

# 2. Iniciar Colima (se necessário)
make colima.start

# 3. Deploy completo
bash scripts/platform/deploy_complete_stack.sh
```

### Deploy Manual

```bash
# 1. Gerar .env
make compose.env

# 2. Deploy local
make deploy.local

# 3. Ver logs
make logs.local SERVICE=traefik
```

---

## 📋 Configuração 1Password

### Items Necessários

Antes do deploy, crie estes items no vault `1p_macos`:

#### Traefik
- `Traefik` (email)

#### Databases
- `PostgreSQL` (password)
- `MongoDB` (password)
- `Redis` (password)

#### Apps
- `Appsmith` (password, encryption_password, encryption_salt)
- `n8n` (encryption_key, jwt_secret)

#### AI Services
- `HuggingFace-Token` ✅ (já existe)
- `Perplexity-API` ✅ (já existe)
- `Gemini-API` ✅ (já existe)
- `Cursor-API` ✅ (já existe)

#### Cloudflare
- `Cloudflare` ✅ (já existe no 1p_vps)

#### SMTP
- `SMTP` ✅ (já existe)

---

## 🔧 Acessar Serviços

Após deploy, acesse:

| Serviço | URL Local | URL Produção |
|---------|-----------|--------------|
| Traefik Dashboard | http://localhost:8080 | https://traefik.{{PRIMARY_DOMAIN}} |
| Portainer | http://localhost:9000 | https://portainer.{{PRIMARY_DOMAIN}} |
| NocoDB | Ver logs | https://nocodb.{{PRIMARY_DOMAIN}} |
| Appsmith | Ver logs | https://appsmith.{{PRIMARY_DOMAIN}} |
| n8n | Ver logs | https://n8n.{{PRIMARY_DOMAIN}} |
| LM Studio | Ver logs | https://lmstudio.{{PRIMARY_DOMAIN}} |
| ChromaDB | Ver logs | https://chromadb.{{PRIMARY_DOMAIN}} |

---

## 📊 Verificar Status

```bash
# Ver todos containers
docker compose ps

# Ver logs de um serviço
make logs.local SERVICE=n8n

# Ver uso de recursos
docker stats
```

---

## 🔐 HuggingFace Pro Setup

Para configurar HuggingFace Pro (1TB):

```bash
bash scripts/huggingface/setup_hf_mac.sh
```

Isso configura:
- Cache de datasets
- Cache de models
- Token automático do 1Password

---

## 🚨 Troubleshooting

### Container não sobe
```bash
docker compose logs -f <nome-container>
```

### Erro de autenticação
```bash
op signin
make compose.env
```

### Traefik sem certificados
```bash
make compose.env  # Verificar TRAEFIK_EMAIL
docker compose restart traefik
```

---

**Última atualização**: 2025-10-31  
**Versão**: 2.1.0

