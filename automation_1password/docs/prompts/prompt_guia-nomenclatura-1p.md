# Guia Rápido: Templates de Variáveis de Ambiente
## 1Password Automation Framework - Nomenclatura Padronizada

**Data:** 2025-10-24  
**Vaults:**
- `1p_macos` → Ambiente macOS Silicon
- `1p_vps` → Ambiente VPS Ubuntu

---

## 📦 Estrutura de Vaults

### 1p_macos (Ambiente macOS Silicon)
```
1p_macos/
├── Databases/
│   ├── Postgres_macos
│   ├── MongoDB_macos
│   ├── Redis_macos
│   ├── Neo4j_macos
│   └── Qdrant_macos
├── AI_Services/
│   ├── OpenAI_API_Key_macos
│   ├── Anthropic_API_Key_macos
│   ├── Gemini_API_Key_macos
│   ├── Perplexity_API_Key_macos
│   └── HuggingFace_Token_macos
├── Dev_Tools/
│   ├── Cursor_API_Key
│   ├── Raycast_Token
│   └── GitHub_Token
├── Infrastructure/
│   ├── Cloudflare_API_Token_macos
│   ├── Cloudflare_Zone_macos
│   ├── VPS_SSH_Key
│   └── Google_Drive_SA_macos
├── Local_Apps/
│   ├── NocoDB_macos
│   ├── n8n_macos
│   ├── Appsmith_macos
│   ├── OpenWebUI_macos
│   ├── Grafana_macos
│   └── Portainer_macos
└── 1Password/
    └── Service_Account_macos
```

### 1p_vps (Ambiente VPS Ubuntu)
```
1p_vps/
├── Databases/
│   ├── Postgres_vps
│   ├── MongoDB_vps
│   ├── Redis_vps
│   ├── Neo4j_vps
│   ├── Qdrant_vps
│   ├── ClickHouse_vps
│   └── MinIO_vps
├── AI_Services/
│   ├── OpenAI_API_Key_vps
│   ├── Anthropic_API_Key_vps
│   └── Gemini_API_Key_vps
├── Application_Secrets/
│   ├── Backend_JWT_Secret
│   ├── Backend_Refresh_Token
│   ├── NocoDB_JWT_Secret
│   ├── NocoDB_Admin
│   ├── n8n_Encryption_Key
│   ├── n8n_Auth
│   ├── Langfuse_Secret
│   ├── Langfuse_Public
│   └── Flowise_Auth
├── Infrastructure/
│   ├── Cloudflare_API_Token_vps
│   ├── Cloudflare_Zone_vps
│   ├── Google_Drive_SA_vps
│   └── Docker_Registry
├── Monitoring/
│   ├── Grafana_Admin
│   ├── Grafana_Secret
│   ├── Portainer_Admin
│   └── Slack_Webhook
├── Proxy/
│   ├── Traefik_Auth
│   └── Backup_Encryption
├── 1Password/
│   ├── Service_Account_vps
│   ├── Connect_Server_Token
│   └── SCIM_Bridge_Token
└── SSH/
    └── VPS_SSH_Key
```

---

## 🚀 Quick Start - macOS

### 1. Criar Vault
```bash
op vault create "1p_macos" --description "Ambiente macOS Silicon"
```

### 2. Template .env.macos

```bash
# 1Password Vault
export OP_VAULT="1p_macos"

# Databases
export MACOS_POSTGRES_PASSWORD="op://1p_macos/Postgres_macos/password"
export MACOS_MONGODB_DB="op://1p_macos/MongoDB_macos/database"
export MACOS_REDIS_HOST="localhost"

# AI Services
export MACOS_OPENAI_API_KEY="op://1p_macos/OpenAI_API_Key_macos/credential"
export MACOS_ANTHROPIC_API_KEY="op://1p_macos/Anthropic_API_Key_macos/credential"
export MACOS_GEMINI_API_KEY="op://1p_macos/Gemini_API_Key_macos/credential"

# Dev Tools
export MACOS_CURSOR_API_KEY="op://1p_macos/Cursor_API_Key/credential"
export MACOS_RAYCAST_API_TOKEN="op://1p_macos/Raycast_Token/credential"
export MACOS_GITHUB_TOKEN="op://1p_macos/GitHub_Token/credential"

# Infrastructure
export MACOS_CF_API_TOKEN="op://1p_macos/Cloudflare_API_Token_macos/credential"
export MACOS_VPS_SSH_KEY="op://1p_macos/VPS_SSH_Key/private_key"
```

