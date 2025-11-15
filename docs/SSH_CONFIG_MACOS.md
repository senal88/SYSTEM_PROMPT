# Configuração SSH Completa - macOS Silicon

Análise e estruturação completa do arquivo `~/.ssh/config` para macOS Silicon.

## Análise da Configuração Atual

### Pontos Positivos
- ✅ Uso de `Include` para configurações externas (Colima)
- ✅ Configuração de VPS com otimizações (ControlMaster, Compression)
- ✅ Múltiplos hosts configurados (VPS, GitHub, Hugging Face)
- ✅ Integração com 1Password SSH Agent
- ✅ Uso de chave ed25519 (moderna e segura)

### Melhorias Recomendadas
- Adicionar mais comentários e organização
- Incluir configurações de segurança adicionais
- Adicionar configurações para outros serviços comuns
- Melhorar estrutura e legibilidade
- Adicionar configurações de timeout e retry

## Configuração Completa Estruturada

```ssh-config
# ============================================================
# SSH CONFIG - macOS Silicon
# ============================================================
# Configuração completa e otimizada para macOS
# Versão: 2.0
# Data: 2025-11-15
# ============================================================

# ============================================================
# CONFIGURAÇÕES GLOBAIS E INCLUDES
# ============================================================

# Incluir configurações externas (Colima, Docker, etc.)
Include /Users/luiz.sena88/.colima/ssh_config

# ============================================================
# CONFIGURAÇÕES PADRÃO PARA TODOS OS HOSTS
# ============================================================

Host *
    # Autenticação
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    AddKeysToAgent yes
    UseKeychain yes

    # Segurança
    StrictHostKeyChecking accept-new
    UserKnownHostsFile ~/.ssh/known_hosts

    # Performance
    Compression yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

    # Conexão
    TCPKeepAlive yes
    ConnectTimeout 10

    # Logging (opcional, descomente se necessário)
    # LogLevel INFO

# ============================================================
# VPS OVH - SERVIDOR PRINCIPAL
# ============================================================

Host vps
    HostName 147.79.81.59
    User root
    Port 22

    # Autenticação
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes

    # Otimizações de Conexão
    ForwardAgent yes
    ControlMaster auto
    ControlPath ~/.ssh/control-%h-%p-%r
    ControlPersist 10m

    # Performance
    Compression yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

    # Segurança
    StrictHostKeyChecking accept-new

    # Port Forwarding (descomente se necessário)
    # LocalForward 8080 localhost:8080
    # RemoteForward 9090 localhost:9090

# Alias alternativo
Host vps-ovh
    HostName 147.79.81.59
    User root
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes

# ============================================================
# GITHUB - REPOSITÓRIOS
# ============================================================

Host github.com
    HostName github.com
    User git
    Port 22

    # Autenticação
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes

    # Segurança
    StrictHostKeyChecking yes
    UserKnownHostsFile ~/.ssh/known_hosts_github

    # Performance
    Compression yes

# GitHub Enterprise (se aplicável)
# Host github-enterprise
#     HostName github.empresa.com
#     User git
#     IdentityFile ~/.ssh/id_ed25519_universal
#     IdentitiesOnly yes

# ============================================================
# HUGGING FACE - MODELOS E DATASETS
# ============================================================

Host hf.co
    HostName hf.co
    User git
    Port 22

    # Autenticação
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes

    # Segurança
    StrictHostKeyChecking yes

# ============================================================
# MACOS LOCAL - LOOPBACK
# ============================================================

Host macos-local
    HostName localhost
    User luiz.sena88
    Port 22

    # Autenticação
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes

    # Segurança local
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

# ============================================================
# MACOS VIA REVERSE TUNNEL
# ============================================================

Host macos-rt
    HostName local-macos
    User luiz.sena88
    Port 22

    # Autenticação
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes

    # ProxyJump (se necessário)
    # ProxyJump vps

# ============================================================
# SERVIÇOS ADICIONAIS (OPCIONAL)
# ============================================================

# GitLab (se usar)
# Host gitlab.com
#     HostName gitlab.com
#     User git
#     IdentityFile ~/.ssh/id_ed25519_universal
#     IdentitiesOnly yes

# Bitbucket (se usar)
# Host bitbucket.org
#     HostName bitbucket.org
#     User git
#     IdentityFile ~/.ssh/id_ed25519_universal
#     IdentitiesOnly yes

# AWS EC2 (se usar)
# Host *.compute.amazonaws.com
#     User ec2-user
#     IdentityFile ~/.ssh/id_ed25519_universal
#     IdentitiesOnly yes
#     StrictHostKeyChecking accept-new

# DigitalOcean (se usar)
# Host *.digitalocean.com
#     User root
#     IdentityFile ~/.ssh/id_ed25519_universal
#     IdentitiesOnly yes

# ============================================================
# CONFIGURAÇÕES DE DESENVOLVIMENTO
# ============================================================

# Docker via SSH (se usar)
# Host docker-remote
#     HostName seu-docker-host
#     User root
#     IdentityFile ~/.ssh/id_ed25519_universal
#     LocalForward 2376 localhost:2376

# Kubernetes (se usar)
# Host k8s-master
#     HostName seu-k8s-master
#     User root
#     IdentityFile ~/.ssh/id_ed25519_universal
#     LocalForward 6443 localhost:6443

# ============================================================
# FIM DA CONFIGURAÇÃO
# ============================================================
```

