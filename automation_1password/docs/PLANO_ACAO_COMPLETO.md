# 📋 Plano de Ação Completo - automation_1password

**Data:** 31 de Outubro de 2025  
**Versão:** 2.1.0  
**Autor:** Luiz Sena

---

## 🎯 Visão Geral

Este documento apresenta os **planos de ação estruturados** para cada pasta do projeto, seguindo os princípios de **Context Engineering**, **governança parametrizada** e **automação macOS Silicon**. A execução diária respeita o fluxo **Coleta → Análise → Ação** descrito abaixo.

---

## 🔄 Pipeline Operacional (Coleta → Análise → Ação)

### 1. Coleta Automatizada
- [x] `scripts/diagnostics/gpt_sys_collector.sh` → gera `diagnostics/system_report_*.md`
- [x] Integrar saída ao template LLM (`diagnostics/system_report_20251031.md`)
- [ ] Agendar execução (launchd/systemd) · tarefa pendente

### 2. Análise Profunda
- [x] Auditoria 1Password (`reports/audits/1password_automation_findings_20251031.md`)
- [ ] Revisão Docker/Colima mensal (`scripts/validation/validate_architecture.sh --dry-run`)
- [ ] Relatório Cloudflare/DNS (template em `configs/dns_cloudflare_localhost_template.txt`)

### 3. Plano de Ação e Governança
- [x] Atualizar `.cursorrules` com guardrails de segredos
- [x] Atualizar runbook (`docs/PLANO_ACAO_COMPLETO.md`)
- [ ] Criar targets `make secrets-sync`, `make deploy-mirror` (próxima sprint)

---

## 📚 Estrutura de Navegação

