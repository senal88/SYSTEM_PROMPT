#!/usr/bin/env bash
################################################################################
# EXECUTAR UPDATE N8N v1.122.4 COM MCP
# Execute este arquivo para atualizar o n8n no VPS
################################################################################

set -e

cd /Users/luiz.sena88/Dotfiles/system_prompts

echo "════════════════════════════════════════════════════════"
echo "  UPDATE N8N v1.122.4 com MCP Capabilities"
echo "════════════════════════════════════════════════════════"
echo ""

# Tornar script executável
chmod +x scripts/update_n8n_vps.sh

# Perguntar confirmação
echo "Este script irá:"
echo "  1. Fazer backup completo do n8n atual"
echo "  2. Upload do novo docker-compose.yml"
echo "  3. Carregar API keys do 1Password"
echo "  4. Atualizar para n8n v1.122.4"
echo "  5. Habilitar MCP e AI Safeguards"
echo ""
read -p "Deseja continuar? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado pelo usuário."
    exit 0
fi

# Executar update
echo ""
echo "[INFO] Iniciando update..."
bash scripts/update_n8n_vps.sh

echo ""
echo "════════════════════════════════════════════════════════"
echo "  ✅ Update concluído!"
echo "════════════════════════════════════════════════════════"
