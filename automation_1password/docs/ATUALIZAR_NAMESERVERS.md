# Guia: Atualizar Nameservers para Hostinger

**Domínio:** senamfo.com.br
**Data:** 2025-11-17

---

## ⚠️ Situação Atual

### Nameservers Atuais
```
ns1.dns-parking.com
ns2.dns-parking.com
```

**Status:** ❌ Não são nameservers da Hostinger

### Nameservers da Hostinger
```
ns1.dns.hostinger.com
ns2.dns.hostinger.com
```

---

## 📋 Passo a Passo

### Opção 1: Via Painel Hostinger (Se domínio estiver na Hostinger)

1. **Acessar Painel Hostinger**
   - URL: https://hpanel.hostinger.com/
   - Fazer login

2. **Navegar para o Domínio**
   - Menu: Domínios
   - Selecionar: senamfo.com.br
   - Aba: Nameservers / DNS

3. **Atualizar Nameservers**
   - Alterar para:
     - ns1.dns.hostinger.com
     - ns2.dns.hostinger.com
   - Salvar alterações

### Opção 2: Via Registro.br (Se domínio não estiver na Hostinger)

1. **Acessar Registro.br**
   - URL: https://registro.br/
   - Fazer login com CPF e senha

2. **Acessar Gerenciamento do Domínio**
   - Menu: Meus Domínios
   - Selecionar: senamfo.com.br
   - Opção: Alterar DNS

3. **Atualizar Nameservers**
   - Remover: ns1.dns-parking.com
   - Remover: ns2.dns-parking.com
   - Adicionar: ns1.dns.hostinger.com
   - Adicionar: ns2.dns.hostinger.com
   - Salvar alterações

---

## ✅ Verificação

### Após Atualização

```bash
# Verificar nameservers públicos
dig NS senamfo.com.br +short

# Resultado esperado:
# ns1.dns.hostinger.com.
# ns2.dns.hostinger.com.
```

### Verificar Propagação

```bash
# Verificar em diferentes servidores DNS
dig NS senamfo.com.br @8.8.8.8 +short      # Google DNS
dig NS senamfo.com.br @1.1.1.1 +short      # Cloudflare DNS
dig NS senamfo.com.br @208.67.222.222 +short # OpenDNS
```

### Verificar Registros DNS

```bash
# Verificar registro A principal
dig A senamfo.com.br +short
# Esperado: 147.79.81.59

# Verificar subdomínios
dig A n8n.senamfo.com.br +short
dig A chatwoot.senamfo.com.br +short
dig A coolify.senamfo.com.br +short
```

---

## ⏱️ Tempo de Propagação

- **Mínimo:** 15 minutos
- **Médio:** 2-4 horas
- **Máximo:** 48 horas

**Fatores que afetam:**
- TTL dos registros NS
- Cache DNS de ISPs
- Localização geográfica

---

## 🔍 Troubleshooting

### Problema: Nameservers não atualizam

**Solução:**
1. Verificar se alteração foi salva no painel
2. Aguardar mais tempo (até 48h)
3. Limpar cache DNS local: `sudo dscacheutil -flushcache` (macOS)
4. Verificar em diferentes servidores DNS

### Problema: Domínio não resolve

**Solução:**
1. Verificar se nameservers foram atualizados corretamente
2. Verificar registros DNS na Hostinger
3. Aguardar propagação completa
4. Verificar se IP da VPS está correto (147.79.81.59)

### Problema: Subdomínios não funcionam

**Solução:**
1. Verificar registros A na Hostinger
2. Garantir que todos apontam para 147.79.81.59
3. Verificar TTL dos registros
4. Aguardar propagação

---

## 📝 Checklist

- [ ] Nameservers atualizados para Hostinger
- [ ] Alterações salvas no painel
- [ ] Verificação inicial (dig NS)
- [ ] Aguardar propagação (verificar periodicamente)
- [ ] Testar resolução de domínio
- [ ] Testar subdomínios (n8n, chatwoot, coolify)
- [ ] Verificar SSL/TLS após propagação
- [ ] Documentar alterações

---

## 🔗 Referências

- [Painel Hostinger](https://hpanel.hostinger.com/)
- [Registro.br](https://registro.br/)
- [Documentação DNS Hostinger](https://support.hostinger.com/)

---

**Última atualização:** 2025-11-17

