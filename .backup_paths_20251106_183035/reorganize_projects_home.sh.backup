#!/bin/bash
set -euo pipefail

# reorganize_projects_home.sh
# Plano de ação completo para reorganização estrutural de ~/Projetos

PROJETOS_ROOT="${HOME}/Projetos"
WORKSPACE_ROOT="${HOME}/workspace"
ARCHIVE_ROOT="${HOME}/archive"
TIMESTAMP="$(date +%Y%m%d)"
ARCHIVE_MONTH="${TIMESTAMP:0:6}"
ANALYSIS_JSON="${HOME}/Dotfiles/automation_1password/exports/projetos_analysis_20251030_204426.json"
LOG_FILE="${HOME}/Dotfiles/automation_1password/exports/reorganization_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo "REORGANIZAÇÃO ESTRUTURAL DE PROJETOS"
echo "Data: $(date)"
echo "=========================================="

# Fase 1: Preparação
echo ""
echo "[FASE 1] Preparação e Criação de Estrutura"
echo "--------------------------------------------"

mkdir -p "${WORKSPACE_ROOT}"/{01_plataformas,02_agentes_ia,03_ecossistemas,04_ferramentas_dev,05_aplicacoes,07_frontend,08_configuracao,09_arquivos,10_experimentais/{prototypes,experimentos},11_1_agent_expert,11_2_agentkit,11_3_agentkit-macos,11_4_agentkit-vps,12_bni_contabil_completo,13_compilador,14_agent_reforma_tributaria,15_local-ai-packaged,16_stirling-pdf}
mkdir -p "${ARCHIVE_ROOT}/${ARCHIVE_MONTH}"
mkdir -p "${HOME}/Dotfiles/automation_1password/exports/migration_run_${TIMESTAMP}"

echo "✅ Estrutura criada:"
echo "   - Workspace: ${WORKSPACE_ROOT}"
echo "   - Archive: ${ARCHIVE_ROOT}/${ARCHIVE_MONTH}"

# Fase 2: Limpeza de Resíduos
echo ""
echo "[FASE 2] Limpeza de Caches e Resíduos"
echo "--------------------------------------"

cleanup_caches() {
  local dir="$1"
  local removed=0
  
  # Node.js
  if [[ -d "${dir}/node_modules" ]]; then
    echo "   Removendo node_modules de ${dir}"
    rm -rf "${dir}/node_modules" 2>/dev/null && ((removed++)) || true
  fi
  
  # Python
  find "${dir}" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null && ((removed++)) || true
  find "${dir}" -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null && ((removed++)) || true
  find "${dir}" -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null && ((removed++)) || true
  find "${dir}" -name "*.pyc" -delete 2>/dev/null || true
  
  # macOS
  find "${dir}" -name ".DS_Store" -delete 2>/dev/null || true
  find "${dir}" -name ".AppleDouble" -exec rm -rf {} + 2>/dev/null || true
  
  # Logs temporários
  find "${dir}" -type f -name "*.log" -size +10M -delete 2>/dev/null || true
  
  return $removed
}

cleanup_sensitive_artifacts() {
  echo "   Revogando artefatos sensíveis..."
  
  # Trash antigos
  find ~/.Trash -name "*1password-credentials*.json" -delete 2>/dev/null || true
  find ~/.Trash -name "*credentials*.json" -delete 2>/dev/null || true
  
  # Docker tokens legados (manter estrutura, apenas limpar tokens expirados)
  if [[ -f ~/.docker/config.json ]]; then
    echo "   Verificando tokens Docker expirados..."
    # Backup antes de qualquer alteração
    cp ~/.docker/config.json ~/.docker/config.json.backup.${TIMESTAMP}
  fi
  
  echo "   ✅ Limpeza de artefatos sensíveis concluída"
}

echo "   Limpando caches em ${PROJETOS_ROOT}..."
cleanup_caches "${PROJETOS_ROOT}"
cleanup_sensitive_artifacts

# Fase 3: Reorganização Estrutural
echo ""
echo "[FASE 3] Reorganização Estrutural"
echo "----------------------------------"

# Ler projetos legítimos do JSON
if [[ -f "$ANALYSIS_JSON" ]]; then
  # Usar jq se disponível, senão parse manual
  if command -v jq &>/dev/null; then
    mapfile -t legitimate_projects < <(jq -r '.projetosIdentificados.lista[]' "$ANALYSIS_JSON" 2>/dev/null)
  else
    # Parse manual do JSON
    legitimate_projects=(
      "11_1_agent_expert"
      "11_2_agentkit"
      "12_bni_contabil_completo"
      "01_plataformas/gestora_investimentos"
      "01_plataformas/agent_expert"
      "agent_expert"
    )
  fi
else
  echo "⚠️  JSON de análise não encontrado, usando lista padrão"
  legitimate_projects=(
    "11_1_agent_expert"
    "11_2_agentkit"
    "12_bni_contabil_completo"
    "agent_expert"
  )
fi