## Explicação das Configurações

### Configurações Globais (Host *)

- **IdentityAgent**: Usa 1Password como agente SSH
- **AddKeysToAgent**: Adiciona chaves automaticamente ao agente
- **UseKeychain**: Usa keychain do macOS para armazenar senhas
- **StrictHostKeyChecking**: Aceita novas chaves automaticamente
- **Compression**: Habilita compressão para melhor performance
- **ServerAliveInterval**: Mantém conexão viva (60 segundos)
- **TCPKeepAlive**: Mantém conexão TCP ativa

### Otimizações de Conexão

- **ControlMaster**: Reutiliza conexões existentes
- **ControlPath**: Caminho para socket de controle
- **ControlPersist**: Mantém conexão por 10 minutos após último uso
- **ForwardAgent**: Permite usar chaves locais em servidores remotos

### Segurança

- **IdentitiesOnly**: Usa apenas chaves especificadas
- **StrictHostKeyChecking**: Validação de chaves do host
- **UserKnownHostsFile**: Arquivo personalizado para known_hosts

## Comandos Úteis

### Testar Conexões

```bash
# Testar VPS
ssh -T vps

# Testar GitHub
ssh -T git@github.com

# Testar Hugging Face
ssh -T git@hf.co

# Verificar configuração
ssh -F ~/.ssh/config -T vps
```

### Debugging

```bash
# Verbose mode
ssh -v vps

# Muito verbose
ssh -vvv vps

# Testar configuração específica
ssh -F ~/.ssh/config -v vps
```

### Gerenciar Conexões Persistentes

```bash
# Ver conexões ativas
ssh -O check vps

# Fechar conexão
ssh -O exit vps
```

## Manutenção

### Verificar Configuração

```bash
# Validar sintaxe
ssh -F ~/.ssh/config -T vps 2>&1 | head -5

# Listar hosts configurados
grep "^Host " ~/.ssh/config | grep -v "^Host \*"
```

### Backup

```bash
# Fazer backup
cp ~/.ssh/config ~/.ssh/config.backup.$(date +%Y%m%d)

# Restaurar backup
cp ~/.ssh/config.backup.YYYYMMDD ~/.ssh/config
```

## Troubleshooting

### Problemas Comuns

1. **Conexão lenta**: Verificar `Compression yes` e `ControlMaster`
2. **Timeout**: Ajustar `ServerAliveInterval` e `ConnectTimeout`
3. **Chave não encontrada**: Verificar `IdentityFile` e permissões
4. **1Password não funciona**: Verificar caminho do `IdentityAgent`

### Permissões Corretas

```bash
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519_universal
chmod 644 ~/.ssh/id_ed25519_universal.pub
chmod 700 ~/.ssh
```

---

**Versão:** 2.0
**Última atualização:** 2025-11-15

