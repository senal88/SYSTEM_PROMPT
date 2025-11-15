# Troubleshooting SSH - VPS

Guia para resolver problemas comuns de SSH no VPS.

## Problema: "er: command not found" ao conectar via SSH

### Sintoma

Ao conectar via SSH, aparece o erro:
```
/root/.profile: line 1: er: command not found
```

### Causa

O arquivo `/root/.profile` tinha "er" na primeira linha, provavelmente resultado de uma edição acidental ou problema de encoding.

### Solução

O arquivo foi corrigido automaticamente. O script `fix_ssh_vps.sh` detecta e corrige este problema.

### Verificação Manual

```bash
# Verificar primeira linha do .profile
head -1 /root/.profile

# Se mostrar "er", corrigir:
cp /root/.profile /root/.profile.backup
# Remover primeira linha ou recriar arquivo
```

## Script de Correção Automática

Execute o script de correção:

```bash
/root/SYSTEM_PROMPT/scripts/shared/fix_ssh_vps.sh
```

Este script:
1. ✅ Verifica e corrige `/root/.profile`
2. ✅ Verifica e cria `/root/.bashrc` se necessário
3. ✅ Corrige permissões SSH
4. ✅ Verifica configuração do servidor SSH
5. ✅ Testa sintaxe dos arquivos

## Testes de Conexão

### Do macOS para VPS

```bash
# Testar conexão básica
ssh vps

# Testar com verbose (debug)
ssh -v vps

# Testar GitHub
ssh -T git@github.com

# Testar Hugging Face
ssh -T git@hf.co
```

### Verificar Configuração SSH no Mac

```bash
# Verificar config
cat ~/.ssh/config

# Testar configuração específica
ssh -F ~/.ssh/config -T vps
```

## Problemas Comuns

### 1. Conexão Recusada

**Sintoma:** `Connection refused`

**Soluções:**
```bash
# Verificar se SSH está rodando
systemctl status sshd

# Reiniciar SSH
systemctl restart sshd

# Verificar firewall
ufw status
```

### 2. Autenticação Falha

**Sintoma:** `Permission denied`

**Soluções:**
```bash
# Verificar chave pública no VPS
cat ~/.ssh/authorized_keys

# Verificar permissões
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Verificar chave privada no Mac
ls -la ~/.ssh/id_ed25519_universal
```

### 3. Host Key Verification Failed

**Sintoma:** `Host key verification failed`

**Solução:**
```bash
# Remover entrada antiga
ssh-keygen -R 147.79.81.59

# Ou editar known_hosts manualmente
nano ~/.ssh/known_hosts
```

### 4. Timeout na Conexão

**Sintoma:** `Connection timed out`

**Soluções:**
```bash
# Verificar conectividade
ping 147.79.81.59

# Verificar porta SSH
telnet 147.79.81.59 22

# Verificar firewall no VPS
ufw allow 22/tcp
```

## Configuração SSH Otimizada

### No Mac (~/.ssh/config)

```ssh-config
Host vps
    HostName 147.79.81.59
    User root
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes
    ForwardAgent yes
    ControlMaster auto
    ControlPath ~/.ssh/control-%h-%p-%r
    ControlPersist 10m
    Compression yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

### No VPS (/etc/ssh/sshd_config)

Configurações recomendadas:
```
PermitRootLogin yes
PubkeyAuthentication yes
PasswordAuthentication no
AuthorizedKeysFile .ssh/authorized_keys
```

## Manutenção Preventiva

### Executar Regularmente

```bash
# Verificar permissões
/root/SYSTEM_PROMPT/scripts/shared/fix_ssh_vps.sh

# Verificar logs SSH
tail -f /var/log/auth.log

# Verificar conexões ativas
ss -tn | grep :22
```

### Backup de Configurações

```bash
# Fazer backup do .profile
cp /root/.profile /root/.profile.backup.$(date +%Y%m%d)

# Fazer backup do .bashrc
cp /root/.bashrc /root/.bashrc.backup.$(date +%Y%m%d)
```

## Logs e Debugging

### Logs SSH no VPS

```bash
# Logs de autenticação
tail -f /var/log/auth.log

# Logs SSH detalhados
journalctl -u sshd -f
```

### Debugging no Mac

```bash
# Verbose mode
ssh -vvv vps

# Testar configuração específica
ssh -F ~/.ssh/config -v vps
```

## Referências

- [Documentação SSH Config macOS](SSH_CONFIG_MACOS.md)
- [Script de Correção](../scripts/shared/fix_ssh_vps.sh)

---

**Versão:** 1.0  
**Última atualização:** 2025-11-15

