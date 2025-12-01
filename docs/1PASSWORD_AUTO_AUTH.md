# Autenticação Automática 1Password CLI - Solução Completa

## Status Atual

✅ **1Password CLI instalado:** v2.32.0  
✅ **Conta configurada:** luiz.sena88@icloud.com  
⚠️ **Autenticação:** Requer autenticação manual ou Service Account Token

## Problema

O 1Password CLI requer autenticação ativa. A `OP_SECRET_KEY` sozinha não é suficiente para autenticação automática em servidores.

## Solução Recomendada: Service Account Token

Para autenticação **verdadeiramente automática** em servidores, use Service Account Token.

### Passo 1: Criar Service Account

1. Acesse: https://start.1password.com/sign-in
2. Vá em: **Settings** → **Integrations** → **Service Accounts**
3. Clique em **"Create Service Account"**
4. Dê um nome (ex: "VPS Production")
5. Selecione os vaults que precisa acessar
6. Copie o **Service Account Token**

### Passo 2: Configurar no VPS

```bash
# Adicionar ao .bashrc
echo 'export OP_SERVICE_ACCOUNT_TOKEN="seu-service-account-token-aqui"' >> ~/.bashrc

# Carregar
source ~/.bashrc

# Testar
op vault list
```

### Passo 3: Verificar

```bash
# Verificar se token está configurado
echo $OP_SERVICE_ACCOUNT_TOKEN

# Testar autenticação
op vault list
op item list
```

## Solução Alternativa: Autenticação Manual Persistente

Se não puder usar Service Account, autentique manualmente:

```bash
# Autenticar uma vez
eval $(op signin my.1password.com luiz.sena88@icloud.com)

# A sessão ficará ativa por um tempo
# Para persistir, adicione ao .bashrc (com cuidado):
# if ! op account list &>/dev/null; then
#     eval $(op signin my.1password.com luiz.sena88@icloud.com --raw) 2>/dev/null || true
# fi
```

## Scripts Criados

### 1. `op-auto-signin` (~/bin/op-auto-signin)

Script que tenta autenticar automaticamente:
- Verifica se já está autenticado
- Tenta usar OP_SECRET_KEY
- Fallback para autenticação interativa

**Uso:**
```bash
~/bin/op-auto-signin
```

### 2. `op-signin-helper` (~/bin/op-signin-helper)

Helper para verificar e autenticar:
```bash
op-signin-helper
```

## Configuração Atual no .bashrc

```bash
# OP_SECRET_KEY já configurado
export OP_SECRET_KEY="A3-YEBP46-396NV5-RDFNK-7LCQK-A43DB-H4XKC"

# Autenticação automática (tenta usar OP_SECRET_KEY)
if [ -n "$OP_SECRET_KEY" ] && ! op account list &>/dev/null 2>&1; then
    op signin my --raw 2>/dev/null || true
fi

# Script de autenticação automática
if [ -f ~/bin/op-auto-signin ]; then
    ~/bin/op-auto-signin 2>/dev/null || true
fi

# PATH para scripts
export PATH="$HOME/bin:$PATH"
```

## Testes

### Verificar Autenticação

```bash
# Verificar status
op account list

# Listar vaults
op vault list

# Listar itens
op item list
```

### Testar Scripts

```bash
# Testar autenticação automática
~/bin/op-auto-signin

# Testar helper
op-signin-helper
```

## Troubleshooting

### Erro: "You are not currently signed in"

**Causa:** Sessão expirada ou não autenticado

**Solução:**
1. Autenticar manualmente: `eval $(op signin my.1password.com luiz.sena88@icloud.com)`
2. Ou configurar Service Account Token (recomendado)

### Erro: "Service Account Token inválido"

**Causa:** Token incorreto ou expirado

**Solução:**
1. Verificar token no 1Password
2. Recriar Service Account se necessário
3. Atualizar `OP_SERVICE_ACCOUNT_TOKEN` no .bashrc

### Autenticação não persiste após reiniciar

**Causa:** Sessão expira ou não está configurada corretamente

**Solução:**
1. Usar Service Account Token (não expira)
2. Ou configurar autenticação automática no .bashrc

## Próximos Passos

1. **Criar Service Account** no 1Password (recomendado)
2. **Configurar token** no VPS
3. **Testar autenticação** automática
4. **Usar em scripts** com confiança

## Referências

- [1Password Service Accounts](https://developer.1password.com/docs/service-accounts)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli)
- Scripts em: `/root/SYSTEM_PROMPT/scripts/shared/`

---

**Nota:** Para autenticação verdadeiramente automática sem intervenção manual, **Service Account Token é obrigatório**.
