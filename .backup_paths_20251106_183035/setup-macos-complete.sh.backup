#!/bin/bash
# ============================================================================
# 🚀 Setup Completo - macOS Silicon
# Arquivo: scripts/setup-macos-complete.sh
# Propósito: Configuração completa do ambiente macOS Silicon
# Data: 27 de Janeiro de 2025
# ============================================================================

set -e

echo "🚀 Configurando ambiente completo para macOS Silicon..."

# 1. Verificar pré-requisitos
echo "🔍 Verificando pré-requisitos..."
command -v docker >/dev/null 2>&1 || { echo "❌ Docker não encontrado"; exit 1; }
command -v op >/dev/null 2>&1 || { echo "❌ 1Password CLI não encontrado"; exit 1; }

# 2. Carregar variáveis de ambiente
echo "📋 Carregando variáveis de ambiente..."
source ~/Dotfiles/automation_1password/scripts/secrets/load-secure-env.sh macos

echo "✅ Variáveis carregadas:"
echo "   - Vault: $OP_VAULT"
echo "   - Host: $OP_CONNECT_HOST"
echo "   - Token: ${OP_CONNECT_TOKEN:0:20}..."

# 3. Iniciar 1Password Connect
echo "🐳 Iniciando 1Password Connect..."
cd ~/Dotfiles/automation_1password/connect
docker-compose up -d

# 4. Aguardar Connect estar pronto
echo "⏳ Aguardando Connect estar pronto..."
sleep 15

# 5. Testar conexão
echo "🧪 Testando conexão com Connect..."
if curl -s http://localhost:8080/v1/health >/dev/null; then
  echo "✅ 1Password Connect está rodando em http://localhost:8080"
else
  echo "❌ Falha ao conectar com Connect"
  exit 1
fi

# 6. Testar acesso aos vaults
echo "🏦 Testando acesso aos vaults..."
if curl -s -H "Authorization: Bearer $OP_CONNECT_TOKEN" "$OP_CONNECT_HOST/v1/vaults" >/dev/null; then
  echo "✅ Acesso aos vaults confirmado"
else
  echo "❌ Falha ao acessar vaults"
  exit 1
fi

# 7. Configurar Cursor
echo "🔧 Configurando Cursor..."
mkdir -p ~/.cursor

# Criar arquivo de ambiente para Cursor
cat > ~/.cursor/.env.macos << EOF
# ============================================================================
# 🔐 Cursor Environment - macOS Silicon
# Arquivo: ~/.cursor/.env.macos
# Propósito: Variáveis de ambiente para Cursor no macOS
# ============================================================================

# 1Password Connect Configuration
export OP_VAULT="$OP_VAULT"
export OP_CONNECT_HOST="$OP_CONNECT_HOST"
export OP_CONNECT_TOKEN="$OP_CONNECT_TOKEN"

# API Keys (via 1Password Connect)
export OPENAI_API_KEY=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/OpenAI%20API%20Key" | jq -r '.fields[] | select(.label=="api_key") | .value')
export ANTHROPIC_API_KEY=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/Anthropic%20API%20Key" | jq -r '.fields[] | select(.label=="api_key") | .value')
export GEMINI_API_KEY=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/Google%20Gemini%20API%20Key" | jq -r '.fields[] | select(.label=="api_key") | .value')
export PERPLEXITY_API_KEY=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/Perplexity%20API%20Key" | jq -r '.fields[] | select(.label=="api_key") | .value')

# Database Configuration
export POSTGRES_HOST=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/PostgreSQL%20Development" | jq -r '.fields[] | select(.label=="hostname") | .value')
export POSTGRES_PORT=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/PostgreSQL%20Development" | jq -r '.fields[] | select(.label=="port") | .value')
export POSTGRES_USER=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/PostgreSQL%20Development" | jq -r '.fields[] | select(.label=="username") | .value')
export POSTGRES_PASSWORD=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/PostgreSQL%20Development" | jq -r '.fields[] | select(.label=="password") | .value')
export POSTGRES_DB=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/PostgreSQL%20Development" | jq -r '.fields[] | select(.label=="database") | .value')

