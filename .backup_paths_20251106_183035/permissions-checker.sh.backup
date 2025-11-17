#!/bin/bash
# permissions-checker.sh - Verificação completa de permissões

set -euo pipefail

# Configurações
TARGET_DIR="/Users/luiz.sena88"
OUTPUT_FILE="permissions-report-$(date +%Y%m%d-%H%M%S).txt"
LOG_FILE="permissions-check.log"
MAX_DEPTH=10  # Limitar profundidade para evitar loops infinitos

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Contadores globais
TOTAL_DIRS=0
TOTAL_FILES=0
READ_SUCCESS=0
WRITE_SUCCESS=0
EXEC_SUCCESS=0
READ_FAIL=0
WRITE_FAIL=0
EXEC_FAIL=0
ERRORS=0

# Função de logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    ((ERRORS++))
}

# Função para verificar se o diretório existe
check_directory_exists() {
    if [ ! -d "$TARGET_DIR" ]; then
        log_error "Diretório não encontrado: $TARGET_DIR"
        exit 1
    fi
    
    if [ ! -r "$TARGET_DIR" ]; then
        log_error "Sem permissão de leitura no diretório raiz: $TARGET_DIR"
        exit 1
    fi
    
    log_success "Diretório encontrado e acessível: $TARGET_DIR"
}

# Função para converter permissões octais em texto legível
octal_to_text() {
    local octal=$1
    local text=""
    
    case $octal in
        0) text="---" ;;
        1) text="--x" ;;
        2) text="-w-" ;;
        3) text="-wx" ;;
        4) text="r--" ;;
        5) text="r-x" ;;
        6) text="rw-" ;;
        7) text="rwx" ;;
        *) text="???" ;;
    esac
    
    echo "$text"
}

# Função para obter permissões detalhadas
get_detailed_permissions() {
    local file_path="$1"
    local stat_output
    
    if stat_output=$(stat -f "%p %u %g %N" "$file_path" 2>/dev/null); then
        local perms=$(echo "$stat_output" | cut -d' ' -f1)
        local owner_uid=$(echo "$stat_output" | cut -d' ' -f2)
        local group_gid=$(echo "$stat_output" | cut -d' ' -f3)
        
        # Extrair permissões octais
        local octal_perms=${perms: -3}
        local owner_perm=${octal_perms:0:1}
        local group_perm=${octal_perms:1:1}
        local other_perm=${octal_perms:2:1}
        
        # Converter para texto
        local owner_text=$(octal_to_text "$owner_perm")
        local group_text=$(octal_to_text "$group_perm")
        local other_text=$(octal_to_text "$other_perm")
        
        # Obter nomes de usuário e grupo
        local owner_name=$(id -nu "$owner_uid" 2>/dev/null || echo "UID:$owner_uid")
        local group_name=$(id -ng "$group_gid" 2>/dev/null || echo "GID:$group_gid")
        
        echo "$owner_text$group_text$other_text $owner_name:$group_name $octal_perms"
    else
        echo "??? ???:??? ???"
    fi
}

# Função para testar permissões específicas
test_permissions() {
    local file_path="$1"
    local file_type="$2"  # "file" ou "directory"
    local read_test="❌"
    local write_test="❌"
    local exec_test="❌"
    
    # Teste de leitura
    if [ -r "$file_path" ]; then
        read_test="✅"
        ((READ_SUCCESS++))
    else
        ((READ_FAIL++))
    fi
    
    # Teste de escrita
    if [ -w "$file_path" ]; then
        write_test="✅"
        ((WRITE_SUCCESS++))
    else
        ((WRITE_FAIL++))
    fi
    
    # Teste de execução
    if [ "$file_type" = "directory" ]; then
        # Para diretórios, testar se podemos entrar
        if [ -x "$file_path" ]; then
            exec_test="✅"
            ((EXEC_SUCCESS++))
        else
            ((EXEC_FAIL++))
        fi
    else
        # Para arquivos, testar se é executável
        if [ -x "$file_path" ]; then
            exec_test="✅"
            ((EXEC_SUCCESS++))
        else
            ((EXEC_FAIL++))
        fi
    fi
    
    echo "$read_test $write_test $exec_test"
}

