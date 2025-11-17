# Sistema de Tags - 1Password

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 📋 Visão Geral

Este documento define o sistema hierárquico de tags para organização e busca eficiente de itens no 1Password.

---

## 🏷️ Estrutura de Tags

### Formato

```
namespace:value
```

Onde:
- **namespace**: Categoria da tag (environment, service, type, status)
- **value**: Valor específico da tag

### Múltiplas Tags

Um item pode ter múltiplas tags separadas por vírgula ou espaço (dependendo da implementação do 1Password CLI).

**Exemplo:**
```
environment:macos,service:openai,type:api_key,status:active
```

---

## 📂 Namespaces de Tags

### 1. environment

**Uso:** Identificar o ambiente onde a credencial é usada.

**Valores:**
- `macos` - macOS local
- `vps` - VPS Ubuntu
- `shared` - Compartilhado entre ambientes
- `production` - Produção
- `development` - Desenvolvimento
- `staging` - Staging

**Exemplos:**
```
environment:macos
environment:vps
environment:shared
```

**Quando usar:**
- Sempre que a credencial é específica de um ambiente
- Para facilitar filtragem por ambiente
- Alternativa ao sufixo `_MACOS` ou `_VPS` no nome

---

### 2. service

**Uso:** Identificar o serviço/provedor da credencial.

**Valores principais:**
- `openai` - OpenAI
- `anthropic` - Anthropic (Claude)
- `google` - Google (Gemini, GCP)
- `github` - GitHub
- `gitlab` - GitLab
- `docker` - Docker Hub
- `cloudflare` - Cloudflare
- `hostinger` - Hostinger
- `postgresql` - PostgreSQL
- `redis` - Redis
- `mongodb` - MongoDB
- `n8n` - n8n
- `chatwoot` - Chatwoot
- `traefik` - Traefik
- `1password` - 1Password

**Exemplos:**
```
service:openai
service:google
service:github
```

**Quando usar:**
- Sempre que possível
- Facilita busca por serviço
- Útil para agrupamento

---

### 3. type

**Uso:** Identificar o tipo de credencial.

**Valores:**
- `api_key` - Chave de API
- `token` - Token de acesso
- `password` - Senha
- `credentials` - Credenciais completas
- `service_account` - Conta de serviço
- `ssh_key` - Chave SSH
- `certificate` - Certificado
- `license` - Licença

**Exemplos:**
```
type:api_key
type:token
type:password
```

**Quando usar:**
- Sempre que possível
- Complementa a categoria do 1Password
- Facilita filtragem por tipo

---

### 4. status

**Uso:** Status da credencial.

**Valores:**
- `active` - Ativa e em uso
- `inactive` - Inativa (não deletar, apenas marcar)
- `deprecated` - Depreciada (será removida)
- `expired` - Expirada
- `rotated` - Rotacionada (versão antiga)

**Exemplos:**
```
status:active
status:inactive
status:deprecated
```

**Quando usar:**
- Para gerenciar ciclo de vida
- Identificar credenciais obsoletas
- Facilitar limpeza periódica

---

### 5. project (Opcional)

**Uso:** Identificar projeto específico (quando aplicável).

**Valores:**
- Nome do projeto em lowercase
- Ex: `chatwoot`, `n8n`, `gemini-setup`

**Exemplos:**
```
project:chatwoot
project:n8n
```

**Quando usar:**
- Quando a credencial é específica de um projeto
- Para organização por projeto

---

### 6. priority (Opcional)

**Uso:** Prioridade da credencial.

**Valores:**
- `critical` - Crítica (backup obrigatório)
- `high` - Alta importância
- `medium` - Média importância
- `low` - Baixa importância

**Exemplos:**
```
priority:critical
priority:high
```

**Quando usar:**
- Para identificar credenciais críticas
- Planejamento de backup
- Gestão de riscos

---

## 📝 Exemplos Completos

### API Key OpenAI (macOS)
```
Nome: OPENAI_API_KEY_MACOS
Categoria: API_CREDENTIAL
Tags: environment:macos,service:openai,type:api_key,status:active,priority:high
```

### Token GitHub (Compartilhado)
```
Nome: GITHUB_TOKEN
Categoria: API_CREDENTIAL
Tags: environment:shared,service:github,type:token,status:active,priority:critical
```

### Senha PostgreSQL (VPS)
```
Nome: POSTGRESQL_PASSWORD_VPS
Categoria: PASSWORD
Tags: environment:vps,service:postgresql,type:password,status:active
```

### Service Account GCP (VPS)
```
Nome: GCP_SERVICE_ACCOUNT_VPS
Categoria: DOCUMENT
Tags: environment:vps,service:google,type:service_account,status:active,priority:critical
```

### Login n8n (VPS)
```
Nome: N8N_LOGIN_VPS
Categoria: LOGIN
Tags: environment:vps,service:n8n,type:credentials,status:active
```

---

## 🔍 Busca com Tags

### Exemplos de Busca

**Buscar todas as API keys do macOS:**
```
environment:macos AND type:api_key
```

**Buscar credenciais do Google:**
```
service:google
```

**Buscar credenciais críticas:**
```
priority:critical
```

**Buscar credenciais inativas:**
```
status:inactive OR status:deprecated
```

**Buscar credenciais do VPS relacionadas a bancos de dados:**
```
environment:vps AND (service:postgresql OR service:redis OR service:mongodb)
```

---

## 📋 Checklist de Tags

Ao criar/atualizar um item, adicionar tags:

- [ ] `environment:*` (macos, vps, shared)
- [ ] `service:*` (openai, google, github, etc.)
- [ ] `type:*` (api_key, token, password, etc.)
- [ ] `status:active` (ou outro status apropriado)
- [ ] `priority:*` (se aplicável - critical, high, etc.)
- [ ] `project:*` (se específico de projeto)

---

## 🔄 Migração de Itens Existentes

### Estratégia

1. **Adicionar tags gradualmente** - Não precisa fazer tudo de uma vez
2. **Priorizar itens críticos** - Começar com credenciais mais importantes
3. **Usar script de migração** - Automatizar adição de tags baseado em nome/categoria

### Tags Baseadas em Nome

Se o nome contém `_MACOS` → adicionar `environment:macos`
Se o nome contém `_VPS` → adicionar `environment:vps`
Se o nome contém `OPENAI` → adicionar `service:openai`
Se o nome contém `API_KEY` → adicionar `type:api_key`

---

## 🔗 Referências

- [Padrões de Nomenclatura](./nomenclature.md)
- [Mapeamento de Categorias](./categories.md)
- [Script de Migração](../scripts/migrate-1password-items.sh)

---

**Última atualização:** 2025-11-17

