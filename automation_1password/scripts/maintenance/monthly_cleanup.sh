#!/bin/bash
set -euo pipefail

# monthly_cleanup.sh
# Rotina mensal de limpeza e snapshot (executado via launchd)

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
WORKSPACE_ROOT="${HOME}/workspace"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/logs/monthly_cleanup_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo "LIMPEZA MENSAL E SNAPSHOT"
echo "Data: $(date)"
echo "=========================================="

# 1. Limpeza de caches
echo ""
echo "[1/4] Limpeza de Caches"
echo "----------------------"

cd "$AUTOMATION_ROOT"
make clean.caches

# 2. Snapshot do workspace
echo ""
echo "[2/4] Gerando Snapshot"
echo "---------------------"

if [[ -d "$WORKSPACE_ROOT" ]]; then
  make snapshot.home
else
  echo "⚠️  Workspace não existe: ${WORKSPACE_ROOT}"
fi

# 3. Verificação de SHA do snapshot de arquitetura
echo ""
echo "[3/4] Verificando Integridade"
echo "----------------------------"

ARCHITECTURE_SNAPSHOT="${AUTOMATION_ROOT}/exports/architecture_system_snapshot_$(date +%Y%m%d).md"

if [[ -f "$ARCHITECTURE_SNAPSHOT" ]]; then
  SHA=$(shasum -a 256 "$ARCHITECTURE_SNAPSHOT" | awk '{print $1}')
  echo "✅ SHA-256 do snapshot: ${SHA}"
  
  # Registrar SHA em arquivo de controle
  echo "${TIMESTAMP},${SHA}" >> "${AUTOMATION_ROOT}/exports/snapshot_shas.txt"
else
  echo "⚠️  Snapshot não encontrado: ${ARCHITECTURE_SNAPSHOT}"
fi

# 4. Rotação de logs
echo ""
echo "[4/4] Rotação de Logs"
echo "-------------------"

find "${AUTOMATION_ROOT}/logs" -name "*.log" -mtime +30 -delete 2>/dev/null || true
find "${AUTOMATION_ROOT}/exports" -name "*_tmp*" -mtime +7 -delete 2>/dev/null || true

echo ""
echo "=========================================="
echo "LIMPEZA MENSAL CONCLUÍDA"
echo "Log: ${LOG_FILE}"
echo "=========================================="

