#!/usr/bin/env bash

################################################################################
# COMANDOS FINAIS EXECUTÁVEIS - NORMALIZADO
# Documento único contendo apenas comandos CLI finais, prontos para execução
# Sem comentários, sem perguntas, sem trechos descritivos
################################################################################

set -euo pipefail

# ============================================================================
# 1) CRIAR ESTRUTURA COMPLETA DO REPOSITÓRIO SYSTEM_PROMPTS
# ============================================================================

mkdir -p SYSTEM_PROMPTS/{00_MASTER,prompts/{cursor,raycast,chatgpt,claude,gemini,mcp},scripts,llm_context/{consolidated,raw_snapshots},policies}

touch SYSTEM_PROMPTS/00_MASTER/{SYSTEM_PROMPT_V3.md,CHANGELOG.md,SYSTEM_PROMPT_ADAPTIVE.md}

touch SYSTEM_PROMPTS/policies/{security_iCloud_rules.md,ssh_key_rules_prod.md,release_immutability_policy.md}

touch SYSTEM_PROMPTS/README.md

# ============================================================================
# 2) CRIAR ÁREA TEMPORÁRIA DE DESENVOLVIMENTO DE PROMPTS
# ============================================================================

mkdir -p SYSTEM_PROMPTS/prompts_temp/{stage_00_coleta,stage_01_interpretacao,stage_02_estrutura,stage_03_refinamento,stage_04_pre_release}

touch SYSTEM_PROMPTS/prompts_temp/checklist_rastreavel.md

touch SYSTEM_PROMPTS/prompts_temp/_progress.log

# ============================================================================
# 3) CRIAR SCRIPT DE AUDITORIA COMPLETA MODULAR DO macOS
# ============================================================================

cat <<'EOF' > SYSTEM_PROMPTS/scripts/audit_macos.sh
#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${SYSTEM_PROMPTS_ROOT:-$(pwd)}"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
SNAP_DIR="${ROOT_DIR}/llm_context/raw_snapshots/${TIMESTAMP}"

mkdir -p "${SNAP_DIR}"

IGNORE_ARGS=(-name ".git" -prune -o -name ".hg" -prune -o -name ".svn" -prune -o -name "node_modules" -prune -o \
-name ".venv" -prune -o -name "__pycache__" -prune -o -name ".mypy_cache" -prune -o -name "dist" -prune -o \
-name "build" -prune -o -name ".DS_Store" -prune -o -name "*.log" -prune -o -name ".Trash" -prune -o \
-name ".Spotlight-V100" -prune -o)

scan_dir(){
    label="$1"
    dir="$2"
    out="${SNAP_DIR}/${label}.txt"
    [ -d "$dir" ] || return
    {
        echo "### $label — $dir — $TIMESTAMP"
        du -hd 2 "$dir" 2>/dev/null | sort -h
        find "$dir" \( "${IGNORE_ARGS[@]}" \) -o -maxdepth 5 -print 2>/dev/null | sed "s#$HOME#~#g" | sort
    } > "$out"
}

echo "[HOME_OVERVIEW]" > "${SNAP_DIR}/HOME_OVERVIEW.txt"
du -hd 1 "$HOME" 2>/dev/null | sort -h | sed "s#$HOME#~#g" >> "${SNAP_DIR}/HOME_OVERVIEW.txt"

scan_dir "DOTFILES" "$HOME/Dotfiles"
scan_dir "PROJETOS_BACKUP_2025" "$HOME/Projetos_backup_20251028_053549"
scan_dir "CLOUD_ICLOUD" "$HOME/Library/Mobile Documents/com~apple~CloudDocs"

for d in $HOME/Library/CloudStorage/OneDrive*; do
    [ -d "$d" ] && scan_dir "CLOUD_ONEDRIVE_$(basename "$d")" "$d"
done

for d in $HOME/Library/CloudStorage/GoogleDrive*; do
    [ -d "$d" ] && scan_dir "CLOUD_GOOGLEDRIVE_$(basename "$d")" "$d"
done

scan_dir "APPS_SYSTEM" "/Applications"
scan_dir "APPS_USER" "$HOME/Applications"
scan_dir "CONFIG_DOTCONFIG" "$HOME/.config"
scan_dir "CONFIG_APP_SUPPORT" "$HOME/Library/Application Support"

echo "[OK] Snapshots: $SNAP_DIR"
EOF

chmod +x SYSTEM_PROMPTS/scripts/audit_macos.sh

# ============================================================================
# 4) EXECUTAR AUDITORIA (QUANDO PRONTO)
# ============================================================================

# ./SYSTEM_PROMPTS/scripts/audit_macos.sh

