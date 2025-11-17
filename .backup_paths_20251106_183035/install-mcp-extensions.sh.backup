#!/usr/bin/env bash
set -euo pipefail

# Script de Instalação Inteligente de Extensões MCP para Gemini CLI
# Analisa e instala as extensões mais relevantes para o ambiente
#
# Uso: ./install-mcp-extensions.sh [--all|--essential|--custom]
#
# Contexto:
# - macOS Silicon (Tahoe 26.0.1)
# - VPS Ubuntu
# - Hugging Face
# - GitHub
# - Codespaces
# - LLMs (OpenAI, Anthropic, Gemini, Ollama, LM Studio)
# - Stacks Docker (Traefik, Redis, Postgres, MongoDB)
# - IDE Cursor

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Limite recomendado de MCP servers simultâneos (performance)
readonly MAX_MCP_SERVERS=12
readonly RECOMMENDED_MCP_SERVERS=8

# Funções de logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

section() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    if ! command -v gemini &> /dev/null; then
        error "Gemini CLI não está instalado. Execute: ./install-gemini-cli.sh"
        exit 1
    fi
    success "Gemini CLI instalado"
    
    if ! command -v op &> /dev/null; then
        error "1Password CLI não está instalado"
        exit 1
    fi
    success "1Password CLI instalado"
}

# Definir extensões por categoria
define_extensions() {
    section "📦 CATALOGANDO EXTENSÕES RELEVANTES"
    
    # Extensões ESSENCIAIS (prioridade máxima)
    ESSENTIAL_EXTENSIONS=(
        "https://github.com/github/github-mcp-server|github|GitHub|MCP|Oficial do GitHub - integração completa com repositórios, issues, PRs, codespaces"
        "https://github.com/ChromeDevTools/chrome-devtools-mcp|chrome-devtools-mcp|Chrome DevTools|MCP|Ferramentas de desenvolvimento para debugging e profiling"
        "https://github.com/googleapis/genai-toolbox|mcp-toolbox-for-databases|Database Toolbox|Context|Suporte para 30+ bancos de dados (Postgres, MongoDB, etc)"
    )
    
    # Extensões ALTAMENTE RECOMENDADAS (alta aderência ao contexto)
    HIGHLY_RECOMMENDED=(
        "https://github.com/hashicorp/terraform-mcp-server|terraform|Terraform|MCP|IaC para gerenciamento de infraestrutura (VPS, Docker, etc)"
        "https://github.com/grafana/mcp-grafana|grafana|Grafana|MCP|Monitoramento e observabilidade para stacks Docker"
        "https://github.com/mongodb-partners/mdb-gemini-cli-ext|mongodb|MongoDB|MCP|Integração nativa com MongoDB (parte do seu stack)"
        "https://github.com/neo4j-contrib/mcp-neo4j|mcp-neo4j|Neo4j|MCP|Suporte a grafos (Neo4j) se necessário"
        "https://github.com/upstash/context7|context7|Context7|MCP|Documentação de código atualizada para prompts"
    )
    
    # Extensões ÚTEIS (moderada aderência)
    USEFUL_EXTENSIONS=(
        "https://github.com/GoogleCloudPlatform/cloud-run-mcp|cloud-run|Cloud Run|MCP|Deploy de aplicações no Google Cloud Run"
        "https://github.com/google/clasp|clasp|Google Apps Script|MCP|Gerenciamento de Google Apps Script"
        "https://github.com/stripe/ai|stripe|Stripe|MCP|Integração com pagamentos Stripe (se aplicável)"
    )
    
    # Extensões OPCIONAIS (baixa prioridade, mas podem ser úteis)
    OPTIONAL_EXTENSIONS=(
        "https://github.com/TencentCloudBase/CloudBase-AI-ToolKit|cloudbase-ai-toolkit|Tencent CloudBase|MCP|Toolkit para desenvolvimento full-stack"
    )
    
    info "📊 Resumo de extensões categorizadas:"
    echo "  • Essenciais: ${#ESSENTIAL_EXTENSIONS[@]}"
    echo "  • Altamente Recomendadas: ${#HIGHLY_RECOMMENDED[@]}"
    echo "  • Úteis: ${#USEFUL_EXTENSIONS[@]}"
    echo "  • Opcionais: ${#OPTIONAL_EXTENSIONS[@]}"
    echo ""
    echo "  📈 Total: $((${#ESSENTIAL_EXTENSIONS[@]} + ${#HIGHLY_RECOMMENDED[@]} + ${#USEFUL_EXTENSIONS[@]} + ${#OPTIONAL_EXTENSIONS[@]})) extensões"
    echo "  ⚠️  Limite recomendado: ${RECOMMENDED_MCP_SERVERS} servidores simultâneos"
    echo "  🔴 Limite máximo: ${MAX_MCP_SERVERS} servidores simultâneos"
}

