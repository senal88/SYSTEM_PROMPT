# Histórico DNS - mfotrust.com

**Data:** 2025-11-17
**Domínio:** mfotrust.com

---

## 📋 Histórico de Alterações DNS

### 2025-11-15
- **Tipo:** Hostinger mail activated
- **Ação:** Ativação do serviço de email Hostinger
- **Status:** ✅ Ativo
- **Registros criados:**
  - MX records (mx1.hostinger.com, mx2.hostinger.com)
  - SPF record
  - DKIM records (hostingermail-a, hostingermail-b, hostingermail-c)
  - DMARC record

### 2025-11-14
- **Tipo:** Hosting CDN enabled
- **Ação:** Ativação do CDN da Hostinger
- **Status:** ✅ Ativo
- **Registros criados:**
  - ALIAS @ → mfotrust.com.cdn.hstgr.net
  - CNAME www → www.mfotrust.com.cdn.hstgr.net

### 2025-11-14 (Múltiplas)
- **Tipo:** Zone records update request
- **Ação:** Atualizações de registros DNS
- **Detalhes:** Várias atualizações de registros A, CNAME, TXT, etc.

### 2025-11-14
- **Tipo:** Zone records delete request
- **Ação:** Remoção de registros DNS
- **Detalhes:** Limpeza de registros antigos ou desnecessários

---

## 🔄 Funcionalidade de Restauração

O painel Hostinger permite restaurar snapshots do DNS para qualquer data do histórico.

### Como Restaurar

1. **Acessar:** Painel Hostinger → mfotrust.com → DNS / Nameservers → Histórico de DNS
2. **Selecionar:** Data desejada do histórico
3. **Clicar:** "Restaurar"
4. **Confirmar:** Restauração

### ⚠️ Atenção

- A restauração substitui **TODOS** os registros DNS atuais
- Pode levar alguns minutos para propagar
- Verifique se você tem backup dos registros atuais antes de restaurar

---

## 📊 Estado Atual dos Registros DNS

### Nameservers
- ns1.dns-parking.com
- ns2.dns-parking.com

**⚠️ Recomendação:** Atualizar para child nameservers (ns1.mfotrust.com, ns2.mfotrust.com)

### Registros A
- @ → (via ALIAS para CDN)
- ftp → 185.173.111.131

### Registros CNAME
- www → www.mfotrust.com.cdn.hstgr.net
- hostingermail-a._domainkey → hostingermail-a.dkim.mail.hostinger.com
- hostingermail-b._domainkey → hostingermail-b.dkim.mail.hostinger.com
- hostingermail-c._domainkey → hostingermail-c.dkim.mail.hostinger.com
- autodiscover → autodiscover.mail.hostinger.com
- autoconfig → autoconfig.mail.hostinger.com

### Registros MX
- @ → mx1.hostinger.com (prioridade 5)
- @ → mx2.hostinger.com (prioridade 10)

### Registros TXT
- @ → "v=spf1 include:_spf.mail.hostinger.com ~all"
- _dmarc → "v=DMARC1; p=none"

### Registros ALIAS
- @ → mfotrust.com.cdn.hstgr.net

### Registros CAA
- Múltiplos registros CAA para certificados SSL (Let's Encrypt, Google, etc.)

---

## 🔍 Verificação do Estado Atual

### Comandos para Verificar

```bash
# Verificar todos os registros
dig mfotrust.com ANY +noall +answer

# Verificar nameservers
dig mfotrust.com NS +short

# Verificar MX
dig mfotrust.com MX +short

# Verificar SPF
dig mfotrust.com TXT +short | grep spf

# Verificar DKIM
dig hostingermail-a._domainkey.mfotrust.com TXT +short

# Verificar DMARC
dig _dmarc.mfotrust.com TXT +short
```

---

## 📝 Recomendações

### 1. Atualizar Nameservers
- Criar child nameservers (ns1.mfotrust.com, ns2.mfotrust.com)
- Atualizar no Registro.br
- Configurar BIND9 na VPS

### 2. Backup Regular
- Exportar registros DNS regularmente
- Documentar mudanças importantes
- Manter histórico de alterações

### 3. Monitoramento
- Verificar propagação após mudanças
- Monitorar resolução DNS
- Validar registros de email (SPF, DKIM, DMARC)

---

## 🔗 Referências

- [Painel Hostinger DNS](https://hpanel.hostinger.com/)
- [Documentação DNS Hostinger](https://support.hostinger.com/)
- [Guia Child Nameservers](./CONFIGURAR_CHILD_NAMESERVERS.md)

---

**Última atualização:** 2025-11-17

