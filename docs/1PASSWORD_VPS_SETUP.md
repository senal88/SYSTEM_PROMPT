# Configuração 1Password CLI - VPS

Guia completo para configurar autenticação automática do 1Password CLI na VPS.

## Problema: Autenticação Falhando

### Sintoma

```bash
op vault list
# [ERROR] You are not currently signed in. Please run `op signin --help` for instructions
```

### Causa

O 1Password CLI requer autenticação manual ou Service Account Token para funcionar em servidores sem interface gráfica.

## Solução Automática

Execute o script de correção:

```bash
/root/SYSTEM_PROMPT/scripts/shared/fix_1password_vps.sh
```

Este script:
1. ✅ Verifica instalação do 1Password CLI
2. ✅ Verifica autenticação atual
3. ✅ Configura autenticação automática no `.bashrc`
4. ✅ Cria script helper para autenticação
5. ✅ Configura PATH se necessário

## Métodos de Autenticação

### Método 1: Service Account Token (Recomendado)

**Vantagens:**
- Autenticação automática
- Não requer senha manual
- Ideal para servidores e automação

**Configuração:**

1. Criar Service Account no 1Password:
   - Acesse: https://start.1password.com/sign-in
   - Vá em: Settings → Integrations → Service Accounts
   - Clique em "Create Service Account"
   - Copie o token

2. Configurar no VPS:
   ```bash
   export OP_SERVICE_ACCOUNT_TOKEN="op://vault/item/field"
   # Ou token direto
   export OP_SERVICE_ACCOUNT_TOKEN="seu-token-aqui"

   # Adicionar ao .bashrc para persistência
   echo 'export OP_SERVICE_ACCOUNT_TOKEN="seu-token-aqui"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Testar:
   ```bash
   op vault list
   ```

### Método 2: Sessão Persistente

**Configuração:**

1. Autenticar manualmente (uma vez):
   ```bash
   eval $(op signin my.1password.com luiz.sena88@icloud.com)
   ```

2. Adicionar ao `.bashrc` para autenticação automática:
   ```bash
   # Adicionar ao final do ~/.bashrc
   if ! op account list &>/dev/null; then
       eval $(op signin my.1password.com luiz.sena88@icloud.com --raw) 2>/dev/null || true
   fi
   ```

3. Recarregar:
   ```bash
   source ~/.bashrc
   ```

## Script Helper

O script `op-signin-helper` foi criado em `~/bin/`:

```bash
# Usar helper
op-signin-helper

# Ou adicionar ao PATH se não estiver
export PATH="$HOME/bin:$PATH"
```

## Verificação

### Verificar Autenticação

```bash
# Verificar se está autenticado
op account list

# Listar vaults
op vault list

# Testar comando
op item list
```

### Verificar Configuração

```bash
# Verificar variáveis de ambiente
env | grep OP_

# Verificar arquivos de configuração
ls -la ~/.config/op/

# Verificar .bashrc
grep -i "op\|1password" ~/.bashrc
```

## Troubleshooting

### Erro: "You are not currently signed in"

**Solução:**
```bash
# Autenticar manualmente
eval $(op signin my.1password.com luiz.sena88@icloud.com)

# Ou configurar Service Account Token
export OP_SERVICE_ACCOUNT_TOKEN="seu-token"
```

### Erro: "Service Account Token inválido"

**Solução:**
1. Verificar se o token está correto
2. Verificar se o Service Account tem permissões adequadas
3. Recriar Service Account se necessário

### Autenticação não persiste após reiniciar

**Solução:**
1. Verificar se configuração está no `.bashrc`
2. Verificar se `.bashrc` é carregado no login
3. Adicionar ao `.profile` se necessário

### PATH não inclui ~/bin

**Solução:**
```bash
# Adicionar ao .bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Integração com Scripts

### Usar em Scripts

```bash
#!/bin/bash
# Verificar autenticação antes de usar
if ! op account list &>/dev/null; then
    if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
        echo "Usando Service Account Token"
    else
        echo "Erro: Não autenticado no 1Password"
        exit 1
    fi
fi

# Usar 1Password CLI
op item get "nome-do-item"
```

### Carregar Secrets Automaticamente

```bash
#!/bin/bash
# Carregar secrets do 1Password
source <(op inject -i script.sh)
```

## Segurança

### Boas Práticas

1. **Service Account Token:**
   - Armazenar em variável de ambiente
   - Não commitar em repositórios
   - Rotacionar periodicamente

2. **Permissões:**
   - Dar apenas permissões necessárias ao Service Account
   - Usar vaults específicos quando possível

3. **Logs:**
   - Não logar tokens ou secrets
   - Limpar histórico quando necessário

## Referências

- [1Password CLI Documentation](https://developer.1password.com/docs/cli)
- [Service Accounts Guide](https://developer.1password.com/docs/service-accounts)
- [Script de Correção](../scripts/shared/fix_1password_vps.sh)

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

