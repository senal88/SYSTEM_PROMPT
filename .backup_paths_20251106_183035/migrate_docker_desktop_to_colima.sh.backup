#!/bin/bash
# Executes full migration workflow from Docker Desktop to Colima using a prior audit bundle.
# Usage: migrate_docker_desktop_to_colima.sh /path/to/docker_migration_audit_*.tar.gz

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Uso: $0 <caminho_para_docker_migration_audit_YYYYMMDD_HHMMSS.tar.gz>"
  exit 1
fi

AUDIT_TAR="$1"
if [[ ! -f "$AUDIT_TAR" ]]; then
  echo "Arquivo de auditoria não encontrado: $AUDIT_TAR"
  exit 1
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Este script foi projetado para macOS."
  exit 1
fi

timestamp="$(date +%Y%m%d_%H%M%S)"
WORK_ROOT="exports/migration_run_${timestamp}"
mkdir -p "$WORK_ROOT"
WORK_ROOT="$(cd "$WORK_ROOT" && pwd)"
TMP_DIR="${WORK_ROOT}/tmp"
VOL_BACKUP_DIR="${WORK_ROOT}/volume_backups"
LOG_FILE="${WORK_ROOT}/migration.log"

mkdir -p "$TMP_DIR" "$VOL_BACKUP_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[INFO] Migração iniciada em ${timestamp}"
echo "[INFO] Audit bundle: ${AUDIT_TAR}"
tar -xzf "$AUDIT_TAR" -C "$TMP_DIR"
AUDIT_FOLDER="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'docker_migration_audit_*' | head -n1)"
if [[ -z "$AUDIT_FOLDER" ]]; then
  echo "[ERRO] Não foi possível localizar o diretório extraído da auditoria."
  exit 1
fi

sys_info="${AUDIT_FOLDER}/00_system_info.txt"
docker_info="${AUDIT_FOLDER}/01_docker_info.txt"
docker_context_inspect="${AUDIT_FOLDER}/01_docker_context_inspect.json"
docker_config="${AUDIT_FOLDER}/05_docker_config_json.json"
docker_ps="${AUDIT_FOLDER}/02_docker_ps.txt"
docker_volumes="${AUDIT_FOLDER}/02_docker_volume_ls.txt"
docker_networks="${AUDIT_FOLDER}/02_docker_network_ls.txt"
docker_processes="${AUDIT_FOLDER}/08_docker_desktop_processes.txt"

if ! command -v brew >/dev/null 2>&1; then
  echo "[ERRO] Homebrew não encontrado. Instale antes de prosseguir."
  exit 1
fi

install_if_missing() {
  local formula="$1"
  if brew list --versions "$formula" >/dev/null 2>&1; then
    echo "[INFO] ${formula} já instalado."
  else
    echo "[INFO] Instalando ${formula}..."
    brew install "$formula"
  fi
}

install_if_missing colima
install_if_missing lima
install_if_missing qemu
install_if_missing docker-compose
install_if_missing docker-buildx
install_if_missing jq

mac_version="$(awk -F':\t*' '/ProductVersion/ {print $2}' "$sys_info" | head -n1 | tr -d ' ')"
chip="$(awk '/system_profiler SPHardwareDataType/ {getline; print $0}' "$sys_info")"
arch="$(awk '/\/usr\/bin\/arch/ {getline; print $0}' "$sys_info")"
echo "[INFO] macOS ${mac_version} (${chip}, ${arch})"

cpu_count="$(awk -F': ' '/CPUs:/ {print $2; exit}' "$docker_info")"
if [[ -z "$cpu_count" ]]; then
  echo "[ERRO] Não foi possível obter a contagem de CPUs."
  exit 1
fi

mem_raw="$(awk -F': ' '/Total Memory:/ {print $2; exit}' "$docker_info" | tr -d ' ')"
if [[ -z "$mem_raw" ]]; then
  echo "[ERRO] Não foi possível obter a memória total."
  exit 1
fi
mem_gib="${mem_raw%GiB}"
mem_ceiled="$(python3 -c 'import math,sys; print(math.ceil(float(sys.argv[1])))' "$mem_gib" 2>/dev/null || echo "$mem_gib")"
echo "[INFO] Recursos Docker Desktop -> CPUs: ${cpu_count}, Memória: ${mem_ceiled} GiB"

virtiofs_mounts=()
while IFS= read -r mount_path; do
  [[ -z "$mount_path" ]] && continue
  virtiofs_mounts+=("$mount_path")
