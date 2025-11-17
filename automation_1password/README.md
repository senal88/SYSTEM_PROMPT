# 🔐 1Password Automation - Governança Centralizada

**Localização**: `~/Dotfiles/automation_1password`  
**Versão**: 2.0.1  
**Última Atualização**: 2025-01-17

---

## 📋 Visão Geral

Este diretório centraliza toda a automação e governança relacionada ao 1Password, incluindo:

- ✅ Scripts de sincronização e backup
- ✅ Templates e standards
- ✅ Documentação de governança
- ✅ Exports e reports
- ✅ Configurações padronizadas

---

## 📁 Estrutura

```
~/Dotfiles/automation_1password/
├── config/          # Configurações
├── scripts/         # Scripts de automação
├── docs/            # Documentação
├── exports/         # Exports do 1Password
├── reports/         # Relatórios e análises
├── standards/       # Padrões e templates
├── templates/      # Templates de itens
└── vaults/          # Configurações por vault
```

---

## 🚀 Scripts Principais

### Sincronização

- `scripts/sync-1password-to-dotfiles.sh` - Sincroniza credenciais do 1Password para ~/Dotfiles
- `scripts/backup-vaults.sh` - Backup de vaults
- `scripts/audit-credentials.sh` - Auditoria de credenciais

### Governança

- `scripts/standardize-items.sh` - Padroniza itens no 1Password
- `scripts/remove-duplicates.sh` - Remove duplicatas
- `scripts/validate-standards.sh` - Valida conformidade com standards

---

## 📚 Documentação

- [Governança de Dados](../docs/governance/GOVERNANCA_DADOS.md)
- [Padrões de Credenciais](standards/)
- [Templates de Itens](templates/)

---

## 🔄 Migração

Este diretório foi migrado de:
- `~/10_INFRAESTRUTURA_VPS/vaults-1password`

Todas as configurações foram consolidadas e padronizadas aqui.

---

**Mantido por**: Sistema de Governança Global  
**Versão**: 2.0.1
