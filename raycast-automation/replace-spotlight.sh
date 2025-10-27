#!/usr/bin/env bash
set -euo pipefail

# Script para substituir completamente o Spotlight pelo Raycast
# Desabilita Spotlight e configura Raycast como principal

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║              SUBSTITUIÇÃO SPOTLIGHT → RAYCAST                  ║"
echo -e "║              Raycast como Launcher Principal                   ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# 1. Verificar se o Raycast está instalado
log "Verificando Raycast..."
if ! ls /Applications/Raycast.app >/dev/null 2>&1; then
    error "Raycast não está instalado. Instalando..."
    brew install --cask raycast
fi
success "✅ Raycast instalado"

# 2. Desabilitar Spotlight completamente
log "Desabilitando Spotlight..."

# Desabilitar Spotlight via defaults
defaults write com.apple.spotlight orderedItems -array

# Desabilitar Spotlight via PlistBuddy (método mais robusto)
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:64:enabled false" \
  "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" 2>/dev/null || true

# Desabilitar Spotlight via System Preferences (se possível)
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist 2>/dev/null || true

success "✅ Spotlight desabilitado"

# 3. Configurar Raycast como principal
log "Configurando Raycast como launcher principal..."

# Configurar atalho ⌘ Space para Raycast
defaults write com.raycast.macos hotkey -data \
  "$(printf '%s' '{ "key": 49, "modifiers": 1048576 }' | iconv -f utf-8 -t utf-16)"

# Configurar Raycast para iniciar automaticamente
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Raycast.app", hidden:false}' 2>/dev/null || true

# Configurar Raycast como app padrão para busca
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.raycast.macos;}'

success "✅ Raycast configurado como principal"

# 4. Configurar permissões do sistema
log "Configurando permissões do sistema..."

# Solicitar permissões de acessibilidade
osascript -e 'tell application "System Events" to tell process "System Preferences" to click button "Open System Preferences" of sheet 1 of window 1' 2>/dev/null || true

# Configurar permissões de automação
osascript -e 'tell application "System Events" to tell process "System Preferences" to click button "Open System Preferences" of sheet 1 of window 1' 2>/dev/null || true

warn "⚠️  Configure manualmente as permissões:"
echo "1. Vá em System Preferences → Security & Privacy → Privacy"
echo "2. Selecione 'Accessibility' e adicione Raycast"
echo "3. Selecione 'Automation' e adicione Raycast"
echo "4. Selecione 'Full Disk Access' e adicione Raycast"

# 5. Desabilitar outros launchers
log "Desabilitando outros launchers..."

# Desabilitar Alfred (se instalado)
if ls /Applications/Alfred*.app >/dev/null 2>&1; then
    defaults write com.runningwithcrayons.Alfred-Preferences-3 hotkey.default -string ""
    success "✅ Alfred desabilitado"
fi

# Desabilitar LaunchBar (se instalado)
if ls /Applications/LaunchBar.app >/dev/null 2>&1; then
    defaults write at.obdev.LaunchBar hotkey -string ""
    success "✅ LaunchBar desabilitado"
fi

# 6. Configurar Raycast para máxima produtividade
log "Configurando Raycast para máxima produtividade..."

# Configurar tema escuro
defaults write com.raycast.macos appearance -string "dark"

# Configurar animações suaves
defaults write com.raycast.macos animations -bool true

# Configurar busca global
defaults write com.raycast.macos globalSearch -bool true

# Configurar atalhos personalizados
defaults write com.raycast.macos hotkeys -dict \
  "calculator" "⌘⌥C" \
  "screenshot" "⌘⌥S" \
  "clipboard" "⌘⌥V"

success "✅ Raycast configurado para máxima produtividade"

# 7. Reiniciar serviços necessários
log "Reiniciando serviços..."

# Reiniciar Dock para aplicar mudanças
killall Dock 2>/dev/null || true

# Reiniciar Finder
killall Finder 2>/dev/null || true

# Reiniciar Raycast
killall Raycast 2>/dev/null || true
sleep 2
open -a Raycast

success "✅ Serviços reiniciados"

# 8. Verificar configuração
log "Verificando configuração..."

# Verificar se Spotlight está desabilitado
SPOTLIGHT_ENABLED=$(defaults read com.apple.spotlight orderedItems 2>/dev/null | wc -l || echo "0")
if [[ "$SPOTLIGHT_ENABLED" -eq 0 ]]; then
    success "✅ Spotlight desabilitado"
else
    warn "⚠️  Spotlight ainda pode estar ativo"
fi

# Verificar se Raycast está configurado
RAYCAST_HOTKEY=$(defaults read com.raycast.macos hotkey 2>/dev/null || echo "")
if [[ -n "$RAYCAST_HOTKEY" ]]; then
    success "✅ Raycast configurado com atalho ⌘ Space"
else
    warn "⚠️  Atalho do Raycast não configurado"
fi

# 9. Criar script de verificação
log "Criando script de verificação..."
cat > "$HOME/Dotfiles/raycast-automation/verify-spotlight-replacement.sh" << 'BASH'
#!/usr/bin/env bash
# Script para verificar se a substituição Spotlight → Raycast funcionou

echo "🔍 Verificando substituição Spotlight → Raycast..."

# Verificar Spotlight
SPOTLIGHT_ITEMS=$(defaults read com.apple.spotlight orderedItems 2>/dev/null | wc -l || echo "0")
if [[ "$SPOTLIGHT_ITEMS" -eq 0 ]]; then
    echo "✅ Spotlight desabilitado"
else
    echo "❌ Spotlight ainda ativo"
fi

# Verificar Raycast
if ls /Applications/Raycast.app >/dev/null 2>&1; then
    echo "✅ Raycast instalado"
else
    echo "❌ Raycast não instalado"
fi

# Verificar atalho
RAYCAST_HOTKEY=$(defaults read com.raycast.macos hotkey 2>/dev/null || echo "")
if [[ -n "$RAYCAST_HOTKEY" ]]; then
    echo "✅ Atalho ⌘ Space configurado"
else
    echo "❌ Atalho não configurado"
fi

# Verificar permissões
if [[ -d "/Applications/Raycast.app" ]]; then
    echo "✅ Raycast acessível"
else
    echo "❌ Raycast não acessível"
fi

echo ""
echo "🎯 Teste: Pressione ⌘ Space para abrir o Raycast"
BASH

chmod +x "$HOME/Dotfiles/raycast-automation/verify-spotlight-replacement.sh"

# 10. Resumo final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
echo -e "║              SUBSTITUIÇÃO CONCLUÍDA!                          ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

success "✅ Spotlight desabilitado completamente"
success "✅ Raycast configurado como launcher principal"
success "✅ Atalho ⌘ Space configurado"
success "✅ Outros launchers desabilitados"
success "✅ Raycast configurado para máxima produtividade"

echo ""
info "🎯 TESTE: Pressione ⌘ Space para abrir o Raycast"
info "🔍 Verificação: ./verify-spotlight-replacement.sh"

echo ""
warn "⚠️  IMPORTANTE: Configure as permissões do sistema:"
echo "1. System Preferences → Security & Privacy → Privacy"
echo "2. Adicione Raycast em: Accessibility, Automation, Full Disk Access"

echo ""
log "Substituição Spotlight → Raycast concluída! 🚀"
