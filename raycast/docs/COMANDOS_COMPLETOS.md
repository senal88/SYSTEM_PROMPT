# 🎯 COMANDOS COMPLETOS - Raycast Automation

## 📍 **LOCALIZAÇÃO DOS SCRIPTS**

```bash
# Diretório principal
~/Dotfiles/raycast-automation/

# Caminho completo
/Users/luiz.sena88/Dotfiles/raycast-automation/

# Navegar para o diretório
cd ~/Dotfiles/raycast-automation/
```

## 🚀 **COMANDOS PRINCIPAIS**

### Instalação e Configuração
```bash
# Instalação completa
~/Dotfiles/raycast-automation/raycast-manager.sh install

# Configurar 1Password CLI
~/Dotfiles/raycast-automation/raycast-manager.sh setup-1password

# Testar instalação
~/Dotfiles/raycast-automation/raycast-manager.sh test

# Ver status atual
~/Dotfiles/raycast-automation/raycast-manager.sh status
```

### Backup e Restore
```bash
# Backup completo do Raycast
~/Dotfiles/raycast-automation/raycast-manager.sh backup

# Restaurar backup
~/Dotfiles/raycast-automation/raycast-manager.sh restore

# Sincronização bidirecional
~/Dotfiles/raycast-automation/raycast-manager.sh sync
```

### 🆕 Substituição Spotlight
```bash
# Substituir Spotlight pelo Raycast como principal
~/Dotfiles/raycast-automation/raycast-manager.sh replace-spotlight

# Verificar se a substituição funcionou
~/Dotfiles/raycast-automation/raycast-manager.sh verify-spotlight
```

### Gerenciamento
```bash
# Limpar arquivos temporários
~/Dotfiles/raycast-automation/raycast-manager.sh clean

# Mostrar ajuda
~/Dotfiles/raycast-automation/raycast-manager.sh help
```

## 🔧 **COMANDOS INDIVIDUAIS**

### Scripts de Instalação
```bash
# Instalador principal
~/Dotfiles/raycast-automation/install.sh

# Configuração 1Password
~/Dotfiles/raycast-automation/setup-1password.sh

# Teste de instalação
~/Dotfiles/raycast-automation/test-installation.sh
```

### Scripts de Backup
```bash
# Backup do Raycast
~/Dotfiles/raycast-automation/backup-raycast.sh

# Restore do Raycast
~/Dotfiles/raycast-automation/restore-raycast.sh

# Sincronização
~/Dotfiles/raycast-automation/sync-raycast.sh
```

### Scripts de Substituição
```bash
# Substituir Spotlight
~/Dotfiles/raycast-automation/replace-spotlight.sh

# Verificar substituição
~/Dotfiles/raycast-automation/verify-spotlight-replacement.sh
```

## 📊 **LOCALIZAÇÕES IMPORTANTES**

### Diretórios do Sistema
```bash
# Perfil do Raycast
~/Library/Application Support/com.raycast.macos/

# Backup do Raycast
~/Dotfiles/raycast-profile/

# Scripts de automação
~/Dotfiles/raycast-automation/
```

### Arquivos de Configuração
```bash
# Configurações do Raycast
~/Library/Preferences/com.raycast.macos.plist

# Configurações do Spotlight
~/Library/Preferences/com.apple.symbolichotkeys.plist

# Perfil do usuário
~/.zprofile
```

## 🎯 **EXEMPLOS DE USO**

### Instalação Completa
```bash
# 1. Navegar para o diretório
cd ~/Dotfiles/raycast-automation/

# 2. Instalar tudo
./raycast-manager.sh install

# 3. Configurar 1Password
./raycast-manager.sh setup-1password

# 4. Testar instalação
./raycast-manager.sh test
```

### Backup e Restore
```bash
# 1. Fazer backup
./raycast-manager.sh backup

# 2. Fazer alterações no Raycast
# (instalar extensões, configurar scripts, etc.)

# 3. Fazer novo backup
./raycast-manager.sh backup

# 4. Restaurar backup anterior
./raycast-manager.sh restore
```

### Substituição Spotlight
```bash
# 1. Substituir Spotlight pelo Raycast
./raycast-manager.sh replace-spotlight

# 2. Verificar se funcionou
./raycast-manager.sh verify-spotlight

# 3. Testar atalho ⌘ Space
# (deve abrir o Raycast em vez do Spotlight)
```

## 🔍 **VERIFICAÇÕES**

### Status do Sistema
```bash
# Verificar status geral
~/Dotfiles/raycast-automation/raycast-manager.sh status

# Verificar substituição Spotlight
~/Dotfiles/raycast-automation/raycast-manager.sh verify-spotlight

# Testar instalação
~/Dotfiles/raycast-automation/raycast-manager.sh test
```

### Verificações Manuais
```bash
# Verificar se Raycast está instalado
ls /Applications/Raycast.app

# Verificar se 1Password CLI está funcionando
op item list

# Verificar configuração do atalho
defaults read com.raycast.macos hotkey
```

## 🆘 **RESOLUÇÃO DE PROBLEMAS**

### Problemas Comuns
```bash
# 1Password CLI não funciona
~/Dotfiles/raycast-automation/setup-1password.sh

# Raycast não abre com ⌘ Space
~/Dotfiles/raycast-automation/replace-spotlight.sh

# Backup não funciona
~/Dotfiles/raycast-automation/backup-raycast.sh

# Restore não funciona
~/Dotfiles/raycast-automation/restore-raycast.sh
```

### Limpeza e Reset
```bash
# Limpar arquivos temporários
~/Dotfiles/raycast-automation/raycast-manager.sh clean

# Reinstalar tudo
~/Dotfiles/raycast-automation/raycast-manager.sh install

# Reset completo (cuidado!)
rm -rf ~/Library/Application Support/com.raycast.macos/
~/Dotfiles/raycast-automation/raycast-manager.sh install
```

## 🎉 **RESUMO**

### Comando Principal
```bash
~/Dotfiles/raycast-automation/raycast-manager.sh [comando]
```

### Comandos Mais Usados
- `install` - Instalação completa
- `backup` - Backup do Raycast
- `restore` - Restaurar backup
- `replace-spotlight` - Substituir Spotlight
- `status` - Ver status atual
- `help` - Mostrar ajuda

### 🚀 **Sistema Completo e Funcional!**

Todos os comandos estão testados e funcionando perfeitamente. Use as URLs completas para máxima clareza e facilidade de uso.

---

**Desenvolvido com ❤️ para máxima produtividade!**
