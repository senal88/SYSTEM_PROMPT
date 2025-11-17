# Gerenciamento de Backups e Snapshots - VPS Hostinger

**Data:** 2025-11-17
**VPS:** senamfo.com.br (147.79.81.59)

---

## 📊 Status Atual

### Backups Automáticos
- **Frequência:** Semanalmente
- **Total:** 2 backups
- **Último backup:** 2025-11-17 00:25
- **Tamanho médio:** ~20 GB

### Snapshots Manuais
- **Total:** 1 snapshot
- **Criado em:** 2025-11-13 22:28
- **Expira em:** 2025-12-03
- **Tempo de restauração:** ~30 minutos

---

## 💾 Detalhes dos Backups

### Backup 1
- **Data:** 2025-11-17 00:25
- **Localização:** Estados Unidos
- **Tamanho:** 14.33 GB
- **Sistema:** Ubuntu 24.04 with Coolify
- **Tempo de restauração:** 30 minutos

### Backup 2
- **Data:** 2025-11-10 00:51
- **Localização:** Estados Unidos
- **Tamanho:** 26.79 GB
- **Sistema:** Ubuntu 24.04 with Portainer
- **Tempo de restauração:** 30 minutos

**Observação:** O backup mais recente é menor (14.33 GB vs 26.79 GB), possivelmente devido a limpeza ou otimização.

---

## 📸 Snapshots

### Snapshot Atual
- **Data de criação:** 2025-11-13 22:28
- **Data de expiração:** 2025-12-03 (20 dias)
- **Tempo de restauração:** 30 minutos
- **Status:** ✅ Ativo

---

## 🔄 Tipos de Backup

### Backups Automáticos
- **Frequência:** Semanal (configurável)
- **Retenção:** Substituição automática de backups antigos
- **Armazenamento:** Separado do servidor principal
- **Custo:** Incluído no plano (backups diários: R$69.99/mês)

### Snapshots Manuais
- **Criação:** Manual pelo usuário
- **Retenção:** 20 dias (padrão)
- **Uso:** Antes de mudanças importantes
- **Custo:** Incluído no plano

---

## 📋 Quando Criar Backup/Snapshot

### Criar Snapshot Antes de:
- ✅ Atualizações do sistema
- ✅ Instalação de novos serviços
- ✅ Mudanças em configurações críticas
- ✅ Atualizações de aplicações (Coolify, n8n, Chatwoot)
- ✅ Mudanças em DNS/Nameservers
- ✅ Alterações em firewall
- ✅ Modificações em Docker/containers

### Backups Automáticos Cobertos:
- ✅ Backup semanal automático
- ✅ Proteção contra falhas de hardware
- ✅ Recuperação de dados

---

## 🔧 Gerenciar Backups

### Criar Novo Snapshot

1. **No painel Hostinger:**
   - VPS → senamfo.com.br → Snapshots e Backups
   - Clicar em "Novo snapshot"
   - Confirmar criação

2. **Tempo estimado:** 5-15 minutos (dependendo do tamanho)

### Restaurar Backup/Snapshot

1. **No painel Hostinger:**
   - VPS → senamfo.com.br → Snapshots e Backups
   - Encontrar backup/snapshot desejado
   - Clicar em "Restaurar"
   - Confirmar restauração

2. **Tempo estimado:** ~30 minutos

3. **⚠️ Atenção:**
   - A restauração substitui **TODOS** os dados atuais
   - A VPS será reiniciada
   - Pode haver downtime durante a restauração

### Gerenciar Cronograma de Backups

1. **No painel Hostinger:**
   - VPS → senamfo.com.br → Snapshots e Backups
   - Clicar em "Gerenciar cronograma"
   - Escolher frequência:
     - Diário (requer upgrade - R$69.99/mês)
     - Semanal (incluído)
     - Mensal (incluído)

---

## 💡 Recomendações

### Estratégia de Backup

1. **Backups Automáticos Semanais:**
   - ✅ Já configurado
   - ✅ Proteção básica garantida

2. **Snapshots Manuais:**
   - ✅ Criar antes de mudanças importantes
   - ✅ Manter pelo menos 1 snapshot ativo
   - ✅ Criar novo snapshot a cada 2 semanas

3. **Backups Adicionais:**
   - Considerar upgrade para backups diários se:
     - Dados críticos mudam frequentemente
     - Múltiplas alterações por dia
     - Necessidade de RPO (Recovery Point Objective) menor

### Checklist de Backup

Antes de fazer mudanças importantes:
- [ ] Verificar último backup automático
- [ ] Criar snapshot manual
- [ ] Documentar mudanças a serem feitas
- [ ] Ter plano de rollback

---

## 📊 Comparação: Backup vs Snapshot

| Característica | Backup Automático | Snapshot Manual |
|----------------|-------------------|-----------------|
| Frequência | Semanal (ou diário com upgrade) | Sob demanda |
| Retenção | Substituição automática | 20 dias |
| Custo | Incluído (diário: R$69.99/mês) | Incluído |
| Tempo de criação | Automático | 5-15 minutos |
| Tempo de restauração | ~30 minutos | ~30 minutos |
| Uso ideal | Proteção regular | Antes de mudanças |

---

## 🔍 Verificar Status dos Backups

### Via Painel Hostinger
- VPS → senamfo.com.br → Snapshots e Backups
- Verificar data do último backup
- Verificar tamanho dos backups
- Verificar snapshots ativos

### Via Script (se disponível)
```bash
# Verificar último backup (exemplo)
./vaults-1password/scripts/verificar-backups-vps.sh
```

---

## ⚠️ Importante

### Antes de Restaurar
1. ✅ Fazer backup dos dados atuais (se possível)
2. ✅ Documentar estado atual
3. ✅ Verificar se há dados não salvos
4. ✅ Notificar usuários sobre possível downtime

### Após Restaurar
1. ✅ Verificar se serviços estão rodando
2. ✅ Testar aplicações principais
3. ✅ Verificar conectividade
4. ✅ Validar configurações

---

## 🔗 Referências

- [Painel Hostinger - Backups](https://hpanel.hostinger.com/)
- [Documentação Backups Hostinger](https://support.hostinger.com/)
- [Guia de Restauração](./REBOOT_COMPLETO_VPS.md)

---

**Última atualização:** 2025-11-17