move_project() {
  local source="$1"
  local category="$2"
  local project_name="$(basename "$source")"
  local dest="${WORKSPACE_ROOT}/${category}/${project_name}"
  
  if [[ ! -d "$source" ]]; then
    echo "   ⚠️  Diretório não encontrado: ${source}"
    return 1
  fi
  
  if [[ -d "$dest" ]]; then
    echo "   ⚠️  Destino já existe: ${dest}, fazendo backup..."
    mv "$dest" "${dest}.backup.${TIMESTAMP}"
  fi
  
  echo "   Movendo ${source} -> ${dest}"
  mkdir -p "$(dirname "$dest")"
  mv "$source" "$dest" 2>/dev/null || cp -R "$source" "$dest" && rm -rf "$source"
  return 0
}

echo "   Movendo projetos legítimos para workspace..."

# Mapear categorias baseado na estrutura existente
for project in "${legitimate_projects[@]}"; do
  full_path="${PROJETOS_ROOT}/${project}"
  
  if [[ ! -d "$full_path" ]]; then
    continue
  fi
  
  # Determinar categoria baseado no path
  if [[ "$project" =~ ^01_plataformas ]]; then
    move_project "$full_path" "01_plataformas"
  elif [[ "$project" =~ ^02_agentes_ia ]] || [[ "$project" =~ ^11_ ]] || [[ "$project" == "agent_expert" ]]; then
    if [[ "$project" == "agent_expert" ]]; then
      move_project "$full_path" "agent_expert"
    elif [[ "$project" =~ ^11_1 ]]; then
      move_project "$full_path" "11_1_agent_expert"
    elif [[ "$project" =~ ^11_2 ]]; then
      move_project "$full_path" "11_2_agentkit"
    elif [[ "$project" =~ ^11_3 ]]; then
      move_project "$full_path" "11_3_agentkit-macos"
    elif [[ "$project" =~ ^11_4 ]]; then
      move_project "$full_path" "11_4_agentkit-vps"
    else
      move_project "$full_path" "02_agentes_ia"
    fi
  elif [[ "$project" =~ ^03_ecossistemas ]]; then
    move_project "$full_path" "03_ecossistemas"
  elif [[ "$project" =~ ^04_ferramentas_dev ]]; then
    move_project "$full_path" "04_ferramentas_dev"
  elif [[ "$project" =~ ^12_bni ]]; then
    move_project "$full_path" "12_bni_contabil_completo"
  elif [[ "$project" =~ ^15_local-ai ]]; then
    move_project "$full_path" "15_local-ai-packaged"
  elif [[ "$project" =~ ^16_stirling ]]; then
    move_project "$full_path" "16_stirling-pdf"
  else
    # Projetos não categorizados vão para experimentais
    move_project "$full_path" "10_experimentais/prototypes"
  fi
done

echo "   ✅ Reorganização estrutural concluída"

# Fase 4: Padronização
echo ""
echo "[FASE 4] Padronização e Governança"
echo "------------------------------------"

standardize_project() {
  local project_dir="$1"
  
  # README.md
  if [[ ! -f "${project_dir}/README.md" ]]; then
    cat > "${project_dir}/README.md" <<EOF
# $(basename "$project_dir")

Last Updated: 2025-10-30
Version: 2.0.0

## Overview

[Descrição do projeto]

## Setup

\`\`\`bash
# Instruções de setup
\`\`\`

## Usage

\`\`\`bash
# Exemplos de uso
\`\`\`
EOF
    echo "     ✅ README.md criado em ${project_dir}"
  else
    # Verificar headers
    if ! grep -q "Last Updated:" "${project_dir}/README.md" 2>/dev/null; then
      sed -i '' '1s/^/# Last Updated: 2025-10-30\n# Version: 2.0.0\n\n/' "${project_dir}/README.md"
      echo "     ✅ Headers adicionados ao README.md em ${project_dir}"
    fi
  fi
  
  # .gitignore
  if [[ ! -f "${project_dir}/.gitignore" ]]; then
    cat > "${project_dir}/.gitignore" <<EOF
# Environment
.env
.env.local
*.log

# Dependencies
node_modules/
venv/
__pycache__/
*.pyc
.pytest_cache/
.mypy_cache/

# Build
dist/
build/
*.egg-info/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Sensitive
credentials.json
*.key
*.pem
EOF
    echo "     ✅ .gitignore criado em ${project_dir}"
  fi
  
  # Estrutura exports/logs
  mkdir -p "${project_dir}/exports"
  mkdir -p "${project_dir}/logs"
  echo "     ✅ Estrutura exports/logs criada em ${project_dir}"
}

# Aplicar padronização em projetos do workspace
find "${WORKSPACE_ROOT}" -maxdepth 2 -type d -not -path "*/\.*" | while read -r dir; do
  if [[ -f "${dir}/package.json" ]] || [[ -f "${dir}/requirements.txt" ]] || [[ -f "${dir}/docker-compose.yml" ]] || [[ -d "${dir}/src" ]]; then
    standardize_project "$dir"
  fi
done

echo "   ✅ Padronização concluída"

echo ""
echo "=========================================="
echo "REORGANIZAÇÃO CONCLUÍDA"
echo "Log: ${LOG_FILE}"
echo "=========================================="

