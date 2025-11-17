# 🌍 Sistema de Contexto Global para IAs

**Versão**: 2.0.1
**Última Atualização**: 2025-01-17

---

## 📋 Visão Geral

Este documento descreve o sistema de contexto global implementado para garantir que todas as IAs (Cursor, VSCode, Claude, Gemini, ChatGPT) tenham acesso completo e atualizado ao contexto do ambiente de desenvolvimento.

---

## 🎯 Objetivo

Fornecer contexto estruturado e atualizado para todas as IAs instaladas, garantindo:
- ✅ Execução correta de comandos
- ✅ Instalações padronizadas
- ✅ Acesso a configurações e credenciais
- ✅ Entendimento completo do ambiente

---

## 📁 Estrutura de Arquivos

```
~/Dotfiles/
├── context/                          # Contexto para IAs
│   ├── README.md                     # Guia de uso
│   ├── global/
│   │   ├── CONTEXTO_GLOBAL_COMPLETO.md  # ⭐ Documento principal
│   │   └── system-info.json          # Informações do sistema
│   ├── cursor/
│   │   └── CONTEXTO_CURSOR.md        # Contexto específico Cursor
│   ├── vscode/
│   │   └── CONTEXTO_VSCODE.md         # Contexto específico VSCode
│   ├── claude/
│   │   └── CONTEXTO_CLAUDE.md        # Contexto específico Claude
│   └── gemini/
│       └── CONTEXTO_GEMINI.md        # Contexto específico Gemini
└── scripts/
    └── context/
        └── update-global-context.sh   # Script de atualização
```

---

## 🔄 Atualização Automática

### Script Principal

**Localização**: `~/Dotfiles/scripts/context/update-global-context.sh`

**O que faz**:
1. Coleta informações do sistema (OS, versões, paths)
2. Atualiza contexto global completo
3. Gera contextos específicos por IA
4. Copia contexto para editores (Cursor, VSCode)
5. Gera relatório de atualização

### Execução

```bash
cd ~/Dotfiles
./scripts/context/update-global-context.sh
```

### Quando Executar

- ✅ Após mudanças significativas no ambiente
- ✅ Após instalação de novas ferramentas
- ✅ Após atualização de credenciais
- ✅ Periodicamente (semanalmente recomendado)
- ✅ Antes de trabalhar em novo projeto

---

## 📖 Documentos de Contexto

### 1. Contexto Global Completo

**Arquivo**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

**Conteúdo**:
- Arquitetura do sistema
- Ambientes suportados (macOS, Ubuntu, DevContainer, Codespaces)
- Credenciais e segurança (1Password)
- Configurações por ferramenta
- Projeto GCP
- Stack de desenvolvimento
- Fluxos de trabalho
- Convenções e padrões
- Comandos rápidos
- Checklists de verificação

### 2. Contextos Específicos

Cada IA tem um contexto específico que referencia o contexto global e adiciona informações relevantes:

- **Cursor**: Configurações, keybindings, extensões
- **VSCode**: Settings, integrações, extensões
- **Claude**: Estrutura de diretórios, comandos importantes
- **Gemini**: Configuração GCP, credenciais, APIs

---

## 🔧 Integração por Ambiente

### macOS Silicon

**Contexto Copiado Para**:
- `~/Library/Application Support/Cursor/User/context/`
- `~/Library/Application Support/Code/User/context/`

**Arquivos Criados**:
- `.cursorrules` na raiz do workspace
- `.vscode/settings.json` com referências ao contexto

### Ubuntu VPS

**Variáveis de Ambiente**:
```bash
export DOTFILES_DIR="$HOME/Dotfiles"
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export CONTEXT_GLOBAL="$DOTFILES_DIR/context/global/CONTEXTO_GLOBAL_COMPLETO.md"
```

**Configuração**: Adicionada ao `.bashrc` e `.zshrc`

### DevContainer

**Script**: `~/Dotfiles/templates/devcontainer/context-setup.sh`

