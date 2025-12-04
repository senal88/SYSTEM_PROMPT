#!/bin/bash
#
# Script: run_all_v1.0.0_20251202.sh
# Descrição: Orquestra todas as tarefas principais para o componente 'antigravity'.
#
# Autor: Gemini
# Data: 2025-12-02
# Versão: 1.0.0

# --- Variáveis ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/run_all_$(date +%Y%m%d_%H%M%S).log"
DEPLOY_SCRIPT="$SCRIPT_DIR/deploy_antigravity_macos_v1.0.0_20251202.sh"

# --- Funções ---

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

run_step() {
    local step_name="$1"
    local command_to_run="$2"

    log "--- INICIANDO ETAPA: $step_name ---"
    if eval "$command_to_run"; then
        log "--- SUCESSO NA ETAPA: $step_name ---"
    else
        log "--- ERRO NA ETAPA: $step_name ---"
        log "Abortando a orquestração."
        exit 1
    fi
}

# --- Execução ---

mkdir -p "$LOG_DIR"

log "============================================="
log "Início da Orquestração 'Antigravity'"
log "============================================="

# Etapa 1: Deploy
# No futuro, outras etapas como auditoria, testes, etc., podem ser adicionadas aqui.
run_step "Deploy" "bash '$DEPLOY_SCRIPT'"

log "============================================="
log "Fim da Orquestração 'Antigravity'"
log "============================================="

exit 0
