# 🔐 GUIA TERMIUS - CONFIGURAÇÃO SSH COMPLETA
## Ambiente: macOS Silicon + VPS Ubuntu + GitHub + Hugging Face

---

## 📊 SITUAÇÃO ATUAL

### VPS Ubuntu (147.79.81.59)
```
✅ Usuários:
   - root (você está aqui agora)
   - admin (usuário de desenvolvimento)

✅ Estrutura:
   /home/admin/.ssh/  → Contém as chaves SSH
   /root/.ssh/        → Vazio (precisa configurar)
```

### Chaves SSH Existentes
Você mencionou ter chaves SSH que funcionam em:
- ✅ macOS Silicon (localhost)
- ✅ VPS Ubuntu
- ✅ GitHub
- ✅ Hugging Face

---

## 🎯 OBJETIVO

Configurar Termius para acessar:
1. **macOS localhost** via SSH
2. **VPS Ubuntu** (root e admin)
3. **GitHub** via SSH
4. **Hugging Face** via SSH

Usando a **MESMA chave SSH** em todos os ambientes.

---

## 🔍 PASSO 1: IDENTIFICAR SUAS CHAVES NO MACOS

### No seu Mac, execute:

```bash
# 1. Listar chaves SSH
ls -la ~/.ssh/

# 2. Você provavelmente tem uma dessas:
ls -la ~/.ssh/id_ed25519*     # Chave moderna (recomendada)
ls -la ~/.ssh/id_rsa*         # Chave RSA tradicional
ls -la ~/.ssh/id_ecdsa*       # Chave ECDSA

# 3. Ver conteúdo da chave PÚBLICA (seguro)
cat ~/.ssh/id_ed25519.pub     # OU
cat ~/.ssh/id_rsa.pub

# 4. Verificar fingerprint
ssh-keygen -lf ~/.ssh/id_ed25519.pub    # OU
ssh-keygen -lf ~/.ssh/id_rsa.pub

# 5. Testar GitHub
ssh -T git@github.com

# 6. Testar Hugging Face
ssh -T git@hf.co
```

### 📝 Anote:
- **Tipo de chave**: ED25519 ou RSA?
- **Fingerprint**: SHA256:xxxxx
- **Localização**: ~/.ssh/id_xxxxx

---

## 🔧 PASSO 2: HABILITAR SSH NO MACOS

```bash
# No macOS Terminal:

# 1. Habilitar Remote Login (SSH)
sudo systemsetup -setremotelogin on

# 2. Verificar status
sudo systemsetup -getremotelogin
# Deve retornar: "Remote Login: On"

# 3. Verificar SSH rodando
sudo launchctl list | grep sshd
# Deve aparecer: com.openssh.sshd

# 4. Obter seu username
whoami
# Anote esse nome (exemplo: sena, senal88, etc)

# 5. Adicionar sua própria chave ao authorized_keys
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
# OU
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# 6. Ajustar permissões
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519   # ou id_rsa
chmod 644 ~/.ssh/id_ed25519.pub

# 7. Testar conexão local
ssh $(whoami)@localhost
# Digite 'yes' se perguntar sobre fingerprint
# Digite 'exit' para sair
```

---

## 🌐 PASSO 3: CONFIGURAR CHAVES NO VPS

### 3A. Configurar para usuário ROOT

```bash
# No VPS (você já está como root):

# 1. Criar diretório SSH (se não existir)
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 2. Copiar sua chave PÚBLICA do macOS
# Opção A: Copiar manualmente
nano ~/.ssh/authorized_keys
# Cole o conteúdo de ~/.ssh/id_ed25519.pub do seu Mac
# Salvar: Ctrl+O, Enter, Ctrl+X

# Opção B: Via SSH (do Mac)
# No macOS, execute:
# ssh-copy-id -i ~/.ssh/id_ed25519.pub root@147.79.81.59

# 3. Ajustar permissões
chmod 600 ~/.ssh/authorized_keys

# 4. Testar do macOS:
# ssh root@147.79.81.59
```

### 3B. Garantir acesso ao usuário ADMIN

```bash
# No VPS como root:

# 1. Verificar SSH do admin
ls -la /home/admin/.ssh/

# 2. Ver authorized_keys do admin
cat /home/admin/.ssh/authorized_keys

# 3. Se necessário, adicionar sua chave
# (cole o conteúdo da sua chave pública do Mac)
nano /home/admin/.ssh/authorized_keys

# 4. Ajustar permissões
chown -R admin:admin /home/admin/.ssh
chmod 700 /home/admin/.ssh
chmod 600 /home/admin/.ssh/authorized_keys

# 5. Testar do macOS:
# ssh admin@147.79.81.59
```

