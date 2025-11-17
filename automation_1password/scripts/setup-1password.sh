#!/usr/bin/env bash
# Setup 1Password CLI para macOS e VPS
# Repositório: 10_INFRAESTRUTURA_VPS
# Compatível: macOS Tahoe 26.0.1, Ubuntu 22.04 LTS

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Função de ajuda
show_help() {
    cat << EOF
Uso: $0 [--platform PLATFORM] [--vault VAULT_ID] [--account ACCOUNT]

Opções:
  --platform PLATFORM    macOS ou vps (padrão: detecta automaticamente)
  --vault VAULT_ID       ID do cofre para configurar
  --account ACCOUNT      Conta 1Password (ex: my.1password.com)
  --help                 Mostrar esta ajuda

Exemplos:
  $0 --platform macos
  $0 --platform vps --vault oa3tidekmeu26nxiier2qbi7v4
  $0 --account my.1password.com
EOF
}

# Detectar plataforma
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "vps"
    else
        echo "unknown"
    fi
}

# Configurações padrão
PLATFORM="${PLATFORM:-$(detect_platform)}"
VAULT_ID=""
ACCOUNT="${ACCOUNT:-}"

# Parse argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --platform)
            PLATFORM="$2"
            shift 2
            ;;
        --vault)
            VAULT_ID="$2"
            shift 2
            ;;
        --account)
            ACCOUNT="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opção desconhecida: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🔐 Configurando 1Password CLI para $PLATFORM${NC}"
echo ""

# Verificar se 1Password CLI está instalado
if ! command -v op &> /dev/null; then
    echo -e "${YELLOW}⚠️  1Password CLI não encontrado. Instalando...${NC}"

    if [[ "$PLATFORM" == "macos" ]]; then
        # macOS: instalar via Homebrew
        if command -v brew &> /dev/null; then
            brew install --cask 1password-cli
        else
            echo -e "${RED}❌ Homebrew não encontrado. Instale manualmente:${NC}"
            echo "   https://developer.1password.com/docs/cli/get-started"
            exit 1
        fi
    elif [[ "$PLATFORM" == "vps" ]]; then
        # Ubuntu: instalar via apt
        if command -v apt-get &> /dev/null; then
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
                sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
                sudo tee /etc/apt/sources.list.d/1password.list
            sudo apt-get update && sudo apt-get install 1password-cli
        else
            echo -e "${RED}❌ apt-get não encontrado. Instale manualmente.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Plataforma não suportada: $PLATFORM${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ 1Password CLI instalado: $(op --version)${NC}"
echo ""

# Configurar autenticação baseada na plataforma
if [[ "$PLATFORM" == "macos" ]]; then
    echo -e "${BLUE}🍎 Configurando autenticação macOS (TouchID)${NC}"

    # Solicitar conta se não fornecida
    if [[ -z "$ACCOUNT" ]]; then
        read -p "Conta 1Password (ex: my.1password.com): " ACCOUNT
    fi

    # Autenticar usando TouchID (se disponível)
    if [[ -z "$VAULT_ID" ]]; then
        VAULT_ID="gkpsbgizlks2zknwzqpppnb2ze"  # 1p_macos
    fi

    echo -e "${YELLOW}📱 Autenticando com TouchID...${NC}"
    eval $(op signin --account "$ACCOUNT") || {
        echo -e "${RED}❌ Falha na autenticação. Tente manualmente:${NC}"
        echo "   op signin --account $ACCOUNT"
        exit 1
    }

elif [[ "$PLATFORM" == "vps" ]]; then
    echo -e "${BLUE}🐧 Configurando autenticação VPS (Service Account)${NC}"

    # Solicitar conta se não fornecida
    if [[ -z "$ACCOUNT" ]]; then
        read -p "Conta 1Password (ex: my.1password.com): " ACCOUNT
    fi

    # Verificar se token existe
    TOKEN_FILE="${HOME}/.op-token"
    if [[ -f "$TOKEN_FILE" ]]; then
        echo -e "${GREEN}✅ Token encontrado: $TOKEN_FILE${NC}"
        TOKEN=$(cat "$TOKEN_FILE")
    else
        echo -e "${YELLOW}⚠️  Token não encontrado.${NC}"
        read -p "Token de service account: " TOKEN
        read -p "Salvar token em $TOKEN_FILE? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$TOKEN" > "$TOKEN_FILE"
            chmod 600 "$TOKEN_FILE"
            echo -e "${GREEN}✅ Token salvo${NC}"
        fi
    fi

    if [[ -z "$VAULT_ID" ]]; then
        VAULT_ID="oa3tidekmeu26nxiier2qbi7v4"  # 1p_vps
    fi

    echo -e "${YELLOW}🔑 Autenticando com token...${NC}"
    eval $(op signin --account "$ACCOUNT" --token "$TOKEN") || {
        echo -e "${RED}❌ Falha na autenticação. Verifique o token.${NC}"
        exit 1
    }
else
    echo -e "${RED}❌ Plataforma não suportada: $PLATFORM${NC}"
    exit 1
fi

# Verificar autenticação
echo -e "${BLUE}🔍 Verificando autenticação...${NC}"
if op whoami &>/dev/null; then
    USER=$(op whoami)
    echo -e "${GREEN}✅ Autenticado como: $USER${NC}"
else
    echo -e "${RED}❌ Autenticação falhou${NC}"
    exit 1
fi

# Listar cofres disponíveis
echo ""
echo -e "${BLUE}📦 Cofres disponíveis:${NC}"
op vault list

# Verificar acesso ao cofre específico
if [[ -n "$VAULT_ID" ]]; then
    echo ""
    echo -e "${BLUE}🔍 Verificando acesso ao cofre $VAULT_ID...${NC}"
    if op vault get "$VAULT_ID" &>/dev/null; then
        VAULT_NAME=$(op vault get "$VAULT_ID" --format json | jq -r '.name // .id')
        echo -e "${GREEN}✅ Acesso confirmado: $VAULT_NAME${NC}"
    else
        echo -e "${YELLOW}⚠️  Não foi possível acessar o cofre $VAULT_ID${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo ""
echo -e "${BLUE}📝 Próximos passos:${NC}"
echo "  1. Verificar cofres: op vault list"
echo "  2. Testar busca: op item list --vault $VAULT_ID"
echo "  3. Ver documentação: automation_1password/vaults-map.yaml"

