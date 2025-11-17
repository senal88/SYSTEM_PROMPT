#!/bin/bash

# Script de configuração inicial para estrutura de dados contábeis NotebookLM
# Executa configuração completa do ambiente

set -e  # Exit on any error

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

# Verificar se estamos no diretório correto
if [ ! -f "README.md" ]; then
    error "Execute este script no diretório notebooklm_accounting"
    exit 1
fi

log "🚀 Iniciando configuração da estrutura de dados contábeis para NotebookLM"

# 1. Verificar dependências Python
log "📋 Verificando dependências Python..."

if ! command -v python3 &> /dev/null; then
    error "Python 3 não encontrado. Instale Python 3.8+ primeiro."
    exit 1
fi

# Verificar versão do Python
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [[ $(echo "$PYTHON_VERSION < 3.8" | bc -l) -eq 1 ]]; then
    error "Python 3.8+ é necessário. Versão atual: $PYTHON_VERSION"
    exit 1
fi

log "✅ Python $PYTHON_VERSION encontrado"

# 2. Instalar dependências Python
log "📦 Instalando dependências Python..."

# Criar requirements.txt se não existir
if [ ! -f "requirements.txt" ]; then
    cat > requirements.txt << EOF
pandas>=1.5.0
numpy>=1.21.0
openpyxl>=3.0.0
python-dateutil>=2.8.0
pytz>=2022.1
EOF
fi

# Instalar dependências
if [ -f "requirements.txt" ]; then
    python3 -m pip install -r requirements.txt
    log "✅ Dependências Python instaladas"
else
    warn "Arquivo requirements.txt não encontrado"
fi

# 3. Verificar estrutura de diretórios
log "📁 Verificando estrutura de diretórios..."

DIRECTORIES=(
    "data/raw"
    "data/processed" 
    "data/exports"
    "templates/balance_sheet"
    "templates/income_statement"
    "templates/cash_flow"
    "templates/general_ledger"
    "reports/monthly"
    "reports/quarterly"
    "reports/annual"
    "analysis/financial_ratios"
    "analysis/trends"
    "analysis/forecasts"
    "analysis/prompts"
    "config"
    "scripts"
    "logs"
)

for dir in "${DIRECTORIES[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log "✅ Diretório criado: $dir"
    else
        info "Diretório já existe: $dir"
    fi
done

# 4. Configurar permissões
log "🔐 Configurando permissões..."