---

## 📱 PASSO 4: CONFIGURAR TERMIUS

### 4A. Importar Chave SSH no Termius

**No macOS:**

1. **Abra o Termius**
2. **Vá em: Keychain** (ícone de chave no menu lateral)
3. **Clique em "+"** → **Import**
4. **Navegue até**: `~/.ssh/`
5. **Selecione sua chave PRIVADA**:
   - `id_ed25519` (SEM .pub) OU
   - `id_rsa` (SEM .pub)
6. **Termius vai pedir senha** (se a chave tiver)
7. **Dê um nome**: "Chave Universal SSH"

### 4B. Configurar Hosts

#### 🖥️ Host 1: macOS Localhost

```
Label: MacOS Dev (Localhost)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Address: 127.0.0.1
Port: 22
Username: <seu-usuario-macos>  # o que você anotou no whoami
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Authentication: Keys
Key: Chave Universal SSH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tags: localhost, macos, dev
```

#### 🌐 Host 2: VPS Ubuntu (ROOT)

```
Label: VPS Ubuntu (ROOT)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Address: 147.79.81.59
Port: 22
Username: root
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Authentication: Keys
Key: Chave Universal SSH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tags: vps, ubuntu, producao, root
```

#### 👨‍💻 Host 3: VPS Ubuntu (ADMIN)

```
Label: VPS Ubuntu (Admin)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Address: 147.79.81.59
Port: 22
Username: admin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Authentication: Keys
Key: Chave Universal SSH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tags: vps, ubuntu, dev, admin
```

#### 🐙 Host 4: GitHub

```
Label: GitHub
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Address: github.com
Port: 22
Username: git
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Authentication: Keys
Key: Chave Universal SSH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tags: github, git, repos
```

#### 🤗 Host 5: Hugging Face

```
Label: Hugging Face
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Address: hf.co
Port: 22
Username: git
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Authentication: Keys
Key: Chave Universal SSH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tags: huggingface, ml, ai
```

---

## 🧪 PASSO 5: TESTAR CONEXÕES

### No Termius:

1. **Localhost**: Duplo-clique em "MacOS Dev (Localhost)"
   - ✅ Deve abrir terminal do seu Mac
   
2. **VPS ROOT**: Duplo-clique em "VPS Ubuntu (ROOT)"
   - ✅ Deve aparecer: `root@senamfo:~#`
   
3. **VPS Admin**: Duplo-clique em "VPS Ubuntu (Admin)"
   - ✅ Deve aparecer: `admin@senamfo:~$`
   
4. **GitHub**: Duplo-clique em "GitHub"
   - ✅ Deve aparecer: "Hi username! You've successfully authenticated..."
   
5. **Hugging Face**: Duplo-clique em "Hugging Face"
   - ✅ Deve aparecer mensagem de autenticação OK

---

## 📝 PASSO 6: CRIAR SSH CONFIG (OPCIONAL)

### No macOS: `~/.ssh/config`

```bash
nano ~/.ssh/config
```

Cole:

```
# MacOS Localhost
Host localhost
    HostName 127.0.0.1
    User <seu-usuario>
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

# VPS Ubuntu - ROOT
Host vps
Host vps-root
    HostName 147.79.81.59
    User root
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

# VPS Ubuntu - ADMIN
Host vps-admin
    HostName 147.79.81.59
    User admin
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

# Hugging Face
Host hf.co
    HostName hf.co
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
```

Salvar: `Ctrl+O`, `Enter`, `Ctrl+X`

**Ajustar permissões**:
```bash
chmod 600 ~/.ssh/config
```

**Testar**:
```bash
ssh localhost        # Conecta no seu Mac
ssh vps             # Conecta no VPS como root
ssh vps-admin       # Conecta no VPS como admin
ssh -T git@github.com
ssh -T git@hf.co
```

---

## 🔐 PASSO 7: BACKUP E SEGURANÇA

### 7A. Backup das Chaves (1Password)

```bash
# No macOS:

# 1. Criar backup
cd ~/.ssh
tar -czf ssh_keys_backup_$(date +%Y%m%d).tar.gz id_* config known_hosts

# 2. Fazer upload para 1Password:
#    - Abra 1Password
#    - Crie item tipo "Document"
#    - Título: "SSH Keys - MacOS Silicon - 2025-12-01"
#    - Anexe: ssh_keys_backup_YYYYMMDD.tar.gz
#    - Adicione nota com fingerprints

# 3. Remover backup local (após confirmar upload)
rm ssh_keys_backup_*.tar.gz
```

