# System Prompts Globais

Este diretório contém **TODOS** os system prompts globais que devem ser aplicados em qualquer LLM, IDE ou ferramenta de automação.

## ⚠️ REGRA FUNDAMENTAL

**System prompts globais NUNCA devem estar em pastas locais específicas.**

Eles devem estar **SOMENTE** em:

- `~/Dotfiles/system_prompts/global/` ← **ESTE DIRETÓRIO**

## 📁 Estrutura

```text
~/Dotfiles/system_prompts/global/
├── README.md (este arquivo)
├── CHANGELOG.md (histórico de versões)
│
├── prompts/ (prompts organizados por categoria)
│   ├── system/ (prompts de sistema)
│   │   ├── universal.md
│   │   ├── icloud_protection.md
│   │   └── CURSOR_2.0_SYSTEM_PROMPT_FINAL.md
│   ├── audit/ (prompts de auditoria)
│   │   └── PROMPT_AUDITORIA_VPS.md
│   └── revision/ (prompts de revisão)
│       ├── PROMPT_REVISAO_MEMORIAS.md
│       └── PROMPT_REVISAO_MEMORIAS_CONCISO.md
│
├── docs/ (documentação organizada)
│   ├── checklists/ (checklists)
│   │   ├── CHECKLIST_1PASSWORD_ATUALIZACAO.md
│   │   └── CHECKLIST_APRIMORAMENTO_PROMPT.md
│   ├── summaries/ (resumos e estruturas)
│   │   ├── RESUMO_AUDITORIA_1PASSWORD.txt
│   │   ├── RESUMO_INCORPORACAO.txt
│   │   └── ESTRUTURA_COMPLETA.txt
│   ├── corrections/ (correções e soluções)
│   │   ├── CORRECAO_DEPENDENCIAS_COMPLETA.md
│   │   └── SOLUCAO_HOMEBREW.md
│   ├── README_VPS.md
│   ├── README_ARQUITETURA.md
│   ├── README_COLETAS.md
│   ├── ANALISE_ARQUITETURA.md
│   ├── ARQUITETURA_COLETAS.md
│   ├── INCORPORACAO_PROMPTS_REVISADOS.md
│   └── GOVERNANCA_E_EXPANSAO.md
│
├── consolidated/ (arquivos consolidados gerados)
│   ├── llms-full.txt
│   └── arquitetura-estrutura.txt
│
├── scripts/ (scripts de automação)
│   ├── master-auditoria-completa.sh (coleta completa)
│   ├── analise-e-sintese.sh (análise e síntese)
│   ├── consolidar-llms-full.sh (geração llms-full.txt)
│   ├── verificar-dependencias.sh (verificação de dependências)
│   ├── exportar-arquitetura.sh (exportação de arquitetura)
│   ├── executar-auditoria-docker-vps.sh (auditoria Docker VPS)
│   ├── coleta-vps.sh (coleta completa da VPS)
│   ├── analise-e-sintese-vps.sh (análise e síntese VPS)
│   ├── deploy-scripts-vps.sh (deploy dos scripts para VPS)
│   ├── coletar-e-adaptar-prompts.sh (coleta e adaptação de prompts)
│   ├── revisar-e-incorporar-prompts.sh (revisar e incorporar prompts)
│   ├── auditar-1password-secrets.sh (auditoria 1Password)
│   ├── corrigir-dependencias-completo.sh (correção completa de dependências)
│   ├── configurar-homebrew.sh (configuração Homebrew)
│   ├── instalar-1password-cli.sh (instalação 1Password CLI)
│   ├── remover-referencias-obsoletas.sh (remoção de referências obsoletas)
│   ├── reorganizar-arquivos-root.sh (reorganização de arquivos)
│   ├── atualizar-versoes-datas.sh (atualização de versões e datas)
│   ├── governanca-ides-completa.sh (governança IDEs)
│   ├── validar-paths-home.sh (validação de paths HOME)
│   ├── master-executar-todos.sh (execução de todos os scripts)
│   └── legacy/ (scripts legados)
│       ├── COMANDOS_FINAIS_EXECUTAVEIS.sh
│       └── COMANDOS_FINAIS_NORMALIZADOS.txt
│
├── audit/ (auditorias históricas)
│   └── YYYYMMDD_HHMMSS/ (timestamp da auditoria)
│       ├── macos/ (dados coletados do macOS)
│       ├── vps/ (dados coletados do VPS - opcional)
│       ├── analysis/ (análises intermediárias)
│       └── consolidated/ (arquivos consolidados)
│
├── prompts_temp/ (área de incubação para desenvolvimento evolutivo)
│   ├── _index_manifest.yaml (manifesto de mapeamento global)
│   ├── _progress.log (log de progresso)
│   ├── README.md (documentação da área de incubação)
│   ├── checklists/ (checklists de lifecycle e avaliação LLM)
│   ├── engines/ (prompts adaptados para diferentes engines)
│   └── stage_*/ (estágios de desenvolvimento)
│
├── governance/ (governança e validações)
│   ├── GOVERNANCA_IDES.md (governança completa de IDEs)
│   ├── validation/ (validações)
│   └── rules/ (regras)
│
├── templates/ (templates para geração)
├── platforms/ (prompts específicos de plataformas)
└── logs/ (logs do sistema)
```

