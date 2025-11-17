# Índice Completo - Sistema de Padronização 1Password

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 📚 Documentação por Categoria

### 🎯 Padrões e Regras

1. **[Nomenclatura](./standards/nomenclature.md)**
   - Padrão SERVICE_TYPE_ENV
   - Nomes de serviços padronizados
   - Exemplos corretos e incorretos
   - Casos especiais (Google/Gemini, Hugging Face, etc.)

2. **[Categorias](./standards/categories.md)**
   - Mapeamento completo de categorias 1Password
   - Quando usar cada categoria
   - Exemplos práticos
   - Checklist de categoria

3. **[Tags](./standards/tags.md)**
   - Sistema hierárquico de tags
   - Namespaces (environment, service, type, status)
   - Exemplos completos
   - Busca com tags

4. **[Regras de Validação](./standards/validation-rules.yaml)**
   - Regras YAML completas
   - Validação por tipo de credencial
   - Regex patterns
   - Auto-fixes

---

### 📖 Guias de Uso

5. **[Guia de Migração](./docs/MIGRATION_GUIDE.md)**
   - Processo completo de migração
   - Fases: Análise, Backup, Migração, Validação, Limpeza
   - Exemplos práticos
   - Troubleshooting

6. **[Registrar Hospedagem](./docs/REGISTRAR_HOSPEDAGEM_1PASSWORD.md)**
   - 4 itens para hospedagem web
   - FTP, plano, servidor, detalhes
   - Scripts automatizados

7. **[Registrar Configurações Avançadas](./docs/REGISTRAR_CONFIGURACOES_AVANCADAS_1PASSWORD.md)**
   - 7 itens para configurações avançadas
   - SSH, MySQL, phpMyAdmin, Git, IP Manager, Redirects
   - Scripts automatizados

8. **[Resumo de Itens](./docs/RESUMO_ITENS_1PASSWORD_MFOTRUST.md)**
   - Lista consolidada de 11 itens
   - Estrutura hierárquica
   - Checklist completo

---

### 🏗️ Infraestrutura Hostinger

9. **[Resumo de Serviços](./docs/RESUMO_SERVICOS_HOSTINGER.md)**
   - Visão geral de todos os serviços
   - Hospedagem Web, Domínio, Email, VPS
   - Cronograma de renovação
   - Checklist de manutenção

10. **[Gerenciar Backups](./docs/GERENCIAR_BACKUPS_SNAPSHOTS.md)**
    - Backups automáticos e snapshots
    - Estratégias de backup
    - Quando criar snapshots
    - Restauração

11. **[Gerenciar Chaves SSH](./docs/GERENCIAR_CHAVES_SSH.md)**
    - Chaves SSH cadastradas
    - Gerar novas chaves
    - Boas práticas
    - Configuração SSH client

12. **[Configuração de Email](./docs/CONFIGURACAO_EMAIL_HOSTINGER.md)**
    - SMTP, IMAP, POP3
    - Configurações completas
    - Scripts de teste
    - Configuração em clientes

13. **[Configurar Child Nameservers](./docs/CONFIGURAR_CHILD_NAMESERVERS.md)**
    - Criar child nameservers
    - Configurar BIND9 na VPS
    - Atualizar no Registro.br
    - Verificação

14. **[Monitorar Recursos](./docs/MONITORAR_RECURSOS_HOSPEDAGEM.md)**
    - Uso de disco, inodes, recursos
    - Alertas e limites
    - Otimizações
    - Quando considerar upgrade

15. **[Histórico DNS](./docs/HISTORICO_DNS_MFOTRUST.md)**
    - Histórico de alterações DNS
    - Funcionalidade de restauração
    - Estado atual dos registros

16. **[Atualizar Nameservers](./docs/ATUALIZAR_NAMESERVERS.md)**
    - Atualizar para Hostinger
    - Via painel ou Registro.br
    - Verificação e propagação

---

## 🔧 Scripts Disponíveis

### Análise e Validação
- `analyze-1password-export.sh` - Analisa exports CSV
- `validate-1password-items.sh` - Valida itens

### Migração
- `migrate-1password-items.sh` - Migra itens

### Criação de Itens
- `criar-itens-hospedagem-1password.sh` - Hospedagem (4 itens)
- `criar-itens-configuracoes-avancadas-1password.sh` - Avançadas (7 itens)

### Testes
- `test-email-hostinger-completo.sh` - Teste completo de email
- `test-smtp-hostinger.sh` - Teste SMTP
- `test-imap-hostinger.sh` - Teste IMAP
- `test-pop3-hostinger.sh` - Teste POP3

### Verificação
- `verificar-dns-email.sh` - DNS de email
- `verificar-nameservers-hostinger.sh` - Nameservers
- `verificar-backups-vps.sh` - Backups
- `monitorar-recursos-hospedagem.sh` - Recursos

### Configuração
- `configurar-child-nameservers.sh` - BIND9 na VPS
- `atualizar-nameservers-hostinger.sh` - Atualizar nameservers
- `exportar-dns-atual.sh` - Exportar DNS

---

## 📋 Templates

1. **[Templates de Itens](./templates/item-templates.yaml)**
   - Templates por categoria
   - Campos obrigatórios e opcionais
   - Exemplos

2. **[Template Hospedagem](./templates/hospedagem-mfotrust-template.yaml)**
   - 4 itens de hospedagem
   - Estrutura completa

3. **[Template Configurações Avançadas](./templates/configuracoes-avancadas-mfotrust-template.yaml)**
   - 7 itens avançados
   - Relacionamentos

4. **[Templates .env](./templates/env-templates/)**
   - `.env.macos.example`
   - `.env.vps.example`

---

## 🎯 Fluxo de Trabalho Recomendado

### 1. Análise Inicial
```bash
# Analisar exports existentes
./vaults-1password/scripts/analyze-1password-export.sh \
    vaults-1password/exports/archive/1p_macos_20251116_201632.csv \
    --vault-name "1p_macos"
```

### 2. Validação
```bash
# Validar itens
./vaults-1password/scripts/validate-1password-items.sh --vault "1p_macos"
```

### 3. Migração
```bash
# Testar migração
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_macos" \
    --dry-run \
    --remove-cloudflare

# Aplicar migração
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_macos" \
    --remove-cloudflare
```

### 4. Criar Novos Itens
```bash
# Hospedagem
./vaults-1password/scripts/criar-itens-hospedagem-1password.sh

# Configurações avançadas
./vaults-1password/scripts/criar-itens-configuracoes-avancadas-1password.sh
```

---

## 📊 Estatísticas

- **Documentos:** 16+
- **Scripts:** 20+
- **Templates:** 4
- **Itens para criar:** 11
- **Padrões definidos:** 4

---

## 🔗 Links Rápidos

### Documentação Principal
- [README Principal](./README.md)
- [Guia de Migração](./docs/MIGRATION_GUIDE.md)
- [Resumo de Itens](./docs/RESUMO_ITENS_1PASSWORD_MFOTRUST.md)

### Padrões
- [Nomenclatura](./standards/nomenclature.md)
- [Categorias](./standards/categories.md)
- [Tags](./standards/tags.md)

### Infraestrutura
- [Resumo de Serviços](./docs/RESUMO_SERVICOS_HOSTINGER.md)
- [Configuração de Email](./docs/CONFIGURACAO_EMAIL_HOSTINGER.md)

---

**Última atualização:** 2025-11-17

