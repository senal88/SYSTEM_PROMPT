#!/usr/bin/env bash
# ==============================================================================
# 🚀 MASTER SETUP SCRIPT - Automation 1Password
# ==============================================================================
# Arquivo: scripts/bootstrap/master-setup.sh
# Propósito: Setup completo e organização do projeto
# Ambiente: macOS Silicon + VPS Ubuntu
# ==============================================================================

set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# COLORS & LOGGING
# ═══════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_header() { echo -e "\n${MAGENTA}▶ $1${NC}"; }
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# ═══════════════════════════════════════════════════════════════
# CONFIG
# ═══════════════════════════════════════════════════════════════
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$REPO_ROOT/backups/backup-$TIMESTAMP"
LOG_FILE="$REPO_ROOT/logs/master-setup-$TIMESTAMP.log"

# Verificar se é macOS
OS_TYPE="$(uname)"
if [[ "$OS_TYPE" != "Darwin" ]]; then
    OS_TYPE="Linux"
fi

# ═══════════════════════════════════════════════════════════════
# BANNER
# ═══════════════════════════════════════════════════════════════
clear
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🔐 AUTOMATION 1PASSWORD - MASTER SETUP                     ║
║                                                               ║
║   Sistema Híbrido: macOS Silicon DEV + VPS Ubuntu PROD       ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo ""

# Log inicial
mkdir -p "$REPO_ROOT/logs"
{
    echo "═══════════════════════════════════════════════════════════"
    echo "Master Setup Log"
    echo "═══════════════════════════════════════════════════════════"
    echo "Data: $(date)"
    echo "OS: $OS_TYPE"
    echo "Repo: $REPO_ROOT"
    echo "═══════════════════════════════════════════════════════════"
} > "$LOG_FILE"

# ═══════════════════════════════════════════════════════════════
# ETAPA 1: Verificar Pré-Requisitos
# ═══════════════════════════════════════════════════════════════
log_header "1. Verificando Pré-Requisitos"

MISSING_TOOLS=()

# Verificar ferramentas essenciais
for tool in git docker op jq; do
    if command -v "$tool" &>/dev/null; then
        VERSION=$("$tool" --version 2>&1 | head -1)
        log_success "$tool: $VERSION"
    else
        MISSING_TOOLS+=("$tool")
        log_warning "$tool: NÃO INSTALADO"
    fi
done

