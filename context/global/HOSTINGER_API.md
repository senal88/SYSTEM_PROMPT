# 🌐 Hostinger API - Contexto Global

**Versão:** 1.0.0
**Última Atualização:** 2025-01-17

---

## 📋 Informações da API

- **Base URL:** `https://developers.hostinger.com`
- **Autenticação:** Bearer Token
- **Content-Type:** `application/json`
- **Documentação:** https://developers.hostinger.com
- **SDKs Disponíveis:** CLI, Python, PHP, Node/TypeScript, Terraform, Ansible

---

## 🔑 API Key

- **Nome:** `API-VPS-HOSTINGER`
- **1Password:** `op://1p_macos/API-VPS-HOSTINGER/credential`
- **Variável de Ambiente:** `HOSTINGER_API_KEY`
- **Uso:** Gerenciamento de VPS, Domínios, DNS, Hosting via API

---

## 📚 Endpoints Principais

### VPS Management

- `/api/vps/v1/virtual-machines` - Listar/criar VPS
- `/api/vps/v1/virtual-machines/{id}/actions` - Ações (start/stop/restart)
- `/api/vps/v1/virtual-machines/{id}/backups` - Backups
- `/api/vps/v1/virtual-machines/{id}/snapshot` - Snapshots
- `/api/vps/v1/docker` - Docker Compose projects

### Domains

- `/api/domains/v1/portfolio` - Gerenciar domínios
- `/api/domains/v1/availability` - Verificar disponibilidade

### DNS

- `/api/dns/v1/zones/{domain}` - Gerenciar DNS zones
- `/api/dns/v1/snapshots/{domain}` - Snapshots DNS

### Hosting

- `/api/hosting/v1/websites` - Gerenciar websites
- `/api/hosting/v1/orders` - Pedidos de hosting

---

## 🔧 Uso

### Via CLI (hapi)

```bash
# Instalar CLI
# Ver: https://github.com/hostinger/api-cli

# Listar VPS
hapi vps vm list

# Criar VPS
hapi vps vm create --template-id 1 --datacenter-code us-central1
```

### Via cURL

```bash
# Obter API Key do 1Password
export HOSTINGER_API_KEY=$(op read "op://1p_macos/API-VPS-HOSTINGER/credential")

# Listar VPS
curl -H "Authorization: Bearer $HOSTINGER_API_KEY" \
     https://developers.hostinger.com/api/vps/v1/virtual-machines
```

### Via Python SDK

```python
from hostinger_api import HostingerAPI

api_key = os.getenv('HOSTINGER_API_KEY')
client = HostingerAPI(api_key)

# Listar VPS
vms = client.vps.virtual_machines.list()
```

---

## 📁 Arquivos de Referência

- **OpenAPI JSON:** `~/10_INFRAESTRUTURA_VPS/framework/api-1.json`
- **OpenAPI YAML:** `~/10_INFRAESTRUTURA_VPS/framework/api-1.yaml`
- **Documentação:** `~/VAULT_OBSIDIAN/Clippings/Hostinger API Reference.md`

---

**Última atualização:** 2025-01-17
