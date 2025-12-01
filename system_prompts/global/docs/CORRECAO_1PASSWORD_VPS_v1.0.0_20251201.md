# 🔧 Correção Configuração 1Password - VPS Ubuntu

**Data:** 2025-12-01
**Versão:** 1.0.0
**Status:** ✅ **CORRIGIDO**

---

## 📋 Problema Identificado

Na VPS Ubuntu, o 1Password CLI estava instalado mas não estava autenticado corretamente:

- ❌ Comando `op-status` não encontrado (alias não configurado)
- ❌ `op vault list` retornava "No accounts configured"
- ✅ Token do Service Account existia em `~/.config/op/credentials`
- ✅ Variáveis de ambiente não estavam sendo carregadas corretamente

---

## ✅ Solução Aplicada

### 1. Verificação do Estado Atual

```bash
# Na VPS
ssh admin-vps

# Verificar token
ls -la ~/.config/op/credentials
cat ~/.config/op/credentials

# Verificar .bashrc
grep -A 10 "1Password" ~/.bashrc
```

### 2. Configuração Corrigida

O script `corrigir-1password-vps_v1.0.0_20251201.sh` foi executado e:

- ✅ Criou diretório `~/.config/op/` (já existia)
- ✅ Salvou Service Account Token em `~/.config/op/credentials`
- ✅ Adicionou configuração completa ao `.bashrc`
- ✅ Configurou aliases: `op-status`, `op-vaults`, `op-items`

### 3. Configuração Adicionada ao `.bashrc`

```bash
# ============================================================================
# 1Password CLI Configuration
# ============================================================================
export OP_SERVICE_ACCOUNT_TOKEN=$(cat "${HOME}/.config/op/credentials" 2>/dev/null || echo "")
export OP_ACCOUNT="dev"

# Aliases úteis para 1Password
alias op-status='op account list && op vault list --account "${OP_ACCOUNT}" 2>/dev/null || echo "1Password não autenticado"'
alias op-vaults='op vault list --account "${OP_ACCOUNT}"'
alias op-items='op item list --vault 1p_vps --account "${OP_ACCOUNT}"'

# Função helper para ler secrets
op-read() {
    local item_path="$1"
    op read "${item_path}" --account "${OP_ACCOUNT}" 2>/dev/null
}
```

---

## 🚀 Como Usar Agora

### Conectar na VPS e Recarregar Shell

```bash
ssh admin-vps
source ~/.bashrc
```

### Verificar Status

```bash
# Verificar autenticação e status
op-status

# Listar vaults disponíveis
op-vaults

# Listar itens do vault 1p_vps
op-items
```

### Ler Secrets

```bash
# Usando função helper
op-read 'op://1p_vps/Postgres-Prod/PASSWORD'

# Ou diretamente
op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev
```

---

## 🔍 Verificação Manual

Se os comandos ainda não funcionarem, execute manualmente:

```bash
# 1. Carregar variáveis de ambiente
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials)
export OP_ACCOUNT="dev"

# 2. Adicionar conta (se necessário)
op account add --address my.1password.com --token ${OP_SERVICE_ACCOUNT_TOKEN} --account dev

# 3. Testar
op vault list --account dev
```

---

## ✅ Status Final

- ✅ Token do Service Account configurado
- ✅ Variáveis de ambiente no `.bashrc`
- ✅ Aliases configurados
- ✅ Conta 1Password adicionada
- ✅ Vaults acessíveis

**Próximo login:** Tudo será carregado automaticamente via `.bashrc`

---

**Última Atualização:** 2025-12-01
**Versão:** 1.0.0
