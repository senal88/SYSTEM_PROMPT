#!/bin/bash

################################################################################
# 🐳 AUDITORIA COMPLETA DOCKER - VPS Ubuntu
# Coleta detalhada de informações sobre Docker, containers, imagens, volumes, etc.
#
# USO:
#   Local: ./auditar-docker.sh
#   Remoto: ssh admin-vps 'bash -s' < ./auditar-docker.sh
#   Ou: scp auditar-docker.sh admin-vps:/tmp/ && ssh admin-vps bash /tmp/auditar-docker.sh
################################################################################

set +euo pipefail 2>/dev/null || set +e
set +u

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
AUDIT_BASE="${DOTFILES_DIR}/system_prompts/global/audit"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Se executado remotamente, usar /tmp, senão usar estrutura de auditoria
if [ -d "$AUDIT_BASE" ]; then
    AUDIT_DIR="${AUDIT_BASE}/${TIMESTAMP}/vps/docker"
else
    AUDIT_DIR="/tmp/docker_audit_${TIMESTAMP}"
fi

mkdir -p "$AUDIT_DIR"
cd "$AUDIT_DIR"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# VERIFICAÇÕES INICIAIS
# ============================================================================

check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker não está instalado ou não está no PATH"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        log_error "Docker não está rodando ou você não tem permissão"
        exit 1
    fi

    log_success "Docker detectado e acessível"
}

# ============================================================================
# COLETA DE DADOS
# ============================================================================

collect_docker_version() {
    print_header "1. VERSÃO E INFORMAÇÕES DO DOCKER"

    {
        echo "=== DOCKER VERSION ==="
        docker --version 2>&1
        echo ""

        echo "=== DOCKER COMPOSE VERSION ==="
        docker compose version 2>&1 || docker-compose --version 2>&1 || echo "Docker Compose não encontrado"
        echo ""

        echo "=== DOCKER INFO (COMPLETO) ==="
        docker info 2>&1
        echo ""

        echo "=== DOCKER SYSTEM DF (USO DE DISCO) ==="
        docker system df -v 2>&1
        echo ""

        echo "=== DOCKER BUILDX ==="
        docker buildx version 2>&1 || echo "Buildx não disponível"
        echo ""

        echo "=== DOCKER CONTEXT ==="
        docker context ls 2>&1
        docker context show 2>&1 || echo "N/A"
    } > 01_docker_version.txt 2>&1

    log_success "Versão e informações coletadas"
}

collect_containers() {
    print_header "2. CONTAINERS"

    {
        echo "=== CONTAINERS (TODOS) ==="
        docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}" 2>&1
        echo ""

        echo "=== CONTAINERS RODANDO ==="
        docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}" 2>&1
        echo ""

        echo "=== CONTAINERS PARADOS ==="
        docker ps -a --filter "status=exited" --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" 2>&1
        echo ""

        echo "=== DETALHES POR CONTAINER ==="
        docker ps -a --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "CONTAINER: $container"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                echo "--- INSPECT (JSON) ---"
                docker inspect "$container" 2>&1 | head -100

                echo ""
                echo "--- STATS (ÚLTIMOS) ---"
                docker stats --no-stream "$container" 2>&1 || echo "Não disponível"

                echo ""
                echo "--- TOP (PROCESSOS) ---"
                docker top "$container" 2>&1 | head -20 || echo "Não disponível"

                echo ""
                echo "--- PORT MAPPING ---"
                docker port "$container" 2>&1 || echo "N/A"

                echo ""
                echo "--- ENV VARS (primeiras 20) ---"
                docker inspect "$container" --format '{{range .Config.Env}}{{println .}}{{end}}' 2>&1 | head -20
            fi
        done
    } > 02_containers.txt 2>&1

    log_success "Containers coletados"
}

collect_images() {
    print_header "3. IMAGENS"

    {
        echo "=== IMAGENS LOCAIS ==="
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}" 2>&1
        echo ""

        echo "=== IMAGENS POR TAMANHO ==="
        docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}" 2>&1 | sort -k2 -h -r | head -20
        echo ""

        echo "=== IMAGENS ÓRFÃS (dangling) ==="
        docker images --filter "dangling=true" 2>&1
        echo ""

        echo "=== DETALHES POR IMAGEM ==="
        docker images --format "{{.Repository}}:{{.Tag}}" 2>&1 | grep -v "^<none>" | head -20 | while read image; do
            if [ -n "$image" ]; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "IMAGEM: $image"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                echo "--- HISTORY ---"
                docker history "$image" --no-trunc 2>&1 | head -10

                echo ""
                echo "--- INSPECT ---"
                docker inspect "$image" 2>&1 | head -50
            fi
        done
    } > 03_images.txt 2>&1

    log_success "Imagens coletadas"
}

