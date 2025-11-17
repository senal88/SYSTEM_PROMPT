# Verificação de Nameservers - Hostinger

**Data:** 2025-11-17
**Objetivo:** Verificar nameservers da Hostinger e remover referências ao Cloudflare

---

## 📊 Status Atual

### Domínio: mfotrust.com

**Nameservers Atuais:**
- ns1: `ns1.dns-parking.com`
- ns2: `ns2.dns-parking.com`

**Status:** ⚠️ **PROBLEMA DETECTADO**
- Nameservers estão apontando para DNS Parking (não Hostinger)
- Não estão usando nameservers da Hostinger

### Nameservers Recomendados da Hostinger

Os nameservers padrão da Hostinger são:
- `ns1.dns.hostinger.com`
- `ns2.dns.hostinger.com`
- `ns3.dns.hostinger.com` (opcional)
- `ns4.dns.hostinger.com` (opcional)

---

## 🔍 Referências ao Cloudflare Encontradas

### No 1Password (VPS - 1p_vps)

**Itens a Remover/Migrar:**

1. **CF_API_TOKEN** (API_CREDENTIAL)
   - ID: 2mb36tmsoxrkr5tf2r5igz7kc4
   - Ação: **REMOVER** (não usar mais Cloudflare)

2. **CF_ACCOUNT_ID** (SECURE_NOTE) - 2 itens duplicados
   - IDs: 2etmmhp4irxvvps6jnlugvykxu, 7d7rplikeuw2iojs3xe7mlwb3y
   - Ação: **REMOVER**

3. **CF_DNS_DOMAIN** (SECURE_NOTE)
   - ID: d5q57udmmgdzu4otwlnrnx7vq4
   - Ação: **REMOVER**

4. **CF_ZONE_ID** (SECURE_NOTE) - 2 itens duplicados
   - IDs: joxq2rlirs4ccvfnoeunxo2bzu, xghspbt7hybx7wnt6rkrh7zo54
   - Ação: **REMOVER**

5. **CF_EMAIL** (SECURE_NOTE) - 2 itens duplicados
   - IDs: dajg2tj54yu5767dv3ico4drwe, hp4e23cfgi7q5nqw5tnikfxcdu
   - Ação: **REMOVER**

6. **CF_PROXIED** (SECURE_NOTE) - 2 itens duplicados
   - IDs: bmlpltulj46hjorcf3yhfsmwzy, qohyxgitahp4yo6bmfqqxhsi7q
   - Ação: **REMOVER**

7. **env-cloudflare** (SECURE_NOTE)
   - ID: stwwihnlzvockcrnsdaatzphym
   - Ação: **REMOVER**

8. **Cloudflare** (PASSWORD)
   - ID: rgk2ieu23mni2mtn4ahd2yucbq
   - Ação: **REMOVER**

9. **Cloudflare - senamfo.com.br** (SERVER)
   - ID: qvhuk7f3b65x4wcdapnnd4p274
   - Ação: **REMOVER**

### No 1Password (macOS - 1p_macos)

1. **Cloudflare** (PASSWORD)
   - ID: nspfvp6kpcsoidrr3j3h7r2pbq
   - Ação: **REMOVER**

---

## ✅ Ações Necessárias

### 1. Atualizar Nameservers para Hostinger

**Comando via API:**
```bash
# Atualizar nameservers do domínio mfotrust.com
# Usar API Hostinger para atualizar
```

**Nameservers a configurar:**
- ns1.dns.hostinger.com
- ns2.dns.hostinger.com

### 2. Remover Itens do Cloudflare do 1Password

**Total de itens a remover:** 13 itens

**Script de remoção:**
- Criar script para remover todos os itens relacionados ao Cloudflare
- Verificar se há dependências antes de remover
- Fazer backup antes de remover

### 3. Verificar DNS Records

Após atualizar nameservers:
- Verificar se registros DNS estão corretos
- Garantir que todos apontam para Hostinger
- Remover qualquer registro relacionado ao Cloudflare

---

## 📋 Checklist

- [ ] Verificar nameservers atuais do domínio
- [ ] Atualizar nameservers para Hostinger
- [ ] Remover itens Cloudflare do 1Password (VPS)
- [ ] Remover itens Cloudflare do 1Password (macOS)
- [ ] Verificar registros DNS após atualização
- [ ] Testar resolução DNS
- [ ] Documentar mudanças

---

## 🔗 Referências

- [API Hostinger - Update Nameservers](https://developers.hostinger.com/)
- [Documentação DNS Hostinger](https://support.hostinger.com/)

---

**Última atualização:** 2025-11-17