done < <(awk '{for(i=1;i<=NF;i++) if($i=="--virtiofs") {print $(i+1)}}' "$docker_processes" | sort -u)
if [[ ${#virtiofs_mounts[@]} -eq 0 ]]; then
  echo "[WARN] Nenhum caminho virtiofs encontrado; usando diretórios padrão."
  virtiofs_mounts=("/Users/${USER}")
fi

networks=()
while IFS= read -r net; do
  [[ -z "$net" ]] && continue
  networks+=("$net")
done < <(awk 'NR>1 {print $2}' "$docker_networks" | grep -Ev '^(bridge|host|none)$' || true)
if [[ ${#networks[@]} -eq 0 ]]; then
  echo "[WARN] Nenhuma rede customizada identificada."
fi

volume_names=()
while IFS= read -r vol; do
  [[ -z "$vol" ]] && continue
  volume_names+=("$vol")
done < <(awk 'NR>1 {print $2}' "$docker_volumes" || true)
declare -a named_volumes=()
for vol in "${volume_names[@]}"; do
  if [[ -z "$vol" ]]; then
    continue
  fi
  if [[ "$vol" =~ ^[0-9a-f]{32,}$ ]]; then
    echo "[INFO] Ignorando volume ${vol} (aparentemente anônimo)."
    continue
  fi
  named_volumes+=("$vol")
done

if [[ ${#named_volumes[@]} -eq 0 ]]; then
  echo "[WARN] Nenhum volume nomeado crítico encontrado."
fi

orig_context="$(docker context show 2>/dev/null || true)"
echo "[INFO] Contexto Docker atual: ${orig_context}"

echo "[INFO] Garantindo que Docker Desktop esteja ativo para exportar volumes..."
docker context use desktop-linux >/dev/null 2>&1 || {
  echo "[ERRO] Contexto desktop-linux indisponível. Abra o Docker Desktop e execute novamente."
  exit 1
}

if [[ ${#named_volumes[@]} -gt 0 ]]; then
  echo "[INFO] Exportando volumes nomeados para ${VOL_BACKUP_DIR}"
  docker pull --quiet busybox:latest >/dev/null
  for vol in "${named_volumes[@]}"; do
    archive="${VOL_BACKUP_DIR}/${vol}.tgz"
    echo "[INFO] Exportando volume ${vol} -> ${archive}"
    docker run --rm -v "${vol}":/v -v "${VOL_BACKUP_DIR}":/b busybox sh -c "cd /v && tar czf /b/${vol}.tgz ."
  done
else
  echo "[INFO] Nenhum volume nomeado para exportar."
fi

echo "[INFO] Encerrando Docker Desktop..."
osascript -e 'tell application "Docker" to quit' >/dev/null 2>&1 || true
sleep 5

echo "[INFO] Iniciando Colima com perfil default..."
colima_args=(
  start --profile default
  --cpu "${cpu_count}"
  --memory "${mem_ceiled}"
  --disk 60
  --arch aarch64
  --vm-type vz
  --mount-type virtiofs
  --vz-rosetta
  --dns 1.1.1.1
)
for mount_path in "${virtiofs_mounts[@]}"; do
  colima_args+=(--mount "${mount_path}:w")
done
colima "${colima_args[@]}"

echo "[INFO] Ajustando contexto Docker para Colima..."
docker context use colima

if [[ ${#named_volumes[@]} -gt 0 ]]; then
  echo "[INFO] Importando volumes para Colima..."
  for vol in "${named_volumes[@]}"; do
    archive="${VOL_BACKUP_DIR}/${vol}.tgz"
    if [[ ! -f "$archive" ]]; then
      echo "[WARN] Arquivo ${archive} não encontrado; pulando importação."
      continue
    fi
    docker volume create "${vol}" >/dev/null || true
    docker run --rm -v "${vol}":/v -v "${VOL_BACKUP_DIR}":/b busybox sh -c "cd /v && tar xzf /b/${vol}.tgz"
  done
fi

if [[ ${#networks[@]} -gt 0 ]]; then
  echo "[INFO] Recriando redes customizadas..."
  for net in "${networks[@]}"; do
    docker network create "${net}" >/dev/null 2>&1 || echo "[WARN] Rede ${net} já existe."
  done
fi

if docker buildx ls | grep -q 'colima_builder'; then
  echo "[INFO] Builder colima_builder já existe."
else
  echo "[INFO] Criando builder colima_builder..."
  docker buildx create --name colima_builder --driver docker-container --use
fi
docker buildx inspect --bootstrap >/dev/null

if command -v jq >/dev/null 2>&1 && [[ -f "$docker_config" ]]; then
  current_creds="$(jq -r '.credsStore // empty' "$docker_config")"
  if [[ "$current_creds" == "desktop" ]]; then
    echo "[INFO] Atualizando credsStore para osxkeychain em ~/.docker/config.json"
    tmp_cfg="$(mktemp)"
    jq '.credsStore="osxkeychain"' "$HOME/.docker/config.json" > "$tmp_cfg"
    mv "$tmp_cfg" "$HOME/.docker/config.json"
  else
    echo "[INFO] credsStore atual (${current_creds}) não requer alteração."
  fi
else
  echo "[WARN] jq não disponível ou config.json ausente ao atualizar credsStore."
fi

echo "[INFO] Buscando arquivos docker-compose em ~/Dotfiles e ~/Projetos..."
fd -HI 'docker-compose*.y*ml|compose*.y*ml' "$HOME/Dotfiles" "$HOME/Projetos" > "${WORK_ROOT}/compose_inventory.txt" 2>/dev/null || true

docker context use colima >/dev/null 2>&1 || true
final_context="$(docker context show 2>/dev/null || echo 'desconhecido')"

echo "[INFO] Migração concluída. Relatórios:"
echo " - Log completo: ${LOG_FILE}"
echo " - Backups de volumes: ${VOL_BACKUP_DIR}"
echo " - Lista de arquivos compose: ${WORK_ROOT}/compose_inventory.txt"
echo " - Contexto Docker atual: ${final_context}"
echo "[INFO] Execute 'docker compose up -d' nos diretórios listados para restaurar os serviços."
