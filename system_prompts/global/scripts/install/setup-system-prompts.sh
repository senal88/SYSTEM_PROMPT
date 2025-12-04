#!/usr/bin/env bash
################################################################################
# 🚀 SETUP INICIAL COMPLETO - SISTEMA DE PROMPTS GLOBAL
#
# DESCRIÇÃO:
#   Configura a estrutura inicial completa do sistema de prompts globais
#   tanto no macOS quanto na VPS Ubuntu.
#
# VERSÃO: 1.0.0
# DATA: 2025-01-15
# STATUS: ATIVO
################################################################################

set -euo pipefail

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_DOTFILES="${VPS_DOTFILES:-/home/admin/Dotfiles}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✅]${NC} $*"
}

log_error() {
    echo -e "${RED}[❌]${NC} $*"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Criar estrutura local (macOS)
setup_local_structure() {
    print_header "📁 CRIANDO ESTRUTURA LOCAL (macOS)"

    local base_dir="${DOTFILES_DIR}/system_prompts/global"

    log_info "Criando estrutura de diretórios..."
    mkdir -p "${base_dir}/"{prompts/{system,audit,revision},docs/{checklists,summaries,corrections,guides},scripts/{sync,install,validate,test},governance/{rules,validation},consolidated,audit,logs/{backups,sync},templates}

    log_success "Estrutura local criada: ${base_dir}"
}

# Criar estrutura remota (VPS)
setup_remote_structure() {
    print_header "📁 CRIANDO ESTRUTURA REMOTA (VPS)"

    local vps_base_dir="${VPS_DOTFILES}/system_prompts/global"

    log_info "Testando conexão SSH..."
    if ! ssh -o ConnectTimeout=5 "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_error "Não foi possível conectar à VPS"
        return 1
    fi

    log_info "Criando estrutura de diretórios na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${vps_base_dir}/"{prompts/{system,audit,revision},docs/{checklists,summaries,corrections,guides},scripts/{sync,install,validate,test},governance/{rules,validation},consolidated,audit,logs/{backups,sync},templates}

    log_success "Estrutura remota criada: ${vps_base_dir}"
}

# Configurar permissões
setup_permissions() {
    print_header "🔐 CONFIGURANDO PERMISSÕES"

    local base_dir="${DOTFILES_DIR}/system_prompts/global"

    log_info "Configurando permissões de scripts..."
    find "${base_dir}/scripts" -type f -name "*.sh" -exec chmod +x {} \;

    log_success "Permissões configuradas"
}

# Criar arquivos README básicos
create_readme_files() {
    print_header "📝 CRIANDO ARQUIVOS README"

    local base_dir="${DOTFILES_DIR}/system_prompts/global"

    # README principal
    if [[ ! -f "${base_dir}/README.md" ]]; then
        cat > "${base_dir}/README.md" << 'EOF'
# 🚀 Sistema de Prompts Globais

Sistema centralizado de prompts para uso em múltiplas IDEs e ambientes.

## Estrutura

- `prompts/` - Prompts organizados por categoria
- `docs/` - Documentação completa
- `scripts/` - Scripts de automação
- `governance/` - Regras e validações

## Uso

Ver documentação completa em `docs/PLANEJAMENTO_IMPLANTACAO_DEFINITIVA.md`
EOF
        log_success "README.md criado"
    fi

    # .gitignore
    if [[ ! -f "${base_dir}/.gitignore" ]]; then
        cat > "${base_dir}/.gitignore" << 'EOF'
# Logs
logs/
*.log

# Backups
logs/backups/

# Arquivos temporários
*.tmp
*.swp
*.bak

# Credenciais
credentials/
*.key
*.pem
EOF
        log_success ".gitignore criado"
    fi
}

# Função principal
main() {
    print_header "🚀 SETUP INICIAL - SISTEMA DE PROMPTS GLOBAL"

    setup_local_structure
    setup_remote_structure
    setup_permissions
    create_readme_files

    print_header "✅ SETUP CONCLUÍDO"
    log_success "Estrutura inicial criada com sucesso!"
    log_info "Próximo passo: Executar sincronização inicial"
}

main "$@"

