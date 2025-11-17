#!/usr/bin/env bash
# Extrai metadados em JSON para parsing por IA
BASE_DIR="${HOME}/Dotfiles/automation_1password"
EXPORT_FILE="$BASE_DIR/exports/metadata_$(date +%Y%m%d_%H%M%S).json"
echo "[" > "$EXPORT_FILE"
FIRST=true
find "$BASE_DIR" -type f | while read -r file; do
  NAME=$(basename "$file")
  SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
  MOD=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file" 2>/dev/null || stat -c "%y" "$file" | cut -d'.' -f1)
  PERM=$(stat -f "%A" "$file" 2>/dev/null || stat -c "%A" "$file")
  OWNER=$(stat -f "%Su" "$file" 2>/dev/null || stat -c "%U" "$file")
  GROUP=$(stat -f "%Sg" "$file" 2>/dev/null || stat -c "%G" "$file")
  HASH=$(shasum -a 256 "$file" 2>/dev/null | awk '{print $1}' || sha256sum "$file" | awk '{print $1}')
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    echo "," >> "$EXPORT_FILE"
  fi
  echo "{\"path\": \"$file\", \"perm\": \"$PERM\", \"owner\": \"$OWNER\", \"group\": \"$GROUP\", \"size\": $SIZE, \"modified\": \"$MOD\", \"sha256\": \"$HASH\"}" >> "$EXPORT_FILE"
done
echo "]" >> "$EXPORT_FILE"
