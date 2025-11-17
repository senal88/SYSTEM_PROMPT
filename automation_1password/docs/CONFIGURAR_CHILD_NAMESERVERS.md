# Configurar Child Nameservers - mfotrust.com

**Data:** 2025-11-17
**Domínio:** mfotrust.com
**VPS IP:** 147.79.81.59

---

## 📋 O que são Child Nameservers?

Child nameservers são nameservers personalizados que você cria para seu próprio domínio. Ao invés de usar `ns1.dns.hostinger.com`, você pode criar:
- `ns1.mfotrust.com`
- `ns2.mfotrust.com`

Esses nameservers apontam para o IP da sua VPS, permitindo que você gerencie DNS diretamente no servidor.

---

## ✅ Configuração no Painel Hostinger

### Passo 1: Criar Child Nameservers

1. **Acessar:** https://hpanel.hostinger.com/
2. **Navegar:** Meus domínios → mfotrust.com → DNS / Nameservers
3. **Clicar:** "Criar nameservers child"

### Passo 2: Preencher Formulário

**Nameserver Child 1:**
- **Nome:** `ns1`
- **Domínio:** `.mfotrust.com` (já preenchido)
- **Endereço IPv4:** `147.79.81.59`

**Nameserver Child 2:**
- **Nome:** `ns2`
- **Domínio:** `.mfotrust.com` (já preenchido)
- **Endereço IPv4:** `147.79.81.59`

### Passo 3: Salvar

Após criar, os nameservers child estarão disponíveis como:
- `ns1.mfotrust.com` → 147.79.81.59
- `ns2.mfotrust.com` → 147.79.81.59

---

## 🔧 Configuração na VPS

### Passo 1: Instalar BIND9 (DNS Server)

```bash
# Conectar na VPS
ssh root@147.79.81.59

# Atualizar sistema
apt update && apt upgrade -y

# Instalar BIND9
apt install -y bind9 bind9utils bind9-doc dnsutils
```

### Passo 2: Configurar BIND9

#### Editar /etc/bind/named.conf.options

```bash
nano /etc/bind/named.conf.options
```

Adicionar:
```conf
options {
    directory "/var/cache/bind";

    // Forwarders (Google DNS)
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Permitir queries
    allow-query { any; };
    recursion yes;

    // DNSSEC
    dnssec-validation auto;

    listen-on-v6 { any; };
};
```

#### Criar Zone para mfotrust.com

```bash
nano /etc/bind/named.conf.local
```

Adicionar:
```conf
zone "mfotrust.com" {
    type master;
    file "/etc/bind/db.mfotrust.com";
};

// Reverse DNS (opcional)
zone "79.147.in-addr.arpa" {
    type master;
    file "/etc/bind/db.147.79";
};
```

#### Criar Arquivo de Zone

```bash
nano /etc/bind/db.mfotrust.com
```

Conteúdo:
```
$TTL    14400
@       IN      SOA     ns1.mfotrust.com. admin.mfotrust.com. (
                        2025111701  ; Serial
                        14400       ; Refresh
                        3600        ; Retry
                        604800      ; Expire
                        86400       ; Minimum TTL
                        )

; Nameservers
@       IN      NS      ns1.mfotrust.com.
@       IN      NS      ns2.mfotrust.com.

; A Records
@       IN      A       147.79.81.59
ns1     IN      A       147.79.81.59
ns2     IN      A       147.79.81.59
www     IN      A       147.79.81.59

; CNAME Records
ftp     IN      CNAME   www.mfotrust.com.

; MX Records
@       IN      MX      5   mx1.hostinger.com.
@       IN      MX      10  mx2.hostinger.com.

; TXT Records
@       IN      TXT     "v=spf1 include:_spf.mail.hostinger.com ~all"

; DKIM Records
hostingermail-a._domainkey    IN      CNAME   hostingermail-a.dkim.mail.hostinger.com.
hostingermail-b._domainkey    IN      CNAME   hostingermail-b.dkim.mail.hostinger.com.
hostingermail-c._domainkey    IN      CNAME   hostingermail-c.dkim.mail.hostinger.com.

; DMARC
_dmarc  IN      TXT     "v=DMARC1; p=none"
```

### Passo 3: Validar e Reiniciar

```bash
# Validar configuração
named-checkconf
named-checkzone mfotrust.com /etc/bind/db.mfotrust.com

# Reiniciar BIND9
systemctl restart bind9
systemctl enable bind9

# Verificar status
systemctl status bind9
```

### Passo 4: Configurar Firewall

```bash
# Permitir DNS (porta 53)
ufw allow 53/tcp
ufw allow 53/udp

# Verificar
ufw status
```

---

## 🔄 Atualizar Nameservers no Registro.br

### Passo 1: Acessar Registro.br

1. **Acessar:** https://registro.br/
2. **Login** com CPF e senha
3. **Navegar:** Meus Domínios → mfotrust.com → Alterar DNS

### Passo 2: Atualizar Nameservers

**Remover:**
- ns1.dns-parking.com
- ns2.dns-parking.com

**Adicionar:**
- ns1.mfotrust.com
- ns2.mfotrust.com

### Passo 3: Salvar

A propagação pode levar até 48 horas.

---

## ✅ Verificação

### Verificar Child Nameservers

```bash
# Verificar se ns1.mfotrust.com resolve para o IP correto
dig ns1.mfotrust.com +short
# Esperado: 147.79.81.59

dig ns2.mfotrust.com +short
# Esperado: 147.79.81.59
```

### Verificar Nameservers do Domínio

```bash
# Verificar nameservers
dig mfotrust.com NS +short
# Esperado: ns1.mfotrust.com e ns2.mfotrust.com
```

### Testar Resolução DNS

```bash
# Testar resolução
dig mfotrust.com +short
# Esperado: 147.79.81.59

dig www.mfotrust.com +short
# Esperado: 147.79.81.59
```

### Verificar DNS na VPS

```bash
# Testar DNS local
dig @127.0.0.1 mfotrust.com +short
dig @147.79.81.59 mfotrust.com +short
```

---

## 📋 Checklist

- [ ] Child nameservers criados no painel Hostinger
- [ ] BIND9 instalado na VPS
- [ ] Zone mfotrust.com configurada
- [ ] Registros DNS criados (A, MX, TXT, CNAME)
- [ ] BIND9 reiniciado e funcionando
- [ ] Firewall configurado (porta 53)
- [ ] Nameservers atualizados no Registro.br
- [ ] Verificação de resolução DNS
- [ ] Propagação DNS completa (pode levar até 48h)

---

## 🔍 Troubleshooting

### Problema: Nameservers não resolvem

**Solução:**
```bash
# Verificar se BIND9 está rodando
systemctl status bind9

# Verificar logs
tail -f /var/log/syslog | grep named

# Testar configuração
named-checkconf
named-checkzone mfotrust.com /etc/bind/db.mfotrust.com
```

### Problema: DNS não propaga

**Solução:**
1. Aguardar até 48 horas
2. Verificar em diferentes servidores DNS:
   ```bash
   dig @8.8.8.8 mfotrust.com NS +short
   dig @1.1.1.1 mfotrust.com NS +short
   ```

### Problema: Firewall bloqueando

**Solução:**
```bash
# Verificar regras
ufw status numbered

# Permitir DNS
ufw allow 53/tcp
ufw allow 53/udp
```

---

## 🔗 Referências

- [Documentação BIND9](https://www.isc.org/bind/)
- [Guia Child Nameservers Hostinger](https://support.hostinger.com/)
- [Registro.br - Alterar DNS](https://registro.br/)

---

**Última atualização:** 2025-11-17

