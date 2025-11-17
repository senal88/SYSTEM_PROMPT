# Prompt Recorrente de Auditoria & Governança — v2.0.0

**Tipo:** Recorrente (Executar mensalmente ou quando necessário)  
**Data desta versão:** 2025-10-30  
**Versão:** 2.0.0  
**Autor:** Luiz Sena  
**Path recomendado:** `context/prompts/prompt_recurrent_audit_v2_2025_10_30.md`

---

## 🎯 Objetivo

Executar auditoria completa, atualização de metadados, validação de governança e geração de manifestos/exports rastreáveis para o projeto **automation_1password**, cobrindo ambientes híbridos macOS Silicon (DEV) e VPS Ubuntu (PROD), com integração 1Password CLI, Docker, MCP servers, Cursor Pro, VSCode Copilot Pro e Gemini Assistant.

---

## 📋 Escopo da Auditoria

### 1. Coleta de Estado Atual

**Ação:** Faça varredura recursiva completa (todos os níveis de diretórios e subdiretórios).

**Arquivos alvo:**

- Documentos: `*.md`
- Scripts: `*.sh`
- Configs: `*.yaml`, `*.yml`, `*.json`, `.env`, `.op`
- Context packs: arquivos em `context/`, `docs/`, `scripts/`
- Sensíveis: validar que `tokens/`, `connect/credentials.json`, `.env` estão protegidos

**Output:**

- Tabela estruturada contendo:
  - Nome do arquivo
  - Path completo (absoluto e relativo)
  - Data "Last Updated" (do header do arquivo)
  - Versão (se aplicável)
  - Metadata de criação/modificação (filesystem)
  - Status de proteção (.gitignore, permissões)

**Formato de salvamento:**

```
exports/audit_state_YYYYMMDD_HHMMSS.md
exports/audit_metadata_YYYYMMDD_HHMMSS.json
```

---

### 2. Diagnóstico de Lacunas e Correlação

**Ação:** Relacionar todos artefatos com governança definida em `.cursorrules` e policies.

**Verificações:**

- Datas "Last Updated" fora do padrão atual (2025-10-30)
- Arquivos sem header de versão
- Falta de manifestos/indexes em `context/indexes/`
- Docs sensíveis fora do `.gitignore` ou com permissões incorretas (diferente de 600/700)
- Context packs sem tags/hints apropriados
- Scripts sem validação ou testes
- Backups desatualizados (> 7 dias sem rotação)

**Output:**

- Lista de arquivos críticos para atualização (prioridade alta/média/baixa)
- Diagnóstico de lacunas por diretório
- Recomendações de ação corretiva

**Formato de salvamento:**

```
exports/audit_gaps_YYYYMMDD_HHMMSS.md
context/indexes/gaps_checklist_YYYYMMDD.json
```

---

### 3. Estrutura Modular Ideal

**Ação:** Revisar e propor hierarquia lógica otimizada.

**Componentes:**

#### Documentos Essenciais (máximo 5 artefatos principais):

1. **governanca.md** - Políticas, SLAs, .cursorrules consolidadas, hooks MCP/Cursor
2. **plataforma_automacao.md** - Arquitetura macOS/VPS, agentes, backups, fluxos deploy
3. **operacoes_e_runbooks.md** - Workflows ponta-a-ponta, checklists, troubleshooting
4. **contexto_manifesto.md** - Collections (raw→curated→indexes), pipelines, TTL
5. **llm_interface.md** - Instruções para agentes LLM/Cursor/CLI, prompts-base, parâmetros

#### Segregação de Ambientes:

- **DEV (macOS):**
  - Path: `~/Dotfiles/automation_1password/`
  - Cofre 1Password: `1p_macos`
  - Context tags: `#dev`, `#macos-silicon`, `#local`
- **PROD (VPS Ubuntu):**
  - Path: `/home/luiz.sena88/dev-prod/1password-connect/`
  - Cofre 1Password: `1p_vps`
  - Context tags: `#prod`, `#vps-ubuntu`, `#remote`

#### Packs Contextuais por Função:

```
context/
├── curated/          # Contextos curados e validados
├── datasets/         # Datasets organizados
├── decisions/        # Decisões arquiteturais (ADRs)
├── embeddings/       # Embeddings para RAG
├── indexes/          # Índices e manifestos
├── metadata/         # Schemas e templates
├── playbooks/        # Playbooks operacionais
├── prompts/          # Prompts e templates de engenharia
├── raw/              # Dados brutos (chats, uploads, snippets)
└── workspace/        # Workspace temporário
```

**Output:**

- Proposta de reorganização (se necessário)
- Mapeamento de tags e context hints por diretório
- Checklist de implementação

**Formato de salvamento:**

```
exports/structure_proposal_YYYYMMDD.md
```

---

### 4. Convenção de Salvamento (Padronização)

**Prompts:**

