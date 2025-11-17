# Context Engineering - Sistema Completo de Engenharia de Contexto

Sistema completo de engenharia de contexto para LLMs em múltiplos ambientes: macOS Silicon, VPS Ubuntu e GitHub Codespaces.

## 🎯 Objetivo

Fornecer contexto rico e estruturado para LLMs através de:
- **Cursor Rules**: Regras específicas por ambiente
- **Snippets**: Atalhos de código para VSCode/Cursor e Raycast
- **Templates**: Modelos para prompts e contexto
- **Scripts**: Automação de setup e configuração

## 📁 Estrutura

```
Dotfiles/
├── context-engineering/
│   ├── .cursorrules                    # Regras globais
│   ├── PREFERENCIAS_PESSOAIS.md        # Preferências pessoais Claude Cloud
│   ├── cursor-rules/
│   │   ├── .cursorrules.macos          # Regras específicas macOS
│   │   ├── .cursorrules.vps            # Regras específicas VPS
│   │   └── .cursorrules.codespace      # Regras específicas Codespace
│   ├── templates/
│   │   ├── llm-context-template.md              # Template de contexto
│   │   ├── prompt-template.md                   # Template de prompt
│   │   ├── claude-cloud-pro-config.xml          # Template XML completo Claude Cloud Pro
│   │   ├── claude-cloud-pro-config-template.xml # Template XML simplificado
│   │   └── CLAUDE_CLOUD_PRO_XML_TEMPLATE_GUIDE.md # Guia do template XML
│   ├── scripts/
│   │   ├── setup-macos.sh              # Setup macOS
│   │   ├── setup-vps.sh                # Setup VPS
│   │   ├── setup-codespace.sh          # Setup Codespace
│   │   └── shell-config.sh             # Config shell comum
│   └── .devcontainer/
│       └── devcontainer.json           # Config Codespace
├── vscode/
│   ├── settings.json                   # Settings VSCode/Cursor
│   ├── extensions.json                 # Extensões recomendadas
│   └── snippets/
│       ├── 1password.code-snippets    # Snippets 1Password
│       ├── python.code-snippets       # Snippets Python
│       └── shell.code-snippets       # Snippets Shell
└── raycast/
    ├── snippets/
    │   ├── 1password.json             # Snippets Raycast 1Password
    │   ├── shell.json                 # Snippets Raycast Shell
    │   └── python.json                # Snippets Raycast Python
    └── shortcuts/
        └── shortcuts.json             # Atalhos Raycast
```

## 🚀 Quick Start

### macOS Silicon

```bash
cd ~/Dotfiles/context-engineering/scripts
./setup-macos.sh
```

### VPS Ubuntu

```bash
cd ~/Dotfiles/context-engineering/scripts
./setup-vps.sh
```

### GitHub Codespaces

O setup é automático via `.devcontainer/devcontainer.json`. Ou manualmente:

```bash
cd ~/Dotfiles/context-engineering/scripts
./setup-codespace.sh
```

## 📝 Cursor Rules

### Global (`.cursorrules`)

Regras aplicadas a todos os ambientes. Define:
- Stack tecnológica
- Convenções de código
- Integração 1Password
- Padrões de arquivos
- Segurança

### Específicas por Ambiente

- **macOS**: `cursor-rules/.cursorrules.macos`
- **VPS**: `cursor-rules/.cursorrules.vps`
- **Codespace**: `cursor-rules/.cursorrules.codespace`

## 💻 Snippets

### VSCode/Cursor

#### 1Password (`1p-*`)
- `1p-get`: Obter item do 1Password
- `1p-field`: Obter campo específico
- `1p-pass`: Obter senha
- `1p-signin`: Login no 1Password
- `1p-vaults`: Listar vaults
- `1p-check`: Verificar configuração
- `1p-vault-macos`: ID vault macOS
- `1p-vault-vps`: ID vault VPS

#### Python (`py-*`)
- `py-template`: Template completo de script
- `py-func`: Função com docstring
- `py-class`: Classe Python
- `py-main`: Guard para execução
- `py-typing`: Imports de type hints
- `py-try`: Tratamento de exceções

#### Shell (`sh-*`)
- `sh-template`: Template completo de script
- `sh-func`: Função bash
- `sh-error`: Tratamento de erros
- `sh-colors`: Definição de cores
- `sh-log`: Funções de logging
- `sh-check-cmd`: Verificar comando
- `sh-1p-unset`: Desativar Connect

