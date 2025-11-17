Last Updated: 2025-10-30
Version: 2.0.0
# 📊 Diagnóstico e Padronização: .cursorrules para ~/Projetos

## 🎯 Escopo

Padronização de `.cursorrules` para projetos em `/Users/luiz.sena88/Projetos`, alinhado com governança de `~/Dotfiles/automation_1password` e melhores práticas de engenharia de contexto.

---

## 📋 Diagnóstico Atual

### ✅ Projetos com .cursorrules (2 encontrados)

1. **`~/Projetos/agent_expert/.cursorrules`**
   - Formato: YAML-like simplificado
   - Context packs definidos
   - CLI agents listados
   - Dependências mapeadas
   - ❌ Sem headers padronizados (Last Updated/Version)
   - ❌ Sem integração com automation_1password

2. **`~/Projetos/01_plataformas/gestora_investimentos/my-frontend/.cursorrules`**
   - Formato: YAML estruturado
   - Focado em Next.js/React
   - Standards, linting, estrutura, performance, observability, security
   - ❌ Sem headers padronizados
   - ❌ Sem referência a automation_1password

### ❌ Projetos sem .cursorrules (maioria)

- **1010+ arquivos README*.md** encontrados, mas apenas **2 .cursorrules**
- Estrutura hierárquica organizada mas sem governança contextual padronizada

### 📁 Estrutura Hierárquica de ~/Projetos

```
~/Projetos/
├── 01_plataformas/          # Plataformas principais
│   ├── agent_expert/
│   ├── app_tributario/
│   ├── gestora_investimentos/
│   └── mfo_platform/
├── 02_agentes_ia/            # Agentes de IA
│   ├── agentkit/
│   ├── bni_contabil_agent/
│   ├── code_review_agent/
│   ├── expert_reforma_tributaria/
│   └── jus_ia/
├── 03_ecossistemas/          # Ecossistemas AI
│   ├── ai_ecosystem/
│   └── huggingface_models/
├── 04_ferramentas_dev/       # Ferramentas de desenvolvimento
├── 05_aplicacoes/            # Aplicações
├── 06_integracao/            # Integrações
├── 07_frontend/              # Frontend
├── 08_configuracao/          # Configurações compartilhadas
│   ├── agents/
│   ├── docs/
│   ├── environments/
│   └── scripts/
├── 09_arquivos/              # Arquivos de backup/dados
│   ├── backups/
│   ├── planilhas/
│   └── temporarios/
├── 10_experimentais/         # Experimentos
│   └── prototypes/
├── 11_X_*                    # Projetos numerados (agent_expert, agentkit, etc.)
└── [projetos soltos na raiz] # agent_expert, app-irpf, etc.
```

---

## 🔧 Template Padronizado

### Template Base para ~/Projetos

```markdown
# .cursorrules - [Nome do Projeto]

# Last Updated: 2025-10-30
# Version: 1.0.0

## Project Overview

[Descrição breve do projeto: objetivo, stack tecnológico, ambiente]

**Repositório Local:** `~/Projetos/[caminho_relativo]`  
**Integração:** `~/Dotfiles/automation_1password` (governança centralizada)

## Governance Inheritance

Este projeto herda governança de `~/Dotfiles/automation_1password/.cursorrules`:
- **Padrões de data:** Last Updated: YYYY-MM-DD, Version: X.Y.Z (Semantic Versioning)
- **Segurança:** Secrets via 1Password CLI (`op://`), nunca hardcoded
- **Scripts Shell:** `set -euo pipefail`, idempotência obrigatória
- **Documentação:** Headers padronizados em todos `.md` críticos

## Context Packs (Project-Specific)

context:
  priority_high:
    - ./src/**
    - ./docs/**
    - ./scripts/**
    - ./config/**
  
  priority_medium:
    - ./tests/**
    - ./examples/**
  
  exclusions:
    - ./node_modules/**
    - ./dist/**
    - ./build/**
    - ./**/*.log
    - ./**/.env
    - ./**/credentials.json

## Integration with automation_1password

### Shared Secrets Management
- Use vaults: `1p_macos` (DEV) ou `1p_vps` (PROD)
- Template pattern: `templates/env/*.secrets.env.op`
- Injection: `op inject -i template.env.op -o .env`
- Never commit: `.env`, `credentials.json`, tokens

### Shared Scripts (Optional)
Reference: `~/Dotfiles/automation_1password/scripts/`
- `scripts/secrets/inject_secrets_macos.sh` — Injeção de secrets
- `scripts/validation/validate_architecture.sh` — Validação

### Architecture Snapshot (When Needed)
Reference: `~/Dotfiles/automation_1password/exports/architecture_system_snapshot_YYYYMMDD.md`
- Use for: LLM context ingestion, full system state
- Current: `architecture_system_snapshot_20251030.md` (6114 lines, 232 KB)

## Code Style and Conventions

### [Stack-Specific Rules]
[Ex: TypeScript strict, React hooks, Python type hints, etc.]

