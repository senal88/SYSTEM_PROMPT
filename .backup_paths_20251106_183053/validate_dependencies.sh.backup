#!/usr/bin/env bash
# Valida dependências obrigatórias
LOG_FILE="${HOME}/Dotfiles/automation_1password/logs/validate_dependencies_$(date +%Y%m%d_%H%M%S).log"
for cmd in op jq git docker python3 curl; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Falta dependência: $cmd" | tee -a "$LOG_FILE"
  else
    echo "✅ $cmd instalado" | tee -a "$LOG_FILE"
  fi
done
