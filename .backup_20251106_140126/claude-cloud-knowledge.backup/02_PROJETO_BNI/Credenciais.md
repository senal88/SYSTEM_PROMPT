# Credenciais NocoDB e PostgreSQL - 1Password

**Data:** 2025-11-04
**Gerenciador:** 1Password

---

## 🔐 Credenciais para Armazenar no 1Password

### 1. PostgreSQL - Banco de Dados

**Item:** `BNI - PostgreSQL Database`

**Campos:**

```
Host: postgres (ou nome do container)
Porta: 5432
Usuário: [seu_usuario_postgres]
Senha: [sua_senha_postgres]
Base de Dados: nocodb (ou nome da base)
Tipo: PostgreSQL
```

**URL de Conexão:**
```
postgresql://[usuario]:[senha]@[host]:5432/[base_dados]
```

**Notas:**
- Usado para conectar NocoDB ao banco de dados
- Mesmas credenciais usadas por outros serviços (n8n, etc.)

---

### 2. NocoDB - Token de API

**Item:** `BNI - NocoDB API Token`

**Campos:**

```
Nome: NOCODB-TOKEN-BNI-1
Token: S4yy49wsOsOh1zdL-_tnSL8I52Mc1xu6VP_rDnAl
URL: http://localhost:8081
Tipo: API Token
```

**Notas:**
- Usado para automações e scripts
- Não expor em repositórios públicos
- Token criado em: Account → Tokens

---

### 3. NocoDB - Conta de Administrador

**Item:** `BNI - NocoDB Admin`

**Campos:**

```
URL: http://localhost:8081
Email: [seu_email_admin]
Senha: [sua_senha_admin]
Tipo: Admin Account
```

**Notas:**
- Primeira conta criada no NocoDB
- Acesso completo ao projeto BNI_GESTAO_IMOBILIARIA

---

## 📋 Checklist de Segurança

- [ ] Credenciais PostgreSQL armazenadas no 1Password
- [ ] Token NocoDB armazenado no 1Password
- [ ] Conta admin NocoDB armazenada no 1Password
- [ ] Arquivo `nocodb_config.json` local (não versionado)
- [ ] Token adicionado ao `.gitignore`

---

## 🔗 Links 1Password

### Credenciais PostgreSQL

**Link direto:** [1Password - PostgreSQL](https://start.1password.com/open/i?a=RTTW3QYD6FGSBFTMETM63HNNO4&v=gkpsbgizlks2zknwzqpppnb2ze&i=ligf3nolmzjg7xqxswjs4uyowy&h=my.1password.com)

**Item no 1Password:** Procure por "BNI - PostgreSQL Database" ou "PostgreSQL"

**Campos disponíveis:**
- Host
- Porta
- Usuário
- Senha
- Base de Dados
- String de Conexão

### Outros Links Úteis

- **Token NocoDB:** [1Password - NocoDB Token](https://start.1password.com/open/i?a=RTTW3QYD6FGSBFTMETM63HNNO4&v=gkpsbgizlks2zknwzqpppnb2ze&i=wgtqezuczcjn6hv54g6g4b3l74&h=my.1password.com)

> **Nota:** Se os links não funcionarem, acesse o 1Password diretamente e procure por:
> - "BNI PostgreSQL"
> - "BNI NocoDB"
> - "PostgreSQL Database"

---

## 💡 Dicas

1. **Organização:** Crie uma pasta "BNI" no 1Password para todas as credenciais
2. **Tags:** Use tags como `database`, `api`, `nocodb` para facilitar busca
3. **Backup:** Certifique-se de que o 1Password está sincronizado
4. **Compartilhamento:** Se necessário, compartilhe apenas com membros da equipe autorizados

---

**Última atualização:** 2025-11-04

