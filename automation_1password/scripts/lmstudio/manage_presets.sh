#!/bin/bash
set -euo pipefail

# manage_presets.sh
# Gerencia presets e modelos de agentes experts para LM Studio
# Integra com contexto detalhado do automation_1password

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
LM_STUDIO_ROOT="${HOME}/.lmstudio"
PRESETS_DIR="${LM_STUDIO_ROOT}/config-presets"
AUTOMATION_PRESETS="${AUTOMATION_ROOT}/prompts/lmstudio/presets"
CONTEXT_DIR="${AUTOMATION_ROOT}/context"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/logs/lmstudio_presets_${TIMESTAMP}.log"

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

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$AUTOMATION_PRESETS"
mkdir -p "$PRESETS_DIR"

# LM Studio API
LM_STUDIO_API="http://localhost:1234/v1"

show_help() {
  cat << EOF
Uso: $0 <comando> [opções]

Comandos:
  init              - Inicializar estrutura de presets
  create <nome>      - Criar novo preset de agente expert
  list               - Listar todos os presets
  show <nome>        - Mostrar preset
  deploy <nome>      - Deploy preset para LM Studio
  test <nome>        - Testar preset via API
  sync               - Sincronizar presets do projeto para LM Studio
  validate           - Validar todos os presets

Opções:
  --model MODEL      - Modelo a usar (padrão: detectado do LM Studio)
  --port PORT        - Porta do LM Studio (padrão: 1234)

Exemplos:
  $0 init
  $0 create agent_expert_1password
  $0 deploy agent_expert_1password
  $0 test agent_expert_1password
EOF
}

# Carregar contexto do projeto
load_context() {
  local context_file="${CONTEXT_DIR}/indexes/context_manifest_20251030.json"
  local index_file="${CONTEXT_DIR}/indexes/context_full_20251030.json"
  
  if [[ -f "$context_file" ]]; then
    cat "$context_file"
  elif [[ -f "$index_file" ]]; then
    jq -r '.summary // "Context loaded"' "$index_file" 2>/dev/null || echo "Context available"
  else
    echo "Context: automation_1password project structure and documentation"
  fi
}

# Gerar system prompt do contexto
generate_system_prompt() {
  local agent_type="$1"
  
  cat << EOF
# Agent Expert: ${agent_type}
# Automation 1Password - Context-Aware Expert Agent

## Project Context

$(load_context)

## Your Role

You are an expert agent specialized in ${agent_type} for the automation_1password project.

### Project Structure
- Root: ~/Dotfiles/automation_1password
- Documentation: README.md, INDEX.md, ARCHITECTURE_REPORT.md
- Runbooks: docs/runbooks/
- Context: context/curated/, context/indexes/
- Scripts: scripts/

### Key Technologies
- 1Password CLI (op) for secrets management
- macOS Silicon + VPS Ubuntu hybrid environment
- Docker/Colima for containerization
- SSH for remote operations
- direnv for environment management

### Important Paths
- macOS: ~/Dotfiles/automation_1password
- VPS: ~/Dotfiles/automation_1password
- LM Studio: ~/.lmstudio/models (port 1234)
- 1Password: op://vault/item/field

## Instructions

1. Always reference project documentation when available
2. Use 1Password CLI for secrets (never hardcode)
3. Detect environment (macOS vs Ubuntu) before operations
4. Provide complete, tested solutions
5. Include error handling and validation
6. Document all significant changes

## Output Format

- Markdown for documentation
- JSON for structured data
- YAML for configurations
- Shell scripts with proper error handling

EOF
}

# Inicializar estrutura
init_structure() {
  log "Inicializando estrutura de presets LM Studio..."
  
  mkdir -p "${AUTOMATION_PRESETS}"/{agents,models,configs}
  
  # Criar preset template
  cat > "${AUTOMATION_PRESETS}/.template.json" << 'TEMPLATE'
{
  "name": "{{NAME}}",
  "model": "{{MODEL}}",
  "temperature": 0.7,
  "max_tokens": 4096,
  "top_p": 0.9,
  "frequency_penalty": 0.0,
  "presence_penalty": 0.0,
  "stop": [],
  "system_prompt": "{{SYSTEM_PROMPT}}",
  "context_files": [
    "{{CONTEXT_PATH}}"
  ],
  "tools": [],
  "mcp_servers": []
}
TEMPLATE

  log_success "Estrutura inicializada"
  log "Diretórios criados:"
  log "  - ${AUTOMATION_PRESETS}/agents (agentes experts)"
  log "  - ${AUTOMATION_PRESETS}/models (configurações de modelos)"
  log "  - ${AUTOMATION_PRESETS}/configs (configs avançadas)"
}

