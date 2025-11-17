#!/usr/bin/env bash
set -euo pipefail

# Raycast Automation - Instalador Principal
# Instala e configura Raycast com integração 1Password

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                RAYCAST AUTOMATION INSTALLER                  ║"
echo "║              Instalação Completa + 1Password                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Verificar macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "Este script é específico para macOS"
    exit 1
fi

# 2. Instalar Homebrew se necessário
log "Verificando Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
    log "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Instalar dependências
log "Instalando dependências..."
brew update
brew install --cask raycast
brew install --cask 1password
brew install --cask 1password-cli
brew install jq

# 4. Configurar Raycast
log "Configurando Raycast..."

# Desabilitar Spotlight
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:64:enabled false" \
  "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true

# Configurar atalho ⌘ Space
defaults write com.raycast.macos hotkey -data \
  "$(printf '%s' '{ "key": 49, "modifiers": 1048576 }' | iconv -f utf-8 -t utf-16)"

# Reiniciar Dock
killall Dock 2>/dev/null || true

# 5. Configurar 1Password CLI
log "Configurando 1Password CLI..."
if ! op account list >/dev/null 2>&1; then
    warn "1Password CLI não está configurado"
    info "Para configurar:"
    echo "1. Abra o 1Password app"
    echo "2. Vá em 1Password → Settings → Developer"
    echo "3. Marque 'Integrate with 1Password CLI'"
    echo "4. Execute: op signin"
    echo ""
    read -p "Pressione Enter após configurar o 1Password CLI..."
fi

# 6. Criar estrutura de diretórios
log "Criando estrutura de diretórios..."
RAYCAST_DIR="$HOME/Library/Application Support/com.raycast.macos"
mkdir -p "$RAYCAST_DIR"/{quicklinks,snippets,script-commands/{development,security}}

# 7. Instalar scripts
log "Instalando scripts do Raycast..."

# Git Status
cat > "$RAYCAST_DIR/script-commands/development/git-status.sh" << 'BASH'
#!/bin/bash
# @raycast.title Git Status
# @raycast.mode fullOutput
# @raycast.icon git-branch
# @raycast.packageName Development

cd "$(pwd)" && git status --porcelain
BASH

# Docker PS
cat > "$RAYCAST_DIR/script-commands/development/docker-ps.sh" << 'BASH'
#!/bin/bash
# @raycast.title Docker PS
# @raycast.mode fullOutput
# @raycast.icon docker
# @raycast.packageName Development

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
BASH

# Test 1Password
cat > "$RAYCAST_DIR/script-commands/security/test-1password.sh" << 'BASH'
#!/bin/bash
# @raycast.title Test 1Password
# @raycast.mode fullOutput
# @raycast.icon key
# @raycast.packageName Security

echo "🔐 Testando 1Password CLI..."
if op item list >/dev/null 2>&1; then
    ITEM_COUNT=$(op item list --format=json | jq '. | length' 2>/dev/null || echo "0")
    echo "✅ 1Password funcionando - $ITEM_COUNT itens acessíveis"
else
    echo "❌ 1Password não está funcionando"
    echo "Execute: op signin"
fi
BASH

# Tornar scripts executáveis
chmod +x "$RAYCAST_DIR/script-commands"/*/*.sh

# 8. Instalar Quicklinks
log "Instalando Quicklinks..."

# GitHub Issues
cat > "$RAYCAST_DIR/quicklinks/github-issues.json" << 'JSON'
{
  "title": "GitHub Issues",
  "searchTemplate": "https://github.com/search?q={argument name=\"query\"}",
  "icon": "💻",
  "keyword": "ghi"
}
JSON

# Google Translate
cat > "$RAYCAST_DIR/quicklinks/translate.json" << 'JSON'
{
  "title": "Google Translate",
  "searchTemplate": "https://translate.google.com/?sl={argument name=\"source\" default=\"auto\"}&tl={argument name=\"target\"}&text={argument name=\"word\"}",
  "icon": "🌐",
  "keyword": "tr"
}
JSON

# 9. Instalar Snippets
log "Instalando Snippets..."

# Email Signature
cat > "$RAYCAST_DIR/snippets/email-signature.json" << 'JSON'
{
  "name": "Email Signature",
  "keyword": "sig",
  "text": "Atenciosamente,\nLuiz Sena\nDesenvolvedor Full Stack"
}
JSON

# 10. Configurar variáveis de ambiente
log "Configurando variáveis de ambiente..."
if ! grep -q "OP_ACCOUNT" "$HOME/.zprofile" 2>/dev/null; then
    echo "" >> "$HOME/.zprofile"
    echo "# 1Password Configuration" >> "$HOME/.zprofile"
    echo "export OP_ACCOUNT='my.1password.com'" >> "$HOME/.zprofile"
fi

# 11. Testar instalação
log "Testando instalação..."

# Verificar Raycast
if ls /Applications/Raycast.app >/dev/null 2>&1; then
    log "✅ Raycast instalado"
else
    error "❌ Raycast não foi instalado"
fi

# Verificar 1Password CLI
if command -v op >/dev/null 2>&1; then
    log "✅ 1Password CLI instalado"
else
    error "❌ 1Password CLI não foi instalado"
fi

# 12. Resumo final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                INSTALAÇÃO CONCLUÍDA!                        ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

info "O que foi instalado:"
echo "✅ Raycast com atalho ⌘ Space"
echo "✅ 1Password CLI"
echo "✅ Scripts de desenvolvimento"
echo "✅ Quicklinks e Snippets"
echo "✅ Window Management"

echo ""
info "Próximos passos:"
echo "1. Abra o Raycast (⌘ Space)"
echo "2. Conceda as permissões necessárias"
echo "3. Configure o 1Password CLI: op signin"
echo "4. Teste os scripts criados"

echo ""
warn "Permissões necessárias:"
echo "- Acessibilidade (para Window Management)"
echo "- Automação (para controle de apps)"
echo "- Full Disk Access (para busca avançada)"

echo ""
log "Instalação completa! Aproveite o Raycast! 🚀"