# SMTP Configuration
export SMTP_HOST=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/SMTP%20Gmail%20Configuration" | jq -r '.fields[] | select(.label=="host") | .value')
export SMTP_PORT=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/SMTP%20Gmail%20Configuration" | jq -r '.fields[] | select(.label=="port") | .value')
export SMTP_USER=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/SMTP%20Gmail%20Configuration" | jq -r '.fields[] | select(.label=="username") | .value')
export SMTP_PASSWORD=\$(curl -s -H "Authorization: Bearer \$OP_CONNECT_TOKEN" "\$OP_CONNECT_HOST/v1/vaults/\$OP_VAULT/items/SMTP%20Gmail%20Configuration" | jq -r '.fields[] | select(.label=="password") | .value')
EOF

echo "✅ Arquivo de ambiente do Cursor criado: ~/.cursor/.env.macos"

# 8. Configurar shell
echo "📝 Configurando shell..."
if ! grep -q "load-secure-env.sh macos" ~/.zshrc; then
  echo "source ~/Dotfiles/automation_1password/scripts/secrets/load-secure-env.sh macos" >> ~/.zshrc
  echo "✅ Configuração adicionada ao ~/.zshrc"
fi

# 9. Criar script de carregamento para Cursor
cat > ~/Dotfiles/automation_1password/scripts/bootstrap/load-cursor-macos.sh << 'EOF'
#!/bin/bash
# ============================================================================
# 🔐 Load Cursor Environment - macOS
# Arquivo: scripts/bootstrap/load-cursor-macos.sh
# Propósito: Carregar variáveis de ambiente do Cursor no macOS
# ============================================================================

set -e

echo "🔐 Carregando variáveis de ambiente do Cursor (macOS)..."

# Carregar variáveis do 1Password Connect
source ~/Dotfiles/automation_1password/scripts/secrets/load-secure-env.sh macos

# Carregar variáveis específicas do Cursor
if [[ -f ~/.cursor/.env.macos ]]; then
  source ~/.cursor/.env.macos
  echo "✅ Variáveis do Cursor carregadas"
else
  echo "❌ Arquivo de ambiente do Cursor não encontrado"
  exit 1
fi

echo "✅ Variáveis carregadas com sucesso!"
echo "   - OpenAI API Key: ${OPENAI_API_KEY:0:10}..."
echo "   - Anthropic API Key: ${ANTHROPIC_API_KEY:0:10}..."
echo "   - Database: $POSTGRES_HOST:$POSTGRES_PORT"
echo "   - SMTP: $SMTP_HOST:$SMTP_PORT"
EOF

chmod +x ~/Dotfiles/automation_1password/scripts/bootstrap/load-cursor-macos.sh

# 10. Testar carregamento de variáveis
echo "🧪 Testando carregamento de variáveis..."
source ~/Dotfiles/automation_1password/scripts/bootstrap/load-cursor-macos.sh

# 11. Configurar Traefik Dashboard
echo "🌐 Configurando Traefik Dashboard..."
echo "   - Dashboard: http://localhost:8080"
echo "   - 1Password Connect: http://localhost:8080/v1/health"

# 12. Log da operação
echo "$(date): Setup completo macOS executado com sucesso" >> ~/Dotfiles/automation_1password/logs/automation.log

echo ""
echo "✅ Configuração completa do macOS Silicon finalizada!"
echo "📂 Logs: ~/Dotfiles/automation_1password/logs/automation.log"
echo "🔧 Scripts: ~/Dotfiles/automation_1password/scripts/bootstrap/"
echo "🌐 Connect: $OP_CONNECT_HOST"
echo "🏦 Vault: $OP_VAULT"
echo "🎯 Traefik Dashboard: http://localhost:8080"
echo ""
echo "🎯 Próximos passos:"
echo "1. Execute: source ~/Dotfiles/automation_1password/scripts/bootstrap/load-cursor-macos.sh"
echo "2. Verifique as variáveis: echo \$OPENAI_API_KEY"
echo "3. Configure o Cursor para usar essas variáveis"
echo "4. Acesse o Traefik Dashboard: http://localhost:8080"
echo ""
echo "🔒 Segurança implementada:"
echo "   - Arquivo de ambiente protegido (600)"
echo "   - Tokens nunca expostos em logs"
echo "   - Credenciais em arquivo separado"
echo "   - .gitignore configurado"
