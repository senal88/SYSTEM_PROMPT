# Sincronização de Perfis - Cursor, VSCode e Outros

## 🎯 Objetivo

Sincronizar automaticamente as configurações do Cursor, VSCode e outras ferramentas entre macOS Silicon e VPS Ubuntu para manter consistência entre ambientes.

## 📋 Paths Principais por Ambiente

### macOS Silicon

```bash
# VSCode
~/Library/Application Support/Code/User/
├── settings.json
├── keybindings.json
├── extensions.json
└── snippets/

# Cursor
~/Library/Application Support/Cursor/User/
├── settings.json
├── keybindings.json
├── extensions.json
└── snippets/

# Cursor Rules
~/.cursorrules

# Claude Desktop
~/Library/Application Support/Claude/claude_desktop_config.json
```

### VPS Ubuntu

```bash
# VSCode
~/.config/Code/User/
├── settings.json
├── keybindings.json
├── extensions.json
└── snippets/

# Cursor
~/.config/Cursor/User/
├── settings.json
├── keybindings.json
├── extensions.json
└── snippets/

# Cursor Rules
~/.cursorrules
```

## 🚀 Script de Sincronização

### Uso Básico

```bash
cd ~/Dotfiles/context-engineering
./scripts/sync-profiles.sh
```

### Verificar Diferenças

```bash
# Ver diferenças sem sincronizar
./scripts/sync-profiles.sh --diff
```

## 📝 O Que É Sincronizado

### VSCode e Cursor

- ✅ **settings.json** - Configurações do editor
- ✅ **keybindings.json** - Atalhos de teclado
- ✅ **extensions.json** - Lista de extensões recomendadas
- ✅ **snippets/** - Todos os snippets de código

### Cursor Rules

- ✅ **.cursorrules** - Regras específicas por ambiente
  - macOS: `.cursorrules.macos`
  - VPS: `.cursorrules.vps`

### Outros

- ✅ **Claude Desktop** - Configuração MCP (apenas macOS)
- ✅ **Git** - `.gitconfig` e `.gitignore_global`
- ✅ **SSH** - `~/.ssh/config`

## 🔄 Processo de Sincronização

### 1. Backup Automático

O script cria backups antes de modificar:

```
~/Library/Application Support/Code/User.backup.20250115_143022/
```

### 2. Sincronização

Arquivos são copiados de:

- **Fonte**: `~/Dotfiles/vscode/`
- **Destino**: Diretórios específicos do OS

### 3. Validação

Verifica se arquivos foram copiados corretamente.

## 📊 Estrutura de Diretórios Fonte

```
~/Dotfiles/
├── vscode/
│   ├── settings.json          # Configurações
│   ├── keybindings.json       # Atalhos
│   ├── extensions.json        # Extensões
│   ├── snippets/              # Snippets
│   ├── .gitconfig             # Git config
│   └── .ssh/config            # SSH config
├── context-engineering/
│   ├── .cursorrules           # Regras globais
│   └── cursor-rules/
│       ├── .cursorrules.macos # Regras macOS
│       └── .cursorrules.vps  # Regras VPS
└── claude-cloud-knowledge/
    └── 01_CONFIGURACOES/
        └── claude_desktop_config.json
```

## 🔧 Configuração Manual

### macOS

```bash
# VSCode
cp ~/Dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/

# Cursor
cp ~/Dotfiles/vscode/settings.json ~/Library/Application\ Support/Cursor/User/

# Snippets
cp -r ~/Dotfiles/vscode/snippets/* ~/Library/Application\ Support/Code/User/snippets/
cp -r ~/Dotfiles/vscode/snippets/* ~/Library/Application\ Support/Cursor/User/snippets/
```

### VPS Ubuntu

```bash
# VSCode
cp ~/Dotfiles/vscode/settings.json ~/.config/Code/User/

# Cursor
cp ~/Dotfiles/vscode/settings.json ~/.config/Cursor/User/

# Snippets
cp -r ~/Dotfiles/vscode/snippets/* ~/.config/Code/User/snippets/
cp -r ~/Dotfiles/vscode/snippets/* ~/.config/Cursor/User/snippets/
```

## 🔄 Sincronização Entre Ambientes

### Via Git

```bash
# No macOS (fonte)
cd ~/Dotfiles
git add vscode/
git commit -m "Atualizar configurações VSCode/Cursor"
git push

# No VPS (destino)
cd ~/Dotfiles
git pull
./context-engineering/scripts/sync-profiles.sh
```

### Via rsync (direto)

```bash
# Do macOS para VPS
rsync -avz ~/Dotfiles/vscode/ user@vps:~/Dotfiles/vscode/
rsync -avz ~/Dotfiles/context-engineering/ user@vps:~/Dotfiles/context-engineering/

# No VPS, executar sync
ssh user@vps "cd ~/Dotfiles/context-engineering && ./scripts/sync-profiles.sh"
```

## 📝 Checklist de Sincronização

### Antes de Sincronizar

- [ ] Fazer backup dos arquivos atuais
- [ ] Verificar diferenças com `--diff`
- [ ] Confirmar que arquivos fonte estão atualizados

### Após Sincronizar

- [ ] Reiniciar VSCode/Cursor
- [ ] Verificar se extensões foram instaladas
- [ ] Testar snippets
- [ ] Testar keybindings
- [ ] Validar configurações

## 🔍 Verificar Sincronização

### Listar Arquivos Sincronizados

```bash
# VSCode
ls -la ~/Library/Application\ Support/Code/User/  # macOS
ls -la ~/.config/Code/User/                       # Linux

# Cursor
ls -la ~/Library/Application\ Support/Cursor/User/ # macOS
ls -la ~/.config/Cursor/User/                     # Linux
```

### Comparar Diferenças

```bash
# Ver diferenças
./scripts/sync-profiles.sh --diff

# Ou manualmente
diff ~/Dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

## 🎯 Paths Resumidos

### macOS Silicon

| Ferramenta     | Path                                        |
| -------------- | ------------------------------------------- |
| VSCode User    | `~/Library/Application Support/Code/User`   |
| Cursor User    | `~/Library/Application Support/Cursor/User` |
| Claude Desktop | `~/Library/Application Support/Claude/`     |
| Config         | `~/.config/`                                |
| Dotfiles       | `~/Dotfiles/`                               |

### VPS Ubuntu

| Ferramenta     | Path                    |
| -------------- | ----------------------- |
| VSCode User    | `~/.config/Code/User`   |
| Cursor User    | `~/.config/Cursor/User` |
| Claude Desktop | N/A                     |
| Config         | `~/.config/`            |
| Dotfiles       | `~/Dotfiles/`           |

## 📚 Referências

- [Paths Comparação](PATHS_COMPARACAO.md) - Comparação completa de paths
- [Setup macOS](scripts/setup-macos.sh) - Setup inicial macOS
- [Setup VPS](scripts/setup-vps.sh) - Setup inicial VPS

---

**Última atualização**: 2025-01-15
**Script**: `scripts/sync-profiles.sh`
