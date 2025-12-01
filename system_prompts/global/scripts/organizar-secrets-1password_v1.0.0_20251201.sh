#!/usr/bin/env bash

################################################################################
# 🔐 ORGANIZAÇÃO DE SECRETS E VARIÁVEIS NO 1PASSWORD
# Organiza todos os secrets necessários nas vaults 1p_macos e 1p_vps
# seguindo a política de governança do repositório
#
# VERSÃO: 1.0.0
# DATA: 2025-12-01
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || echo "${HOME}/Dotfiles")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${ROOT_DIR}/system_prompts/global/logs/organizacao-secrets-${TIMESTAMP}.log"

# Vaults
VAULT_MACOS="1p_macos"
VAULT_VPS="1p_vps"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${LOG_FILE}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${LOG_FILE}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${LOG_FILE}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${LOG_FILE}"
}

log_step() {
    echo -e "${CYAN}▶${NC} $@" | tee -a "${LOG_FILE}"
}

# Verificar se 1Password CLI está autenticado
check_1password_auth() {
    if ! op whoami >/dev/null 2>&1; then
        log_error "1Password CLI não está autenticado. Execute: op signin"
        exit 1
    fi
    log_success "1Password CLI autenticado"
}

# Verificar se vault existe
check_vault() {
    local vault="$1"
    if ! op vault list 2>/dev/null | grep -q "${vault}"; then
        log_error "Vault '${vault}' não encontrado"
        return 1
    fi
    return 0
}

# Criar item no 1Password (se não existir)
create_item_if_not_exists() {
    local vault="$1"
    local item_name="$2"
    local item_type="${3:-Login}"
    local fields="$4"
    
    # Verificar se item já existe
    if op item list --vault "${vault}" 2>/dev/null | grep -q "${item_name}"; then
        log_info "Item '${item_name}' já existe no vault '${vault}'"
        return 0
    fi
    
    log_step "Criando item '${item_name}' no vault '${vault}'..."
    
    # Criar item usando op item create
    if echo "${fields}" | op item create \
        --vault "${vault}" \
        --title "${item_name}" \
        --category "${item_type}" \
        --format json >/dev/null 2>&1; then
        log_success "Item '${item_name}' criado com sucesso"
        return 0
    else
        log_warning "Não foi possível criar item '${item_name}' automaticamente"
        log_info "Crie manualmente no 1Password:"
        log_info "  Vault: ${vault}"
        log_info "  Nome: ${item_name}"
        log_info "  Tipo: ${item_type}"
        return 1
    fi
}

# ============================================================================
# DEFINIÇÃO DE SECRETS POR VAULT
# ============================================================================

# Secrets para 1p_macos (Desenvolvimento) - Formato: "ITEM|FIELD|DESCRIPTION"
SECRETS_MACOS=(
    # APIs de IA
    "GitHub|copilot_token|GitHub Copilot Token"
    "OpenAI|api_key|OpenAI API Key"
    "Anthropic|api_key|Anthropic Claude API Key"
    "Google|gemini_api_key|Google Gemini API Key"
    "HuggingFace|token|Hugging Face API Token"
    
    # 1Password Connect
    "1Password-Connect|token|1Password Connect Token (macOS)"
    
    # Infraestrutura Local
    "PostgreSQL Stack Local|username|PostgreSQL Username (Local)"
    "PostgreSQL Stack Local|password|PostgreSQL Password (Local)"
    "PostgreSQL Stack Local|database|PostgreSQL Database (Local)"
    "Redis Stack Local|password|Redis Password (Local)"
    
    # Serviços Locais
    "Traefik|email|Traefik Email (Let's Encrypt)"
    "Traefik|dashboard_auth|Traefik Dashboard Auth"
    "Grafana|username|Grafana Admin Username"
    "Grafana|password|Grafana Admin Password"
    "n8n|username|n8n Basic Auth Username"
    "n8n|password|n8n Basic Auth Password"
    "Dify|secret_key|Dify Secret Key"
    "NocoDB|jwt_secret|NocoDB JWT Secret"
    
    # SMTP Local
    "SMTP|host|SMTP Host (Local)"
    "SMTP|port|SMTP Port (Local)"
    "SMTP|user|SMTP User (Local)"
    "SMTP|password|SMTP Password (Local)"
    "SMTP|from|SMTP From Email (Local)"
    
    # APIs Externas
    "API-VPS-HOSTINGER|credential|Hostinger VPS API Token"
)

