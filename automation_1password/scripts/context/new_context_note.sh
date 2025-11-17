#!/usr/bin/env bash

set -euo pipefail

REPO="${REPO:-$PWD}"

TPL="$REPO/context/metadata/schemas/context_note_template.md"

AREA="${1:-kb}"; SUB="${2:-general}"; TITLE="${3:-rationale}"; VER="${4:-v01}"

DATE="$(date +%Y_%m_%d)"; ISO="$(date +%F)"

SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-|-$//g')"

OUT="$REPO/context/curated/${AREA}__${SUB}__${SLUG}__${DATE}__${VER}.md"

sed -e "s/<título curto>/${TITLE}/" -e "s/<YYYY-MM-DD>/${ISO}/g" -e "s/<slug>/${AREA}-${SUB}-${SLUG}/" "$TPL" > "$OUT"

echo "Criado: $OUT"; command -v code >/dev/null && code "$OUT" || true

