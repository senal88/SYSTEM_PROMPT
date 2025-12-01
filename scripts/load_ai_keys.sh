#!/usr/bin/env bash
################################################################################
# 🔑 Load AI Keys - Carrega chaves de API via 1Password CLI
#
# PROPÓSITO: Exportar variáveis de ambiente com API keys de forma segura
# VERSÃO: 1.0.1
# DATA: 2025-12-01
################################################################################

# Não usar set -e quando sourced para não matar o shell
# set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ️${NC} $*"; }
ok() { echo -e "${GREEN}✅${NC} $*"; }
warn() { echo -e "${YELLOW}⚠️${NC} $*"; }
err() { echo -e "${RED}❌${NC} $*"; }

# Verificar se 1Password CLI está instalado
if ! command -v op &> /dev/null; then
  warn "1Password CLI não encontrado - pulando carregamento de keys"
  warn "Instale via: brew install --cask 1password-cli"
  return 0 2>/dev/null || true
fi

# Verificar autenticação do 1Password
if ! op account list &> /dev/null 2>&1; then
  warn "1Password CLI não está autenticado - pulando carregamento de keys"
  warn "Execute manualmente: eval \$(op signin)"
  return 0 2>/dev/null || true
fi

info "Carregando chaves de API via 1Password..."# ============================================================================
# ANTHROPIC (Claude)
# ============================================================================
ANTHROPIC_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential" 2>/dev/null || echo "")
if [ -n "$ANTHROPIC_KEY" ]; then
  export ANTHROPIC_API_KEY="$ANTHROPIC_KEY"
  ok "ANTHROPIC_API_KEY carregada (${#ANTHROPIC_KEY} chars)"
else
  warn "ANTHROPIC_API_KEY não encontrada no 1Password"
  warn "Crie o item: op://Development/Anthropic API Key (Claude)/credential"
fi

# ============================================================================
# OPENAI (GPT)
# ============================================================================
OPENAI_KEY=$(op read "op://Development/OpenAI API Key/credential" 2>/dev/null || echo "")
if [ -n "$OPENAI_KEY" ]; then
  export OPENAI_API_KEY="$OPENAI_KEY"
  ok "OPENAI_API_KEY carregada (${#OPENAI_KEY} chars)"
else
  warn "OPENAI_API_KEY não encontrada (opcional)"
fi

# ============================================================================
# GOOGLE (Gemini)
# ============================================================================
GEMINI_KEY=$(op read "op://Development/Google Gemini API Key/credential" 2>/dev/null || echo "")
if [ -n "$GEMINI_KEY" ]; then
  export GOOGLE_API_KEY="$GEMINI_KEY"
  export GEMINI_API_KEY="$GEMINI_KEY"
  ok "GEMINI_API_KEY carregada (${#GEMINI_KEY} chars)"
else
  warn "GEMINI_API_KEY não encontrada (opcional)"
fi

# ============================================================================
# PERPLEXITY
# ============================================================================
PERPLEXITY_KEY=$(op read "op://Development/Perplexity API Key/credential" 2>/dev/null || echo "")
if [ -n "$PERPLEXITY_KEY" ]; then
  export PERPLEXITY_API_KEY="$PERPLEXITY_KEY"
  ok "PERPLEXITY_API_KEY carregada (${#PERPLEXITY_KEY} chars)"
else
  warn "PERPLEXITY_API_KEY não encontrada (opcional)"
fi

# ============================================================================
# GITHUB (se necessário)
# ============================================================================
GITHUB_TOKEN=$(op read "op://Development/GitHub Personal Access Token/credential" 2>/dev/null || echo "")
if [ -n "$GITHUB_TOKEN" ]; then
  export GITHUB_TOKEN="$GITHUB_TOKEN"
  export GH_TOKEN="$GITHUB_TOKEN"
  ok "GITHUB_TOKEN carregada (${#GITHUB_TOKEN} chars)"
else
  warn "GITHUB_TOKEN não encontrada (opcional)"
fi

# ============================================================================
# RESUMO
# ============================================================================
echo ""
info "Resumo das chaves carregadas:"
env | grep -E "ANTHROPIC|OPENAI|GEMINI|GOOGLE|PERPLEXITY|GITHUB" | \
  sed 's/=.*/=***/' | \
  while read line; do
    echo "  - $line"
  done

echo ""
ok "Chaves de API carregadas com sucesso!"
info "Para usar em novas shells, adicione ao ~/.zshrc:"
echo "  source ~/Dotfiles/scripts/load_ai_keys.sh"
