# ============================================================================
# 🔐 Configuração do 1Password para Bash (VPS Ubuntu)
# Arquivo: bashrc_1password_config.sh
# Propósito: Aliases e funções para facilitar o uso do 1Password CLI
# Uso: Adicione este arquivo ao seu .bashrc ou source manualmente
# ============================================================================

# ============================================================================
# CORES PARA OUTPUT
# ============================================================================

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

_op_log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

_op_log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

_op_log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

_op_log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================================================
# VERIFICAÇÃO DE SERVICE ACCOUNT TOKEN
# ============================================================================

_check_service_account_token() {
    if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
        _op_log_error "OP_SERVICE_ACCOUNT_TOKEN não está definido."
        _op_log_info "Configure com: export OP_SERVICE_ACCOUNT_TOKEN='seu_token_aqui'"
        return 1
    fi
    return 0
}

# ============================================================================
# FUNÇÕES PRINCIPAIS
# ============================================================================

# Função: Verificar status da sessão
op_status() {
    if ! _check_service_account_token; then
        return 1
    fi

    if op whoami &>/dev/null; then
        _op_log_success "Conectado ao 1Password"
        echo ""
        op whoami
        echo ""
        _op_log_info "Vaults disponíveis:"
        op vault list --format json | jq -r '.[] | "  - \(.name)"'
    else
        _op_log_error "Não conectado ao 1Password"
        return 1
    fi
}

# Função: Listar todos os itens de um vault
op_list_items() {
    local vault="${1:-shared_infra}"
    
    if [[ -z "$vault" ]]; then
        _op_log_error "Uso: op_list_items [vault_name]"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_info "Listando itens do vault: $vault"
    op item list --vault "$vault" --format json | jq -r '.[] | "\(.title) (\(.category))"'
}

# Função: Obter um segredo específico
op_get_secret() {
    local item="$1"
    local field="${2:-password}"
    local vault="${3:-shared_infra}"

    if [[ -z "$item" ]]; then
        _op_log_error "Uso: op_get_secret <item> [field] [vault]"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    op read "op://$vault/$item/$field"
}

# Função: Injetar segredos a partir de um arquivo .env.op
op_inject_env() {
    local template_file="${1:-.env.op}"
    local output_file="${2:-.env}"

    if [[ ! -f "$template_file" ]]; then
        _op_log_error "Arquivo de template não encontrado: $template_file"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_info "Injetando segredos de $template_file..."
    op inject -i "$template_file" -o "$output_file"

    if [[ -f "$output_file" ]]; then
        chmod 600 "$output_file"
        _op_log_success "Arquivo $output_file gerado com sucesso."
        _op_log_info "Permissões ajustadas (600)."
    else
        _op_log_error "Falha ao gerar arquivo $output_file."
        return 1
    fi
}

# Função: Carregar variáveis de ambiente de um arquivo .env
op_load_env() {
    local env_file="${1:-.env}"

    if [[ ! -f "$env_file" ]]; then
        _op_log_error "Arquivo de ambiente não encontrado: $env_file"
        return 1
    fi

    _op_log_info "Carregando variáveis de $env_file..."
    set -a
    source "$env_file"
    set +a
    _op_log_success "Variáveis carregadas."
}

# Função: Executar um comando com segredos injetados
op_run_with_secrets() {
    local env_file="${1:-.env.op}"
    shift

    if [[ ! -f "$env_file" ]]; then
        _op_log_error "Arquivo de template não encontrado: $env_file"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_info "Executando comando com segredos injetados..."
    op run --env-file="$env_file" -- "$@"
}

# Função: Criar um novo item no 1Password
op_create_item() {
    local title="$1"
    local vault="${2:-shared_infra}"
    local category="${3:-password}"

    if [[ -z "$title" ]]; then
        _op_log_error "Uso: op_create_item <title> [vault] [category]"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_info "Criando novo item: $title"
    op item create \
        --category="$category" \
        --title="$title" \
        --vault="$vault"
    
    _op_log_success "Item criado com sucesso."
}

# Função: Atualizar um campo de um item
op_update_item() {
    local item="$1"
    local field="$2"
    local value="$3"
    local vault="${4:-shared_infra}"

    if [[ -z "$item" ]] || [[ -z "$field" ]] || [[ -z "$value" ]]; then
        _op_log_error "Uso: op_update_item <item> <field> <value> [vault]"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_info "Atualizando campo $field do item $item..."
    op item edit "$item" --vault "$vault" "$field=$value"
    _op_log_success "Item atualizado com sucesso."
}

# Função: Deletar um item
op_delete_item() {
    local item="$1"
    local vault="${2:-shared_infra}"

    if [[ -z "$item" ]]; then
        _op_log_error "Uso: op_delete_item <item> [vault]"
        return 1
    fi

    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_warning "Você está prestes a deletar: $item"
    read -p "Tem certeza? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        op item delete "$item" --vault "$vault"
        _op_log_success "Item deletado com sucesso."
    else
        _op_log_info "Operação cancelada."
    fi
}

# Função: Gerar uma senha forte
op_generate_password() {
    local length="${1:-32}"
    
    if ! _check_service_account_token; then
        return 1
    fi

    _op_log_info "Gerando senha com $length caracteres..."
    op item create \
        --category=password \
        --title="Generated Password $(date +%s)" \
        --vault="shared_infra" \
        password="$(openssl rand -base64 $((length * 3 / 4)) | head -c $length)"
    
    _op_log_success "Senha gerada e armazenada no 1Password."
}

# ============================================================================
# ALIASES
# ============================================================================

# Aliases curtos para funções comuns
alias op_s='op_status'
alias op_l='op_list_items'
alias op_g='op_get_secret'
alias op_i='op_inject_env'
alias op_load='op_load_env'
alias op_run='op_run_with_secrets'

# Aliases para comandos do 1Password CLI
alias op_read='op read'
alias op_list='op item list'
alias op_whoami='op whoami'
alias op_vault='op vault list'

# ============================================================================
# VARIÁVEIS DE AMBIENTE
# ============================================================================

# Vault padrão para operações
export OP_DEFAULT_VAULT="shared_infra"

# Arquivo de template padrão
export OP_ENV_TEMPLATE=".env.op"

# Arquivo de saída padrão
export OP_ENV_OUTPUT=".env"

# ============================================================================
# INICIALIZAÇÃO
# ============================================================================

# Verificar se está autenticado ao abrir um novo shell
if [[ -n "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
    if ! op whoami &>/dev/null; then
        _op_log_warning "Falha ao autenticar com o 1Password."
        _op_log_info "Verifique o OP_SERVICE_ACCOUNT_TOKEN"
    fi
else
    _op_log_warning "OP_SERVICE_ACCOUNT_TOKEN não está definido."
    _op_log_info "Configure com: export OP_SERVICE_ACCOUNT_TOKEN='seu_token_aqui'"
fi

