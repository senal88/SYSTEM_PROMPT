#!/usr/bin/env bash

################################################################################
# 🔐 CRIAÇÃO DE SECRETS FALTANTES NO 1PASSWORD
# Gera comandos e guias para criar os secrets faltantes nas vaults
#
# VERSÃO: 1.0.0
# DATA: 2025-12-01
################################################################################

set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || echo "${HOME}/Dotfiles")"
VAULT_MACOS="1p_macos"
VAULT_VPS="1p_vps"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_step() {
    echo -e "${CYAN}▶${NC} $@"
}

# Secrets faltantes para 1p_macos
SECRETS_MACOS_MISSING=(
    "GitHub|copilot_token|GitHub Copilot Token|password"
    "OpenAI|api_key|OpenAI API Key|password"
    "Anthropic|api_key|Anthropic Claude API Key|password"
    "Google|gemini_api_key|Google Gemini API Key|password"
    "HuggingFace|token|Hugging Face API Token|password"
    "1Password-Connect|token|1Password Connect Token (macOS)|password"
    "PostgreSQL Stack Local|username|PostgreSQL Username (Local)|text"
    "PostgreSQL Stack Local|password|PostgreSQL Password (Local)|password"
    "PostgreSQL Stack Local|database|PostgreSQL Database (Local)|text"
    "Redis Stack Local|password|Redis Password (Local)|password"
    "Traefik|email|Traefik Email (Let's Encrypt)|email"
    "Traefik|dashboard_auth|Traefik Dashboard Auth|password"
    "Grafana|username|Grafana Admin Username|text"
    "Grafana|password|Grafana Admin Password|password"
    "n8n|username|n8n Basic Auth Username|text"
    "n8n|password|n8n Basic Auth Password|password"
    "Dify|secret_key|Dify Secret Key|password"
    "SMTP|host|SMTP Host (Local)|text"
    "SMTP|port|SMTP Port (Local)|text"
    "SMTP|user|SMTP User (Local)|email"
    "SMTP|password|SMTP Password (Local)|password"
    "SMTP|from|SMTP From Email (Local)|email"
    "API-VPS-HOSTINGER|credential|Hostinger VPS API Token|password"
)

# Secrets faltantes para 1p_vps
SECRETS_VPS_MISSING=(
    "1Password-Connect|token|1Password Connect Token (VPS)|password"
    "Cloudflare|API_TOKEN|Cloudflare API Token|password"
    "Cloudflare|ZONE_ID|Cloudflare Zone ID|text"
    "Cloudflare|ACCOUNT_ID|Cloudflare Account ID|text"
    "Cloudflare|EMAIL|Cloudflare Email|email"
    "Cloudflare|DOMAIN|Domain Name (Production)|text"
    "Postgres-Prod|USER|PostgreSQL Username (Production)|text"
    "Postgres-Prod|PASSWORD|PostgreSQL Password (Production)|password"
    "Postgres-Prod|DB|PostgreSQL Database (Production)|text"
    "Redis-Prod|password|Redis Password (Production)|password"
    "Traefik-Auth|basicauth|Traefik Dashboard Auth (Production)|password"
    "Grafana-Auth|USER|Grafana Admin Username (Production)|text"
    "Grafana-Auth|PASSWORD|Grafana Admin Password (Production)|password"
    "N8N-Auth|USER|n8n Basic Auth Username (Production)|text"
    "N8N-Auth|PASSWORD|n8n Basic Auth Password (Production)|password"
    "Dify|SECRET_KEY|Dify Secret Key (Production)|password"
    "SMTP|HOST|SMTP Host (Production)|text"
    "SMTP|PORT|SMTP Port (Production)|text"
    "SMTP|USER|SMTP User (Production)|email"
    "SMTP|PASSWORD|SMTP Password (Production)|password"
    "SMTP|FROM|SMTP From Email (Production)|email"
    "Service_Account_vps|credential|1Password Service Account Token (VPS)|password"
)

generate_creation_guide() {
    local vault="$1"
    local secrets_array_name="$2"
    local vault_display_name="$3"
    
    log_step "Gerando guia de criação para vault '${vault_display_name}'..."
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 VAULT: ${vault_display_name} (${vault})"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Usar array indireto
    local array_ref="${secrets_array_name}[@]"
    local current_item=""
    local item_count=0
    
    for secret_entry in ${!array_ref}; do
        IFS='|' read -r item_name field_name description field_type <<< "${secret_entry}"
        
        # Se mudou de item, criar seção
        if [ "${current_item}" != "${item_name}" ]; then
            if [ -n "${current_item}" ]; then
                echo ""
            fi
            current_item="${item_name}"
            item_count=$((item_count + 1))
            echo "${item_count}. **${item_name}**"
            echo "   Vault: \`${vault}\`"
            echo "   Tipo: Login (ou Password conforme necessário)"
            echo ""
        fi
        
        echo "   - Campo: \`${field_name}\`"
        echo "     Tipo: ${field_type}"
        echo "     Descrição: ${description}"
        echo "     Referência: \`op://${vault}/${item_name}/${field_name}\`"
        echo ""
    done
    
    echo ""
    echo "### 📝 Instruções de Criação"
    echo ""
    echo "Para cada item acima:"
    echo ""
    echo "1. Abra o 1Password Desktop App"
    echo "2. Selecione o vault \`${vault}\`"
    echo "3. Clique em \"+\" para criar novo item"
    echo "4. Escolha o tipo apropriado (Login, Password, Secure Note)"
    echo "5. Preencha os campos conforme especificado"
    echo "6. Salve o item"
    echo ""
    echo "**OU** use o CLI (exemplo para um item):"
    echo ""
    echo "\`\`\`bash"
    echo "# Criar item via CLI (ajuste conforme necessário)"
    echo "op item create --vault ${vault} \\"
    echo "  --title \"Nome do Item\" \\"
    echo "  --category password \\"
    echo "  --field label=\"campo\",value=\"valor\""
    echo "\`\`\`"
    echo ""
}

main() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  GUIA DE CRIAÇÃO DE SECRETS FALTANTES NO 1PASSWORD       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Verificar autenticação
    if ! op whoami >/dev/null 2>&1; then
        log_warning "1Password CLI não está autenticado. Execute: op signin"
        exit 1
    fi
    
    # Gerar guias
    generate_creation_guide "${VAULT_MACOS}" "SECRETS_MACOS_MISSING" "1p_macos (Desenvolvimento)"
    generate_creation_guide "${VAULT_VPS}" "SECRETS_VPS_MISSING" "1p_vps (Produção)"
    
    echo ""
    log_success "Guia de criação gerado!"
    log_info "Siga as instruções acima para criar os secrets faltantes no 1Password"
}

main "$@"

