#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔧 ADICIONAR ALIASES ÚTEIS DO 1PASSWORD NA VPS
#
# Objetivo:
#   - Adicionar aliases úteis (op-status, op-vaults, op-items) ao .bashrc
#   - Facilitar uso do 1Password CLI na VPS
#
# Uso: ./adicionar-aliases-1password-vps_v1.0.0_20251201.sh
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️${NC} $@"; }
log_success() { echo -e "${GREEN}✅${NC} $@"; }

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  ADICIONAR ALIASES 1PASSWORD - VPS                       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Adicionar aliases ao .bashrc
ssh "${VPS_USER}@${VPS_HOST}" << 'EOF'
    set -e

    # Verificar se aliases já existem
    if grep -q "# 1Password Aliases" ~/.bashrc 2>/dev/null; then
        echo "Aliases já existem no .bashrc"
        exit 0
    fi

    # Adicionar aliases
    cat >> ~/.bashrc << 'ALIASEOF'

# 1Password Aliases
alias op-status='export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null) && op account list --account dev 2>&1 || echo "Token carregado"'
alias op-vaults='export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null) && op vault list --account dev'
alias op-items='export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/op/credentials 2>/dev/null) && op item list --vault 1p_vps --account dev'
ALIASEOF

    echo "Aliases adicionados ao .bashrc"
EOF

if [[ $? -eq 0 ]]; then
    log_success "Aliases adicionados com sucesso!"
    echo ""
    log_info "Para usar os aliases, execute:"
    log_info "  ssh ${VPS_HOST}"
    log_info "  source ~/.bashrc"
    log_info "  op-status"
    log_info "  op-vaults"
    log_info "  op-items"
else
    log_info "Aliases podem já existir ou houve um problema"
fi

echo ""
