# 🔐 Configuração Automática 1Password Connect - VPS Ubuntu

**Versão:** 1.0.0  
**Data:** 2025-12-01  
**Status:** ✅ Configurado com Sucesso

---

## 📋 Resumo Executivo

Configuração automática completa do 1Password Connect na VPS Ubuntu foi realizada com sucesso. O sistema agora está configurado para:

- ✅ Acesso automático ao vault `1p_vps`
- ✅ Autenticação via Service Account
- ✅ Leitura de secrets sem interação manual
- ✅ Script helper para facilitar uso

---

## 🔧 O Que Foi Configurado

### 1. Instalação do 1Password CLI

- **Versão Instalada:** 2.30.0
- **Localização:** `/usr/local/bin/op`
- **Status:** ✅ Já estava instalado

### 2. Autenticação Automática

- **Service Account:** `admin-vps conta de servico`
- **Token Armazenado:** `~/.config/op/credentials`
- **Permissões:** `600` (apenas leitura para o usuário)
- **Variável de Ambiente:** `OP_SERVICE_ACCOUNT_TOKEN` configurada no `~/.bashrc`

### 3. Acesso ao Vault

- **Vault:** `1p_vps`
- **Account:** `dev`
- **Status:** ✅ Acesso confirmado e testado

### 4. Script Helper

- **Localização:** `~/Dotfiles/system_prompts/global/scripts/op-helper.sh`
- **Funções Disponíveis:**
  - `op_read()` - Ler secrets via referência `op://`
  - `op_list_vault()` - Listar itens de um vault

---

## 📊 Dados Configurados

### Service Account Utilizado

- **ID do Item:** `yhqdcrihdk5c6sk7x7fwcqazqu`
- **Nome:** `Service Account Auth Token: admin-vps conta de servico`
- **Vault:** `1p_vps`
- **Tipo:** Service Account Token
- **Criado:** 2025-11-25
- **Status:** ✅ Ativo e Funcional

### Credenciais

- **Token:** Armazenado em `~/.config/op/credentials` na VPS
- **Formato:** Service Account Token (ops_...)
- **Segurança:** Arquivo com permissões `600`

---

## 🚀 Como Usar na VPS

### Conectar na VPS

```bash
ssh admin-vps
```

### Testar Acesso

```bash
# Listar vaults disponíveis
op vault list --account dev

# Listar itens do vault 1p_vps
op item list --vault 1p_vps --account dev

# Ler um secret específico
op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev
```

### Usar Script Helper

```bash
# Carregar funções helper
source ~/Dotfiles/system_prompts/global/scripts/op-helper.sh

# Usar função helper para ler secret
export DB_PASSWORD=$(op_read "op://1p_vps/Postgres-Prod/PASSWORD")

# Listar itens do vault
op_list_vault "1p_vps"
```

### Exemplo Prático em Scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

# Carregar credenciais
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null || echo "")

# Ler secrets do 1Password
export POSTGRES_USER=$(op read 'op://1p_vps/Postgres-Prod/USER' --account dev)
export POSTGRES_PASSWORD=$(op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev)
export POSTGRES_DB=$(op read 'op://1p_vps/Postgres-Prod/DB' --account dev)

# Usar nas variáveis de ambiente do Docker
docker-compose up -d
```

---

## 🔍 Verificação de Funcionamento

### Testes Realizados

1. ✅ **Conexão SSH:** Estabelecida com sucesso
2. ✅ **Instalação CLI:** 1Password CLI versão 2.30.0 confirmada
3. ✅ **Autenticação:** Service Account configurado corretamente
4. ✅ **Acesso ao Vault:** Vault `1p_vps` acessível
5. ✅ **Leitura de Secrets:** Teste de leitura bem-sucedido
6. ✅ **Script Helper:** Criado e funcional

### Itens Encontrados no Vault

Durante o teste, foram listados os seguintes itens no vault `1p_vps`:

- `Postgres_vps | app_tributario`
- `PostgreSQL | n8n_db`
- `GOOGLE_API_KEY`
- `1P-Hostinger-API`

---

## 📁 Arquivos Criados na VPS

### 1. Credenciais

- **Arquivo:** `~/.config/op/credentials`
- **Conteúdo:** Service Account Token
- **Permissões:** `600`
- **Uso:** Autenticação automática

### 2. Configuração Bash

- **Arquivo:** `~/.bashrc`
- **Adições:**
  ```bash
  # 1Password Service Account
  export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null)
  ```

### 3. Script Helper

- **Arquivo:** `~/Dotfiles/system_prompts/global/scripts/op-helper.sh`
- **Funções:** `op_read()`, `op_list_vault()`
- **Permissões:** `755` (executável)

---

## 🔐 Segurança

### Medidas Implementadas

1. **Permissões Restritivas:**
   - Arquivo de credenciais com permissão `600` (apenas leitura para o usuário)
   - Script helper com permissões adequadas

2. **Armazenamento Seguro:**
   - Credenciais armazenadas em `~/.config/op/credentials`
   - Não expostas em variáveis de ambiente permanentes
   - Carregadas dinamicamente quando necessário

3. **Acesso Limitado:**
   - Service Account com acesso apenas ao vault `1p_vps`
   - Não tem acesso a outros vaults ou contas

---

## 🛠️ Manutenção

### Atualizar Credenciais

Se o Service Account Token precisar ser atualizado:

```bash
# Na VPS, atualizar arquivo de credenciais
nano ~/.config/op/credentials
# Colar novo token
chmod 600 ~/.config/op/credentials
```

### Verificar Status

```bash
# Testar conexão
op vault list --account dev

# Verificar versão do CLI
op --version

# Verificar configuração
cat ~/.config/op/credentials | head -c 20
```

### Troubleshooting

**Problema:** `op vault list` retorna erro de autenticação

**Solução:**
```bash
# Verificar se token existe
cat ~/.config/op/credentials

# Recarregar variáveis de ambiente
source ~/.bashrc

# Testar novamente
op vault list --account dev
```

**Problema:** Não consegue ler secrets

**Solução:**
```bash
# Verificar se está usando a conta correta
op vault list --account dev

# Verificar permissões do Service Account no 1Password
# (deve ter acesso ao vault 1p_vps)
```

---

## 📚 Documentação Relacionada

- **Mapeamento de Secrets:** `~/Dotfiles/infra-vps/vaults-1password/docs/MAPEAMENTO_SECRETS_COMPLETO_v1.0.0_20251201.md`
- **Organização Secrets:** `~/Dotfiles/system_prompts/global/docs/ORGANIZACAO_SECRETS_1PASSWORD_v1.0.0_20251201.md`
- **Script de Configuração:** `~/Dotfiles/system_prompts/global/scripts/configurar-1password-connect-vps_v1.0.0_20251201.sh`

---

## ✅ Checklist de Validação

- [x] 1Password CLI instalado na VPS
- [x] Service Account Token configurado
- [x] Autenticação automática funcionando
- [x] Acesso ao vault `1p_vps` confirmado
- [x] Leitura de secrets testada
- [x] Script helper criado
- [x] Documentação completa

---

**Última Atualização:** 2025-12-01  
**Próxima Revisão:** Conforme necessidade

