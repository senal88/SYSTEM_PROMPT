#!/bin/bash
# ============================================================================
# 🚀 Setup 1Password Connect - VPS
# Arquivo: scripts/setup-vps.sh
# Propósito: Configuração automática do ambiente VPS
# Data: 27 de Janeiro de 2025
# ============================================================================

set -e

# Configurações
ROOT="$HOME/Dotfiles/automation_1password"
ENV_FILE="$ROOT/env/vps.env"
SHARED_ENV="$ROOT/env/shared.env"

echo "🚀 Configurando 1Password Connect na VPS..."

# Criar estrutura de diretórios
mkdir -p "$ROOT"/{env,scripts,connect,tokens,logs}

# Verificar token
if [[ ! -f "$ROOT/tokens/vps_token.txt" ]]; then
  echo "⚠️  Token não encontrado. Gere-o com:"
  echo "    op connect token create --name vps_connect_token --expiry 90d > $ROOT/tokens/vps_token.txt"
  echo "    chmod 600 $ROOT/tokens/vps_token.txt"
  exit 1
fi

# Carregar variáveis
if [[ -f "$SHARED_ENV" ]]; then
  source "$SHARED_ENV"
fi
source "$ENV_FILE"

echo "✅ Variáveis carregadas:"
echo "   - Vault: $OP_VAULT"
echo "   - Host: $OP_CONNECT_HOST"
echo "   - Environment: $OP_ENVIRONMENT"

# Testar conexão
echo "🔍 Testando conexão com 1Password Connect..."
op vault list || { echo "❌ Falha ao conectar-se ao 1Password Connect."; exit 1; }

# Configurar shell
echo "📝 Configurando shell..."
if ! grep -q "source $ENV_FILE" ~/.bashrc; then
  echo "source $ENV_FILE" >> ~/.bashrc
  echo "✅ Configuração adicionada ao ~/.bashrc"
fi

echo "✅ 1Password Connect (VPS) configurado com sucesso!"
echo "📂 Logs: $OP_LOG_FILE"
echo "🔧 Scripts: $OP_SCRIPTS_DIR"
