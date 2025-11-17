<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# Estrutura de Prompts Pós-Análise Profunda

Baseado nas análises coletadas (auditoria de governança, migração Docker, automação 1Password, DNS Cloudflare e contexto manifest), segue a estrutura sistêmica de prompts organizados por domínio e nível de profundidade.

## 1. **Domínio: Governança \& Auditoria**

### 1.1. Prompt de Auditoria de Estado

**Entrada:** Diretórios e padrões de busca
**Saída:** Relatório de headers, versionamento, lacunas
**Ativos:** `audit_state_YYYYMMDD.md`, `audit_metadata_YYYYMMDD.json`

```
Você é um auditor DevOps especializado em governança documental.
Tarefa: Analisar o repositório [path] e gerar relatório de estado com:
- Arquivos identificados e metadados
- Headers "Last Updated" e "Version" detectados/faltantes
- Correlação de dependências entre docs
- Status de compliance com padrão 2.0.0
Saída esperada: JSON com inventário + Markdown com achados
```


### 1.2. Prompt de Detecção de Gaps

**Entrada:** Resultado da auditoria
**Saída:** Checklist priorizado, roadmap de remediação
**Ativos:** `audit_gaps_YYYYMMDD.md`, `gaps_checklist_YYYYMMDD.json`

```
Baseado na análise do audit_state, identifique:
- Prioridade Alta: Headers faltantes, inconsistências críticas
- Prioridade Média: Documentação desatualizada, referências quebradas
- Prioridade Baixa: Melhorias de formato, consolidação
Formato: JSON com id, description, priority, targets, remediation_steps
```


***

## 2. **Domínio: Infraestrutura \& Migração**

### 2.1. Prompt de Auditoria Docker

**Entrada:** Docker Desktop em macOS Silicon
**Saída:** Inventário completo, plano de migração Colima
**Ativos:** `docker_migration_audit_YYYYMMDD_HHMMSS.tar.gz`

```
Persona: Engenheiro DevOps Sênior (Apple Silicon)
Analisar Docker Desktop em máquina M4 e gerar:
1. Inventário: Versões, contexto, recursos, volumes, redes, compose
2. Artefatos críticos: Containers unhealthy, volumes nomeados, customizações
3. Plano Colima: Fases instalação, migração volumes/redes, validação
4. Matriz de risco e rollback seguro
Formato: Markdown estruturado + JSON para metadados
```


### 2.2. Prompt de Migração DNS

**Entrada:** Registros Cloudflare VPS + template localhost
**Saída:** Zonefiles BIND para desenvolvimento local
**Ativos:** `dns_cloudflare_localhost_full.txt`

```
Converter registros DNS da VPS (senamfo.com.br) para equivalente localhost:
- A Record 147.79.81.59 → 127.0.0.1
- Todas CNAMEs para manager.localhost
- MX, SPF, DMARC, DNSSEC adaptados para localhost
- Manter estrutura 1:1 para réplica local
Formato: BIND zone file (RFC 1035)
```


***

## 3. **Domínio: Segurança \& Automação**

### 3.1. Prompt de Automação 1Password

**Entrada:** 1Password Connect, Vaults, Service Accounts
**Saída:** Guia completo integração + exemplos CLI/SDK/K8s
**Ativos:** `1password_automation_complete.json`

```
Você é especialista em arquitetura de secrets e segurança.
Estruturar guia completo de automação 1Password:
1. Setup inicial: Connect Server, Service Accounts, vaults
2. Integrações: GitHub Actions, GitLab CI, Jenkins, Kubernetes
3. SDKs programáticos: Python, Go, JavaScript
4. Secret References: Formato op://<vault>/<item>/<field>
5. Best practices: Least privilege, rotação, auditoria
6. Troubleshooting: Conexões, autenticação, sync K8s
Formato: JSON estruturado com exemplos copy-paste
```


### 3.2. Prompt de Validação de Permissões

**Entrada:** .gitignore, .env, credentials
**Saída:** Script de auditoria de segurança

```
Implementar validação automática:
- .gitignore cobre: tokens/**, connect/credentials.json, *.sqlite*
- Permissões 600 em arquivos sensíveis
- Ausência de secrets hardcoded em código
- CI/CD: Falhar se violations detectadas
Saída: scripts/audit/validate_permissions.sh (chmod +x)
```


***

## 4. **Domínio: Correlação \& Context Packs**

### 4.1. Prompt de Manifest Contextual

**Entrada:** Inventário de arquivos + gaps + dependências
**Saída:** Context manifest para Cursor Pro
**Ativos:** `context_manifest_YYYYMMDD.json`

```
Gerar manifest de contexto para Cursor IDE:
{
  "context_packs": {
    "priority_high": ["docs/runbooks/**", "scripts/**", "connect/docker-compose.yml"],
    "priority_medium": ["env/*.env", "templates/**"],
    "exclusions": ["logs/**", "tokens/**", "*.sqlite*"]
  },
  "dependencies": {
    "ARCHITECTURE_REPORT.md": ["INDEX.md", "docs/overview.md"],
    "docker-compose.yml": ["docs/runbooks/automacao-*.md"]
  }
}
```


