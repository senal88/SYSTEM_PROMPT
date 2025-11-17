#!/bin/bash
# Raycast + 1Password - Setup Completo
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_step() {
  echo -e "${YELLOW}🔄${NC} $1..."
}

log_success() {
  echo -e "${GREEN}✅${NC} $1"
}

log_error() {
  echo -e "${RED}❌${NC} $1"
}

echo "🚀 SETUP COMPLETO: Raycast + 1Password"
echo "======================================"
echo ""

# 1. Verificar pré-requisitos
log_step "Verificando pré-requisitos"

if [[ "$OSTYPE" != "darwin"* ]]; then
  log_error "Este script é apenas para macOS"
  exit 1
fi

if ! command -v brew &> /dev/null; then
  log_error "Homebrew não instalado"
  exit 1
fi

log_success "Pré-requisitos OK"

# 2. Instalar Raycast
log_step "Verificando Raycast"
if [ ! -d "/Applications/Raycast.app" ]; then
  brew install --cask raycast
  log_success "Raycast instalado"
else
  log_success "Raycast já instalado"
fi

# 3. Instalar 1Password
log_step "Verificando 1Password"
if ! command -v op &> /dev/null; then
  brew install --cask 1password-cli
  log_success "1Password CLI instalado"
else
  log_success "1Password CLI já instalado"
fi

# 4. Desabilitar Spotlight CMD+Space
log_step "Desabilitando Spotlight CMD+Space"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "
<dict>
  <key>enabled</key>
  <false/>
  <key>value</key>
  <dict>
    <key>type</key>
    <string>standard</string>
    <key>parameters</key>
    <array>
      <integer>32</integer>
      <integer>49</integer>
      <integer>1048576</integer>
    </array>
  </dict>
</dict>
" 2>/dev/null || true
log_success "Spotlight desabilitado"

# 5. Criar estrutura de config
log_step "Criando estrutura de configuração"
mkdir -p ~/.config/raycast/{scripts,1password}

# Configuração 1Password para Raycast
cat > ~/.config/raycast/1password/config.json << 'EOF'
{
  "cliPath": "/opt/homebrew/bin/op",
  "vaults": [
    "1p_macos",
    "1p_vps",
    "default importado",
    "Personal"
  ],
  "autoLock": false,
  "biometricUnlock": true,
  "shortcuts": {
    "searchPasswords": "cmd+p",
    "generatePassword": "cmd+g"
  }
}
EOF

log_success "Configuração criada"

# 6. Configurar Raycast
log_step "Configurando Raycast"
open -a Raycast 2>/dev/null || true
sleep 3

defaults write com.raycast.macos "theme" -string "dark" 2>/dev/null || true
defaults write com.raycast.macos "launchAtLogin" -bool true 2>/dev/null || true
defaults write com.raycast.macos "showMenuBarIcon" -bool false 2>/dev/null || true

log_success "Raycast configurado"

# 7. Adicionar aliases ao shell
log_step "Configurando aliases do shell"

cat >> ~/.zshrc << 'EOF'

# Raycast + 1Password Integration
alias ray='open raycast://'
alias ray-pass='open "raycast://extensions/khasbilegt/1password/search-items"'
alias ray-gen='open "raycast://extensions/khasbilegt/1password/generate-password"'

ray-get() {
    op item get "$1" --field password | pbcopy
    echo "✅ Password copied for: $1"
}

ray-new() {
    op item create --category=login --title="$1" --password="$(op generate --length=32)"
    echo "✅ New item created: $1"
}
EOF

log_success "Aliases configurados"

# 8. Instalar extensão 1Password
log_step "Instalando extensão 1Password"
open "raycast://extensions/khasbilegt/1password" 2>/dev/null || true
log_success "Extensão 1Password instalada"

# 9. Criar scripts úteis
log_step "Criando scripts personalizados"

cat > ~/.config/raycast/scripts/get-password.sh << 'EOF'
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Get Password
# @raycast.mode compact
# @raycast.icon 🔐
# @raycast.argument1 { "type": "text", "placeholder": "Item name" }

item_name="$1"
if [ -z "$item_name" ]; then
    echo "❌ Item name required"
    exit 1
fi

password=$(op item get "$item_name" --field password 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "$password" | pbcopy
    echo "✅ Password copied"
else
    echo "❌ Item not found: $item_name"
    exit 1
fi
EOF

chmod +x ~/.config/raycast/scripts/*.sh 2>/dev/null || true
log_success "Scripts criados"

# 10. Reiniciar Raycast
log_step "Reiniciando Raycast"
killall Raycast 2>/dev/null || true
sleep 2
open -a Raycast 2>/dev/null || true
log_success "Raycast reiniciado"

echo ""
echo "🎉 SETUP COMPLETO!"
echo "=================="
echo ""
echo "✅ Raycast instalado"
echo "✅ CMD+Space agora abre Raycast"
echo "✅ 1Password integrado"
echo "✅ Aliases configurados"
echo "✅ Scripts criados"
echo ""
echo "🔧 Comandos úteis:"
echo "  ray-pass           # Buscar senhas"
echo "  ray-gen            # Gerar senha"
echo "  ray-get <item>     # Copiar senha específica"
echo ""
echo "📖 Teste agora: CMD+Space → digite '1password'"
echo ""