```
context/prompts/prompt_{engine}_{date}_{contexto}.md
Exemplo: prompt_cursor_2025_10_30_docker_migration.md
```

**Respostas de Agentes:**

```
context/raw/chats/chat_{engine}_{date}_{modulo}.md
Exemplo: chat_codex_2025_10_30_audit_results.md
```

**Relatórios e Manifestos:**

```
exports/export_full_{date}.md
exports/metadata_{date}.json
context/indexes/context_manifest_{date}.json
organized/ORGANIZACAO_CONCLUIDA.md
```

**Logs:**

```
logs/{script_name}_{date}.log
Exemplo: logs/validate_permissions_20251030_132000.log
```

**Backups:**

```
.backups/backup-{operation}-{date}/
Exemplo: .backups/backup-cleanup-20251030-140000/
```

---

### 5. Automação e Agentes CLI

**Plano Sequencial (Makefile/Scripts):**

```makefile
# Targets recomendados
make update.headers      # Atualizar "Last Updated" em todos .md principais
make backup.full         # Backup completo com timestamp
make context.index       # Gerar/atualizar manifestos de contexto
make validate.all        # Validar deps, perms, arquitetura
make export.context      # Exportar manifests para ingestão LLM
make sync.vps           # Sincronizar com VPS (rsync)
make health.check        # Health check completo (Docker, 1P, SSH)
```

**Agentes Especializados:**

1. **context-builder** - Gera indexes e manifestos de contexto
2. **validator** - Valida dependências, permissões, arquitetura
3. **1password-deployer** - Materializa secrets e deploy seguro
4. **backup-manager** - Gerencia backups rotacionados
5. **sync-agent** - Sincroniza ambientes DEV↔PROD

**Cada agente deve:**

- Registrar logs em `logs/`
- Gerar manifesto de execução
- Backup automático antes de alterações destrutivas
- Output em formato Markdown + JSON

**Output:**

- Documentação de agentes em `docs/operations/cli_agents.md`
- Exemplos de uso em `docs/runbooks/`

---

### 6. Governança, Segurança e Compliance

**Verificações Obrigatórias:**

#### .gitignore Coverage:

```
connect/credentials.json
connect/.env
connect/certs/*
tokens/*
*.sqlite*
*.log
.DS_Store
```

#### Permissões:

```bash
# Secrets e credentials
chmod 600 connect/credentials.json
chmod 600 .env
chmod 600 tokens/*.json

# Scripts executáveis
chmod +x scripts/**/*.sh

# Diretórios
chmod 755 (diretórios em geral)
chmod 700 tokens/
```

#### 1Password Integration:

```bash
# Autenticação automática ao abrir terminal (.zshrc/.bashrc)
eval $(op signin)

# Materialização segura de secrets
op inject -i templates/env/macos.secrets.env.op -o env/.macos.secrets.env
source env/.macos.secrets.env

# Limpeza após uso (idempotente)
shred -u env/.macos.secrets.env || rm -f env/.macos.secrets.env
```

#### Context Packs (.cursorrules):

```yaml
context_packs:
  priority_high:
    - ./context/curated/**
    - ./docs/runbooks/**
    - ./scripts/**
    - ./connect/docker-compose.yml

  priority_medium:
    - ./env/*.env
    - ./templates/**
    - ./docs/operations/**

  exclusions:
    - ./logs/**
    - ./connect/data/**
    - ./tokens/**
    - ./**/*.sqlite*
```

**Output:**

- Relatório de compliance em `exports/compliance_report_YYYYMMDD.md`
- Checklist de segurança em `organized/security_checklist.md`

---

### 7. Integração Multi-Ambiente (macOS + VPS)

**macOS Silicon (DEV):**

```bash
# Dependências
brew install docker 1password-cli jq shellcheck shfmt yq

# Paths
REPO_ROOT=~/Dotfiles/automation_1password
VAULT=1p_macos

# Automação ao abrir terminal
eval $(op signin)
source $REPO_ROOT/env/shared.env
source $REPO_ROOT/env/macos.env

# Context packs Cursor Pro
cursor --context-pack $REPO_ROOT/context/
```

**VPS Ubuntu (PROD):**

```bash
# Dependências
apt install docker.io docker-compose jq -y

# Paths
REPO_ROOT=/home/luiz.sena88/dev-prod/1password-connect
VAULT=1p_vps

# Service account (sem interação)
export OP_SERVICE_ACCOUNT_TOKEN="ops_xxxxx"

# Automação systemd
systemctl enable --user automation-1password.timer

# Sincronização
rsync -avz --exclude='.git' ~/Dotfiles/automation_1password/ vps:$REPO_ROOT/
```

**Output:**

- Guia de setup em `docs/runbooks/setup_hybrid_environment.md`
- Scripts de sync em `scripts/workflow/sync_dev_prod.sh`

---

### 8. Dependências Atualizadas (Checklist)

#### macOS Silicon:

