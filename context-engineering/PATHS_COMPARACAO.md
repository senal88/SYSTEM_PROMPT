# Principais Paths - macOS Silicon e VPS Ubuntu

## 📋 Visão Geral

Este documento mapeia todos os principais paths de configuração dos editores e ferramentas entre macOS Silicon e VPS Ubuntu para sincronização automática.

---

## 🖥️ macOS SILICON (Apple Silicon)

### Paths Principais do Sistema

```bash
HOME_DIR="/Users/luiz.sena88"
DOTFILES_DIR="$HOME_DIR/Dotfiles"
CONFIG_DIR="$HOME_DIR/.config"

# Paths importantes
BREW_PATH="/opt/homebrew"
PYTHON_PATH="/opt/homebrew/bin/python3"
NODE_PATH="$(nvm which current)"  # Via NVM
```

### VSCode / Cursor

```bash
# VSCode
VSCODE_USER_DIR="$HOME_DIR/Library/Application Support/Code/User"
VSCODE_SETTINGS="$VSCODE_USER_DIR/settings.json"
VSCODE_SNIPPETS="$VSCODE_USER_DIR/snippets"
VSCODE_KEYBINDINGS="$VSCODE_USER_DIR/keybindings.json"
VSCODE_EXTENSIONS="$VSCODE_USER_DIR/extensions.json"

# Cursor
CURSOR_USER_DIR="$HOME_DIR/Library/Application Support/Cursor/User"
CURSOR_SETTINGS="$CURSOR_USER_DIR/settings.json"
CURSOR_SNIPPETS="$CURSOR_USER_DIR/snippets"
CURSOR_KEYBINDINGS="$CURSOR_USER_DIR/keybindings.json"
CURSOR_EXTENSIONS="$CURSOR_USER_DIR/extensions.json"

# Cursor Rules
CURSOR_RULES_GLOBAL="$HOME_DIR/.cursorrules"
CURSOR_RULES_PROJECT="$PROJECT_DIR/.cursorrules"

# Configuração Claude Desktop
CLAUDE_DESKTOP_CONFIG="$HOME_DIR/Library/Application Support/Claude/claude_desktop_config.json"
```

### 1Password

```bash
OP_CONFIG_DIR="$CONFIG_DIR/op"
OP_CONFIG_SH="$OP_CONFIG_DIR/op_config.sh"
OP_VAULT_CONFIG="$OP_CONFIG_DIR/vault_config.json"
OP_VAULT_DATA="$OP_CONFIG_DIR/vault_data"
```

### Shell (Zsh)

```bash
ZSHRC="$HOME_DIR/.zshrc"
ZPROFILE="$HOME_DIR/.zprofile"
ZSH_HISTORY="$HOME_DIR/.zsh_history"
ZSH_COMPLETIONS="$CONFIG_DIR/zsh/completions"
ZSH_FUNCTIONS="$CONFIG_DIR/zsh/functions"
```

### Git

```bash
GIT_CONFIG="$HOME_DIR/.gitconfig"
GIT_IGNORE_GLOBAL="$HOME_DIR/.gitignore_global"
SSH_DIR="$HOME_DIR/.ssh"
SSH_CONFIG="$SSH_DIR/config"
SSH_KEYS="$SSH_DIR"
```

### Python / Node / Docker

```bash
# Python (via Pyenv)
PYENV_ROOT="$HOME_DIR/.pyenv"
PYTHON_VENVS="$HOME_DIR/.virtualenvs"

# Node (via NVM)
NVM_DIR="$HOME_DIR/.nvm"
NODE_MODULES_GLOBAL="$(npm config get prefix)/lib/node_modules"

# Docker
DOCKER_CONFIG="$CONFIG_DIR/docker"
DOCKER_COMPOSE_LOCAL="$HOME_DIR/infra/stack-local"
```

### Raycast (macOS apenas)

```bash
RAYCAST_CONFIG="$CONFIG_DIR/raycast"
RAYCAST_SNIPPETS="$HOME_DIR/Dotfiles/raycast/snippets"
```

---

## 🐧 VPS UBUNTU

### Paths Principais do Sistema

```bash
HOME_DIR="/home/luiz.sena88"  # ou /home/[user]
DOTFILES_DIR="$HOME_DIR/Dotfiles"
CONFIG_DIR="$HOME_DIR/.config"

# Paths importantes
BREW_PATH="/home/linuxbrew/.linuxbrew"  # Se usar Homebrew
PYTHON_PATH="/usr/bin/python3"  # ou via pyenv
NODE_PATH="/usr/bin/node"  # ou via nvm
```

### VSCode / Cursor