# Instalar extensão
install_extension() {
    local url="$1"
    local name="$2"
    local display_name="$3"
    local type="$4"
    local description="$5"
    
    info "Instalando: ${display_name} (${name})"
    echo "  Tipo: ${type}"
    echo "  Descrição: ${description}"
    
    if gemini extensions install "$url" 2>&1 | tee /tmp/gemini-ext-install.log; then
        success "${display_name} instalado com sucesso"
        return 0
    else
        local error_msg=$(cat /tmp/gemini-ext-install.log 2>/dev/null || echo "Erro desconhecido")
        if grep -q "already installed" <<< "$error_msg"; then
            warn "${display_name} já está instalado"
            return 0
        else
            error "Falha ao instalar ${display_name}"
            echo "  Erro: ${error_msg}"
            return 1
        fi
    fi
}

# Instalar extensões essenciais
install_essential() {
    section "🎯 INSTALANDO EXTENSÕES ESSENCIAIS"
    
    local installed=0
    local failed=0
    
    for ext in "${ESSENTIAL_EXTENSIONS[@]}"; do
        IFS='|' read -r url name display_name type description <<< "$ext"
        if install_extension "$url" "$name" "$display_name" "$type" "$description"; then
            ((installed++))
        else
            ((failed++))
        fi
        echo ""
    done
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    info "📊 Resultado das Extensões Essenciais:"
    echo "  ✅ Instaladas: ${installed}"
    echo "  ❌ Falhas: ${failed}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Instalar extensões altamente recomendadas
install_highly_recommended() {
    section "⭐ INSTALANDO EXTENSÕES ALTAMENTE RECOMENDADAS"
    
    local installed=0
    local failed=0
    
    for ext in "${HIGHLY_RECOMMENDED[@]}"; do
        IFS='|' read -r url name display_name type description <<< "$ext"
        
        # Verificar limite antes de instalar
        local current_count=$(gemini extensions list 2>/dev/null | grep -c "MCP\|Context" || echo "0")
        if [ "$current_count" -ge "$MAX_MCP_SERVERS" ]; then
            warn "Limite de ${MAX_MCP_SERVERS} servidores atingido. Pulando ${display_name}"
            continue
        fi
        
        if install_extension "$url" "$name" "$display_name" "$type" "$description"; then
            ((installed++))
        else
            ((failed++))
        fi
        echo ""
    done
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    info "📊 Resultado das Extensões Altamente Recomendadas:"
    echo "  ✅ Instaladas: ${installed}"
    echo "  ❌ Falhas: ${failed}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Instalar extensões úteis
install_useful() {
    section "🔧 INSTALANDO EXTENSÕES ÚTEIS"
    
    local installed=0
    local failed=0
    
    for ext in "${USEFUL_EXTENSIONS[@]}"; do
        IFS='|' read -r url name display_name type description <<< "$ext"
        
        # Verificar limite antes de instalar
        local current_count=$(gemini extensions list 2>/dev/null | grep -c "MCP\|Context" || echo "0")
        if [ "$current_count" -ge "$RECOMMENDED_MCP_SERVERS" ]; then
            warn "Limite recomendado de ${RECOMMENDED_MCP_SERVERS} servidores atingido. Pulando ${display_name}"
            continue
        fi
        
        info "⚠️  Instalação opcional: ${display_name}"
        read -p "  Instalar ${display_name}? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            if install_extension "$url" "$name" "$display_name" "$type" "$description"; then
                ((installed++))
            else
                ((failed++))
            fi
        else
            info "  Pulando ${display_name}"
        fi
        echo ""
    done
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    info "📊 Resultado das Extensões Úteis:"
    echo "  ✅ Instaladas: ${installed}"
    echo "  ❌ Falhas: ${failed}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Listar extensões instaladas
list_installed() {
    section "📋 EXTENSÕES INSTALADAS"
    
    if gemini extensions list 2>/dev/null; then
        local count=$(gemini extensions list 2>/dev/null | grep -c "MCP\|Context" || echo "0")
        echo ""
        info "Total de servidores MCP ativos: ${count}/${MAX_MCP_SERVERS}"
        
        if [ "$count" -gt "$RECOMMENDED_MCP_SERVERS" ]; then
            warn "⚠️  Você está usando ${count} servidores, acima do recomendado (${RECOMMENDED_MCP_SERVERS})"
            warn "    Considere desabilitar extensões não utilizadas para melhor performance"
        fi
    else
        error "Não foi possível listar extensões"
    fi
}

# Configurar autenticação para extensões (se necessário)
configure_authentication() {
    section "🔐 CONFIGURANDO AUTENTICAÇÃO"
    
    info "Configurando credenciais para extensões via 1Password..."
    
    # GitHub
    if gemini extensions list 2>/dev/null | grep -q "github"; then
        info "Configurando GitHub MCP Server..."
        local github_token
        if github_token=$(op read "op://shared_infra/github/cli_token" 2>/dev/null); then
            export GITHUB_TOKEN="$github_token"
            success "GitHub token configurado"
        else
            warn "GitHub token não encontrado no 1Password"
        fi
    fi
    
    # MongoDB
    if gemini extensions list 2>/dev/null | grep -q "mongodb"; then
        info "Configurando MongoDB MCP Server..."
        warn "Configure manualmente as credenciais do MongoDB se necessário"
    fi
    
    # Database Toolbox
    if gemini extensions list 2>/dev/null | grep -q "mcp-toolbox-for-databases"; then
        info "Configurando Database Toolbox..."
        warn "Configure manualmente as conexões de banco de dados conforme necessário"
    fi
}

# Gerar relatório de instalação
generate_report() {
    section "📊 RELATÓRIO DE INSTALAÇÃO"
    
    local report_file="$HOME/.config/gemini-cli/extensions-report-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# Relatório de Instalação de Extensões MCP - Gemini CLI

**Data:** $(date '+%Y-%m-%d %H:%M:%S')
**Ambiente:** macOS Silicon (Tahoe 26.0.1) / VPS Ubuntu
**Contexto:** Hugging Face + GitHub + Codespaces + LLMs + Stacks Docker + Cursor IDE

## Extensões Instaladas

EOF

    if gemini extensions list 2>/dev/null >> "$report_file"; then
        success "Relatório salvo em: ${report_file}"
    else
        warn "Não foi possível gerar relatório completo"
    fi
    
    echo ""
    info "📄 Visualize o relatório completo:"
    echo "   cat ${report_file}"
}

# Função principal
main() {
    local mode="${1:-essential}"
    
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║     INSTALAÇÃO INTELIGENTE DE EXTENSÕES MCP PARA GEMINI CLI                  ║"
    echo -e "╚════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    info "Modo: ${mode}"
    echo ""
    
    check_prerequisites
    define_extensions
    
    case "$mode" in
        --essential|essential)
            install_essential
            ;;
        --all|all)
            install_essential
            install_highly_recommended
            install_useful
            ;;
        --custom|custom)
            install_essential
            echo ""
            info "Instalação personalizada - selecione quais extensões instalar"
            read -p "Instalar extensões altamente recomendadas? (S/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                install_highly_recommended
            fi
            read -p "Instalar extensões úteis? (s/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ss]$ ]]; then
                install_useful
            fi
            ;;
        *)
            error "Modo inválido: ${mode}"
            echo ""
            echo "Uso: $0 [--essential|--all|--custom]"
            echo ""
            echo "  --essential  Instala apenas extensões essenciais (padrão)"
            echo "  --all        Instala todas as extensões recomendadas"
            echo "  --custom     Instalação interativa personalizada"
            exit 1
            ;;
    esac
    
    list_installed
    configure_authentication
    generate_report
    
    echo ""
    success "🎉 Instalação concluída!"
    echo ""
    info "Próximos passos:"
    echo "  1. Verifique as extensões instaladas: gemini extensions list"
    echo "  2. Configure credenciais adicionais conforme necessário"
    echo "  3. Teste as extensões em uma sessão: gemini"
    echo ""
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