# Criar preset de agente
create_agent_preset() {
  local name="$1"
  local agent_type="${2:-expert}"
  
  if [[ -z "$name" ]]; then
    log_error "Nome do preset é obrigatório"
    show_help
    exit 1
  fi
  
  local preset_file="${AUTOMATION_PRESETS}/agents/${name}.json"
  
  if [[ -f "$preset_file" ]]; then
    log_error "Preset '${name}' já existe"
    exit 1
  fi
    
  log "Criando preset de agente: ${name}"
  
  # Gerar system prompt
  local system_prompt=$(generate_system_prompt "$agent_type")
  
  # Criar preset JSON
  cat > "$preset_file" << EOF
{
  "name": "${name}",
  "type": "agent_expert",
  "model": {
    "provider": "lmstudio",
    "endpoint": "http://localhost:1234/v1",
    "model_name": "auto-detect"
  },
  "temperature": 0.7,
  "max_tokens": 4096,
  "top_p": 0.9,
  "frequency_penalty": 0.0,
  "presence_penalty": 0.0,
  "stop": [],
  "system_prompt": $(echo "$system_prompt" | jq -Rs .),
  "context": {
    "project_root": "${HOME}/Dotfiles/automation_1password",
    "index_file": "${CONTEXT_DIR}/indexes/context_full_20251030.json",
    "manifest_file": "${CONTEXT_DIR}/indexes/context_manifest_20251030.json",
    "key_docs": [
      "README.md",
      "INDEX.md",
      "ARCHITECTURE_REPORT.md"
    ],
    "runbooks": "docs/runbooks/"
  },
  "tools": [
    "1password_cli",
    "ssh_remote",
    "docker_management",
    "file_operations"
  ],
  "mcp_servers": [
    "mcp/huggingface",
    "lmstudio/rag-v1"
  ],
  "capabilities": [
    "code_generation",
    "documentation",
    "troubleshooting",
    "architecture_analysis",
    "script_automation"
  ],
  "metadata": {
    "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "version": "1.0.0",
    "author": "automation_1password"
  }
}
EOF
  
  log_success "Preset criado: ${preset_file}"
}