### Documentation
- Use Markdown with headers: `Last Updated: YYYY-MM-DD`, `Version: X.Y.Z`
- Include code examples with syntax highlighting
- Provide step-by-step instructions
- Add troubleshooting sections

## Security Best Practices

### Secrets Management
- Never commit `.env`, `credentials.json`, or certificate files
- Always use `op://` references via 1Password CLI
- Use restrictive file permissions (600 for sensitive files)
- Validate all inputs

## Apple Silicon Optimizations (if applicable)

- Prioritize ARM64 native images over x86_64/amd64
- Use Docker with `platform: linux/arm64` when applicable
- Test on M1/M2/M3 chips

## AI Assistant Instructions

When helping with this project:

1. Consider Apple Silicon optimizations (if applicable)
2. Prioritize security in all suggestions
3. Reference shared governance from `~/Dotfiles/automation_1password`
4. Use 1Password CLI for secrets (`op://` syntax)
5. Follow project-specific code style conventions
6. Maintain documentation headers (Last Updated/Version)
7. Include error handling and validation
8. Provide complete, tested code examples
```

---

## 📐 Padronização por Categoria

### 🔵 Categoria: Agentes de IA (02_agentes_ia/, 11_X_agent*)

**Características:**
- Agentes OpenAI/Anthropic/Gemini
- Uso intensivo de LLMs e prompts
- Integração com 1Password para API keys
- Context packs: `./prompts/`, `./policies/`, `./docs/`

**Template específico:** `cursorrules_template_agent.md`

### 🟢 Categoria: Plataformas (01_plataformas/)

**Características:**
- Stack full-stack (frontend + backend + database)
- Deploy DEV/PROD
- Integração Docker/1Password Connect
- Context packs: `./src/`, `./api/`, `./docker-compose.yml`

**Template específico:** `cursorrules_template_platform.md`

### 🟡 Categoria: Frontend (07_frontend/, projetos Next.js/React)

**Características:**
- Componentes React/Next.js
- TypeScript strict
- Performance e observability
- Context packs: `./src/components/`, `./src/pages/`, `./src/hooks/`

**Template específico:** `cursorrules_template_frontend.md`

### 🟣 Categoria: Ferramentas/Utilitários (04_ferramentas_dev/, 08_configuracao/)

**Características:**
- Scripts de automação
- Configurações compartilhadas
- Integração com automation_1password
- Context packs: `./scripts/`, `./config/`

**Template específico:** `cursorrules_template_tool.md`

---

## 🚀 Plano de Implementação

### Fase 1: Projetos Críticos (Prioridade Alta)

1. **11_1_agent_expert** — Já possui `.cursorrules`, atualizar com template padronizado
2. **11_2_agentkit** — Criar `.cursorrules` do zero
3. **12_bni_contabil_completo** — Criar `.cursorrules` (projeto contábil crítico)
4. **01_plataformas/gestora_investimentos/** — Expandir para todos subprojetos

### Fase 2: Categorias Organizadas

5. Criar `.cursorrules` para todos em `02_agentes_ia/`
6. Criar `.cursorrules` para todos em `01_plataformas/`
7. Criar `.cursorrules` para todos em `07_frontend/`

### Fase 3: Padronização Completa

8. Script automatizado: `~/Dotfiles/automation_1password/scripts/projetos/sync_cursorrules.sh`
   - Detecta projetos sem `.cursorrules`
   - Gera baseado em categoria/tipo
   - Atualiza headers padronizados
   - Valida integração com automation_1password

---

## 📝 Script de Sincronização Automatizada

**Path sugerido:** `~/Dotfiles/automation_1password/scripts/projetos/sync_cursorrules.sh`

**Funcionalidades:**
- Varredura recursiva de `~/Projetos/`
- Detecção de projetos sem `.cursorrules`
- Geração automática baseada em:
  - Presença de `package.json` → Frontend/Node.js
  - Presença de `requirements.txt` → Python
  - Presença de `docker-compose.yml` → Plataforma/Stack
  - Diretório em `02_agentes_ia/` → Agente IA
- Validação de headers padronizados
- Integração com `automation_1password` (referências corretas)
- Backup de `.cursorrules` existentes antes de atualizar

---

## ✅ Checklist de Validação

Para cada projeto em `~/Projetos/`:

- [ ] Possui `.cursorrules` na raiz
- [ ] Headers padronizados (Last Updated, Version)
- [ ] Integração com `~/Dotfiles/automation_1password` documentada
- [ ] Context packs definidos (priority_high, priority_medium, exclusions)
- [ ] Secrets management via 1Password (`op://`) referenciado
- [ ] Code style conventions específicas do stack
- [ ] Security best practices aplicadas
- [ ] Referência ao snapshot de arquitetura quando relevante

---

**Última atualização:** 2025-10-30  
**Versão:** 2.0.0  
**Gerado por:** Sistema de auditoria automation_1password

