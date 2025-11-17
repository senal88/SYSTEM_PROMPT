#!/bin/bash
set -euo pipefail

# select_and_test_model.sh
# Script interativo para selecionar e testar modelo no LM Studio
# Integra com presets do automation_1password

LM_STUDIO_API="http://localhost:1234/v1"
AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
PRESETS_DIR="${AUTOMATION_ROOT}/prompts/lmstudio/presets"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
  echo -e "${BLUE}[LM Studio]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[LM Studio] ✅${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[LM Studio] ⚠️${NC} $1"
}

# Verificar se LM Studio está rodando
check_lm_studio() {
  log "Verificando conexão com LM Studio..."
  
  if ! curl -s "${LM_STUDIO_API}/models" > /dev/null 2>&1; then
    log_warning "LM Studio não está respondendo em ${LM_STUDIO_API}"
    log "Certifique-se de que:"
    log "  1. LM Studio está rodando"
    log "  2. Servidor está na porta 1234"
    log "  3. 'Servir na Rede Local' está habilitado"
    return 1
  fi
  
  log_success "LM Studio está respondendo"
  return 0
}

# Listar modelos disponíveis
list_models() {
  log "Listando modelos disponíveis..."
  
  MODELS_JSON=$(curl -s "${LM_STUDIO_API}/models")
  
  if echo "$MODELS_JSON" | jq -e '.data' > /dev/null 2>&1; then
    echo "$MODELS_JSON" | jq -r '.data[] | "\(.id) - \(.object)"'
  else
    log_warning "Nenhum modelo encontrado ou formato inesperado"
    echo "$MODELS_JSON" | jq '.' || echo "$MODELS_JSON"
  fi
}

# Testar modelo com preset
test_model_with_preset() {
  local model="${1:-local-model}"
  local preset_name="${2:-agent_expert_1password}"
  
  local preset_file="${PRESETS_DIR}/agents/${preset_name}.json"
  
  if [[ ! -f "$preset_file" ]]; then
    log_warning "Preset não encontrado: ${preset_file}"
    return 1
  fi
  
  log "Testando modelo '${model}' com preset '${preset_name}'..."
  
  # Extrair system prompt
  local system_prompt=$(jq -r '.operation.fields[] | select(.key == "llm.prediction.systemPrompt") | .value' "$preset_file" 2>/dev/null || echo "You are a helpful assistant.")
  
  # Fazer requisição de teste
  local response=$(curl -s -X POST "${LM_STUDIO_API}/chat/completions" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"${model}\",
      \"messages\": [
        {\"role\": \"system\", \"content\": $(echo "$system_prompt" | jq -Rs .)},
        {\"role\": \"user\", \"content\": \"Você é o agent expert do automation_1password? Responda apenas 'SIM' ou 'NÃO'.\"}
      ],
      \"temperature\": 0.7,
      \"max_tokens\": 50
    }" 2>/dev/null)
  
  if echo "$response" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
    local content=$(echo "$response" | jq -r '.choices[0].message.content')
    log_success "Modelo respondeu:"
    echo "  ${content}"
    return 0
  else
    log_warning "Erro na resposta:"
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    return 1
  fi
}

# Menu interativo
show_menu() {
  cat << EOF

╔════════════════════════════════════════════════════════╗
║  LM Studio - Seleção e Teste de Modelos                ║
╚════════════════════════════════════════════════════════╝

1. Verificar conexão LM Studio
2. Listar modelos disponíveis
3. Testar modelo com preset agent_expert_1password
4. Testar modelo com preset agent_expert_vps
5. Testar modelo com preset agent_expert_memory
6. Teste completo (listar + testar todos os presets)
7. Sair

EOF
}

# Main
main() {
  log "LM Studio - Seleção e Teste de Modelos"
  
  if ! check_lm_studio; then
    log_warning "Não foi possível conectar ao LM Studio"
    log "Execute este script após iniciar o LM Studio"
    exit 1
  fi
  
  while true; do
    show_menu
    read -p "Escolha uma opção: " choice
    
    case "$choice" in
      1)
        check_lm_studio
        ;;
      2)
        list_models
        ;;
      3)
        read -p "Nome do modelo (ou Enter para 'local-model'): " model
        test_model_with_preset "${model:-local-model}" "agent_expert_1password"
        ;;
      4)
        read -p "Nome do modelo (ou Enter para 'local-model'): " model
        test_model_with_preset "${model:-local-model}" "agent_expert_vps"
        ;;
      5)
        read -p "Nome do modelo (ou Enter para 'local-model'): " model
        test_model_with_preset "${model:-local-model}" "agent_expert_memory"
        ;;
      6)
        log "Executando teste completo..."
        list_models
        echo ""
        for preset in agent_expert_1password agent_expert_vps agent_expert_memory; do
          echo ""
          test_model_with_preset "local-model" "$preset"
        done
        ;;
      7)
        log "Saindo..."
        exit 0
        ;;
      *)
        log_warning "Opção inválida"
        ;;
    esac
    
    echo ""
    read -p "Pressione Enter para continuar..."
  done
}

main