# Função para formatar tamanho de arquivo
format_size() {
    local size=$1
    
    if [ "$size" -lt 1024 ]; then
        echo "${size}B"
    elif [ "$size" -lt 1048576 ]; then
        echo "$((size / 1024))KB"
    elif [ "$size" -lt 1073741824 ]; then
        echo "$((size / 1048576))MB"
    else
        echo "$((size / 1073741824))GB"
    fi
}

# Função para processar um item (arquivo ou diretório)
process_item() {
    local item_path="$1"
    local depth="$2"
    local relative_path="${item_path#$TARGET_DIR}"
    
    # Limitar profundidade
    if [ "$depth" -gt "$MAX_DEPTH" ]; then
        log_warning "Profundidade máxima atingida: $item_path"
        return
    fi
    
    # Verificar se o item existe e é acessível
    if [ ! -e "$item_path" ]; then
        log_error "Item não existe: $item_path"
        return
    fi
    
    # Obter informações do arquivo
    local file_info
    if ! file_info=$(ls -la "$item_path" 2>/dev/null); then
        log_error "Erro ao obter informações: $item_path"
        return
    fi
    
    # Determinar tipo do arquivo
    local file_type=""
    local type_icon=""
    local size_info=""
    
    if [ -d "$item_path" ]; then
        file_type="directory"
        type_icon="📁"
        ((TOTAL_DIRS++))
        
        # Contar itens no diretório
        local item_count=0
        if [ -r "$item_path" ]; then
            item_count=$(find "$item_path" -maxdepth 1 -not -path "$item_path" 2>/dev/null | wc -l | tr -d ' ')
        fi
        size_info="($item_count items)"
    else
        file_type="file"
        type_icon="📄"
        ((TOTAL_FILES++))
        
        # Obter tamanho do arquivo
        local file_size
        if file_size=$(stat -f "%z" "$item_path" 2>/dev/null); then
            size_info="($(format_size "$file_size"))"
        else
            size_info="(? bytes)"
        fi
        
        # Identificar tipos especiais de arquivo
        if [ -x "$item_path" ]; then
            type_icon="⚡"  # Executável
        elif [[ "$item_path" == *.txt ]] || [[ "$item_path" == *.md ]]; then
            type_icon="📝"  # Texto
        elif [[ "$item_path" == *.jpg ]] || [[ "$item_path" == *.png ]] || [[ "$item_path" == *.gif ]]; then
            type_icon="🖼️"   # Imagem
        elif [[ "$item_path" == *.pdf ]]; then
            type_icon="📕"  # PDF
        elif [[ "$item_path" == *.zip ]] || [[ "$item_path" == *.tar ]] || [[ "$item_path" == *.gz ]]; then
            type_icon="📦"  # Arquivo compactado
        fi
    fi
    
    # Obter permissões detalhadas
    local detailed_perms=$(get_detailed_permissions "$item_path")
    
    # Testar permissões
    local perm_tests=$(test_permissions "$item_path" "$file_type")
    
    # Obter data de modificação
    local mod_date
    if mod_date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$item_path" 2>/dev/null); then
        mod_date="$mod_date"
    else
        mod_date="Unknown"
    fi
    
    # Criar indentação baseada na profundidade
    local indent=""
    for ((i=0; i<depth; i++)); do
        indent+="  "
    done
    
    # Formatar saída
    local output_line=$(printf "%s%s %s %s %s | R W X: %s | %s | %s" \
        "$indent" \
        "$type_icon" \
        "$(basename "$item_path")" \
        "$size_info" \
        "$detailed_perms" \
        "$perm_tests" \
        "$mod_date" \
        "$relative_path")
    
    echo "$output_line" | tee -a "$OUTPUT_FILE"
}

