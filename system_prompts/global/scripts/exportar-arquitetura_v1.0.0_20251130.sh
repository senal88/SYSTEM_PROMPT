#!/bin/bash

################################################################################
# 🌳 EXPORTAR ARQUITETURA - Formato Eficiente para LLMs
# Gera visualização estruturada da arquitetura do sistema para análise por LLMs
################################################################################

set +euo pipefail 2>/dev/null || set +e
set +u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
OUTPUT_FILE="${DOTFILES_DIR}/system_prompts/global/arquitetura-estrutura.txt"

# Adicionar Homebrew ao PATH se necessário
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# FUNÇÃO: GERAR ÁRVORE COM TREE (se disponível)
# ============================================================================

generate_tree_structure() {
    local base_dir="$1"
    local max_depth="${2:-4}"

    if command -v tree &> /dev/null; then
        tree -L "$max_depth" -a -I '.git|node_modules|.venv|__pycache__|*.pyc|.DS_Store' "$base_dir" 2>/dev/null
    else
        # Fallback: usar find com formatação
        find "$base_dir" -maxdepth "$max_depth" -not -path '*/\.git/*' \
            -not -path '*/node_modules/*' \
            -not -path '*/.venv/*' \
            -not -path '*/__pycache__/*' \
            -not -name '*.pyc' \
            -not -name '.DS_Store' \
            2>/dev/null | sed "s|^$base_dir/||" | sort | \
            awk '{
                n = split($0, parts, "/")
                for (i = 1; i < n; i++) {
                    printf "  "
                }
                print parts[n]
            }'
    fi
}

# ============================================================================
# FUNÇÃO: ANÁLISE DE ESTRUTURA PARA MELHORIAS
# ============================================================================

