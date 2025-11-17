#!/usr/bin/env bash

set -euo pipefail

REPO="${REPO:-$PWD}"; OUT="$REPO/context/indexes/context_index.jsonl"; :> "$OUT"

normalize(){ sed '1,/^---$/d' | sed '1,/^---$/d' || true; }

for f in $(find "$REPO/context/curated" -type f -name "*.md" | sort); do

  T=$(grep -m1 '^title:' "$f"|sed 's/^title:[ ]*//;s/"//g'); U=$(grep -m1 '^updated:' "$f"|sed 's/^updated:[ ]*//;s/"//g')

  TO=$(grep -m1 '^topic:' "$f"|sed 's/^topic:[ ]*//;s/"//g'); TG=$(grep -m1 '^tags:' "$f"|sed 's/^tags:[ ]*//;s/"//g')

  C=$(cat "$f"|normalize|awk 'BEGIN{ORS="\\n"}{gsub(/"/,"\\\"");print}')

  printf '{"path":"%s","title":"%s","topic":"%s","tags":"%s","updated":"%s","content":"%s"}\n' "$f" "$T" "$TO" "$TG" "$U" "$C" >> "$OUT"

done

for f in $(find "$REPO/scripts" -type f -name "*.sh" | sort); do

  C=$(cat "$f"|normalize|awk 'BEGIN{ORS="\\n"}{gsub(/"/,"\\\"");print}')

  printf '{"path":"%s","title":"%s","topic":"%s","tags":"%s","updated":"%s","content":"%s"}\n' "$f" "$f" "script" "shell" "" "$C" >> "$OUT"

done

echo "Index JSONL: $OUT"