### 3. Carregar no Shell
```bash
# Adicionar ao ~/.zshrc
if [[ -f "$HOME/.env.macos" ]]; then
  op run --env-file="$HOME/.env.macos" -- zsh
fi
```

---

## 🖥️ Quick Start - VPS Ubuntu

### 1. Criar Vault
```bash
op vault create "1p_vps" --description "Ambiente VPS Ubuntu"
```

### 2. Template .env.vps

```bash
# 1Password Vault
OP_VAULT=1p_vps
OP_SERVICE_ACCOUNT_TOKEN=op://1p_vps/Service_Account_vps/credential

# Databases
VPS_POSTGRES_PASSWORD=op://1p_vps/Postgres_vps/password
VPS_MONGODB_PASSWORD=op://1p_vps/MongoDB_vps/password
VPS_REDIS_PASSWORD=op://1p_vps/Redis_vps/password

# Application Secrets
VPS_JWT_SECRET=op://1p_vps/Backend_JWT_Secret/password
VPS_NC_AUTH_JWT_SECRET=op://1p_vps/NocoDB_JWT_Secret/password
VPS_N8N_ENCRYPTION_KEY=op://1p_vps/n8n_Encryption_Key/password

# AI Services
VPS_OPENAI_API_KEY=op://1p_vps/OpenAI_API_Key_vps/credential
VPS_GEMINI_API_KEY=op://1p_vps/Gemini_API_Key_vps/credential

# Infrastructure
VPS_CF_API_TOKEN=op://1p_vps/Cloudflare_API_Token_vps/credential
VPS_TRAEFIK_DASHBOARD_AUTH=op://1p_vps/Traefik_Auth/basic_auth

# Monitoring
VPS_GRAFANA_ADMIN_PASSWORD=op://1p_vps/Grafana_Admin/password
VPS_SLACK_WEBHOOK=op://1p_vps/Slack_Webhook/url
```

### 3. Deploy com Secrets
```bash
# Deploy com 1Password Service Account
export OP_SERVICE_ACCOUNT_TOKEN="..."

op run --env-file=/opt/sistema-tributario/.env.vps -- \
  docker-compose up -d
```

---

## 📋 Comandos Essenciais

### Autenticação
```bash
# macOS (biométrico)
eval $(op signin)

# VPS (Service Account)
export OP_SERVICE_ACCOUNT_TOKEN="op_sa_..."
```

### Criar Items
```bash
# Database credentials (macOS)
op item create \
  --vault="1p_macos" \
  --category="Database" \
  --title="Postgres_macos" \
  username=varela_user \
  password=$(openssl rand -base64 32) \
  database=varela_tax \
  port=5432

# Database credentials (VPS)
op item create \
  --vault="1p_vps" \
  --category="Database" \
  --title="Postgres_vps" \
  username=varela_user \
  password=$(openssl rand -base64 32) \
  database=varela_tax \
  port=5432

# API Key (macOS)
op item create \
  --vault="1p_macos" \
  --category="API Credential" \
  --title="OpenAI_API_Key_macos" \
  credential=sk-...

# API Key (VPS)
op item create \
  --vault="1p_vps" \
  --category="API Credential" \
  --title="OpenAI_API_Key_vps" \
  credential=sk-...

# SSH Key
op item create \
  --vault="1p_macos" \
  --category="SSH Key" \
  --title="VPS_SSH_Key" \
  "private key"="$(cat ~/.ssh/id_rsa)"
```

### Ler Secrets
```bash
# Ler valor (macOS)
op read 'op://1p_macos/Postgres_macos/password'

# Ler valor (VPS)
op read 'op://1p_vps/Postgres_vps/password'

# Injetar em comando
export DB_PASS=$(op read 'op://1p_macos/Postgres_macos/password')

# Executar comando com secrets
op run --env-file=.env.macos -- python app.py
```

---