# Função para processar diretório recursivamente
process_directory_recursive() {
    local dir_path="$1"
    local depth="$2"
    
    # Processar o próprio diretório
    process_item "$dir_path" "$depth"
    
    # Verificar se podemos ler o diretório
    if [ ! -r "$dir_path" ]; then
        log_warning "Sem permissão de leitura: $dir_path"
        return
    fi
    
    # Processar conteúdo do diretório
    local items=()
    while IFS= read -r -d '' item; do
        items+=("$item")
    done < <(find "$dir_path" -maxdepth 1 -not -path "$dir_path" -print0 2>/dev/null | sort -z)
    
    # Processar cada item
    for item in "${items[@]}"; do
        if [ -d "$item" ]; then
            # Recursão para subdiretórios
            process_directory_recursive "$item" $((depth + 1))
        else
            # Processar arquivo
            process_item "$item" $((depth + 1))
        fi
    done
}

# Função para gerar relatório de resumo
generate_summary() {
    local summary_file="permissions-summary-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "🔍 RELATÓRIO DE PERMISSÕES - RESUMO"
        echo "=================================="
        echo "Data/Hora: $(date)"
        echo "Diretório analisado: $TARGET_DIR"
        echo "Usuário: $(whoami)"
        echo ""
        
        echo "📊 ESTATÍSTICAS GERAIS:"
        echo "----------------------"
        echo "Total de diretórios: $TOTAL_DIRS"
        echo "Total de arquivos: $TOTAL_FILES"
        echo "Total de itens: $((TOTAL_DIRS + TOTAL_FILES))"
        echo "Erros encontrados: $ERRORS"
        echo ""
        
        echo "🔐 PERMISSÕES DE LEITURA:"
        echo "------------------------"
        echo "Sucessos: $READ_SUCCESS"
        echo "Falhas: $READ_FAIL"
        if [ $((READ_SUCCESS + READ_FAIL)) -gt 0 ]; then
            echo "Taxa de sucesso: $(( READ_SUCCESS * 100 / (READ_SUCCESS + READ_FAIL) ))%"
        fi
        echo ""
        
        echo "✏️  PERMISSÕES DE ESCRITA:"
        echo "-------------------------"
        echo "Sucessos: $WRITE_SUCCESS"
        echo "Falhas: $WRITE_FAIL"
        if [ $((WRITE_SUCCESS + WRITE_FAIL)) -gt 0 ]; then
            echo "Taxa de sucesso: $(( WRITE_SUCCESS * 100 / (WRITE_SUCCESS + WRITE_FAIL) ))%"
        fi
        echo ""
        
        echo "⚡ PERMISSÕES DE EXECUÇÃO:"
        echo "-------------------------"
        echo "Sucessos: $EXEC_SUCCESS"
        echo "Falhas: $EXEC_FAIL"
        if [ $((EXEC_SUCCESS + EXEC_FAIL)) -gt 0 ]; then
            echo "Taxa de sucesso: $(( EXEC_SUCCESS * 100 / (EXEC_SUCCESS + EXEC_FAIL) ))%"
        fi
        echo ""
        
        echo "📁 ARQUIVOS DE RELATÓRIO:"
        echo "------------------------"
        echo "Relatório detalhado: $OUTPUT_FILE"
        echo "Log de execução: $LOG_FILE"
        echo "Resumo: $summary_file"
        
    } | tee "$summary_file"
    
    log_success "Resumo salvo em: $summary_file"
}

