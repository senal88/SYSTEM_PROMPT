#!/bin/bash
set -euo pipefail

# sync_cursorrules_auto.sh
# Execução automática completa do fluxo de sincronização otimizado
# Inclui diagnóstico, limpeza, verificação e monitoramento

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/exports/sync_auto_${TIMESTAMP}.log"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Configurações
BATCH_SIZE="${BATCH_SIZE:-50}"
SKIP_DOCKER_CHECK="${SKIP_DOCKER_CHECK:-false}"
SKIP_CLEANUP="${SKIP_CLEANUP:-false}"
MONITOR_MEMORY="${MONITOR_MEMORY:-true}"

cd "$AUTOMATION_ROOT"

echo ""
log "🚀 Execução Automática de Sincronização de .cursorrules"
log "════════════════════════════════════════════════════════"
echo ""

# FASE 1: Diagnóstico Inicial
log "📊 FASE 1: Diagnóstico de Memória"
log "─────────────────────────────────"

DIAGNOSTIC_REPORT=$(mktemp)
if bash scripts/maintenance/diagnose_memory.sh 2>&1 | tee "$DIAGNOSTIC_REPORT"; then
  log_success "Diagnóstico concluído"
else
  log_error "Falha no diagnóstico"
  exit 1
fi

# Verificar páginas livres
FREE_PAGES=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
log "Páginas livres: ${FREE_PAGES}"

if (( FREE_PAGES < 10000 )); then
  log_warning "Pouca memória livre detectada (${FREE_PAGES} páginas)"
  log_warning "Reduzindo BATCH_SIZE para 25"
  BATCH_SIZE=25
fi

echo ""

# FASE 2: Limpeza de Processos Órfãos
if [[ "$SKIP_CLEANUP" != "true" ]]; then
  log "🧹 FASE 2: Limpeza de Processos Órfãos"
  log "──────────────────────────────────────"
  
  # Verificar processos órfãos (sem interação)
  FIND_ORPHANS=$(pgrep -f "^find.*Projetos" 2>/dev/null || true)
  GIT_ORPHANS=$(pgrep -f "^git.*init\|^git.*status" 2>/dev/null || true)
  
  if [[ -n "$FIND_ORPHANS" ]] || [[ -n "$GIT_ORPHANS" ]]; then
    log_warning "Processos órfãos detectados"
    if [[ -n "$FIND_ORPHANS" ]]; then
      log "  - Processos find: $(echo $FIND_ORPHANS | wc -w)"
      echo "$FIND_ORPHANS" | xargs kill -TERM 2>/dev/null || true
    fi
    if [[ -n "$GIT_ORPHANS" ]]; then
      log "  - Processos git: $(echo $GIT_ORPHANS | wc -w)"
      echo "$GIT_ORPHANS" | xargs kill -TERM 2>/dev/null || true
    fi
    sleep 2
    log_success "Processos órfãos finalizados"
  else
    log_success "Nenhum processo órfão encontrado"
  fi
else
  log "🧹 FASE 2: Limpeza de Processos Órfãos (pulada)"
fi

echo ""

# FASE 3: Verificação Docker/Colima
if [[ "$SKIP_DOCKER_CHECK" != "true" ]]; then
  log "🐳 FASE 3: Verificação Docker/Colima"
  log "────────────────────────────────────"
  
  DOCKER_CONTAINERS=$(docker ps --format "{{.Names}}" 2>/dev/null | wc -l | xargs || echo "0")
  if (( DOCKER_CONTAINERS > 0 )); then
    log "Docker: $DOCKER_CONTAINERS container(s) ativo(s)"
    docker ps --format "table {{.Names}}\t{{.Status}}" | tee -a "$LOG_FILE"
  else
    log_success "Docker: nenhum container ativo"
  fi
  
  if colima status &>/dev/null; then
    log "Colima: rodando"
  else
    log_success "Colima: não está rodando"
  fi