## 🔄 Migration Guide

### De nomenclatura antiga para nova

```bash
# Script de migração
#!/bin/bash

# Migrar vault macOS
OLD_VAULT="MFO_DevOps_Local"
NEW_VAULT="1p_macos"

# Listar todos os items
op item list --vault="$OLD_VAULT" --format=json > old_items_macos.json

# Migrar items
jq -r '.[] | .id' old_items_macos.json | while read item_id; do
  ITEM_NAME=$(op item get "$item_id" --vault="$OLD_VAULT" --format=json | jq -r '.title')
  NEW_NAME=$(echo "$ITEM_NAME" | sed 's/_Local/_macos/g' | sed 's/_Dev/_macos/g')
  
  op item get "$item_id" --vault="$OLD_VAULT" --format=json \
    | jq ".title = \"$NEW_NAME\"" \
    | op item create --vault="$NEW_VAULT"
done

# Migrar vault VPS
OLD_VAULT_VPS="MFO_Production"
NEW_VAULT_VPS="1p_vps"

op item list --vault="$OLD_VAULT_VPS" --format=json > old_items_vps.json

jq -r '.[] | .id' old_items_vps.json | while read item_id; do
  ITEM_NAME=$(op item get "$item_id" --vault="$OLD_VAULT_VPS" --format=json | jq -r '.title')
  NEW_NAME=$(echo "$ITEM_NAME" | sed 's/_Prod/_vps/g' | sed 's/_Production/_vps/g')
  
  op item get "$item_id" --vault="$OLD_VAULT_VPS" --format=json \
    | jq ".title = \"$NEW_NAME\"" \
    | op item create --vault="$NEW_VAULT_VPS"
done
```

### Atualizar referências em arquivos

```bash
# Substituir em todos os arquivos do projeto
find ~/Projetos -type f \( -name "*.yml" -o -name "*.yaml" -o -name "*.env*" -o -name "*.sh" \) \
  -exec sed -i '' \
  -e 's/MFO_DevOps_Local/1p_macos/g' \
  -e 's/_Local/_macos/g' \
  -e 's/_Dev/_macos/g' \
  -e 's/MFO_Production/1p_vps/g' \
  -e 's/_Prod/_vps/g' \
  -e 's/_Production/_vps/g' \
  {} \;

echo "✅ Migração de nomenclatura completa"
```

---

## 🎯 Padrões de Nomenclatura

### Items no 1Password

| Tipo | Padrão | Exemplo macOS | Exemplo VPS |
|------|--------|---------------|-------------|
| Database | `[Service]_macos/vps` | `Postgres_macos` | `Postgres_vps` |
| API Key | `[Provider]_API_Key_macos/vps` | `OpenAI_API_Key_macos` | `OpenAI_API_Key_vps` |
| Auth Credential | `[Service]_Auth` | `NocoDB_Admin` | `Traefik_Auth` |
| Secret/Token | `[Service]_[Type]` | `Backend_JWT_Secret` | `n8n_Encryption_Key` |
| SSH Key | `[Target]_SSH_Key` | `VPS_SSH_Key` | `VPS_SSH_Key` |

### Variáveis de Ambiente

| Ambiente | Prefixo | Sufixo Item | Exemplo Completo |
|----------|---------|-------------|------------------|
| macOS | `MACOS_` | `_macos` | `MACOS_POSTGRES_PASSWORD=op://1p_macos/Postgres_macos/password` |
| VPS | `VPS_` | `_vps` | `VPS_POSTGRES_PASSWORD=op://1p_vps/Postgres_vps/password` |
| Compartilhado | Sem prefixo | Sem sufixo | `OP_SERVICE_ACCOUNT_TOKEN` |

---

## 📚 Documentos de Referência

### Templates Completos
1. **[env-template-macos.md](./env-template-macos.md)** → Template detalhado macOS
2. **[env-template-vps.md](./env-template-vps.md)** → Template detalhado VPS

### Scripts de Automação
3. **generate_macos_env.sh** → Gera .env.macos automaticamente
4. **generate_vps_env.sh** → Gera .env.vps automaticamente
5. **migrate_vaults.sh** → Migra nomenclatura antiga para nova

