#!/bin/bash
# Nome do script: audit_docker_migration.sh
# Objetivo: Executar a auditoria completa do ambiente Docker Desktop
# para planejar a migração para Docker CLI + Colima, conforme
# o plano de 10 etapas fornecido.
# Gera um pacote .tar.gz com todos os artefatos.

# --- Configuração ---
# Diretório de trabalho para salvar os artefatos
AUDIT_DIR="docker_migration_audit_$(date +%Y%m%d_%H%M%S)"
# Arquivo de log consolidado
LOG_FILE="${AUDIT_DIR}/_audit_run.log"
# Nome do pacote final
TAR_FILE="${AUDIT_DIR}.tar.gz"

echo "--- Iniciando Auditoria Docker Desktop para Colima ---"
echo "Os resultados serão salvos em: $AUDIT_DIR"
mkdir -p "$AUDIT_DIR"

# Redireciona toda a saída (stdout e stderr) para o arquivo de log,
# enquanto também a exibe no console.
exec > >(tee -a "$LOG_FILE") 2>&1

echo "============================================================"
echo "[+] Etapa 0: Sistema e pacotes (macOS)"
echo "============================================================"
(
    echo "--- sw_vers ---"
    sw_vers
    echo -e "\n--- uname -a ---"
    uname -a
    echo -e "\n--- sysctl machdep.cpu.brand_string ---"
    sysctl -n machdep.cpu.brand_string
    echo -e "\n--- system_profiler SPHardwareDataType (Chip) ---"
    system_profiler SPHardwareDataType | sed -n 's/.*Chip: //p'
    echo -e "\n--- /usr/bin/arch ---"
    /usr/bin/arch
    echo -e "\n--- brew --version ---"
    brew --version
    echo -e "\n--- brew list (colima, lima, docker, etc) ---"
    brew list --versions colima lima docker docker-compose docker-buildx nerdctl qemu | sed 's/^/brew: /'
) > "${AUDIT_DIR}/00_system_info.txt" 2>/dev/null

echo "============================================================"
echo "[+] Etapa 1: Docker geral"
echo "============================================================"
docker version > "${AUDIT_DIR}/01_docker_version.txt" 2>/dev/null
docker info > "${AUDIT_DIR}/01_docker_info.txt" 2>/dev/null
docker system df -v > "${AUDIT_DIR}/01_docker_system_df.txt" 2>/dev/null
docker context ls > "${AUDIT_DIR}/01_docker_context_ls.txt" 2>/dev/null
docker context inspect > "${AUDIT_DIR}/01_docker_context_inspect.json" 2>/dev/null
docker buildx version > "${AUDIT_DIR}/01_docker_buildx_version.txt" 2>/dev/null || true
docker buildx ls > "${AUDIT_DIR}/01_docker_buildx_ls.txt" 2>/dev/null || true
docker buildx inspect > "${AUDIT_DIR}/01_docker_buildx_inspect.txt" 2>/dev/null || true
docker scan --version > "${AUDIT_DIR}/01_docker_scan_version.txt" 2>/dev/null || true

echo "============================================================"
echo "[+] Etapa 2: Imagens/containers/volumes/redes"
echo "============================================================"
docker ps -a --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}' > "${AUDIT_DIR}/02_docker_ps.txt" 2>/dev/null
docker images --digests > "${AUDIT_DIR}/02_docker_images.txt" 2>/dev/null
docker volume ls > "${AUDIT_DIR}/02_docker_volume_ls.txt" 2>/dev/null
docker network ls > "${AUDIT_DIR}/02_docker_network_ls.txt" 2>/dev/null
docker network inspect bridge host none > "${AUDIT_DIR}/02_docker_network_inspect_defaults.json" 2>/dev/null || true
echo "Inspecionando todas as redes..."
docker network inspect $(docker network ls -q) > "${AUDIT_DIR}/02_docker_network_inspect_all.json" 2>/dev/null

echo "============================================================"
echo "[+] Etapa 3: Compose"
echo "============================================================"
(docker compose version || docker-compose version) > "${AUDIT_DIR}/03_docker_compose_version.txt" 2>/dev/null || true
echo "Buscando arquivos compose na home do usuário (fd)..."
fd -HI 'docker-compose*.y*ml|compose*.y*ml' ~ > "${AUDIT_DIR}/03_docker_compose_files.txt" 2>/dev/null || true
echo "Arquivos Compose encontrados listados em 03_docker_compose_files.txt"

echo "Validando 'config' dos arquivos compose encontrados..."
COMPOSE_CONFIG_DIR="${AUDIT_DIR}/03_compose_configs"
mkdir -p "$COMPOSE_CONFIG_DIR"
while IFS= read -r file; do
    if [ -n "$file" ]; then
        # Sanitiza o path do arquivo para usar como nome de arquivo de saída
        sanitized_path=$(echo "$file" | tr '/' '_' | tr -d ' :')
        echo "Validando config: $file"
        (docker compose -f "$file" config > "${COMPOSE_CONFIG_DIR}/${sanitized_path}_config.yml" 2>/dev/null) || \
        (docker-compose -f "$file" config > "${COMPOSE_CONFIG_DIR}/${sanitized_path}_config.yml" 2>/dev/null)
    fi