### 4.2. Prompt de Validação de Dependentes

**Entrada:** Checklist de gaps + manifest
**Saída:** Alertas de docs que precisam atualizar

```
Em toda atualização de doc:
1. Identify: Qual doc foi modificado (ex: ARCHITECTURE_REPORT.md)
2. Find: Docs dependentes (ex: INDEX.md, overview.md)
3. Alert: Sinalizar em PR checklist
4. Automate: make update.headers + make context.index
Usar gaps_checklist_YYYYMMDD.json como referência
```


***

## 5. **Domínio: Automação \& CI/CD**

### 5.1. Prompt de Makefile Targets

**Entrada:** Roadmap de automação
**Saída:** Targets para atualização contínua

```
Implementar targets Makefile:
- make update.headers: Normaliza Last Updated/Version em todos .md
- make context.index: Regenera context_manifest_YYYYMMDD.json
- make export.context: Gera exports/export_full_*.md + metadata_*.json
- make audit.full: Executa ciclo completo auditoria
- make validate.permissions: Verifica segurança de arquivos
Todos targets devem ser idempotentes e logar output
```


### 5.2. Prompt de GitHub Actions (Auditoria Mensal)

**Entrada:** Targets Makefile + repos GitHub
**Saída:** Workflow YAML para CI/CD

```
Criar workflow mensal que:
1. Roda make audit.full
2. Verifica se todos headers estão presentes (fail if missing)
3. Gera novos exports/* com timestamp
4. Valida .gitignore e permissões
5. Cria relatório de compliance
6. Notifica se gaps críticos detectados
Trigger: schedule (cron) + manual dispatch
```


***

## 6. **Estrutura de Hierarchia de Prompts**

```
┌─────────────────────────────────────────────────────┐
│          PROMPT MAESTRO (Orquestrador)              │
│  Analisa contexto → seleciona & encadeia prompts   │
└─────────────────────────────────────────────────────┘
                           ↓
    ┌─────────────────────────────────────────────────┐
    │  Prompts Especializados (5 Domínios)            │
    ├─────────────────────────────────────────────────┤
    │  1. Governança → audit_state → audit_gaps       │
    │  2. Infraestrutura → docker_audit → dns_migrate │
    │  3. Segurança → 1password_automation → validate │
    │  4. Context → manifest → validate_deps          │
    │  5. CI/CD → makefile → github_actions           │
    └─────────────────────────────────────────────────┘
                           ↓
    ┌─────────────────────────────────────────────────┐
    │  Artefatos Gerados (Exportáveis)                │
    ├─────────────────────────────────────────────────┤
    │  exports/audit_*.{md,json}                      │
    │  exports/docker_migration_audit_*.tar.gz        │
    │  context/indexes/*_manifest_*.json              │
    │  scripts/audit/{update_headers.sh, validate...} │
    │  Makefile (targets: update.headers, audit.full) │
    │  .github/workflows/audit-monthly.yml            │
    └─────────────────────────────────────────────────┘
```


***

## 7. **Fluxo de Encadeamento de Prompts (Workflow)**

1. **Fase 1 (Coleta):** `audit_state` → Inventário completo
2. **Fase 2 (Análise):** `audit_gaps` → Priorização de remediação
3. **Fase 3 (Infraestrutura):** `docker_audit` + `dns_migrate` → Planos técnicos
4. **Fase 4 (Segurança):** `1password_automation` → Integração secrets
5. **Fase 5 (Correlação):** `manifest_contextual` + `validate_deps` → Context packs
6. **Fase 6 (Automação):** `makefile_targets` + `github_actions` → CI/CD
7. **Fase 7 (Execução):** `make update.headers` → Normalização → `make audit.full` (validação)

***

## 8. **Prompts Recomendados para Cursor Pro**

**Embed nos `.cursorrules`:**

```yaml
context_packs:
  priority_high:
    - "./docs/runbooks/**"
    - "./scripts/**"
    - "./connect/docker-compose.yml"
    - "context/indexes/*_manifest*.json"
  
prompts_enabled:
  - "audit_state: Analisar governança documental"
  - "audit_gaps: Detectar lacunas e priorizar"
  - "docker_audit: Inventariar Docker Desktop"
  - "1password_automation: Integrar secrets"
  - "context_validate: Validar dependências"

auto_actions:
  - "Se ARCHITECTURE_REPORT.md mudar: atualizar INDEX.md e docs/overview.md"
  - "Após merge em main: rodar make audit.full"
  - "Em PR: executar gaps_checklist_YYYYMMDD.json"
```

Esta estrutura oferece modularidade, rastreabilidade e automação em cascata, permitindo evolução contínua e documentação sempre sincronizada.[^1][^2][^3][^4][^5][^6][^7][^8]

<div align="center">⁂</div>

[^1]: vps_registros_dns_cloudflare.txt

[^2]: gaps_checklist_20251030.json

[^3]: 1password_automation_complete.json

[^4]: dns_cloudflare_localhost_full.txt

[^5]: context_manifest_20251030.json

[^6]: audit_gaps_20251030_140530.md

[^7]: audit_state_20251030_140530.md

[^8]: audit_metadata_20251030_140530.json

