#!/bin/bash

# ============================================
# Script de Correção: 1Password CLI VPS
# ============================================
# Configura autenticação automática do 1Password CLI
# ============================================

set -e

echo "============================================"
echo "🔐 Correção 1Password CLI - VPS"
echo "============================================"
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Verificar instalação
echo "1️⃣  Verificando instalação do 1Password CLI..."
if ! command -v op &> /dev/null; then
    echo -e "   ${RED}❌ 1Password CLI não instalado${NC}"
    echo ""
    echo "   Para instalar:"
    echo "   curl -sSf https://downloads.1password.com/linux/keys/1password.asc | \\"
    echo "     sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg"
    echo ""
    echo "   echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \\"
    echo "     https://downloads.1password.com/linux/debian/amd64 stable main' | \\"
    echo "     sudo tee /etc/apt/sources.list.d/1password.list"
    echo ""
    echo "   sudo apt update && sudo apt install 1password-cli"
    exit 1
fi

OP_VERSION=$(op --version 2>/dev/null || echo "desconhecida")
echo -e "   ${GREEN}✅ 1Password CLI instalado: $OP_VERSION${NC}"

# 2. Verificar contas configuradas
echo ""
echo "2️⃣  Verificando contas configuradas..."
if op account list &>/dev/null; then
    echo -e "   ${GREEN}✅ Autenticado${NC}"
    op account list
    SIGNED_IN=true
else
    echo -e "   ${YELLOW}⚠️  Não autenticado${NC}"
    SIGNED_IN=false
fi

# 3. Verificar Service Account Token
echo ""
echo "3️⃣  Verificando Service Account Token..."
if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo -e "   ${GREEN}✅ OP_SERVICE_ACCOUNT_TOKEN configurado${NC}"
    echo "   Prefixo: ${OP_SERVICE_ACCOUNT_TOKEN:0:20}..."
    SERVICE_ACCOUNT=true
else
    echo -e "   ${YELLOW}⚠️  OP_SERVICE_ACCOUNT_TOKEN não configurado${NC}"
    SERVICE_ACCOUNT=false
fi

# 4. Verificar arquivo de configuração
echo ""
echo "4️⃣  Verificando arquivos de configuração..."
OP_CONFIG_DIR="$HOME/.config/op"
if [ ! -d "$OP_CONFIG_DIR" ]; then
    mkdir -p "$OP_CONFIG_DIR"
    echo -e "   ${GREEN}✅ Diretório criado: $OP_CONFIG_DIR${NC}"
else
    echo -e "   ${GREEN}✅ Diretório existe: $OP_CONFIG_DIR${NC}"
fi

# 5. Tentar autenticação interativa se necessário
if [ "$SIGNED_IN" = false ]; then
    echo ""
    echo "5️⃣  Configurando autenticação..."
    echo -e "   ${BLUE}ℹ️  Para autenticação automática, você tem duas opções:${NC}"
    echo ""
    echo "   Opção 1: Service Account (Recomendado para servidores)"
    echo "   - Crie um Service Account no 1Password"
    echo "   - Configure a variável OP_SERVICE_ACCOUNT_TOKEN"
    echo ""
    echo "   Opção 2: Sessão persistente"
    echo "   - Execute: eval \$(op signin)"
    echo "   - Adicione ao ~/.bashrc para persistir"
    echo ""
    
    # Tentar autenticação interativa
    echo -e "   ${YELLOW}Tentando autenticação interativa...${NC}"
    echo "   (Você precisará inserir sua senha do 1Password)"
    echo ""
    
    # Criar script temporário para autenticação
    AUTH_SCRIPT=$(mktemp)
    cat > "$AUTH_SCRIPT" << 'AUTH_EOF'
#!/bin/bash
# Script temporário para autenticação 1Password

echo "Para autenticar, execute:"
echo ""
echo "  eval \$(op signin my.1password.com luiz.sena88@icloud.com)"
echo ""
echo "Ou configure Service Account Token:"
echo ""
echo "  export OP_SERVICE_ACCOUNT_TOKEN='seu-token-aqui'"
echo "  echo 'export OP_SERVICE_ACCOUNT_TOKEN=\"seu-token-aqui\"' >> ~/.bashrc"
AUTH_EOF
    
    cat "$AUTH_SCRIPT"
    rm "$AUTH_SCRIPT"
fi

# 6. Configurar autenticação automática no .bashrc
echo ""
echo "6️⃣  Configurando autenticação automática no .bashrc..."
BASHRC="$HOME/.bashrc"

