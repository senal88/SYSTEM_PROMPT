#!/usr/bin/env bash
set -euo pipefail

# Script para configurar 1Password CLI corretamente

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

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                CONFIGURAÇÃO 1PASSWORD CLI                    ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# 1. Verificar se o 1Password CLI está instalado
log "Verificando 1Password CLI..."
if ! command -v op >/dev/null 2>&1; then
    error "1Password CLI não está instalado"
    info "Instalando..."
    brew install --cask 1password-cli
fi

# 2. Verificar se o 1Password app está instalado
log "Verificando 1Password app..."
if ! ls /Applications/1Password.app >/dev/null 2>&1; then
    error "1Password app não está instalado"
    info "Instalando..."
    brew install --cask 1password
fi

# 3. Limpar configurações corrompidas
log "Limpando configurações corrompidas..."
rm -rf "$HOME/.config/op" 2>/dev/null || true
rm -rf "$HOME/.op" 2>/dev/null || true

# 4. Verificar se o 1Password app está rodando
log "Verificando 1Password app..."
if ! pgrep -f "1Password" >/dev/null; then
    warn "1Password app não está rodando. Abrindo..."
    open -a "1Password"
    sleep 5
fi

# 5. Verificar integração com o app
log "Verificando integração com o 1Password app..."
if ! op account list >/dev/null 2>&1; then
    warn "1Password CLI não está integrado com o app"
    echo ""
    info "Para configurar a integração:"
    echo "1. Abra o 1Password app"
    echo "2. Vá em 1Password → Settings → Developer"
    echo "3. Marque 'Integrate with 1Password CLI'"
    echo "4. Execute: op signin"
    echo ""
    read -p "Pressione Enter após configurar a integração no 1Password app..."
fi

# 6. Tentar fazer signin
log "Tentando fazer signin..."
if op signin >/dev/null 2>&1; then
    log "✅ Signin realizado com sucesso!"
else
    warn "Signin automático falhou"
    echo ""
    info "Execute manualmente: op signin"
    echo "E siga as instruções na tela"
    echo ""
    read -p "Pressione Enter após fazer o signin manual..."
fi

# 7. Verificar se funcionou
log "Verificando se a autenticação funcionou..."
if op item list >/dev/null 2>&1; then
    log "✅ 1Password CLI funcionando!"
    
    # Listar alguns itens para verificar
    ITEM_COUNT=$(op item list --format=json | jq '. | length' 2>/dev/null || echo "0")
    log "✅ Acesso a $ITEM_COUNT itens no vault"
    
    # Testar busca por token
    if op item get "GitHub Token" >/dev/null 2>&1; then
        log "✅ Item 'GitHub Token' encontrado"
    else
        warn "⚠️  Item 'GitHub Token' não encontrado"
    fi
    
else
    error "❌ Falha na autenticação do 1Password CLI"
    echo ""
    info "Soluções alternativas:"
    echo "1. Verifique se o 1Password app está logado"
    echo "2. Verifique se a integração CLI está habilitada"
    echo "3. Tente executar: op signin --account [sua-conta]"
    echo "4. Reinicie o 1Password app e tente novamente"
    exit 1
fi

# 8. Configurar variáveis de ambiente
log "Configurando variáveis de ambiente..."
ACCOUNT_URL=$(op account get --format=json | jq -r '.url' 2>/dev/null || echo "")
if [[ -n "$ACCOUNT_URL" ]]; then
    if ! grep -q "OP_ACCOUNT" "$HOME/.zprofile" 2>/dev/null; then
        echo "" >> "$HOME/.zprofile"
        echo "# 1Password Configuration" >> "$HOME/.zprofile"
        echo "export OP_ACCOUNT='$ACCOUNT_URL'" >> "$HOME/.zprofile"
        log "✅ Variável OP_ACCOUNT configurada: $ACCOUNT_URL"
    else
        log "✅ Variável OP_ACCOUNT já configurada"
    fi
fi

# 9. Testar comandos básicos
log "Testando comandos básicos..."

# Listar itens
if op item list >/dev/null 2>&1; then
    log "✅ Lista de itens funcionando"
else
    warn "⚠️  Lista de itens falhou"
fi

# Testar busca
if op item get "GitHub Token" >/dev/null 2>&1; then
    log "✅ Busca por 'GitHub Token' funcionando"
else
    warn "⚠️  Item 'GitHub Token' não encontrado"
fi

# 10. Resumo final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                CONFIGURAÇÃO CONCLUÍDA!                        ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

info "Status atual:"
echo "✅ 1Password CLI: Funcionando"
echo "✅ Autenticação: Ativa"
echo "✅ Acesso aos itens: Funcionando"

echo ""
info "Para testar:"
echo "1. Execute: op item list"
echo "2. Execute: op item get 'Nome do Item'"
echo "3. Execute: op account list"

echo ""
log "Configuração do 1Password CLI concluída! 🎯"