# Função para exibir ajuda
show_help() {
    cat << 'EOF'
🔍 Script de Verificação de Permissões

USO:
    ./permissions-checker.sh [OPÇÕES]

OPÇÕES:
    -d, --directory DIR    Diretório a ser analisado (padrão: /Users/luiz.sena88)
    -o, --output FILE      Arquivo de saída (padrão: permissions-report-TIMESTAMP.txt)
    -m, --max-depth NUM    Profundidade máxima (padrão: 10)
    -q, --quiet           Modo silencioso (apenas erros)
    -v, --verbose         Modo verboso
    -h, --help            Mostrar esta ajuda

EXEMPLOS:
    ./permissions-checker.sh
    ./permissions-checker.sh -d /Users/outro-usuario
    ./permissions-checker.sh -o meu-relatorio.txt -m 5

LEGENDA:
    📁 Diretório    📄 Arquivo    ⚡ Executável    📝 Texto
    🖼️  Imagem       📕 PDF        📦 Compactado
    
    R W X: ✅ = Permitido, ❌ = Negado
    
    Permissões: rwx rwx rwx (proprietário grupo outros)
EOF
}

# Função principal
main() {
    local quiet_mode=false
    local verbose_mode=false
    
    # Processar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--directory)
                TARGET_DIR="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -m|--max-depth)
                MAX_DEPTH="$2"
                shift 2
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            -v|--verbose)
                verbose_mode=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Opção desconhecida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Configurar modo silencioso
    if [ "$quiet_mode" = true ]; then
        exec 1>/dev/null
    fi
    
    # Cabeçalho
    echo -e "${WHITE}🔍 VERIFICAÇÃO DE PERMISSÕES - ANÁLISE COMPLETA${NC}"
    echo -e "${WHITE}===============================================${NC}"
    echo "📅 Data/Hora: $(date)"
    echo "👤 Usuário: $(whoami)"
    echo "📁 Diretório: $TARGET_DIR"
    echo "📊 Profundidade máxima: $MAX_DEPTH"
    echo "📄 Arquivo de saída: $OUTPUT_FILE"
    echo ""
    
    # Inicializar arquivos de saída
    {
        echo "🔍 RELATÓRIO DETALHADO DE PERMISSÕES"
        echo "===================================="
        echo "Data/Hora: $(date)"
        echo "Diretório: $TARGET_DIR"
        echo "Usuário: $(whoami)"
        echo ""
        echo "LEGENDA:"
        echo "📁 = Diretório  📄 = Arquivo  ⚡ = Executável"
        echo "R W X = Leitura Escrita Execução (✅ = Permitido, ❌ = Negado)"
        echo "Formato: [Tipo] Nome (Tamanho) Permissões | R W X | Data Modificação | Caminho"
        echo ""
        echo "RESULTADOS:"
        echo "-----------"
    } > "$OUTPUT_FILE"
    
    # Verificar diretório
    check_directory_exists
    
    # Processar diretório recursivamente
    log_info "Iniciando análise recursiva..."
    process_directory_recursive "$TARGET_DIR" 0
    
    # Gerar resumo
    echo ""
    log_info "Gerando resumo..."
    generate_summary
    
    # Resultados finais
    echo ""
    echo -e "${WHITE}🎉 ANÁLISE CONCLUÍDA!${NC}"
    echo -e "${WHITE}====================${NC}"
    echo -e "${GREEN}✅ Itens processados: $((TOTAL_DIRS + TOTAL_FILES))${NC}"
    echo -e "${BLUE}📁 Diretórios: $TOTAL_DIRS${NC}"
    echo -e "${BLUE}📄 Arquivos: $TOTAL_FILES${NC}"
    
    if [ $ERRORS -gt 0 ]; then
        echo -e "${RED}❌ Erros encontrados: $ERRORS${NC}"
    else
        echo -e "${GREEN}✅ Nenhum erro encontrado${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}📋 Arquivos gerados:${NC}"
    echo -e "${CYAN}  • Relatório detalhado: $OUTPUT_FILE${NC}"
    echo -e "${CYAN}  • Log de execução: $LOG_FILE${NC}"
    echo -e "${CYAN}  • Resumo: permissions-summary-$(date +%Y%m%d-%H%M%S).txt${NC}"
    
    # Abrir relatório se possível
    if command -v open &> /dev/null; then
        echo ""
        echo -e "${YELLOW}💡 Dica: Execute 'open $OUTPUT_FILE' para visualizar o relatório${NC}"
    fi
}

# Verificar se está sendo executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