collect_volumes() {
    print_header "4. VOLUMES"

    {
        echo "=== VOLUMES LIST ==="
        docker volume ls 2>&1
        echo ""

        echo "=== DETALHES POR VOLUME ==="
        docker volume ls --format "{{.Name}}" 2>&1 | while read volume; do
            if [ -n "$volume" ]; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "VOLUME: $volume"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                docker volume inspect "$volume" 2>&1

                echo ""
                echo "--- USO DE DISCO ---"
                docker system df -v | grep "$volume" || echo "N/A"
            fi
        done

        echo ""
        echo "=== VOLUMES ÓRFÃOS (não usados) ==="
        docker volume ls --format "{{.Name}}" 2>&1 | while read volume; do
            if ! docker ps -a --filter volume="$volume" --format "{{.Names}}" 2>&1 | grep -q .; then
                echo "$volume (não usado por nenhum container)"
            fi
        done
    } > 04_volumes.txt 2>&1

    log_success "Volumes coletados"
}

collect_networks() {
    print_header "5. REDES"

    {
        echo "=== NETWORKS LIST ==="
        docker network ls 2>&1
        echo ""

        echo "=== DETALHES POR REDE ==="
        docker network ls --format "{{.Name}}" 2>&1 | while read network; do
            if [ -n "$network" ] && [ "$network" != "NETWORK" ]; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "NETWORK: $network"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                docker network inspect "$network" 2>&1

                echo ""
                echo "--- CONTAINERS CONECTADOS ---"
                docker network inspect "$network" --format '{{range .Containers}}{{.Name}} {{end}}' 2>&1
            fi
        done
    } > 05_networks.txt 2>&1

    log_success "Redes coletadas"
}

collect_compose() {
    print_header "6. DOCKER COMPOSE"

    {
        echo "=== COMPOSE PROJECTS ==="
        docker compose ls 2>&1 || docker-compose ps 2>&1 || echo "Nenhum projeto Compose encontrado"
        echo ""

        echo "=== BUSCAR docker-compose.yml ==="
        find /home -name "docker-compose.yml" -o -name "docker-compose.yaml" 2>/dev/null | head -20
        find /opt -name "docker-compose.yml" -o -name "docker-compose.yaml" 2>/dev/null | head -10
        find /root -name "docker-compose.yml" -o -name "docker-compose.yaml" 2>/dev/null | head -10
        echo ""

        echo "=== STACKS (SWARM) ==="
        docker stack ls 2>&1 || echo "Swarm não ativo ou sem stacks"
        echo ""

        if docker stack ls &> /dev/null; then
            docker stack ls --format "{{.Name}}" 2>&1 | while read stack; do
                if [ -n "$stack" ] && [ "$stack" != "NAME" ]; then
                    echo ""
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "STACK: $stack"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    docker stack services "$stack" 2>&1
                    docker stack ps "$stack" 2>&1 | head -20
                fi
            done
        fi
    } > 06_compose.txt 2>&1

    log_success "Docker Compose coletado"
}

collect_swarm() {
    print_header "7. DOCKER SWARM"

    {
        echo "=== SWARM INFO ==="
        docker info 2>&1 | grep -A 20 "Swarm:" || echo "Swarm não ativo"
        echo ""

        echo "=== SWARM NODES ==="
        docker node ls 2>&1 || echo "Não é Swarm ou sem permissão"
        echo ""

        if docker node ls &> /dev/null; then
            echo "=== DETALHES DOS NODES ==="
            docker node ls --format "{{.ID}}" 2>&1 | while read node; do
                if [ -n "$node" ]; then
                    echo ""
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "NODE: $node"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    docker node inspect "$node" 2>&1 | head -50
                fi
            done

            echo ""
            echo "=== SWARM SERVICES ==="
            docker service ls 2>&1

            docker service ls --format "{{.Name}}" 2>&1 | while read service; do
                if [ -n "$service" ] && [ "$service" != "NAME" ]; then
                    echo ""
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "SERVICE: $service"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    docker service inspect "$service" 2>&1 | head -100
                    docker service ps "$service" 2>&1
                fi
            done
        fi
    } > 07_swarm.txt 2>&1

    log_success "Swarm coletado"
}