done < "${AUDIT_DIR}/03_docker_compose_files.txt"
echo "Configs do Compose salvas em $COMPOSE_CONFIG_DIR"

echo "============================================================"
echo "[+] Etapa 4: Kubernetes (se houver)"
echo "============================================================"
(
    kubectl version --client=true
    echo -e "\n--- kubectl config get-contexts ---"
    kubectl config get-contexts
    echo -e "\n--- kubectl config current-context ---"
    kubectl config current-context
    echo -e "\n--- kubectl get nodes -A ---"
    kubectl get nodes -A
    echo -e "\n--- kubectl get ns ---"
    kubectl get ns
    echo -e "\n--- kubectl get storageclass ---"
    kubectl get storageclass
) > "${AUDIT_DIR}/04_kubernetes_info.txt" 2>/dev/null || true

echo "============================================================"
echo "[+] Etapa 5: Configurações do Docker"
echo "============================================================"
cat /etc/docker/daemon.json > "${AUDIT_DIR}/05_docker_daemon_json.json" 2>/dev/null || true
cat ~/.docker/config.json > "${AUDIT_DIR}/05_docker_config_json.json" 2>/dev/null || true
ls -la ~/.docker > "${AUDIT_DIR}/05_docker_dir_listing.txt" 2>/dev/null
grep -R "credsStore\|credHelpers\|auths\|proxies" -n ~/.docker > "${AUDIT_DIR}/05_docker_config_secrets_grep.txt" 2>/dev/null || true

echo "============================================================"
echo "[+] Etapa 6: Credenciais/registries (mapeamento)"
echo "============================================================"
echo "Verificando existência da credencial 'docker-credential-osxkeychain'..."
security find-generic-password -a $USER -s "docker-credential-osxkeychain" -g > "${AUDIT_DIR}/06_osxkeychain_check.txt" 2>/dev/null || true
echo "Listando chaves 'auths' do config.json..."
jq '.auths | keys' ~/.docker/config.json > "${AUDIT_DIR}/06_docker_auths_keys.json" 2>/dev/null || true

echo "============================================================"
echo "[+] Etapa 7: Proxy/Rede/Certificados"
echo "============================================================"
env | egrep -i 'http_proxy|https_proxy|no_proxy' > "${AUDIT_DIR}/07_env_proxies.txt"
networksetup -listallnetworkservices > "${AUDIT_DIR}/07_network_services.txt"
echo "Verificando certificados customizados..."
ls -R ~/.docker/certs.d > "${AUDIT_DIR}/07_docker_certs_d_listing.txt" 2>/dev/null || true

echo "============================================================"
echo "[+] Etapa 8: Integrações do Docker Desktop (Indicadores)"
echo "============================================================"
ps aux | egrep -i 'Docker Desktop|com.docker' | grep -v egrep > "${AUDIT_DIR}/08_docker_desktop_processes.txt" || true
echo "---" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"
echo "!! AÇÃO MANUAL PENDENTE (AUDITORIA GUI) !!" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"
echo "Verifique e anote as seguintes configurações no Docker Desktop GUI:" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"
echo "1. Settings > Resources > File sharing (Paths compartilhados)" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"
echo "2. Settings > Resources > Proxies (Configuração de proxy manual/auto)" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"
echo "3. Settings > Resources > Certificates (Certificados internos)" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"
echo "4. Settings > Extensions (Extensões habilitadas)" >> "${AUDIT_DIR}/08_docker_desktop_processes.txt"

echo "============================================================"
echo "[+] Etapa 9: Colima/Lima (se já instalados)"
echo "============================================================"
(
    colima version
    echo -e "\n--- colima list ---"
    colima list
    echo -e "\n--- limactl --version ---"
    limactl --version
    echo -e "\n--- limactl list ---"
    limactl list
    echo -e "\n--- colima status default ---"
    colima status default
    echo -e "\n--- colima ssh (os-release) ---"
    colima ssh -- cat /etc/os-release
    echo -e "\n--- colima ssh (docker version) ---"
    colima ssh -- docker version
    echo -e "\n--- nerdctl version ---"
    nerdctl version
) > "${AUDIT_DIR}/09_colima_lima_info.txt" 2>/dev/null || true

echo "============================================================"
echo "[+] Etapa 10: Buildx/QEMU/Plataformas"
echo "============================================================"
docker buildx ls > "${AUDIT_DIR}/10_docker_buildx_ls_final.txt" 2>/dev/null || true
echo "Executando tonistiigi/xx:latest xx-info para verificar plataformas..."
docker run --rm tonistiigi/xx:latest xx-info > "${AUDIT_DIR}/10_xx_info.txt" 2>/dev/null || true

echo "============================================================"
echo "[+] Compactando artefatos da auditoria..."
echo "============================================================"
# Parar o log no arquivo para não registrar o 'tar' e 'rm' nele.
exec 1>&- 2>&-
exec > /dev/tty 2>&1

tar -czf "$TAR_FILE" "$AUDIT_DIR"
if [ $? -eq 0 ]; then
    echo "Pacote de auditoria gerado com sucesso: $TAR_FILE"
    echo "Limpando diretório de trabalho..."
    rm -rf "$AUDIT_DIR"
else
    echo "Erro ao gerar o pacote .tar.gz."
    echo "Os artefatos estão em: $AUDIT_DIR"
fi

echo "--- Auditoria Concluída ---"