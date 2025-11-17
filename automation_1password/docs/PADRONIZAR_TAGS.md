# Padronização de Tags - 1Password

**Versão:** 1.0.0
**Última Atualização:** 2025-11-17

---

## 🎯 Objetivo

Remover todas as tags fora do padrão e garantir que todas as tags sigam o formato hierárquico `namespace:value`, garantindo automação eficiente e livre de erros.

---

## 📋 Padrão de Tags

### Formato Válido

```
namespace:value
```

**Exemplos:**

- ✅ `environment:macos`
- ✅ `service:google`
- ✅ `type:api_key`
- ✅ `status:active`
- ❌ `macos` (sem namespace)
- ❌ `google` (sem namespace)
- ❌ `API_KEY` (maiúsculas, sem namespace)

### Namespaces Válidos

1. **environment**: macos, vps, shared, production, development, staging
2. **service**: openai, anthropic, google, github, gitlab, docker, cloudflare, hostinger, etc.
3. **type**: api_key, token, password, credentials, service_account, ssh_key, certificate, license, note
4. **status**: active, inactive, deprecated, expired, rotated
5. **project**: gemini, chatwoot, n8n, nocodb, mfotrust, senamfo, etc.
6. **priority**: critical, high, medium, low

---

## 🔧 Scripts Disponíveis

### 1. Analisar Tags

Identifica todas as tags fora do padrão:

```bash
# Analisar vault específico
./vaults-1password/scripts/analisar-tags-1password.sh --vault "1p_macos"

# Analisar todos os vaults
./vaults-1password/scripts/analisar-tags-1password.sh --all

# Gerar relatório
./vaults-1password/scripts/analisar-tags-1password.sh --all --output relatorio-tags.md
```

### 2. Padronizar Tags

Remove tags inválidas e aplica padrões:

```bash
# Testar (dry-run)
./vaults-1password/scripts/padronizar-tags-1password.sh --vault "1p_macos" --dry-run

# Aplicar mudanças
./vaults-1password/scripts/padronizar-tags-1password.sh --vault "1p_macos"

# Todos os vaults
./vaults-1password/scripts/padronizar-tags-1password.sh --all --dry-run
```

---

## 🔄 Processo de Migração

### Tags que Serão Migradas

| Tag Antiga | Tag Nova |
|------------|----------|
| `macos` | `environment:macos` |
| `vps` | `environment:vps` |
| `api` | `type:api_key` |
| `key` | `type:api_key` |
| `token` | `type:token` |
| `password` | `type:password` |
| `active` | `status:active` |
| `inactive` | `status:inactive` |
| `production` | `environment:production` |
| `development` | `environment:development` |
| `staging` | `environment:staging` |
| `critical` | `priority:critical` |
| `high` | `priority:high` |
| `medium` | `priority:medium` |
| `low` | `priority:low` |

### Tags que Serão Removidas

- `test`
- `temp`
- `old`
- `backup`
- Tags sem namespace válido
- Tags com valores inválidos

---

## 📊 Fluxo de Trabalho Recomendado

### 1. Análise Inicial

```bash
# Analisar todos os vaults
./vaults-1password/scripts/analisar-tags-1password.sh --all --output relatorio-inicial.md

# Revisar relatório
cat relatorio-inicial.md
```

### 2. Teste de Padronização

```bash
# Testar em um vault
./vaults-1password/scripts/padronizar-tags-1password.sh --vault "1p_macos" --dry-run

# Verificar resultados
./vaults-1password/scripts/analisar-tags-1password.sh --vault "1p_macos"
```

### 3. Aplicar Padronização

```bash
# Aplicar em um vault
./vaults-1password/scripts/padronizar-tags-1password.sh --vault "1p_macos"

# Verificar resultado
./vaults-1password/scripts/analisar-tags-1password.sh --vault "1p_macos"
```

### 4. Padronizar Todos os Vaults

```bash
# Testar todos
./vaults-1password/scripts/padronizar-tags-1password.sh --all --dry-run

# Aplicar todos
./vaults-1password/scripts/padronizar-tags-1password.sh --all
```

---

## ✅ Validação Contínua

### Script de Validação

```bash
# Validar tags de um item específico
op item get "GOOGLE_API_KEY" --vault "1p_macos" --format json | jq -r '.tags[]?' | while read tag; do
    if [[ ! "$tag" =~ ^[a-z0-9_]+:[a-z0-9_]+$ ]]; then
        echo "❌ Tag inválida: $tag"
    else
        echo "✅ Tag válida: $tag"
    fi
done
```

### Integração com CI/CD

Adicionar validação de tags em pipelines:

```bash
# Validar antes de commit
./vaults-1password/scripts/analisar-tags-1password.sh --all --output /tmp/tags-check.txt
if grep -q "Tags inválidas" /tmp/tags-check.txt; then
    echo "❌ Tags inválidas encontradas!"
    exit 1
fi
```

---

## 📝 Exemplos

### Antes da Padronização

```
Item: OPENAI_API_KEY_MACOS
Tags: macos, openai, api, active, critical
```

### Depois da Padronização

```
Item: OPENAI_API_KEY_MACOS
Tags: environment:macos, service:openai, type:api_key, status:active, priority:critical
```

---

## 🔗 Referências

- [Sistema de Tags](./standards/tags.md)
- [Tags Válidas](../standards/tags-validas.yaml)
- [Script de Análise](../scripts/analisar-tags-1password.sh)
- [Script de Padronização](../scripts/padronizar-tags-1password.sh)

---

**Última atualização:** 2025-11-17
