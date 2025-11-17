# Configuração Completa de Email - Hostinger (mfotrust.com)

**Data:** 2025-11-17
**Domínio:** mfotrust.com
**Email:** sena@mfotrust.com

---

## 📧 Configurações de Servidor

### SMTP (Envio)
- **Servidor:** smtp.hostinger.com
- **Porta:** 465
- **Segurança:** SSL/TLS
- **Autenticação:** Sim (usuário completo + senha)
- **Usuário:** sena@mfotrust.com
- **Senha:** [Armazenada no 1Password]

### IMAP (Recebimento)
- **Servidor:** imap.hostinger.com
- **Porta:** 993
- **Segurança:** SSL/TLS
- **Autenticação:** Sim (usuário completo + senha)
- **Usuário:** sena@mfotrust.com
- **Senha:** [Armazenada no 1Password]

### POP3 (Recebimento Alternativo)
- **Servidor:** pop.hostinger.com
- **Porta:** 995
- **Segurança:** SSL/TLS
- **Autenticação:** Sim (usuário completo + senha)
- **Usuário:** sena@mfotrust.com
- **Senha:** [Armazenada no 1Password]

---

## 🔍 Registros DNS

### MX Records
```
5  mx1.hostinger.com
10 mx2.hostinger.com
```

### SPF Record
```
"v=spf1 include:_spf.mail.hostinger.com ~all"
```

### DKIM Records
```
hostingermail-a._domainkey.mfotrust.com
hostingermail-b._domainkey.mfotrust.com
hostingermail-c._domainkey.mfotrust.com
```

### DMARC Record
```
"v=DMARC1; p=none"
```

---

## 🧪 Scripts de Teste

### 1. Teste Completo
```bash
./vaults-1password/scripts/test-email-hostinger-completo.sh
```

### 2. Teste SMTP (Envio)
```bash
./vaults-1password/scripts/test-smtp-hostinger.sh
# Ou com parâmetros:
./vaults-1password/scripts/test-smtp-hostinger.sh --user sena@mfotrust.com --pass SUA_SENHA --to destinatario@exemplo.com
```

### 3. Teste IMAP (Recebimento)
```bash
./vaults-1password/scripts/test-imap-hostinger.sh
# Ou com parâmetros:
./vaults-1password/scripts/test-imap-hostinger.sh --user sena@mfotrust.com --pass SUA_SENHA
```

### 4. Teste POP3 (Recebimento Alternativo)
```bash
./vaults-1password/scripts/test-pop3-hostinger.sh
# Ou com parâmetros:
./vaults-1password/scripts/test-pop3-hostinger.sh --user sena@mfotrust.com --pass SUA_SENHA
```

### 5. Verificar DNS
```bash
./vaults-1password/scripts/verificar-dns-email.sh
# Ou para outro domínio:
./vaults-1password/scripts/verificar-dns-email.sh --domain senamfo.com.br
```

---

## 📋 Comandos Manuais

### Testar SMTP via openssl
```bash
openssl s_client -crlf -connect smtp.hostinger.com:465
```
Depois de conectar, digite:
```
EHLO mfotrust.com
AUTH LOGIN
[base64 do email]
[base64 da senha]
MAIL FROM:<sena@mfotrust.com>
RCPT TO:<destinatario@exemplo.com>
DATA
Subject: Teste
Corpo do email
.
QUIT
```

### Testar IMAP via openssl
```bash
openssl s_client -crlf -connect imap.hostinger.com:993
```
Depois de conectar, digite:
```
a LOGIN sena@mfotrust.com SUA_SENHA
a LIST "" "*"
a SELECT INBOX
a FETCH 1:* (FLAGS)
a LOGOUT
```

### Testar POP3 via openssl
```bash
openssl s_client -crlf -connect pop.hostinger.com:995
```
Depois de conectar, digite:
```
USER sena@mfotrust.com
PASS SUA_SENHA
LIST
STAT
RETR 1
QUIT
```

---

## 🔐 Gerar Base64 para AUTH LOGIN

```bash
# Email
echo -n "sena@mfotrust.com" | base64

# Senha
echo -n "SUA_SENHA" | base64
```

---

## 📱 Configuração em Clientes de Email

### Thunderbird
1. **Conta de Email** → **Adicionar Conta**
2. **Email:** sena@mfotrust.com
3. **Senha:** [senha]
4. **Configuração Manual:**
   - **IMAP:** imap.hostinger.com:993 (SSL/TLS)
   - **SMTP:** smtp.hostinger.com:465 (SSL/TLS)

### Outlook
1. **Arquivo** → **Adicionar Conta**
2. **Configuração Manual**
3. **IMAP:**
   - Servidor: imap.hostinger.com
   - Porta: 993
   - SSL: Sim
4. **SMTP:**
   - Servidor: smtp.hostinger.com
   - Porta: 465
   - SSL: Sim

### Apple Mail
1. **Mail** → **Adicionar Conta**
2. **Outro Mail Account**
3. Preencher:
   - Email: sena@mfotrust.com
   - Senha: [senha]
4. **Configuração Manual:**
   - **IMAP:** imap.hostinger.com:993
   - **SMTP:** smtp.hostinger.com:465

---

## 🔧 Configuração para Aplicações

### Chatwoot (.env)
```env
SMTP_ADDRESS=smtp.hostinger.com
SMTP_PORT=465
SMTP_DOMAIN=mfotrust.com
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=false
SMTP_OPENSSL_VERIFY_MODE=none
SMTP_USERNAME=sena@mfotrust.com
SMTP_PASSWORD=[senha do 1Password]
MAILER_SENDER_EMAIL=sena@mfotrust.com
```

### n8n
```json
{
  "host": "smtp.hostinger.com",
  "port": 465,
  "secure": true,
  "auth": {
    "user": "sena@mfotrust.com",
    "pass": "[senha]"
  }
}
```

---

## ✅ Checklist de Validação

- [ ] MX records configurados corretamente
- [ ] SPF record configurado
- [ ] DKIM records configurados
- [ ] DMARC record configurado
- [ ] SMTP testado e funcionando
- [ ] IMAP testado e funcionando
- [ ] POP3 testado (opcional)
- [ ] Cliente de email configurado
- [ ] Aplicações configuradas (Chatwoot, n8n, etc.)

---

## 🔗 Referências

- [Painel Hostinger Email](https://hpanel.hostinger.com/)
- [Documentação Hostinger Email](https://support.hostinger.com/)

---

**Última atualização:** 2025-11-17