### Raycast

Snippets configuráveis via UI do Raycast. Arquivos de referência em `raycast/snippets/`.

**Como configurar:**
1. Abra Raycast
2. Vá em Settings → Extensions → Snippets
3. Importe ou crie snippets baseados nos arquivos JSON

## 🎨 Templates

### LLM Context Template

Use `templates/llm-context-template.md` para estruturar contexto para LLMs:

```markdown
## Contexto do Ambiente
Ambiente: macOS Silicon
Sistema: macOS darwin
Shell: zsh

## Contexto do Projeto
Nome: Meu Projeto
Stack: Python 3.11+, Docker

## Objetivo
[Descreva o objetivo]
```

### Prompt Template

Use `templates/prompt-template.md` para criar prompts eficazes:

1. Contexto Inicial
2. Tarefa Específica
3. Informações de Entrada
4. Restrições e Requisitos
5. Formato de Saída Esperado
6. Exemplos

## ⚙️ Configurações

### VSCode/Cursor Settings

Arquivo: `vscode/settings.json`

Inclui:
- Formatação automática (Black, Prettier)
- Linting (Flake8, ShellCheck)
- Snippets priorizados
- Configurações por linguagem
- Integração 1Password

### Extensões Recomendadas

Arquivo: `vscode/extensions.json`

Extensões principais:
- 1Password (op-vscode)
- Python (ms-python.python)
- Docker (ms-azuretools.vscode-docker)
- GitLens (eamodio.gitlens)
- ShellCheck (timonwong.shellcheck)

## 🎯 Raycast

### Snippets

Arquivos JSON em `raycast/snippets/`:
- `1password.json`: Snippets 1Password
- `shell.json`: Snippets Shell
- `python.json`: Snippets Python

### Shortcuts

Arquivo: `raycast/shortcuts/shortcuts.json`

Atalhos sugeridos:
- `⌘+⇧+P`: 1Password - Get Password
- `⌘+⇧+G`: 1Password - Generate Password
- `⌘+⇧+T`: Terminal - New Window
- `⌘+⇧+V`: VSCode - Open Folder
- `⌘+⇧+C`: 1Password - Check Config

## 🔧 Scripts de Setup

### setup-macos.sh

Configura:
- Snippets VSCode/Cursor
- Settings VSCode/Cursor
- .cursorrules
- Raycast (referência)

### setup-vps.sh

Configura:
- .cursorrules
- 1Password
- VSCode Remote
- Shell config

### setup-codespace.sh

Configura:
- .cursorrules
- VSCode settings/snippets
- 1Password (se disponível)

### auto-config-claude-cloud.py

**Script automatizado para Claude Cloud Pro:**

- ✅ Verifica MCP conectado
- ✅ Revisa todos os arquivos de contexto
- ✅ Atualiza configuração XML automaticamente
- ✅ Gera prompt para Claude Cloud
- ✅ Cria relatório de arquivos para upload

**Uso:**
```bash
cd ~/Dotfiles/context-engineering
python3 scripts/auto-config-claude-cloud.py
```

**Arquivos gerados:**
- `templates/prompt-claude-cloud.md` - Prompt completo para upload
- `RELATORIO_AUTOMATIZADO.md` - Relatório de revisão
- `templates/claude-cloud-pro-config.xml` - XML atualizado (se sucesso)

### claude-code-setup.sh

**Setup do Claude Code com 1Password:**

- ✅ Instala Claude Code (requer Node.js 18+)
- ✅ Configura `ANTHROPIC_API_KEY` do 1Password
- ✅ Adiciona configuração automática ao shell
- ✅ Verifica instalação com `claude doctor`

**Uso:**
```bash
cd ~/Dotfiles/context-engineering
./scripts/claude-code-setup.sh
```

**Pré-requisitos:**
- `ANTHROPIC_API_KEY` deve estar nos vaults 1p_macos ou 1p_vps
- 1Password CLI instalado e autenticado

**Documentação completa:** Ver `CLAUDE_CODE_SETUP.md`

**Guia de Login:** Ver `CLAUDE_CODE_LOGIN.md` para instruções de autenticação

**Yolo Mode:** Ver `CLAUDE_CODE_YOLO_MODE.md` para informações sobre segurança

### claude-code-login.sh

