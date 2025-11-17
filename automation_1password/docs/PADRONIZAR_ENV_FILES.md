# Padronizar Arquivos .env - Guia Completo

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 🎯 Objetivo

Padronizar todos os arquivos `.env.example` e `.env` seguindo:
- ✅ Nomenclatura `SERVICE_TYPE_ENV`
- ✅ Comentários descritivos
- ✅ Referências ao 1Password
- ✅ Tags recomendadas
- ✅ Organização por seções

---

## 📋 Padrão de Nomenclatura

### Formato

```
SERVICE_TYPE_ENV
```

### Exemplos

- `POSTGRESQL_USER_CHATWOOT_VPS` - Usuário PostgreSQL do Chatwoot na VPS
- `POSTGRESQL_PASSWORD_CHATWOOT_VPS` - Senha PostgreSQL do Chatwoot na VPS
- `REDIS_PASSWORD_CHATWOOT_VPS` - Senha Redis do Chatwoot na VPS
- `CHATWOOT_SECRET_KEY_BASE_VPS` - Secret key base do Chatwoot na VPS
- `RESEND_API_KEY_VPS` - API key do Resend (compartilhada)
- `N8N_API_KEY_VPS` - API key do n8n na VPS

---

## 📝 Estrutura de Arquivo .env

### Template Base

```bash
# ==================================================
#        CONFIGURAÇÕES [SERVICO] - [AMBIENTE]
# ==================================================
# Template de variáveis de ambiente para [Serviço]
# Seguindo padrões de nomenclatura SERVICE_TYPE_ENV
# Última atualização: YYYY-MM-DD

# ==================================================
#        [SEÇÃO 1]
# ==================================================
# Descrição da seção
# Padrão 1Password: ITEM_NAME
VARIAVEL=<valor ou descrição>

# ==================================================
#        NOTAS
# ==================================================
# Todas as credenciais devem ser registradas no 1Password
# seguindo o padrão SERVICE_TYPE_ENV
#
# Exemplos de itens 1Password:
# - ITEM_1 (CATEGORIA)
# - ITEM_2 (CATEGORIA)
#
# Tags recomendadas:
# - environment:vps
# - service:servico
# - type:password
# - status:active
```

---

## 🔧 Padronização por Serviço

### Chatwoot

**Variáveis:**
- `POSTGRESQL_USER_CHATWOOT_VPS` (LOGIN)
- `POSTGRESQL_PASSWORD_CHATWOOT_VPS` (PASSWORD)
- `CHATWOOT_SECRET_KEY_BASE_VPS` (PASSWORD)
- `REDIS_PASSWORD_CHATWOOT_VPS` (PASSWORD)
- `CHATWOOT_BAILEYS_API_KEY_VPS` (PASSWORD)
- `RESEND_API_KEY_VPS` (API_CREDENTIAL)
- `RESEND_SENDER_EMAIL_VPS` (EMAIL_ACCOUNT)

**Tags:**
- `environment:vps`
- `service:chatwoot`
- `type:password` (ou `api_key`, `credentials`)
- `status:active`
- `project:chatwoot`

### n8n

**Variáveis:**
- `N8N_API_KEY_VPS` (API_CREDENTIAL)
- `POSTGRESQL_USER_N8N_VPS` (LOGIN)
- `POSTGRESQL_PASSWORD_N8N_VPS` (PASSWORD)
- `N8N_ENCRYPTION_KEY_VPS` (PASSWORD)

**Tags:**
- `environment:vps`
- `service:n8n`
- `type:api_key` (ou `password`)
- `status:active`
- `project:n8n`

---

## ✅ Checklist de Padronização

Para cada arquivo `.env.example`:

- [ ] Variáveis seguem padrão `SERVICE_TYPE_ENV`
- [ ] Comentários descritivos para cada variável
- [ ] Referência ao item 1Password correspondente
- [ ] Seções organizadas logicamente
- [ ] Notas sobre registro no 1Password
- [ ] Tags recomendadas documentadas
- [ ] Data de última atualização

---

## 🔗 Referências

- [Padrões de Nomenclatura](../standards/nomenclature.md)
- [Sistema de Tags](../standards/tags.md)
- [Templates .env](../templates/env-templates/)

---

**Última atualização:** 2025-11-17