### 7B. Documentar Fingerprints

```bash
# No macOS:

# Gerar fingerprints
ssh-keygen -lf ~/.ssh/id_ed25519.pub > ~/ssh_fingerprints.txt
ssh-keygen -E md5 -lf ~/.ssh/id_ed25519.pub >> ~/ssh_fingerprints.txt

# Ver conteúdo
cat ~/ssh_fingerprints.txt

# Salvar no 1Password como "Secure Note"
```

---

## 🚨 TROUBLESHOOTING

### ❌ Problema: "Permission denied (publickey)"

**No macOS:**
```bash
# 1. Verificar chave carregada
ssh-add -l

# 2. Se vazio, adicionar
ssh-add ~/.ssh/id_ed25519

# 3. Testar com verbose
ssh -vvv git@github.com

# 4. Verificar permissões
ls -la ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/config
```

**No VPS:**
```bash
# Verificar permissões
ls -la ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### ❌ Problema: "Connection refused"

**No macOS:**
```bash
# Verificar SSH rodando
sudo launchctl list | grep sshd

# Reiniciar SSH
sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
```

**No VPS:**
```bash
# Verificar SSH rodando
systemctl status sshd

# Reiniciar se necessário
systemctl restart sshd
```

### ❌ Problema: Termius não conecta

1. **Verificar fingerprint**:
   ```bash
   ssh-keygen -lf ~/.ssh/id_ed25519
   ```
   Comparar com o que aparece no Termius

2. **Reimportar chave no Termius**:
   - Keychain → Deletar chave antiga
   - "+" → Import → Selecionar novamente

3. **Testar via CLI primeiro**:
   ```bash
   ssh -i ~/.ssh/id_ed25519 root@147.79.81.59
   ```

### ❌ Problema: "Too many authentication failures"

**No `~/.ssh/config`:**
```
IdentitiesOnly yes
```

---

## 📋 CHECKLIST FINAL

```markdown
✅ No macOS Silicon:
- [ ] Identifiquei tipo de chave (ED25519 ou RSA)
- [ ] SSH habilitado (Remote Login: On)
- [ ] Chave pública em ~/.ssh/authorized_keys
- [ ] Permissões corretas (700/600/644)
- [ ] Teste localhost OK: ssh $(whoami)@localhost
- [ ] Chave importada no Termius
- [ ] SSH config criado e testado

✅ No VPS Ubuntu:
- [ ] Chave pública em /root/.ssh/authorized_keys
- [ ] Chave pública em /home/admin/.ssh/authorized_keys
- [ ] Permissões corretas ambos usuários
- [ ] Teste root OK: ssh root@147.79.81.59
- [ ] Teste admin OK: ssh admin@147.79.81.59
- [ ] Hosts configurados no Termius (root e admin)

✅ GitHub:
- [ ] Teste OK: ssh -T git@github.com
- [ ] Host configurado no Termius
- [ ] Conexão via Termius OK

✅ Hugging Face:
- [ ] Teste OK: ssh -T git@hf.co
- [ ] Host configurado no Termius
- [ ] Conexão via Termius OK

✅ Segurança:
- [ ] Backup chaves no 1Password
- [ ] Fingerprints documentados
- [ ] Termius E2E encryption ativado
- [ ] SSH config documentado
```

---

## 🎯 PRÓXIMOS PASSOS IMEDIATOS

1. **No seu Mac** (agora):
   ```bash
   ls -la ~/.ssh/
   cat ~/.ssh/id_ed25519.pub  # OU id_rsa.pub
   ```
   
2. **Me envie**:
   - Tipo de chave (ED25519 ou RSA?)
   - Output do comando acima (chave PÚBLICA é segura)
   - Seu username no macOS (output de `whoami`)

3. **Posso então**:
   - Gerar comandos específicos para você
   - Validar configuração
   - Testar conexões

---

## 📚 REFERÊNCIAS

- Documentação SSH: https://www.ssh.com/academy/ssh/config
- Termius Docs: https://termius.com/help
- GitHub SSH: https://docs.github.com/en/authentication
- Hugging Face SSH: https://huggingface.co/docs/hub/security-git-ssh

---

**Última atualização**: 2025-12-01
**Autor**: Claude Code Agent
**Versão**: 1.0.0
