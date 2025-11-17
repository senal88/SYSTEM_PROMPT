#!/bin/bash
set -euo pipefail

# sync_cursorrules_optimized.sh
# Versão otimizada que processa em lotes e evita diretórios grandes
# Evita esgotar RAM ao processar 900+ projetos

PROJETOS_ROOT="${HOME}/Projetos"
AUTOMATION_ROOT="${HOME}/Dotfiles/automation_1password"
TEMPLATE_BASE="${AUTOMATION_ROOT}/templates/projetos/.cursorrules.template"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${AUTOMATION_ROOT}/exports/projetos_sync_cursorrules_${TIMESTAMP}.log"

# Configurações de lotes
BATCH_SIZE="${BATCH_SIZE:-50}"  # Processa 50 projetos por vez
MAX_DEPTH="${MAX_DEPTH:-3}"     # Profundidade máxima

exec > >(tee -a "$LOG_FILE") 2>&1

echo "[INFO] Sincronização otimizada de .cursorrules iniciada em $(date)"
echo "[INFO] Processamento em lotes de ${BATCH_SIZE} projetos"
echo "[INFO] Profundidade máxima: ${MAX_DEPTH}"
echo "[INFO] Projetos root: ${PROJETOS_ROOT}"
echo ""

if [[ ! -f "$TEMPLATE_BASE" ]]; then
  echo "[ERRO] Template não encontrado: ${TEMPLATE_BASE}"
  exit 1
fi

# Funções auxiliares (reutilizadas do script original)
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
  
  echo "[INFO] ✅ .cursorrules atualizado"
}

# Verificar se é um diretório de projeto válido
is_valid_project() {
  local project_dir="$1"
  local basename_dir="$(basename "$project_dir")"
  
  # Ignorar diretórios ocultos
  [[ "$basename_dir" =~ ^\. ]] && return 1
  
  # Ignorar diretórios conhecidos como não-projetos
  case "$basename_dir" in
    node_modules|venv|.git|__pycache__|.next|dist|build|target|.idea|.vscode|.env|env|.venv|*.log)
      return 1
      ;;
  esac
  
  # Ignorar se contém apenas diretórios proibidos no nome do caminho
  if [[ "$project_dir" =~ /(node_modules|venv|\.git|__pycache__|\.next|dist|build|target) ]]; then
    return 1
  fi
  
  # Verificar se é um projeto válido (tem indicadores)
  [[ -f "${project_dir}/package.json" ]] || \
  [[ -f "${project_dir}/requirements.txt" ]] || \
  [[ -f "${project_dir}/pyproject.toml" ]] || \
  [[ -f "${project_dir}/docker-compose.yml" ]] || \
  [[ -f "${project_dir}/Makefile" ]] || \
  [[ -d "${project_dir}/src" ]] || \
  [[ -d "${project_dir}/scripts" ]] || \
  [[ "$(dirname "$project_dir")" == "$PROJETOS_ROOT" ]]
}

# Coletar projetos válidos (com exclusões)
echo "[INFO] Coletando lista de projetos válidos..."
PROJECTS_LIST=$(mktemp)
trap "rm -f '$PROJECTS_LIST'" EXIT

find "$PROJETOS_ROOT" \
  -maxdepth "$MAX_DEPTH" \
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
  -print0 | while IFS= read -r -d '' project_dir; do
  if is_valid_project "$project_dir"; then
    echo -n "$project_dir" >> "$PROJECTS_LIST"
    echo -ne '\0' >> "$PROJECTS_LIST"
  fi
done

TOTAL_PROJECTS=$(tr '\0' '\n' < "$PROJECTS_LIST" | wc -l | xargs)
echo "[INFO] Total de projetos encontrados: ${TOTAL_PROJECTS}"
echo ""

# Processar em lotes
projects_processed=0
projects_skipped=0
batch_num=1

tr '\0' '\n' < "$PROJECTS_LIST" | while IFS= read -r project_dir; do
  [[ -z "$project_dir" ]] && continue
  
  # Pausa entre lotes para liberar memória
  if (( projects_processed > 0 && projects_processed % BATCH_SIZE == 0 )); then
    echo ""
    echo "[INFO] Lote ${batch_num} concluído (${BATCH_SIZE} projetos)"
    echo "[INFO] Pausando 2 segundos para liberar memória..."
    sleep 2
    
    # Mostrar uso de memória
    if command -v vm_stat &>/dev/null; then
      free_pages=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
      echo "[INFO] Páginas livres: ${free_pages}"
    fi
    
    ((batch_num++))
  fi
  
  if is_valid_project "$project_dir"; then
    update_cursorrules "$project_dir"
    ((projects_processed++))
  else
    ((projects_skipped++))
  fi
done

echo ""
echo "[INFO] Sincronização concluída:"
echo " - Projetos processados: ${projects_processed}"
echo " - Projetos ignorados: ${projects_skipped}"
echo " - Lotes processados: ${batch_num}"
echo " - Log completo: ${LOG_FILE}"

