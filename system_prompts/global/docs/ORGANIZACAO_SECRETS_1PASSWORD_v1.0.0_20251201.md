# 🔐 Organização de Secrets e Variáveis no 1Password

**Versão:** 1.0.0  
**Data:** 2025-12-01  
**Status:** ✅ Organizado

## 📋 Política de Governança

### Vaults e Propósitos

- **`1p_macos`**: Secrets para ambiente de desenvolvimento local (macOS)
- **`1p_vps`**: Secrets para ambiente de produção (VPS Ubuntu)

### Princípios

1. **Separação de Ambientes**: Dev e Prod nunca compartilham os mesmos secrets
2. **Nomenclatura Padronizada**: `VAULT/ITEM/FIELD` seguindo padrão `op://`
3. **Documentação Completa**: Todos os secrets devem estar documentados
4. **Rotação Periódica**: Secrets devem ser rotacionados conforme política de segurança

---

## 🔑 Secrets - Vault `1p_macos` (Desenvolvimento)

### APIs de IA

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `GitHub` | `copilot_token` | GitHub Copilot Token | GitHub Copilot, GitHub API |
| `OpenAI` | `api_key` | OpenAI API Key | ChatGPT Plus, OpenAI API |
| `Anthropic` | `api_key` | Anthropic Claude API Key | Claude Code, Claude.ai |
| `Google` | `gemini_api_key` | Google Gemini API Key | Gemini CLI, Gemini Web |
| `HuggingFace` | `token` | Hugging Face API Token | Hugging Face MCP, Modelos HF |

### 1Password Connect

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `1Password-Connect` | `token` | 1Password Connect Token | 1Password Connect Server Local |

### Infraestrutura Local

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `PostgreSQL Stack Local` | `username` | PostgreSQL Username | Docker Stack Local |
| `PostgreSQL Stack Local` | `password` | PostgreSQL Password | Docker Stack Local |
| `PostgreSQL Stack Local` | `database` | PostgreSQL Database Name | Docker Stack Local |
| `Redis Stack Local` | `password` | Redis Password | Docker Stack Local |

### Serviços Locais

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Traefik` | `email` | Traefik Email (Let's Encrypt) | Traefik SSL Certificates |
| `Traefik` | `dashboard_auth` | Traefik Dashboard Auth | Traefik Dashboard |
| `Grafana` | `username` | Grafana Admin Username | Grafana Dashboard |
| `Grafana` | `password` | Grafana Admin Password | Grafana Dashboard |
| `n8n` | `username` | n8n Basic Auth Username | n8n Workflow Automation |
| `n8n` | `password` | n8n Basic Auth Password | n8n Workflow Automation |
| `Dify` | `secret_key` | Dify Secret Key | Dify AI Platform |
| `NocoDB` | `jwt_secret` | NocoDB JWT Secret | NocoDB Database |

### SMTP Local

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `SMTP` | `host` | SMTP Host | Email Local |
| `SMTP` | `port` | SMTP Port | Email Local |
| `SMTP` | `user` | SMTP User | Email Local |
| `SMTP` | `password` | SMTP Password | Email Local |
| `SMTP` | `from` | SMTP From Email | Email Local |

### APIs Externas

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `API-VPS-HOSTINGER` | `credential` | Hostinger VPS API Token | Hostinger API |

---

## 🔑 Secrets - Vault `1p_vps` (Produção)

### 1Password Connect

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `1Password-Connect` | `token` | 1Password Connect Token | 1Password Connect Server VPS |

### Cloudflare

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Cloudflare` | `API_TOKEN` | Cloudflare API Token | DNS Management |
| `Cloudflare` | `ZONE_ID` | Cloudflare Zone ID | DNS Management |
| `Cloudflare` | `ACCOUNT_ID` | Cloudflare Account ID | Cloudflare API |
| `Cloudflare` | `EMAIL` | Cloudflare Email | Cloudflare Account |
| `Cloudflare` | `DOMAIN` | Domain Name (Production) | Domain Configuration |

