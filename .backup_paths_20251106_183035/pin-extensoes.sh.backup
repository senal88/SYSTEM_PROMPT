#!/bin/bash
# Script unificado para pinagem automática de extensões Atlas CLI
# Detecta automaticamente o ambiente (macOS ou VPS Ubuntu)
# Extensões: Promptheus, WebPilot, AIPRM

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                ATLAS CLI - PINAGEM DE EXTENSÕES                ║"
echo -e "║                    Script Unificado                            ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# Detectar ambiente
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    WORKDIR="/Users/luiz.sena88/Dotfiles/atlas-cli"
    ENVIRONMENT="macOS Silicon"
    ENV_ICON="🍏"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux (VPS Ubuntu)
    WORKDIR="/home/luiz.sena88/Dotfiles/atlas-cli"
    ENVIRONMENT="VPS Ubuntu"
    ENV_ICON="🐧"
else
    error "Sistema operacional não suportado: $OSTYPE"
    exit 1
fi

log "Ambiente detectado: $ENV_ICON $ENVIRONMENT"
log "Diretório de trabalho: $WORKDIR"

# Criar o diretório de trabalho
mkdir -p "$WORKDIR"

# Verificar se o Atlas CLI está instalado
log "Verificando Atlas CLI..."
if ! command -v atlas-cli >/dev/null 2>&1; then
    error "Atlas CLI não está instalado"
    info "Para instalar:"
    echo "1. Acesse: https://atlas.anthropic.com/"
    echo "2. Baixe e instale o Atlas CLI"
    echo "3. Execute este script novamente"
    exit 1
fi
success "✅ Atlas CLI encontrado"

# Verificar se o Atlas CLI está autenticado
log "Verificando autenticação do Atlas CLI..."
if ! atlas-cli status >/dev/null 2>&1; then
    warn "Atlas CLI não está autenticado"
    info "Para autenticar:"
    echo "1. Execute: atlas-cli login"
    echo "2. Siga as instruções na tela"
    echo "3. Execute este script novamente"
    exit 1
fi
success "✅ Atlas CLI autenticado"

# Extensões que serão fixadas na barra
EXTENSOES=("Promptheus" "WebPilot" "AIPRM")

# Função que envia comandos JSON ao Atlas CLI
fixar_extensao() {
    local nome_extensao="$1"
    log "Fixando extensão: $nome_extensao"
    
    # Tentar fixar a extensão
    if atlas-cli <<EOF
{
  "command": "extensions.pin",
  "name": "$nome_extensao",
  "active": true
}
EOF
    then
        success "✅ $nome_extensao fixada com sucesso"
        return 0
    else
        warn "⚠️  Falha ao fixar $nome_extensao"
        return 1
    fi
}

# Loop para fixar cada extensão
log "Iniciando pinagem das extensões..."
SUCCESS_COUNT=0
TOTAL_COUNT=${#EXTENSOES[@]}

for ext in "${EXTENSOES[@]}"; do
    if fixar_extensao "$ext"; then
        ((SUCCESS_COUNT++))
    fi
done

# Resumo final
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    RESUMO DA PINAGEM                          ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

info "Ambiente: $ENV_ICON $ENVIRONMENT"
info "Extensões processadas: $TOTAL_COUNT"
info "Extensões fixadas com sucesso: $SUCCESS_COUNT"

if [[ $SUCCESS_COUNT -eq $TOTAL_COUNT ]]; then
    success "🎉 Todas as extensões foram fixadas com sucesso!"
    echo ""
    info "Extensões fixadas:"
    for ext in "${EXTENSOES[@]}"; do
        echo "  ✅ $ext"
    done
else
    warn "⚠️  Algumas extensões falharam na pinagem"
    echo ""
    info "Verifique se as extensões estão instaladas no Atlas"
    info "Execute: atlas-cli extensions list"
fi

echo ""
log "Pinagem de extensões Atlas CLI concluída! 🚀"