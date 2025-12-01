# ✅ Resumo Final - Correção 1Password VPS

**Data:** 2025-12-01
**Status:** ⚠️ **REQUER CORREÇÃO MANUAL DO TOKEN**

---

## 🔍 Problema Identificado

O arquivo `~/.config/op/credentials` na VPS tem **3 linhas** quando deveria ter apenas **1 linha** com o token do Service Account.

**Erro:**

```
failed to DecodeSACredentials: failed to DeserializeServiceAccountAuthToken, unrecognized auth type
```

---

## ✅ Solução Manual (Recomendada)

### Passo 1: Obter Token Correto no macOS

```bash
# No macOS, autenticar no 1Password
op signin

# Ler o token (deve ser uma linha única, ~853 caracteres)
op read "op://1p_vps/yhqdcrihdk5c6sk7x7fwcqazqu/credencial"
```

**Copie APENAS o token** (começa com `ops_` e tem ~853 caracteres)

### Passo 2: Limpar e Salvar Token na VPS

```bash
# Conectar na VPS
ssh admin-vps

# Fazer backup do arquivo atual
cp ~/.config/op/credentials ~/.config/op/credentials.backup

# Limpar e salvar APENAS o token (cole o token que você copiou)
echo "ops_SEU_TOKEN_AQUI_SEM_ESPACOS_NEM_QUEBRAS" > ~/.config/op/credentials

# Verificar que tem apenas 1 linha
wc -l ~/.config/op/credentials  # Deve mostrar: 1

# Configurar permissões
chmod 600 ~/.config/op/credentials
```

### Passo 3: Testar Autenticação

```bash
# Carregar variáveis
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials | tr -d '\n\r\t ')
export OP_ACCOUNT="dev"

# Testar
op vault list --account dev
```

Se funcionar, você verá a lista de vaults.

### Passo 4: Recarregar Shell e Testar Aliases

```bash
# Recarregar .bashrc
source ~/.bashrc

# Testar aliases
op-status
op-vaults
op-items
```

---

## 🔧 Scripts Disponíveis

### Script de Correção Automática

```bash
# No macOS
cd ~/Dotfiles/system_prompts/global/scripts
./corrigir-token-1password-vps_v1.0.0_20251201.sh
```

**Nota:** O script limpa o arquivo e salva apenas o token, mas pode requerer teste manual adicional.

---

## ✅ Verificação Final

Após correção, execute na VPS:

```bash
# Verificar arquivo
cat ~/.config/op/credentials | wc -l  # Deve ser: 1
cat ~/.config/op/credentials | wc -c  # Deve ser: ~853

# Testar autenticação
source ~/.bashrc
op-status
op-vaults
op-items
```

---

## 📋 Checklist

- [ ] Token obtido do 1Password local (macOS)
- [ ] Arquivo `~/.config/op/credentials` tem apenas 1 linha
- [ ] Token tem ~853 caracteres
- [ ] Permissões: `600`
- [ ] Variáveis de ambiente carregadas no `.bashrc`
- [ ] Autenticação funcionando: `op vault list --account dev`
- [ ] Aliases funcionando: `op-status`, `op-vaults`, `op-items`

---

## 🚨 Troubleshooting

### Se ainda não funcionar:

1. **Verificar formato do token:**

   ```bash
   cat ~/.config/op/credentials | head -c 20
   # Deve começar com: ops_
   ```

2. **Verificar se não há espaços ou caracteres extras:**

   ```bash
   cat ~/.config/op/credentials | od -c | head -5
   ```

3. **Testar token diretamente:**

   ```bash
   export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials | tr -d '\n\r\t ')
   op vault list --account dev
   ```

4. **Verificar versão do 1Password CLI:**
   ```bash
   op --version
   # Deve ser: 2.x.x ou superior
   ```

---

**Última Atualização:** 2025-12-01
**Versão:** 1.0.0