collect_resources() {
    print_header "8. RECURSOS E PERFORMANCE"

    {
        echo "=== DOCKER STATS (TODOS OS CONTAINERS) ==="
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}" 2>&1
        echo ""

        echo "=== USO DE DISCO POR CONTAINER ==="
        docker ps --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                echo ""
                echo "Container: $container"
                docker exec "$container" df -h 2>&1 | head -10 || echo "Não foi possível acessar"
            fi
        done
        echo ""

        echo "=== LIMITES DE RECURSOS ==="
        docker ps --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "Container: $container"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                docker inspect "$container" --format 'CPU: {{.HostConfig.CpuShares}} shares, Memory: {{.HostConfig.Memory}} bytes' 2>&1
                docker inspect "$container" --format 'CPU Quota: {{.HostConfig.CpuQuota}}, CPU Period: {{.HostConfig.CpuPeriod}}' 2>&1
            fi
        done
    } > 08_resources.txt 2>&1

    log_success "Recursos coletados"
}

collect_logs() {
    print_header "9. LOGS (ÚLTIMAS 50 LINHAS POR CONTAINER)"

    {
        docker ps -a --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "LOGS: $container"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                docker logs --tail 50 "$container" 2>&1 || echo "Não foi possível acessar logs"
            fi
        done
    } > 09_logs.txt 2>&1

    log_success "Logs coletados"
}

collect_security() {
    print_header "10. SEGURANÇA"

    {
        echo "=== CONTAINERS COM PRIVILEGIOS ==="
        docker ps --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                PRIV=$(docker inspect "$container" --format '{{.HostConfig.Privileged}}' 2>&1)
                if [ "$PRIV" = "true" ]; then
                    echo "⚠️ $container está rodando com privilégios!"
                    docker inspect "$container" --format 'Privileged: {{.HostConfig.Privileged}}, CapAdd: {{.HostConfig.CapAdd}}, CapDrop: {{.HostConfig.CapDrop}}' 2>&1
                fi
            fi
        done
        echo ""

        echo "=== CONTAINERS COM BIND MOUNTS SENSÍVEIS ==="
        docker ps --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                MOUNTS=$(docker inspect "$container" --format '{{range .Mounts}}{{.Source}} -> {{.Destination}} ({{.Type}}){{println}}{{end}}' 2>&1)
                if echo "$MOUNTS" | grep -qE "(/etc|/root|/home.*\.ssh|/var/run/docker)" 2>/dev/null; then
                    echo "⚠️ $container tem mounts sensíveis:"
                    echo "$MOUNTS" | grep -E "(/etc|/root|/home.*\.ssh|/var/run/docker)" || true
                fi
            fi
        done
        echo ""

        echo "=== CONTAINERS COM USER ROOT ==="
        docker ps --format "{{.Names}}" 2>&1 | while read container; do
            if [ -n "$container" ]; then
                USER=$(docker inspect "$container" --format '{{.Config.User}}' 2>&1)
                if [ -z "$USER" ] || [ "$USER" = "root" ] || [ "$USER" = "0" ]; then
                    echo "⚠️ $container está rodando como root"
                fi
            fi
        done
        echo ""

        echo "=== DOCKER DAEMON CONFIG ==="
        cat /etc/docker/daemon.json 2>/dev/null || echo "daemon.json não encontrado"
        echo ""

        echo "=== DOCKER SOCKET PERMISSIONS ==="
        ls -la /var/run/docker.sock 2>/dev/null || echo "Socket não encontrado"
        echo ""

        echo "=== GRUPO DOCKER ==="
        getent group docker 2>/dev/null || echo "Grupo docker não encontrado"
    } > 10_security.txt 2>&1

    log_success "Segurança coletada"
}

