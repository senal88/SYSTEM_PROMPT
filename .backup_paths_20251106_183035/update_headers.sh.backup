#!/bin/bash
set -euo pipefail

# update_headers.sh
# Atualiza/injeta headers padronizados em arquivos Markdown
# Regras: "Last Updated: YYYY-MM-DD" e "Version: 2.0.0" no topo (até 10 primeiras linhas)
# Uso:
#   scripts/audit/update_headers.sh --date 2025-10-30 --version 2.0.0 FILE [FILE...]
# Notas:
# - Idempotente: substitui headers existentes; insere se não houver
# - Apenas toca arquivos que mudarem de fato
# - Ignora arquivos fora de *.md

DATE_VALUE=""
VERSION_VALUE=""

print_usage() {
  echo "Uso: $0 --date YYYY-MM-DD --version X.Y.Z <arquivos...>" >&2
}

# Parse args
if [[ $# -lt 3 ]]; then
  print_usage; exit 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --date)
      DATE_VALUE="${2:-}"; shift 2 ;;
    --version)
      VERSION_VALUE="${2:-}"; shift 2 ;;
    --help|-h)
      print_usage; exit 0 ;;
    *)
      break ;;
  esac
done

if [[ -z "$DATE_VALUE" || -z "$VERSION_VALUE" ]]; then
  print_usage; exit 2
fi

if [[ $# -lt 1 ]]; then
  echo "Erro: especifique ao menos um arquivo .md" >&2
  exit 2
fi

update_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  case "$file" in
    *.md|*.MD|*.markdown) : ;; 
    *) return 0 ;;
  esac

  # Lê as 10 primeiras linhas para detectar headers
  local head_tmp
  head_tmp="$(head -n 10 "$file" || true)"

  local new_header
  new_header="Last Updated: ${DATE_VALUE}
Version: ${VERSION_VALUE}"

  # Lógicas de substituição:
  # 1) Se existir linhas com Last Updated/Version nas 10 primeiras, substituir
  # 2) Caso contrário, inserir no topo com uma linha em branco após

  local tmp_file
  tmp_file="${file}.tmp.$$"

  if echo "$head_tmp" | grep -qiE '^(Last Updated|Última Atualização|Atualizado em)\s*:'; then
    # Substitui qualquer variação conhecida da data
    # Preserva restante do arquivo
    awk -v datev="$DATE_VALUE" -v ver="$VERSION_VALUE" '
      NR<=10 {
        if ($0 ~ /^(Last Updated|\xC3\x9Altima Atualiza\xC3\xA7\xC3\xA3o|Atualizado em)\s*:/i) {
          if (!printed_date) { print "Last Updated: " datev; printed_date=1; }
          next
        }
        if ($0 ~ /^Version\s*:\s*|^Vers(ão|ao)\s*:/i) {
          if (!printed_version) { print "Version: " ver; printed_version=1; }
          next
        }
      }
      { print $0 }
      END {
        # Se não havia algum dos headers nas 10 primeiras, garante inclusão no topo caso ausente
      }
    ' "$file" > "$tmp_file"
  else
    # Insere cabeçalho no topo
    {
      echo "$new_header"
      echo ""
      cat "$file"
    } > "$tmp_file"
  fi

  if ! cmp -s "$file" "$tmp_file"; then
    mv "$tmp_file" "$file"
    echo "Atualizado: $file"
  else
    rm -f "$tmp_file"
  fi
}

# Loop de arquivos
for f in "$@"; do
  update_file "$f"
done
