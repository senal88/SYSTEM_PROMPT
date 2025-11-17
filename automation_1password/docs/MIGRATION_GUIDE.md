# Guia de Migração - Padronização 1Password

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Pré-requisitos](#pré-requisitos)
- [Fase 1: Análise](#fase-1-análise)
- [Fase 2: Backup](#fase-2-backup)
- [Fase 3: Migração](#fase-3-migração)
- [Fase 4: Validação](#fase-4-validação)
- [Fase 5: Limpeza Cloudflare](#fase-5-limpeza-cloudflare)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

Este guia descreve o processo completo de migração dos itens do 1Password para os novos padrões de nomenclatura, categorias e tags.

**Objetivos:**
- Padronizar nomenclaturas (SERVICE_TYPE_ENV)
- Corrigir categorias incorretas
- Adicionar tags hierárquicas
- Remover referências ao Cloudflare
- Validar formatos de credenciais

**Tempo estimado:** 1-2 horas

---

## ✅ Pré-requisitos

### Ferramentas Necessárias

- [ ] 1Password CLI instalado (`op`)
- [ ] Autenticado no 1Password (`op signin`)
- [ ] Acesso aos vaults (1p_macos, 1p_vps)
- [ ] Backup completo do 1Password

### Verificações Iniciais

```bash
# Verificar instalação
op --version

# Verificar autenticação
op whoami

# Listar vaults
op vault list
```

---

## 📊 Fase 1: Análise

### 1.1 Executar Análise dos Exports

```bash
# Analisar vault macOS
./vaults-1password/scripts/analyze-1password-export.sh \
    vaults-1password/exports/archive/1p_macos_20251116_201632.csv \
    --vault-name "1p_macos"

# Analisar vault VPS
./vaults-1password/scripts/analyze-1password-export.sh \
    vaults-1password/exports/archive/1p_vps_20251116_201632.csv \
    --vault-name "1p_vps"
```

### 1.2 Revisar Relatórios

Os relatórios serão gerados em:
- `vaults-1password/reports/analysis-1p_macos-*.md`
- `vaults-1password/reports/analysis-1p_vps-*.md`

**Verificar:**
- Erros de digitação
- Nomenclaturas inconsistentes
- Categorias incorretas
- Duplicatas
- Itens sem sufixo de ambiente

---

## 💾 Fase 2: Backup

### 2.1 Exportar Itens Atuais

```bash
# Exportar vault completo (já feito)
cd vaults-1password
./scripts/export-1password-profissional.sh
```

### 2.2 Verificar Backup

```bash
# Verificar checksums
cat vaults-1password/exports/archive/checksums_*.txt

# Verificar arquivos
ls -lh vaults-1password/exports/archive/
```

---

## 🔄 Fase 3: Migração

### 3.1 Migração com Dry-Run (Teste)

```bash
# Testar migração sem fazer alterações
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_macos" \
    --dry-run

./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_vps" \
    --dry-run
```

### 3.2 Aplicar Migração

```bash
# Migrar vault macOS
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_macos"

# Migrar vault VPS
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_vps"
```

### 3.3 Correções Manuais Necessárias

Algumas correções podem precisar de intervenção manual:

#### Exemplo 1: Renomear ANTRHOPIC → ANTHROPIC

```bash
# Via 1Password CLI
op item edit "ANTRHOPIC_API_KEY" \
    --vault "1p_macos" \
    --title "ANTHROPIC_API_KEY"
```

#### Exemplo 2: Consolidar GOOGLE_API_KEY e GEMINI_API_KEY

```bash
# Verificar qual tem o valor correto
op item get "GOOGLE_API_KEY" --vault "1p_macos"
op item get "GEMINI_API_KEY" --vault "1p_macos"

# Se GEMINI_API_KEY tem o valor correto, atualizar GOOGLE_API_KEY
# Depois remover GEMINI_API_KEY
op item delete "GEMINI_API_KEY" --vault "1p_macos"
```

#### Exemplo 3: Corrigir Categoria

```bash
# Mudar categoria de LOGIN para API_CREDENTIAL
op item edit "OPENAI_API_KEY" \
    --vault "1p_macos" \
    --category "API_CREDENTIAL"
```

---

## ✅ Fase 4: Validação

### 4.1 Validar Itens

```bash
# Validar vault macOS
./vaults-1password/scripts/validate-1password-items.sh \
    --vault "1p_macos"

# Validar vault VPS
./vaults-1password/scripts/validate-1password-items.sh \
    --vault "1p_vps"
```

### 4.2 Verificar Formatos

O script de validação verifica:
- ✅ Nomenclaturas (UPPER_SNAKE_CASE)
- ✅ Categorias corretas
- ✅ Formatos de credenciais (regex)
- ✅ Tags obrigatórias

### 4.3 Testar Carregamento

```bash
# No macOS
source ~/.zshrc
echo $OPENAI_API_KEY
echo $GOOGLE_API_KEY

# Na VPS
source ~/.bashrc
echo $OPENAI_API_KEY
echo $GOOGLE_API_KEY
```

---

## 🗑️ Fase 5: Limpeza Cloudflare

### 5.1 Identificar Itens Cloudflare

```bash
# Listar itens Cloudflare
op item list --vault "1p_vps" | grep -i cloudflare
op item list --vault "1p_macos" | grep -i cloudflare
```

### 5.2 Remover Itens Cloudflare

```bash
# Remover com dry-run primeiro
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_vps" \
    --remove-cloudflare \
    --dry-run

# Remover de fato
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_vps" \
    --remove-cloudflare

# Repetir para macOS se necessário
./vaults-1password/scripts/migrate-1password-items.sh \
    --vault "1p_macos" \
    --remove-cloudflare \
    --dry-run
```

### 5.3 Itens a Remover (VPS)

Baseado na análise:
- CF_API_TOKEN
- CF_ACCOUNT_ID (2 duplicatas)
- CF_DNS_DOMAIN
- CF_ZONE_ID (2 duplicatas)
- CF_EMAIL (2 duplicatas)
- CF_PROXIED (2 duplicatas)
- env-cloudflare
- Cloudflare (PASSWORD)
- Cloudflare - senamfo.com.br (SERVER)

### 5.4 Itens a Remover (macOS)

- Cloudflare (PASSWORD)

---

## 📝 Exemplos Práticos

### Exemplo 1: Migrar OpenAI API Key

**Antes:**
- Nome: `OpenAI_API_Key_macos`
- Categoria: `LOGIN`
- Tags: nenhuma

**Depois:**
- Nome: `OPENAI_API_KEY_MACOS`
- Categoria: `API_CREDENTIAL`
- Tags: `environment:macos,service:openai,type:api_key,status:active`

**Comando:**
```bash
op item edit "OpenAI_API_Key_macos" \
    --vault "1p_macos" \
    --title "OPENAI_API_KEY_MACOS" \
    --category "API_CREDENTIAL"
```

### Exemplo 2: Consolidar Google/Gemini

**Situação:**
- `GOOGLE_API_KEY` (SECURE_NOTE)
- `GEMINI_API_KEY` (API_CREDENTIAL)

**Ação:**
1. Verificar qual tem o valor correto
2. Atualizar `GOOGLE_API_KEY` com valor correto
3. Mudar categoria para `API_CREDENTIAL`
4. Remover `GEMINI_API_KEY`

**Comando:**
```bash
# Obter valor do GEMINI_API_KEY
VALUE=$(op item get "GEMINI_API_KEY" --vault "1p_macos" --fields credential)

# Atualizar GOOGLE_API_KEY
op item edit "GOOGLE_API_KEY" \
    --vault "1p_macos" \
    --category "API_CREDENTIAL" \
    credential="$VALUE"

# Remover GEMINI_API_KEY
op item delete "GEMINI_API_KEY" --vault "1p_macos"
```

### Exemplo 3: Adicionar Tags

```bash
# Adicionar tags manualmente (se suportado pelo CLI)
op item edit "OPENAI_API_KEY_MACOS" \
    --vault "1p_macos" \
    --tag "environment:macos" \
    --tag "service:openai" \
    --tag "type:api_key" \
    --tag "status:active"
```

---

## 🔍 Troubleshooting

### Problema: "Item not found"

**Solução:**
```bash
# Verificar se item existe
op item list --vault "1p_macos" | grep -i "item_name"

# Verificar ID correto
op item get "item_name" --vault "1p_macos" --format json | jq '.id'
```

### Problema: "Permission denied"

**Solução:**
```bash
# Verificar autenticação
op whoami

# Verificar acesso ao vault
op vault list
op vault get "1p_macos"
```

### Problema: Tags não são aplicadas

**Solução:**
- Tags podem não ser suportadas via CLI em todas as versões
- Adicionar manualmente via interface web do 1Password
- Ou usar script personalizado se disponível

### Problema: Categoria não muda

**Solução:**
```bash
# Verificar categorias disponíveis
op item template list

# Tentar com nome exato da categoria
op item edit "item_name" \
    --vault "1p_macos" \
    --category "API Credential"  # Pode precisar do nome completo
```

---

## 📋 Checklist Final

Após migração completa:

- [ ] Todos os itens renomeados corretamente
- [ ] Categorias corrigidas
- [ ] Tags adicionadas (quando possível)
- [ ] Itens Cloudflare removidos
- [ ] Validação passou sem erros
- [ ] Variáveis de ambiente carregam corretamente
- [ ] Backup atualizado
- [ ] Documentação atualizada

---

## 🔗 Referências

- [Padrões de Nomenclatura](../standards/nomenclature.md)
- [Mapeamento de Categorias](../standards/categories.md)
- [Sistema de Tags](../standards/tags.md)
- [Regras de Validação](../standards/validation-rules.yaml)

---

**Última atualização:** 2025-11-17

