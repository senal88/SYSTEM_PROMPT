# 🚀 Raycast Automation - Instalação Completa

Automação completa do Raycast com integração 1Password para macOS Silicon e VPS Ubuntu.

## ⚡ Instalação Rápida

```bash
# Clone o repositório
git clone https://github.com/senal88/ls-edia-config.git
cd ls-edia-config/raycast-automation

# Execute a instalação completa
./raycast-manager.sh install

# Ou use comandos específicos
./raycast-manager.sh setup-1password  # Configurar 1Password
./raycast-manager.sh test             # Testar instalação
./raycast-manager.sh status           # Ver status
```

## 📍 **Localização dos Scripts**

```bash
# Diretório principal
~/Dotfiles/raycast-automation/

# Caminho completo
/Users/luiz.sena88/Dotfiles/raycast-automation/

# Navegar para o diretório
cd ~/Dotfiles/raycast-automation/
```

## 🎯 O que é Instalado

### Raycast Core
- ✅ Instalação automática via Homebrew
- ✅ Configuração do atalho ⌘ Space
- ✅ Window Management com 50+ comandos
- ✅ Integração com 1Password

### Scripts de Desenvolvimento
- ✅ **Git Status** - Status do repositório
- ✅ **Docker PS** - Lista containers
- ✅ **1Password Tokens** - Gerenciamento de tokens
- ✅ **Copy Tokens** - Copia tokens para clipboard

### Quicklinks
- ✅ **GitHub Issues** (`ghi`) - Busca no GitHub
- ✅ **Google Translate** (`tr`) - Tradução
- ✅ **Docker Hub** (`dh`) - Busca no Docker Hub

### Snippets
- ✅ **Email Signature** (`sig`) - Assinatura de email
- ✅ **Code Templates** - Templates de código

## 🔧 Configuração

### 1Password CLI
```bash
# Configure o 1Password CLI
op signin

# Teste a conexão
op item list
```

### Permissões Necessárias
1. **Acessibilidade** - Para Window Management
2. **Automação** - Para controle de apps
3. **Full Disk Access** - Para busca avançada

## 📁 Estrutura

```
raycast-automation/
├── raycast-manager.sh      # Gerenciador principal
├── install.sh              # Instalador completo
├── setup-1password.sh      # Configuração 1Password
├── test-installation.sh    # Teste de instalação
├── backup-raycast.sh       # Backup do Raycast
├── restore-raycast.sh      # Restore do Raycast
├── sync-raycast.sh         # Sincronização bidirecional
└── README.md               # Esta documentação
```

## 🔄 Backup e Restore

### Backup Automático
```bash
# Fazer backup completo
~/Dotfiles/raycast-automation/raycast-manager.sh backup

# Backup sem arquivos SQLite (economiza espaço)
~/Dotfiles/raycast-automation/backup-raycast.sh ~/Dotfiles/raycast-profile true
```

### Restore
```bash
# Restaurar backup
~/Dotfiles/raycast-automation/raycast-manager.sh restore

# Restore forçado (sobrescreve atual)
~/Dotfiles/raycast-automation/restore-raycast.sh ~/Dotfiles/raycast-profile --force
```

### Sincronização
```bash
# Sincronização bidirecional
~/Dotfiles/raycast-automation/raycast-manager.sh sync

# Sincronizar apenas para backup
~/Dotfiles/raycast-automation/sync-raycast.sh to-backup

# Sincronizar apenas para Raycast
~/Dotfiles/raycast-automation/sync-raycast.sh to-raycast
```

### 🆕 **Substituição Spotlight**
```bash
# Substituir Spotlight pelo Raycast como principal
~/Dotfiles/raycast-automation/replace-spotlight.sh

# Verificar se a substituição funcionou
~/Dotfiles/raycast-automation/verify-spotlight-replacement.sh
```

## 🚀 Uso

### Comandos Principais
- **⌘ Space** - Abrir Raycast
- **⌘ K** - Action Panel
- **esc** - Voltar

### Scripts Disponíveis
- `git status` - Status do Git
- `docker ps` - Containers Docker
- `test tokens` - Testar 1Password
- `copy github` - Copiar token GitHub

## 🔐 Segurança

- ✅ Tokens armazenados no 1Password
- ✅ Nenhum secret no código
- ✅ Configurações locais apenas
- ✅ Backup automático

## 📚 Documentação

- [Raycast Manual](https://manual.raycast.com)
- [1Password CLI Docs](https://developer.1password.com/docs/cli)
- [Scripts Personalizados](./docs/custom-scripts.md)

## 🆘 Suporte

Se encontrar problemas:

1. Verifique as permissões do sistema
2. Execute `./test-installation.sh`
3. Consulte a documentação
4. Abra uma issue no GitHub

---

**Desenvolvido com ❤️ para produtividade máxima**
