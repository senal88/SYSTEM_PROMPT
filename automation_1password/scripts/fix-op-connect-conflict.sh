#!/bin/bash
# fix-op-connect-conflict.sh
# Solução definitiva para conflito 1Password Connect + CLI
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔧 Corrigindo conflito 1Password Connect + CLI"

# Verificar se Connect está ativo
if env | grep -q "OP_CONNECT"; then
    echo -e "${YELLOW}⚠️  Variáveis Connect detectadas${NC}"
    env | grep OP_CONNECT || true
else
    echo -e "${GREEN}✅ Connect não está ativo${NC}"
fi

# Criar função helper para .zshrc
FIX_FUNCTION=$(cat << 'EOF'

# Fix 1Password CLI/Connect Conflict
function op-cli() {
  unset OP_CONNECT_HOST OP_CONNECT_TOKEN
  op "$@"
}

# Alias para conveniência
alias opc='op-cli'
EOF
)

# Adicionar ao .zshrc se não existir
if ! grep -q "op-cli()" ~/.zshrc 2>/dev/null; then
    echo "📝 Adicionando fix ao .zshrc..."
    echo "$FIX_FUNCTION" >> ~/.zshrc
    echo -e "${GREEN}✅ Fix adicionado ao .zshrc${NC}"
else
    echo -e "${GREEN}✅ Fix já existe no .zshrc${NC}"
fi

# Testar agora
echo ""
echo "🧪 Testando agora (sem recarregar shell)..."
unset OP_CONNECT_HOST OP_CONNECT_TOKEN

if op whoami &>/dev/null 2>&1; then
    echo -e "${GREEN}✅ 1Password CLI funcionando!${NC}"
    op whoami
else
    echo -e "${YELLOW}⚠️  Precisa fazer login primeiro${NC}"
    echo "Execute: op signin"
fi

echo ""
echo "✅ Fix aplicado!"
echo ""
echo "📋 Próximos passos:"
echo "  1. Recarregue shell: source ~/.zshrc OU exec zsh"
echo "  2. Use op-cli OU opc para comandos CLI"
echo "  3. Use op normal para Connect (read-only)"
echo ""
echo "📚 Documentação: SOLUCAO_OP_CONNECT_CONFLITO.md"