# Listar presets
list_presets() {
  log "Presets disponíveis:"
  echo ""
  
  if [[ -d "${AUTOMATION_PRESETS}/agents" ]]; then
    echo "🤖 Agentes Experts:"
    ls -1 "${AUTOMATION_PRESETS}/agents"/*.json 2>/dev/null | while read -r file; do
      name=$(basename "$file" .json)
      echo "  - ${name}"
    done || echo "  (nenhum)"
    echo ""
  fi
  
  # Listar presets no LM Studio
  if [[ -d "$PRESETS_DIR" ]]; then
    echo "📁 Presets no LM Studio:"
    ls -1 "$PRESETS_DIR"/*.json 2>/dev/null | while read -r file; do
      name=$(basename "$file" .json)
      echo "  - ${name}"
    done || echo "  (nenhum)"
  fi
}

# Mostrar preset
show_preset() {
  local name="$1"
  
  if [[ -z "$name" ]]; then
    log_error "Nome do preset é obrigatório"
    exit 1
  fi
  
  local preset_file="${AUTOMATION_PRESETS}/agents/${name}.json"
  
  if [[ ! -f "$preset_file" ]]; then
    log_error "Preset '${name}' não encontrado"
    exit 1
  fi
  
  log "Conteúdo do preset: ${name}"
  cat "$preset_file" | jq '.' 2>/dev/null || cat "$preset_file"
}

# Deploy para LM Studio
deploy_preset() {
  local name="$1"
  
  if [[ -z "$name" ]]; then
    log_error "Nome do preset é obrigatório"
    exit 1
  fi
  
  local source_file="${AUTOMATION_PRESETS}/agents/${name}.json"
  local target_file="${PRESETS_DIR}/${name}.json"
  
  if [[ ! -f "$source_file" ]]; then
    log_error "Preset '${name}' não encontrado em ${AUTOMATION_PRESETS}/agents/"
    exit 1
  fi
  
  log "Fazendo deploy de '${name}' para LM Studio..."
  
  # Converter para formato do LM Studio se necessário
  cp "$source_file" "$target_file"
  
  log_success "Preset deployado: ${target_file}"
  log "Recarregue o LM Studio para ver o novo preset"
}

# Testar preset via API
test_preset() {
  local name="$1"
  
  if [[ -z "$name" ]]; then
    log_error "Nome do preset é obrigatório"
    exit 1
  fi
  
  log "Testando preset '${name}' via API..."
  
  # Verificar se LM Studio está rodando
  if ! curl -s "${LM_STUDIO_API}/models" > /dev/null 2>&1; then
    log_error "LM Studio não está respondendo em ${LM_STUDIO_API}"
    log "Certifique-se de que o servidor está rodando na porta 1234"
    exit 1
  fi
  
  local preset_file="${AUTOMATION_PRESETS}/agents/${name}.json"
  
  if [[ ! -f "$preset_file" ]]; then
    log_error "Preset não encontrado"
    exit 1
  fi
  
  # Extrair system prompt
  local system_prompt=$(jq -r '.system_prompt' "$preset_file" 2>/dev/null || echo "")
  
  if [[ -z "$system_prompt" ]]; then
    log_warning "System prompt não encontrado no preset"
    system_prompt="You are a helpful assistant."
  fi
  
  # Testar com uma mensagem simples
  log "Enviando mensagem de teste..."
  
  local response=$(curl -s -X POST "${LM_STUDIO_API}/chat/completions" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"local-model\",
      \"messages\": [
        {\"role\": \"system\", \"content\": $(echo "$system_prompt" | jq -Rs .)},
        {\"role\": \"user\", \"content\": \"Hello, can you confirm you are working?\"}
      ],
      \"temperature\": 0.7,
      \"max_tokens\": 100
    }" 2>/dev/null)
  
  if echo "$response" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
    local content=$(echo "$response" | jq -r '.choices[0].message.content')
    log_success "Resposta recebida:"
    echo "$content" | head -5
  else
    log_error "Erro na resposta da API"
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
  fi
}

# Sincronizar todos os presets
sync_presets() {
  log "Sincronizando presets para LM Studio..."
  
  local count=0
  
  for preset in "${AUTOMATION_PRESETS}/agents"/*.json; do
    [[ -f "$preset" ]] || continue
    
    local name=$(basename "$preset" .json)
    deploy_preset "$name"
    ((count++))
  done
  
  log_success "${count} preset(s) sincronizado(s)"
}

# Validar presets
validate_presets() {
  log "Validando presets..."
  
  local errors=0
  
  for preset in "${AUTOMATION_PRESETS}/agents"/*.json; do
    [[ -f "$preset" ]] || continue
    
    local name=$(basename "$preset" .json)
    
    if jq empty "$preset" 2>/dev/null; then
      log_success "✓ ${name} (JSON válido)"
    else
      log_error "✗ ${name} (JSON inválido)"
      ((errors++))
    fi
  done
  
  if (( errors == 0 )); then
    log_success "Todos os presets são válidos"
  else
    log_error "${errors} preset(s) com erros"
    exit 1
  fi
}

# Main
COMMAND="${1:-help}"

case "$COMMAND" in
  init)
    init_structure
    ;;
  create)
    create_agent_preset "${2:-}" "${3:-}"
    ;;
  list)
    list_presets
    ;;
  show)
    show_preset "${2:-}"
    ;;
  deploy)
    deploy_preset "${2:-}"
    ;;
  test)
    test_preset "${2:-}"
    ;;
  sync)
    sync_presets
    ;;
  validate)
    validate_presets
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

