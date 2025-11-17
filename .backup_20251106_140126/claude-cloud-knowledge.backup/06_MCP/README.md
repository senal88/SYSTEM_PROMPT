# 🔌 Servidores MCP - Configurações Centralizadas

**Data:** 2025-11-06  
**Localização Padrão:** `~/Dotfiles/claude-cloud-knowledge/06_MCP/`

---

## 📋 Estrutura

```
06_MCP/
├── README.md                          # Este arquivo
├── configuracoes/                     # Backup das configurações
│   ├── claude_desktop_config.json     # Configuração principal MCP
│   ├── ant.dir.ant.anthropic.filesystem.json
│   ├── ant.dir.gh.k6l3.osascript.json
│   └── context7.json
└── servidores/                        # Documentação dos servidores
    ├── filesystem.md
    ├── context7.md
    └── osascript.md
```

---

## 🔌 Servidores MCP Ativos

### 1. Filesystem (ant.dir.ant.anthropic.filesystem)

**Status:** ✅ Rodando  
**Tipo:** Extensão Gerenciada  
**Controla Mac:** ✅ Sim

**Configuração Local:**
- `~/Library/Application Support/Claude/Claude Extensions Settings/ant.dir.ant.anthropic.filesystem.json`

**Diretório Permitido:**
- `/Users/luiz.sena88/Dotfiles/claude-cloud-knowledge`

---

### 2. Context7

**Status:** ✅ Rodando  
**Tipo:** Extensão Gerenciada  
**Controla Mac:** ✅ Sim

**Comando:**
```bash
node /Users/luiz.sena88/Library/Application\ Support/Claude/Claude\ Extensions/context7/dist/index.js
```

**Variáveis de Ambiente:**
- `icuqsapkzysbulka6xkhzk6ftu`

**Configuração Local:**
- `~/Library/Application Support/Claude/Claude Extensions Settings/context7.json`

---

### 3. OSA Script (ant.dir.gh.k6l3.osascript)

**Status:** ✅ Rodando  
**Tipo:** Extensão Gerenciada  
**Controla Mac:** ✅ Sim

**Comando:**
```bash
node /Users/luiz.sena88/Library/Application\ Support/Claude/Claude\ Extensions/ant.dir.gh.k6l3.osascript/server/index.js
```

**Configuração Local:**
- `~/Library/Application Support/Claude/Claude Extensions Settings/ant.dir.gh.k6l3.osascript.json`

---

### 4. Task Master AI

**Status:** ⚠️ Configurado  
**Tipo:** MCP stdio  
**Controla Mac:** ❌ Não

**Configuração:**
- `~/Library/Application Support/Claude/claude_desktop_config.json`

---

## 📁 Localização Padrão

### Configurações Principais

**Arquivo Principal:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Backup Centralizado:**
```
~/Dotfiles/claude-cloud-knowledge/06_MCP/configuracoes/
```

### Extensões

**Diretório de Extensões:**
```
~/Library/Application Support/Claude/Claude Extensions/
```

**Configurações de Extensões:**
```
~/Library/Application Support/Claude/Claude Extensions Settings/
```

---

## 🔧 Gerenciamento

### Sincronizar Configurações

As configurações são automaticamente sincronizadas para este diretório via scripts de backup.

### Restaurar Configurações

```bash
# Restaurar configuração principal
cp ~/Dotfiles/claude-cloud-knowledge/06_MCP/configuracoes/claude_desktop_config.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Restaurar configurações de extensões
cp ~/Dotfiles/claude-cloud-knowledge/06_MCP/configuracoes/*.json \
   ~/Library/Application\ Support/Claude/Claude\ Extensions\ Settings/
```

---

## 📊 Status

| Servidor | Status | Localização Padrão |
|----------|--------|-------------------|
| **Filesystem** | ✅ Rodando | `~/Library/Application Support/Claude/` |
| **Context7** | ✅ Rodando | `~/Library/Application Support/Claude/` |
| **OSA Script** | ✅ Rodando | `~/Library/Application Support/Claude/` |
| **Task Master AI** | ⚠️ Configurado | `~/Library/Application Support/Claude/` |

---

**Última atualização:** 2025-11-06

