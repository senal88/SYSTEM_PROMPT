# ~/.dotfiles/zsh/functions.zsh
#
# Este arquivo contém todas as funções de shell.

# função para inicializar Copilot com logging
function inicia_copilot {
  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "[ERRO] Nenhum repositório Git detectado. Execute dentro do projeto alvo." >&2
    return 1
  fi

  local rules_file="$repo_root/config/.copilot_rules.json"
  if [[ ! -f "$rules_file" ]]; then
    echo "[ERRO] Regras Copilot não encontradas em $rules_file. Aborte." >&2
    return 1
  fi

  local log_file="$repo_root/logs/copilot_exec.log"
  mkdir -p "$(dirname "$log_file")"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Iniciando Copilot em $repo_root" >> "$log_file"

  # Verifica se AGENTKIT_HOME está definido
  if [[ -z "$AGENTKIT_HOME" ]]; then
    echo "[ERRO] Variável AGENTKIT_HOME não está definida." >&2
    return 1
  fi
  
  local copilot_script="$AGENTKIT_HOME/scripts/inicia_copilot.sh"
  if [[ ! -x "$copilot_script" ]]; then
    echo "[ERRO] Script $copilot_script não encontrado ou sem permissão de execução." >&2
    return 1
  fi

  sh "$copilot_script"
}

# Cursor Agent Functions
function cursor_agent {
  local project_path="$1"
  if [[ -z "$project_path" ]]; then
    project_path="$(pwd)"
  fi

  echo "🚀 Iniciando Cursor Agent em: $project_path"
  cd "$project_path" && cursor . --wait
}

function cursor_new {
  local project_name="$1"
  if [[ -z "$project_name" ]]; then
    echo "❌ Nome do projeto é obrigatório"
    echo "Uso: cursor_new <nome_do_projeto>"
    return 1
  fi

  local project_path="$HOME/Projetos/$project_name"
  mkdir -p "$project_path"
  cd "$project_path"

  echo "📁 Projeto criado: $project_path"
  cd "$project_path" && cursor .
}

function cursor_open {
  local project_path="$1"
  if [[ -z "$project_path" ]]; then
    project_path="$(pwd)"
  fi

  echo "📂 Abrindo projeto: $project_path"
  cd "$project_path" && cursor .
}

# FUNÇÕES CENTRALIZADAS EM DOTFILES
# Função para recarregar configurações
function reload_dotfiles {
    echo "🔄 Recarregando configurações do Dotfiles..."
    source "$HOME/.zshrc"
    echo "✅ Configurações recarregadas!"
}

# Função para verificar status das configurações
function check_dotfiles_status {
    echo "🔍 VERIFICANDO STATUS DAS CONFIGURAÇÕES DOTFILES"
    echo "==============================================="

    echo "📁 DOTFILES_HOME: $DOTFILES_HOME"
    echo "🔧 Scripts disponíveis:"
    ls -la "$DOTFILES_HOME/scripts/" 2>/dev/null | head -5

    echo ""
    echo "⚙️ Configurações disponíveis:"
    ls -la "$DOTFILES_HOME/configs/" 2>/dev/null

    echo ""
    echo "🌍 Variáveis de ambiente:"
    echo "GEMINI_API_KEY: ${GEMINI_API_KEY:0:20}..."
    echo "CURSOR_API_KEY: ${CURSOR_API_KEY:0:20}..."
    echo "OPENAI_API_KEY: ${OPENAI_API_KEY:0:20}..."
    echo "ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY:0:20}..."
}

# Função para executar setup das configurações
function setup_dotfiles {
    echo "🚀 Executando setup das configurações centralizadas..."
    if [[ -f "$DOTFILES_HOME/scripts/setup_cli_configs.sh" ]]; then
        bash "$DOTFILES_HOME/scripts/setup_cli_configs.sh"
    else
        echo "❌ Script de setup não encontrado"
    fi
}

