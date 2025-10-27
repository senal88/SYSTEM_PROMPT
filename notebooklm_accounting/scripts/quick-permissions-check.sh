#!/bin/bash
# quick-permissions-check.sh - Verificação rápida de permissões

set -euo pipefail

# Configurações
TARGET_DIR="/Users/luiz.sena88"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Função para formatar tamanho
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

# Função para verificar permissões básicas
check_basic_permissions() {
    echo -e "${WHITE}🔍 Verificação Rápida de Permissões${NC}"
    echo -e "${WHITE}===================================${NC}"
    echo "📁 Diretório: $TARGET_DIR"
    echo "👤 Usuário: $(whoami)"
    echo "📅 Data: $(date)"
    echo ""
    
    # Verificar se o diretório existe
    if [ ! -d "$TARGET_DIR" ]; then
        echo -e "${RED}❌ Diretório não encontrado: $TARGET_DIR${NC}"
        exit 1
    fi
    
    # Verificar permissões básicas
    echo -e "${CYAN}🔐 Permissões Básicas:${NC}"
    echo "-------------------"
    
    if [ -r "$TARGET_DIR" ]; then
        echo -e "${GREEN}✅ Leitura: OK${NC}"
    else
        echo -e "${RED}❌ Leitura: FALHA${NC}"
    fi
    
    if [ -w "$TARGET_DIR" ]; then
        echo -e "${GREEN}✅ Escrita: OK${NC}"
    else
        echo -e "${RED}❌ Escrita: FALHA${NC}"
    fi
    
    if [ -x "$TARGET_DIR" ]; then
        echo -e "${GREEN}✅ Execução: OK${NC}"
    else
        echo -e "${RED}❌ Execução: FALHA${NC}"
    fi
    
    echo ""
}