else
  log "🐳 FASE 3: Verificação Docker/Colima (pulada)"
fi

echo ""

# FASE 4: Execução da Sincronização
log "⚙️  FASE 4: Sincronização de .cursorrules"
log "─────────────────────────────────────────"
log "BATCH_SIZE: ${BATCH_SIZE}"
log "MAX_DEPTH: ${MAX_DEPTH:-3}"

SYNC_LOG="${AUTOMATION_ROOT}/exports/projetos_sync_cursorrules_${TIMESTAMP}.log"

if [[ "$MONITOR_MEMORY" == "true" ]]; then
  log "Monitoramento de memória: ATIVADO"
  
  # Executar sincronização em background
  BATCH_SIZE="$BATCH_SIZE" bash scripts/projetos/sync_cursorrules_optimized.sh > "$SYNC_LOG" 2>&1 &
  SYNC_PID=$!
  
  log "PID da sincronização: $SYNC_PID"
  
  # Monitorar memória em paralelo
  MONITOR_LOG="${AUTOMATION_ROOT}/exports/memory_monitor_${TIMESTAMP}.log"
  bash scripts/maintenance/monitor_memory.sh "$SYNC_PID" > "$MONITOR_LOG" 2>&1 &
  MONITOR_PID=$!
  
  log "Monitoramento iniciado (PID: $MONITOR_PID)"
  log "Aguardando conclusão da sincronização..."
  
  # Aguardar conclusão
  wait "$SYNC_PID"
  SYNC_EXIT=$?
  
  # Parar monitoramento após um breve delay
  sleep 2
  kill "$MONITOR_PID" 2>/dev/null || true
  
  if (( SYNC_EXIT == 0 )); then
    log_success "Sincronização concluída com sucesso"
  else
    log_error "Sincronização falhou (exit code: $SYNC_EXIT)"
    log "Verificar log: $SYNC_LOG"
  fi
  
  log "Log de monitoramento: $MONITOR_LOG"
else
  log "Monitoramento de memória: DESATIVADO"
  BATCH_SIZE="$BATCH_SIZE" bash scripts/projetos/sync_cursorrules_optimized.sh 2>&1 | tee -a "$SYNC_LOG"
fi

log "Log de sincronização: $SYNC_LOG"
echo ""

# FASE 5: Diagnóstico Final
log "📊 FASE 5: Diagnóstico Final"
log "──────────────────────────────"

FINAL_DIAGNOSTIC=$(mktemp)
if bash scripts/maintenance/diagnose_memory.sh 2>&1 | tee "$FINAL_DIAGNOSTIC"; then
  log_success "Diagnóstico final concluído"
else
  log_warning "Diagnóstico final teve problemas (continuando...)"
fi

FINAL_FREE_PAGES=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
log "Páginas livres (final): ${FINAL_FREE_PAGES}"

if (( FINAL_FREE_PAGES < FREE_PAGES / 2 )); then
  log_warning "Memória livre reduziu significativamente"
  log "Considerar executar limpeza de processos órfãos"
fi

echo ""

# Resumo Final
log "════════════════════════════════════════════════════════"
log_success "Execução Automática Concluída"
log "════════════════════════════════════════════════════════"
log ""
log "📁 Logs gerados:"
log "  - Execução completa: ${LOG_FILE}"
log "  - Sincronização: ${SYNC_LOG}"
[[ "$MONITOR_MEMORY" == "true" ]] && log "  - Monitoramento: ${MONITOR_LOG}"
log ""
log "💡 Próximos passos:"
log "  1. Revisar logs em: ${AUTOMATION_ROOT}/exports/"
log "  2. Validar .cursorrules nos projetos críticos"
log "  3. Executar limpeza se houver processos órfãos"
log ""

# Limpar arquivos temporários
rm -f "$DIAGNOSTIC_REPORT" "$FINAL_DIAGNOSTIC"

exit "${SYNC_EXIT:-0}"

