# 🛠️ Guia de Restauração do Terminal

**Last Updated**: 2025-10-31  
**Versão**: 1.0.0

---

## 🎯 Objetivo

Este documento fornece instruções para restaurar a configuração do terminal caso algo dê errado durante execuções de scripts de automação.

---

## 📦 Backups Criados

Os backups são criados automaticamente em:
```
~/.dotfiles_backup_TIMESTAMP/
├── .zshrc.backup
├── .bashrc.backup
└── .bash_profile.backup (se existir)
```

**Timestamp**: `YYYYMMDD_HHMMSS` (ex: `20251031_143734`)

---

## 🔄 Restauração Completa

### Passo 1: Identificar Backup Mais Recente

```bash
ls -lt ~/.dotfiles_backup_*/ | head -5
```

### Passo 2: Restaurar Arquivos

```bash
# Substituir BACKUP_TIMESTAMP pelo identificador real
BACKUP_DIR=~/.dotfiles_backup_BACKUP_TIMESTAMP

# Restaurar .zshrc
cp "${BACKUP_DIR}/.zshrc.backup" ~/.zshrc

# Restaurar .bashrc (se necessário)
cp "${BACKUP_DIR}/.bashrc.backup" ~/.bashrc

# Restaurar .bash_profile (se existir)
[[ -f "${BACKUP_DIR}/.bash_profile.backup" ]] && \
  cp "${BACKUP_DIR}/.bash_profile.backup" ~/.bash_profile
```

### Passo 3: Recarregar Terminal

```bash
# Recarregar configuração
exec zsh

# OU fazer logout/login completo
```

---

## ⚡ Restauração Rápida (Comando Único)

```bash
# Restaurar do backup mais recente
cd ~ && \
BACKUP_DIR=$(ls -td .dotfiles_backup_* | head -1) && \
cp "${BACKUP_DIR}/.zshrc.backup" ~/.zshrc && \
[[ -f "${BACKUP_DIR}/.bashrc.backup" ]] && \
cp "${BACKUP_DIR}/.bashrc.backup" ~/.bashrc && \
exec zsh
```

---

## 🔍 Validação Pós-Restauração

```bash
# 1. Verificar sintaxe
zsh -n ~/.zshrc

# 2. Verificar variáveis essenciais
echo $SHELL
echo $PATH

# 3. Verificar comandos críticos
command -v op
command -v docker
command -v git

# 4. Carregar configuração
source ~/.zshrc
```

---

## 🏥 Terminal Completamente Quebrado

Se o terminal não responder ou apresentar loops infinitos:

### Opção A: Terminal Temporário

```bash
# Abrir nova janela terminal e executar:
SHELL=/bin/bash bash

# Dentro do bash temporário, restaurar zsh:
cp ~/.dotfiles_backup_TIMESTAMP/.zshrc.backup ~/.zshrc
exec zsh
```

### Opção B: Configuração Mínima

Se os backups também estão corrompidos:

```bash
# Criar .zshrc mínimo funcional
cat > ~/.zshrc << 'EOF'
# Configuração mínima Zsh
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/bin:$PATH"
autoload -Uz compinit && compinit
HISTFILE=~/.zsh_history
HISTSIZE=10000
setopt SHARE_HISTORY
EOF

exec zsh
```

---

## 📋 Checklist de Retorno ao Trabalho

Após restaurar, verificar:

- [ ] Terminal funciona corretamente
- [ ] Sintaxe do .zshrc válida
- [ ] PATH contém diretórios essenciais
- [ ] Comandos críticos acessíveis (op, docker, git)
- [ ] Voltar ao diretório de trabalho correto
  ```bash
  cd ~/Dotfiles/automation_1password
  ```
- [ ] Recarregar contexto do Cursor IDE
  ```bash
  open -a "Cursor" .
  ```

---

## 🔗 Referências

- **Logs de execução**: `~/terminal_fix_TIMESTAMP.log`
- **Script original**: `scripts/bootstrap/fix_terminal_config.sh`
- **Backups**: `~/.dotfiles_backup_*/`

---

**Última atualização**: 2025-10-31  
**Versão**: 1.0.0

