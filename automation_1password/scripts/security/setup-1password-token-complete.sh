#!/bin/bash
set -euo pipefail

# ============================================================================
# Configuração Completa do Token 1Password + Export de Inventário
# Executa TUDO automaticamente: token, validação, export completo
# ============================================================================

# Token fornecido (Connect Token JWT)
OP_TOKEN="${1:-eyJhbGciOiJFUzI1NiIsImtpZCI6IjZzamszamkzb253eDZlMmVweGN3amN6Mmt1IiwidHlwIjoiSldUIn0.eyIxcGFzc3dvcmQuY29tL2F1dWlkIjoiUlRUVzNRWUQ2RkdTQkZUTUVUTTYzSE5OTzQiLCIxcGFzc3dvcmQuY29tL3Rva2VuIjoiWmZCWEtMcVg2aXZsaFBhSUpHTV9NOW5Zb3l5ZVFaam8iLCIxcGFzc3dvcmQuY29tL2Z0cyI6WyJ2YXVsdGFjY2VzcyJdLCIxcGFzc3dvcmQuY29tL3Z0cyI6W3sidSI6ImdrcHNiZ2l6bGtzMnprbnd6cXBwcG5iMnplIiwiYSI6NDh9LHsidSI6Im9hM3RpZGVrbWV1MjZueGlpZXIycWJpN3Y0IiwiYSI6NDk2fV0sImF1ZCI6WyJjb20uMXBhc3N3b3JkLmNvbm5lY3QiXSwic3ViIjoiQkZGRVZVWUlUQkNUUEdGWlZTWDRGTVhQM1EiLCJpYXQiOjE3NjMyNTkwODMsImlzcyI6ImNvbS4xcGFzc3dvcmQuYjUiLCJqdGkiOiJtczY1dmtlcDRhY3V1Z3pqNG5kZTJicDdleSJ9.sTfCqx5N0_1fY1niwaXTmcmrP65Hzr04foE41NPXTeCfk6Wfgn4m41W4PKjSa5xoeN0-BvzWv04ERdEGVUdGfA}"

VAULT_IDS="gkpsbgizlks2zknwzqpppnb2ze oa3tidekmeu26nxiier2qbi7v4 syz4hgfg6c62ndrxjmoortzhia 7bgov3zmccio5fxc5v7irhy5k4"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

log "🚀 Iniciando configuração completa do 1Password..."

# 1. Persistir token em /etc/op/op.env
log "1/5 Persistindo token em /etc/op/op.env..."
umask 077
sudo mkdir -p /etc/op
sudo bash -c "cat > /etc/op/op.env <<'EOF'
export OP_SERVICE_ACCOUNT_TOKEN='${OP_TOKEN}'
export OP_VAULT='1p_vps'
EOF"
sudo chmod 600 /etc/op/op.env
sudo chown root:root /etc/op/op.env
success "✅ Token persistido"

# 2. Carregar e validar
log "2/5 Validando autenticação 1Password..."
source /etc/op/op.env
export OP_SERVICE_ACCOUNT_TOKEN="${OP_TOKEN}"
export OP_VAULT="1p_vps"

if ! op --version >/dev/null 2>&1; then
    error "1Password CLI não está instalado"
fi

if ! op account list >/dev/null 2>&1; then
    error "Falha na autenticação - token inválido ou expirado"
fi
success "✅ Autenticação validada"

# 3. Exportar inventário completo
log "3/5 Exportando inventário completo..."
EXPORT_SCRIPT="${HOME}/Dotfiles/automation_1password/scripts/security/export_1password_inventory.sh"
if [ ! -x "$EXPORT_SCRIPT" ]; then
    error "Script de exportação não encontrado: $EXPORT_SCRIPT"
fi

bash "$EXPORT_SCRIPT" \
    --token-source env \
    --default-vault "1p_vps" \
    --vault-ids "$VAULT_IDS" \
    --inject \
    --no-bootstrap 2>&1 | tee /tmp/export.log

success "✅ Inventário exportado"

# 4. Localizar saída e validar arquivos
log "4/5 Validando arquivos gerados..."
OUT_DIR=$(ls -dt ~/1password_inventory/* 2>/dev/null | head -n1)
if [ -z "$OUT_DIR" ] || [ ! -d "$OUT_DIR" ]; then
    error "Diretório de saída não encontrado"
fi

FILES_OK=0
[ -s "$OUT_DIR/1p_inventory_uuid.json" ] && ((FILES_OK++))
[ -s "$OUT_DIR/1p_inventory_uuid.csv" ] && ((FILES_OK++))
[ -s "$OUT_DIR/1p_inventory_uuid.md" ] && ((FILES_OK++))
[ -s "$OUT_DIR/generated_with_uuid.env.op" ] && ((FILES_OK++))
[ -s "$OUT_DIR/.env" ] && ((FILES_OK++))

if [ $FILES_OK -lt 3 ]; then
    warn "Alguns arquivos não foram gerados (esperado: 5, gerado: $FILES_OK)"
else
    success "✅ Arquivos validados ($FILES_OK/5)"
fi

# 5. Estatísticas
log "5/5 Gerando estatísticas..."
if [ -s "$OUT_DIR/1p_inventory_uuid.json" ]; then
    VC=$(jq -r '.[].vault_id' "$OUT_DIR/1p_inventory_uuid.json" 2>/dev/null | sort -u | wc -l | tr -d ' ')
    IC=$(jq -r '.[].item_id' "$OUT_DIR/1p_inventory_uuid.json" 2>/dev/null | sort -u | wc -l | tr -d ' ')
    FC=$(jq -r '.[].field_id' "$OUT_DIR/1p_inventory_uuid.json" 2>/dev/null | wc -l | tr -d ' ')
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ CONFIGURAÇÃO COMPLETA FINALIZADA${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "📊 Estatísticas:"
    echo "   • Cofres: $VC"
    echo "   • Itens: $IC"
    echo "   • Campos: $FC"
    echo ""
    echo "📁 Diretório de saída:"
    echo "   $OUT_DIR"
    echo ""
    echo "📄 Arquivos gerados:"
    ls -1h "$OUT_DIR" | sed 's/^/   • /'
    echo ""
fi

success "🎉 Tudo configurado e exportado com sucesso!"