**Login rápido no Claude Code:**

- 🔑 Obtém `ANTHROPIC_API_KEY` do 1Password automaticamente
- ✅ Configura variável de ambiente
- 🔍 Verifica autenticação

**Uso:**
```bash
cd ~/Dotfiles/context-engineering
./scripts/claude-code-login.sh
claude
```

### add-mcp-server.sh

**Adicionar servidor MCP HTTP ao Claude Desktop:**

- ✅ Adiciona servidor MCP HTTP à configuração
- 🔐 Suporta headers de autenticação (Bearer token, API Key)
- 📝 Usa jq ou Python para atualizar JSON
- 💾 Faz backup antes de modificar

**Uso:**
```bash
cd ~/Dotfiles/context-engineering
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer token" "api-key"
```

**Documentação:** Ver `MCP_HTTP_SERVER_CONFIG.md`

### sync-profiles.sh

**Sincronizar perfis entre ambientes:**

- ✅ Sincroniza VSCode e Cursor (settings, snippets, keybindings)
- ✅ Sincroniza Cursor Rules específicas por ambiente
- ✅ Sincroniza Git e SSH config
- ✅ Faz backup automático antes de modificar
- ✅ Detecta diferenças com `--diff`

**Uso:**
```bash
cd ~/Dotfiles/context-engineering
./scripts/sync-profiles.sh              # Sincronizar tudo
./scripts/sync-profiles.sh --diff       # Ver diferenças
```

**Documentação:** Ver `SINCRONIZACAO_PERFIS.md` e `PATHS_COMPARACAO.md`

## 📚 Uso

### 1. Usar Snippets

No VSCode/Cursor:
1. Digite o prefixo do snippet (ex: `1p-get`)
2. Pressione Tab ou Enter
3. Preencha os placeholders

### 2. Usar Cursor Rules

O arquivo `.cursorrules` é lido automaticamente pelo Cursor. Para ambiente específico:
- macOS: Copiar `cursor-rules/.cursorrules.macos` para `~/.cursorrules`
- VPS: Copiar `cursor-rules/.cursorrules.vps` para `~/.cursorrules`
- Codespace: Copiar `cursor-rules/.cursorrules.codespace` para `~/.cursorrules`

### 3. Usar Templates

#### Templates Markdown
1. Copie o template relevante (`llm-context-template.md` ou `prompt-template.md`)
2. Preencha com seu contexto
3. Use como prompt para LLM

#### Template XML Claude Cloud Pro
1. Copie `claude-cloud-pro-config-template.xml` (versão simplificada)
2. Ou use `claude-cloud-pro-config.xml` (versão completa pré-preenchida)
3. Preencha com suas informações pessoais
4. Consulte `CLAUDE_CLOUD_PRO_XML_TEMPLATE_GUIDE.md` para documentação completa
5. Faça upload no Claude Cloud Pro Knowledge base

## 🔄 Manutenção

### Atualizar Snippets

1. Edite arquivos em `vscode/snippets/` ou `raycast/snippets/`
2. Execute script de setup correspondente
3. Recarregue VSCode/Cursor

### Atualizar Cursor Rules

1. Edite `.cursorrules` ou arquivos específicos
2. Copie para local apropriado
3. Recarregue Cursor

### Adicionar Novo Snippet

1. Adicione ao arquivo `.code-snippets` apropriado
2. Execute setup script
3. Teste no editor

## 🐛 Troubleshooting

### Snippets não aparecem

1. Verifique se arquivos estão em local correto
2. Execute script de setup novamente
3. Recarregue VSCode/Cursor completamente

### Cursor Rules não aplicadas

1. Verifique se `.cursorrules` está no diretório raiz do projeto
2. Ou em `~/.cursorrules` para global
3. Recarregue Cursor

### Raycast snippets não funcionam

1. Configure manualmente via UI do Raycast
2. Use arquivos JSON como referência
3. Verifique permissões de arquivos

## 📖 Referências

- [Cursor Rules Documentation](https://docs.cursor.com)
- [VSCode Snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets)
- [Raycast Snippets](https://www.raycast.com/docs/snippets)

## 🔐 Segurança

- Não commitar secrets em snippets
- Usar 1Password para todos os secrets
- Validar snippets antes de usar em produção

---

**Status:** ✅ Completo
**Última atualização:** 2025-11-04

