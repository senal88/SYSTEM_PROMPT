#!/usr/bin/env bash
# Valida permissões críticas e loga inconsistências
BASE_DIR="${HOME}/Dotfiles/automation_1password"
LOG_FILE="$BASE_DIR/logs/validate_permissions_$(date +%Y%m%d_%H%M%S).log"
find "$BASE_DIR" -type f | while read -r file; do
  PERM=$(stat -f "%A" "$file" 2>/dev/null || stat -c "%A" "$file")
  if [[ "$PERM" != "-rw-r--r--" && "$PERM" != "-rw-------" ]]; then
    echo "Arquivo $file com permissão incomum: $PERM" | tee -a "$LOG_FILE"
  fi
  OWNER=$(stat -f "%Su" "$file" 2>/dev/null || stat -c "%U" "$file")
  if [[ "$OWNER" != "luiz.sena88" ]]; then
    echo "Arquivo $file com proprietário diferente: $OWNER" | tee -a "$LOG_FILE"
  fi
  # Adicione outras validações conforme necessário
  
done
