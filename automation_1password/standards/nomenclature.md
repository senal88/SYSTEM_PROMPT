# Padrões de Nomenclatura - 1Password

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 📋 Visão Geral

Este documento define os padrões de nomenclatura para todos os itens armazenados no 1Password, garantindo consistência, clareza e facilidade de busca.

---

## 🎯 Formato Padrão

### Estrutura Básica

```
SERVICE_TYPE_ENV
```

Onde:
- **SERVICE**: Nome do serviço/provedor (ex: OPENAI, ANTHROPIC, GOOGLE)
- **TYPE**: Tipo de credencial (ex: API_KEY, TOKEN, PASSWORD, CREDENTIALS)
- **ENV**: Ambiente (opcional) - MACOS, VPS, ou omitido se compartilhado

### Regras Gerais

1. **Uso de MAIÚSCULAS**: Todos os componentes em UPPER_SNAKE_CASE
2. **Sem espaços**: Usar underscore (_) para separar palavras
3. **Sem caracteres especiais**: Apenas letras, números e underscore
4. **Sufixo de ambiente**: Usar apenas quando necessário diferenciar ambientes
5. **Prefira tags**: Para separação por ambiente, usar tags ao invés de sufixos quando possível

---

## 📝 Tipos de Credenciais

### API_KEY
Chaves de API de serviços externos.

**Formato:** `SERVICE_API_KEY_ENV`

**Exemplos:**
- `OPENAI_API_KEY_MACOS`
- `ANTHROPIC_API_KEY_VPS`
- `GOOGLE_API_KEY` (compartilhado)
- `GITHUB_TOKEN` (sem ENV se compartilhado)

**Regras:**
- Sempre usar `API_KEY` (não `API-KEY`, `api_key`, etc.)
- Para tokens GitHub/GitLab, pode usar `TOKEN` ao invés de `API_KEY`

### TOKEN
Tokens de acesso (GitHub, GitLab, 1Password, etc.).

**Formato:** `SERVICE_TOKEN_ENV`

**Exemplos:**
- `GITHUB_TOKEN_MACOS`
- `GITLAB_TOKEN_VPS`
- `1PASSWORD_TOKEN` (compartilhado)

**Regras:**
- Usar `TOKEN` para tokens de acesso
- Diferenciar de `API_KEY` quando aplicável

### PASSWORD
Senhas isoladas (sem usuário associado).

**Formato:** `SERVICE_PASSWORD_ENV`

**Exemplos:**
- `POSTGRESQL_PASSWORD_VPS`
- `REDIS_PASSWORD_VPS`
- `MONGODB_PASSWORD_MACOS`

**Regras:**
- Usar apenas para senhas isoladas
- Se tiver usuário, usar categoria `LOGIN`

### CREDENTIALS
Credenciais completas (usuário + senha ou múltiplos campos).

**Formato:** `SERVICE_CREDENTIALS_ENV`

**Exemplos:**
- `DOCKER_CREDENTIALS_VPS`
- `AWS_CREDENTIALS` (compartilhado)

**Regras:**
- Usar quando há múltiplos campos de autenticação
- Preferir categoria `LOGIN` se for usuário/senha simples

### SERVICE_ACCOUNT
Contas de serviço (GCP, AWS, etc.).

**Formato:** `SERVICE_SERVICE_ACCOUNT_ENV`

**Exemplos:**
- `GCP_SERVICE_ACCOUNT_VPS`
- `AWS_SERVICE_ACCOUNT_MACOS`

**Regras:**
- Especificar o serviço claramente
- Incluir ambiente se específico

---

## 🏷️ Nomes de Serviços Padronizados

### Serviços de IA/LLM
- `OPENAI` - OpenAI
- `ANTHROPIC` - Anthropic (Claude)
- `GOOGLE` - Google (Gemini, GCP)
- `PERPLEXITY` - Perplexity AI
- `HUGGINGFACE` ou `HF` - Hugging Face

### Serviços de Código/Dev
- `GITHUB` - GitHub
- `GITLAB` - GitLab
- `DOCKER` - Docker Hub
- `CURSOR` - Cursor IDE

### Serviços de Infraestrutura
- `CLOUDFLARE` ou `CF` - Cloudflare
- `HOSTINGER` - Hostinger
- `AWS` - Amazon Web Services
- `GCP` - Google Cloud Platform

### Bancos de Dados
- `POSTGRESQL` ou `POSTGRES` - PostgreSQL
- `MYSQL` - MySQL
- `MONGODB` - MongoDB
- `REDIS` - Redis

