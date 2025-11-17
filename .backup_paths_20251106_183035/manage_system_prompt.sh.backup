#!/bin/bash
set -euo pipefail

# manage_system_prompt.sh
# Gerencia system_prompt global híbrido para macOS Silicon + VPS Ubuntu
# Suporta criação, edição, sincronização e deploy entre ambientes

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
PROMPTS_DIR="${AUTOMATION_ROOT}/prompts/system"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/logs/system_prompt_${TIMESTAMP}.log"

# Configuração VPS (ajustar conforme necessário)
VPS_HOST="${VPS_HOST:-}"
VPS_USER="${VPS_USER:-}"
VPS_PROMPTS_DIR="${VPS_PROMPTS_DIR:-~/Dotfiles/automation_1password/prompts/system}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
  echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
  echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] ✅ $1${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
  echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] ⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
  echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ❌ $1${NC}" | tee -a "$LOG_FILE"
}

log_info() {
  echo -e "${CYAN}[$(date +'%Y-%m-%d %H:%M:%S')] ℹ️  $1${NC}" | tee -a "$LOG_FILE"
}

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$PROMPTS_DIR"

show_help() {
  cat << EOF
Uso: $0 <comando> [opções]

Comandos:
  init              - Inicializar estrutura de system_prompt híbrido
  create <nome>     - Criar novo system_prompt
  edit <nome>       - Editar system_prompt existente
  list              - Listar todos os system_prompts
  show <nome>       - Mostrar conteúdo do system_prompt
  sync <nome>       - Sincronizar com VPS Ubuntu (via SSH)
  deploy <nome>     - Deploy completo (local + VPS)
  validate <nome>   - Validar system_prompt
  diff <nome>       - Comparar versões local vs VPS
  backup            - Criar backup de todos os prompts

Opções:
  --vps-host HOST   - Host do VPS (ex: 147.79.81.59)
  --vps-user USER   - Usuário do VPS (ex: luiz.sena88)
  --vps-dir DIR     - Diretório no VPS (padrão: ~/Dotfiles/automation_1password/prompts/system)

Exemplos:
  $0 init
  $0 create global_hybrid
  $0 edit global_hybrid
  $0 sync global_hybrid --vps-host 147.79.81.59 --vps-user luiz.sena88
  $0 deploy global_hybrid --vps-host 147.79.81.59
EOF
}

# Detectar ambiente atual
detect_environment() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  elif [[ "$(uname)" == "Linux" ]]; then
    echo "ubuntu"
  else
    echo "unknown"
  fi
}

# Inicializar estrutura
init_structure() {
  log "Inicializando estrutura de system_prompt híbrido..."
  
  mkdir -p "${PROMPTS_DIR}"/{macos,ubuntu,shared,versions}
  
  # Criar template base
  cat > "${PROMPTS_DIR}/shared/.template.md" << 'TEMPLATE'
# System Prompt: {{NAME}}
## Ambiente: Híbrido (macOS Silicon + VPS Ubuntu)

Last Updated: {{DATE}}
Version: 1.0.0

## Context

### Ambiente macOS Silicon
- Sistema: macOS {{VERSION}}
- Chip: Apple Silicon (M1/M2/M3)
- Shell: zsh
- 1Password: Desktop App + CLI
- Autenticação: Biométrica (Touch ID/Face ID)

### Ambiente VPS Ubuntu
- Sistema: Ubuntu {{UBUNTU_VERSION}}
- Shell: bash
- 1Password: CLI apenas (headless)
- Autenticação: Service Account Token

## Rules

### Plataforma Híbrida
- Use detecção de ambiente: `[[ "$(uname)" == "Darwin" ]]` para macOS, `[[ "$(uname)" == "Linux" ]]` para Ubuntu
- Sempre verificar se comando/tool existe antes de usar
- Usar caminhos relativos quando possível
- Padronizar formatos de saída entre ambientes

### 1Password Integration
- macOS: Usar `op signin` interativo ou autenticação biométrica
- Ubuntu: Usar `OP_SERVICE_ACCOUNT_TOKEN` via variável de ambiente
- Sempre validar autenticação: `op whoami`

### Paths e Variáveis
- macOS: `~/Dotfiles/automation_1password`
- Ubuntu: `~/Dotfiles/automation_1password`
- Usar `$HOME` ao invés de `~` em scripts

## Examples

### Detecção de Ambiente
```bash
if [[ "$(uname)" == "Darwin" ]]; then
  # Código macOS
elif [[ "$(uname)" == "Linux" ]]; then
  # Código Ubuntu
fi
```

### 1Password Authentication
```bash
if [[ "$(uname)" == "Darwin" ]]; then
  op signin
else
  export OP_SERVICE_ACCOUNT_TOKEN="${OP_SERVICE_ACCOUNT_TOKEN}"
  op whoami || { echo "Erro: 1Password não autenticado"; exit 1; }
fi
```

## Output Format
- Markdown para documentação
- JSON para dados estruturados
- YAML para configurações
TEMPLATE

  log_success "Estrutura inicializada"
  log "Diretórios criados:"
  log "  - ${PROMPTS_DIR}/macos (específico macOS)"
  log "  - ${PROMPTS_DIR}/ubuntu (específico Ubuntu)"
  log "  - ${PROMPTS_DIR}/shared (compartilhado)"
  log "  - ${PROMPTS_DIR}/versions (versões históricas)"
}

