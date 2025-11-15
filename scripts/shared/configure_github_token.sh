#!/bin/bash

# ============================================
# Script de Configuração: GitHub Token
# ============================================
# Configura GitHub Personal Access Token na VPS
# ============================================

set -e

echo "============================================"
echo "🔑 Configuração GitHub Token - VPS"
echo "============================================"
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Token do GitHub (pode ser passado como argumento ou variável de ambiente)
GITHUB_TOKEN="${1:-${GITHUB_TOKEN}}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${YELLOW}⚠️  Token não fornecido${NC}"
    echo ""
    echo "Uso:"
    echo "  $0 <github-token>"
    echo "  ou"
    echo "  GITHUB_TOKEN='seu-token' $0"
    echo ""
    exit 1
fi

# Validar formato do token
if [[ ! "$GITHUB_TOKEN" =~ ^ghp_ ]]; then
    echo -e "${RED}❌ Token inválido (deve começar com 'ghp_')${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Token válido: ${GITHUB_TOKEN:0:10}...${NC}"
echo ""

# 1. Testar token
echo "1️⃣  Testando token..."
USER_INFO=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user)
if echo "$USER_INFO" | grep -q '"login"'; then
    USERNAME=$(echo "$USER_INFO" | grep '"login"' | cut -d'"' -f4)
    echo -e "   ${GREEN}✅ Token válido para usuário: $USERNAME${NC}"
else
    echo -e "   ${RED}❌ Token inválido ou sem permissões${NC}"
    exit 1
fi

# 2. Configurar variáveis de ambiente
echo ""
echo "2️⃣  Configurando variáveis de ambiente..."
BASHRC="$HOME/.bashrc"

# Remover tokens antigos se existirem
sed -i '/^export GITHUB_TOKEN=/d' "$BASHRC" 2>/dev/null || true
sed -i '/^export GIT_TOKEN=/d' "$BASHRC" 2>/dev/null || true

# Adicionar novos tokens
echo "" >> "$BASHRC"
echo "# GitHub Personal Access Token" >> "$BASHRC"
echo "export GITHUB_TOKEN=\"$GITHUB_TOKEN\"" >> "$BASHRC"
echo "export GIT_TOKEN=\"$GITHUB_TOKEN\"" >> "$BASHRC"

echo -e "   ${GREEN}✅ Tokens adicionados ao .bashrc${NC}"

# 3. Configurar Git
echo ""
echo "3️⃣  Configurando Git..."
git config --global credential.helper store
echo -e "   ${GREEN}✅ Git credential helper configurado${NC}"

# Configurar usuário Git se não estiver configurado
if [ -z "$(git config --global user.name)" ]; then
    git config --global user.name "$USERNAME"
    echo -e "   ${GREEN}✅ Git user.name configurado: $USERNAME${NC}"
fi

if [ -z "$(git config --global user.email)" ]; then
    EMAIL=$(echo "$USER_INFO" | grep '"email"' | cut -d'"' -f4 || echo "")
    if [ -n "$EMAIL" ]; then
        git config --global user.email "$EMAIL"
        echo -e "   ${GREEN}✅ Git user.email configurado: $EMAIL${NC}"
    fi
fi

# 4. Configurar remote do SYSTEM_PROMPT se existir
echo ""
echo "4️⃣  Configurando remote do repositório..."
if [ -d "/root/SYSTEM_PROMPT/.git" ]; then
    cd /root/SYSTEM_PROMPT
    CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [[ "$CURRENT_REMOTE" == *"github.com"* ]]; then
        # Atualizar remote com token
        NEW_REMOTE="https://${GITHUB_TOKEN}@github.com/$(echo "$CURRENT_REMOTE" | sed 's|.*github.com/||' | sed 's|\.git$||').git"
        git remote set-url origin "$NEW_REMOTE"
        echo -e "   ${GREEN}✅ Remote atualizado com token${NC}"
    else
        echo -e "   ${YELLOW}⚠️  Remote não é do GitHub${NC}"
    fi
else
    echo -e "   ${YELLOW}ℹ️  Repositório SYSTEM_PROMPT não encontrado${NC}"
fi

# 5. Criar arquivo .git-credentials
echo ""
echo "5️⃣  Configurando .git-credentials..."
GIT_CREDENTIALS="$HOME/.git-credentials"
echo "https://${GITHUB_TOKEN}@github.com" > "$GIT_CREDENTIALS"
chmod 600 "$GIT_CREDENTIALS"
echo -e "   ${GREEN}✅ .git-credentials criado${NC}"

# 6. Testar push (se houver commits pendentes)
echo ""
echo "6️⃣  Testando configuração..."
export GITHUB_TOKEN="$GITHUB_TOKEN"
export GIT_TOKEN="$GITHUB_TOKEN"

# Testar API
if curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user > /dev/null; then
    echo -e "   ${GREEN}✅ Conexão com GitHub API funcionando${NC}"
else
    echo -e "   ${RED}❌ Erro ao conectar com GitHub API${NC}"
fi

# 7. Resumo
echo ""
echo "============================================"
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo "============================================"
echo ""
echo "📋 Configurações aplicadas:"
echo "   ✅ GITHUB_TOKEN configurado no .bashrc"
echo "   ✅ GIT_TOKEN configurado no .bashrc"
echo "   ✅ Git credential helper configurado"
echo "   ✅ .git-credentials criado"
echo "   ✅ Remote do SYSTEM_PROMPT atualizado"
echo ""
echo "📋 Próximos passos:"
echo "   1. Recarregar shell: source ~/.bashrc"
echo "   2. Testar: git push origin main"
echo "   3. Verificar: echo \$GITHUB_TOKEN"
echo ""

