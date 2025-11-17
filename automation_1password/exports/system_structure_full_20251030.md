Last Updated: 2025-10-30
Version: 2.0.0
# 📁 Estrutura Completa do Sistema — Projeto e Home do Usuário

## 🎯 Escopo

Este documento apresenta a estrutura completa e hierárquica de:
- **Projeto automation_1password**: `/Users/luiz.sena88/Dotfiles/automation_1password`
- **Home do Usuário**: `/Users/luiz.sena88`

---

## 📦 Projeto: automation_1password

**Caminho Base:** `/Users/luiz.sena88/Dotfiles/automation_1password`

### 🔹 Nível 0 — Raiz do Projeto

```
automation_1password/
├── 📄 .cursorrules                    # Governança Cursor AI (Last Updated: 2025-10-30)
├── 📄 .gitignore                      # Proteção de secrets e arquivos sensíveis
├── 📄 README-COMPLETE.md             # ⭐ Documentação principal (755 linhas)
├── 📄 INDEX.md                        # ⭐ Índice hierárquico de navegação
├── 📄 ARCHITECTURE_REPORT.md          # Relatório de arquitetura atual
├── 📄 cursor-ide-config.md            # Configuração Cursor IDE
├── 📄 Makefile                        # Comandos automatizados (update.headers, etc.)
│
├── 📄 IMPLEMENTACAO_COMPLETA.md      # Status da implementação
├── 📄 RESUMO_CORRECOES_ARQUITETURA.md # Correções arquiteturais
├── 📄 RESUMO_CLEANUP_20251029.md     # Limpeza executada (Last Updated: 2025-10-30)
│
├── 📂 .backups/                       # Backups rotacionados
│   └── cleanup-20251029-181817/      # Backup de limpeza com MANIFEST.txt
│
├── 📂 .devcontainer/                  # Dev container config
│   └── devcontainer.json
│
├── 📂 .github/                        # GitHub Actions e templates
│   └── dependabot.yml
│
├── 📂 .vscode/                        # Configurações VSCode/Cursor
│   ├── settings.json
│   └── tasks.json
│
└── 📂 1Password.opvault/             # Vault local (macOS)
    └── default/
        ├── band_A.js
        └── profile.js
```

### 🔹 Nível 1 — Diretórios Principais

#### 📂 `connect/` — 1Password Connect Server

```
connect/
├── docker-compose.yml                 # ⭐ Stack Docker (v3.8+, linux/arm64)
├── .env                               # Variáveis ambiente (gitignored, 600)
├── credentials.json                   # Credenciais 1Password (gitignored, 600)
├── .gitignore                         # Proteção local
├── Makefile                           # Comandos Connect
├── validate-and-deploy.sh             # Validação completa e deploy
├── vps-setup.sh                       # Setup para VPS
├── dns.template.env                    # Template DNS (600)
│
├── certs/                             # Certificados TLS (gitignored)
│   └── .gitkeep
│
├── data/                              # Dados persistentes
│   ├── 1password.sqlite               # Database
│   ├── 1password.sqlite-shm
│   ├── 1password.sqlite-wal
│   ├── files/
│   └── .gitkeep
│
└── macos_connect_server/             # Configs específicas macOS
```

#### 📂 `configs/` — Configurações Globais

```
configs/
├── 1password_automation_complete.json
├── template.env.op                    # Template 1Password
├── dns_cloudflare_localhost_full.txt
├── dns_cloudflare_localhost_template.txt
├── marketplace.1password.com_24th_Oct_2025.txt
└── vps_registros_dns_cloudflare.txt
```

#### 📂 `scripts/` — Automação

```
scripts/
├── audit/                             # Scripts de auditoria
│   ├── audit_full.sh
│   ├── audit_docker_migration.sh
│   ├── collect_metadata.sh
│   ├── validate_dependencies.sh
│   ├── validate_permissions.sh
│   └── update_headers.sh              # ⭐ Normalização de headers
│
├── bootstrap/                         # Setup inicial
│   ├── setup-macos-complete.sh
│   ├── setup-vps-complete.sh
│   ├── init_1password_macos.sh
│   ├── init_1password_ubuntu.sh
│   ├── bashrc_1password_config.sh
│   └── zshrc_1password_config.sh
│
├── connect/                           # Scripts Connect
│   ├── setup-connect-local.sh
│   ├── setup-connect-complete.sh
│   ├── setup-1password-connect-secure.sh
│   ├── start-connect.sh
│   └── stop-connect.sh
│
├── context/                           # Gerenciamento de contexto
│   ├── build_index.sh
│   ├── new_context_note.sh
│   └── validate_env_paths.sh
│
├── maintenance/                       # Manutenção
│   ├── cleanup-obsolete-files.sh
│   └── rotate_logs.sh
│
├── migration/                         # Migração Docker → Colima
│   └── migrate_docker_desktop_to_colima.sh
│
├── secrets/                           # Gerenciamento de secrets
│   ├── inject_secrets_macos.sh
│   ├── inject_secrets_ubuntu.sh
│   ├── load-secure-env.sh
│   ├── load-infra-env.sh
│   ├── export_1password_env.sh
│   └── sync_1password_env.sh
│
├── validation/                        # Validação e testes
│   ├── validate_architecture.sh
│   ├── validate_environment_macos.sh
│   ├── validate_organization.sh
│   └── validate-setup.sh
│
└── export_architecture.sh             # Exportação de arquitetura
```

