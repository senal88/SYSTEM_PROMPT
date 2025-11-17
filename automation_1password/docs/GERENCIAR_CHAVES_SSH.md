# Gerenciamento de Chaves SSH - Hostinger

**Data:** 2025-11-17
**VPS:** senamfo.com.br (147.79.81.59)

---

## 🔑 Chaves SSH Cadastradas

### Chave Atual
- **Nome:** id_ed25519_universal.pub
- **Tipo:** ED25519
- **Adicionada em:** 2025-08-20
- **Status:** ✅ Ativa

---

## 📋 Informações sobre Chaves SSH

### Tipos de Chave SSH

#### ED25519 (Recomendado)
- **Vantagens:**
  - Mais seguro que RSA
  - Chaves menores
  - Mais rápido
  - Suportado por padrão no OpenSSH 6.5+

#### RSA
- **Vantagens:**
  - Amplamente suportado
  - Compatível com sistemas antigos
- **Desvantagens:**
  - Chaves maiores
  - Mais lento que ED25519

---

## 🔧 Gerenciar Chaves SSH

### Ver Chaves Locais

```bash
# Listar chaves públicas
ls -la ~/.ssh/*.pub

# Ver conteúdo de uma chave
cat ~/.ssh/id_ed25519_universal.pub
```

### Gerar Nova Chave SSH

```bash
# Gerar chave ED25519 (recomendado)
ssh-keygen -t ed25519 -C "seu-email@exemplo.com" -f ~/.ssh/id_ed25519_nova

# Ou gerar chave RSA (se necessário)
ssh-keygen -t rsa -b 4096 -C "seu-email@exemplo.com" -f ~/.ssh/id_rsa_nova
```

### Adicionar Chave ao Hostinger

1. **Copiar chave pública:**
   ```bash
   cat ~/.ssh/id_ed25519_nova.pub | pbcopy  # macOS
   # ou
   cat ~/.ssh/id_ed25519_nova.pub | xclip -selection clipboard  # Linux
   ```

2. **No painel Hostinger:**
   - VPS → senamfo.com.br → Chave SSH
   - Clicar em "Adicionar chave SSH"
   - Colar a chave pública
   - Dar um nome descritivo
   - Salvar

### Remover Chave SSH

1. **No painel Hostinger:**
   - VPS → senamfo.com.br → Chave SSH
   - Encontrar a chave a remover
   - Clicar em "Remover"

2. **Verificar se chave ainda está em uso:**
   ```bash
   # Tentar conectar sem a chave removida
   ssh -i ~/.ssh/outra_chave root@147.79.81.59
   ```

---

## 🔐 Boas Práticas

### 1. Usar Chaves Diferentes por Ambiente
- **Desenvolvimento:** id_ed25519_dev
- **Produção:** id_ed25519_prod
- **Universal:** id_ed25519_universal (atual)

### 2. Proteger Chaves Privadas
```bash
# Permissões corretas
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519*
chmod 644 ~/.ssh/*.pub
```

### 3. Usar Passphrase
```bash
# Gerar chave com passphrase
ssh-keygen -t ed25519 -C "email@exemplo.com" -f ~/.ssh/id_ed25519_segura
# Será solicitada uma passphrase
```

### 4. Backup de Chaves
```bash
# Fazer backup das chaves (criptografado)
tar -czf ~/backup-ssh-keys-$(date +%Y%m%d).tar.gz ~/.ssh/
# Armazenar em local seguro (1Password, etc.)
```

---

## 🧪 Testar Conexão SSH

### Testar com Chave Específica

```bash
# Testar conexão
ssh -i ~/.ssh/id_ed25519_universal -v root@147.79.81.59

# Testar sem interação (apenas verificar)
ssh -i ~/.ssh/id_ed25519_universal -o BatchMode=yes -o ConnectTimeout=5 root@147.79.81.59 echo "OK"
```

### Verificar Chaves Autorizadas na VPS

```bash
# Conectar na VPS
ssh root@147.79.81.59

# Ver chaves autorizadas
cat ~/.ssh/authorized_keys

# Verificar permissões
ls -la ~/.ssh/
```

---

## 📝 Configuração SSH Client (~/.ssh/config)

```bash
# Adicionar ao ~/.ssh/config
Host vps-senamfo
    HostName 147.79.81.59
    User root
    IdentityFile ~/.ssh/id_ed25519_universal
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Usar: ssh vps-senamfo
```

---

## 🔗 Referências

- [Painel Hostinger - Chaves SSH](https://hpanel.hostinger.com/)
- [Documentação OpenSSH](https://www.openssh.com/)
- [Guia SSH Keys](https://www.ssh.com/academy/ssh/key)

---

**Última atualização:** 2025-11-17

