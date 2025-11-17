#!/bin/bash
# Script para Criar Itens de Hospedagem no 1Password
# Cria todos os itens necessários para mfotrust.com seguindo melhores práticas
#
# Uso: ./scripts/criar-itens-hospedagem-1password.sh [--vault VAULT] [--dry-run]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VAULT="1p_vps"
DRY_RUN=false
FTP_PASSWORD=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vault)
            VAULT="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --ftp-password)
            FTP_PASSWORD="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

# Verificar se 1Password CLI está disponível
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    echo -e "${YELLOW}   Instale com: brew install 1password-cli${NC}"
    exit 1
fi

if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Não autenticado no 1Password${NC}"
    echo -e "${YELLOW}   Execute: op signin${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   CRIAR ITENS HOSPEDAGEM 1PASSWORD    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Vault: ${VAULT}${NC}"
echo -e "${CYAN}Domínio: mfotrust.com${NC}"
[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
echo ""

# Solicitar senha FTP se não fornecida
if [ -z "$FTP_PASSWORD" ] && [ "$DRY_RUN" = false ]; then
    read -sp "🔑 Senha FTP (não será exibida): " FTP_PASSWORD
    echo ""
fi

# Conteúdo das notas
PLAN_DETAILS=$(cat <<'EOF'
PLANO: Business Web Hosting
DOMÍNIO: mfotrust.com
EXPIRA: 2026-11-14

RECURSOS:
- Espaço em disco: 50 GB
- RAM: 1536 MB
- CPU: 2 núcleos
- Inodes: 600.000
- Addons/Sites: 50
- Máximo de processos: 120
- PHP workers: 60
- Largura de banda: Ilimitado

SERVIDOR:
- Nome: server1596
- Localização: South America (Brazil)
- Backups: EUA
- IP do site: 185.173.111.131

ACESSO:
- Site: https://mfotrust.com
- Site WWW: https://www.mfotrust.com
- FTP IP: ftp://185.173.111.131
- FTP Host: ftp://mfotrust.com
EOF
)

SERVER_INFO=$(cat <<'EOF'
SERVIDOR: server1596
LOCALIZAÇÃO: South America (Brazil)
BACKUPS: EUA

IP DO SITE: 185.173.111.131

NAMESERVERS ATUAIS:
- ns1.dns-parking.com
- ns2.dns-parking.com

NAMESERVERS HOSTINGER:
- ns1.dns-parking.com
- ns2.dns-parking.com

NOTA: Nameservers estão como dns-parking (verificar se deve atualizar)
EOF
)

FTP_DETAILS=$(cat <<'EOF'
FTP - mfotrust.com

IP: ftp://185.173.111.131
Hostname: ftp://mfotrust.com
Username: u452314665
Password: [ver item HOSTINGER_FTP_MFOTRUST]

CAMINHO DE UPLOAD:
public_html

PROTOCOLO: FTP
PORTA: 21 (padrão)
SEGURANÇA: FTPS recomendado (porta 990)
EOF
)

# Função para criar item
create_item() {
    local title="$1"
    local category="$2"
    local notes="$3"
    local username="${4:-}"
    local password="${5:-}"
    local url="${6:-}"

    echo -e "${YELLOW}📝 Criando: ${title}${NC}"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}   [DRY-RUN] Seria criado:${NC}"
        echo -e "${CYAN}   - Título: ${title}${NC}"
        echo -e "${CYAN}   - Categoria: ${category}${NC}"
        if [ -n "$username" ]; then
            echo -e "${CYAN}   - Username: ${username}${NC}"
        fi
        if [ -n "$url" ]; then
            echo -e "${CYAN}   - URL: ${url}${NC}"
        fi
        echo ""
        return 0
    fi

    # Criar item baseado na categoria
    if [ "$category" = "LOGIN" ]; then
        if op item create \
            --category "LOGIN" \
            --title "$title" \
            --vault "$VAULT" \
            username="$username" \
            password="$password" \
            url="$url" \
            --tag "environment:vps" \
            --tag "service:hostinger" \
            --tag "type:credentials" \
            --tag "status:active" \
            --tag "project:mfotrust" \
            2>/dev/null; then
            echo -e "${GREEN}   ✅ Criado com sucesso${NC}"
        else
            echo -e "${RED}   ❌ Erro ao criar${NC}"
            return 1
        fi
    else
        # SECURE_NOTE
        if echo "$notes" | op item create \
            --category "SECURE_NOTE" \
            --title "$title" \
            --vault "$VAULT" \
            notesPlain=- \
            --tag "environment:vps" \
            --tag "service:hostinger" \
            --tag "type:note" \
            --tag "status:active" \
            --tag "project:mfotrust" \
            2>/dev/null; then
            echo -e "${GREEN}   ✅ Criado com sucesso${NC}"
        else
            echo -e "${RED}   ❌ Erro ao criar${NC}"
            return 1
        fi
    fi

    echo ""
}

# Verificar se itens já existem
echo -e "${YELLOW}🔍 Verificando itens existentes...${NC}"
EXISTING=$(op item list --vault "$VAULT" --format json 2>/dev/null | jq -r '.[] | select(.title | test("HOSTINGER.*MFOTRUST")) | .title' || echo "")

if [ -n "$EXISTING" ]; then
    echo -e "${YELLOW}   Itens existentes encontrados:${NC}"
    echo "$EXISTING" | while read item; do
        echo -e "${CYAN}   - $item${NC}"
    done
    echo ""
    read -p "Deseja continuar mesmo assim? (s/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${YELLOW}Operação cancelada${NC}"
        exit 0
    fi
fi

echo ""

# Criar itens
echo -e "${BLUE}📦 Criando itens...${NC}"
echo ""

# 1. Credenciais FTP
create_item \
    "HOSTINGER_FTP_MFOTRUST" \
    "LOGIN" \
    "" \
    "u452314665" \
    "$FTP_PASSWORD" \
    "ftp://mfotrust.com"

# 2. Informações do Plano
create_item \
    "HOSTINGER_PLAN_DETAILS_MFOTRUST" \
    "SECURE_NOTE" \
    "$PLAN_DETAILS" \
    "" \
    "" \
    ""

# 3. Informações do Servidor
create_item \
    "HOSTINGER_SERVER_INFO_MFOTRUST" \
    "SECURE_NOTE" \
    "$SERVER_INFO" \
    "" \
    "" \
    ""

# 4. Detalhes FTP
create_item \
    "HOSTINGER_FTP_DETAILS_MFOTRUST" \
    "SECURE_NOTE" \
    "$FTP_DETAILS" \
    "" \
    "" \
    ""

# Resumo
echo -e "${BLUE}📊 Resumo:${NC}"
echo ""
echo -e "${CYAN}Itens criados/atualizados:${NC}"
echo -e "   1. HOSTINGER_FTP_MFOTRUST (LOGIN)"
echo -e "   2. HOSTINGER_PLAN_DETAILS_MFOTRUST (SECURE_NOTE)"
echo -e "   3. HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)"
echo -e "   4. HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)"
echo ""

if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}✅ Todos os itens foram criados!${NC}"
    echo ""
    echo -e "${CYAN}📝 Verificar itens:${NC}"
    echo -e "   op item list --vault ${VAULT} | grep HOSTINGER"
    echo ""
else
    echo -e "${YELLOW}⚠️  Modo DRY-RUN: Nenhum item foi criado${NC}"
    echo -e "${YELLOW}   Execute sem --dry-run para criar os itens${NC}"
fi

echo ""

