# Instruções: Configurar 1Password do Cofre 1p_vps

## Método 1: Autenticar e Buscar Automaticamente

```bash
# 1. Autenticar no 1Password
eval $(op signin my.1password.com luiz.sena88@icloud.com)

# 2. Executar script de configuração
/root/SYSTEM_PROMPT/scripts/shared/configure_1password_from_vault.sh
```

## Método 2: Buscar Manualmente

```bash
# 1. Autenticar
eval $(op signin)

# 2. Listar itens
op item list

# 3. Buscar item específico
op item get "1p_vps"

# 4. Extrair token
op item get "1p_vps" --fields "token"
# ou
op item get "1p_vps" --fields "password"
# ou
op item get "1p_vps" --format json | jq -r '.fields[] | select(.label | test("token"; "i")) | .value'

# 5. Configurar
export OP_SERVICE_ACCOUNT_TOKEN="token-extraido"
echo 'export OP_SERVICE_ACCOUNT_TOKEN="token-extraido"' >> ~/.bashrc
```

## Método 3: Usar op:// URL

Se o item estiver em um vault específico:

```bash
# Ler token usando op:// URL
TOKEN=$(op read "op://vault-name/1p_vps/token")

# Configurar
export OP_SERVICE_ACCOUNT_TOKEN="$TOKEN"
echo "export OP_SERVICE_ACCOUNT_TOKEN=\"$TOKEN\"" >> ~/.bashrc
```

## Verificar

```bash
# Carregar variável
source ~/.bashrc

# Testar
op vault list
```

---

**Nota:** O token deve começar com `opvault_` para ser um Service Account Token válido.