| Pasta | Plano de Ação | Status | Prioridade |
|-------|---------------|--------|------------|
| **`context/`** | [Context Engineering](#context-context-engineering) | 🔨 Criar | Alta |
| **`connect/`** | [1Password Connect Server](#connect-1password-connect-server) | ✅ Existe | Crítica |
| **`env/`** | [Environment Management](#env-environment-management) | ✅ Existe | Crítica |
| **`scripts/`** | [Automation Scripts](#scripts-automation-scripts) | ✅ Existe | Alta |
| **`tokens/`** | [Token Management](#tokens-token-management) | ✅ Existe | Média |
| **`docs/`** | [Documentation](#docs-documentation) | ✅ Existe | Média |
| **`templates/`** | [Templates](#templates-templates) | ✅ Existe | Alta |
| **`configs/`** | [Global Configurations](#configs-global-configurations) | ✅ Existe | Baixa |
| **`logs/`** | [Logs Management](#logs-logs-management) | ✅ Existe | Baixa |
| **`organized/`** | [Legacy Organization](#organized-legacy-organization) | ✅ Existe | Baixa |

---

## 🔨 `context/` - Context Engineering

### Status Atual
❌ **Não existe** - Nova pasta para Context Engineering

### Objetivo
Criar estrutura de **repositório de conhecimento** estruturado para IA (RAG/Context Packs) seguindo princípios de Context Engineering.

### Plano de Ação

#### 1. Criar Estrutura de Diretórios
```bash
mkdir -p context/{raw/chats,raw/snippets,raw/uploads,curated,playbooks,prompts,decisions,indexes,embeddings,datasets,metadata/schemas,workspace}
```

**Estrutura:**
```
context/
├── raw/              # Quarentena - material não curado
│   ├── chats/        # Históricos de conversas
│   ├── snippets/     # Trechos de código/documentação
│   └── uploads/      # Uploads diretos
├── curated/          # Material curado - AI Context Pack
├── playbooks/        # Runbooks operacionais
├── prompts/          # Prompts de IA
├── decisions/        # Architectural Decision Records (ADRs)
├── indexes/          # Índices de busca (JSONL)
├── embeddings/       # Embeddings para RAG
├── datasets/         # Datasets de treinamento
├── metadata/         # Schemas e metadados
│   └── schemas/      # Templates de schema
└── workspace/        # Workspace temporário
```

#### 2. Implementar Schemas

**Schema de Context Note:**
```markdown
---
title: "Título curto e descritivo"
topic: "Domínio/tema (ex: devops, secrets, docker)"
tags: ["context", "kb", "devops", "1password"]
source: "chat|doc|code-review|runbook|meeting"
system: ["macos", "vps", "cloudflare", "1password", "traefik"]
related: []
authors: ["luiz.sena88"]
sensitivity: "internal|public|confidential"
revision: 1
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
slug: "slug-url-friendly"
---

## Resumo
- ...

## Decisões (ADR)
- [ ] DEC-001: ...

## Procedimento
1. ...
```

#### 3. Scripts de Gestão

**Gerador de Context Notes:**
```bash
scripts/context/new_context_note.sh <area> <sub> <title> <version>
```

**Build Index:**
```bash
scripts/context/build_index.sh
```

#### 4. Validações

**Validate Paths:**
```bash
scripts/context/validate_env_paths.sh
```

### Critérios de Sucesso

- ✅ Estrutura criada
- ✅ Schemas implementados
- ✅ Scripts funcionais
- ✅ Índice gerado automaticamente
- ✅ Integração com Cursor/VSCode

### Próximos Passos

1. Executar script de bootstrap
2. Criar primeira context note de exemplo
3. Gerar índice inicial
4. Validar integração com Cursor

---

## 🐳 `connect/` - 1Password Connect Server

### Status Atual
✅ **Existente e funcional**

### Plano de Ação

#### 1. Melhorias Prioritárias

**a) Limpar Logs Antigos**
```bash
find connect/ -name "validation-*.log" -mtime +7 -delete
```

**b) Consolidar Credentials**
- ✅ Manter apenas `connect/credentials.json`
- ❌ Remover duplicatas

**c) Melhorar Makefile**
- ✅ Atualizar com validate-architecture
- ✅ Adicionar tarefas de limpeza

#### 2. Documentação

- ✅ Criar README.md específico
- ✅ Documentar workflows
- ✅ Adicionar troubleshooting

### Critérios de Sucesso

- ✅ Sem logs obsoletos
- ✅ Credentials consolidados
- ✅ Makefile atualizado
- ✅ Documentação completa

---

## 🔐 `env/` - Environment Management

### Status Atual
✅ **Existente com workflow implementado**

### Plano de Ação

#### 1. Consolidação

**a) Padronizar Arquivos**
- ✅ `macos.env` - Configurações macOS
- ✅ `vps.env` - Configurações VPS
- ✅ `shared.env` - Configurações compartilhadas
- ✅ `infra.example.env.op` - Template completo de infra

**b) Workflow Automatizado**
- ✅ `load-infra-env.sh` - Carregamento automático
- ✅ Zero conflitos IDE/Terminal
- ✅ Integração 1Password Environments

#### 2. Validações

- ✅ Validação de paths
- ✅ Validação de variáveis obrigatórias
- ✅ Testes de integração

### Critérios de Sucesso

- ✅ Workflow funcional
- ✅ Validações passando
- ✅ Documentação atualizada

---

## 🤖 `scripts/` - Automation Scripts

### Status Atual
✅ **Existente e expandindo**

### Estrutura

```
scripts/
├── bootstrap/           # Setup inicial
├── connect/             # Operações Connect
├── secrets/             # Gerenciamento de secrets
├── validation/          # Validação e testes
├── maintenance/         # Manutenção
├── context/             # 🔨 Context Engineering
├── util/                # 🔨 Utilitários
└── raycast/             # 🔨 Raycast integration
```

### Plano de Ação

#### 1. Novos Scripts (Alta Prioridade)

**Context Management:**
- 🔨 `context/new_context_note.sh`
- 🔨 `context/build_index.sh`
- 🔨 `context/validate_env_paths.sh`

**Utilities:**
- 🔨 `util/cleanup_repo.sh`

**Raycast:**
- 🔨 `raycast/context-new-note.sh`

#### 2. Melhorias em Scripts Existentes

- ✅ Atualizar datas para 2025-10-29
- ✅ Padronizar logs
- ✅ Melhorar error handling

### Critérios de Sucesso

- ✅ Novos scripts implementados
- ✅ Scripts existentes atualizados
- ✅ Todas as datas padronizadas
- ✅ Logs consistentes

---

## 🔑 `tokens/` - Token Management

### Status Atual
✅ **Existente com documentação completa**

### Plano de Ação

#### 1. Consolidação

- ✅ README.md completo
- ✅ CONFIGURACAO_TOKENS.md detalhado
- ✅ tokens-summary.json atualizado
- ✅ Scripts de configuração

#### 2. Automação

- ✅ Extração automática de tokens
- ✅ Configuração de ambientes
- ✅ Validação de tokens

### Critérios de Sucesso

- ✅ Documentação 100%
- ✅ Scripts funcionais
- ✅ Tokens validados

---

## 📖 `docs/` - Documentation

### Status Atual
✅ **Existente e estruturado**

### Estrutura

```
docs/
├── overview.md                # Visão geral técnica
├── operations/                # Runbooks operacionais
│   ├── dns-records.md
│   ├── integracao-docker-traefik.md
│   └── master-plan.md
├── runbooks/                  # Runbooks detalhados
│   ├── automacao-macos.md
│   ├── automacao-vps.md
│   └── automacao-dual.md
└── archive/                   # Documentação histórica
```

### Plano de Ação

#### 1. Novos Documentos

- 🔨 `PLANO_ACAO_COMPLETO.md` (este arquivo)
- ✅ Manter overview atualizado
- ✅ Expandir runbooks

#### 2. Consolidação

- ✅ Consolidar documentação arquivada
- ✅ Atualizar links
- ✅ Validar referências

### Critérios de Sucesso

- ✅ Documentação hierárquica completa
- ✅ Links funcionais
- ✅ Runbooks atualizados

---

## 📄 `templates/` - Templates

### Status Atual
✅ **Existente**

### Estrutura

```
templates/
└── env/
    ├── macos.secrets.env.op
    └── vps.secrets.env.op
```

### Plano de Ação

#### 1. Expansão

- ✅ Adicionar `infra.example.env.op`
- ✅ Templates para novos serviços
- ✅ Documentar uso

### Critérios de Sucesso

- ✅ Templates completos
- ✅ Cobertura de todos os serviços
- ✅ Exemplos funcionais

---

## ⚙️ `configs/` - Global Configurations

### Status Atual
✅ **Existente**

### Plano de Ação

#### 1. Limpeza

- ✅ Consolidar arquivos de configuração
- ✅ Remover duplicatas
- ✅ Organizar por categoria

### Critérios de Sucesso

- ✅ Configurações organizadas
- ✅ Sem duplicatas
- ✅ Bem documentadas

---

## 📝 `logs/` - Logs Management

### Status Atual
✅ **Existente com .gitkeep**

### Plano de Ação

#### 1. Implementar Rotação

- 🔨 Script de rotação automática
- 🔨 Retenção de 30 dias
- 🔨 Compressão automática

#### 2. Limpeza

- 🔨 Remover logs antigos de `connect/`
- 🔨 Centralizar em `logs/`

### Critérios de Sucesso

- ✅ Sistema de rotação ativo
- ✅ Logs centralizados
- ✅ Retenção configurada

---

## 📦 `organized/` - Legacy Organization

### Status Atual
✅ **Existente com documentação de organização**

### Plano de Ação

#### 1. Migração

- 🔨 Mover conteúdo relevante para `context/`
- 🔨 Arquivar restante
- 🔨 Manter como referência

### Critérios de Sucesso

- ✅ Migração concluída
- ✅ Referências mantidas
- ✅ Limpeza de duplicatas

---

## 🎯 Priorização

### 🔴 Crítica (Fazer Imediatamente)

1. **Context Engineering** - Criar estrutura `context/`
2. **Workflow ENV** - Validar e ajustar
3. **Limpeza de Logs** - Remover logs antigos

### 🟡 Alta (Fazer nas Próximas 2 Semanas)

1. **Scripts Novos** - Context management
2. **Documentação** - Completar planos
3. **Validações** - Implementar testes

### 🟢 Média/Baixa (Backlog)

1. **Organização de Legacy**
2. **Melhorias incrementais**
3. **Otimizações**

---

## 📊 Métricas de Sucesso

| Métrica | Meta | Status Atual |
|---------|------|--------------|
| Estrutura `context/` | ✅ Criada | ❌ Pendente |
| Workflow ENV | ✅ Funcional | ✅ Completo |
| Logs limpos | < 7 dias | ❌ Pendente |
| Scripts atualizados | 100% | ✅ 100% |
| Documentação completa | 100% | ✅ 95% |
| Validações passando | 100% | ✅ 100% |

---

## ✅ Checklist de Implementação

### Fase 1: Context Engineering
- [ ] Criar estrutura de diretórios
- [ ] Implementar schemas
- [ ] Criar scripts de gestão
- [ ] Gerar índice inicial
- [ ] Validar integração Cursor

### Fase 2: Limpeza e Organização
- [ ] Limpar logs antigos
- [ ] Consolidar credenciais
- [ ] Organizar configs
- [ ] Migrar conteúdo relevant

### Fase 3: Documentação e Validação
- [ ] Completar planos de ação
- [ ] Atualizar INDEX.md
- [ ] Validar toda documentação
- [ ] Executar validações finais

---

**Próximo Passo Imediato:** Executar bootstrap de Context Engineering

**Data de Revisão:** 29 de Outubro de 2025