### Documentação 1Password
- Vaults: https://support.1password.com/vaults/
- CLI: https://developer.1password.com/docs/cli
- Service Accounts: https://developer.1password.com/docs/service-accounts

---

## ✅ Checklist de Implementação

### macOS Silicon
- [ ] Criar vault `1p_macos`
- [ ] Adicionar items com sufixo `_macos`
- [ ] Gerar .env.macos
- [ ] Adicionar ao ~/.zshrc
- [ ] Testar: `op read 'op://1p_macos/Postgres_macos/password'`
- [ ] Atualizar docker-compose.yml com novas referências

### VPS Ubuntu
- [ ] Criar vault `1p_vps`
- [ ] Gerar Service Account
- [ ] Adicionar items com sufixo `_vps`
- [ ] Deploy SCIM Bridge
- [ ] Deploy Connect Server
- [ ] Gerar .env.vps
- [ ] Testar deploy com secrets
- [ ] Configurar backups
- [ ] Configurar monitoring

---

## 🔐 Segurança

### Princípios
1. **Least Privilege**: Service Accounts com permissões mínimas
2. **Rotation**: Tokens rotacionados a cada 30 dias
3. **Audit**: Logs completos via Events API
4. **Backup**: Secrets backupeados em vault separado

### Permissões Recomendadas

**1p_macos:**
- Usuário pessoal: Read/Write
- Service Account: Read Only

**1p_vps:**
- Service Account VPS: Read Only
- Service Account CI/CD: Read Only
- Admin: Read/Write

---

## 🚨 Troubleshooting

### Erro: "vault not found"
```bash
# Listar vaults disponíveis
op vault list

# Criar vault se necessário
op vault create "1p_macos"
op vault create "1p_vps"
```

### Erro: "item not found"
```bash
# Listar items no vault (macOS)
op item list --vault="1p_macos"

# Verificar nome exato
op item get "Postgres_macos" --vault="1p_macos"

# Listar items no vault (VPS)
op item list --vault="1p_vps"
op item get "Postgres_vps" --vault="1p_vps"
```

### Erro: "not authenticated"
```bash
# macOS
eval $(op signin)

# VPS
export OP_SERVICE_ACCOUNT_TOKEN="..."
op whoami
```

---

## 📊 Exemplo Completo de Setup

### macOS - Banco de Dados

```bash
# 1. Criar item no vault
op item create \
  --vault="1p_macos" \
  --category="Database" \
  --title="Postgres_macos" \
  username=varela_user \
  password=$(openssl rand -base64 32) \
  database=varela_tax \
  host=localhost \
  port=5432

# 2. Adicionar ao .env.macos
cat >> ~/.env.macos <<'EOF'
export MACOS_POSTGRES_HOST="localhost"
export MACOS_POSTGRES_PORT="5432"
export MACOS_POSTGRES_DB="op://1p_macos/Postgres_macos/database"
export MACOS_POSTGRES_USER="op://1p_macos/Postgres_macos/username"
export MACOS_POSTGRES_PASSWORD="op://1p_macos/Postgres_macos/password"
EOF

# 3. Testar
op run --env-file=~/.env.macos -- env | grep MACOS_POSTGRES
```

### VPS - API Key

```bash
# 1. Criar item no vault
op item create \
  --vault="1p_vps" \
  --category="API Credential" \
  --title="OpenAI_API_Key_vps" \
  credential=sk-proj-... \
  organization=org-...

# 2. Adicionar ao .env.vps
cat >> /opt/sistema-tributario/.env.vps <<'EOF'
VPS_OPENAI_API_KEY=op://1p_vps/OpenAI_API_Key_vps/credential
VPS_OPENAI_ORG_ID=op://1p_vps/OpenAI_API_Key_vps/organization
EOF

# 3. Testar no deploy
export OP_SERVICE_ACCOUNT_TOKEN="..."
op run --env-file=/opt/sistema-tributario/.env.vps -- \
  docker-compose config | grep OPENAI
```

---

**Guia Versão:** 3.0  
**Última Atualização:** 2025-10-24  
**Nomenclatura:** Sufixos `_macos` e `_vps` (sem dev/prod)  
**Mantido por:** Multi-Family Office – InfraOps