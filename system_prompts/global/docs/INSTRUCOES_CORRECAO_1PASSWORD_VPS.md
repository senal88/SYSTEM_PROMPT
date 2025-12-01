# 📋 Instruções de Correção Manual - 1Password VPS

**Data:** 2025-12-01  
**Status:** ⚠️ **REQUER CORREÇÃO MANUAL**

---

## 🔍 Problema Identificado

O token do Service Account pode estar em formato incorreto ou o arquivo pode ter conteúdo adicional. O erro indica:

```
failed to DecodeSACredentials: failed to DeserializeServiceAccountAuthToken, unrecognized auth type
```

---

## ✅ Solução Manual

### Passo 1: Verificar e Limpar Token

```bash
# Conectar na VPS
ssh admin-vps

# Verificar conteúdo do arquivo
cat ~/.config/op/credentials

# O token deve ser apenas uma linha com o token (sem espaços, quebras de linha extras)
# Exemplo correto:
# ops_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Passo 2: Obter Token Correto do 1Password Local

No macOS, execute:

```bash
# Autenticar no 1Password local
op signin

# Ler o token correto
op read "op://1p_vps/yhqdcrihdk5c6sk7x7fwcqazqu/credencial"
```

### Passo 3: Salvar Token Corretamente na VPS

```bash
# Na VPS, substituir o conteúdo do arquivo
# Cole APENAS o token (sem espaços, sem quebras de linha)
echo "ops_SEU_TOKEN_AQUI" > ~/.config/op/credentials
chmod 600 ~/.config/op/credentials
```

### Passo 4: Configurar Variáveis de Ambiente

```bash
# Adicionar ao .bashrc (se ainda não estiver)
cat >> ~/.bashrc << 'EOF'

# 1Password CLI Configuration
export OP_SERVICE_ACCOUNT_TOKEN=$(cat "${HOME}/.config/op/credentials" 2>/dev/null || echo "")
export OP_ACCOUNT="dev"

# Aliases
alias op-status='op account list && op vault list --account "${OP_ACCOUNT}" 2>/dev/null || echo "1Password não autenticado"'
alias op-vaults='op vault list --account "${OP_ACCOUNT}"'
alias op-items='op item list --vault 1p_vps --account "${OP_ACCOUNT}"'
EOF

# Recarregar shell
source ~/.bashrc
```

### Passo 5: Testar Autenticação

```bash
# Carregar variáveis
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials)
export OP_ACCOUNT="dev"

# Testar
op vault list --account dev
```

---

## 🔧 Alternativa: Usar Script de Correção Automática

Se preferir, execute o script de correção:

```bash
# No macOS
cd ~/Dotfiles/system_prompts/global/scripts
./corrigir-1password-vps_v1.0.0_20251201.sh
```

**Nota:** O script obtém o token automaticamente do 1Password local e configura na VPS.

---

## ✅ Verificação Final

Após correção, execute:

```bash
# Na VPS
source ~/.bashrc
op-status
op-vaults
op-items
```

Todos os comandos devem funcionar corretamente.

---

**Última Atualização:** 2025-12-01

