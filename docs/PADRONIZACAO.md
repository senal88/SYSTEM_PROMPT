# 📐 Padronização Global - ~/Dotfiles

**Data**: 2025-01-17  
**Versão**: 2.0.1  
**Status**: ✅ Padronizado

---

## 🎯 Objetivo

Centralizar e padronizar todas as configurações do ambiente de desenvolvimento em `~/Dotfiles`, removendo dependências de diretórios específicos como `~/system_prompt_tahoe_26.0.1` e `~/10_INFRAESTRUTURA_VPS`.

---

## 📁 Estrutura Padronizada

```
~/Dotfiles/
├── configs/
│   ├── cursor/
│   │   ├── settings.json          # Configurações Cursor 2.0
│   │   └── keybindings.json       # Keybindings Cursor
│   ├── vscode/
│   │   └── settings.json          # Configurações VSCode
│   ├── mcp/
│   │   └── servers.json           # MCP Servers
│   ├── raycast/
│   │   └── config.json            # Raycast
│   ├── karabiner/
│   │   └── config.json            # Karabiner-Elements
│   └── extensions/
│       └── recommended.json       # Extensões universais
│
├── scripts/
│   ├── setup/
│   │   ├── master.sh              # Setup master
│   │   ├── ubuntu.sh              # Setup Ubuntu VPS
│   │   └── migrate-to-dotfiles.sh # Script de migração
│   ├── install/
│   │   └── cursor.sh              # Instalar Cursor
│   ├── sync/
│   │   └── configs.sh             # Sincronizar configs
│   └── backup/
│       └── configs.sh             # Backup configs
│
├── templates/
│   ├── devcontainer/
│   │   ├── devcontainer.json      # Template DevContainer
│   │   └── post-create.sh         # Script pós-criação
│   └── github/
│       └── workflows/
│           └── codespace-setup.yml # Setup Codespaces
│
└── docs/
    ├── SYSTEM_PROMPT_GLOBAL.md    # System Prompt
    ├── RESUMO_EXECUCOES.md        # Resumo execuções
    └── PADRONIZACAO.md            # Este documento
```

---

## 🔄 Migração Realizada

### Origem das Configurações

As configurações foram migradas de:

1. **`~/system_prompt_tahoe_26.0.1`**
   - Configurações do Cursor 2.0
   - Configurações do VSCode
   - MCP Servers
   - Raycast e Karabiner
   - Scripts de setup
   - Templates DevContainer

2. **`~/10_INFRAESTRUTURA_VPS`**
   - Scripts de infraestrutura VPS
   - Documentação de VPS
   - Configurações específicas de VPS

### Mapeamento de Arquivos

| Origem | Destino |
|--------|---------|
| `system_prompt_tahoe_26.0.1/configs/cursor-settings.json` | `Dotfiles/configs/cursor/settings.json` |
| `system_prompt_tahoe_26.0.1/configs/cursor-keybindings.json` | `Dotfiles/configs/cursor/keybindings.json` |
| `system_prompt_tahoe_26.0.1/configs/vscode-settings.json` | `Dotfiles/configs/vscode/settings.json` |
| `system_prompt_tahoe_26.0.1/configs/mcp-servers.json` | `Dotfiles/configs/mcp/servers.json` |
| `system_prompt_tahoe_26.0.1/configs/raycast-config.json` | `Dotfiles/configs/raycast/config.json` |
| `system_prompt_tahoe_26.0.1/configs/karabiner-config.json` | `Dotfiles/configs/karabiner/config.json` |
| `system_prompt_tahoe_26.0.1/configs/extensions-universal.json` | `Dotfiles/configs/extensions/recommended.json` |
| `system_prompt_tahoe_26.0.1/scripts/setup-master.sh` | `Dotfiles/scripts/setup/master.sh` |
| `system_prompt_tahoe_26.0.1/scripts/setup-ubuntu.sh` | `Dotfiles/scripts/setup/ubuntu.sh` |
| `system_prompt_tahoe_26.0.1/scripts/apply-cursor-config.sh` | `Dotfiles/scripts/install/cursor.sh` |

---

## ✅ Padronizações Aplicadas

### 1. Paths Absolutos

Todos os scripts agora usam `$HOME/Dotfiles` como base:

```bash
REPO_ROOT="$HOME/Dotfiles"
```

### 2. Estrutura de Diretórios

- Configurações organizadas por ferramenta
- Scripts organizados por função (setup, install, sync, backup)
- Templates separados por tipo

### 3. Nomenclatura

- Arquivos em lowercase com hífen: `settings.json`, `keybindings.json`
- Scripts com extensão `.sh` e nomes descritivos
- Diretórios em lowercase

### 4. Referências Atualizadas

Todos os scripts foram atualizados para:
- Usar `$HOME/Dotfiles` como base
- Referenciar novos caminhos de configuração
- Manter compatibilidade com estrutura antiga (se necessário)

---

## 🚀 Como Usar

### Instalação Completa

```bash
cd ~/Dotfiles
./scripts/setup/master.sh
```

### Aplicar Configurações do Cursor

```bash
cd ~/Dotfiles
./scripts/install/cursor.sh
```

### Setup Ubuntu VPS

```bash
cd ~/Dotfiles
./scripts/setup/ubuntu.sh
```

---

## 📝 Notas Importantes

1. **Backup**: As configurações originais foram mantidas nos diretórios originais
2. **Compatibilidade**: Scripts foram atualizados para usar novos caminhos
3. **Documentação**: Toda documentação foi migrada para `~/Dotfiles/docs/`

---

## 🔍 Verificação

Para verificar se a migração foi bem-sucedida:

```bash
# Verificar estrutura
ls -la ~/Dotfiles/configs/
ls -la ~/Dotfiles/scripts/
ls -la ~/Dotfiles/templates/

# Verificar scripts
./scripts/setup/master.sh --help  # Se implementado
```

---

## 📚 Referências

- [System Prompt Global](SYSTEM_PROMPT_GLOBAL.md)
- [Resumo de Execuções](RESUMO_EXECUCOES.md)
- [README Principal](../README.md)

---

**Última atualização**: 2025-01-17  
**Versão**: 2.0.1

