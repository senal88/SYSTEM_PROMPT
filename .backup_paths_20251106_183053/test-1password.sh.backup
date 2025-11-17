#!/bin/bash
# @raycast.title Test 1Password
# @raycast.mode fullOutput
# @raycast.icon key
# @raycast.packageName Security

echo "🔐 Testando 1Password CLI..."
if op item list >/dev/null 2>&1; then
    ITEM_COUNT=$(op item list --format=json | jq '. | length' 2>/dev/null || echo "0")
    echo "✅ 1Password funcionando - $ITEM_COUNT itens acessíveis"
else
    echo "❌ 1Password não está funcionando"
    echo "Execute: op signin"
fi