#### 📂 `docs/` — Documentação

```
docs/
├── README.md                          # ⭐ Índice de documentação
├── overview.md                        # Visão geral técnica
│
├── operations/                        # Runbooks operacionais
│   ├── dns-records.md
│   ├── integracao-docker-traefik.md
│   ├── direnv-op-workflow.md
│   ├── master-plan.md
│   └── analisar_adequar_automation_1password/
│       ├── master-setup.sh
│       ├── organize-project.sh
│       └── IMPLEMENTATION-SCRIPTS.md
│
├── runbooks/                          # Runbooks detalhados
│   ├── automacao-macos.md            # ⭐ Last Updated: 2025-10-30
│   ├── automacao-vps.md              # ⭐ Last Updated: 2025-10-30
│   ├── automacao-dual.md             # ⭐ Last Updated: 2025-10-30
│   └── automacao-cursor-pro.md       # ⭐ Runbook Cursor Pro
│
├── prompts/                           # Prompts para IA
│   ├── agent-expert.md
│   ├── prompt_codex_automation_1password_macos.md
│   ├── prompt_guia-nomenclatura-1p.md
│   ├── sumarizar_versao_final.md     # ⭐ Last Updated: 2025-10-30
│   └── [outros prompts]
│
└── archive/                           # Documentação histórica
    ├── 1password-automacao-completa.pdf
    ├── processo-unico-implantacao.pdf
    ├── volumes-raycast-investigar.md
    └── [outros arquivos]
```

#### 📂 `env/` — Variáveis de Ambiente

```
env/
├── README.md                          # ⭐ Documentação do módulo (Last Updated: 2025-10-30)
├── shared.env                         # Configurações globais
├── macos.env                          # Configurações macOS
├── vps.env                            # Configurações VPS
└── infra.example.env.op               # Template infraestrutura
```

#### 📂 `templates/` — Templates com Referências 1Password

```
templates/
└── env/
    ├── macos.secrets.env.op           # Template macOS (op://)
    └── vps.secrets.env.op             # Template VPS (op://)
```

#### 📂 `tokens/` — Gerenciamento de Tokens

```
tokens/
├── README.md                          # ⭐ Documentação do módulo
├── CONFIGURACAO_TOKENS.md             # Configuração detalhada
├── tokens-summary.json                # Resumo de tokens (gitignored)
├── configure-1password-with-token.sh
├── configure-both-tokens.sh
├── extract-tokens.sh
├── test-installation.sh
└── .gitignore                         # Proteção de tokens
```

#### 📂 `context/` — Contexto e Índices

```
context/
├── curated/                           # Contextos curados e validados
├── datasets/                          # Datasets organizados
├── decisions/                         # Decisões arquiteturais (ADRs)
├── embeddings/                        # Embeddings para RAG
├── indexes/                           # ⭐ Índices e manifestos
│   ├── context_manifest_20251030.json
│   ├── gaps_checklist_20251030.json
│   └── context_full_20251030.json    # ⭐ Manifesto completo para LLM
├── metadata/                          # Schemas e templates
│   └── schemas/
│       └── context_note_template.md
├── playbooks/                         # Playbooks operacionais
├── prompts/                           # Prompts de engenharia
│   └── prompt_recurrent_audit_v2_2025_10_30.md
├── raw/                               # Dados brutos (chats, uploads, snippets)
│   ├── chats/
│   └── uploads/
└── workspace/                         # Workspace temporário
```

#### 📂 `exports/` — Exports e Relatórios

