# Mapeamento de Categorias 1Password

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 📋 Visão Geral

Este documento define quando usar cada categoria do 1Password, garantindo classificação correta e consistente de todos os itens.

---

## 🏷️ Categorias Disponíveis

### API_CREDENTIAL

**Uso:** Chaves de API, tokens de acesso e credenciais de API.

**Quando usar:**
- Chaves de API de serviços externos (OpenAI, Anthropic, Google, etc.)
- Tokens de acesso (GitHub, GitLab, etc.)
- Service Account tokens (GCP, AWS)
- Webhook tokens
- API keys de qualquer serviço

**Quando NÃO usar:**
- Credenciais de login (usuário/senha) → usar `LOGIN`
- Senhas isoladas → usar `PASSWORD`
- Documentos JSON → usar `DOCUMENT`

**Exemplos:**
- `OPENAI_API_KEY_MACOS` → API_CREDENTIAL
- `GITHUB_TOKEN` → API_CREDENTIAL
- `GCP_SERVICE_ACCOUNT_VPS` → API_CREDENTIAL
- `CLOUDFLARE_API_TOKEN` → API_CREDENTIAL

**Campos típicos:**
- `credential` ou `password` (para o valor da chave/token)
- `notes` (opcional - informações adicionais)

---

### LOGIN

**Uso:** Credenciais de login (usuário + senha) para serviços web ou aplicações.

**Quando usar:**
- Login em sites (GitHub, Hostinger, etc.)
- Credenciais de aplicações web (n8n, Chatwoot, etc.)
- Acesso a painéis administrativos
- Qualquer caso com usuário E senha juntos

**Quando NÃO usar:**
- Apenas API keys → usar `API_CREDENTIAL`
- Apenas senhas → usar `PASSWORD`
- Tokens de acesso → usar `API_CREDENTIAL`

**Exemplos:**
- `GITHUB_LOGIN` → LOGIN
- `N8N_LOGIN_VPS` → LOGIN
- `HOSTINGER_LOGIN` → LOGIN
- `CHATWOOT_LOGIN` → LOGIN

**Campos típicos:**
- `username` ou `email`
- `password`
- `url` (opcional - URL do serviço)
- `notes` (opcional)

---

### PASSWORD

**Uso:** Senhas isoladas, sem usuário associado.

**Quando usar:**
- Senhas de bancos de dados (sem usuário no nome)
- Senhas de serviços (Redis, MongoDB, etc.)
- JWT secrets
- Senhas de criptografia
- Qualquer senha sem contexto de login

**Quando NÃO usar:**
- Senhas com usuário → usar `LOGIN`
- API keys → usar `API_CREDENTIAL`
- Tokens → usar `API_CREDENTIAL`

**Exemplos:**
- `POSTGRESQL_PASSWORD_VPS` → PASSWORD
- `REDIS_PASSWORD_MACOS` → PASSWORD
- `JWT_SECRET_VPS` → PASSWORD
- `ENCRYPTION_KEY` → PASSWORD

**Campos típicos:**
- `password` (valor da senha)
- `notes` (opcional - descrição do uso)

---

### DATABASE

**Uso:** Credenciais completas de banco de dados.

**Quando usar:**
- Credenciais de banco de dados com múltiplos campos
- Connection strings completas
- Quando você quer organizar credenciais de DB separadamente

**Quando NÃO usar:**
- Apenas senha → usar `PASSWORD`
- Login web → usar `LOGIN`

**Exemplos:**
- `POSTGRESQL_DATABASE_VPS` → DATABASE
- `MYSQL_DATABASE_MACOS` → DATABASE
- `MONGODB_DATABASE_VPS` → DATABASE

**Campos típicos:**
- `hostname` ou `server`
- `port`
- `database`
- `username`
- `password`
- `connection_string` (opcional)

---

### SSH_KEY

**Uso:** Chaves SSH públicas e privadas.

**Quando usar:**
- Chaves SSH para acesso a servidores
- Chaves de deploy
- Chaves de autenticação SSH

**Exemplos:**
- `SSH_KEY_UNIVERSAL` → SSH_KEY
- `SSH_KEY_VPS` → SSH_KEY
- `GITHUB_SSH_KEY` → SSH_KEY

**Campos típicos:**
- `private_key`
- `public_key` (opcional)
- `notes` (opcional - servidor, usuário, etc.)

---

### DOCUMENT

**Uso:** Arquivos e documentos (JSON, certificados, etc.).

