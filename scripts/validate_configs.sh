#!/bin/bash

echo "🔍 VALIDAÇÃO DAS CONFIGURAÇÕES CENTRALIZADAS"
echo "============================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERRO]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

# Verificar se estamos no diretório correto
if [[ ! -d "$DOTFILES_HOME" ]]; then
    error "Diretório $DOTFILES_HOME não encontrado!"
    exit 1
fi

cd "$DOTFILES_HOME"

echo ""
log "Verificando estrutura centralizada..."

# 1. VERIFICAR ESTRUTURA DE PASTAS
echo ""
echo "📁 ESTRUTURA DE PASTAS:"
echo "======================="
required_dirs=("configs" "scripts" "env" "clis")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        success "✅ Pasta $dir existe"
    else
        error "❌ Pasta $dir NÃO existe"
    fi
done

# 2. VERIFICAR ARQUIVOS DE CONFIGURAÇÃO
echo ""
echo "⚙️ ARQUIVOS DE CONFIGURAÇÃO:"
echo "============================"
config_files=("configs/gemini_config.json" "configs/cursor_config.json" "configs/codex_config.json" "configs/api_keys.json")
for file in "${config_files[@]}"; do
    if [ -f "$file" ]; then
        success "✅ $file"
    else
        error "❌ $file NÃO encontrado"
    fi
done

# 3. VERIFICAR ARQUIVOS DE AMBIENTE
echo ""
echo "🌍 ARQUIVOS DE AMBIENTE:"
echo "========================"
env_files=("env/global.env")
for file in "${env_files[@]}"; do
    if [ -f "$file" ]; then
        success "✅ $file"
    else
        error "❌ $file NÃO encontrado"
    fi
done

# 4. VERIFICAR SCRIPTS
echo ""
echo "🔧 SCRIPTS:"
echo "==========="
script_files=("scripts/setup_cli_configs.sh" "scripts/validate_configs.sh")
for file in "${script_files[@]}"; do
    if [ -f "$file" ]; then
        success "✅ $file"
    else
        error "❌ $file NÃO encontrado"
    fi
done

# 5. VERIFICAR CLIs
echo ""
echo "🛠️ CLIs:"
echo "========"

# Gemini CLI
if command -v gemini >/dev/null 2>&1; then
    success "✅ Gemini CLI: $(gemini --version)"
else
    error "❌ Gemini CLI não encontrado"
fi

# Cursor CLI
if command -v cursor >/dev/null 2>&1; then
    success "✅ Cursor CLI: $(cursor --version)"
else
    error "❌ Cursor CLI não encontrado"
fi

# Codex CLI
if [[ -f "codex/codex-cli/bin/codex.js" ]]; then
    success "✅ Codex CLI: Encontrado em $DOTFILES_HOME/codex/"
else
    warning "⚠️ Codex CLI: Não encontrado em $DOTFILES_HOME/codex/"
fi

# 6. VERIFICAR VARIÁVEIS DE AMBIENTE
echo ""
echo "🔑 VARIÁVEIS DE AMBIENTE:"
echo "========================="
env_vars=("GEMINI_API_KEY" "CURSOR_API_KEY" "OPENAI_API_KEY" "ANTHROPIC_API_KEY" "DOTFILES_HOME")
for var in "${env_vars[@]}"; do
    if [[ -n "${!var}" ]]; then
        success "✅ $var: ${!var:0:20}..."
    else
        error "❌ $var: NÃO definida"
    fi
done

# 7. VERIFICAR PATHS
echo ""
echo "🛤️ PATHS:"
echo "=========="
if [[ "$PATH" == *"$DOTFILES_HOME/scripts"* ]]; then
    success "✅ PATH contém $DOTFILES_HOME/scripts"
else
    error "❌ PATH não contém $DOTFILES_HOME/scripts"
fi

if [[ "$PATH" == *"$HOME/bin"* ]]; then
    success "✅ PATH contém ~/bin"
else
    error "❌ PATH não contém ~/bin"
fi

# 8. VERIFICAR FUNÇÕES DO ZSHRC
echo ""
echo "🔧 FUNÇÕES DO ZSHRC:"
echo "===================="
if command -v reload_dotfiles >/dev/null 2>&1; then
    success "✅ Função reload_dotfiles disponível"
else
    error "❌ Função reload_dotfiles NÃO disponível"
fi

if command -v check_dotfiles_status >/dev/null 2>&1; then
    success "✅ Função check_dotfiles_status disponível"
else
    error "❌ Função check_dotfiles_status NÃO disponível"
fi

if command -v setup_dotfiles >/dev/null 2>&1; then
    success "✅ Função setup_dotfiles disponível"
else
    error "❌ Função setup_dotfiles NÃO disponível"
fi

# 9. VERIFICAR ALIASES
echo ""
echo "🔗 ALIASES:"
echo "==========="
aliases=("reload" "status" "setup" "c" "cn" "co" "ca")
for alias in "${aliases[@]}"; do
    if alias "$alias" >/dev/null 2>&1; then
        success "✅ Alias $alias disponível"
    else
        error "❌ Alias $alias NÃO disponível"
    fi
done

# 10. ESTATÍSTICAS FINAIS
echo ""
echo "📊 ESTATÍSTICAS:"
echo "================"
echo "📁 Total de pastas: $(find . -type d | wc -l)"
echo "📄 Total de arquivos: $(find . -type f | wc -l)"
echo "🔧 Scripts: $(find scripts -type f 2>/dev/null | wc -l)"
echo "⚙️ Configurações: $(find configs -type f 2>/dev/null | wc -l)"
echo "🌍 Arquivos de ambiente: $(find env -type f 2>/dev/null | wc -l)"

echo ""
echo "🎯 VALIDAÇÃO CONCLUÍDA!"
echo "======================="
echo "📁 Todas as configurações estão centralizadas em: $DOTFILES_HOME/"
echo "🔧 Use 'status' para verificar o status das configurações"
echo "🔄 Use 'reload' para recarregar as configurações"
echo "🚀 Use 'setup' para executar o setup das configurações"
