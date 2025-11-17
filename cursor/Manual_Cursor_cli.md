# 🚀 Manual Cursor CLI - Guia Completo

## 📋 Índice

1. [Instalação e Configuração](#-instalação-e-configuração)
2. [Comandos Básicos](#-comandos-básicos)
3. [Funções Personalizadas](#-funções-personalizadas)
4. [Aliases Rápidos](#-aliases-rápidos)
5. [Variáveis de Ambiente](#-variáveis-de-ambiente)
6. [Exemplos Práticos](#-exemplos-práticos)
7. [Troubleshooting](#-troubleshooting)

---

## 🔧 Instalação e Configuração

### ✅ Status da Instalação

- **Cursor CLI**: Instalado globalmente
- **PATH**: Configurado no `.zshrc`
- **API Key**: Configurada e ativa
- **Auto-save**: Habilitado

### 📁 Estrutura de Arquivos

```text
/Users/luiz.sena88/
├── .zshrc (configurações globais)
├── Projetos/
│   └── cursor/
│       └── Manual_Cursor_cli.md
└── Applications/Cursor.app
```

---

## 🎯 Comandos Básicos

### Comando Principal

```bash
cursor [opções] [caminho]
```

### Opções Principais

- `--version` - Mostra versão do Cursor
- `--folder <path>` - Abre pasta específica
- `--wait` - Aguarda fechamento do Cursor
- `--new-window` - Abre em nova janela
- `--reuse-window` - Reutiliza janela existente

### Exemplos Básicos

```bash
# Abrir Cursor no diretório atual
cursor .

# Abrir pasta específica
cursor /Users/luiz.sena88/Projetos/meu_projeto

# Abrir com nova janela
cursor --new-window /path/to/project

# Aguardar fechamento
cursor --wait /path/to/project
```

---

## 🚀 Funções Personalizadas

### 1. `cursor_agent <path>`

Inicia Cursor Agent em projeto específico com logging.

```bash
# Uso
cursor_agent /caminho/do/projeto

# Exemplo
cursor_agent /Users/luiz.sena88/Projetos/dashboard_tributario_v2
```

**Funcionalidades:**

- ✅ Detecta automaticamente o diretório atual se não especificado
- ✅ Logs de inicialização
- ✅ Aguarda fechamento do Cursor

### 2. `cursor_new <nome>`

Cria novo projeto e abre no Cursor.

```bash
# Uso
cursor_new nome_do_projeto

# Exemplo
cursor_new meu_novo_projeto
```

**Funcionalidades:**

- ✅ Cria diretório em `~/Projetos/`
- ✅ Navega para o novo projeto
- ✅ Abre automaticamente no Cursor

### 3. `cursor_open <path>`

Abre projeto existente no Cursor.

```bash
# Uso
cursor_open /caminho/do/projeto

# Exemplo
cursor_open /Users/luiz.sena88/Projetos/dashboard_tributario_v2
```

**Funcionalidades:**

- ✅ Abre projeto existente
- ✅ Detecta diretório atual se não especificado
- ✅ Logs de abertura

---

## ⚡ Aliases Rápidos

### Aliases Principais

```bash
c          # cursor
code       # cursor (compatibilidade VSCode)
edit       # cursor
```

### Aliases de Funções

```bash
ca         # cursor_agent
cn         # cursor_new
co         # cursor_open
```

### Exemplos de Uso

```bash
# Abrir projeto atual
c .

# Criar novo projeto
cn meu_projeto

# Abrir projeto específico
co /path/to/project

# Iniciar agent
ca /path/to/project
```

---

## 🔧 Variáveis de Ambiente

### Configurações Principais

```bash
# API Key do Cursor
export CURSOR_API_KEY="con-4b675d386275cbe80dd3d7f729e845ad5f9db2ae8746d0c8283638449dcfaf44"

# Habilitar Cursor Agent
export CURSOR_AGENT_ENABLED="true"

# Auto-save habilitado
export CURSOR_AGENT_AUTO_SAVE="true"

# Nível de log
export CURSOR_AGENT_LOG_LEVEL="info"
```

### PATH Configurado

```bash
export PATH="$PATH:/Applications/Cursor.app/Contents/Resources/app/bin"
```

---

## 📚 Exemplos Práticos

### 1. Desenvolvimento de Projeto Existente

```bash
# Navegar para projeto
cd /Users/luiz.sena88/Projetos/dashboard_tributario_v2

# Abrir no Cursor
cursor .

# Ou usar alias
c .
```

### 2. Criar Novo Projeto

```bash
# Criar e abrir novo projeto
cursor_new meu_novo_projeto

# Isso criará:
# ~/Projetos/meu_novo_projeto/
# E abrirá no Cursor
```

### 3. Trabalhar com Múltiplos Projetos

```bash
# Projeto 1
cursor_open /Users/luiz.sena88/Projetos/projeto1

# Projeto 2 (nova janela)
cursor --new-window /Users/luiz.sena88/Projetos/projeto2
```

### 4. Automação com Scripts

```bash
#!/bin/bash
# Script para abrir múltiplos projetos

# Projeto principal
cursor_agent /Users/luiz.sena88/Projetos/dashboard_tributario_v2

# Projeto secundário
cursor_open /Users/luiz.sena88/Projetos/agentkit
```

---

## 🔍 Troubleshooting

### Problemas Comuns

#### 1. Comando `cursor` não encontrado

```bash
# Verificar PATH
echo $PATH | grep Cursor

# Recarregar .zshrc
source ~/.zshrc

# Verificar instalação
ls -la /Applications/Cursor.app/Contents/Resources/app/bin/cursor
```

#### 2. Funções não disponíveis

```bash
# Recarregar .zshrc
source ~/.zshrc

# Verificar funções
type cursor_agent
type cursor_new
type cursor_open
```

#### 3. API Key não configurada

```bash
# Verificar variável
echo $CURSOR_API_KEY

# Configurar manualmente
export CURSOR_API_KEY="sua_api_key_aqui"
```

### Comandos de Diagnóstico

```bash
# Verificar versão
cursor --version

# Verificar PATH
which cursor

# Verificar funções
type cursor_agent

# Verificar aliases
alias | grep cursor
```

---

## 📊 Resumo de Comandos

### Comandos Essenciais

| Comando             | Função                  | Exemplo                         |
| ------------------- | ----------------------- | ------------------------------- |
| `cursor .`          | Abrir diretório atual   | `cursor .`                      |
| `cursor_new nome`   | Criar novo projeto      | `cursor_new meu_projeto`        |
| `cursor_open path`  | Abrir projeto existente | `cursor_open /path/to/project`  |
| `cursor_agent path` | Iniciar agent           | `cursor_agent /path/to/project` |

### Aliases Úteis

| Alias | Comando        | Função        |
| ----- | -------------- | ------------- |
| `c`   | `cursor`       | Abrir Cursor  |
| `cn`  | `cursor_new`   | Criar projeto |
| `co`  | `cursor_open`  | Abrir projeto |
| `ca`  | `cursor_agent` | Iniciar agent |

---

## 🎯 Melhores Práticas

### 1. Organização de Projetos

- Use `~/Projetos/` para todos os projetos
- Nomes descritivos para projetos
- Estrutura consistente

### 2. Workflow Recomendado

```bash
# 1. Criar projeto
cursor_new meu_projeto

# 2. Desenvolver
# (trabalhar no Cursor)

# 3. Abrir novamente
cursor_open ~/Projetos/meu_projeto
```

### 3. Automação

- Use scripts para projetos complexos
- Configure aliases para comandos frequentes
- Mantenha .zshrc organizado

---

## 📝 Notas Importantes

- ✅ **Cursor CLI** está instalado globalmente
- ✅ **Configurações** salvas no `.zshrc`
- ✅ **API Key** configurada e ativa
- ✅ **Funções** personalizadas disponíveis
- ✅ **Aliases** configurados
- ✅ **Auto-save** habilitado

---

## 🔄 Atualizações

Para atualizar este manual:

1. Edite este arquivo
2. Mantenha exemplos atualizados
3. Adicione novos comandos conforme necessário

---

**📅 Última atualização**: 2025-10-31  
**👤 Configurado por**: Sistema de automação  
**🔧 Versão**: 1.0.0
