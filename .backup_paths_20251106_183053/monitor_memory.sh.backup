#!/bin/bash
set -euo pipefail

# monitor_memory.sh
# Monitora uso de memória durante execuções de scripts pesados
# Uso: ./monitor_memory.sh [PID do processo a monitorar]

PID="${1:-$$}"
INTERVAL="${INTERVAL:-5}"
REPORT_DIR="${HOME}/Dotfiles/automation_1password/exports"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${REPORT_DIR}/memory_monitor_${TIMESTAMP}.log"

mkdir -p "$REPORT_DIR"

echo "[INFO] Monitoramento de memória iniciado em $(date)"
echo "[INFO] Monitorando processo PID: ${PID}"
echo "[INFO] Intervalo: ${INTERVAL} segundos"
echo "[INFO] Log: ${LOG_FILE}"
echo ""

{
  echo "Timestamp,FreePages,ActivePages,InactivePages,WiredPages,ProcessRSS(MB),ProcessCPU%"
  
  while kill -0 "$PID" 2>/dev/null; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Memória do sistema
    vm_stats=$(vm_stat | grep -E "(Pages free|Pages active|Pages inactive|Pages wired)" | \
      awk '{gsub(/\./, "", $3); print $3}')
    
    free_pages=$(echo "$vm_stats" | sed -n '1p')
    active_pages=$(echo "$vm_stats" | sed -n '2p')
    inactive_pages=$(echo "$vm_stats" | sed -n '3p')
    wired_pages=$(echo "$vm_stats" | sed -n '4p')
    
    # Memória do processo
    if ps -p "$PID" > /dev/null 2>&1; then
      proc_stats=$(ps -p "$PID" -o rss=,%cpu= 2>/dev/null || echo "0 0.0")
      rss_mb=$(echo "$proc_stats" | awk '{print $1/1024}')
      cpu_pct=$(echo "$proc_stats" | awk '{print $2}')
    else
      rss_mb="0"
      cpu_pct="0.0"
    fi
    
    echo "${timestamp},${free_pages},${active_pages},${inactive_pages},${wired_pages},${rss_mb},${cpu_pct}"
    
    sleep "$INTERVAL"
  done
} | tee "$LOG_FILE"

echo ""
echo "[INFO] Processo PID ${PID} finalizado"
echo "[INFO] Monitoramento concluído em $(date)"
echo "[INFO] Log completo: ${LOG_FILE}"