- [ ] Docker Desktop 4.25+ (ou Colima 0.6+)
- [ ] 1Password CLI 2.32.0+
- [ ] Homebrew (atualizado)
- [ ] jq 1.7+
- [ ] shellcheck 0.9+
- [ ] Node.js 20+ (para MCP servers)
- [ ] Python 3.11+ (para scripts auxiliares)
- [ ] Git 2.42+

#### VPS Ubuntu 22.04:

- [ ] Docker Engine 24.0+
- [ ] Docker Compose v2.20+
- [ ] 1Password CLI 2.32.0+
- [ ] jq, curl, rsync, ssh
- [ ] systemd (timers para automação)
- [ ] Nginx/Traefik (reverse proxy)

#### MCP Servers:

- [ ] @modelcontextprotocol/server-filesystem
- [ ] @modelcontextprotocol/server-github
- [ ] Hugging Face MCP (oficial)
- [ ] Cloudflare MCP (community)

**Validação:**

```bash
make validate.dependencies
# ou
bash scripts/validation/validate_dependencies.sh
```

**Output:**

```
logs/validate_dependencies_YYYYMMDD_HHMMSS.log
exports/dependencies_report_YYYYMMDD.md
```

---

## 📊 Output Final Esperado

### Documentos Gerados:

1. **Tabela de Estado Atual:**

   - `exports/audit_state_YYYYMMDD_HHMMSS.md` (Markdown table)
   - `exports/audit_metadata_YYYYMMDD_HHMMSS.json` (JSON estruturado)

2. **Diagnóstico de Lacunas:**

   - `exports/audit_gaps_YYYYMMDD_HHMMSS.md`
   - Prioridades: Alta/Média/Baixa
   - Ações recomendadas

3. **Proposta de Estrutura:**

   - `exports/structure_proposal_YYYYMMDD.md`
   - Reorganizações necessárias
   - Tags e context hints

4. **Checklist de Implementação:**

   - Por diretório/subdiretório
   - Status: ✅ Completo | 🔨 Em andamento | ❌ Pendente

5. **Manifesto de Contexto:**

   - `context/indexes/context_manifest_YYYYMMDD.json`
   - Collections, pipelines, TTL, responsáveis

6. **Relatórios de Compliance:**

   - `exports/compliance_report_YYYYMMDD.md`
   - Security checklist
   - Permissões, .gitignore, backups

7. **Changelog Consolidado:**
   - `organized/ORGANIZACAO_CONCLUIDA.md`
   - Histórico de mudanças
   - Próximas ações

---

## 🔄 Frequência de Execução

- **Auditoria Completa:** Mensal (ou após mudanças estruturais significativas)
- **Atualização de Headers:** Semanal (automatizado via `make update.headers`)
- **Validação de Segurança:** Diária (via cron/systemd)
- **Backup Full:** Semanal (automatizado)
- **Sync DEV↔PROD:** Sob demanda (após validações)

---

## 🚀 Como Executar Este Prompt

### Método 1: Cursor Pro / VSCode

```
1. Abrir projeto em Cursor Pro
2. Abrir chat/agent
3. Colar este prompt completo
4. Aguardar execução e geração dos outputs
5. Revisar manifestos em exports/
6. Aplicar correções recomendadas
```

### Método 2: CLI (Automatizado)

```bash
cd ~/Dotfiles/automation_1password

# Executar auditoria completa
make audit.full

# Ou script direto
bash scripts/audit/audit_full.sh

# Gerar exports
make export.context
```

### Método 3: GitHub Actions (CI/CD)

```yaml
# .github/workflows/audit.yml
name: Monthly Audit
on:
  schedule:
    - cron: "0 0 1 * *" # 1º dia de cada mês
  workflow_dispatch:

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Audit
        run: make audit.full
      - name: Upload Reports
        uses: actions/upload-artifact@v4
        with:
          name: audit-reports
          path: exports/
```

---

## 📝 Histórico de Versões

| Versão | Data       | Mudanças                                                             |
| ------ | ---------- | -------------------------------------------------------------------- |
| v2.0.0 | 2025-10-30 | Versão completa consolidada com todas diretrizes e melhores práticas |
| v1.0.0 | 2025-10-29 | Versão inicial do prompt de auditoria                                |

---

## 🔗 Referências Relacionadas

- `.cursorrules` - Governança e context packs
- `INDEX.md` - Estrutura hierárquica do projeto
- `ARCHITECTURE_REPORT.md` - Arquitetura técnica
- `docs/operations/master-plan.md` - Plano mestre de operações
- `docs/runbooks/` - Runbooks operacionais

---

**Este prompt é recorrente, versionado e deve ser executado regularmente para garantir governança, rastreabilidade e compliance total do projeto automation_1password em ambientes híbridos macOS Silicon + VPS Ubuntu.**

**Próxima execução recomendada:** 2025-11-30
