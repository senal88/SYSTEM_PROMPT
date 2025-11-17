#!/bin/bash
set -euo pipefail

# sync_cursorrules.sh
# Sincroniza e padroniza .cursorrules em todos projetos de ~/Projetos
# Baseado em diagnóstico e templates do automation_1password

PROJETOS_ROOT="${HOME}/Projetos"
AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
TEMPLATE_BASE="${AUTOMATION_ROOT}/templates/projetos/.cursorrules.template"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/exports/projetos_sync_cursorrules_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "[INFO] Sincronização de .cursorrules iniciada em $(date)"
echo "[INFO] Projetos root: ${PROJETOS_ROOT}"
echo "[INFO] Template base: ${TEMPLATE_BASE}"

if [[ ! -f "$TEMPLATE_BASE" ]]; then
  echo "[ERRO] Template não encontrado: ${TEMPLATE_BASE}"
  exit 1
fi

detect_project_type() {
  local project_dir="$1"
  
  if [[ -f "${project_dir}/package.json" ]]; then
    if grep -q '"next"' "${project_dir}/package.json" 2>/dev/null; then
      echo "frontend_nextjs"
    elif grep -q '"react"' "${project_dir}/package.json" 2>/dev/null; then
      echo "frontend_react"
    else
      echo "nodejs"
    fi
  elif [[ -f "${project_dir}/requirements.txt" ]] || [[ -f "${project_dir}/pyproject.toml" ]]; then
    if [[ -d "${project_dir}/prompts" ]] || [[ -d "${project_dir}/policies" ]]; then
      echo "agent_ai"
    else
      echo "python"
    fi
  elif [[ -f "${project_dir}/docker-compose.yml" ]]; then
    echo "platform"
  elif [[ "$(basename "$project_dir")" =~ ^(02_agentes_ia|11_.*agent) ]]; then
    echo "agent_ai"
  elif [[ "$(basename "$project_dir")" =~ ^(01_plataformas|05_aplicacoes) ]]; then
    echo "platform"
  elif [[ "$(basename "$project_dir")" =~ ^(07_frontend|frontend) ]]; then
    echo "frontend"
  elif [[ "$(basename "$project_dir")" =~ ^(04_ferramentas_dev|08_configuracao|scripts) ]]; then
    echo "tool"
  else
    echo "generic"
  fi
}

generate_context_packs() {
  local project_type="$1"
  local project_dir="$2"
  
  case "$project_type" in
    frontend_nextjs|frontend_react|frontend)
      echo "  priority_high:
    - ./src/**
    - ./components/**
    - ./pages/**
    - ./app/**
    - ./docs/**
  
  priority_medium:
    - ./tests/**
    - ./public/**
  
  exclusions:
    - ./node_modules/**
    - ./.next/**
    - ./dist/**
    - ./build/**
    - ./**/*.log
    - ./**/.env*"
      ;;
    agent_ai)
      echo "  priority_high:
    - ./prompts/**
    - ./policies/**
    - ./src/**
    - ./docs/**
    - ./scripts/**
  
  priority_medium:
    - ./examples/**
    - ./tests/**
  
  exclusions:
    - ./__pycache__/**
    - ./venv/**
    - ./**/*.pyc
    - ./**/.env*"
      ;;
    platform)
      echo "  priority_high:
    - ./src/**
    - ./api/**
    - ./backend/**
    - ./docker-compose.yml
    - ./docs/**
  
  priority_medium:
    - ./tests/**
    - ./config/**
  
  exclusions:
    - ./node_modules/**
    - ./venv/**
    - ./dist/**
    - ./build/**
    - ./**/*.log
    - ./**/.env*"
      ;;
    tool)
      echo "  priority_high:
    - ./scripts/**
    - ./config/**
    - ./docs/**
  
  priority_medium:
    - ./templates/**
  
  exclusions:
    - ./**/*.log
    - ./**/.env*"
      ;;
    *)
      echo "  priority_high:
    - ./src/**
    - ./docs/**
    - ./scripts/**
  
  priority_medium:
    - ./tests/**
  
  exclusions:
    - ./**/*.log
    - ./**/.env*"
      ;;
  esac
}

update_cursorrules() {
  local project_dir="$1"
  local project_name="$(basename "$project_dir")"
  local relative_path="${project_dir#$PROJETOS_ROOT/}"
  local project_type="$(detect_project_type "$project_dir")"
  
  local cursorrules_file="${project_dir}/.cursorrules"
  local backup_file="${project_dir}/.cursorrules.backup.${TIMESTAMP}"
  
  echo "[INFO] Processando: ${relative_path} (tipo: ${project_type})"
  
  # Backup se existe
  if [[ -f "$cursorrules_file" ]]; then
    cp "$cursorrules_file" "$backup_file"
    echo "[INFO] Backup criado: ${backup_file}"
  fi
  
  # Gerar novo .cursorrules
  {
    cat "$TEMPLATE_BASE" | \
      sed "s|\[PROJECT_NAME\]|${project_name}|g" | \
      sed "s|\[RELATIVE_PATH\]|${relative_path}|g" | \
      sed "s|\[DESCRIPTION\]|Projeto ${project_name} em ~/Projetos/${relative_path}|g" | \
      sed "s|\[STACK_SPECIFIC_RULES\]|Stack: ${project_type}|g"
    
    echo ""
    echo "## Context Packs (Project-Specific)"
    echo ""
    generate_context_packs "$project_type" "$project_dir"
  } > "$cursorrules_file"
  
  echo "[INFO] ✅ .cursorrules atualizado: ${cursorrules_file}"
}

# Processar projetos
projects_processed=0
projects_skipped=0

while IFS= read -r -d '' project_dir; do
  # Ignorar diretórios ocultos e caches
  if [[ "$(basename "$project_dir")" =~ ^\. ]]; then
    continue
  fi
  
  # Verificar se é um diretório de projeto (tem algum arquivo indicador)
  if [[ -f "${project_dir}/package.json" ]] || \
     [[ -f "${project_dir}/requirements.txt" ]] || \
     [[ -f "${project_dir}/docker-compose.yml" ]] || \
     [[ -f "${project_dir}/Makefile" ]] || \
     [[ -d "${project_dir}/src" ]] || \
     [[ -d "${project_dir}/scripts" ]]; then
    update_cursorrules "$project_dir"
    ((projects_processed++))
  else
    echo "[SKIP] Diretório ignorado (sem indicadores de projeto): $(basename "$project_dir")"
    ((projects_skipped++))
  fi
done < <(find "$PROJETOS_ROOT" \
  -maxdepth 3 \
  -type d \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -path "*/venv/*" \
  ! -path "*/.venv/*" \
  ! -path "*/__pycache__/*" \
  ! -path "*/.next/*" \
  ! -path "*/dist/*" \
  ! -path "*/build/*" \
  ! -path "*/target/*" \
  ! -name "node_modules" \
  ! -name ".git" \
  ! -name "venv" \
  ! -name ".venv" \
  ! -name "__pycache__" \
  ! -name ".next" \
  ! -name "dist" \
  ! -name "build" \
  -print0)

echo ""
echo "[INFO] Sincronização concluída:"
echo " - Projetos processados: ${projects_processed}"
echo " - Projetos ignorados: ${projects_skipped}"
echo " - Log completo: ${LOG_FILE}"
echo ""
echo "[INFO] Próximos passos:"
echo " 1. Revisar logs: ${LOG_FILE}"
echo " 2. Validar .cursorrules gerados nos projetos críticos"
echo " 3. Ajustar context packs específicos se necessário"
echo " 4. Executar 'make update.headers' em projetos com documentação"

