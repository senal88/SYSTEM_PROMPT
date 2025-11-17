#!/usr/bin/env bash
#
# load-infra-env.sh
# Carregar variáveis de ambiente da stack infra completa
# Compatível com 1Password Environments montados via Local .env files
#
# Uso: bash scripts/secrets/load-infra-env.sh
#

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Diretório raiz
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║            LOAD INFRA ENVIRONMENT VARIABLES                ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se 1Password está rodando
if ! pgrep -x "1Password" > /dev/null; then
    log_warning "1Password não está rodando"
    log_info "Abra o 1Password Desktop App para que os arquivos .env montados funcionem"
fi

# Carregar variáveis compartilhadas
if [[ -f "env/shared.env" ]]; then
    log_info "Carregando shared.env..."
    set -a
    source "env/shared.env"
    set +a
    log_success "Shared environment carregado"
else
    log_warning "shared.env não encontrado"
fi

# Carregar variáveis macOS
if [[ -f "env/macos.env" ]]; then
    log_info "Carregando macos.env..."
    set -a
    source "env/macos.env"
    set +a
    log_success "macOS environment carregado"
else
    log_warning "macos.env não encontrado"
fi

# Carregar secrets da infra (montado pelo 1Password)
INFRA_SECRETS="env/infra.secrets.env.op"

if [[ -f "$INFRA_SECRETS" ]]; then
    log_info "Carregando secrets de infraestrutura..."
    log_warning "⚠️  Requer autorização 1Password (primeira vez)"
    
    # Verificar se arquivo está acessível
    if ! timeout 2 cat "$INFRA_SECRETS" > /dev/null 2>&1; then
        log_error "Não foi possível ler $INFRA_SECRETS"
        log_info "Possíveis causas:"
        echo "  1. Arquivo aberto na IDE (feche-o primeiro)"
        echo "  2. 1Password não está rodando"
        echo "  3. Ambiente não configurado no 1Password"
        exit 1
    fi
    
    set -a
    source "$INFRA_SECRETS"
    set +a
    log_success "Secrets de infraestrutura carregados"
else
    log_warning "$INFRA_SECRETS não encontrado"
    log_info "Configure o Local .env file no 1Password Environment"
fi

# Exportar variáveis para o shell pai
export $(cat "env/shared.env" 2>/dev/null | grep -v '^#' | xargs)
export $(cat "env/macos.env" 2>/dev/null | grep -v '^#' | xargs)

if [[ -f "$INFRA_SECRETS" ]]; then
    export $(cat "$INFRA_SECRETS" 2>/dev/null | grep -v '^#' | xargs)
fi

echo ""
log_success "🎯 Variáveis de ambiente carregadas!"
echo ""
log_info "Variáveis disponíveis:"
echo "  • OP_CONNECT_TOKEN"
echo "  • OP_CONNECT_HOST"
echo "  • OP_VAULT"
echo "  • DATABASE credentials (se configurados)"
echo "  • API keys (se configurados)"
echo ""
log_info "Próximo passo: docker compose up -d"
echo ""

exit 0