### Outros Serviços
- `N8N` - n8n
- `CHATWOOT` - Chatwoot
- `TRAEFIK` - Traefik
- `1PASSWORD` ou `1P` - 1Password

---

## 🌍 Sufixos de Ambiente

### Quando Usar

Use sufixos de ambiente (`_MACOS`, `_VPS`) quando:
- A credencial é específica de um ambiente
- Há versões diferentes para cada ambiente
- A credencial não pode ser compartilhada

### Quando NÃO Usar

Não use sufixos quando:
- A credencial é compartilhada entre ambientes
- Você prefere usar tags para separação
- O item é genérico (ex: documentação)

### Ambientes Padronizados

- `_MACOS` - macOS local
- `_VPS` - VPS Ubuntu
- (sem sufixo) - Compartilhado ou genérico

---

## ✅ Exemplos Corretos

### API Keys
```
OPENAI_API_KEY_MACOS
ANTHROPIC_API_KEY_VPS
GOOGLE_API_KEY
GITHUB_TOKEN
HF_TOKEN
```

### Senhas
```
POSTGRESQL_PASSWORD_VPS
REDIS_PASSWORD_MACOS
MONGODB_PASSWORD_VPS
```

### Credenciais
```
DOCKER_CREDENTIALS_VPS
AWS_CREDENTIALS
GCP_SERVICE_ACCOUNT_VPS
```

### Logins
```
GITHUB_LOGIN
N8N_LOGIN_VPS
HOSTINGER_LOGIN
```

---

## ❌ Exemplos Incorretos

### Erros Comuns

```
❌ ANTRHOPIC_API_KEY          → ✅ ANTHROPIC_API_KEY
❌ OpenAI_API_Key_macos       → ✅ OPENAI_API_KEY_MACOS
❌ GEMINI_API_KEY             → ✅ GOOGLE_API_KEY (usar GOOGLE, não GEMINI)
❌ HF_TOKEN                   → ✅ HUGGINGFACE_TOKEN (ou manter HF_TOKEN se já estabelecido)
❌ Openai-API                 → ✅ OPENAI_API_KEY
❌ github.com                 → ✅ GITHUB_LOGIN ou GITHUB_TOKEN
❌ N8N-API-LOCALHOST          → ✅ N8N_API_KEY_MACOS
```

### Problemas de Formato

```
❌ API_KEY_OpenAI             → ✅ OPENAI_API_KEY
❌ token_github               → ✅ GITHUB_TOKEN
❌ password.postgres          → ✅ POSTGRESQL_PASSWORD
❌ Service Account Auth Token → ✅ GCP_SERVICE_ACCOUNT
```

---

## 🔄 Casos Especiais

### Google/Gemini

**Decisão:** Usar `GOOGLE_API_KEY` (não `GEMINI_API_KEY`)

**Razão:**
- A chave é da Google, não específica do Gemini
- Bibliotecas oficiais procuram por `GOOGLE_API_KEY`
- Mantém consistência com outros serviços Google

**Exceção:** Se houver necessidade específica de diferenciar, usar tags.

### Hugging Face

**Decisão:** `HF_TOKEN` ou `HUGGINGFACE_TOKEN` (ambos aceitáveis)

**Razão:**
- `HF` é amplamente reconhecido
- `HUGGINGFACE_TOKEN` é mais descritivo
- Escolher um e manter consistência

### 1Password

**Decisão:** `1PASSWORD_TOKEN` ou `1P_TOKEN` (ambos aceitáveis)

**Razão:**
- `1P` é comum na comunidade
- `1PASSWORD` é mais claro
- Escolher um e manter consistência

---

## 📋 Checklist de Validação

Antes de criar um novo item, verifique:

- [ ] Nome está em UPPER_SNAKE_CASE?
- [ ] Segue o formato SERVICE_TYPE_ENV?
- [ ] Nome do serviço está padronizado?
- [ ] Tipo está correto (API_KEY, TOKEN, PASSWORD)?
- [ ] Sufixo de ambiente está correto (se necessário)?
- [ ] Não há caracteres especiais ou espaços?
- [ ] Não há duplicatas com nomes similares?

---

## 🔗 Referências

- [Categorias 1Password](./categories.md)
- [Sistema de Tags](./tags.md)
- [Regras de Validação](./validation-rules.yaml)

---

**Última atualização:** 2025-11-17

