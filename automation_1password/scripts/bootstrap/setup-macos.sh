#!/bin/bash
# ============================================================================
# 🚀 Setup 1Password Connect - macOS
# Arquivo: scripts/setup-macos.sh
# Propósito: Configuração automática do ambiente macOS
# Data: 27 de Janeiro de 2025
# ============================================================================

set -e

# Configurações
ROOT="$DOTFILES_HOME/automation_1password"
ENV_FILE="$ROOT/env/macos.env"
SHARED_ENV="$ROOT/env/shared.env"

echo "🚀 Configurando 1Password Connect no macOS..."

# Criar estrutura de diretórios
mkdir -p "$ROOT"/{env,scripts,connect,tokens,logs}

# Verificar token
if [[ ! -f "$ROOT/tokens/macos_token.txt" ]]; then
  echo "⚠️  Token não encontrado. Gere-o com:"
  echo "    op connect token create --name macos_connect_token --expiry 90d > $ROOT/tokens/macos_token.txt"
  echo "    chmod 600 $ROOT/tokens/macos_token.txt"
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
if ! grep -q "source $ENV_FILE" ~/.zshrc; then
  echo "source $ENV_FILE" >> ~/.zshrc
  echo "✅ Configuração adicionada ao ~/.zshrc"
fi

echo "✅ 1Password Connect (macOS) configurado com sucesso!"
echo "📂 Logs: $OP_LOG_FILE"
echo "🔧 Scripts: $OP_SCRIPTS_DIR"