# Secrets para 1p_vps (Produção) - Formato: "ITEM|FIELD|DESCRIPTION"
SECRETS_VPS=(
    # 1Password Connect
    "1Password-Connect|token|1Password Connect Token (VPS)"
    
    # Cloudflare
    "Cloudflare|API_TOKEN|Cloudflare API Token"
    "Cloudflare|ZONE_ID|Cloudflare Zone ID"
    "Cloudflare|ACCOUNT_ID|Cloudflare Account ID"
    "Cloudflare|EMAIL|Cloudflare Email"
    "Cloudflare|DOMAIN|Domain Name (Production)"
    
    # Infraestrutura Produção
    "Postgres-Prod|USER|PostgreSQL Username (Production)"
    "Postgres-Prod|PASSWORD|PostgreSQL Password (Production)"
    "Postgres-Prod|DB|PostgreSQL Database (Production)"
    "Redis-Prod|password|Redis Password (Production)"
    
    # Serviços Produção
    "Traefik-Auth|basicauth|Traefik Dashboard Auth (Production)"
    "Grafana-Auth|USER|Grafana Admin Username (Production)"
    "Grafana-Auth|PASSWORD|Grafana Admin Password (Production)"
    "N8N-Auth|USER|n8n Basic Auth Username (Production)"
    "N8N-Auth|PASSWORD|n8n Basic Auth Password (Production)"
    "Dify|SECRET_KEY|Dify Secret Key (Production)"
    
    # SMTP Produção
    "SMTP|HOST|SMTP Host (Production)"
    "SMTP|PORT|SMTP Port (Production)"
    "SMTP|USER|SMTP User (Production)"
    "SMTP|PASSWORD|SMTP Password (Production)"
    "SMTP|FROM|SMTP From Email (Production)"
    
    # Service Account
    "Service_Account_vps|credential|1Password Service Account Token (VPS)"
)

# ============================================================================
# FUNÇÃO PRINCIPAL DE ORGANIZAÇÃO
# ============================================================================

organize_secrets() {
    log_step "Organizando secrets nas vaults..."
    
    # Criar diretório de logs
    mkdir -p "$(dirname "${LOG_FILE}")"
    
    # Organizar secrets no vault 1p_macos
    log_info "Organizando secrets no vault '${VAULT_MACOS}'..."
    for secret_entry in "${SECRETS_MACOS[@]}"; do
        IFS='|' read -r item_name field_name description <<< "${secret_entry}"
        
        log_info "  Item: ${item_name} / Campo: ${field_name}"
        log_info "  Descrição: ${description}"
        
        # Verificar se item existe
        if op item list --vault "${VAULT_MACOS}" 2>/dev/null | grep -q "${item_name}"; then
            log_success "    Item '${item_name}' já existe"
        else
            log_warning "    Item '${item_name}' NÃO existe - precisa ser criado manualmente"
        fi
    done
    
    echo ""
    
    # Organizar secrets no vault 1p_vps
    log_info "Organizando secrets no vault '${VAULT_VPS}'..."
    for secret_entry in "${SECRETS_VPS[@]}"; do
        IFS='|' read -r item_name field_name description <<< "${secret_entry}"
        
        log_info "  Item: ${item_name} / Campo: ${field_name}"
        log_info "  Descrição: ${description}"
        
        # Verificar se item existe
        if op item list --vault "${VAULT_VPS}" 2>/dev/null | grep -q "${item_name}"; then
            log_success "    Item '${item_name}' já existe"
        else
            log_warning "    Item '${item_name}' NÃO existe - precisa ser criado manualmente"
        fi
    done
}