# Tornar scripts executáveis
chmod +x scripts/*.py
chmod +x scripts/*.sh

# Configurar permissões de diretórios
chmod 755 data/
chmod 755 config/
chmod 755 scripts/

log "✅ Permissões configuradas"

# 5. Validar arquivos de configuração
log "⚙️ Validando arquivos de configuração..."

# Verificar se arquivos de configuração existem
CONFIG_FILES=(
    "config/chart_of_accounts.json"
    "config/company_info.json"
    "config/notebooklm_config.json"
)

for config_file in "${CONFIG_FILES[@]}"; do
    if [ -f "$config_file" ]; then
        # Validar JSON
        if python3 -m json.tool "$config_file" > /dev/null 2>&1; then
            log "✅ $config_file é válido"
        else
            error "$config_file contém JSON inválido"
            exit 1
        fi
    else
        warn "$config_file não encontrado"
    fi
done

# 6. Executar scripts de configuração
log "🔧 Executando scripts de configuração..."

# Executar processamento de dados
if [ -f "scripts/data_processing.py" ]; then
    python3 scripts/data_processing.py
    log "✅ Script de processamento de dados executado"
else
    warn "Script de processamento de dados não encontrado"
fi

# Executar integração com NotebookLM
if [ -f "scripts/notebooklm_integration.py" ]; then
    python3 scripts/notebooklm_integration.py
    log "✅ Script de integração NotebookLM executado"
else
    warn "Script de integração NotebookLM não encontrado"
fi

# 7. Criar arquivo de ambiente
log "🌍 Configurando variáveis de ambiente..."

if [ ! -f ".env" ]; then
    cat > .env << EOF
# Configurações do ambiente
ACCOUNTING_DATA_PATH=$(pwd)/data
NOTEBOOKLM_API_KEY=your_api_key_here
COMPANY_ID=your_company_id
LOG_LEVEL=INFO
BACKUP_ENABLED=true
AUTO_REFRESH=true
EOF
    log "✅ Arquivo .env criado"
else
    info "Arquivo .env já existe"
fi

# 8. Criar script de inicialização
log "🚀 Criando script de inicialização..."

cat > start.sh << 'EOF'
#!/bin/bash

# Script de inicialização para estrutura de dados contábeis NotebookLM

echo "🚀 Iniciando estrutura de dados contábeis para NotebookLM..."

# Verificar se estamos no diretório correto
if [ ! -f "README.md" ]; then
    echo "❌ Execute este script no diretório notebooklm_accounting"
    exit 1
fi

# Ativar ambiente virtual se existir
if [ -d "venv" ]; then
    source venv/bin/activate
    echo "✅ Ambiente virtual ativado"
fi

# Executar processamento de dados
echo "📊 Processando dados contábeis..."
python3 scripts/data_processing.py

# Executar integração com NotebookLM
echo "🤖 Configurando integração com NotebookLM..."
python3 scripts/notebooklm_integration.py

echo "✅ Sistema inicializado com sucesso!"
echo "📁 Dados disponíveis em: data/exports/"
echo "📋 Configurações em: config/"
echo "🔧 Scripts em: scripts/"
echo "📊 Análises em: analysis/"

EOF

chmod +x start.sh
log "✅ Script de inicialização criado"

# 9. Criar script de backup
log "💾 Criando script de backup..."

cat > backup.sh << 'EOF'
#!/bin/bash

# Script de backup para estrutura de dados contábeis

BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="accounting_backup_${DATE}.tar.gz"

echo "💾 Iniciando backup..."

# Criar diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

# Criar backup
tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" \
    --exclude="*.pyc" \
    --exclude="__pycache__" \
    --exclude=".git" \
    --exclude="venv" \
    --exclude="backups" \
    .

echo "✅ Backup criado: ${BACKUP_DIR}/${BACKUP_FILE}"

# Manter apenas os últimos 7 backups
cd "$BACKUP_DIR"
ls -t accounting_backup_*.tar.gz | tail -n +8 | xargs -r rm
cd ..

echo "🧹 Backups antigos removidos"
EOF

chmod +x backup.sh
log "✅ Script de backup criado"

# 10. Criar script de validação
log "✅ Criando script de validação..."

cat > validate.sh << 'EOF'
#!/bin/bash

# Script de validação para estrutura de dados contábeis

echo "🔍 Validando estrutura de dados contábeis..."

# Verificar estrutura de diretórios
echo "📁 Verificando diretórios..."
REQUIRED_DIRS=(
    "data/raw" "data/processed" "data/exports"
    "templates/balance_sheet" "templates/income_statement"
    "config" "scripts" "analysis"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir"
    else
        echo "❌ $dir não encontrado"
    fi
done

# Verificar arquivos de configuração
echo "⚙️ Verificando arquivos de configuração..."
CONFIG_FILES=(
    "config/chart_of_accounts.json"
    "config/company_info.json"
    "config/notebooklm_config.json"
)

for config_file in "${CONFIG_FILES[@]}"; do
    if [ -f "$config_file" ]; then
        if python3 -m json.tool "$config_file" > /dev/null 2>&1; then
            echo "✅ $config_file"
        else
            echo "❌ $config_file (JSON inválido)"
        fi
    else
        echo "❌ $config_file não encontrado"
    fi
done

# Verificar scripts
echo "🔧 Verificando scripts..."
SCRIPT_FILES=(
    "scripts/data_processing.py"
    "scripts/notebooklm_integration.py"
)

for script_file in "${SCRIPT_FILES[@]}"; do
    if [ -f "$script_file" ]; then
        echo "✅ $script_file"
    else
        echo "❌ $script_file não encontrado"
    fi
done

echo "✅ Validação concluída"
EOF

chmod +x validate.sh
log "✅ Script de validação criado"

# 11. Executar validação final
log "🔍 Executando validação final..."

if [ -f "validate.sh" ]; then
    ./validate.sh
else
    warn "Script de validação não encontrado"
fi

# 12. Resumo final
log "🎉 Configuração concluída com sucesso!"

echo ""
echo "📋 Resumo da configuração:"
echo "├── 📁 Estrutura de diretórios criada"
echo "├── ⚙️ Arquivos de configuração validados"
echo "├── 🔧 Scripts configurados e executados"
echo "├── 📊 Dados de exemplo processados"
echo "├── 🤖 Integração NotebookLM configurada"
echo "├── 💾 Scripts de backup criados"
echo "└── ✅ Sistema pronto para uso"
echo ""

echo "🚀 Próximos passos:"
echo "1. Editar config/company_info.json com dados da sua empresa"
echo "2. Ajustar config/chart_of_accounts.json conforme necessário"
echo "3. Executar ./start.sh para inicializar o sistema"
echo "4. Importar dados reais em data/raw/"
echo "5. Executar python3 scripts/data_processing.py"
echo "6. Configurar NotebookLM com os dados exportados"
echo ""

echo "📚 Documentação disponível:"
echo "├── README.md - Visão geral"
echo "├── GUIA_USO.md - Guia detalhado"
echo "└── analysis/notebooklm_setup.md - Configuração NotebookLM"
echo ""

echo "🔧 Scripts disponíveis:"
echo "├── ./start.sh - Inicializar sistema"
echo "├── ./backup.sh - Fazer backup"
echo "├── ./validate.sh - Validar configuração"
echo "└── python3 scripts/data_processing.py - Processar dados"
echo ""

log "✅ Configuração finalizada! Sistema pronto para uso."
