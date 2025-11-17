#!/usr/bin/env bash
# ==========================================================
# UNIVERSAL AUDIT SCRIPT (macOS Silicon + Ubuntu)
# Author: Luiz Sena
# ==========================================================
set -euo pipefail
IFS=$'\n\t'

# Detect environment
if [[ "$(uname)" == "Darwin" ]]; then
  SHELL_NAME="zsh"
  BASE_DIR="${HOME}/Dotfiles/automation_1password"
else
  SHELL_NAME="bash"
  BASE_DIR="/home/luiz.sena88/Dotfiles/automation_1password"
fi

DATE_TAG=$(date +%Y%m%d_%H%M%S)
EXPORT_DIR="$BASE_DIR/exports"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$EXPORT_DIR" "$LOG_DIR"

MD_FILE="$EXPORT_DIR/export_full_${DATE_TAG}.md"
JSON_FILE="$EXPORT_DIR/export_manifest_${DATE_TAG}.json"
LOG_FILE="$LOG_DIR/audit_${DATE_TAG}.log"

# Cabeçalho Markdown
{
  echo "# 🔍 Auditoria Completa - automation_1password"
  echo "## Data: $(date)"
  echo "## Hostname: $(hostname)"
  echo "## Usuário: $(whoami)"
  echo "## Shell: $SHELL_NAME"
  echo "## SO: $(uname -a)"
  echo ""
} > "$MD_FILE"

# Dependencies check
for cmd in op jq git docker python3 curl; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Falta dependência: $cmd" | tee -a "$LOG_FILE"
  else
    echo "✅ $cmd instalado" | tee -a "$LOG_FILE"
  fi
}

echo "" >> "$MD_FILE"
echo "## Estrutura e Metadados dos Arquivos" >> "$MD_FILE"
echo "[" > "$JSON_FILE"

FIRST=true
find "$BASE_DIR" -type f ! -path "$EXPORT_DIR/*" ! -path "$LOG_DIR/*" | while read -r file; do
  NAME=$(basename "$file")
  SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
  MOD=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file" 2>/dev/null || stat -c "%y" "$file" | cut -d'.' -f1)
  PERM=$(stat -f "%A" "$file" 2>/dev/null || stat -c "%A" "$file")
  OWNER=$(stat -f "%Su" "$file" 2>/dev/null || stat -c "%U" "$file")
  GROUP=$(stat -f "%Sg" "$file" 2>/dev/null || stat -c "%G" "$file")
  HASH=$(shasum -a 256 "$file" 2>/dev/null | awk '{print $1}' || sha256sum "$file" | awk '{print $1}')
  echo "- $file (Perm: $PERM, Owner: $OWNER, Group: $GROUP, Tamanho: ${SIZE}B, Modificado: $MOD)" >> "$MD_FILE"
  # Append JSON
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    echo "," >> "$JSON_FILE"
  fi
  echo "{\"path\": \"$file\", \"perm\": \"$PERM\", \"owner\": \"$OWNER\", \"group\": \"$GROUP\", \"size\": $SIZE, \"modified\": \"$MOD\", \"sha256\": \"$HASH\"}" >> "$JSON_FILE"
done
echo "]" >> "$JSON_FILE"

echo "" >> "$MD_FILE"
echo "## 🧩 Cofres 1Password Detectados" >> "$MD_FILE"
unset OP_CONNECT_HOST OP_CONNECT_TOKEN
if op whoami &>/dev/null; then
  op vault list | tee -a "$MD_FILE"
else
  echo "⚠️ 1Password CLI não autenticado" >> "$MD_FILE"
fi

echo "" >> "$MD_FILE"
echo "## ✅ Finalização" >> "$MD_FILE"
echo "- Relatório Markdown: $MD_FILE" >> "$MD_FILE"
echo "- Manifesto JSON: $JSON_FILE" >> "$MD_FILE"
echo "- Log: $LOG_FILE" >> "$MD_FILE"
