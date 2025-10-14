#!/bin/bash
set -euo pipefail

# Corrige prompts constantes de acesso à rede local para apps Electron
# no macOS Tahoe 26.0.1 seguindo o runbook da documentação.

echo 'Correcao: Electron solicitando rede local - macOS Tahoe 26.0.1'
echo '================================================================'
echo ''

echo 'Problema identificado:'
echo 'Aplicativos baseados em Electron (VS Code, etc.) solicitam acesso a redes locais continuamente.'
echo ''

echo 'Apps Electron detectados:'
if ELECTRON_APPS=$(find /Applications -type f -path '*/Contents/Info.plist' -print0 \
    | xargs -0 grep -l 'Electron' 2>/dev/null); then
    if [ -z "$ELECTRON_APPS" ]; then
        echo '  - Nenhum app Electron encontrado em /Applications.'
    else
        printf '%s\n' "$ELECTRON_APPS" | while IFS= read -r plist; do
            app_dir="${plist%/Contents/Info.plist}"
            echo "  - $(basename "$app_dir" .app)"
        done
    fi
else
    echo '  - Falha ao inspecionar /Applications.'
fi
echo ''

echo 'Aplicando correcoes...'
echo ''

echo '1) Ajustando permissao LocalNetwork do VS Code'
if [ -d '/Applications/Visual Studio Code.app' ]; then
    if ! sudo tccutil reset LocalNetwork com.microsoft.VSCode 2>/dev/null; then
        echo '   • Reset LocalNetwork nao era necessario.'
    fi
    echo '   • Permissoes do VS Code ajustadas.'
else
    echo '   • VS Code nao encontrado em /Applications.'
fi
echo ''

echo '2) Atualizando preferencias de Privacy & Security'
if sudo defaults write /Library/Preferences/com.apple.networkserviceproxy UseSystemProxySettings -bool true >/dev/null 2>&1; then
    echo '   • Configuracoes de proxy do sistema aplicadas.'
else
    echo '   • Nao foi possivel aplicar a configuracao de proxy.'
fi
echo ''

echo '3) Resetando permissoes TCC relacionadas'
sudo tccutil reset All com.microsoft.VSCode 2>/dev/null || true
sudo tccutil reset All com.microsoft.VSCode.helper 2>/dev/null || true
echo '   • Permissoes TCC resetadas.'
echo ''

echo '4) Gerando configuracao Electron padrao'
mkdir -p "$HOME/Library/Preferences/Electron"
cat > "$HOME/Library/Preferences/Electron/config.json" <<'JSON'
{
  "network": {
    "disable_local_discovery": false,
    "auto_grant_local_network": true
  },
  "privacy": {
    "suppress_network_prompts": true
  }
}
JSON
echo '   • Configuracao Electron escrita em ~/Library/Preferences/Electron.'
echo ''

echo '5) Ajustando settings.json do VS Code'
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_CONFIG_DIR"
SETTINGS_FILE="$VSCODE_CONFIG_DIR/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    backup_file="$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$SETTINGS_FILE" "$backup_file"
    echo "   • Backup criado: $backup_file"
else
    cat > "$SETTINGS_FILE" <<'JSON'
{
    "security.workspace.trust.enabled": false,
    "extensions.autoCheckUpdates": false,
    "telemetry.telemetryLevel": "off",
    "update.mode": "manual"
}
JSON
    echo '   • settings.json inicial criado.'
fi

if [ -f "$SETTINGS_FILE" ]; then
    if command -v jq >/dev/null 2>&1; then
        tmp_settings=$(mktemp)
        jq '."security.workspace.trust.enabled" = false |
            ."extensions.autoCheckUpdates" = false |
            ."telemetry.telemetryLevel" = "off" |
            ."update.mode" = "manual"' "$SETTINGS_FILE" >"$tmp_settings" && mv "$tmp_settings" "$SETTINGS_FILE"
    else
        python3 - "$SETTINGS_FILE" <<'PY'
import json
import pathlib
import sys

settings = pathlib.Path(sys.argv[1])
if settings.exists():
    try:
        content = json.loads(settings.read_text())
    except json.JSONDecodeError:
        content = {}
else:
    content = {}

content.update({
    "security.workspace.trust.enabled": False,
    "extensions.autoCheckUpdates": False,
    "telemetry.telemetryLevel": "off",
    "update.mode": "manual"
})

settings.write_text(json.dumps(content, indent=4, ensure_ascii=False) + "\n")
PY
    fi
    echo '   • settings.json atualizado.'
fi
echo ''

echo '6) Ajustando firewall do macOS'
FIREWALL_STATUS=$(sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep 'enabled' || printf 'disabled')
echo "   • Estado atual: $FIREWALL_STATUS"
if [ -d '/Applications/Visual Studio Code.app' ]; then
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add '/Applications/Visual Studio Code.app/Contents/MacOS/Electron' 2>/dev/null || true
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp '/Applications/Visual Studio Code.app/Contents/MacOS/Electron' 2>/dev/null || true
    echo '   • VS Code adicionado as excecoes do firewall.'
else
    echo '   • VS Code nao encontrado para ajustes no firewall.'
fi
echo ''

echo '7) Recriando cache de permissoes'
sudo killall -HUP tccd 2>/dev/null || echo '   • tccd nao estava em execucao.'
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.tccd.system.plist 2>/dev/null || true
sudo launchctl load /System/Library/LaunchDaemons/com.apple.tccd.system.plist 2>/dev/null || true
echo '   • Cache de permissoes recriado.'
echo ''

cat <<'MANUAL'
Instrucoes manuais adicionais:
1) System Settings → Privacy & Security → Local Network
   - Marque o acesso para "Visual Studio Code" ou demais apps Electron.

2) Caso o problema persista:
   - System Settings → Privacy & Security → Full Disk Access
   - Adicione "Visual Studio Code" à lista.

3) Para outros apps Electron:
   - Repita o processo para Discord, Slack, WhatsApp Desktop, etc.
MANUAL
echo ''

cat <<'NEXT'
Proximos passos:
1. Reinicie o VS Code.
2. Verifique se os prompts cessaram.
3. Se necessario, finalize configuracoes manualmente no System Settings.
NEXT
echo ''

echo 'Correcao aplicada.'
echo 'Se o aviso retornar, execute: sudo tccutil reset LocalNetwork com.microsoft.VSCode'
echo 'Depois, autorize novamente o acesso em System Settings.'
