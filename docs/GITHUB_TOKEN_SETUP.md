# Configuração GitHub Personal Access Token - VPS

Guia completo para configurar GitHub Personal Access Token na VPS para push automático.

## Status Atual

✅ **Token configurado:** `ghp_7YBdUD...`  
✅ **Usuário:** senal88  
✅ **Repositório:** senal88/SYSTEM_PROMPT  
✅ **Autenticação:** Funcionando

## Configuração Aplicada

### 1. Variáveis de Ambiente

Adicionado ao `~/.bashrc`:
```bash
export GITHUB_TOKEN="ghp_YOUR_TOKEN_HERE"
export GIT_TOKEN="ghp_YOUR_TOKEN_HERE"
```

### 2. Git Credential Helper

```bash
git config --global credential.helper store
```

### 3. .git-credentials

Criado em `~/.git-credentials`:
```
https://ghp_YOUR_TOKEN_HERE@github.com
```

### 4. Remote Configurado

```bash
git remote set-url origin https://ghp_YOUR_TOKEN_HERE@github.com/senal88/SYSTEM_PROMPT.git
```

## Script de Configuração

Use o script para configurar tokens:

```bash
/root/SYSTEM_PROMPT/scripts/shared/configure_github_token.sh <seu-token>
```

Ou com variável de ambiente:
```bash
GITHUB_TOKEN="seu-token" /root/SYSTEM_PROMPT/scripts/shared/configure_github_token.sh
```

## Verificação

### Testar Token

```bash
# Verificar variáveis
echo $GITHUB_TOKEN
echo $GIT_TOKEN

# Testar API GitHub
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### Testar Push

```bash
cd /root/SYSTEM_PROMPT
git add .
git commit -m "Teste"
git push origin main
```

## Segurança

### Boas Práticas

1. **Não commitar tokens:**
   - Tokens estão apenas em `.bashrc` e `.git-credentials`
   - `.git-credentials` tem permissão 600
   - Não está versionado no git

2. **Rotacionar tokens:**
   - Rotacione periodicamente
   - Revogue tokens antigos no GitHub

3. **Permissões mínimas:**
   - Token tem apenas permissões necessárias
   - Pode ser limitado a repositórios específicos

## Troubleshooting

### Erro: "Authentication failed"

**Solução:**
```bash
# Verificar token
echo $GITHUB_TOKEN

# Reconfigurar
/root/SYSTEM_PROMPT/scripts/shared/configure_github_token.sh <novo-token>
```

### Erro: "Permission denied"

**Solução:**
1. Verificar permissões do token no GitHub
2. Verificar se token não expirou
3. Recriar token se necessário

### Push rejeitado

**Solução:**
```bash
# Fazer pull primeiro
git pull origin main --allow-unrelated-histories

# Depois push
git push origin main
```

## Atualizar Token

Se precisar atualizar o token:

```bash
# Usar script
/root/SYSTEM_PROMPT/scripts/shared/configure_github_token.sh <novo-token>

# Ou manualmente
sed -i 's/export GITHUB_TOKEN=".*"/export GITHUB_TOKEN="novo-token"/' ~/.bashrc
sed -i 's|https://.*@github.com|https://novo-token@github.com|' ~/.git-credentials
git remote set-url origin https://novo-token@github.com/senal88/SYSTEM_PROMPT.git
source ~/.bashrc
```

## Referências

- [GitHub Personal Access Tokens](https://github.com/settings/tokens)
- [Script de Configuração](../scripts/shared/configure_github_token.sh)

---

**Versão:** 1.0  
**Última atualização:** 2025-11-15