```bash
# VSCode
VSCODE_USER_DIR="$CONFIG_DIR/Code/User"
VSCODE_SETTINGS="$VSCODE_USER_DIR/settings.json"
VSCODE_SNIPPETS="$VSCODE_USER_DIR/snippets"
VSCODE_KEYBINDINGS="$VSCODE_USER_DIR/keybindings.json"
VSCODE_EXTENSIONS="$VSCODE_USER_DIR/extensions.json"

# Cursor
CURSOR_USER_DIR="$CONFIG_DIR/Cursor/User"
CURSOR_SETTINGS="$CURSOR_USER_DIR/settings.json"
CURSOR_SNIPPETS="$CURSOR_USER_DIR/snippets"
CURSOR_KEYBINDINGS="$CURSOR_USER_DIR/keybindings.json"
CURSOR_EXTENSIONS="$CURSOR_USER_DIR/extensions.json"

# Cursor Rules
CURSOR_RULES_GLOBAL="$HOME_DIR/.cursorrules"
CURSOR_RULES_PROJECT="$PROJECT_DIR/.cursorrules"

# VSCode Remote SSH
VSCODE_REMOTE_SSH="$CONFIG_DIR/Code/User/globalStorage/ms-vscode-remote.remote-ssh"
```

### 1Password

```bash
OP_CONFIG_DIR="$CONFIG_DIR/op"
OP_CONFIG_SH="$OP_CONFIG_DIR/op_config.sh"
OP_VAULT_CONFIG="$OP_CONFIG_DIR/vault_config.json"
OP_VAULT_DATA="$OP_CONFIG_DIR/vault_data"
```

### Shell (Bash/Zsh)

```bash
BASHRC="$HOME_DIR/.bashrc"
BASH_PROFILE="$HOME_DIR/.bash_profile"
ZSHRC="$HOME_DIR/.zshrc"
ZPROFILE="$HOME_DIR/.zprofile"
ZSH_HISTORY="$HOME_DIR/.zsh_history"
```

### Git

```bash
GIT_CONFIG="$HOME_DIR/.gitconfig"
GIT_IGNORE_GLOBAL="$HOME_DIR/.gitignore_global"
SSH_DIR="$HOME_DIR/.ssh"
SSH_CONFIG="$SSH_DIR/config"
SSH_KEYS="$SSH_DIR"
```

### Python / Node / Docker

```bash
# Python (via Pyenv)
PYENV_ROOT="$HOME_DIR/.pyenv"
PYTHON_VENVS="$HOME_DIR/.virtualenvs"

# Node (via NVM)
NVM_DIR="$HOME_DIR/.nvm"
NODE_MODULES_GLOBAL="$(npm config get prefix)/lib/node_modules"

# Docker
DOCKER_CONFIG="$CONFIG_DIR/docker"
DOCKER_COMPOSE_PROD="$HOME_DIR/infra/stack-prod"
```

---

## 📊 Comparação de Paths

### Estrutura Base

| Item | macOS Silicon | VPS Ubuntu |
|------|--------------|------------|
| Home | `/Users/luiz.sena88` | `/home/luiz.sena88` |
| Dotfiles | `~/Dotfiles` | `~/Dotfiles` |
| Config | `~/.config` | `~/.config` |
| Shell Config | `~/.zshrc` | `~/.bashrc` ou `~/.zshrc` |

### VSCode/Cursor

| Item | macOS Silicon | VPS Ubuntu |
|------|--------------|------------|
| VSCode User | `~/Library/Application Support/Code/User` | `~/.config/Code/User` |
| Cursor User | `~/Library/Application Support/Cursor/User` | `~/.config/Cursor/User` |
| Settings | `settings.json` | `settings.json` |
| Snippets | `snippets/` | `snippets/` |
| Keybindings | `keybindings.json` | `keybindings.json` |
| Extensions | `extensions.json` | `extensions.json` |

### Outros

| Item | macOS Silicon | VPS Ubuntu |
|------|--------------|------------|
| Claude Desktop | `~/Library/Application Support/Claude/` | N/A |
| Raycast | `~/.config/raycast` | N/A |
| SSH | `~/.ssh` | `~/.ssh` |
| Git | `~/.gitconfig` | `~/.gitconfig` |

---

## 🔄 Sincronização Automática

### Arquivos a Sincronizar

**VSCode/Cursor:**
- `settings.json`
- `keybindings.json`
- `extensions.json`
- `snippets/` (diretório completo)

**Shell:**
- `.zshrc` ou `.bashrc`
- `.zprofile` ou `.bash_profile`
- Funções customizadas

**Git:**
- `.gitconfig`
- `.gitignore_global`
- `.ssh/config`

**Outros:**
- `.cursorrules` (global)
- Configurações de extensões específicas

---

## 📝 Notas Importantes

### Diferenças Entre Ambientes

1. **macOS usa**: `~/Library/Application Support/`
2. **Linux usa**: `~/.config/`
3. **Shell padrão**: macOS (Zsh), VPS (Bash ou Zsh)
4. **Raycast**: Apenas macOS
5. **Claude Desktop**: Apenas macOS

### Paths Relativos

Para manter compatibilidade, use sempre:
- `$HOME` ao invés de `/Users/...` ou `/home/...`
- `$XDG_CONFIG_HOME` (Linux) ou `~/Library/Application Support/` (macOS)
- Variáveis de ambiente para paths específicos

---

**Última atualização**: 2025-01-15
**Uso**: Referência para sincronização entre ambientes

