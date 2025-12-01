#!/bin/bash
# Script para Instalar LaunchAgent de Monitoramento do Mouse Dell MS3320W
# Objetivo: Configurar monitoramento automático em background
# Autor: Sistema de Automação Dotfiles
# Data: $(date +%Y-%m-%d)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
PLIST_NAME="com.dotfiles.dell-ms3320w-monitor.plist"
PLIST_PATH="${LAUNCH_AGENTS_DIR}/${PLIST_NAME}"
MONITOR_SCRIPT="${SCRIPT_DIR}/dell-ms3320w-monitor.sh"

# Verificar se o script de monitoramento existe
if [ ! -f "${MONITOR_SCRIPT}" ]; then
    echo "ERRO: Script de monitoramento não encontrado: ${MONITOR_SCRIPT}"
    exit 1
fi

# Garantir que o script é executável
chmod +x "${MONITOR_SCRIPT}"

# Criar diretório LaunchAgents se não existir
mkdir -p "${LAUNCH_AGENTS_DIR}"

# Criar arquivo plist do LaunchAgent
cat > "${PLIST_PATH}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.dell-ms3320w-monitor</string>

    <key>ProgramArguments</key>
    <array>
        <string>${MONITOR_SCRIPT}</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>${HOME}/.local/logs/bluetooth/dell-ms3320w-launchagent.out.log</string>

    <key>StandardErrorPath</key>
    <string>${HOME}/.local/logs/bluetooth/dell-ms3320w-launchagent.err.log</string>

    <key>StartInterval</key>
    <integer>300</integer>

    <key>ThrottleInterval</key>
    <integer>60</integer>

    <key>ProcessType</key>
    <string>Background</string>

    <key>Nice</key>
    <integer>1</integer>
</dict>
</plist>
EOF

echo "✅ LaunchAgent criado: ${PLIST_PATH}"

# Carregar o LaunchAgent
if launchctl list | grep -q "com.dotfiles.dell-ms3320w-monitor"; then
    echo "⏹️  Parando serviço existente..."
    launchctl unload "${PLIST_PATH}" 2>/dev/null || true
fi

echo "▶️  Carregando LaunchAgent..."
launchctl load "${PLIST_PATH}"

# Verificar status
sleep 2
if launchctl list | grep -q "com.dotfiles.dell-ms3320w-monitor"; then
    echo "✅ LaunchAgent carregado com sucesso!"
    echo ""
    echo "Para verificar o status:"
    echo "  launchctl list | grep dell-ms3320w"
    echo ""
    echo "Para parar o serviço:"
    echo "  launchctl unload ${PLIST_PATH}"
    echo ""
    echo "Para reiniciar o serviço:"
    echo "  launchctl unload ${PLIST_PATH} && launchctl load ${PLIST_PATH}"
    echo ""
    echo "Logs:"
    echo "  ${HOME}/.local/logs/bluetooth/"
else
    echo "⚠️  Aviso: LaunchAgent pode não ter sido carregado corretamente"
    echo "Verifique os logs em: ${HOME}/.local/logs/bluetooth/"
fi

