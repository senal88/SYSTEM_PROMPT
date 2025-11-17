#!/bin/bash
set -euo pipefail

# diagnose_memory.sh
# Diagnóstico completo de uso de memória e processos
# Útil após execuções de scripts pesados (sync_cursorrules, análise de projetos)

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_DIR="${HOME}/Dotfiles/automation_1password/exports"
REPORT_FILE="${REPORT_DIR}/memory_diagnosis_${TIMESTAMP}.txt"

mkdir -p "$REPORT_DIR"

{
  echo "=========================================="
  echo "DIAGNÓSTICO DE MEMÓRIA - $(date)"
  echo "=========================================="
  echo ""
  
  echo "=== INFORMAÇÕES DE SISTEMA ==="
  sysctl hw.memsize | awk '{printf "RAM Total: %.2f GB\n", $2/1024/1024/1024}'
  echo ""
  
  echo "=== STATUS DE MEMÓRIA (vm_stat) ==="
  vm_stat
  echo ""
  
  echo "=== TOP 20 PROCESSOS POR MEMÓRIA ==="
  ps aux | head -1
  ps aux | sort -rk 4 | head -20
  echo ""
  
  echo "=== PROCESSOS find/fd/git ATIVOS ==="
  pgrep -fl "find|fd|git" || echo "Nenhum processo find/fd/git encontrado"
  echo ""
  
  echo "=== PROCESSOS python/node ATIVOS ==="
  pgrep -fl "python|node" | head -20 || echo "Nenhum processo python/node encontrado"
  echo ""
  
  echo "=== STATUS DOCKER ==="
  docker ps 2>/dev/null || echo "Docker não está rodando"
  echo ""
  
  echo "=== STATUS COLIMA ==="
  colima status 2>/dev/null || echo "Colima não está rodando"
  echo ""
  
  echo "=== LOGS RECENTES (tamanho) ==="
  ls -lh "${REPORT_DIR}"/*.log 2>/dev/null | tail -5 | awk '{print $5, $9}'
  echo ""
  
  echo "=== USO DE DISCO (logs) ==="
  du -sh "${REPORT_DIR}"/*.log 2>/dev/null | sort -h | tail -5
  echo ""
  
  echo "=== PROCESSOS ZOMBIE ==="
  ps aux | awk '$8 ~ /^Z/ {print}'
  echo ""
  
} | tee "$REPORT_FILE"

echo ""
echo "✅ Diagnóstico salvo em: ${REPORT_FILE}"
echo ""
echo "💡 Próximos passos:"
echo "   1. Revisar processos consumindo mais memória"
echo "   2. Finalizar processos órfãos se necessário"
echo "   3. Limpar logs grandes se não forem mais necessários"
echo "   4. Verificar Docker/Colima e finalizar se não estiver em uso"

