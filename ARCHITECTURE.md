# Arquitetura Dotfiles - Estrutura Completa

**Data:** 2025-11-06
**Versão:** 1.0.0
**Status:** Documentação da Estrutura Atual

---

## Visão Geral

Este documento descreve a arquitetura completa do repositório Dotfiles, incluindo estrutura hierárquica, dependências e organização.

---

## Estrutura Hierárquica

### Nível 0 (Raiz)
```
~/Dotfiles/
```

### Nível 1 (Diretórios Principais - 35 diretórios)

#### Configurações e Sistema
- `.config/` - Configurações centralizadas (XDG)
- `.git/` - Repositório Git
- `.local/` - Binários e dados locais

#### Aplicações e Ferramentas
- `Claude/` - Configurações Claude Desktop
- `cursor/` - Cursor IDE (50M, 2535 arquivos)
- `codex/` - Codex CLI (113M, 1198 arquivos)
- `gemini/` - Gemini CLI (414M, 23651 arquivos)
- `raycast/` - Raycast (192M, 1301 arquivos)
- `raycast-automation/` - Automação Raycast
- `raycast-profile/` - Perfil Raycast (36M)
- `vscode/` - VSCode settings

#### Sistemas Globais
- `context-engineering/` - Sistema global de engenharia de contexto (456K, 61 arquivos)
- `claude-cloud-knowledge/` - Knowledge base Claude Cloud Pro (332K, 38 arquivos)
- `automation_1password/` - Automação 1Password (20M, 696 arquivos)

#### Módulos e Scripts
- `modules/` - Módulos modulares (24K, 6 arquivos)
- `scripts/` - Scripts globais (16K, 2 arquivos)
- `zsh/` - Configurações Zsh (24K, 4 arquivos)

#### Configurações Compartilhadas
- `configs/` - Configurações compartilhadas (16K, 4 arquivos)
- `templates/` - Templates (24K, 4 arquivos)

#### Outros
- `atlas-cli/` - Atlas CLI (72K)
- `clis/` - CLIs (vazio)
- `credentials/` - Credenciais (44K)
- `docs/` - Documentação (8K)
- `dotfiles_automation_scripts/` - Scripts de automação
- `env/` - Variáveis de ambiente (vazio)
- `gemini-cli/` - Gemini CLI (vazio)
- `huggingface/` - Hugging Face (1.3M)
- `mcp/` - MCP (vazio)
- `notebooklm_accounting/` - NotebookLM Accounting (436K)
- `tmux/` - Tmux (4K)

---

## Arquivos Críticos

### .cursorrules
- **Global:** `context-engineering/.cursorrules` (177 linhas)
- **Específicos:** `context-engineering/cursor-rules/.cursorrules.{macos,vps,codespace}`
- **Projetos:** `automation_1password/.cursorrules` (293 linhas)
- **Referência:** `cursor/awesome-cursorrules/` (150+ arquivos, não ativo)

### Configurações Principais
- `configs/cursor_config.json`
- `configs/codex_config.json`
- `configs/gemini_config.json`
- `configs/raycast.env`

### Scripts Principais
- `install.sh` - Instalação principal
- `raycast-setup.sh` - Setup Raycast
- `Makefile` - Automação

---

## Dependências

### Shell
- `~/.zshrc` referencia `$DOTFILES_HOME/zsh/*`
- `~/.zprofile` referencia Homebrew

### Cursor IDE
- `~/Library/Application Support/Cursor/User/settings.json`
- Referências: `remote.SSH.defaultExtensions`, `dev.containers.defaultExtensions`, `claudeCodeChat`

### Claude Desktop
- `~/Library/Application Support/Claude/claude_desktop_config.json`
- `~/Library/Application Support/Claude/Claude Extensions Settings/`

### Git
- `~/.gitconfig` (referenciado)
- `~/.gitignore_global` (referenciado)

---

## Variáveis de Ambiente

### Definidas
- `DOTFILES_HOME="$HOME/Dotfiles"` (definido em ~/.zshrc)

### Propostas
- `DOTFILES_CONFIG="$DOTFILES_HOME/.config"`
- `DOTFILES_APPS="$DOTFILES_HOME/apps"`

---

## Configurações Externas

### Que Devem Ser Centralizadas
1. **Cursor:** `~/Library/Application Support/Cursor/User/settings.json`
2. **Claude:** `~/Library/Application Support/Claude/claude_desktop_config.json`
3. **Git:** `~/.gitconfig`, `~/.gitignore_global`
4. **Shell:** `~/.zshrc` (manter, atualizar referências)

### Que Devem Permanecer Locais
1. **1Password:** `~/.config/op/` (não mover)
2. **Homebrew:** `~/.zprofile` (manter como está)

---

## Configurações em ~/Projetos

### Para Mover para Dotfiles
1. **.cursorrules principais** (fora de node_modules) - Consolidar
2. **settings.json relevantes** - Mover para `.config/apps/`
3. **Diretórios config/** - Revisar e mover relevantes

### Para Manter em Projetos
1. **.cursorrules específicos de projeto** - Manter local
2. **settings.json específicos de projeto** - Manter local
3. **config/ dentro de projetos** - Manter local

---

## Estrutura Proposta (Futuro)

```
~/Dotfiles/
├── .config/                    # Configurações centralizadas (XDG)
│   ├── apps/                   # Configs de aplicações
│   │   ├── cursor/            # Cursor settings
│   │   ├── claude/            # Claude Desktop configs
│   │   └── vscode/            # VSCode settings
│   ├── shell/                 # Shell configs
│   ├── git/                   # Git configs
│   └── op/                    # 1Password configs (symlink)
├── apps/                       # Aplicações e ferramentas
│   ├── cursor/                # Cursor-related
│   ├── claude/                # Claude-related
│   ├── codex/                 # Codex
│   ├── gemini/                # Gemini
│   └── raycast/               # Raycast
├── context-engineering/        # Sistema global
├── claude-cloud-knowledge/     # Knowledge base
├── automation_1password/      # Automação 1Password
├── modules/                    # Módulos modulares
└── scripts/                    # Scripts globais
```

---

## Padronização de Paths

### Variáveis de Ambiente
- `DOTFILES_HOME="$HOME/Dotfiles"` (já existe)
- `DOTFILES_CONFIG="$DOTFILES_HOME/.config"` (proposta)
- `DOTFILES_APPS="$DOTFILES_HOME/apps"` (proposta)

### Uso em Scripts
Todos os scripts devem usar variáveis de ambiente ao invés de paths hardcoded.

---

## Padronização de .cursorrules

### Estrutura
- **Global:** `context-engineering/.cursorrules` (master)
- **Específicos:** `context-engineering/cursor-rules/.cursorrules.{macos,vps,codespace}`
- **Projetos:** Manter local quando específico do projeto
- **Referência:** `cursor/awesome-cursorrules/` (não ativo, apenas referência)

---

## Manutenção

### Scripts de Automação
- `DIAGNOSTICO_COMPLETO_DOTFILES.sh` - Diagnóstico completo
- `BACKUP_COMPLETO_REORGANIZACAO.sh` - Backup completo
- `VALIDAR_FUNCIONALIDADE_ATUAL.sh` - Validação
- `ROLLBACK_REORGANIZACAO.sh` - Rollback

### Documentação
- `ARCHITECTURE.md` - Este arquivo
- `README.md` - Documentação principal
- Relatórios em `00_DOCUMENTACAO_POLITICAS/`

---

**Última atualização:** 2025-11-06
**Versão:** 1.0.0