collect_coolify() {
    print_header "11. COOLIFY (SE APLICÁVEL)"

    {
        COOLIFY_CONTAINER=$(docker ps --format "{{.Names}}" 2>&1 | grep -i coolify | head -1)

        if [ -n "$COOLIFY_CONTAINER" ]; then
            echo "=== COOLIFY CONTAINER ENCONTRADO: $COOLIFY_CONTAINER ==="
            echo ""

            echo "--- INSPECT ---"
            docker inspect "$COOLIFY_CONTAINER" 2>&1 | head -100
            echo ""

            echo "--- ENV VARS (primeiras 30) ---"
            docker inspect "$COOLIFY_CONTAINER" --format '{{range .Config.Env}}{{println .}}{{end}}' 2>&1 | head -30
            echo ""

            echo "--- VOLUMES ---"
            docker inspect "$COOLIFY_CONTAINER" --format '{{range .Mounts}}{{.Source}} -> {{.Destination}} ({{.Type}}){{println}}{{end}}' 2>&1
            echo ""

            echo "=== COOLIFY SERVICES ==="
            docker ps --format "{{.Names}}" 2>&1 | grep -i coolify
            echo ""

            echo "=== BUSCAR CONFIGURAÇÕES COOLIFY ==="
            find /home -path "*coolify*" -type d 2>/dev/null | head -10
            find /opt -path "*coolify*" -type d 2>/dev/null | head -10
        else
            echo "Coolify não encontrado nos containers ativos"
        fi
    } > 11_coolify.txt 2>&1

    log_success "Coolify coletado"
}

generate_summary() {
    print_header "12. RESUMO EXECUTIVO"

    {
        echo "=== RESUMO DOCKER ==="
        echo ""
        echo "Data/Hora: $(date)"
        echo "Hostname: $(hostname)"
        echo ""

        echo "--- VERSÃO ---"
        docker --version 2>&1
        echo ""

        echo "--- ESTATÍSTICAS ---"
        echo "Containers rodando: $(docker ps -q | wc -l)"
        echo "Containers totais: $(docker ps -a -q | wc -l)"
        echo "Imagens: $(docker images -q | wc -l)"
        echo "Volumes: $(docker volume ls -q | wc -l)"
        echo "Networks: $(docker network ls -q | wc -l)"
        echo ""

        echo "--- USO DE DISCO ---"
        docker system df 2>&1
        echo ""

        echo "--- CONTAINERS ATIVOS ---"
        docker ps --format "{{.Names}}\t{{.Image}}\t{{.Status}}" 2>&1
        echo ""

        echo "--- IMAGENS MAIORES (top 10) ---"
        docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}" 2>&1 | sort -k2 -h -r | head -10
        echo ""

        echo "--- VOLUMES NÃO USADOS ---"
        UNUSED=$(docker volume ls --format "{{.Name}}" 2>&1 | while read vol; do
            if ! docker ps -a --filter volume="$vol" --format "{{.Names}}" 2>&1 | grep -q .; then
                echo "$vol"
            fi
        done)
        if [ -n "$UNUSED" ]; then
            echo "$UNUSED"
        else
            echo "Nenhum volume não usado encontrado"
        fi
        echo ""

        echo "--- PROBLEMAS DE SEGURANÇA ---"
        PRIV_COUNT=$(docker ps --format "{{.Names}}" 2>&1 | while read c; do
            docker inspect "$c" --format '{{.HostConfig.Privileged}}' 2>&1
        done | grep -c "true" || echo "0")
        echo "Containers com privilégios: $PRIV_COUNT"

        ROOT_COUNT=$(docker ps --format "{{.Names}}" 2>&1 | while read c; do
            USER=$(docker inspect "$c" --format '{{.Config.User}}' 2>&1)
            if [ -z "$USER" ] || [ "$USER" = "root" ] || [ "$USER" = "0" ]; then
                echo "1"
            fi
        done | wc -l)
        echo "Containers rodando como root: $ROOT_COUNT"
    } > 00_summary.txt 2>&1

    log_success "Resumo gerado"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🐳 AUDITORIA COMPLETA DOCKER"

    log_info "Iniciando auditoria Docker..."
    log_info "Diretório de saída: $AUDIT_DIR"

    check_docker

    collect_docker_version
    collect_containers
    collect_images
    collect_volumes
    collect_networks
    collect_compose
    collect_swarm
    collect_resources
    collect_logs
    collect_security
    collect_coolify
    generate_summary

    print_header "✅ AUDITORIA CONCLUÍDA"

    echo "📁 Resultados salvos em: $AUDIT_DIR"
    echo ""
    echo "Arquivos gerados:"
    ls -lh "$AUDIT_DIR" | tail -n +2 | awk '{print "  - " $9 " (" $5 ")"}'
    echo ""
    echo "Para visualizar o resumo:"
    echo "  cat $AUDIT_DIR/00_summary.txt"
    echo ""

    # Se executado remotamente e há estrutura de auditoria, copiar resultados
    if [ -d "$AUDIT_BASE" ] && [ "$AUDIT_DIR" != "/tmp"* ]; then
        log_success "Resultados integrados à estrutura de auditoria"
    fi
}

main "$@"

