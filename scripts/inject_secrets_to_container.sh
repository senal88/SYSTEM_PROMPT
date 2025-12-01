#!/usr/bin/env bash
################################################################################
# 💉 Inject Secrets to Container - Injeta secrets do 1Password em DevContainer
#
# PROPÓSITO: Transferir chaves de API do host para container ativo
# VERSÃO: 1.0.0
# DATA: 2025-12-01
################################################################################

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ️${NC} $*"; }
ok() { echo -e "${GREEN}✅${NC} $*"; }
warn() { echo -e "${YELLOW}⚠️${NC} $*"; }
err() { echo -e "${RED}❌${NC} $*"; }

# Verificar se Docker está rodando
if ! docker info &> /dev/null; then
  err "Docker não está rodando"
  exit 1
fi

# Encontrar DevContainer ativo no diretório atual
info "Procurando DevContainer ativo para ${PWD}..."
CONTAINER_ID=$(docker ps -q --filter "label=devcontainer.local_folder=${PWD}" | head -1)

if [ -z "$CONTAINER_ID" ]; then
  err "Nenhum DevContainer ativo encontrado para este diretório"
  warn "Certifique-se de que o DevContainer está rodando"
  exit 1
fi

CONTAINER_NAME=$(docker inspect -f '{{.Name}}' "$CONTAINER_ID" | sed 's/^\///')
info "DevContainer encontrado: $CONTAINER_NAME ($CONTAINER_ID)"

# Verificar se 1Password CLI está disponível
if ! command -v op &> /dev/null; then
  err "1Password CLI não encontrado"
  warn "Instale via: brew install --cask 1password-cli"
  exit 1
fi

# Autenticar no 1Password se necessário
if ! op account list &> /dev/null 2>&1; then
  warn "Autenticando no 1Password..."
  eval $(op signin) || { err "Falha na autenticação"; exit 1; }
fi

info "Carregando chaves do 1Password..."

# Carregar chaves
ANTHROPIC_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential" 2>/dev/null || echo "")
OPENAI_KEY=$(op read "op://Development/OpenAI API Key/credential" 2>/dev/null || echo "")
GEMINI_KEY=$(op read "op://Development/Google Gemini API Key/credential" 2>/dev/null || echo "")
GITHUB_TOKEN=$(op read "op://Development/GitHub Personal Access Token/credential" 2>/dev/null || echo "")

# Criar script de exportação temporário
TEMP_SCRIPT="/tmp/inject_secrets_$$. sh"
cat > "$TEMP_SCRIPT" <<'EOFSCRIPT'
#!/bin/bash
# Script temporário para injetar secrets
EOFSCRIPT

# Adicionar exports ao script
[ -n "$ANTHROPIC_KEY" ] && echo "export ANTHROPIC_API_KEY='$ANTHROPIC_KEY'" >> "$TEMP_SCRIPT"
[ -n "$OPENAI_KEY" ] && echo "export OPENAI_API_KEY='$OPENAI_KEY'" >> "$TEMP_SCRIPT"
[ -n "$GEMINI_KEY" ] && {
  echo "export GOOGLE_API_KEY='$GEMINI_KEY'" >> "$TEMP_SCRIPT"
  echo "export GEMINI_API_KEY='$GEMINI_KEY'" >> "$TEMP_SCRIPT"
}
[ -n "$GITHUB_TOKEN" ] && {
  echo "export GITHUB_TOKEN='$GITHUB_TOKEN'" >> "$TEMP_SCRIPT"
  echo "export GH_TOKEN='$GITHUB_TOKEN'" >> "$TEMP_SCRIPT"
}

# Copiar script para container
info "Injetando secrets no container..."
docker cp "$TEMP_SCRIPT" "$CONTAINER_ID:/tmp/inject_secrets.sh"

# Executar no container e adicionar ao .bashrc (se não existir)
docker exec "$CONTAINER_ID" bash -c "
  chmod +x /tmp/inject_secrets.sh
  source /tmp/inject_secrets.sh

  # Adicionar ao .bashrc se ainda não existe
  if ! grep -q 'AI API Keys injected by host' ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '# AI API Keys injected by host' >> ~/.bashrc
    cat /tmp/inject_secrets.sh | grep '^export' >> ~/.bashrc
  fi

  rm -f /tmp/inject_secrets.sh
  echo '✅ Secrets injetados e adicionados ao .bashrc'
"

# Limpar arquivo temporário local
rm -f "$TEMP_SCRIPT"

ok "Secrets injetados com sucesso no container $CONTAINER_NAME"
info "Para aplicar em novos shells do container, reinicie o terminal integrado"

# Mostrar resumo
echo ""
info "Variáveis exportadas:"
[ -n "$ANTHROPIC_KEY" ] && echo "  ✅ ANTHROPIC_API_KEY"
[ -n "$OPENAI_KEY" ] && echo "  ✅ OPENAI_API_KEY"
[ -n "$GEMINI_KEY" ] && echo "  ✅ GEMINI_API_KEY / GOOGLE_API_KEY"
[ -n "$GITHUB_TOKEN" ] && echo "  ✅ GITHUB_TOKEN / GH_TOKEN"
