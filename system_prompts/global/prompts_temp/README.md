# 📋 PROMPTS_TEMP - Área de Incubação para Desenvolvimento Evolutivo

**Versão:** 1.0.0
**Data:** 28 de Novembro de 2025
**Status:** Ativo

---

## 🎯 Objetivo

Esta pasta (`prompts_temp/`) é uma **área de incubação** para desenvolvimento evolutivo de prompts, formatada para **interpretação universal por LLMs** em múltiplos contextos:

- ✅ CLI / terminal
- ✅ Extensões integradas (Cursor, VSCode, Raycast, Zed, JetBrains AI)
- ✅ LLMs offline (Ollama, llama.cpp, LM Studio)
- ✅ Plataformas web (ChatGPT, Claude.ai, Gemini, Perplexity)
- ✅ LLMs desktop e agentes locais
- ✅ Coordenação multi-agente

---

## 📁 Estrutura

```
prompts_temp/
├── stage_00_coleta/              # Entrada bruta sem organização
├── stage_01_interpretacao/       # Revisão, síntese e contextualização
├── stage_02_estrutura/           # Formatação padronizada (md, json, yaml)
├── stage_03_refinamento/         # Pré-produção, coerência e testabilidade
├── stage_04_pre_release/         # Versão final antes de migrar para /prompts
├── checklists/
│   ├── lifecycle_checklist.md     # Rastreio de evolução por prompt
│   └── llm_eval_matrix.md         # Avaliação de resposta cross-model
├── engines/
│   ├── cli/                       # Prompts otimizados para terminal
│   ├── ide_ext/                   # Prompts para agentes no Cursor/VSCode
│   ├── offline_llms/              # Prompts p/ Ollama/LMStudio
│   ├── web_platforms/             # Prompts p/ GPT/Claude/Gemini/Perplexity
│   ├── desktop_llms/              # Prompts p/ apps locais
│   └── multi_agent/               # Coordenação de mais de um modelo
├── _progress.log                  # Log de progresso
├── _index_manifest.yaml           # Fonte única para mapeamento global
└── README.md                      # Este arquivo
```

---

## 🔄 Ciclo de Vida dos Prompts

### Stage 00: Coleta
**Propósito:** Ingestão de dados brutos sem organização

- Dados brutos coletados
- Origem documentada
- Formato bruto preservado

### Stage 01: Interpretação
**Propósito:** Revisão, síntese e contextualização

- Informações organizadas semanticamente
- Contexto claro e completo
- Redundâncias removidas

### Stage 02: Estrutura
**Propósito:** Formatação padronizada (md, json, yaml)

- Formato padronizado aplicado
- Estrutura hierárquica definida
- Compatibilidade com LLMs validada

### Stage 03: Refinamento
**Propósito:** Precisão, ajuste, validação

- Precisão técnica verificada
- Estilo consistente aplicado
- Testes básicos realizados

### Stage 04: Pré-Release
**Propósito:** Versão final antes de migrar para `/prompts`

- Avaliação final realizada
- Testes completos executados
- Aprovação para produção

---

## 🎯 Engines Disponíveis

### CLI (`engines/cli/`)
Prompts otimizados para:
- Shell scripts (bash/zsh)
- Terminal automation
- MCP agents
- CLI tools

### IDE Extensions (`engines/ide_ext/`)
Prompts para:
- Cursor 2.x
- VSCode Copilot
- JetBrains AI
- Raycast AI

### Offline LLMs (`engines/offline_llms/`)
Prompts para:
- Ollama (modelos locais)
- LM Studio
- llama.cpp
- GPTQ models

### Web Platforms (`engines/web_platforms/`)
Prompts para:
- ChatGPT Plus 5.1
- Claude Code (Sonnet/Opus)
- Gemini Pro
- Perplexity Pro

### Desktop LLMs (`engines/desktop_llms/`)
Prompts para:
- Aplicativos macOS
- Aplicativos Windows
- Aplicativos Linux

### Multi-Agent (`engines/multi_agent/`)
Prompts para:
- Coordenação entre múltiplos modelos
- Pipeline de agentes
- Orquestração inteligente

---

## 🚀 Uso Rápido

### Coletar e Adaptar Prompts Automaticamente

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./coletar-e-adaptar-prompts.sh
```

Este script:
- Coleta prompts existentes
- Processa através dos estágios
- Adapta para todos os engines
- Valida a estrutura completa

### Verificar Progresso

```bash
cat ~/Dotfiles/system_prompts/global/prompts_temp/_progress.log
```

### Consultar Manifest

```bash
cat ~/Dotfiles/system_prompts/global/prompts_temp/_index_manifest.yaml
```

---

## 📋 Checklists

### Lifecycle Checklist
Rastrear evolução de cada prompt através dos estágios:
- `checklists/lifecycle_checklist.md`

### LLM Eval Matrix
Avaliar qualidade através de múltiplos modelos:
- `checklists/llm_eval_matrix.md`

---

## 🔄 Processo de Promoção

### Regras

1. **Não pular estágios:** Cada prompt deve passar por todos os estágios
2. **Validação obrigatória:** Cada estágio requer validação antes de avançar
3. **Documentação:** Cada promoção deve ser documentada
4. **Versionamento:** Cada estágio deve ter versão documentada

### Promoção para Produção

**Requisitos:**
- ✅ Passou por todos os 5 estágios
- ✅ Checklist completo validado
- ✅ Avaliação LLM realizada
- ✅ Documentação completa
- ✅ Testes em múltiplos contextos
- ✅ Aprovação final

**Processo:**
1. Validar checklist completo
2. Executar avaliação LLM
3. Revisar documentação
4. Aprovar para produção
5. Migrar para `/prompts` ou `/global`

---

## 📊 Estatísticas Atuais

- **Prompts Coletados:** 6
- **Engines Criados:** 6
- **Arquivos Gerados:** 36+
- **Estrutura:** ✅ Completa
- **Validação:** ✅ Sem erros

---

## 🔗 Integração

Esta estrutura integra-se com:
- Sistema de coletas (`scripts/master-auditoria-completa.sh`)
- Sistema de análise (`scripts/analise-e-sintese.sh`)
- Prompts globais (`global/`)
- Scripts VPS (`scripts/coleta-vps.sh`)

---

## 📝 Notas Importantes

- **Não modificar diretamente:** Use os scripts de processamento
- **Versionamento:** Cada alteração deve ser versionada
- **Validação:** Sempre validar antes de promover
- **Documentação:** Manter documentação atualizada

---

**Versão:** 1.0.0
**Última Atualização:** 28 de Novembro de 2025
**Status:** Ativo e Funcional