# ============================================================================
# GERAR DOCUMENTAÇÃO
# ============================================================================

generate_documentation() {
    local doc_file="${ROOT_DIR}/system_prompts/global/docs/ORGANIZACAO_SECRETS_1PASSWORD_v1.0.0_20251201.md"
    
    log_step "Gerando documentação completa..."
    
    mkdir -p "$(dirname "${doc_file}")"
    
    cat > "${doc_file}" << 'EOF'
# 🔐 Organização de Secrets e Variáveis no 1Password

**Versão:** 1.0.0  
**Data:** 2025-12-01  
**Status:** ✅ Organizado

## 📋 Política de Governança

### Vaults e Propósitos

- **`1p_macos`**: Secrets para ambiente de desenvolvimento local (macOS)
- **`1p_vps`**: Secrets para ambiente de produção (VPS Ubuntu)

### Princípios

1. **Separação de Ambientes**: Dev e Prod nunca compartilham os mesmos secrets
2. **Nomenclatura Padronizada**: `VAULT/ITEM/FIELD` seguindo padrão `op://`
3. **Documentação Completa**: Todos os secrets devem estar documentados
4. **Rotação Periódica**: Secrets devem ser rotacionados conforme política de segurança

---

## 🔑 Secrets - Vault `1p_macos` (Desenvolvimento)

### APIs de IA

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `GitHub` | `copilot_token` | GitHub Copilot Token | GitHub Copilot, GitHub API |
| `OpenAI` | `api_key` | OpenAI API Key | ChatGPT Plus, OpenAI API |
| `Anthropic` | `api_key` | Anthropic Claude API Key | Claude Code, Claude.ai |
| `Google` | `gemini_api_key` | Google Gemini API Key | Gemini CLI, Gemini Web |
| `HuggingFace` | `token` | Hugging Face API Token | Hugging Face MCP, Modelos HF |

### 1Password Connect

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `1Password-Connect` | `token` | 1Password Connect Token | 1Password Connect Server Local |

### Infraestrutura Local

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `PostgreSQL Stack Local` | `username` | PostgreSQL Username | Docker Stack Local |
| `PostgreSQL Stack Local` | `password` | PostgreSQL Password | Docker Stack Local |
| `PostgreSQL Stack Local` | `database` | PostgreSQL Database Name | Docker Stack Local |
| `Redis Stack Local` | `password` | Redis Password | Docker Stack Local |

### Serviços Locais

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Traefik` | `email` | Traefik Email (Let's Encrypt) | Traefik SSL Certificates |
| `Traefik` | `dashboard_auth` | Traefik Dashboard Auth | Traefik Dashboard |
| `Grafana` | `username` | Grafana Admin Username | Grafana Dashboard |
| `Grafana` | `password` | Grafana Admin Password | Grafana Dashboard |
| `n8n` | `username` | n8n Basic Auth Username | n8n Workflow Automation |
| `n8n` | `password` | n8n Basic Auth Password | n8n Workflow Automation |
| `Dify` | `secret_key` | Dify Secret Key | Dify AI Platform |
| `NocoDB` | `jwt_secret` | NocoDB JWT Secret | NocoDB Database |

### SMTP Local

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `SMTP` | `host` | SMTP Host | Email Local |
| `SMTP` | `port` | SMTP Port | Email Local |
| `SMTP` | `user` | SMTP User | Email Local |
| `SMTP` | `password` | SMTP Password | Email Local |
| `SMTP` | `from` | SMTP From Email | Email Local |

### APIs Externas

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `API-VPS-HOSTINGER` | `credential` | Hostinger VPS API Token | Hostinger API |

---

## 🔑 Secrets - Vault `1p_vps` (Produção)

### 1Password Connect

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `1Password-Connect` | `token` | 1Password Connect Token | 1Password Connect Server VPS |

### Cloudflare

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Cloudflare` | `API_TOKEN` | Cloudflare API Token | DNS Management |
| `Cloudflare` | `ZONE_ID` | Cloudflare Zone ID | DNS Management |
| `Cloudflare` | `ACCOUNT_ID` | Cloudflare Account ID | Cloudflare API |
| `Cloudflare` | `EMAIL` | Cloudflare Email | Cloudflare Account |
| `Cloudflare` | `DOMAIN` | Domain Name (Production) | Domain Configuration |

### Infraestrutura Produção

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Postgres-Prod` | `USER` | PostgreSQL Username | PostgreSQL Production |
| `Postgres-Prod` | `PASSWORD` | PostgreSQL Password | PostgreSQL Production |
| `Postgres-Prod` | `DB` | PostgreSQL Database | PostgreSQL Production |
| `Redis-Prod` | `password` | Redis Password | Redis Production |

### Serviços Produção

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Traefik-Auth` | `basicauth` | Traefik Dashboard Auth | Traefik Dashboard Production |
| `Grafana-Auth` | `USER` | Grafana Admin Username | Grafana Production |
| `Grafana-Auth` | `PASSWORD` | Grafana Admin Password | Grafana Production |
| `N8N-Auth` | `USER` | n8n Basic Auth Username | n8n Production |
| `N8N-Auth` | `PASSWORD` | n8n Basic Auth Password | n8n Production |
| `Dify` | `SECRET_KEY` | Dify Secret Key | Dify Production |

### SMTP Produção

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `SMTP` | `HOST` | SMTP Host | Email Production |
| `SMTP` | `PORT` | SMTP Port | Email Production |
| `SMTP` | `USER` | SMTP User | Email Production |
| `SMTP` | `PASSWORD` | SMTP Password | Email Production |
| `SMTP` | `FROM` | SMTP From Email | Email Production |

### Service Account

| Item | Campo | Descrição | Uso |
|------|-------|-----------|-----|
| `Service_Account_vps` | `credential` | 1Password Service Account Token | 1Password Automation VPS |

---

## 📝 Referências de Uso

### Formato Padrão

Todas as referências seguem o formato:
```
op://VAULT/ITEM/FIELD
```

### Exemplos de Uso

```bash
# GitHub Token
export GITHUB_TOKEN="$(op read op://1p_macos/GitHub/copilot_token)"

# OpenAI API Key
export OPENAI_API_KEY="$(op read op://1p_macos/OpenAI/api_key)"

# PostgreSQL (Local)
export POSTGRES_USER="$(op read op://1p_macos/PostgreSQL Stack Local/username)"
export POSTGRES_PASSWORD="$(op read op://1p_macos/PostgreSQL Stack Local/password)"

# Cloudflare (Production)
export CF_API_TOKEN="$(op read op://1p_vps/Cloudflare/API_TOKEN)"
export CF_ZONE_ID="$(op read op://1p_vps/Cloudflare/ZONE_ID)"
```

---

## ✅ Checklist de Organização

### Vault `1p_macos`

- [ ] GitHub/copilot_token
- [ ] OpenAI/api_key
- [ ] Anthropic/api_key
- [ ] Google/gemini_api_key
- [ ] HuggingFace/token
- [ ] 1Password-Connect/token
- [ ] PostgreSQL Stack Local (username, password, database)
- [ ] Redis Stack Local/password
- [ ] Traefik (email, dashboard_auth)
- [ ] Grafana (username, password)
- [ ] n8n (username, password)
- [ ] Dify/secret_key
- [ ] NocoDB/jwt_secret
- [ ] SMTP (host, port, user, password, from)
- [ ] API-VPS-HOSTINGER/credential

### Vault `1p_vps`

- [ ] 1Password-Connect/token
- [ ] Cloudflare (API_TOKEN, ZONE_ID, ACCOUNT_ID, EMAIL, DOMAIN)
- [ ] Postgres-Prod (USER, PASSWORD, DB)
- [ ] Redis-Prod/password
- [ ] Traefik-Auth/basicauth
- [ ] Grafana-Auth (USER, PASSWORD)
- [ ] N8N-Auth (USER, PASSWORD)
- [ ] Dify/SECRET_KEY
- [ ] SMTP (HOST, PORT, USER, PASSWORD, FROM)
- [ ] Service_Account_vps/credential

---

## 🔄 Manutenção

### Rotação de Secrets

- **APIs de IA**: Rotacionar a cada 90 dias ou quando expirado
- **Infraestrutura**: Rotacionar a cada 180 dias
- **Cloudflare**: Rotacionar a cada 90 dias
- **SMTP**: Rotacionar a cada 180 dias ou quando necessário

### Auditoria

Execute periodicamente:
```bash
./system_prompts/global/scripts/auditar-1password-secrets_v1.0.0_20251130.sh
```

---

**Última atualização:** 2025-12-01  
**Próxima revisão:** 2026-01-01

EOF

    log_success "Documentação gerada em: ${doc_file}"
}

