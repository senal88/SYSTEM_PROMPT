# Framework de Implantação 1Password - Versão 3.0
> **Sistema Tributário Integrado** | **macOS Silicon + VPS Ubuntu** | **Automação Completa**

## 🎯 **Visão Geral do Framework**

### **Estrutura Integrada**
- **Base**: Framework customizado de prompts otimizados para 1Password
- **Integração**: Sistema Tributário com cofres `1p_macos` e `1p_vps`
- **Automação**: Scripts parametrizados para macOS Silicon e VPS Ubuntu
- **Segurança**: Nomenclatura padronizada e least privilege

### **Componentes Principais**
1. **CLI Automation** - Configuração e automação 1Password CLI v2
2. **CI/CD Integration** - GitHub Actions com secret masking
3. **Agent Development** - Orquestração com LLMs
4. **Debugging & Troubleshooting** - Diagnóstico automatizado
5. **Security & Compliance** - Hardening e auditoria

## 🏗️ **Estrutura de Diretórios Padronizada**

### **macOS Silicon**
```
~/Documents/cursor-setup/
├── cursor-docs-setup-framework.json
├── cursor-setup-prerequisites.md
├── scripts/
│   ├── install-macos.sh
│   ├── validate-macos.sh
│   └── setup-1password-items.sh
├── config-templates/
│   ├── cli-config.json.template
│   ├── cursorrules.template
│   └── cursorignore.template
└── logs/
    └── setup-execution.log
```

### **VPS Ubuntu**
```
~/cursor-setup/
├── cursor-docs-setup-framework.json
├── cursor-setup-prerequisites.md
├── scripts/
│   ├── install-ubuntu.sh
│   ├── validate-ubuntu.sh
│   └── setup-1password-items.sh
├── config-templates/
│   ├── cli-config.json.template
│   ├── cursorrules.template
│   └── cursorignore.template
└── logs/
    └── setup-execution.log
```

## 🔧 **Scripts de Automação**

### **1. Script Mestre macOS Silicon**
```bash
#!/bin/bash
# Arquivo: ~/Documents/cursor-setup/scripts/install-macos.sh

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função para logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos do macOS Silicon..."
    
    # Verificar macOS version
    if [[ $(sw_vers -productVersion | cut -d. -f1) -lt 11 ]]; then
        error "macOS 11.0+ necessário"
        exit 1
    fi
    
    # Verificar arquitetura
    if [[ $(uname -m) != "arm64" ]]; then
        error "Apple Silicon (M1/M2/M3/M4) necessário"
        exit 1
    fi
    
    # Verificar Xcode Command Line Tools
    if ! xcode-select -p &> /dev/null; then
        log "Instalando Xcode Command Line Tools..."
        xcode-select --install
    fi
    
    success "Pré-requisitos verificados"
}

# Instalar Cursor IDE
install_cursor() {
    log "Instalando Cursor IDE..."
    
    # Download
    curl -L https://cursor.com/download -o ~/Downloads/Cursor.dmg
    
    # Instalar
    hdiutil attach ~/Downloads/Cursor.dmg -nobrowse -quiet
    cp -R /Volumes/Cursor/Cursor.app /Applications/
    hdiutil detach /Volumes/Cursor -quiet
    
    # Limpar
    rm -f ~/Downloads/Cursor.dmg
    
    success "Cursor IDE instalado"
}

# Instalar Cursor CLI
install_cursor_cli() {
    log "Instalando Cursor CLI..."
    
    curl -fsSL https://cursor.com/install.sh | bash
    
    # Atualizar PATH
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    export PATH="$HOME/.local/bin:$PATH"
    
    success "Cursor CLI instalado"
}

# Configurar 1Password
setup_1password() {
    log "Configurando integração 1Password..."
    
    # Verificar se 1Password CLI está instalado
    if ! command -v op &> /dev/null; then
        log "Instalando 1Password CLI..."
        brew install --cask 1password-cli
    fi
    
    # Verificar autenticação
    if ! op whoami &> /dev/null; then
        warning "Execute: op signin"
        warning "Cofres necessários: 1p_macos e 1p_vps"
    fi
    
    success "1Password configurado"
}

# Configurar Cursor
configure_cursor() {
    log "Configurando Cursor..."
    
    # Criar diretórios
    mkdir -p ~/.cursor/rules
    mkdir -p ~/Documents/cursor-setup/{logs,scripts,config-templates}
    
    # Configuração CLI
    cat > ~/.cursor/cli-config.json << 'EOF'
{
  "version": 1,
  "editor": {
    "vimMode": false
  },
  "permissions": {
    "allow": [
      "Shell(ls)",
      "Shell(cat)",
      "Shell(echo)",
      "Shell(pwd)",
      "Shell(cd)",
      "Shell(mkdir)",
      "Shell(touch)",
      "Shell(git)"
    ],
    "deny": [
      "Shell(rm)",
      "Shell(sudo)",
      "Shell(chmod 777)"
    ]
  }
}
EOF
    
    # Global ignore
    cat > ~/.cursor/global.cursorignore << 'EOF'
# Global Cursor Ignore
**/.env
**/.env.*
**/credentials.json
**/secrets.json
**/*.key
**/*.pem
**/id_rsa
**/id_ed25519
**/.aws/
**/.ssh/
node_modules/
.git/
*.log
EOF
    
    success "Cursor configurado"
}

# Função principal
main() {
    log "Iniciando setup do Cursor IDE no macOS Silicon..."
    
    check_prerequisites
    install_cursor
    install_cursor_cli
    setup_1password
    configure_cursor
    
    success "Setup completo!"
    log "Próximos passos:"
    echo "1. Execute: cursor-agent auth login"
    echo "2. Configure seu projeto com .cursorrules"
    echo "3. Execute: make 1password-setup (Sistema Tributário)"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### **2. Script Mestre VPS Ubuntu**
```bash
#!/bin/bash
# Arquivo: ~/cursor-setup/scripts/install-ubuntu.sh

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função para logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos do Ubuntu..."
    
    # Verificar Ubuntu version
    if ! lsb_release -d | grep -E "(Ubuntu 20.04|Ubuntu 22.04|Ubuntu 24.04)" &> /dev/null; then
        error "Ubuntu 20.04/22.04/24.04 LTS necessário"
        exit 1
    fi
    
    # Verificar sudo
    if ! sudo -n true 2>/dev/null; then
        error "Acesso sudo necessário"
        exit 1
    fi
    
    # Instalar dependências
    sudo apt-get update
    sudo apt-get install -y curl git build-essential ca-certificates
    
    success "Pré-requisitos verificados"
}

