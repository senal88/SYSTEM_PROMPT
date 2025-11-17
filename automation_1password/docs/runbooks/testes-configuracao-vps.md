Last Updated: 2025-10-30
Version: 1.0.0

# Testes e Configuração VPS Ubuntu - 1Password Automation

## 1. Visão Geral

Este runbook documenta o processo completo de configuração e testes do ambiente VPS Ubuntu para automação com 1Password, incluindo correção de problemas comuns de SSH e integração do agente SSH do 1Password.

### 1.1. Problema Identificado

Durante a configuração do VPS Ubuntu, o erro:

```
Bad configuration option: usekeychain
```

ocorre porque `UseKeychain` é uma opção específica do **macOS** e não existe no OpenSSH do Linux.

### 1.2. Objetivo

Estabelecer um ambiente VPS Ubuntu completamente funcional com:
- Configuração SSH correta (sem opções macOS)
- Agente 1Password SSH funcionando
- 1Password CLI configurado e autenticado
- direnv configurado para injeção automática de segredos
- Testes automatizados de validação

## 2. Scripts de Configuração

### 2.1. Correção SSH e 1Password Agent

**Arquivo**: `scripts/bootstrap/fix_ssh_1password_vps.sh`

**Funcionalidades**:
- Remove opções `UseKeychain` do SSH config (macOS-only)
- Configura `IdentityAgent` para apontar ao socket do 1Password
- Cria diretórios e symlinks necessários
- Configura opções SSH otimizadas para Linux
- Verifica instalação do 1Password CLI

**Uso**:
```bash
bash scripts/bootstrap/fix_ssh_1password_vps.sh
```

**Saída**: 
- Backup do SSH config: `~/.ssh/config.backup.YYYYMMDD_HHMMSS`
- SSH config atualizado
- Log: `logs/fix_ssh_1password_YYYYMMDD_HHMMSS.log`

### 2.2. Testes de Validação

**Arquivo**: `scripts/bootstrap/test_ssh_1password.sh`

**Testes Executados**:
1. Sistema Operacional (deve ser Linux)
2. Configuração SSH (permissões, opções corretas)
3. Socket do 1Password SSH Agent
4. 1Password CLI (instalação e autenticação)
5. Variáveis de ambiente SSH
6. Conexão SSH com GitHub

**Uso**:
```bash
bash scripts/bootstrap/test_ssh_1password.sh
```

**Saída**: 
- Relatório detalhado de cada teste
- Log: `logs/test_ssh_1password_YYYYMMDD_HHMMSS.log`
- Exit code: 0 (sucesso) ou 1 (falhas)

### 2.3. Configuração Completa do VPS

**Arquivo**: `scripts/bootstrap/setup_vps_complete.sh`

**Funcionalidades**:
1. Instala dependências (curl, wget, jq, git, build-essential)
2. Instala direnv
3. Instala 1Password CLI
4. Corrige configuração SSH (executa fix_ssh_1password_vps.sh)
5. Configura direnv (hooks e script use_1password_env)
6. Configura ambiente 1Password (carrega vps.env)
7. Cria estrutura de diretórios
8. Executa testes de validação (test_ssh_1password.sh)

**Uso**:
```bash
bash scripts/bootstrap/setup_vps_complete.sh
```

**Requisitos**:
- Acesso sudo no VPS
- Conexão SSH ao servidor
- Arquivo `env/vps.env` (opcional, para carregar variáveis)

## 3. Fluxo de Configuração Completo

### 3.1. Preparação

#### Passo 1: Conectar ao VPS
```bash
ssh usuario@ip-do-vps
```

#### Passo 2: Clonar Repositório
```bash
cd ~
git clone https://github.com/seu-usuario/automation_1password.git
cd automation_1password/Dotfiles/automation_1password
```

#### Passo 3: Executar Configuração Completa
```bash
chmod +x scripts/bootstrap/*.sh
bash scripts/bootstrap/setup_vps_complete.sh
```

### 3.2. Pós-Configuração

#### Passo 1: Recarregar Shell
```bash
source ~/.bashrc
# ou
source ~/.zshrc
```

#### Passo 2: Autenticar 1Password
```bash
# Opção A: Autenticação interativa (primeira vez)
op signin

# Opção B: Service Account Token (produção)
export OP_SERVICE_ACCOUNT_TOKEN="op_v1_..."
op whoami  # Validar autenticação
```

#### Passo 3: Testar SSH
```bash
ssh -T git@github.com
# Deve retornar: "Hi <user>! You've successfully authenticated..."
```

#### Passo 4: Testar direnv (opcional)
```bash
cd ~/projeto-com-direnv
echo 'use 1password_env' >> .envrc
direnv allow
direnv reload  # Verificar se variáveis foram injetadas
```

## 4. Troubleshooting