# Função para estatísticas rápidas
get_quick_stats() {
    echo -e "${CYAN}📊 Estatísticas Rápidas:${NC}"
    echo "----------------------"
    
    # Contar diretórios
    local dir_count=$(find "$TARGET_DIR" -type d 2>/dev/null | wc -l | tr -d ' ')
    echo "📁 Diretórios: $dir_count"
    
    # Contar arquivos
    local file_count=$(find "$TARGET_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "📄 Arquivos: $file_count"
    
    # Contar links simbólicos
    local link_count=$(find "$TARGET_DIR" -type l 2>/dev/null | wc -l | tr -d ' ')
    echo "🔗 Links: $link_count"
    
    # Calcular tamanho total
    local total_size=$(du -sk "$TARGET_DIR" 2>/dev/null | cut -f1)
    if [ -n "$total_size" ]; then
        echo "💾 Tamanho total: $(format_size $((total_size * 1024)))"
    else
        echo "💾 Tamanho total: Não disponível"
    fi
    
    echo ""
}

# Função para mostrar top arquivos
show_top_files() {
    echo -e "${CYAN}📁 Top 5 Maiores Arquivos:${NC}"
    echo "---------------------------"
    
    # Encontrar os 5 maiores arquivos
    local top_files=$(find "$TARGET_DIR" -type f -exec ls -la {} \; 2>/dev/null | sort -k5 -nr | head -5)
    
    if [ -n "$top_files" ]; then
        echo "$top_files" | while IFS= read -r line; do
            if [ -n "$line" ]; then
                local size=$(echo "$line" | awk '{print $5}')
                local file=$(echo "$line" | awk '{print $NF}')
                local formatted_size=$(format_size "$size")
                echo "  📄 $formatted_size - $file"
            fi
        done
    else
        echo "  Nenhum arquivo encontrado"
    fi
    
    echo ""
}

# Função para verificar problemas de permissão
check_permission_issues() {
    echo -e "${CYAN}⚠️  Verificação de Problemas:${NC}"
    echo "----------------------------"
    
    local issues_found=0
    
    # Verificar arquivos sem permissão de leitura
    local unreadable_files=$(find "$TARGET_DIR" -type f ! -readable 2>/dev/null | wc -l | tr -d ' ')
    if [ "$unreadable_files" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Arquivos não legíveis: $unreadable_files${NC}"
        ((issues_found++))
    fi
    
    # Verificar diretórios sem permissão de execução
    local unexecutable_dirs=$(find "$TARGET_DIR" -type d ! -executable 2>/dev/null | wc -l | tr -d ' ')
    if [ "$unexecutable_dirs" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Diretórios não executáveis: $unexecutable_dirs${NC}"
        ((issues_found++))
    fi
    
    # Verificar arquivos sem permissão de escrita
    local unwritable_files=$(find "$TARGET_DIR" -type f ! -writable 2>/dev/null | wc -l | tr -d ' ')
    if [ "$unwritable_files" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Arquivos não graváveis: $unwritable_files${NC}"
        ((issues_found++))
    fi
    
    if [ $issues_found -eq 0 ]; then
        echo -e "${GREEN}✅ Nenhum problema de permissão encontrado${NC}"
    fi
    
    echo ""
}

# Função para mostrar estrutura de diretórios
show_directory_structure() {
    echo -e "${CYAN}📁 Estrutura de Diretórios (Top 10):${NC}"
    echo "------------------------------------"
    
    # Mostrar os primeiros 10 diretórios
    find "$TARGET_DIR" -type d -maxdepth 2 2>/dev/null | head -10 | while IFS= read -r dir; do
        local relative_path="${dir#$TARGET_DIR}"
        if [ -z "$relative_path" ]; then
            relative_path="/"
        fi
        
        # Contar itens no diretório
        local item_count=0
        if [ -r "$dir" ]; then
            item_count=$(find "$dir" -maxdepth 1 -not -path "$dir" 2>/dev/null | wc -l | tr -d ' ')
        fi
        
        echo "  📁 $relative_path ($item_count itens)"
    done
    
    echo ""
}

# Função para verificar tipos de arquivo
check_file_types() {
    echo -e "${CYAN}📄 Tipos de Arquivo:${NC}"
    echo "-------------------"
    
    # Contar por extensão
    local extensions=$(find "$TARGET_DIR" -type f -name "*.*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -nr | head -10)
    
    if [ -n "$extensions" ]; then
        echo "$extensions" | while IFS= read -r line; do
            if [ -n "$line" ]; then
                local count=$(echo "$line" | awk '{print $1}')
                local ext=$(echo "$line" | awk '{print $2}')
                echo "  📄 .$ext: $count arquivos"
            fi
        done
    else
        echo "  Nenhum arquivo com extensão encontrado"
    fi
    
    echo ""
}

# Função para mostrar resumo final
show_final_summary() {
    echo -e "${WHITE}📋 Resumo Final:${NC}"
    echo "==============="
    
    # Verificar se há problemas
    local total_issues=0
    
    # Contar problemas
    local unreadable=$(find "$TARGET_DIR" -type f ! -readable 2>/dev/null | wc -l | tr -d ' ')
    local unexecutable=$(find "$TARGET_DIR" -type d ! -executable 2>/dev/null | wc -l | tr -d ' ')
    local unwritable=$(find "$TARGET_DIR" -type f ! -writable 2>/dev/null | wc -l | tr -d ' ')
    
    total_issues=$((unreadable + unexecutable + unwritable))
    
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ Sistema de permissões está funcionando corretamente${NC}"
    else
        echo -e "${YELLOW}⚠️  $total_issues problemas de permissão encontrados${NC}"
        echo -e "${YELLOW}💡 Execute o script completo para análise detalhada${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}🔧 Comandos úteis:${NC}"
    echo "  • Análise completa: ./permissions-checker.sh"
    echo "  • Verificar arquivo específico: ls -la /caminho/arquivo"
    echo "  • Corrigir permissões: chmod 755 /caminho/diretorio"
    echo "  • Verificar proprietário: ls -la /caminho/arquivo"
    
    echo ""
    echo -e "${GREEN}🎉 Verificação rápida concluída!${NC}"
}

# Função principal
main() {
    # Verificar argumentos
    if [ $# -gt 0 ]; then
        case $1 in
            -h|--help)
                echo "🔍 Verificação Rápida de Permissões"
                echo ""
                echo "USO:"
                echo "    ./quick-permissions-check.sh [OPÇÕES]"
                echo ""
                echo "OPÇÕES:"
                echo "    -h, --help    Mostrar esta ajuda"
                echo ""
                echo "EXEMPLOS:"
                echo "    ./quick-permissions-check.sh"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Opção desconhecida: $1${NC}"
                echo "Use -h ou --help para ver as opções disponíveis"
                exit 1
                ;;
        esac
    fi
    
    # Executar verificações
    check_basic_permissions
    get_quick_stats
    show_top_files
    check_permission_issues
    show_directory_structure
    check_file_types
    show_final_summary
}

# Executar função principal
main "$@"