# Instalar Cursor CLI
install_cursor_cli() {
    log "Instalando Cursor CLI..."
    
    curl -fsSL https://cursor.com/install.sh | bash
    
    # Atualizar PATH
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
    
    success "Cursor CLI instalado"
}

# Configurar 1Password
setup_1password() {
    log "Configurando integração 1Password..."
    
    # Verificar se 1Password CLI está instalado
    if ! command -v op &> /dev/null; then
        log "Instalando 1Password CLI..."
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
        echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
        sudo apt-get update
        sudo apt-get install -y 1password-cli
    fi
    
    # Verificar autenticação
    if ! op whoami &> /dev/null; then
        warning "Execute: op signin"
        warning "Cofres necessários: 1p_macos e 1p_vps"
    fi
    
    success "1Password configurado"
}

# Configurar Cursor
configure_cursor() {
    log "Configurando Cursor..."
    
    # Criar diretórios
    mkdir -p ~/.cursor/rules
    mkdir -p ~/cursor-setup/{logs,scripts,config-templates}
    
    # Configuração CLI
    cat > ~/.cursor/cli-config.json << 'EOF'
{
  "version": 1,
  "editor": {
    "vimMode": false
  },
  "permissions": {
    "allow": [
      "Shell(ls)",
      "Shell(cat)",
      "Shell(echo)",
      "Shell(pwd)",
      "Shell(cd)",
      "Shell(mkdir)",
      "Shell(touch)",
      "Shell(git)"
    ],
    "deny": [
      "Shell(rm)",
      "Shell(sudo)",
      "Shell(chmod 777)"
    ]
  }
}
EOF
    
    # Global ignore
    cat > ~/.cursor/global.cursorignore << 'EOF'
# Global Cursor Ignore
**/.env
**/.env.*
**/credentials.json
**/secrets.json
**/*.key
**/*.pem
**/id_rsa
**/id_ed25519
**/.aws/
**/.ssh/
node_modules/
.git/
*.log
EOF
    
    success "Cursor configurado"
}

