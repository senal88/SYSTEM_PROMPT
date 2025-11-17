<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# 🚀 Plano de Migração: Docker Desktop para Colima

## 1. Inventário do Ambiente Atual (Análise da Auditoria)

Baseado na análise completa do pacote docker_migration_audit_20251030_135931.tar.gz:

### 1.1. Sistema e Versões

- macOS: 26.0.1 (00_system_info.txt)
- Arquitetura: arm64 / Chip Apple M4 (00_system_info.txt)
- Docker CLI: 28.5.1 (01_docker_version.txt)
- Docker Server (Desktop VM): 28.5.1 — OS/Arch linux/arm64 (01_docker_version.txt)
- Compose V2: v2.40.2-desktop.1 (03_docker_compose_version.txt)
- Buildx: v0.29.1-desktop.1 (01_docker_buildx_version.txt)
- Colima/Lima (Status): Não instalado / nenhum perfil listado (09_colima_lima_info.txt)


### 1.2. Configuração do Docker Desktop

- Contexto Atual: desktop-linux (05_docker_config_json.json)
- Socket em Uso: unix:///Users/luiz.sena88/.docker/run/docker.sock (01_docker_context_inspect.json)
- Recursos Alocados (VM): 10 CPUs; 7.654 GiB de memória (01_docker_info.txt)
- Storage Driver: overlayfs (01_docker_info.txt)
- BuildKit Ativo: Builder desktop-linux rodando com BuildKit v0.25.1 (01_docker_buildx_inspect.txt)
- Proxies Internos (Desktop): HTTP/HTTPS http.docker.internal:3128 (não migrar) (01_docker_info.txt)


### 1.3. Artefatos Críticos (Containers, Volumes, Redes)

- Containers (Status): op-connect-sync (unhealthy), op-connect-api (unhealthy), dify-api (Restarting); demais em Created/Up (02_docker_ps.txt)
- Volumes Nomeados (Críticos): infra_portainer_data (único volume não anônimo) (02_docker_volume_ls.txt)
- Redes Customizadas: connect_net, stack-local_traefik_net, traefik_net (02_docker_network_ls.txt)


### 1.4. Integrações e Ambiente (Pontos de Atenção)

- File Sharing (virtiofs): /Users/luiz.sena88/Dotfiles, /Users/luiz.sena88/Projetos, /private, /tmp, /var/folders (08_docker_desktop_processes.txt)
- Segurança (credsStore): "desktop" (05_docker_config_json.json)
- Registries Privados: Nenhum (06_docker_auths_keys.json)
- Certificados Custom: Nenhum (07_docker_certs_d_listing.txt)
- Proxies (Host): Nenhum (07_env_proxies.txt)
- Kubernetes (Status): Sem contextos ou clusters configurados (04_kubernetes_info.txt)


### 1.5. GAPs da Auditoria (Dados Faltantes)

- Arquivos Compose: Nenhum docker-compose.yml encontrado; 03_docker_compose_files.txt e 03_compose_configs/ vazios (necessário localizar manualmente)


## 2. Plano de Ação para Migração (Colima)

Com base no inventário, este é o plano de migração detalhado e os comandos exatos a serem executados:

### 2.1. Fase 1: Instalação (Homebrew)

- Ação: Instalar as dependências CLI (Docker CLI já existe).
- Comando:

```bash
brew install colima lima qemu docker-compose docker-buildx
```


### 2.2. Fase 2: Configuração do Perfil Colima

- Ação: Criar o perfil default do Colima espelhando 100% dos recursos e montagens do Docker Desktop.
- Comando (Pare o Docker Desktop antes de executar):

```bash
colima start --profile default \
  --cpu 10 \
  --memory 8 \
  --disk 60 \
  --arch aarch64 \
  --vm-type vz \
  --mount-type virtiofs \
  --vz-rosetta \
  --dns 1.1.1.1 \
  --mount /Users/luiz.sena88/Dotfiles:w \
  --mount /Users/luiz.sena88/Projetos:w \
  --mount /private:w \
  --mount /tmp:w \
  --mount /var/folders:w
```


### 2.3. Fase 3: Migração de Artefatos

- Ação: Apontar o CLI para Colima e migrar volumes/redes críticas.
- Comandos:

```bash
# 1. Mudar contexto
docker context use colima
docker info | grep -i 'context\|docker root'

# 2. Migrar Volumes (Requer Docker Desktop parado, mas não desinstalado)
echo "Migrando volumes críticos..."
docker context use desktop-linux
docker run --rm \
  -v infra_portainer_data:/v \
  -v "$(pwd)":/b \
  busybox tar czf /b/infra_portainer_data.tgz -C /v .
docker context use colima
docker volume create infra_portainer_data
docker run --rm \
  -v infra_portainer_data:/v \
  -v "$(pwd)":/b \
  busybox sh -c "cd /v && tar xzf /b/infra_portainer_data.tgz"
rm infra_portainer_data.tgz

# 3. Recriar Redes Customizadas
echo "Recriando redes..."
docker network create connect_net
docker network create stack-local_traefik_net
docker network create traefik_net
```


### 2.4. Fase 4: Validação e Pós-Migração

- Buildx:
    - Ação: Criar um novo builder dedicado ao Colima.
    - Comando:

```bash
docker buildx create --name colima_builder --driver docker-container --use
docker buildx inspect --bootstrap
```

- Segurança (credsStore):
    - Ação: Substituir credsStore: "desktop" por osxkeychain em ~/.docker/config.json após instalar o docker-credential-osxkeychain (Homebrew).
    - Validação: Confirmar com:

```bash
cat ~/.docker/config.json | grep credsStore
```

- Validação (Compose):
    - Ação (Manual - GAP 1.5): Localize seus docker-compose.yml nos diretórios de projetos e execute docker compose up -d em cada stack.
    - Comando Sugerido:

```bash
fd -g 'docker-compose*.yml' ~/Dotfiles ~/Projetos
# Para cada stack localizado:
docker compose up -d
docker ps
docker logs op-connect-api
docker logs dify-api
```


## 3. Matriz de Risco e Rollback

- Risco 1 (Compose - GAP): Baixo — ausência de manifests nos exports exige localização manual antes do re-deploy.
- Risco 2 (Volumes): Baixo — apenas infra_portainer_data é nomeado; cópia via tar reduz chance de perda.
- Risco 3 (Containers Unhealthy): Médio — op-connect-* e dify-api já falham no Desktop; revisar saúde e dependências ao reinstanciar em Colima.
- Plano de Rollback (Seguro):

```bash
# 1. Parar o Colima
colima stop
# 2. (Opcional) Remover contexto Colima
# docker context rm colima
# 3. Iniciar o Docker Desktop (via GUI)
# 4. Apontar o CLI de volta para o Desktop
docker context use desktop-linux
```


