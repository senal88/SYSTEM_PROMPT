#!/usr/bin/env bash
# claude-code-login.sh
# Login automático no Claude Code usando ANTHROPIC_API_KEY do 1Password

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔐 Configurando login Claude Code...${NC}"

# Obter API key do 1Password
API_KEY=$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal 2>/dev/null || \
          op item get "Anthropic-API" --vault "1p_macos" --fields "credential" --reveal 2>/dev/null || \
          op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_vps" --fields "credential" --reveal 2>/dev/null || \
          op item get "Anthropic-API" --vault "1p_vps" --fields "credential" --reveal 2>/dev/null || \
          echo "")

if [ -z "$API_KEY" ]; then
    echo -e "${YELLOW}⚠️  Não foi possível obter ANTHROPIC_API_KEY do 1Password${NC}"
    echo "   Configure manualmente: export ANTHROPIC_API_KEY='sua-chave'"
    exit 1
fi

# Exportar API key
export ANTHROPIC_API_KEY="$API_KEY"

echo -e "${GREEN}✅ ANTHROPIC_API_KEY configurada${NC}"
echo "   (${#API_KEY} caracteres)"

# Verificar se Claude Code está disponível
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠️  Claude Code não encontrado no PATH${NC}"
    echo "   Execute: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

# Verificar autenticação
echo -e "${BLUE}🔍 Verificando autenticação...${NC}"
if claude doctor &> /dev/null; then
    echo -e "${GREEN}✅ Claude Code autenticado e pronto para uso${NC}"
else
    echo -e "${YELLOW}⚠️  Execute 'claude' para iniciar sessão interativa${NC}"
fi

echo ""
echo -e "${BLUE}📝 Para usar o Claude Code:${NC}"
echo "   export ANTHROPIC_API_KEY=\$(op item get \"ce5jhu6mivh4g63lzfxlj3r2cu\" --vault \"1p_macos\" --fields \"credential\" --reveal)"
echo "   claude"
echo ""

