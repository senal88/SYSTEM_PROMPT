#!/usr/bin/env bash
# Sincroniza config Claude Desktop com vault Obsidian

CLAUDE_USER_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
CLAUDE_PROJECT_CONFIG="/Users/luiz.sena88/Dotfiles/system_prompts/segundo-cerebro-ia/claude-config/claude_desktop_config.json"

if [[ -f "$CLAUDE_USER_CONFIG" ]]; then
    echo "[INFO] Backup config existente..."
    cp "$CLAUDE_USER_CONFIG" "$CLAUDE_USER_CONFIG.bak"
fi

echo "[INFO] Copiando nova config..."
cp "$CLAUDE_PROJECT_CONFIG" "$CLAUDE_USER_CONFIG"

echo "[✓] Claude Desktop configurado"
echo "[!] Reinicie o Claude Desktop para aplicar mudanças"
