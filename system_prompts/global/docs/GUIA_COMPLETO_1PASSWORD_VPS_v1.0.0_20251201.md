# 🔐 Guia Completo - 1Password Connect na VPS Ubuntu

**Versão:** 1.0.0  
**Data:** 2025-12-01  
**Status:** ✅ **100% CONFIGURADO E FUNCIONAL**

---

## 📊 Status Final da Configuração

| Componente | Status | Detalhes |
|------------|--------|----------|
| **1Password CLI** | ✅ v2.30.0 | `/usr/local/bin/op` |
| **Autenticação** | ✅ Automática | Service Account Token |
| **Credenciais** | ✅ Protegidas | `~/.config/op/credentials` (chmod 600) |
| **Carregamento** | ✅ Automático | Via `.bashrc` |

---

## 🗂️ Vaults Acessíveis

| Vault | Itens | Descrição |
|-------|-------|-----------|
| `1p_vps` | 130 itens | Vault principal de produção (VPS) |
| `1p_macos` | 72 itens | Vault de desenvolvimento (macOS) |
| `default importado` | disponível | Vault padrão importado |

---

## 🚀 Comandos Disponíveis

### Comandos Helper (Aliases)

Os seguintes aliases estão configurados no `~/.bashrc`:

```bash
# Verificar status da conexão
op-status

# Listar vaults disponíveis
op-vaults

# Listar itens do vault 1p_vps
op-items
```

### Comandos Diretos do 1Password CLI

```bash
# Listar vaults
op vault list --account dev

# Listar itens de um vault específico
op item list --vault 1p_vps --account dev
op item list --vault 1p_macos --account dev

# Ler um secret específico
op read 'op://1p_vps/GitHub Personal Access Token/password' --account dev
op read 'op://1p_vps/CURSOR_CLOUD_AGENT_API_KEY/credential' --account dev
op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev

# Buscar itens
op item list --vault 1p_vps --account dev | grep -i "postgres"

# Obter detalhes de um item
op item get "ITEM_ID" --vault 1p_vps --account dev
```

---

## 📝 Exemplos Práticos de Uso

### Exemplo 1: Carregar Secrets para Docker Compose

```bash
#!/usr/bin/env bash
set -euo pipefail

# Carregar credenciais (já está no .bashrc, mas para garantir)
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null)

# Ler secrets do vault 1p_vps
export POSTGRES_USER=$(op read 'op://1p_vps/Postgres-Prod/USER' --account dev)
export POSTGRES_PASSWORD=$(op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev)
export POSTGRES_DB=$(op read 'op://1p_vps/Postgres-Prod/DB' --account dev)
export REDIS_PASSWORD=$(op read 'op://1p_vps/Redis-Prod/password' --account dev)

# Usar nas variáveis de ambiente do Docker
docker-compose up -d
```

### Exemplo 2: Usar em Scripts de Deploy

```bash
#!/usr/bin/env bash
set -euo pipefail

# Carregar credenciais
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null)

# Obter API keys
export GITHUB_TOKEN=$(op read 'op://1p_vps/GitHub Personal Access Token/password' --account dev)
export CURSOR_API_KEY=$(op read 'op://1p_vps/CURSOR_CLOUD_AGENT_API_KEY/credential' --account dev)

# Usar nas operações
curl -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/user
```

### Exemplo 3: Usar Script Helper

```bash
# Carregar funções helper
source ~/Dotfiles/system_prompts/global/scripts/op-helper.sh

# Usar funções
export DB_PASSWORD=$(op_read "op://1p_vps/Postgres-Prod/PASSWORD")
export DB_USER=$(op_read "op://1p_vps/Postgres-Prod/USER")

# Listar itens
op_list_vault "1p_vps"
```

---

## 🔧 Configuração Automática

### Como Funciona

A autenticação é carregada **automaticamente** ao iniciar o shell:

1. **Arquivo de Credenciais:** `~/.config/op/credentials`
   - Contém o Service Account Token
   - Permissões: `600` (apenas leitura para o usuário)

2. **Carregamento Automático:** `~/.bashrc`
   ```bash
   # 1Password Service Account
   export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null)
   ```

3. **Variável de Ambiente:** `OP_SERVICE_ACCOUNT_TOKEN`
   - Carregada automaticamente em cada sessão
   - Disponível para todos os comandos `op`

### ✅ Não é mais necessário executar `op signin` manualmente!

---

## 🔐 Service Account Utilizado

- **ID do Item:** `yhqdcrihdk5c6sk7x7fwcqazqu`
- **Nome:** `Service Account Auth Token: admin-vps conta de servico`
- **Email:** `cer7itfaktf5g@1passwordserviceaccounts.com`
- **Address:** `my.1password.com`
- **Account:** `dev`
- **Vaults Acessíveis:** `1p_vps`, `1p_macos`
- **Status:** ✅ Ativo e Funcional

---

## 📁 Estrutura de Arquivos na VPS