**Quando usar:**
- Arquivos JSON de service accounts (GCP, AWS)
- Certificados SSL/TLS
- Arquivos de configuração sensíveis
- Qualquer documento que precisa ser armazenado

**Quando NÃO usar:**
- Apenas valores de texto → usar categoria apropriada
- Notas de texto → usar `SECURE_NOTE`

**Exemplos:**
- `GCP_SERVICE_ACCOUNT_JSON_VPS` → DOCUMENT
- `SSL_CERTIFICATE_SENAMFO` → DOCUMENT
- `AWS_CREDENTIALS_FILE` → DOCUMENT

**Campos típicos:**
- `document` (arquivo anexado)
- `notes` (opcional - descrição)

---

### SECURE_NOTE

**Uso:** Notas seguras com informações sensíveis, mas não credenciais.

**Quando usar:**
- Configurações sensíveis (não credenciais)
- Informações de conta (IDs, números)
- Recovery codes
- Informações que precisam ser protegidas mas não são credenciais

**Quando NÃO usar:**
- API keys → usar `API_CREDENTIAL`
- Senhas → usar `PASSWORD` ou `LOGIN`
- Credenciais → usar categoria apropriada

**Exemplos:**
- `CLOUDFLARE_ZONE_ID` → SECURE_NOTE
- `GITHUB_RECOVERY_CODES` → SECURE_NOTE
- `PROJECT_CONFIGURATION` → SECURE_NOTE

**Campos típicos:**
- `notes` (conteúdo da nota)
- `notesPlain` (texto simples)

---

### SERVER

**Uso:** Credenciais e configurações de servidores.

**Quando usar:**
- Configurações SMTP
- Configurações de servidor
- Credenciais de serviços de servidor
- Quando não se encaixa em outras categorias mas é relacionado a servidor

**Exemplos:**
- `SMTP_CONFIGURATION` → SERVER
- `TRAEFIK_CONFIG` → SERVER
- `SERVER_ACCESS` → SERVER

**Campos típicos:**
- Depende do tipo de servidor
- Geralmente múltiplos campos

---

### EMAIL_ACCOUNT

**Uso:** Contas de email completas.

**Quando usar:**
- Configurações completas de email
- Credenciais de email com múltiplos campos

**Exemplos:**
- `HOSTINGER_EMAIL_ACCOUNT` → EMAIL_ACCOUNT
- `GMAIL_ACCOUNT` → EMAIL_ACCOUNT

**Campos típicos:**
- `email`
- `password`
- `smtp_server`
- `imap_server`
- `port`

---

### SOFTWARE_LICENSE

**Uso:** Licenças de software.

**Quando usar:**
- Chaves de licença
- Códigos de ativação
- Licenças de software

**Exemplos:**
- `N8N_LICENSE` → SOFTWARE_LICENSE
- `JETBRAINS_LICENSE` → SOFTWARE_LICENSE

---

## 🔄 Mapeamento de Itens Existentes

### Problemas Identificados

#### API Keys como LOGIN
```
❌ OPENAI_API_KEY (categoria: LOGIN)
✅ OPENAI_API_KEY (categoria: API_CREDENTIAL)
```

#### Tokens como LOGIN
```
❌ GITHUB_TOKEN (categoria: LOGIN)
✅ GITHUB_TOKEN (categoria: API_CREDENTIAL)
```

#### Secrets como SECURE_NOTE
```
❌ GOOGLE_API_KEY (categoria: SECURE_NOTE)
✅ GOOGLE_API_KEY (categoria: API_CREDENTIAL)
```

---

## 📋 Checklist de Categoria

Antes de criar/atualizar um item, verifique:

- [ ] É uma API key ou token? → `API_CREDENTIAL`
- [ ] É usuário + senha? → `LOGIN`
- [ ] É apenas senha? → `PASSWORD`
- [ ] É banco de dados completo? → `DATABASE`
- [ ] É chave SSH? → `SSH_KEY`
- [ ] É arquivo/documento? → `DOCUMENT`
- [ ] É nota/informação (não credencial)? → `SECURE_NOTE`
- [ ] É configuração de servidor? → `SERVER`
- [ ] É conta de email? → `EMAIL_ACCOUNT`
- [ ] É licença? → `SOFTWARE_LICENSE`

---

## 🔗 Referências

- [Padrões de Nomenclatura](./nomenclature.md)
- [Sistema de Tags](./tags.md)
- [Templates de Itens](../templates/item-templates.yaml)

---

**Última atualização:** 2025-11-17