### 4.1. Erro: "Bad configuration option: usekeychain"

**Causa**: SSH config contém opção específica do macOS

**Solução**:
```bash
bash scripts/bootstrap/fix_ssh_1password_vps.sh
```

### 4.2. Erro: "Permission denied" ao conectar ao GitHub

**Possíveis Causas**:
- Chaves SSH não estão no 1Password
- Agente 1Password não está rodando
- Socket do agente não configurado corretamente

**Solução**:
```bash
# 1. Verificar socket
ls -la ~/.1password/agent.sock

# 2. Verificar configuração SSH
grep IdentityAgent ~/.ssh/config

# 3. Verificar 1Password está rodando
op whoami

# 4. Reexecutar correção
bash scripts/bootstrap/fix_ssh_1password_vps.sh
```

### 4.3. 1Password CLI não autentica

**Causa**: Falta de token ou autenticação

**Solução**:
```bash
# Para desenvolvimento (interativo)
op signin

# Para produção (Service Account Token)
export OP_SERVICE_ACCOUNT_TOKEN="op_v1_..."
op whoami  # Validar
```

### 4.4. direnv não funciona

**Possíveis Causas**:
- Hook não configurado no shell
- Script use_1password_env.sh não existe

**Solução**:
```bash
# Verificar hook
grep direnv ~/.bashrc ~/.zshrc

# Verificar script
ls -la ~/.config/direnv/lib/use_1password_env.sh

# Reexecutar setup
bash scripts/bootstrap/setup_vps_complete.sh
```

## 5. Validação e Testes

### 5.1. Teste Rápido

```bash
# Executar todos os testes
bash scripts/bootstrap/test_ssh_1password.sh
```

### 5.2. Teste Manual SSH

```bash
# Testar GitHub
ssh -T git@github.com

# Testar GitLab (se usar)
ssh -T git@gitlab.com

# Testar servidor próprio
ssh -T usuario@seu-servidor.com
```

### 5.3. Teste 1Password

```bash
# Verificar autenticação
op whoami

# Listar vaults
op vault list

# Ler um segredo de teste
op read op://shared_infra/test/secret
```

### 5.4. Teste direnv

```bash
# Criar projeto de teste
mkdir -p ~/test-direnv && cd ~/test-direnv

# Criar .env.op
cat > .env.op << EOF
TEST_VAR=op://shared_infra/test/secret
EOF

# Criar .envrc
echo 'use 1password_env' > .envrc
direnv allow

# Verificar variável
echo $TEST_VAR
```

## 6. Configuração Avançada

### 6.1. Service Account Token (Produção)

Para ambientes de produção, use Service Account Token:

```bash
# Gerar token (no 1Password web)
# Copiar token para variável de ambiente

export OP_SERVICE_ACCOUNT_TOKEN="op_v1_..."
echo 'export OP_SERVICE_ACCOUNT_TOKEN="op_v1_..."' >> ~/.bashrc

# Validar
op whoami
```

### 6.2. Configuração SSH para Múltiplos Hosts

Editar `~/.ssh/config`:

```ssh-config
# Configuração global (1Password)
Host *
    IdentityAgent ~/.1password/agent.sock
    AddKeysToAgent yes
    IdentitiesOnly yes

# Host específico (sem 1Password)
Host servidor-legado
    HostName 192.168.1.100
    User admin
    IdentityFile ~/.ssh/id_rsa_legado
    IdentitiesOnly yes
```

### 6.3. Integração com CI/CD

Para pipelines CI/CD, injetar token via variável de ambiente:

```yaml
# GitHub Actions exemplo
env:
  OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}

steps:
  - name: Test 1Password
    run: op whoami
```

## 7. Checklist de Configuração

Antes de considerar o VPS configurado:

- [ ] Sistema operacional Linux/Ubuntu verificado
- [ ] Dependências instaladas (curl, git, jq, direnv, 1password-cli)
- [ ] SSH config corrigido (sem UseKeychain)
- [ ] Socket do 1Password SSH agent configurado
- [ ] 1Password CLI instalado e autenticado
- [ ] direnv configurado (hook + script use_1password_env)
- [ ] Teste SSH com GitHub bem-sucedido
- [ ] Teste 1Password CLI funcionando
- [ ] Estrutura de diretórios criada
- [ ] Logs de configuração revisados

## 8. Referências

- **Runbook Principal VPS**: `docs/runbooks/automacao-vps.md`
- **Scripts de Bootstrap**: `scripts/bootstrap/`
- **Logs**: `logs/`
- **Documentação 1Password SSH**: https://developer.1password.com/docs/ssh
- **Documentação direnv**: https://direnv.net/

---

**Última atualização**: 2025-10-30  
**Versão**: 1.0.0  
**Autor**: Sistema de Automação 1Password