# Criar novo system_prompt
create_prompt() {
  local name="$1"
  
  if [[ -z "$name" ]]; then
    log_error "Nome do prompt é obrigatório"
    show_help
    exit 1
  fi
  
  local prompt_file="${PROMPTS_DIR}/shared/${name}.md"
  
  if [[ -f "$prompt_file" ]]; then
    log_error "System prompt '${name}' já existe"
    exit 1
  fi
  
  log "Criando system_prompt: ${name}"
  
  # Copiar template e substituir variáveis
  sed -e "s/{{NAME}}/${name}/g" \
      -e "s/{{DATE}}/$(date +%Y-%m-%d)/g" \
      -e "s/{{VERSION}}/$(sw_vers -productVersion 2>/dev/null || echo 'N/A')/g" \
      -e "s/{{UBUNTU_VERSION}}/$(lsb_release -rs 2>/dev/null || echo 'N/A')/g" \
      "${PROMPTS_DIR}/shared/.template.md" > "$prompt_file"
  
  log_success "System prompt criado: ${prompt_file}"
  log_info "Edite o arquivo para customizar o prompt"
}

# Listar prompts
list_prompts() {
  log "System Prompts disponíveis:"
  echo ""
  
  if [[ -d "${PROMPTS_DIR}/shared" ]]; then
    echo "📋 Compartilhados (Híbridos):"
    ls -1 "${PROMPTS_DIR}/shared"/*.md 2>/dev/null | while read -r file; do
      name=$(basename "$file" .md)
      [[ "$name" != ".template" ]] && echo "  - ${name}"
    done
    echo ""
  fi
  
  if [[ -d "${PROMPTS_DIR}/macos" ]]; then
    echo "🍎 macOS Específicos:"
    ls -1 "${PROMPTS_DIR}/macos"/*.md 2>/dev/null 2>/dev/null | while read -r file; do
      echo "  - $(basename "$file" .md)"
    done || echo "  (nenhum)"
    echo ""
  fi
  
  if [[ -d "${PROMPTS_DIR}/ubuntu" ]]; then
    echo "🐧 Ubuntu Específicos:"
    ls -1 "${PROMPTS_DIR}/ubuntu"/*.md 2>/dev/null | while read -r file; do
      echo "  - $(basename "$file" .md)"
    done || echo "  (nenhum)"
    echo ""
  fi
}

# Mostrar prompt
show_prompt() {
  local name="$1"
  
  if [[ -z "$name" ]]; then
    log_error "Nome do prompt é obrigatório"
    exit 1
  fi
  
  local shared_file="${PROMPTS_DIR}/shared/${name}.md"
  local macos_file="${PROMPTS_DIR}/macos/${name}.md"
  local ubuntu_file="${PROMPTS_DIR}/ubuntu/${name}.md"
  
  ENV=$(detect_environment)
  
  if [[ "$ENV" == "macos" ]] && [[ -f "$macos_file" ]]; then
    log_info "Mostrando versão macOS:"
    cat "$macos_file"
  elif [[ "$ENV" == "ubuntu" ]] && [[ -f "$ubuntu_file" ]]; then
    log_info "Mostrando versão Ubuntu:"
    cat "$ubuntu_file"
  elif [[ -f "$shared_file" ]]; then
    log_info "Mostrando versão compartilhada:"
    cat "$shared_file"
  else
    log_error "Prompt '${name}' não encontrado"
    exit 1
  fi
}

# Sincronizar com VPS
sync_to_vps() {
  local name="$1"
  shift
  
  # Parse opções
  while [[ $# -gt 0 ]]; do
    case $1 in
      --vps-host) VPS_HOST="$2"; shift 2 ;;
      --vps-user) VPS_USER="$2"; shift 2 ;;
      --vps-dir) VPS_PROMPTS_DIR="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
  
  if [[ -z "$VPS_HOST" ]] || [[ -z "$VPS_USER" ]]; then
    log_error "VPS_HOST e VPS_USER são obrigatórios"
    log "Use: --vps-host HOST --vps-user USER"
    exit 1
  fi
  
  local shared_file="${PROMPTS_DIR}/shared/${name}.md"
  local macos_file="${PROMPTS_DIR}/macos/${name}.md"
  local ubuntu_file="${PROMPTS_DIR}/ubuntu/${name}.md"
  
  if [[ ! -f "$shared_file" ]] && [[ ! -f "$ubuntu_file" ]]; then
    log_error "Prompt '${name}' não encontrado"
    exit 1
  fi
  
  log "Sincronizando '${name}' para VPS ${VPS_USER}@${VPS_HOST}..."
  
  # Criar diretório no VPS
  ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_PROMPTS_DIR}/{shared,ubuntu,versions}"
  
  # Enviar arquivos
  if [[ -f "$shared_file" ]]; then
    log "Enviando versão compartilhada..."
    scp "$shared_file" "${VPS_USER}@${VPS_HOST}:${VPS_PROMPTS_DIR}/shared/"
  fi
  
  if [[ -f "$ubuntu_file" ]]; then
    log "Enviando versão Ubuntu..."
    scp "$ubuntu_file" "${VPS_USER}@${VPS_HOST}:${VPS_PROMPTS_DIR}/ubuntu/"
  fi
  
  log_success "Sincronização concluída"
}

# Comparar versões
diff_prompt() {
  local name="$1"
  shift
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      --vps-host) VPS_HOST="$2"; shift 2 ;;
      --vps-user) VPS_USER="$2"; shift 2 ;;
      --vps-dir) VPS_PROMPTS_DIR="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
  
  if [[ -z "$VPS_HOST" ]] || [[ -z "$VPS_USER" ]]; then
    log_error "VPS_HOST e VPS_USER são obrigatórios"
    exit 1
  fi
  
  local local_file="${PROMPTS_DIR}/shared/${name}.md"
  local remote_file="${VPS_PROMPTS_DIR}/shared/${name}.md"
  
  log "Comparando versões local vs VPS..."
  
  if ssh "${VPS_USER}@${VPS_HOST}" "test -f ${remote_file}"; then
    log "Diferenças encontradas:"
    diff <(cat "$local_file") <(ssh "${VPS_USER}@${VPS_HOST}" "cat ${remote_file}") || true
  else
    log_warning "Arquivo não existe no VPS"
  fi
}

# Validar prompt
validate_prompt() {
  local name="$1"
  local shared_file="${PROMPTS_DIR}/shared/${name}.md"
  local macos_file="${PROMPTS_DIR}/macos/${name}.md"
  local ubuntu_file="${PROMPTS_DIR}/ubuntu/${name}.md"
  
  log "Validando system_prompt: ${name}"
  
  local errors=0
  
  if [[ ! -f "$shared_file" ]] && [[ ! -f "$macos_file" ]] && [[ ! -f "$ubuntu_file" ]]; then
    log_error "Nenhuma versão do prompt encontrada"
    ((errors++))
  fi
  
  # Validar markdown básico
  for file in "$shared_file" "$macos_file" "$ubuntu_file"; do
    [[ -f "$file" ]] || continue
    
    if ! grep -q "^#" "$file"; then
      log_warning "Arquivo sem headers Markdown: $(basename "$file")"
    fi
    
    if ! grep -qi "1password\|op\|vault" "$file"; then
      log_warning "Arquivo pode não ter referências ao 1Password: $(basename "$file")"
    fi
  done
  
  if (( errors == 0 )); then
    log_success "Validação concluída sem erros críticos"
  else
    log_error "Validação encontrou ${errors} erro(s)"
    exit 1
  fi
}

# Backup
backup_prompts() {
  local backup_dir="${PROMPTS_DIR}/versions/backup_${TIMESTAMP}"
  
  log "Criando backup..."
  mkdir -p "$backup_dir"
  
  cp -r "${PROMPTS_DIR}"/{shared,macos,ubuntu}/*.md "$backup_dir" 2>/dev/null || true
  
  log_success "Backup criado: ${backup_dir}"
}

# Main
COMMAND="${1:-help}"

case "$COMMAND" in
  init)
    init_structure
    ;;
  create)
    create_prompt "${2:-}"
    ;;
  list)
    list_prompts
    ;;
  show)
    show_prompt "${2:-}"
    ;;
  sync)
    sync_to_vps "${2:-}" "${@:3}"
    ;;
  diff)
    diff_prompt "${2:-}" "${@:3}"
    ;;
  validate)
    validate_prompt "${2:-}"
    ;;
  backup)
    backup_prompts
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    log_error "Comando desconhecido: ${COMMAND}"
    show_help
    exit 1
    ;;
esac