```
~/
├── .config/
│   └── op/
│       └── credentials          # Service Account Token (chmod 600)
├── .bashrc                      # Configuração de variáveis de ambiente
└── Dotfiles/
    └── system_prompts/
        └── global/
            └── scripts/
                └── op-helper.sh  # Funções helper
```

---

## 🛠️ Scripts Disponíveis

### 1. Configuração Automática
```bash
~/Dotfiles/system_prompts/global/scripts/configurar-1password-connect-vps_v1.0.0_20251201.sh
```
**Uso:** Configurar 1Password Connect na VPS do zero

### 2. Verificação de Status
```bash
~/Dotfiles/system_prompts/global/scripts/verificar-configuracao-1password-vps_v1.0.0_20251201.sh
```
**Uso:** Verificar se tudo está configurado corretamente

### 3. Helper Functions
```bash
source ~/Dotfiles/system_prompts/global/scripts/op-helper.sh
```
**Uso:** Carregar funções helper para facilitar uso

---

## 🔍 Troubleshooting

### Problema: Comando `op` não encontrado

**Solução:**
```bash
# Verificar instalação
which op
op --version

# Se não estiver instalado, executar script de configuração
~/Dotfiles/system_prompts/global/scripts/configurar-1password-connect-vps_v1.0.0_20251201.sh
```

### Problema: "No accounts configured"

**Solução:**
```bash
# Verificar se token está carregado
echo $OP_SERVICE_ACCOUNT_TOKEN | head -c 20

# Recarregar se necessário
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials)

# Usar sempre com --account dev
op vault list --account dev
```

### Problema: Não consegue ler secrets

**Solução:**
```bash
# Verificar arquivo de credenciais
cat ~/.config/op/credentials | head -c 20

# Verificar permissões
stat -c '%a' ~/.config/op/credentials  # Deve ser 600

# Recarregar variável
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials)

# Testar acesso
op vault list --account dev
```

### Problema: Variável não carrega automaticamente

**Solução:**
```bash
# Verificar se está no .bashrc
grep "OP_SERVICE_ACCOUNT_TOKEN" ~/.bashrc

# Se não estiver, adicionar:
echo 'export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null)' >> ~/.bashrc

# Recarregar shell
source ~/.bashrc
```

---

## ✅ Checklist de Validação

Execute os seguintes comandos para validar a configuração:

```bash
# 1. Verificar CLI instalado
op --version
# Esperado: 2.30.0 ou superior

# 2. Verificar arquivo de credenciais
test -f ~/.config/op/credentials && echo "OK" || echo "FALTA"
# Esperado: OK

# 3. Verificar permissões
stat -c '%a' ~/.config/op/credentials
# Esperado: 600

# 4. Verificar variável de ambiente
echo $OP_SERVICE_ACCOUNT_TOKEN | head -c 20
# Esperado: ops_eyJzaWduSW5BZGRy...

# 5. Verificar acesso aos vaults
op vault list --account dev
# Esperado: Lista de vaults incluindo 1p_vps

# 6. Verificar itens do vault
op item list --vault 1p_vps --account dev | wc -l
# Esperado: 130 ou mais itens

# 7. Testar leitura de secret
op read 'op://1p_vps/Postgres-Prod/PASSWORD' --account dev
# Esperado: Valor do secret (não vazio)
```

---

## 📚 Referências e Documentação

### Documentação Criada

1. **`CONFIGURACAO_1PASSWORD_CONNECT_VPS_v1.0.0_20251201.md`**
   - Guia completo de configuração
   - Detalhes técnicos

2. **`RESUMO_CONFIGURACAO_1PASSWORD_VPS_v1.0.0_20251201.md`**
   - Resumo executivo
   - Status e verificações

3. **`GUIA_COMPLETO_1PASSWORD_VPS_v1.0.0_20251201.md`** (este arquivo)
   - Guia completo de uso
   - Exemplos práticos

### Links Úteis

- [1Password CLI Documentation](https://developer.1password.com/docs/cli)
- [Service Accounts Guide](https://developer.1password.com/docs/service-accounts)
- [1Password Connect](https://developer.1password.com/docs/connect)

---

## 🎯 Conclusão

**Status Final:** ✅ **100% CONFIGURADO E FUNCIONAL**

- ✅ 1Password CLI v2.30.0 instalado
- ✅ Service Account Token configurado e protegido
- ✅ Autenticação automática funcionando
- ✅ Acesso aos vaults `1p_vps` e `1p_macos` confirmado
- ✅ 130+ itens acessíveis no vault `1p_vps`
- ✅ Scripts helper disponíveis
- ✅ Documentação completa criada

**A VPS Ubuntu está totalmente configurada para usar o 1Password Connect automaticamente, sem necessidade de autenticação manual!**

---

**Última Atualização:** 2025-12-01  
**Próxima Revisão:** Conforme necessidade  
**Versão:** 1.0.0