# ============================================================================
# GERAR RELATÓRIO DE STATUS
# ============================================================================

generate_status_report() {
    log_step "Gerando relatório de status..."
    
    local report_file="${ROOT_DIR}/system_prompts/global/docs/STATUS_SECRETS_1PASSWORD_${TIMESTAMP}.md"
    
    cat > "${report_file}" << EOF
# 📊 Status de Secrets no 1Password

**Data:** $(date '+%Y-%m-%d %H:%M:%S')  
**Gerado por:** Script de Organização Automática

## Vault: 1p_macos

EOF

    # Verificar secrets no vault 1p_macos
    for secret_entry in "${SECRETS_MACOS[@]}"; do
        IFS='|' read -r item_name field_name description <<< "${secret_entry}"
        if op item list --vault "${VAULT_MACOS}" 2>/dev/null | grep -q "${item_name}"; then
            echo "- ✅ **${item_name}/${field_name}** - Existe" >> "${report_file}"
        else
            echo "- ❌ **${item_name}/${field_name}** - NÃO EXISTE" >> "${report_file}"
        fi
    done
    
    cat >> "${report_file}" << EOF

## Vault: 1p_vps

EOF

    # Verificar secrets no vault 1p_vps
    for secret_entry in "${SECRETS_VPS[@]}"; do
        IFS='|' read -r item_name field_name description <<< "${secret_entry}"
        if op item list --vault "${VAULT_VPS}" 2>/dev/null | grep -q "${item_name}"; then
            echo "- ✅ **${item_name}/${field_name}** - Existe" >> "${report_file}"
        else
            echo "- ❌ **${item_name}/${field_name}** - NÃO EXISTE" >> "${report_file}"
        fi
    done
    
    cat >> "${report_file}" << EOF

---

**Relatório completo:** ${report_file}  
**Log de execução:** ${LOG_FILE}

EOF

    log_success "Relatório de status gerado em: ${report_file}"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  ORGANIZAÇÃO DE SECRETS E VARIÁVEIS NO 1PASSWORD         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Verificações iniciais
    check_1password_auth
    check_vault "${VAULT_MACOS}" || exit 1
    check_vault "${VAULT_VPS}" || exit 1
    
    echo ""
    
    # Organizar secrets
    organize_secrets
    
    echo ""
    
    # Gerar documentação
    generate_documentation
    
    echo ""
    
    # Gerar relatório
    generate_status_report
    
    echo ""
    log_success "Organização de secrets concluída!"
    log_info "Consulte a documentação em: system_prompts/global/docs/ORGANIZACAO_SECRETS_1PASSWORD_v1.0.0_20251201.md"
}

# Executar
main "$@"