if [[ ${#MISSING_TOOLS[@]} -gt 0 ]]; then
    log_error "Ferramentas faltando: ${MISSING_TOOLS[*]}"
    log_info "Instale com: brew install ${MISSING_TOOLS[*]}"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# ETAPA 2: Criar Estrutura de Diretórios
# ═══════════════════════════════════════════════════════════════
log_header "2. Criando Estrutura de Diretórios"

DIRS=(
    ".dev/.cursor"
    ".dev/.vscode"
    ".dev/.raycast"
    ".context"
    "scripts/automation"
    "scripts/maintenance"
    "scripts/dev"
    "scripts/workflow"
    "scripts/validation"
    "scripts/secrets"
    "scripts/bootstrap"
    "connect/certs"
    "connect/data"
    "env"
    "templates/env"
    "configs"
    "docs/operations"
    "docs/runbooks"
    "docs/archive"
    "logs"
    "backups"
    "tokens"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$REPO_ROOT/$dir"
    log_success "Criado: $dir"
done

# ═══════════════════════════════════════════════════════════════
# ETAPA 3: Criar Arquivos Essenciais
# ═══════════════════════════════════════════════════════════════
log_header "3. Criando Arquivos Essenciais"

# .gitignore
cat > "$REPO_ROOT/.gitignore" <<'GITIGNORE'
# Secrets & Credentials
.env
.env.*
!.env.template
!.env.op
credentials.json
tokens/
*.key
*.pem
*.p12

# IDE
.vscode/
.cursor/
*.code-workspace

# OS
.DS_Store
._*
.AppleDouble

# Logs
logs/*.log
*.log

# Docker
docker-compose.override.yml
.dockerignore

# Python
__pycache__/
*.pyc
.venv/
venv/

# Node
node_modules/
dist/
.next/

# Build
build/
dist/
*.egg-info/

# Temp
*.tmp
*.swp
*.swo
*~

# Backups
backups/
*.backup
GITIGNORE

log_success "Criado: .gitignore"

# .gitkeep em diretórios importantes
for dir in "logs" "configs" "tokens" "connect/data"; do
    touch "$REPO_ROOT/$dir/.gitkeep"
    log_success "Criado: $dir/.gitkeep"
done

# ═══════════════════════════════════════════════════════════════
# ETAPA 4: Criar Arquivos de Configuração
# ═══════════════════════════════════════════════════════════════
log_header "4. Criando Arquivos de Configuração"

# Makefile no diretório connect
cat > "$REPO_ROOT/connect/Makefile" <<'MAKEFILE'
.PHONY: help setup up down restart logs clean validate health

help:
	@echo "🔧 Automation 1Password - Makefile"
	@echo ""
	@echo "Setup Commands:"
	@echo "  make setup              Setup básico"
	@echo "  make setup-complete     Setup completo com validação"
	@echo ""
	@echo "Docker Commands:"
	@echo "  make up                 Subir containers"
	@echo "  make down               Parar containers"
	@echo "  make restart            Reiniciar containers"
	@echo "  make logs               Ver logs em tempo real"
	@echo ""
	@echo "Validation:"
	@echo "  make validate           Validar setup"
	@echo "  make health             Health check"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean              Limpeza básica"
	@echo "  make clean-volumes      Remover volumes"

setup:
	@echo "🚀 Setup básico..."
	@docker compose pull
	@docker compose up -d
	@sleep 5
	@curl -fsS http://127.0.0.1:8080/health && echo "✅ Ready" || echo "⏳ Aguarde..."

setup-complete: validate setup
	@echo "✅ Setup completo"

up:
	@echo "⬆️  Subindo containers..."
	@docker compose up -d
	@docker compose ps

down:
	@echo "⬇️  Parando containers..."
	@docker compose down

restart:
	@echo "🔄 Reiniciando..."
	@docker compose restart

logs:
	@docker compose logs -f --tail=100

clean:
	@echo "🧹 Limpando..."
	@docker compose down -v

clean-volumes:
	@echo "💾 Removendo volumes..."
	@docker volume prune -f

validate:
	@echo "✅ Validando setup..."
	@docker compose config > /dev/null && echo "✅ Docker Compose OK" || exit 1
	@command -v op >/dev/null && echo "✅ 1Password CLI OK" || exit 1
	@command -v jq >/dev/null && echo "✅ jq OK" || exit 1

health:
	@echo "🏥 Health Check..."
	@curl -fsS http://127.0.0.1:8080/health | jq . || echo "❌ Connect DOWN"
	@docker compose ps
MAKEFILE

log_success "Criado: connect/Makefile"

# ═══════════════════════════════════════════════════════════════
# ETAPA 5: Criar Arquivos de Configuração Environment
# ═══════════════════════════════════════════════════════════════
log_header "5. Criando Arquivos de Ambiente"

# env/shared.env
cat > "$REPO_ROOT/env/shared.env" <<'SHARED'
# ═══════════════════════════════════════════════════════════════
# Shared Environment Variables
# ═══════════════════════════════════════════════════════════════

ORG_NAME=senamfo
PROJECT_NAME=automation-1password
REPO_ROOT=/Users/luiz.sena88/Dotfiles/automation_1password
DATE_TAG=$(date +%Y_%m_%d)

# Docker
COMPOSE_PROJECT_NAME=${PROJECT_NAME}
DOCKER_BUILDKIT=1
DOCKER_SCAN_SUGGEST=false

# Logging
LOG_LEVEL=info
LOG_FORMAT=json

# Timeouts
HTTP_TIMEOUT=30
DB_TIMEOUT=30
SHARED
log_success "Criado: env/shared.env"

# env/README.md
cat > "$REPO_ROOT/env/README.md" <<'ENV_README'
# Environment Configuration

## Files

- **shared.env** - Variáveis compartilhadas entre ambientes
- **macos.env** - Configuração desenvolvimento (macOS)
- **vps.env** - Configuração produção (VPS Ubuntu)

## Carregamento

```bash
# Carregar configuração
source env/shared.env
source env/macos.env  # ou env/vps.env

# Ou usar op inject para secrets
op inject -i templates/env/macos.secrets.env.op -o env/macos.secrets.env
```

## Variaáveis Obrigatórias

- `REPO_ROOT` - Caminho do repositório
- `OP_CONNECT_HOST` - URL do 1Password Connect
- `OP_CONNECT_TOKEN` - Token de autenticação (não commitar)
- `DB_PASSWORD` - Senha do banco (via 1Password)

## Security

- Nunca commitar `.env` com valores reais
- Usar `.env.op` templates com referências `op://`
- Materializar com `op inject` em runtime
ENV_README

log_success "Criado: env/README.md"

# ═══════════════════════════════════════════════════════════════
# ETAPA 6: Criar Scripts de Validação
# ═══════════════════════════════════════════════════════════════
log_header "6. Criando Scripts de Validação"

cat > "$REPO_ROOT/scripts/validation/quick-check.sh" <<'QUICKCHECK'
#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Quick Health Check"
echo ""

# 1Password
if command -v op &>/dev/null; then
    if op whoami &>/dev/null; then
        echo "✅ 1Password: Autenticado"
    else
        echo "⚠️  1Password: Não autenticado (execute: eval \$(op signin))"
    fi
else
    echo "❌ 1Password CLI: Não instalado"
fi

# Docker
if command -v docker &>/dev/null; then
    if docker ps &>/dev/null; then
        echo "✅ Docker: Rodando"
    else
        echo "❌ Docker: Não iniciado"
    fi
else
    echo "❌ Docker: Não instalado"
fi

# Connect Server
if curl -fsS http://127.0.0.1:8080/health &>/dev/null; then
    echo "✅ Connect Server: Saudável"
else
    echo "⚠️  Connect Server: Não respondendo"
fi

echo ""
echo "Status completo: docker compose ps"
QUICKCHECK

chmod +x "$REPO_ROOT/scripts/validation/quick-check.sh"
log_success "Criado: scripts/validation/quick-check.sh"

# ═══════════════════════════════════════════════════════════════
# ETAPA 7: Criar README do Projeto
# ═══════════════════════════════════════════════════════════════
log_header "7. Criando README"

cat > "$REPO_ROOT/README.md" <<'README'
# 🔐 Automation 1Password

Automação de infraestrutura híbrida com 1Password, Docker e Traefik.

**Ambiente:** macOS Silicon (DEV) + VPS Ubuntu (PROD)  
**Status:** ✅ Production Ready  
**Versão:** 2.0.0

## 🚀 Quick Start

```bash
# 1. Instalar dependências
brew install docker 1password-cli jq

# 2. Autenticar 1Password
eval $(op signin)

# 3. Setup
cd connect
make setup

# 4. Verificar
make health
```

## 📁 Estrutura

- `connect/` - Docker Compose stack
- `scripts/` - Automação e ferramentas
- `env/` - Configurações por ambiente
- `docs/` - Documentação técnica
- `configs/` - Templates e configurações

## 📚 Documentação

Ver [docs/README.md](docs/README.md) para documentação completa.

## 🔒 Segurança

- Secrets sempre em 1Password
- Nunca commitar `.env` com valores reais
- Use templates `op://` para referências

## 📞 Suporte

- 📧 Email: luizfernandomoreirasena@gmail.com
- 📖 Docs: [docs/README.md](docs/README.md)
README

log_success "Criado: README.md"

# ═══════════════════════════════════════════════════════════════
# ETAPA 8: Proteger Arquivos Sensíveis
# ═══════════════════════════════════════════════════════════════
log_header "8. Protegendo Arquivos Sensíveis"

# Criar .env.template
cat > "$REPO_ROOT/.env.template" <<'TEMPLATE'
# Copie este arquivo para .env e configure os valores

# 1Password
OP_CONNECT_HOST=http://127.0.0.1:8080
OP_CONNECT_TOKEN=seu-token-aqui

# Database
DATABASE_URL=postgresql://localhost:5432/mydb
DB_USER=devuser
DB_PASSWORD=seu-password-aqui

# Cloudflare
CF_API_TOKEN=seu-token-cloudflare

# Outros
LOG_LEVEL=info
TEMPLATE

log_success "Criado: .env.template"

# Proteger permissões
chmod 600 "$REPO_ROOT/.env.template" 2>/dev/null || true
chmod 600 "$REPO_ROOT/tokens" 2>/dev/null || true

# ═══════════════════════════════════════════════════════════════
# ETAPA 9: Criar Documentação
# ═══════════════════════════════════════════════════════════════
log_header "9. Criando Documentação"

cat > "$REPO_ROOT/docs/README.md" <<'DOCS'
# 📚 Documentação - Automation 1Password

## Índice

### Visão Geral
- [overview.md](overview.md) - Arquitetura técnica

### Operação
- [operations/dns-records.md](operations/dns-records.md) - Configuração DNS
- [operations/integracao-docker-traefik.md](operations/integracao-docker-traefik.md) - Docker + Traefik
- [operations/direnv-op-workflow.md](operations/direnv-op-workflow.md) - Workflows

### Runbooks
- [runbooks/automacao-macos.md](runbooks/automacao-macos.md) - Procedimentos macOS
- [runbooks/automacao-vps.md](runbooks/automacao-vps.md) - Procedimentos VPS
- [runbooks/automacao-dual.md](runbooks/automacao-dual.md) - Procedimentos gerais

## Quick Links

- [../README.md](../README.md) - README principal
- [../.cursorrules](../.cursorrules) - Cursor AI rules
- [../cursor-ide-config.md](../cursor-ide-config.md) - Configuração IDE
DOCS

log_success "Criado: docs/README.md"

# ═══════════════════════════════════════════════════════════════
# ETAPA 10: Criar Script de Utilidades
# ═══════════════════════════════════════════════════════════════
log_header "10. Criando Scripts de Utilidades"

# Script: init-env.sh
cat > "$REPO_ROOT/scripts/dev/init-env.sh" <<'INITENV'
#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Inicializando ambiente..."

# 1. Autenticar 1Password
if ! op whoami &>/dev/null; then
    echo "📲 Autenticando 1Password..."
    eval $(op signin)
fi

# 2. Validar estrutura
if [[ ! -f ".env.template" ]]; then
    echo "❌ .env.template não encontrado"
    exit 1
fi

# 3. Criar .env se não existir
if [[ ! -f ".env" ]]; then
    echo "📝 Criando .env..."
    cp .env.template .env
    echo "⚠️  Configure .env com seus valores"
fi

echo "✅ Ambiente inicializado"
INITENV

chmod +x "$REPO_ROOT/scripts/dev/init-env.sh"
log_success "Criado: scripts/dev/init-env.sh"

# ═══════════════════════════════════════════════════════════════
# ETAPA 11: Criar .editorconfig
# ═══════════════════════════════════════════════════════════════
log_header "11. Criando .editorconfig"

cat > "$REPO_ROOT/.editorconfig" <<'EDITORCONFIG'
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{sh,bash}]
indent_style = space
indent_size = 2

[*.{yml,yaml}]
indent_style = space
indent_size = 2

[*.json]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
EDITORCONFIG

log_success "Criado: .editorconfig"

# ═══════════════════════════════════════════════════════════════
# ETAPA 12: RESUMO FINAL
# ═══════════════════════════════════════════════════════════════
log_header "RESUMO DO SETUP"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "✅ SETUP CONCLUÍDO COM SUCESSO!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📁 Estrutura criada:"
echo "  ✓ $(find "$REPO_ROOT" -type d | wc -l) diretórios"
echo "  ✓ $(find "$REPO_ROOT" -type f -not -path '*/\.*' | wc -l) arquivos"
echo ""
echo "🚀 Próximos passos:"
echo "  1. cd $REPO_ROOT/connect"
echo "  2. make setup"
echo "  3. make health"
echo ""
echo "📚 Documentação:"
echo "  README.md - Começar aqui"
echo "  docs/README.md - Documentação técnica"
echo "  .cursorrules - Rules para Cursor AI"
echo ""
echo "🔐 Segurança:"
echo "  • .env adicionado ao .gitignore"
echo "  • tokens/ protegido"
echo "  • Permissões: 600 em arquivos sensíveis"
echo ""
echo "📊 Log salvo em: $LOG_FILE"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Atualizar log final
{
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "Setup concluído com sucesso!"
    echo "Data: $(date)"
    echo "═══════════════════════════════════════════════════════════"
} >> "$LOG_FILE"

exit 0