### Infraestrutura Produção

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Postgres-Prod` | `USER` | PostgreSQL Username | PostgreSQL Production |
| `Postgres-Prod` | `PASSWORD` | PostgreSQL Password | PostgreSQL Production |
| `Postgres-Prod` | `DB` | PostgreSQL Database | PostgreSQL Production |
| `Redis-Prod` | `password` | Redis Password | Redis Production |

### Serviços Produção

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Traefik-Auth` | `basicauth` | Traefik Dashboard Auth | Traefik Dashboard Production |
| `Grafana-Auth` | `USER` | Grafana Admin Username | Grafana Production |
| `Grafana-Auth` | `PASSWORD` | Grafana Admin Password | Grafana Production |
| `N8N-Auth` | `USER` | n8n Basic Auth Username | n8n Production |
| `N8N-Auth` | `PASSWORD` | n8n Basic Auth Password | n8n Production |
| `Dify` | `SECRET_KEY` | Dify Secret Key | Dify Production |

### SMTP Produção

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `SMTP` | `HOST` | SMTP Host | Email Production |
| `SMTP` | `PORT` | SMTP Port | Email Production |
| `SMTP` | `USER` | SMTP User | Email Production |
| `SMTP` | `PASSWORD` | SMTP Password | Email Production |
| `SMTP` | `FROM` | SMTP From Email | Email Production |

### Service Account

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Service_Account_vps` | `credential` | 1Password Service Account Token | 1Password Automation VPS |

---

## 📝 Referências de Uso

### Formato Padrão

Todas as referências seguem o formato:
```
op://VAULT/ITEM/FIELD
```

### Exemplos de Uso

```bash
# GitHub Token
export GITHUB_TOKEN="$(op read op://1p_macos/GitHub/copilot_token)"

# OpenAI API Key
export OPENAI_API_KEY="$(op read op://1p_macos/OpenAI/api_key)"

# PostgreSQL (Local)
export POSTGRES_USER="$(op read op://1p_macos/PostgreSQL Stack Local/username)"
export POSTGRES_PASSWORD="$(op read op://1p_macos/PostgreSQL Stack Local/password)"

# Cloudflare (Production)
export CF_API_TOKEN="$(op read op://1p_vps/Cloudflare/API_TOKEN)"
export CF_ZONE_ID="$(op read op://1p_vps/Cloudflare/ZONE_ID)"
```

---

## ✅ Checklist de Organização

### Vault `1p_macos`

- [ ] GitHub/copilot_token
- [ ] OpenAI/api_key
- [ ] Anthropic/api_key
- [ ] Google/gemini_api_key
- [ ] HuggingFace/token
- [ ] 1Password-Connect/token
- [ ] PostgreSQL Stack Local (username, password, database)
- [ ] Redis Stack Local/password
- [ ] Traefik (email, dashboard_auth)
- [ ] Grafana (username, password)
- [ ] n8n (username, password)
- [ ] Dify/secret_key
- [ ] NocoDB/jwt_secret
- [ ] SMTP (host, port, user, password, from)
- [ ] API-VPS-HOSTINGER/credential

### Vault `1p_vps`

- [ ] 1Password-Connect/token
- [ ] Cloudflare (API_TOKEN, ZONE_ID, ACCOUNT_ID, EMAIL, DOMAIN)
- [ ] Postgres-Prod (USER, PASSWORD, DB)
- [ ] Redis-Prod/password
- [ ] Traefik-Auth/basicauth
- [ ] Grafana-Auth (USER, PASSWORD)
- [ ] N8N-Auth (USER, PASSWORD)
- [ ] Dify/SECRET_KEY
- [ ] SMTP (HOST, PORT, USER, PASSWORD, FROM)
- [ ] Service_Account_vps/credential

---

## 🔄 Manutenção

### Rotação de Secrets

- **APIs de IA**: Rotacionar a cada 90 dias ou quando expirado
- **Infraestrutura**: Rotacionar a cada 180 dias
- **Cloudflare**: Rotacionar a cada 90 dias
- **SMTP**: Rotacionar a cada 180 dias ou quando necessário

### Auditoria

Execute periodicamente:
```bash
./system_prompts/global/scripts/auditar-1password-secrets_v1.0.0_20251130.sh
```

---

**Última atualização:** 2025-12-01  
**Próxima revisão:** 2026-01-01