## 🚀 Uso Rápido

### Para ChatGPT/Claude/Gemini/Perplexity

Cole o conteúdo de `consolidated/llms-full.txt` ou `prompts/system/universal.md` nas Custom Instructions.

### Para Cursor 2.0+

Os prompts são carregados automaticamente de `~/.cursor/rules/` que devem ser symlinks ou cópias de arquivos aqui. Use `prompts/system/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md` como referência completa.

### Para Revisão de Memórias e Contexto

Use `prompts/revision/PROMPT_REVISAO_MEMORIAS_CONCISO.md` para uma revisão rápida ou `prompts/revision/PROMPT_REVISAO_MEMORIAS.md` para documentação completa.

### Para Coleta e Consolidação de Dados

```bash
cd ~/Dotfiles/system_prompts/global/scripts

# Pipeline completo
./master-auditoria-completa.sh && \
./analise-e-sintese.sh && \
./consolidar-llms-full.sh
```

## 📚 Documentação Principal

### Prompts de Sistema

- **`prompts/system/universal.md`** - Prompt universal base para todos LLMs
- **`prompts/system/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md`** - Prompt completo e detalhado para Cursor 2.0+
- **`prompts/system/icloud_protection.md`** - Política de proteção iCloud

### Prompts de Revisão

- **`prompts/revision/PROMPT_REVISAO_MEMORIAS.md`** - Prompt completo para revisão de memórias e contexto
- **`prompts/revision/PROMPT_REVISAO_MEMORIAS_CONCISO.md`** - Versão concisa pronta para uso direto

### Prompts de Auditoria

- **`prompts/audit/PROMPT_AUDITORIA_VPS.md`** - Prompt para auditoria e alinhamento da arquitetura VPS (status atual vs planejado)

### Arquitetura e Coletas

- **`docs/ARQUITETURA_COLETAS.md`** - Arquitetura completa do sistema de coletas
- **`docs/README_COLETAS.md`** - Guia rápido de uso do sistema de coletas
- **`docs/ANALISE_ARQUITETURA.md`** - Análise do status atual da arquitetura
- **`docs/README_ARQUITETURA.md`** - Guia de exportação de arquitetura

### Arquivos Consolidados (Gerados)

- **`consolidated/llms-full.txt`** - Arquivo consolidado otimizado para importação em LLMs
- **`consolidated/arquitetura-estrutura.txt`** - Estrutura completa do sistema

### Scripts VPS

- **`scripts/coleta-vps.sh`** - Script de coleta completa da VPS Ubuntu
- **`scripts/analise-e-sintese-vps.sh`** - Script de análise e síntese VPS
- **`scripts/deploy-scripts-vps.sh`** - Script de deploy dos scripts para VPS
- **`README_VPS.md`** - Guia completo de uso dos scripts VPS

### Scripts de Auditoria e Segurança

- **`scripts/auditar-1password-secrets.sh`** - Auditoria completa de secrets e variáveis de ambiente para 1Password
- **`docs/checklists/CHECKLIST_1PASSWORD_ATUALIZACAO.md`** - Checklist completo para atualização no 1Password

### Scripts de Governança e Validação

- **`scripts/governanca-ides-completa.sh`** - Implementa governança completa para IDEs com validações
- **`scripts/validar-paths-home.sh`** - Valida paths HOME antes de operações
- **`scripts/reorganizar-arquivos-root.sh`** - Reorganiza arquivos da root para subdiretórios
- **`scripts/atualizar-versoes-datas.sh`** - Atualiza versões e datas em todos os arquivos
- **`scripts/remover-referencias-obsoletas.sh`** - Remove referências obsoletas
- **`governance/GOVERNANCA_IDES.md`** - Documentação completa de governança de IDEs

### Área de Incubação (prompts_temp)

- **`prompts_temp/`** - Área de incubação para desenvolvimento evolutivo de prompts
- **`prompts_temp/README.md`** - Documentação completa da área de incubação
- **`prompts_temp/_index_manifest.yaml`** - Manifesto de mapeamento global
- **`prompts_temp/_progress.log`** - Log de progresso
- **`prompts_temp/checklists/`** - Checklists de lifecycle e avaliação LLM
- **`prompts_temp/engines/`** - Prompts adaptados para diferentes engines (CLI, IDE, Offline, Web, Desktop, Multi-Agent)
- **`scripts/coletar-e-adaptar-prompts.sh`** - Script automatizado de coleta e adaptação
- **`scripts/revisar-e-incorporar-prompts.sh`** - Script para revisar e incorporar prompts de documentos externos

### Prompts Incorporados Recentemente

- **`PROMPT_MCP_SERVERS`** - Guia de configuração de MCP Servers no Cursor
- **`PROMPT_SETUP_MACOS_WINDOWS_EXPERIENCE`** - Setup macOS familiar ao Windows
- **`PROMPT_MODO_ADAPTATIVO`** - Modo operacional adaptativo permanente
- **`docs/INCORPORACAO_PROMPTS_REVISADOS.md`** - Documentação da incorporação