analyze_structure() {
    local base_dir="$1"

    cat << 'ANALYSIS_EOF'

================================================================================
ANÁLISE DE ESTRUTURA E IDENTIFICAÇÃO DE MELHORIAS
================================================================================

ANALYSIS_EOF

    # Contar arquivos por tipo
    echo "=== ESTATÍSTICAS DE ARQUIVOS ==="
    echo ""

    local total_files=$(find "$base_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
    local total_dirs=$(find "$base_dir" -type d 2>/dev/null | wc -l | tr -d ' ')
    local sh_files=$(find "$base_dir" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')
    local md_files=$(find "$base_dir" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    local txt_files=$(find "$base_dir" -name "*.txt" -type f 2>/dev/null | wc -l | tr -d ' ')
    local json_files=$(find "$base_dir" -name "*.json" -type f 2>/dev/null | wc -l | tr -d ' ')
    local yaml_files=$(find "$base_dir" -name "*.yaml" -o -name "*.yml" -type f 2>/dev/null | wc -l | tr -d ' ')

    echo "Total de arquivos: $total_files"
    echo "Total de diretórios: $total_dirs"
    echo "Scripts shell (.sh): $sh_files"
    echo "Documentação Markdown (.md): $md_files"
    echo "Arquivos texto (.txt): $txt_files"
    echo "Arquivos JSON (.json): $json_files"
    echo "Arquivos YAML (.yaml/.yml): $yaml_files"
    echo ""

    # Identificar padrões e melhorias
    echo "=== IDENTIFICAÇÃO DE PADRÕES ==="
    echo ""

    # Verificar scripts sem permissão de execução
    local scripts_no_exec=$(find "$base_dir" -name "*.sh" -type f ! -executable 2>/dev/null | wc -l | tr -d ' ')
    if [ "$scripts_no_exec" -gt 0 ]; then
        echo "⚠️  Scripts sem permissão de execução: $scripts_no_exec"
        find "$base_dir" -name "*.sh" -type f ! -executable 2>/dev/null | head -5
        echo ""
    fi

    # Verificar arquivos grandes (>100KB)
    echo "=== ARQUIVOS GRANDES (>100KB) ==="
    find "$base_dir" -type f -size +100k 2>/dev/null | while read file; do
        size=$(du -h "$file" | awk '{print $1}')
        echo "  $file ($size)"
    done | head -10
    echo ""

    # Verificar duplicatas potenciais
    echo "=== POSSÍVEIS DUPLICATAS (mesmo nome, locais diferentes) ==="
    find "$base_dir" -type f -name "*.sh" 2>/dev/null | \
        awk -F'/' '{print $NF, $0}' | \
        sort | uniq -f1 -d | \
        awk '{print "  " $2}' | head -10
    echo ""

    # Verificar estrutura de diretórios
    echo "=== PROFUNDIDADE MÁXIMA DE DIRETÓRIOS ==="
    find "$base_dir" -type d 2>/dev/null | \
        awk -F'/' '{print NF-1}' | \
        sort -rn | head -1 | \
        awk '{print "  Profundidade máxima: " $1 " níveis"}'
    echo ""
}

# ============================================================================
# FUNÇÃO: GERAR DOCUMENTAÇÃO DE ARQUITETURA
# ============================================================================

generate_architecture_doc() {
    local temp_file=$(mktemp)
    local timestamp=$(date +"%d/%m/%Y %H:%M:%S")

    cat > "$temp_file" << 'ARCH_EOF'
================================================================================
ARQUITETURA DO SISTEMA - ESTRUTURA COMPLETA
================================================================================

Versão: 1.0.0
Data de Geração: TIMESTAMP_PLACEHOLDER
Formato: Otimizado para interpretação por LLMs e identificação de melhorias

================================================================================
ÍNDICE
================================================================================

1. ESTRUTURA PRINCIPAL DO DOTFILES
2. SYSTEM PROMPTS GLOBAIS
3. SCRIPTS DE AUTOMAÇÃO
4. AUDITORIAS E COLETAS
5. ANÁLISE DE ESTRUTURA
6. IDENTIFICAÇÃO DE MELHORIAS
7. RECOMENDAÇÕES

================================================================================
1. ESTRUTURA PRINCIPAL DO DOTFILES
================================================================================

ARCH_EOF

    # Adicionar árvore do Dotfiles
    echo "=== DOTFILES ROOT ===" >> "$temp_file"
    echo "" >> "$temp_file"
    generate_tree_structure "$DOTFILES_DIR" 3 >> "$temp_file" 2>/dev/null
    echo "" >> "$temp_file"

    # Adicionar estrutura específica de system_prompts
    echo "=== SYSTEM PROMPTS GLOBAIS ===" >> "$temp_file"
    echo "" >> "$temp_file"
    generate_tree_structure "${DOTFILES_DIR}/system_prompts/global" 4 >> "$temp_file" 2>/dev/null
    echo "" >> "$temp_file"

    # Adicionar análise
    analyze_structure "${DOTFILES_DIR}/system_prompts/global" >> "$temp_file"

    # Adicionar seção de melhorias
    cat >> "$temp_file" << 'IMPROVEMENTS_EOF'

================================================================================
6. IDENTIFICAÇÃO DE MELHORIAS
================================================================================

=== MELHORIAS SUGERIDAS ===

1. ORGANIZAÇÃO E ESTRUTURA
   - Verificar profundidade excessiva de diretórios
   - Consolidar arquivos relacionados
   - Padronizar nomenclatura de arquivos

2. DOCUMENTAÇÃO
   - Garantir README.md em cada diretório principal
   - Adicionar comentários em scripts complexos
   - Documentar dependências e pré-requisitos

3. PERFORMANCE
   - Identificar arquivos grandes para otimização
   - Verificar scripts que podem ser paralelizados
   - Otimizar buscas e coletas

4. MANUTENIBILIDADE
   - Remover duplicatas identificadas
   - Padronizar formatos de arquivo
   - Criar testes para scripts críticos

5. SEGURANÇA
   - Verificar permissões de arquivos sensíveis
   - Validar inputs de scripts
   - Revisar exposição de informações sensíveis

================================================================================
7. RECOMENDAÇÕES
================================================================================

=== PRÓXIMOS PASSOS ===

1. Revisar estrutura de diretórios para reduzir complexidade
2. Consolidar scripts similares ou duplicados
3. Adicionar documentação faltante
4. Implementar testes automatizados
5. Criar pipeline de validação contínua
6. Otimizar arquivos grandes identificados
7. Padronizar permissões de execução

=== FERRAMENTAS RECOMENDADAS ===

- tree: Visualização de estrutura (instalar: brew install tree)
- shellcheck: Validação de scripts shell
- markdownlint: Validação de Markdown
- pre-commit: Hooks de validação antes de commits

================================================================================

Última Atualização: TIMESTAMP_PLACEHOLDER
Versão: 1.0.0
Fonte: Análise automatizada da estrutura do sistema

IMPROVEMENTS_EOF

    # Substituir timestamp
    perl -i -pe "s|TIMESTAMP_PLACEHOLDER|${timestamp}|g" "$temp_file"

    # Mover para destino final
    mv "$temp_file" "$OUTPUT_FILE"

    log_success "Arquivo gerado: $OUTPUT_FILE"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🌳 EXPORTAÇÃO DE ARQUITETURA"

    # Verificar se tree está disponível
    if ! command -v tree &> /dev/null; then
        log_warning "Comando 'tree' não encontrado. Usando fallback com 'find'."
        log_info "Para melhor visualização, instale: brew install tree"
    else
        log_success "Comando 'tree' disponível"
    fi

    generate_architecture_doc

    # Estatísticas
    local line_count=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')
    local file_size=$(du -h "$OUTPUT_FILE" | awk '{print $1}')

    echo ""
    log_info "Estatísticas do arquivo:"
    echo "  - Linhas: $line_count"
    echo "  - Tamanho: $file_size"
    echo ""

    print_header "✅ EXPORTAÇÃO CONCLUÍDA"
    echo "📁 Arquivo gerado: $OUTPUT_FILE"
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar o arquivo: $OUTPUT_FILE"
    echo "  2. Analisar melhorias sugeridas"
    echo "  3. Implementar recomendações prioritárias"
}

main "$@"