# Verificar se já existe configuração do 1Password
if grep -q "OP_SERVICE_ACCOUNT_TOKEN\|op signin" "$BASHRC" 2>/dev/null; then
    echo -e "   ${YELLOW}⚠️  Configuração do 1Password já existe no .bashrc${NC}"
    echo "   Linhas encontradas:"
    grep -n "OP_SERVICE_ACCOUNT_TOKEN\|op signin" "$BASHRC" | sed 's/^/   /'
else
    echo -e "   ${BLUE}ℹ️  Adicionando configuração ao .bashrc...${NC}"
    
    # Backup do .bashrc
    cp "$BASHRC" "${BASHRC}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Adicionar configuração
    cat >> "$BASHRC" << 'BASHRC_EOF'

# ============================================================
# 1Password CLI - Autenticação Automática
# ============================================================
# Opção 1: Service Account Token (Recomendado)
# Descomente e configure seu token:
# export OP_SERVICE_ACCOUNT_TOKEN="op://vault/item/field"

# Opção 2: Sessão persistente (se Service Account não disponível)
# Descomente para autenticação automática:
# if ! op account list &>/dev/null; then
#     eval $(op signin my.1password.com luiz.sena88@icloud.com --raw) 2>/dev/null || true
# fi
BASHRC_EOF
    
    echo -e "   ${GREEN}✅ Configuração adicionada ao .bashrc${NC}"
fi

# 7. Criar script helper para autenticação
echo ""
echo "7️⃣  Criando script helper..."
HELPER_SCRIPT="$HOME/bin/op-signin-helper"
mkdir -p "$HOME/bin"

cat > "$HELPER_SCRIPT" << 'HELPER_EOF'
#!/bin/bash
# Helper script para autenticação 1Password

if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "✅ Service Account Token configurado"
    op account list &>/dev/null && echo "✅ Autenticado" || echo "❌ Token inválido"
elif op account list &>/dev/null; then
    echo "✅ Já autenticado"
else
    echo "🔐 Autenticando..."
    eval $(op signin my.1password.com luiz.sena88@icloud.com)
fi
HELPER_EOF

chmod +x "$HELPER_SCRIPT"
echo -e "   ${GREEN}✅ Script helper criado: $HELPER_SCRIPT${NC}"

# 8. Verificar PATH
echo ""
echo "8️⃣  Verificando PATH..."
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo -e "   ${YELLOW}⚠️  $HOME/bin não está no PATH${NC}"
    echo "   Adicionando ao .bashrc..."
    
    if ! grep -q '$HOME/bin' "$BASHRC"; then
        echo '' >> "$BASHRC"
        echo '# Adicionar ~/bin ao PATH' >> "$BASHRC"
        echo 'export PATH="$HOME/bin:$PATH"' >> "$BASHRC"
        echo -e "   ${GREEN}✅ PATH atualizado${NC}"
    fi
else
    echo -e "   ${GREEN}✅ $HOME/bin está no PATH${NC}"
fi

# 9. Testar autenticação final
echo ""
echo "9️⃣  Teste final..."
if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    if op account list &>/dev/null; then
        echo -e "   ${GREEN}✅ Autenticação funcionando com Service Account Token${NC}"
    else
        echo -e "   ${RED}❌ Service Account Token inválido${NC}"
    fi
elif op account list &>/dev/null; then
    echo -e "   ${GREEN}✅ Autenticação funcionando${NC}"
else
    echo -e "   ${YELLOW}⚠️  Ainda não autenticado${NC}"
    echo ""
    echo "   Para autenticar agora, execute:"
    echo "   ${BLUE}eval \$(op signin my.1password.com luiz.sena88@icloud.com)${NC}"
    echo ""
    echo "   Ou configure Service Account Token:"
    echo "   ${BLUE}export OP_SERVICE_ACCOUNT_TOKEN='seu-token'${NC}"
    echo "   ${BLUE}echo 'export OP_SERVICE_ACCOUNT_TOKEN=\"seu-token\"' >> ~/.bashrc${NC}"
fi

# 10. Resumo e próximos passos
echo ""
echo "============================================"
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo "============================================"
echo ""
echo "📋 Próximos passos:"
echo ""
echo "1. Autenticar manualmente (uma vez):"
echo "   ${BLUE}eval \$(op signin my.1password.com luiz.sena88@icloud.com)${NC}"
echo ""
echo "2. Ou configurar Service Account Token (recomendado):"
echo "   - Crie Service Account no 1Password"
echo "   - Configure: export OP_SERVICE_ACCOUNT_TOKEN='seu-token'"
echo "   - Adicione ao ~/.bashrc para persistência"
echo ""
echo "3. Testar autenticação:"
echo "   ${BLUE}op vault list${NC}"
echo ""
echo "4. Usar script helper:"
echo "   ${BLUE}op-signin-helper${NC}"
echo ""