**Execução**: Automática via `postCreateCommand` no `devcontainer.json`

**O que faz**:
- Cria estrutura de contexto
- Copia contexto global
- Configura variáveis de ambiente
- Cria link simbólico para fácil acesso

### GitHub Codespaces

**Workflow**: `~/Dotfiles/templates/github/workflows/codespace-setup.yml`

**Step**: `Setup Codespace - Contexto Global`

**O que faz**:
- Cria estrutura de contexto
- Configura variáveis de ambiente
- Disponibiliza contexto para todas as IAs

---

## 🎯 Uso pelas IAs

### Cursor

1. **Arquivo `.cursorrules`** na raiz referencia o contexto global
2. **Contexto copiado** para diretório do Cursor
3. **IA do Cursor** lê automaticamente o contexto

### VSCode

1. **Settings** referencia o contexto global
2. **Contexto copiado** para diretório do VSCode
3. **Extensões de IA** (Copilot, Gemini) acessam o contexto

### Claude/Gemini/ChatGPT

1. **Arquivos de contexto** disponíveis em `~/Dotfiles/context/`
2. **Referenciar diretamente** os arquivos `.md` ao iniciar conversa
3. **Copiar conteúdo** se necessário para contexto da conversa

---

## 📝 Convenções

### Nomenclatura

- Arquivos de contexto: `CONTEXTO_[NOME].md`
- Scripts: `update-global-context.sh`
- JSON de info: `system-info.json`

### Versionamento

- Contexto versionado no Git
- Credenciais NUNCA versionadas
- Timestamp em cada atualização
- Versão do sistema documentada

### Atualização

- Sempre executar script de atualização após mudanças
- Verificar se contexto foi copiado corretamente
- Testar acesso ao contexto em cada IA

---

## ✅ Checklist de Verificação

### Após Atualização

- [ ] Script executado com sucesso
- [ ] Arquivos de contexto atualizados
- [ ] Contexto copiado para editores (macOS)
- [ ] Variáveis de ambiente configuradas (Ubuntu/DevContainer)
- [ ] Contexto acessível pelas IAs
- [ ] Informações do sistema atualizadas

### Verificação por IA

- [ ] **Cursor**: Contexto disponível em `~/Library/Application Support/Cursor/User/context/`
- [ ] **VSCode**: Contexto disponível em `~/Library/Application Support/Code/User/context/`
- [ ] **Claude**: Arquivo `CONTEXTO_CLAUDE.md` acessível
- [ ] **Gemini**: Arquivo `CONTEXTO_GEMINI.md` acessível

---

## 🚀 Comandos Rápidos

```bash
# Atualizar contexto global
cd ~/Dotfiles && ./scripts/context/update-global-context.sh

# Verificar contexto atualizado
ls -la ~/Dotfiles/context/

# Ver informações do sistema
cat ~/Dotfiles/context/global/system-info.json

# Acessar contexto global
cat ~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md
```

---

## 📚 Documentação Relacionada

- [System Prompt Global](./SYSTEM_PROMPT_GLOBAL.md)
- [Padronização](./PADRONIZACAO.md)
- [GCP Project Config](./GCP_PROJECT_CONFIG.md)
- [Gemini Code Assist Setup](./GEMINI_CODE_ASSIST_SETUP.md)

---

## 🔄 Manutenção

### Frequência Recomendada

- **Semanal**: Atualização de contexto
- **Após mudanças**: Atualização imediata
- **Mensal**: Revisão completa do contexto

### Troubleshooting

**Problema**: Contexto não atualizado
- **Solução**: Executar script manualmente

**Problema**: Contexto não copiado para editores
- **Solução**: Verificar permissões e paths

**Problema**: Variáveis de ambiente não configuradas
- **Solução**: Verificar `.bashrc` e `.zshrc`

---

**Última atualização**: 2025-01-17
**Versão**: 2.0.1
**Status**: ✅ Ativo e Mantido
