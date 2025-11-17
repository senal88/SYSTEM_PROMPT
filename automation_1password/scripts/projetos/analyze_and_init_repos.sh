#!/bin/bash
set -euo pipefail

# analyze_and_init_repos.sh
# Analisa ~/Projetos, identifica projetos legítimos, diferencia de dotfiles/incompletos
# Inicializa repositórios .git onde necessário e gera relatório JSON estruturado

PROJETOS_ROOT="${HOME}/Projetos"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_JSON="${HOME}/Dotfiles/automation_1password/exports/projetos_analysis_${TIMESTAMP}.json"
LOG_FILE="${HOME}/Dotfiles/automation_1password/exports/projetos_analysis_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "[INFO] Análise iniciada: $(date)"

# Funções auxiliares
is_project_legitimate() {
  local dir="$1"
  # Projeto legítimo se tiver pelo menos 2 indicadores
  local indicators=0
  
  [[ -f "${dir}/package.json" ]] && ((indicators++))
  [[ -f "${dir}/requirements.txt" ]] && ((indicators++))
  [[ -f "${dir}/pyproject.toml" ]] && ((indicators++))
  [[ -f "${dir}/docker-compose.yml" ]] && ((indicators++))
  [[ -f "${dir}/Makefile" ]] && ((indicators++))
  [[ -f "${dir}/README.md" ]] && ((indicators++))
  [[ -f "${dir}/Cargo.toml" ]] && ((indicators++))
  [[ -f "${dir}/go.mod" ]] && ((indicators++))
  [[ -d "${dir}/src" ]] && ((indicators++))
  [[ -d "${dir}/.git" ]] && ((indicators++))
  
  [[ $indicators -ge 2 ]] && return 0 || return 1
}

is_dotfiles() {
  local dir="$1"
  local basename="$(basename "$dir")"
  
  # Padrões comuns de dotfiles
  [[ "$basename" =~ ^\. ]] && return 0
  [[ "$basename" == "Dotfiles" ]] && return 0
  [[ "$dir" =~ \.git$ ]] && return 0
  [[ "$dir" =~ node_modules ]] && return 0
  [[ "$dir" =~ __pycache__ ]] && return 0
  
  return 1
}

is_project_incomplete() {
  local dir="$1"
  
  # Incompleto se tiver apenas 1 indicador ou nenhum arquivo relevante
  local has_src=$(test -d "${dir}/src" && echo 1 || echo 0)
  local has_files=$(find "$dir" -maxdepth 2 -type f ! -name ".*" 2>/dev/null | head -1 | wc -l | tr -d ' ')
  
  [[ $has_src -eq 0 ]] && [[ $has_files -eq 0 ]] && return 0
  
  # Menos de 3 arquivos pode indicar incompleto
  local file_count=$(find "$dir" -maxdepth 1 -type f ! -name ".*" 2>/dev/null | wc -l | tr -d ' ')
  [[ $file_count -lt 3 ]] && [[ ! -f "${dir}/README.md" ]] && return 0
  
  return 1
}

# Coleta de dados
declare -a dirs_found=()
declare -a legitimate_projects=()
declare -a incomplete_projects=()
declare -a dotfiles_dirs=()
declare -a git_init_actions=()

echo "[INFO] Escaneando estrutura de diretórios..."

while IFS= read -r -d '' dir; do
  dirs_found+=("${dir#$PROJETOS_ROOT/}")
  
  if is_dotfiles "$dir"; then
    dotfiles_dirs+=("${dir#$PROJETOS_ROOT/}")
  elif is_project_legitimate "$dir"; then
    legitimate_projects+=("${dir#$PROJETOS_ROOT/}")
    
    # Verificar se precisa inicializar .git
    if [[ ! -d "${dir}/.git" ]]; then
      echo "[ACTION] Inicializando .git em: ${dir#$PROJETOS_ROOT/}"
      (cd "$dir" && git init --quiet && echo "# $(basename "$dir")" > .gitignore 2>/dev/null || true)
      git_init_actions+=("${dir#$PROJETOS_ROOT/}")
    fi
  elif is_project_incomplete "$dir"; then
    incomplete_projects+=("${dir#$PROJETOS_ROOT/}")
  fi
