## Auditoria da Automação 1Password
**Data:** 2025-10-31  
**Ambientes avaliados:** macOS (Apple Silicon) · VPS Ubuntu (espelhamento previsto)  
**Arquivos foco:** `scripts/secrets/sync_1password_env.sh`, `scripts/bootstrap/init_1password_*.sh`, `scripts/secrets/inject_secrets_*.sh`

---

### Problemas Críticos Identificados
- **Segredos hardcoded** (`scripts/secrets/sync_1password_env.sh:11-37`): Secret Key + master password do 1Password expostos em texto puro. Viola as regras de segurança e impede rotação automatizada.
- **Operações não idempotentes** (`scripts/secrets/sync_1password_env.sh:25-36`): `op item create` roda sempre, gerando duplicatas no vault `1p_macos`.
- **Ausência de validação de sessão** (`scripts/bootstrap/init_1password_*.sh`): scripts assumem login ativo; se a sessão expira, a automação falha silenciosamente.
- **Sem uso de Service Accounts/Connect**: processos CLI dependem do perfil pessoal, contrariando a meta de “nunca digitar senha” nos servidores.
- **Governança incompleta**: não há registro em `.cursorrules` orientando que modificações nos scripts de segredos disparem auditoria/refresh do template.

---

### Causas Raiz Prováveis
1. Automação criada por LLM sem sanitização posterior (copypasta direto da CLI).
2. Falta de camada de configuração (`.env`/`templates`) para placeholders sensíveis.
3. Ausência de `just`/Make targets que orquestrem login, injeção e sincronização de forma padronizada.

---

### Recomendações Técnicas
- Migrar credenciais para `templates/env/*.op` e usar `op inject` com placeholders `{{OP_SECRET_REFERENCE}}`.
- Substituir fluxo `op account add` + senha por login biométrico no macOS e serviço do `1Password Connect`/`Service Account` na VPS.
- Introduzir validações: `op whoami` + verificação de item existente (`op item get --vault ... --format=json`) antes de criar/editar.
- Versionar scripts sensíveis sob `scripts/secrets/` com hooks de auditoria (gatilho `.cursorrules` → atualizar `diagnostics/system_report*.md` + este arquivo).
- Automatizar rotação de segredos via `scripts/secrets/reset_connect_env.sh` (pendente).

---

### Ações Imediatas Sugeridas
1. Refatorar `scripts/secrets/sync_1password_env.sh` para remover credenciais hardcoded e aceitar `op://` placeholders.
2. Criar targets no `Makefile`/`justfile`: `secrets-sync`, `secrets-rotate`, `op-login`.
3. Habilitar 1Password SSH Agent e `IdentityAgent` compartilhado para a VPS (`~/.ssh/config`).
4. Atualizar `.cursorrules` com gatilho explícito para `scripts/secrets/` → “requires audit”.
5. Configurar pipeline de validação (`scripts/validation/validate_environment_macos.sh`) para verificar ausência de strings secretas via `rg`.

---

### Próximos Passos (Governança)
- Registrar este laudo em `docs/runbooks/automacao-dual.md`.
- Criar agenda mensal no `launchd/systemd` para executar `scripts/diagnostics/gpt_sys_collector.sh` e enviar para revisão.
- Abrir issue/ticket interno: “Remover hardcoded secrets do fluxo 1Password” com responsável e deadline.
