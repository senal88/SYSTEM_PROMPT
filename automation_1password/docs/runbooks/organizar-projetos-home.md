# 🗂️ Runbook — Organização Modular do Diretório `~/`

**Last Updated:** 2025-10-30  
**Version:** 2.0.0  
**Autor:** Automação Cursor ↔️ automation_1password

---

## 🎯 Objetivo

Registrar o plano de ação completo para organizar, limpar e padronizar os projetos localizados em `~/`, com foco especial em `~/Projetos`. O runbook lista módulos independentes, prontos para execução incremental ou em lote, permitindo rastreabilidade e ingestão por LLMs.

---

## 🧩 Módulos do Plano de Ação

### M1 — Revisão de Escopo
- Artefatos: `exports/projetos_analysis_20251030_204426.json`, `exports/projetos_cursorrules_execution_report_20251030.md`
- Ações:
  1. Validar estatísticas (61 projetos legítimos, 434 incompletos, 29 repos inicializados).
  2. Identificar prioridades (plataformas, agentes IA, ferramentas, frontends).
- Registro: anotações em `exports/projetos_analysis_20251030_204426.log`.

### M2 — Estrutura de Trabalho e Arquivo
- Criar `~/workspace` para projetos ativos e `~/archive/YYYYMM/` para históricos.
- Registrar criação no log `exports/projects_org_execution_YYYYMMDD.log`.

### M3 — Limpeza de Resíduos
- Comandos sugeridos:
  ```bash
  fd -HI "node_modules|__pycache__|.mypy_cache" ~/Projetos -x rm -rf
  find ~ -name ".DS_Store" -delete
  rm -rf ~/.Trash/*
  ```
- Verificar e destruir credenciais antigas (`~/.Trash/1password-credentials*.json`, tokens obsoletos em `~/.docker`).
- Registro: `logs/cleanup_projects_YYYYMMDD.log`.

### M4 — Reorganização Estrutural
- Mover projetos legítimos para `~/workspace/<categoria>/<projeto>` respeitando taxonomia (01_plataformas, 02_agentes_ia...).
- Projetos incompletos ➜ `~/workspace/10_experimentais/prototypes/` ou `~/archive/YYYYMM/`.
- Atualizar paths em `.cursorrules` se necessário.

### M5 — Padronização e Governança
- Checar README.md (headers `Last Updated`, `Version`), `.gitignore`, `.cursorrules` (já sincronizados), estrutura `src/`, `docs/`, `scripts/`, `context/`, `exports/`.
- Centralizar exports/logs nos novos diretórios.
- Atualizar `.cursorrules` com seções para snapshots (`exports/architecture_system_snapshot_YYYYMMDD.md`).

### M6 — Atualização do Makefile
- Adicionar targets ao `Makefile` do automation_1password:
  - `clean.caches`
  - `sync.projects`
  - `snapshot.home`
- Incluir documentação rápida no runbook.

### M7 — Inicialização Git e Primeiro Commit
- Revisar os 29 repositórios recém-`git init`.
- Adicionar README padrão, `.gitignore`, executar `git status` e preparar commit inicial.
- Registrar resultados em `exports/projects_git_init_YYYYMMDD.md`.

### M8 — Runbooks Atualizados
- Criar/atualizar:
  - `docs/runbooks/migracao-docker-desktop-colima.md`
  - `docs/runbooks/organizar-projetos-home.md` (este)
- Cross-link com `INDEX.md` e `README-COMPLETE.md`.

### M9 — Automação Recorrente
- Configurar Launchd (macOS) e Systemd (VPS) para:
  - `clean.caches`
  - `snapshot.home`
  - `validate.organization`
- Registrar agendamentos em `docs/operations/master-plan.md`.

### M10 — Validação Final
- Executar `scripts/validation/validate_organization.sh` (ajustar para trabalhar com `~/workspace`).
- Gerar relatório `exports/projects_org_validation_YYYYMMDD.md` e atualizar `.cursorrules`.

---

## 📦 Artefatos de Registro
| Módulo | Registro Primário | Observações |
|--------|-------------------|-------------|
| M1 | `exports/projetos_analysis_20251030_204426.log` | Escopo, estatísticas |
| M2 | `exports/projects_org_execution_YYYYMMDD.log` | Estruturas criadas |
| M3 | `logs/cleanup_projects_YYYYMMDD.log` | Comandos executados |
| M4 | `exports/move_projects_YYYYMMDD.log` | Mapeamento de relocação |
| M5 | `.cursorrules` | Seções de governança atualizadas |
| M6 | `Makefile` | Novos targets documentados |
| M7 | `exports/projects_git_init_YYYYMMDD.md` | Primeiro commit |
| M8 | `docs/runbooks/*` | Referências cruzadas |
| M9 | `docs/operations/master-plan.md` | Cron/Launchd/Systemd |
| M10 | `exports/projects_org_validation_YYYYMMDD.md` | Validação final |

---

## ✅ Checklist Rápido
- [ ] Revisar relatórios de análise (M1)
- [ ] Criar `~/workspace` e `~/archive/YYYYMM` (M2)
- [ ] Limpar caches e resíduos sensíveis (M3)
- [ ] Reorganizar projetos e atualizar `.cursorrules` (M4–M5)
- [ ] Ajustar Makefile (M6)
- [ ] Revisar repositórios `git init` (M7)
- [ ] Atualizar runbooks (M8)
- [ ] Configurar automação recorrente (M9)
- [ ] Rodar validação final e gerar relatório (M10)

---

## 🔄 Integração com automation_1password
- Seguir padrões definidos em `.cursorrules` (datas, versões, segurança, secrets).
- Utilizar scripts existentes em `scripts/` e atualizar conforme novo layout (`scripts/context`, `scripts/validation`, `scripts/migration`).
- Referenciar snapshots principais: `exports/architecture_system_snapshot_20251030.md`, `exports/system_structure_full_20251030.md`.

---

## 📌 Observações Finais
- Execução pode ser modular; cada módulo deve ser registrado individualmente.
- Antes de remover arquivos sensíveis, garantir backup conforme governança.
- Atualizar `INDEX.md` após concluir reorganização para refletir novo layout.

---

**Fim do runbook.**
