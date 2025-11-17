#!/bin/bash
# shellcheck disable=SC2044
set -euo pipefail

# Organize dotfiles into structured folders (compatível com bash 3.2)
BASE_DIR="/Users/luiz.sena88/Dotfiles"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_DIR="$BASE_DIR/_backup_$TIMESTAMP"
LOG_FILE="$BASE_DIR/organizer.log"

mkdir -p "$BACKUP_DIR"
rsync -a --exclude "$(basename "$BACKUP_DIR")" "$BASE_DIR"/ "$BACKUP_DIR"/

files_map=(
  ".zshrc:zsh"
  ".zprofile:zsh"
  "*.md:docs"
  "*.svg:docs"
  "*.pdf:docs"
  "install.sh:infra"
  "Makefile:infra"
  "*.env:secrets"
  "*credentials*:secrets"
  "*.sh:scripts"
  "*.py:scripts"
)

dirs_map=(
  "codex:ai_models"
  "cursor:ai_models"
  "notebooklm*:notebooks"
)

move_files() {
  local pattern=$1
  local target=$2
  local target_dir="$BASE_DIR/$target"

  mkdir -p "$target_dir"

  find "$BASE_DIR" -maxdepth 1 -type f -name "$pattern" ! -path "$target_dir/*" -print0 | while IFS= read -r -d '' file; do
    mv "$file" "$target_dir/"
  done
}

move_dirs() {
  local pattern=$1
  local target=$2
  local target_dir="$BASE_DIR/$target"

  mkdir -p "$target_dir"

  for dir in "$BASE_DIR"/$pattern; do
    [[ -e "$dir" ]] || continue
    [[ -d "$dir" ]] || continue
    [[ "$dir" == "$target_dir" ]] && continue
    mv "$dir" "$target_dir/"
  done
}

for rule in "${files_map[@]}"; do
  pattern=${rule%%:*}
  target=${rule##*:}
  move_files "$pattern" "$target"
done

for rule in "${dirs_map[@]}"; do
  pattern=${rule%%:*}
  target=${rule##*:}
  move_dirs "$pattern" "$target"
done

printf "Organization completed on %s\n" "$(date)" >> "$LOG_FILE"
