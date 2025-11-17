#!/bin/bash

# Required parameters:
# @raycast.title Stirling-PDF Status
# @raycast.author Luiz Sena
# @raycast.authorURL https://github.com/luizsena88
# @raycast.description Verifica status e controla o Stirling-PDF
# @raycast.mode full
# @raycast.packageName Stirling-PDF
# @raycast.icon 🔧

# @raycast.argument1 { "type": "text", "placeholder": "Ação (start, stop, restart, status, logs)", "optional": true }

# --- Configuração ---
PROJECT_DIR="/Users/luiz.sena88/Projetos/stirling-pdf"
CONTROL_SCRIPT="$PROJECT_DIR/stirling-control.sh"
STIRLING_URL="http://localhost:8081"

# --- Execução Principal ---

echo "🔧 Stirling-PDF Control Panel"
echo "============================"

# Navegar para o diretório do projeto
cd "$PROJECT_DIR"

# Determinar ação
action="${1:-status}"

case "$action" in
    "start")
        echo "🚀 Iniciando Stirling-PDF..."
        ./stirling-control.sh start
        ;;
    "stop")
        echo "🛑 Parando Stirling-PDF..."
        ./stirling-control.sh stop
        ;;
    "restart")
        echo "🔄 Reiniciando Stirling-PDF..."
        ./stirling-control.sh restart
        ;;
    "status")
        echo "📊 Status do Stirling-PDF:"
        ./stirling-control.sh status
        echo ""
        echo "🌐 URL: $STIRLING_URL"
        ;;
    "logs")
        echo "📝 Exibindo logs do Stirling-PDF..."
        ./stirling-control.sh logs
        ;;
    "open")
        echo "🌐 Abrindo Stirling-PDF no navegador..."
        open "$STIRLING_URL"
        ;;
    *)
        echo "❌ Ação inválida: $action"
        echo ""
        echo "💡 Ações disponíveis:"
        echo "  start    - Iniciar Stirling-PDF"
        echo "  stop     - Parar Stirling-PDF"
        echo "  restart  - Reiniciar Stirling-PDF"
        echo "  status   - Verificar status"
        echo "  logs     - Exibir logs"
        echo "  open     - Abrir no navegador"
        exit 1
        ;;
esac

echo "🏁 Operação finalizada"
