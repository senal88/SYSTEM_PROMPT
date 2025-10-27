# 1Password Automation Master Plan

> Status: **Planejamento** · Última atualização: 2025-10-24 21:45 UTC  
> Responsáveis: Equipe InfraOps / Segurança · Repositório: `senal88/automation_1password`

---

## 1. Objetivos
- Centralizar segredos corporativos no 1Password, eliminando credenciais hardcoded.
- Operacionalizar fluxos locais (macOS Silicon) e remotos (VPS Ubuntu) com autenticação segregada.
- Habilitar integrações oficiais (SCIM Bridge, Connect, Device Trust, Slack Alerts, GitHub Actions).
- Garantir conformidade com políticas corporativas (MFA obrigatório, device compliance, auditoria em tempo real).

## 2. Escopo & Premissas
- **Ambientes**: macOS Silicon (admin local com biometria) e VPS Ubuntu 22.04 (infra headless).
- **Vaults**: criação dos cofres `1p_macos` (local) e `1p_vps` (infra remota), além do vault compartilhado `Shared_Integrations`.
- **Sessões**: uso de 1Password CLI v2 com autenticação biométrica local; Service Accounts para automações.
- **Arquivos**: toda a documentação e scripts em formato `.md`/shell, sem geração de `.docx`.
- **Não incluído**: migração de dados legados fora do escopo (ex.: cofres pessoais, integração Okta).

## 3. Arquitetura de Referência
```
macOS (Admin) ─┬─► Raycast + 1Password CLI (Touch ID)
               ├─► direnv + op inject (dev containers)
               └─► GitHub Actions (Service Account Token)

VPS Ubuntu ────► Docker Compose (SCIM Bridge + Connect Server)
               └─► Event Reporting → Slack / Panther SIEM
```

## 4. Design dos Vaults `1p_macos` e `1p_vps`
| Vault | Categoria | Item | Campo | Prefixo variável |
|-------|-----------|------|-------|------------------|
| `1p_macos` | CLI Local | `CLI_Biometric_Seed` | `credential` | `LOCAL_OP_SESSION_SEED` |
| `1p_macos` | Automação Local | `Raycast_Access_Token_macos` (opc.) | `credential` | `LOCAL_RAYCAST_TOKEN` |
| `1p_vps` | Service Accounts | `ServiceAccount_vps` | `credential` | `VPS_OP_SERVICE_ACCOUNT_TOKEN` |
| `1p_vps` | SCIM Bridge | `SCIM_Bearer_vps` | `credential` | `VPS_SCIM_TOKEN` |
| `1p_vps` | Connect Server | `Connect_API_vps` | `credential` | `VPS_CONNECT_TOKEN` |
| `1p_vps` | Integrations | `Slack_Webhook_vps` | `url` | `VPS_SLACK_SECURITY_WEBHOOK` |
| `1p_vps` | Compliance | `Panther_API_vps` | `credential` | `VPS_PANTHER_API_KEY` |

**Políticas:**  
- Prefixos obrigatórios por ambiente (`LOCAL_`, `VPS_`, `CI_`).  
- Itens com tags `automation`, `rotation:90d`.  
- Campos customizados documentados em `configs/template.env.op`.

## 5. Integrações Obrigatórias
| Área | Integração | Ação Preparatória |
|------|------------|-------------------|
| Provisioning | SCIM Bridge (Docker) | Gerar `scimsession`; armazenar `SCIM_SESSION_FILE` em vault; planejar TLS via Traefik. |
| Secrets API | 1Password Connect | Definir host `connect.production`; usar token dedicado no vault; mapear roles. |
| Device Trust | macOS + Ubuntu | Instalar Device Trust Agent; validar compatibilidade MDM/Kolide. |
| Alertas | Slack Notifications | Configurar canais `#security-alerts`, `#it-approvals`, `#audit-logs`. |
| Auditoria | Events Reporting API | Registrar webhook SIEM Panther; definir filtros (login.failed, device.non_compliant). |
| CI/CD | GitHub Actions | Adicionar segredo `OP_SERVICE_ACCOUNT_TOKEN`; incluir arquivo `.github/secrets.mappings`. |
| Insights | Breach Monitoring | Habilitar Insights → e-mail + Slack para incidentes. |

## 6. Planos por Ambiente

