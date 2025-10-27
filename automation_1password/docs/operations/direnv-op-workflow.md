---
title: "Integração direnv + 1Password CLI"
created_at: "2025-10-24T21:19:44Z"
status: "draft"
---

# direnv + 1Password CLI Workflow

## Objetivo
Garantir que variáveis sensíveis sejam carregadas dinamicamente, sem persistir segredos em `.zshrc` ou `.env` versionados.

## Pré-requisitos
- `direnv` instalado (`brew install direnv`)
- `1Password CLI` autenticado (`op signin --account <apelido>`)
- Template `configs/template.env.op` atualizado

## Passos
1. **Permitir direnv na pasta do projeto**
   ```bash
   echo 'use 1password_env' >> .envrc
   direnv allow
   ```

2. **Criar extensão direnv customizada**  
   Salvar em `~/.config/direnv/lib/use_1password_env.sh`:
   ```bash
   use_1password_env() {
     local template="${1:-${PWD}/configs/template.env.op}"
     local generated="${template%.op}.direnv"

     op inject -i "$template" -o "$generated"
     dotenv "$generated"
   }
   ```

3. **Validar sessão**
   ```bash
   op account list
   op whoami
   ```

4. **Testar carregamento**
   ```bash
   direnv reload
   env | grep -E 'LOCAL_|VPS_|OPENAI_'
   ```

## Boas Práticas
- Agrupar segredos por vault (`Local-Dev`, `VPS-Prod`)
- Usar prefixos `LOCAL_` e `VPS_`
- Revogar tokens via `op vault list` e `op item edit`

## Troubleshooting
| Sintoma | Causa Provável | Correção |
| --- | --- | --- |
| `direnv: command not found` | direnv não instalado | `brew install direnv` |
| `op: no active session` | sessão expirada | `op signin --account <apelido>` |
| `unknown directive use` | lib não carregada | `mkdir -p ~/.config/direnv/lib` e salvar função |

---

*Mantido em sincronia com `Contexto_Global/relatorios/ambientes-segregados-2025-10-24.md`*
