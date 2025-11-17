# 📋 Status: Registro de API Keys

**Data:** 2025-11-01  
**Arquivo:** `add-1password-vps-macos.md`

---

## ✅ Script Criado

**Arquivo:** `scripts/secrets/register-and-validate-api-keys.sh`

**Funcionalidades:**
- ✅ Extrai tokens do arquivo `add-1password-vps-macos.md`
- ✅ Registra nos vaults `1p_macos` e `1p_vps`
- ✅ Valida registro após criação
- ✅ Remove arquivo fonte após validação completa

---

## ⚠️ Status Atual

**Problema:** 1Password Connect não consegue criar items diretamente.

**Causa Provável:**
- Vaults `1p_macos` e `1p_vps` não existem no Connect
- Connect pode estar limitado a leitura apenas
- Permissões insuficientes para criar items

---

## 🔧 Próximos Passos

### Opção 1: Usar 1Password CLI Direto (Recomendado)

```bash
# Desabilitar Connect temporariamente
unset OP_CONNECT_HOST
unset OP_CONNECT_TOKEN

# Autenticar com CLI direto
op signin --account senamfo

# Executar script
./scripts/secrets/register-and-validate-api-keys.sh
```

### Opção 2: Verificar Vaults no Connect

```bash
# Listar vaults disponíveis
curl -s -H "Authorization: Bearer ${OP_CONNECT_TOKEN}" \
     "${OP_CONNECT_HOST}/v1/vaults" | jq '.[].name'

# Usar vaults reais (pode ter nomes diferentes)
# Ajustar script para usar vaults corretos
```

### Opção 3: Registrar Manualmente via 1Password App

1. Abrir 1Password app no macOS
2. Criar items manualmente nos vaults corretos
3. Script ainda validará após criação manual

---

## 📝 Arquivo Fonte

**Localização:** `add-1password-vps-macos.md`

**Conteúdo:**
- OPENAI_API_KEY
- ANTHROPIC_API_KEY
- HF_TOKEN
- PERPLEXITY_API_KEY
- CURSOR_API_KEY

**Status:** ✅ Arquivo existe e será removido após registro bem-sucedido

---

**Recomendação:** Use Opção 1 (CLI direto) para ambiente híbrido funcionar corretamente.