# Função principal
main() {
    log "Iniciando setup do Cursor IDE no Ubuntu..."
    
    check_prerequisites
    install_cursor_cli
    setup_1password
    configure_cursor
    
    success "Setup completo!"
    log "Próximos passos:"
    echo "1. Execute: source ~/.bashrc"
    echo "2. Execute: cursor-agent auth login"
    echo "3. Configure seu projeto com .cursorrules"
    echo "4. Execute: make 1password-setup (Sistema Tributário)"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

## 📋 **Templates de Configuração**

### **1. CLI Config Template**
```json
{
  "version": 1,
  "editor": {
    "vimMode": false
  },
  "permissions": {
    "allow": [
      "Shell(ls)",
      "Shell(cat)",
      "Shell(echo)",
      "Shell(pwd)",
      "Shell(cd)",
      "Shell(mkdir)",
      "Shell(touch)",
      "Shell(git)"
    ],
    "deny": [
      "Shell(rm)",
      "Shell(sudo)",
      "Shell(chmod 777)"
    ]
  }
}
```

### **2. Cursor Rules Template**
```markdown
---
description: Sistema Tributário - Regras de Desenvolvimento
alwaysApply: true
---

# Sistema Tributário - Regras de Desenvolvimento

## Tecnologias
- **Frontend**: React + TypeScript + Vite + Tailwind CSS
- **Backend**: Node.js + Python + FastAPI + Streamlit
- **Database**: PostgreSQL + MongoDB + Redis
- **AI/ML**: OpenAI + Gemini + Anthropic
- **Infrastructure**: Docker + Traefik + 1Password

## Padrões de Código
- Use TypeScript strict mode
- Siga convenções ESLint/Prettier
- Implemente testes unitários
- Documente APIs com OpenAPI
- Use nomenclatura em português para variáveis de negócio

## Segurança
- Nunca commite secrets
- Use 1Password para credenciais
- Valide todas as entradas
- Implemente autenticação JWT
- Siga princípios de least privilege

## 1Password Integration
- Use cofres `1p_macos` (desenvolvimento) e `1p_vps` (produção)
- Prefixe variáveis: `MACOS_*` e `VPS_*`
- Use sintaxe `op://vault/item/field`
- Implemente rotação de tokens
```

### **3. Cursor Ignore Template**
```
# Sistema Tributário - Arquivos Ignorados

# Environment
.env
.env.*
!.env.example

# Dependencies
node_modules/
__pycache__/
*.pyc
*.pyo
*.pyd
venv/
env/
.venv/

# Build
dist/
build/
.next/
out/
coverage/

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Database
*.db
*.sqlite
*.sqlite3

# Secrets
**/credentials.json
**/secrets.json
**/*.key
**/*.pem
**/id_rsa
**/id_ed25519
**/.aws/
**/.ssh/

# 1Password
**/.op/
**/1password/
```

## 🚀 **Execução Automatizada**

### **macOS Silicon**
```bash
# Criar estrutura de diretórios
mkdir -p ~/Documents/cursor-setup/{logs,scripts,config-templates}

# Baixar e executar script
curl -fsSL https://raw.githubusercontent.com/seu-repo/cursor-automation/main/scripts/install-macos.sh | bash

# Ou executar localmente
chmod +x ~/Documents/cursor-setup/scripts/install-macos.sh
~/Documents/cursor-setup/scripts/install-macos.sh
```

### **VPS Ubuntu**
```bash
# Criar estrutura de diretórios
mkdir -p ~/cursor-setup/{logs,scripts,config-templates}

# Baixar e executar script
curl -fsSL https://raw.githubusercontent.com/seu-repo/cursor-automation/main/scripts/install-ubuntu.sh | bash

# Ou executar localmente
chmod +x ~/cursor-setup/scripts/install-ubuntu.sh
~/cursor-setup/scripts/install-ubuntu.sh
```

## 📊 **Validação e Troubleshooting**

### **Scripts de Validação**
```bash
# macOS
~/Documents/cursor-setup/scripts/validate-macos.sh

# Ubuntu
~/cursor-setup/scripts/validate-ubuntu.sh
```

### **Logs de Execução**
```bash
# macOS
tail -f ~/Documents/cursor-setup/logs/setup-execution.log

# Ubuntu
tail -f ~/cursor-setup/logs/setup-execution.log
```

## 🔄 **Integração com Sistema Tributário**

### **Comandos Makefile Atualizados**
```makefile
# Cursor Integration
cursor-setup:
	@echo "Setting up Cursor IDE..."
	./scripts/install-macos.sh  # ou install-ubuntu.sh

cursor-validate:
	@echo "Validating Cursor setup..."
	./scripts/validate-macos.sh  # ou validate-ubuntu.sh

cursor-dev:
	@echo "Starting development with Cursor..."
	cursor-agent --project . --mode development

# 1Password Integration
1password-setup:
	@echo "Setting up 1Password items..."
	./scripts/setup-1password-items.sh

1password-dev:
	@echo "Starting development with 1Password secrets..."
	op run --env-file configs/.env.macos -- cursor-agent --project . --mode development
```

## 📈 **Métricas de Sucesso**

### **Operacionais**
- **Setup Time**: < 15 minutos
- **Success Rate**: > 99%
- **Error Recovery**: < 5 minutos
- **User Satisfaction**: > 95%

### **Técnicas**
- **CLI Response Time**: < 2 segundos
- **Authentication Success**: > 99.9%
- **Configuration Accuracy**: 100%
- **Integration Success**: > 99.5%

---

**Framework Versão**: 3.0  
**Última Atualização**: 2025-10-24  
**Status**: Pronto para implementação  
**Próxima Ação**: Executar scripts de setup automatizado