#!/bin/bash
# op_login.sh
# Script interativo para autenticar no 1Password CLI
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔐 Autenticação 1Password CLI${NC}"
echo ""

# Verificar 1Password CLI instalado
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ Erro: 1Password CLI não encontrado${NC}"
    echo "Instale com: brew install 1password-cli"
    exit 1
fi

# Verificar se já está autenticado
if op whoami &>/dev/null 2>&1; then
    CURRENT_ACCOUNT=$(op whoami 2>/dev/null)
    echo -e "${GREEN}✅ Já autenticado: $CURRENT_ACCOUNT${NC}"
    echo ""
    echo "Para reautenticar:"
    echo "  op signout"
    echo "  op signin"
    exit 0
fi

# Listar contas existentes
echo "Contas configuradas:"
op account list 2>/dev/null || echo "Nenhuma conta configurada"

echo ""
echo "Métodos de autenticação disponíveis:"
echo "1. Login interativo (recomendado)"
echo "2. Usar sessão existente do desktop app"
echo "3. Login com command line"
echo ""

read -p "Escolha método [1-3] (padrão: 1): " -n 1 -r METHOD
echo
METHOD=${METHOD:-1}

case "$METHOD" in
    1)
        echo -e "${YELLOW}🔐 Login interativo...${NC}"
        op signin --raw > "${HOME}/.op_session" 2>&1
        export OP_SESSION="$(cat ${HOME}/.op_session)"
        ;;
    2)
        echo -e "${YELLOW}🔐 Usando sessão do desktop app...${NC}"
        if ! op signin &>/dev/null; then
            echo -e "${RED}❌ Erro: Não foi possível usar sessão do desktop app${NC}"
            exit 1
        fi
        ;;
    3)
        read -p "Digite o endereço do servidor (ex: my.1password.com): " SERVER
        read -p "Digite seu email: " EMAIL
        echo -e "${YELLOW}🔐 Login...${NC}"
        op signin "$SERVER" "$EMAIL"
        ;;
    *)
        echo -e "${RED}❌ Opção inválida${NC}"
        exit 1
        ;;
esac

# Verificar autenticação
if op whoami &>/dev/null 2>&1; then
    ACCOUNT=$(op whoami 2>/dev/null)
    echo -e "${GREEN}✅ Autenticado com sucesso!${NC}"
    echo "Conta: $ACCOUNT"
    echo ""
    echo "Para usar em outros scripts:"
    echo "  export OP_SESSION=\$(op signin --raw)"
else
    echo -e "${RED}❌ Erro: Falha na autenticação${NC}"
    exit 1
fi