# 1Password Auto-Authentication Function (Melhorada)
op_auto_auth() {
    if ! command -v op >/dev/null 2>&1; then
        echo "⚠️  1Password CLI não está instalado ou não está no PATH"
        return 1
    fi
    
    # Cache de sessão (30 minutos)
    local cache_file="$HOME/.op_session_cache"
    local cache_age=1800  # 30 minutos
    
    if [ -f "$cache_file" ]; then
        local cache_time=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
        local current_time=$(date +%s)
        local age=$((current_time - cache_time))
        
        if [ "$age" -lt "$cache_age" ]; then
            # Tentar usar sessão cached
            if op vault list &>/dev/null 2>&1; then
                echo "✅ 1Password authenticated (cached)"
                return 0
            fi
        fi
    fi
    
    # Verificar se já está autenticado
    if op vault list &>/dev/null 2>&1; then
        echo "✅ 1Password already authenticated"
        touch "$cache_file" 2>/dev/null || true
        return 0
    fi
    
    # Tentar usar biometria/Touch ID se disponível (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🔐 Authenticating with 1Password (Touch ID if available)..."
        eval $(op signin --account my.1password.com 2>/dev/null) || {
            echo "❌ 1Password authentication failed"
            return 1
        }
    else
        echo "🔐 Authenticating with 1Password..."
        eval $(op signin --account my.1password.com)
        if [ $? -ne 0 ]; then
            echo "❌ 1Password authentication failed"
            return 1
        fi
    fi
    
    # Salvar timestamp do cache
    touch "$cache_file" 2>/dev/null || true
    echo "✅ 1Password authenticated successfully"
}

# Função para injeção automática de secrets em qualquer diretório
op_inject_env() {
    local env_type="${1:-local}"
    local template_name=".env.template.${env_type}"
    local output_name=".env"
    local search_dirs=("." "$HOME/infra/stack-local" "$(pwd)")
    
    local template_path=""
    local output_path=""
    
    # Procurar template
    for dir in "${search_dirs[@]}"; do
        if [ -f "$dir/$template_name" ]; then
            template_path="$dir/$template_name"
            output_path="$dir/$output_name"
            break
        fi
    done
    
    if [ -z "$template_path" ]; then
        echo "❌ Template não encontrado: $template_name"
        echo "   Procurou em: ${search_dirs[*]}"
        return 1
    fi
    
    # Autenticar se necessário
    op_auto_auth
    
    # Injetar secrets
    echo "🔐 Injecting secrets from $template_path..."
    op inject -i "$template_path" -o "$output_path" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Secrets injetados em $output_path"
        
        # Verificar referências não resolvidas
        if grep -q "op://" "$output_path" 2>/dev/null; then
            local unresolved=$(grep -c "op://" "$output_path")
            echo "⚠️  $unresolved referência(s) não resolvida(s) encontrada(s)"
        fi
    else
        echo "❌ Falha ao injetar secrets"
        return 1
    fi
}

# Alias para compatibilidade
op_framework_auth() {
    op_auto_auth
}

# Vault-specific functions
op_get_vault_id() {
    local vault_name="$1"
    if ! command -v op >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
        echo "❌ op ou jq não estão instalados"
        return 1
    fi
    op vault list --format json | jq -r ".[] | select(.name == \"$vault_name\") | .id"
}

op_list_vault_items() {
    local vault_name="$1"
    if ! command -v op >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
        echo "❌ op ou jq não estão instalados"
        return 1
    fi
    
    local vault_id=$(op_get_vault_id "$vault_name")
    if [[ -n "$vault_id" ]]; then
        op item list --vault "$vault_id" --format json | jq -r ".[] | \"\(.title) - \(.id)\""
    else
        echo "❌ Vault '$vault_name' not found"
    fi
}

# Collection functions
op_collect_vault() {
    local source_vault="$1"
    local target_vault_macos="${2:-1p_macos}"
    local target_vault_vps="${3:-1p_vps}"

    if ! command -v op >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
        echo "❌ op ou jq não estão instalados"
        return 1
    fi

    echo "🔍 Collecting from vault: $source_vault"

    # Ensure authentication
    op_auto_auth

    # Get vault ID
    local vault_id=$(op_get_vault_id "$source_vault")
    if [[ -z "$vault_id" ]]; then
        echo "❌ Source vault '$source_vault' not found"
        return 1
    fi

    echo "📋 Vault ID: $vault_id"

    # List items
    echo "📊 Items in vault:"
    op_list_vault_items "$source_vault"

    # Create collection report
    local report_file="vault-collection-$(date +%Y%m%d_%H%M%S).json"
    if op item list --vault "$vault_id" --format json > "$report_file" 2>/dev/null; then
        echo "📄 Collection report saved: $report_file"
    else
        echo "❌ Erro ao criar relatório de coleta"
        return 1
    fi

    echo "✅ Vault data collection completed"
}