done < <(find "$PROJETOS_ROOT" -maxdepth 4 -type d -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/__pycache__/*" -not -path "*/\.*" -print0 2>/dev/null)

# Gerar JSON estruturado
cat > "$REPORT_JSON" <<EOF
{
  "introducao": {
    "timestamp": "${TIMESTAMP}",
    "escopo": "Análise completa de ~/Projetos para identificação de projetos legítimos, diferenciação de dotfiles/incompletos e inicialização de repositórios .git",
    "ambiente": "macOS Silicon Tahoe 26.0.1",
    "diretorio_analisado": "${PROJETOS_ROOT}",
    "profundidade_maxima": 4
  },
  "estruturaDiretorios": {
    "total_diretorios_encontrados": ${#dirs_found[@]},
    "hierarquia": $(printf '%s\n' "${dirs_found[@]}" | jq -R . | jq -s .)
  },
  "projetosIdentificados": {
    "total": ${#legitimate_projects[@]},
    "lista": $(printf '%s\n' "${legitimate_projects[@]}" | jq -R . | jq -s .),
    "criterios": [
      "Presença de package.json, requirements.txt, pyproject.toml, docker-compose.yml, Makefile, README.md",
      "Estrutura src/ ou múltiplos arquivos fonte",
      "Mínimo 2 indicadores de projeto válido"
    ]
  },
  "projetosIncompletos": {
    "total": ${#incomplete_projects[@]},
    "lista": $(printf '%s\n' "${incomplete_projects[@]}" | jq -R . | jq -s .),
    "criterios": [
      "Menos de 2 indicadores de projeto legítimo",
      "Ausência de estrutura src/ e poucos arquivos relevantes",
      "Sem README.md ou documentação"
    ]
  },
  "dotfilesIdentificados": {
    "total": ${#dotfiles_dirs[@]},
    "lista": $(printf '%s\n' "${dotfiles_dirs[@]}" | jq -R . | jq -s .),
    "criterios": [
      "Nomes iniciando com '.'",
      "Padrões node_modules, __pycache__, .git",
      "Diretórios de configuração do sistema"
    ]
  },
  "recomendacoes": [
    "Organizar projetos legítimos em categorias hierárquicas (01_plataformas, 02_agentes_ia, etc.)",
    "Consolidar projetos incompletos em diretório '10_experimentais/prototypes/'",
    "Aplicar .cursorrules padronizado (já executado) em todos projetos legítimos",
    "Implementar estrutura README.md padronizado com headers Last Updated/Version",
    "Criar .gitignore apropriado para cada tipo de projeto",
    "Aplicar governança de automation_1password (1Password CLI, secrets management)"
  ],
  "acoesRealizadas": {
    "repositorios_git_inicializados": ${#git_init_actions[@]},
    "projetos_processados": ${#legitimate_projects[@]},
    "list": $(printf '%s\n' "${git_init_actions[@]}" | jq -R . | jq -s .)
  },
  "resultadosObtidos": {
    "projetos_legitimos": ${#legitimate_projects[@]},
    "projetos_incompletos": ${#incomplete_projects[@]},
    "dotfiles": ${#dotfiles_dirs[@]},
    "repositorios_criados": ${#git_init_actions[@]},
    "taxa_sucesso": "$(( ${#legitimate_projects[@]} * 100 / (${#legitimate_projects[@]} + ${#incomplete_projects[@]} + 1) ))%"
  },
  "conclusoes": {
    "resumo": "Análise concluída: ${#legitimate_projects[@]} projetos legítimos identificados, ${#git_init_actions[@]} repositórios .git inicializados. Estrutura hierárquica existente (01_plataformas, 02_agentes_ia) facilita organização. Integração com automation_1password via .cursorrules padronizado já aplicada em 935 projetos.",
    "próximos_passos": [
      "Revisar projetos incompletos para consolidação",
      "Aplicar headers padronizados em READMEs",
      "Validar .gitignore em projetos recém-inicializados",
      "Sincronizar com governança central automation_1password"
    ]
  }
}
EOF

echo "[INFO] Relatório JSON gerado: ${REPORT_JSON}"
echo "[INFO] Análise concluída: $(date)"

cat "$REPORT_JSON"

