#!/bin/bash
set -euo pipefail

# deploy_presets.sh
# Deploy presets do automation_1password para LM Studio

AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
SOURCE_PRESETS="${AUTOMATION_ROOT}/prompts/lmstudio/presets"
LM_STUDIO_HUB="${HOME}/.lmstudio/hub/presets/automation-1password"

mkdir -p "$LM_STUDIO_HUB"

log() {
  echo "📦 $1"
}

log "Deployando presets para LM Studio..."

# Deploy cada preset
for preset_dir in "${SOURCE_PRESETS}"/*/; do
  [[ -d "$preset_dir" ]] || continue
  
  preset_name=$(basename "$preset_dir")
  
  if [[ -f "${preset_dir}preset.json" ]] && [[ -f "${preset_dir}manifest.json" ]]; then
    log "Deployando: ${preset_name}"
    
    target_dir="${LM_STUDIO_HUB}/${preset_name}"
    mkdir -p "$target_dir"
    
    cp "${preset_dir}preset.json" "${target_dir}/preset.json"
    cp "${preset_dir}manifest.json" "${target_dir}/manifest.json"
    
    echo "  ✅ ${preset_name}"
  fi
done

log "✅ Deploy concluído! Recarregue o LM Studio para ver os novos presets."