```
exports/
├── architecture_system_snapshot_20251030.md  # ⭐ Snapshot consolidado (6114 linhas, 232 KB)
│                                               SHA-256: 59ba13544e81bb6e6a18a22e5928e7a098750dfba54d7738f4a59077181150d6
├── audit_state_20251030_140530.md            # Estado de auditoria
├── audit_gaps_20251030_140530.md             # Relatório de lacunas
├── audit_metadata_20251030_140530.json       # Metadados estruturados
├── export_full_20251030_112212.md            # Export completo
├── metadata_20251030_112252.json             # Metadados anterior
├── docker_migration_audit_20251030_135931.tar.gz  # Bundle de auditoria Docker
├── migration_run_20251030_161230/            # Execução de migração
│   ├── migration.log
│   ├── compose_inventory.txt
│   └── volume_backups/
└── _audit_tmp/                               # Temporários de auditoria
```

#### 📂 `logs/` — Logs de Execução

```
logs/
├── validate_permissions_20251030_112229.log
├── validate_dependencies_20251030_112241.log
└── .gitkeep
```

#### 📂 `organized/` — Documentação Organizada

```
organized/
├── README.md                          # ⭐ Last Updated: 2025-10-30
└── ORGANIZACAO_CONCLUIDA.md
```

---

## 🏠 Home do Usuário: /Users/luiz.sena88

### 🔹 Diretórios de Configuração e Cache

```
~/
├── .1password/                        # Cache e dados 1Password
├── .azure/                            # Configurações Azure
├── .bundle/                           # Ruby bundler
├── .cache/                            # Caches diversos
│   ├── colima/
│   └── [outros]
├── .codex/                            # Codex caches
├── .colima/                           # ⭐ Perfis Colima
│   └── default/                       # Perfil default (pós-migração)
├── .config/                           # Configurações de aplicativos
│   ├── 1password/
│   └── [outros]
├── .cursor/                           # Cache e dados Cursor IDE
├── .docker/                           # ⭐ Configurações Docker
│   ├── config.json                    # (credsStore atualizado para osxkeychain)
│   └── run/
│       └── docker.sock                # Socket Docker
├── .gemini/                           # Gemini Assistant caches
└── [outros diretórios de configuração]
```

### 🔹 Projetos Ativos

```
~/
├── Dotfiles/                          # ⭐ Repositórios Dotfiles
│   └── automation_1password/         # Este projeto
├── cursor-automation-framework/       # Framework de automação Cursor
├── docker_cli/                        # Scripts e configs Docker CLI
├── infra/                             # Infraestrutura e IaC
├── rclone/                            # Configurações Rclone
├── scripts/                           # Scripts isolados
│   ├── generate_ai_context.sh
│   └── sync_1password_env.sh
└── [outros projetos]
```

### 🔹 Artefatos e Revisão

```
~/
├── .Trash/                            # Lixeira macOS
├── database/                          # Databases locais
├── data/                              # Dados diversos
├── shell/                             # Scripts shell personalizados
├── path-architecture.txt               # Documentação de paths
├── urls_openai.csv                    # Dados de URLs OpenAI
└── [outros arquivos na raiz]
```

### 🔹 Observações Importantes

- **Colima**: Perfil `default` criado em `.colima/default/` após migração Docker Desktop → Colima
- **Docker**: Config atualizado em `.docker/config.json` (credsStore: osxkeychain)
- **Contexto Docker**: Atualmente `colima` (após migração)

---

## 📊 Referências Rápidas

### Documentos Principais do Projeto

| Documento | Path | Uso |
|-----------|------|-----|
| **README-COMPLETE.md** | Raiz | Documentação principal completa |
| **INDEX.md** | Raiz | Índice hierárquico de navegação |
| **ARCHITECTURE_REPORT.md** | Raiz | Relatório de arquitetura atual |
| **architecture_system_snapshot_20251030.md** | `exports/` | ⭐ Snapshot consolidado completo (6114 linhas) |
| **context_full_20251030.json** | `context/indexes/` | ⭐ Manifesto completo para LLM |

### Scripts Críticos

| Script | Path | Função |
|--------|------|--------|
| **update_headers.sh** | `scripts/audit/` | Normalização de headers Last Updated/Version |
| **validate-and-deploy.sh** | `connect/` | Validação completa e deploy Connect |
| **migrate_docker_desktop_to_colima.sh** | `scripts/migration/` | Migração automatizada Docker → Colima |

### Comandos Makefile Principais

- `make update.headers` — Atualizar headers padronizados
- `make context.index` — Gerar/atualizar manifestos de contexto
- `make export.context` — Exportar inventário e metadados
- `make validate.all` — Validar deps, permissões e arquitetura

---

**Última atualização:** 2025-10-30  
**Versão:** 2.0.0  
**Gerado por:** Sistema de auditoria e governança automation_1password

