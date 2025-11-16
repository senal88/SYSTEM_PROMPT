#!/bin/bash

# ============================================
# Script: Configurar 1Password do Cofre
# ============================================
# Busca e configura Service Account Token do cofre 1p_vps
# ============================================

set -e

echo "============================================"
echo "🔐 Configurar 1Password do Cofre 1p_vps"
echo "============================================"
echo ""

# Verificar autenticação
if ! op account list &>/dev/null 2>&1; then
    echo "❌ 1Password não autenticado"
    echo ""
    echo "Para autenticar:"
    echo "  eval \$(op signin my.1password.com luiz.sena88@icloud.com)"
    echo ""
    exit 1
fi

# Tentar diferentes nomes e vaults
ITEM_NAMES=("1p_vps" "VPS 1Password" "1Password VPS" "Service Account VPS" "OP_VPS" "vps")
VAULT_NAMES=("1p_vps" "Private" "Personal" "VPS")

TOKEN=""
ITEM_FOUND=""

# Buscar em todos os vaults
for vault in $(op vault list --format json 2>/dev/null | grep -o '"name":"[^"]*"' | cut -d'"' -f4); do
    for item_name in "${ITEM_NAMES[@]}"; do
        echo "Buscando: '$item_name' no vault '$vault'..."

        # Tentar buscar item
        ITEM_DATA=$(op item get "$item_name" --vault "$vault" --format json 2>/dev/null || echo "")

        if [ -n "$ITEM_DATA" ]; then
            # Tentar extrair token de diferentes campos
            TOKEN=$(echo "$ITEM_DATA" | grep -o '"value":"opvault_[^"]*"' | cut -d'"' -f4 || \
                   echo "$ITEM_DATA" | grep -o '"value":"[^"]*token[^"]*"' | cut -d'"' -f4 || \
                   echo "$ITEM_DATA" | jq -r '.fields[] | select(.label | test("token|Token|SERVICE|service"; "i")) | .value' 2>/dev/null || \
                   echo "")

            if [ -n "$TOKEN" ] && [[ "$TOKEN" =~ ^opvault_ ]]; then
                ITEM_FOUND="$item_name"
                VAULT_FOUND="$vault"
                break 2
            fi
        fi
    done
done

# Se não encontrou, listar todos os itens para ajudar
if [ -z "$TOKEN" ]; then
    echo ""
    echo "⚠️  Item '1p_vps' não encontrado automaticamente"
    echo ""
    echo "Itens disponíveis nos vaults:"
    for vault in $(op vault list --format json 2>/dev/null | grep -o '"name":"[^"]*"' | cut -d'"' -f4); do
        echo ""
        echo "Vault: $vault"
        op item list --vault "$vault" 2>/dev/null | head -10 | sed 's/^/  /'
    done
    echo ""
    echo "Para configurar manualmente:"
    echo "  export OP_SERVICE_ACCOUNT_TOKEN='seu-token'"
    echo "  echo 'export OP_SERVICE_ACCOUNT_TOKEN=\"seu-token\"' >> ~/.bashrc"
    exit 1
fi

# Configurar token
echo ""
echo "✅ Token encontrado no item: $ITEM_FOUND (vault: $VAULT_FOUND)"
echo ""

# Remover token antigo
sed -i '/^export OP_SERVICE_ACCOUNT_TOKEN=/d' ~/.bashrc 2>/dev/null || true

# Adicionar novo token
echo "" >> ~/.bashrc
echo "# 1Password Service Account Token (do cofre 1p_vps)" >> ~/.bashrc
echo "export OP_SERVICE_ACCOUNT_TOKEN=\"$TOKEN\"" >> ~/.bashrc

export OP_SERVICE_ACCOUNT_TOKEN="$TOKEN"

echo "✅ Token configurado no .bashrc"
echo ""

# Testar
echo "Testando autenticação..."
if op vault list &>/dev/null 2>&1; then
    echo "✅ Autenticação funcionando!"
    echo ""
    echo "Vaults disponíveis:"
    op vault list | sed 's/^/  /'
else
    echo "❌ Token pode estar inválido ou sem permissões"
    exit 1
fi

echo ""
echo "✅ Configuração concluída!"
echo ""
echo "Para usar em novos shells:"
echo "  source ~/.bashrc"
echo ""

