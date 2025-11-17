Last Updated: 2025-10-30
Version: 2.0.0
# Runbook — Automação com Cursor Pro (Context Packs, Agentes CLI, Correlação)

## 🎯 Objetivo
Padronizar o uso do Cursor Pro no projeto, com context packs priorizados, agentes CLI, workflow de correlação entre documentos e integração com CI. Garantir governança, rastreabilidade e atualização automática de headers e manifestos.

---

## 🧩 Context Packs (.cursorrules)

- Prioridades recomendadas:
  - priority_high:
    - `./context/curated/**`
    - `./docs/runbooks/**`
    - `./scripts/**`
    - `./connect/docker-compose.yml`
  - priority_medium:
    - `./env/*.env`
    - `./templates/**`
    - `./docs/operations/**`
  - exclusions:
    - `./logs/**`
    - `./connect/data/**`
    - `./tokens/**`
    - `./**/*.sqlite*`

- Boas práticas:
  - Não incluir dados sensíveis nos packs (seguir .gitignore).
  - Agrupar por função (runbooks, scripts, infra) e manter baixa ambiguidade.
  - Revisar packs quando novos diretórios entrarem na governança.

---

## 🧪 Workflow de Correlação (Atualização em Cadeia)

Sempre que um documento crítico for alterado:
1) `make update.headers`
2) `make context.index`
3) `make export.context`
4) Conferir `context/indexes/gaps_checklist_YYYYMMDD.json`

Arquivos normalmente correlatos:
- `ARCHITECTURE_REPORT.md` → `INDEX.md` e `docs/overview.md`
- `README-COMPLETE.md` → `INDEX.md` e `docs/runbooks/*`
- Mudanças em `scripts/**` → revisar `docs/runbooks/*` e `cursor-ide-config.md`

---

## ⚙️ Agentes CLI (padrões)

- context-builder: gera índices/manifestos de contexto
  - Output: `context/indexes/context_manifest_YYYYMMDD.json`
- validator: valida dependências, permissões, arquitetura
  - Logs: `logs/validate_*_YYYYMMDD_HHMMSS.log`
- 1password-deployer: materializa segredos e valida Connect
  - Respeitar: “NUNCA copie segredos; use op/op inject/op read.”
- backup-manager: backups e rotação com MANIFEST
  - Dir: `.backups/backup-<op>-<timestamp>/`
- sync-agent: sincronização DEV↔PROD (com exclusões críticas)

Requisitos gerais:
- Logs em `logs/`
- Manifestos Markdown + JSON
- Idempotência e `set -euo pipefail` nos scripts

---

## 🛠️ Makefile — Alvos Recomendados

- `make update.headers` — atualiza headers Last Updated/Version em lote
- `make context.index` — gera/atualiza manifestos de contexto
- `make export.context` — exporta inventário e metadados (para LLM)
- `make validate.all` — valida deps, permissões e arquitetura
- `make audit.full` — auditoria completa (mensal/PR crítico)

Execução manual (exemplo):
```bash
DATE=$(date +%F)
make update.headers
make context.index
make export.context
```

---

## 🔐 Segurança & Compliance

- .gitignore mínimo:
  - `connect/credentials.json`, `connect/.env`, `connect/certs/*`, `tokens/*`, `*.sqlite*`, `logs/*`, `.DS_Store`
- Permissões:
  - Seguros: `chmod 600` (secrets/credenciais)
  - Scripts: `chmod +x scripts/**/*.sh`
- 1Password CLI:
  - DEV: `eval $(op signin)`
  - PROD: `export OP_SERVICE_ACCOUNT_TOKEN="..."`

---

## 🔁 CI/CD (GitHub Actions)

- Job mensal para `make audit.full` (falha se faltar headers padronizados)
- Upload de `exports/` como artefatos
- Gate para PR: validar `gaps_checklist_*.json` e context packs

Exemplo de checagens mínimas (CI):
- Headers presentes e padronizados (Last Updated, Version)
- Packs sem diretórios sensíveis
- Permissões corretas (scripts e secrets)

---

## 🧭 Troubleshooting Rápido

- “Arquivo sem header”: rodar `make update.headers` e confirmar diffs
- “Contexto desatualizado”: rodar `make context.index` e revisar manifesto
- “Exports antigos”: rodar `make export.context`
- “CI falhou por headers”: corrigir docs críticos e reexecutar pipeline

---

## ✅ Checklist Operacional

- [ ] Headers padronizados em principais `.md`
- [ ] Context packs revisados no `.cursorrules`
- [ ] Manifestos atualizados em `context/indexes/`
- [ ] Exports atualizados em `exports/`
- [ ] CI configurado com auditoria mensal e gates de PR

---

## ℹ️ Referências
- `.cursorrules` (governança e packs)
- `exports/audit_state_*.md`, `exports/audit_gaps_*.md`, `exports/audit_metadata_*.json`
- `context/indexes/context_manifest_*.json`, `context/indexes/gaps_checklist_*.json`
- `scripts/audit/update_headers.sh`, `Makefile` (update.headers)
