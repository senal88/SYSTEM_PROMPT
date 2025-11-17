#!/bin/bash
set -euo pipefail

# cleanup_orphan_processes.sh
# Limpa processos órfãos de find, fd, git que podem ter ficado rodando
# após execuções de scripts pesados

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${HOME}/Dotfiles/automation_1password/exports/cleanup_orphan_processes_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "[INFO] Limpeza de processos órfãos iniciada em $(date)"
echo ""

# Função para matar processos de forma segura
kill_processes() {
  local pattern="$1"
  local name="$2"
  
  local pids=$(pgrep -f "$pattern" 2>/dev/null || true)
  
  if [[ -z "$pids" ]]; then
    echo "[OK] Nenhum processo $name encontrado"
    return 0
  fi
  
  echo "[INFO] Encontrados processos $name:"
  ps -p "$pids" -o pid,ppid,command | head -20
  
  read -p "[CONFIRMAÇÃO] Finalizar esses processos? (s/N): " -n 1 -r
  echo ""
  
  if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "$pids" | while read -r pid; do
      if kill -0 "$pid" 2>/dev/null; then
        echo "[ACTION] Finalizando PID $pid"
        kill -TERM "$pid" 2>/dev/null || true
        sleep 1
        # Force kill se ainda estiver rodando
        if kill -0 "$pid" 2>/dev/null; then
          echo "[WARNING] Processo $pid ainda ativo, forçando término"
          kill -KILL "$pid" 2>/dev/null || true
        fi
      fi
    done
    echo "[OK] Processos $name finalizados"
  else
    echo "[SKIP] Processos $name mantidos"
  fi
}

# Verificar e limpar processos find órfãos (com mais de 5 minutos)
echo "=== Verificando processos find órfãos ==="
find_pids=$(pgrep -f "^find.*Projetos" 2>/dev/null || true)
if [[ -n "$find_pids" ]]; then
  echo "[INFO] Processos find encontrados:"
  for pid in $find_pids; do
    runtime=$(ps -o etime= -p "$pid" 2>/dev/null | xargs || echo "N/A")
    echo "  PID $pid (tempo: $runtime)"
  done
  kill_processes "^find.*Projetos" "find"
else
  echo "[OK] Nenhum processo find órfão encontrado"
fi
echo ""

# Verificar e limpar processos git órfãos
echo "=== Verificando processos git órfãos ==="
kill_processes "^git.*init\|^git.*status" "git"
echo ""

# Verificar e limpar processos fd órfãos
echo "=== Verificando processos fd órfãos ==="
kill_processes "^fd.*Projetos" "fd"
echo ""

# Verificar Python/Node órfãos (apenas os relacionados a scripts de automação)
echo "=== Verificando processos Python/Node órfãos ==="
python_pids=$(pgrep -f "python.*sync_cursorrules\|python.*projetos" 2>/dev/null || true)
node_pids=$(pgrep -f "node.*sync_cursorrules\|node.*projetos" 2>/dev/null || true)

if [[ -n "$python_pids" ]] || [[ -n "$node_pids" ]]; then
  echo "[WARNING] Processos Python/Node de automação encontrados:"
  [[ -n "$python_pids" ]] && ps -p "$python_pids" -o pid,command
  [[ -n "$node_pids" ]] && ps -p "$node_pids" -o pid,command
  kill_processes "python.*sync_cursorrules\|python.*projetos" "python-automation"
  kill_processes "node.*sync_cursorrules\|node.*projetos" "node-automation"
else
  echo "[OK] Nenhum processo Python/Node de automação órfão encontrado"
fi
echo ""

# Opcional: Parar Docker/Colima se não estiver em uso
echo "=== Verificando Docker/Colima ==="
if docker ps 2>/dev/null | grep -q .; then
  containers=$(docker ps --format "{{.Names}}" | wc -l)
  echo "[INFO] Docker rodando com $containers container(s) ativo(s)"
  docker ps
  echo ""
  read -p "[OPCIONAL] Deseja parar todos os containers Docker? (s/N): " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Ss]$ ]]; then
    docker stop $(docker ps -q) 2>/dev/null || true
    echo "[OK] Containers Docker parados"
  fi
else
  echo "[OK] Docker não está rodando ou não há containers ativos"
fi

if colima status 2>/dev/null | grep -q "running"; then
  echo "[INFO] Colima está rodando"
  read -p "[OPCIONAL] Deseja parar Colima? (s/N): " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Ss]$ ]]; then
    colima stop
    echo "[OK] Colima parado"
  fi
else
  echo "[OK] Colima não está rodando"
fi
echo ""

echo "[INFO] Limpeza concluída em $(date)"
echo "[INFO] Log completo: ${LOG_FILE}"