## 🔄 Fluxo de Trabalho

### 1. Coleta de Dados

Execute a auditoria completa para coletar informações do ambiente:

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./master-auditoria-completa.sh
```

### 2. Análise e Síntese

Processe os dados coletados:

```bash
./analise-e-sintese.sh
```

### 3. Consolidação para LLMs

Gere o arquivo consolidado:

```bash
./consolidar-llms-full.sh
```

### 4. Revisão de Memórias

Use o prompt de revisão para verificar informações armazenadas:

- Copie `prompts/revision/PROMPT_REVISAO_MEMORIAS_CONCISO.md` e cole no LLM desejado

### 5. Coleta e Adaptação de Prompts

Coletar e adaptar prompts existentes para múltiplos engines:

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./coletar-e-adaptar-prompts.sh
```

Este script:

- Coleta prompts existentes em `stage_00_coleta/`
- Processa através dos estágios de desenvolvimento
- Adapta para todos os engines (CLI, IDE, Offline, Web, Desktop, Multi-Agent)
- Valida a estrutura completa

### 6. Revisar e Incorporar Prompts de Documentos Externos

Revisar documentos externos e incorporar apenas prompts relevantes e novos:

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./revisar-e-incorporar-prompts.sh
```

Este script:

- Analisa documento fonte (`~/aprimorar_prompts.md`)
- Extrai apenas prompts relevantes e que ainda não existem
- Incorpora em `prompts_temp/stage_00_coleta/`
- Processa através do pipeline de adaptação
- Valida incorporação completa

### 7. Auditoria 1Password - Secrets e Variáveis de Ambiente

Auditar instalações, configurações e gerar relatório para atualização no 1Password:

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./auditar-1password-secrets.sh
```

Este script:

- Verifica instalações (Homebrew, Node, Python, Docker, etc.)
- Audita configurações de LLMs (Cursor, VSCode, Raycast, etc.)
- Verifica variáveis de ambiente e secrets
- Audita configurações de MCP Servers
- Gera relatório completo com recomendações
- Cria checklist de atualização no 1Password

**Relatório gerado em:** `audit/[timestamp]/1password/relatorio_1password_[timestamp].md`
**Checklist:** `docs/checklists/CHECKLIST_1PASSWORD_ATUALIZACAO.md`

## 📋 Versionamento

Todos os prompts devem ter:

- Versão semântica (ex: 1.0.0)
- Data de criação/atualização
- Changelog quando aplicável

## 🏷️ Nomenclatura

- `universal.md` - Prompt universal para todos LLMs
- `[ferramenta]_[versao].md` - Prompt específico de ferramenta
- `[categoria]_[nome].md` - Prompt por categoria
- `PROMPT_[acao].md` - Prompts de ação específica
- `README_[topico].md` - Documentação por tópico
- `[nome]-full.txt` - Arquivos consolidados gerados

## 🔐 Segurança

- **Nunca** exponha credenciais em texto claro
- Use 1Password CLI para gestão de secrets
- Respeite a política de proteção iCloud (`icloud_protection.md`)
- Valide scripts antes de execução

## 📊 Status do Sistema

- **Última Auditoria:** Verificar em `audit/` (mais recente por timestamp)
- **Versão llms-full.txt:** Verificar cabeçalho do arquivo
- **Scripts:** Todos funcionais e documentados
- **Expansão:** Sistema evolutivo - ver `GOVERNANCA_E_EXPANSAO.md`

## 📚 Documentação Adicional

- **`docs/GOVERNANCA_E_EXPANSAO.md`** - Governança, expansão, versionamento e padrões
- **`CHANGELOG.md`** - Histórico de mudanças e versões
- **`docs/README_VPS.md`** - Guia completo de scripts VPS
- **`docs/README_COLETAS.md`** - Guia de sistema de coletas
- **`docs/README_ARQUITETURA.md`** - Guia de exportação de arquitetura
- **`governance/GOVERNANCA_IDES.md`** - Governança completa de IDEs com validações

## 🔄 Expansão e Atualização

**Este repositório é evolutivo e pode expandir-se continuamente.**

Para adicionar novos conteúdos:

1. Verificar se é **global** ou específico de projeto (ver `docs/GOVERNANCA_E_EXPANSAO.md`)
2. Seguir padrão de nomenclatura e versionamento
3. Criar em `prompts_temp/` primeiro (se aplicável)
4. Validar e promover para `global/`
5. **NUNCA** criar arquivos na root (exceto README.md, CHANGELOG.md, .gitignore)
6. Organizar em subdiretórios apropriados (`prompts/`, `docs/`, `scripts/`, etc.)
7. Atualizar documentação

**Padrão de atualização integrada:** Uma atualização propaga-se automaticamente para todos os sistemas (macOS, VPS, GitHub Copilot, LLMs web, etc.)

---

**Última Atualização**: 2025-11-28
**Status**: Sistema completo, operacional e em expansão contínua
**Versão**: 2.0.0