### 6.1 macOS Silicon
1. Validar 1Password CLI (`op --version`, `op account list`).
2. Autenticar via Touch ID (`op signin --account <apelido>`).
3. Executar `scripts/export_1password_env.sh` para gerar `configs/.env.generated`.
4. Configurar `direnv` com `use_1password_env` conforme `docs/direnv-op-workflow.md`.
5. Revisar runbooks Raycast para acionar scripts (`init_1password_macos.sh`, `inject_secrets_macos.sh`).
6. Registrar Device Trust Agent e Extended Compliance (100 checks) com base no blog oficial.

### 6.2 VPS Ubuntu 22.04
1. Provisionar host com Docker e UFW (22/80/443).
2. Implantar SCIM Bridge:
   ```bash
   docker run -d --name op-scim \
     -p 8080:8080 \
     -v /opt/1password/scim:/etc/scim \
     -e SCIM_SESSION_FILE=/etc/scim/scimsession \
     -e SCIM_BEARER_TOKEN=$(op read 'op://1p_vps/SCIM_Bearer/credential') \
     1password/scim:latest
   ```
3. Configurar Connect Server (opcionalmente em mesmo host ou container dedicado).
4. Integrar SCIM com Azure AD/Google Workspace (sincronização de grupos).
5. Habilitar Event Reporting → Slack/Panther; validar logs no SIEM.

## 7. Sequência de Implantação
| Ordem | Etapa | Entregável | Critério de aceitação |
|-------|-------|------------|------------------------|
| 1 | Aprovação do plano | `1password-automation-master-plan.md` (este arquivo) | Revisado por Segurança + InfraOps |
| 2 | Configuração do Vault | `docs/vault-structure.md` (a criar) | Todos os itens criados e auditados |
| 3 | Autenticação macOS | Log `op whoami` + `.env.generated` | CLI biométrica funcionando |
| 4 | Deploy SCIM Bridge | Script `deploy_scim.sh` (a criar) | Provisionamento automatizado de usuários |
| 5 | Device Trust | Registro em compliance dashboard | Dispositivos aprovados |
| 6 | Alertas & Events | Teste de evento → Slack & Panther | Alertas recebidos |
| 7 | CI/CD | Execução workflow `ci-secrets-check` | Segredos injetados com sucesso |
| 8 | Documentação final | `docs/runbook-1password.md` | Contém rollback, troubleshooting |

## 8. Controle de Mudanças
- Toda modificação deve passar por PR com revisão dupla (Segurança + DevOps).
- Utilizar commits semânticos (`feat:`, `chore:`, `docs:`) com referência a tarefas.
- Proibição de alterações diretas em produção sem rollback documentado.
- Checklists de aprovação armazenados em `docs/change-log/`.

## 9. Validação & Testes
| Teste | Descrição | Ferramenta | Responsável |
|-------|-----------|-------------|-------------|
| CLI Login | `op signin` + Touch ID | macOS Terminal | Admin local |
| Geração `.env` | `op inject` vs `template.env.op` | shell script | DevOps |
| SCIM Sync | Inclusão/remoção usuário teste | Azure AD / Google Workspace | Segurança |
| Device Compliance | Estado do agent | Device Trust dashboard | SecOps |
| Slack Alerts | Simulação `login.failed` | Events Reporting | InfraOps |
| CI/CD Secrets | Workflow GitHub | Actions | DevOps |

## 10. Rollback & Contingência
- Manter backup criptografado dos arquivos de configuração (`_backup_<date>`).
- Possuir sessão de emergência em vault “BreakGlass” com auditoria reforçada.
- Documentar procedimentos de restauração de SCIM Bridge (reutilizar `scimsession`).
- Implantar monitoramento para quedas do Connect Server (healthchecks HTTP).

## 11. Próximas Entregas Planejadas
1. `docs/vault-structure.md` – detalhando itens/rotinas de rotação.
2. `scripts/deploy_scim.sh` – automatização do container SCIM (após aprovação).
3. `docs/runbook-1password.md` – runbook operacional final.

---

### Checklist de Aprovação
- [ ] Segurança validou arquitetura (Device Trust, Events, Insights).  
- [ ] InfraOps validou processo macOS/VPS.  
- [ ] DevOps aprovou integrações CI/CD.  
- [ ] Gestão aprovou cronograma e comunicação.

> **Importante:** nenhum script ou automação deve ser executado antes da aprovação formal deste plano. Todos os próximos arquivos (`vault-structure.md`, `deploy_scim.sh`, `runbook-1password.md`) só serão criados/stageados após os responsáveis confirmarem este documento.
