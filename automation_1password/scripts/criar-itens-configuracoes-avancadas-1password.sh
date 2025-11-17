#!/bin/bash
# Script para Criar Itens de Configurações Avançadas no 1Password
# Cria todos os itens necessários para configurações avançadas do mfotrust.com
#
# Uso: ./scripts/criar-itens-configuracoes-avancadas-1password.sh [--vault VAULT] [--dry-run] [--ssh-password PASSWORD] [--mysql-password PASSWORD]

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
SSH_PASSWORD=""
MYSQL_PASSWORD=""

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
        --ssh-password)
            SSH_PASSWORD="$2"
            shift 2
            ;;
        --mysql-password)
            MYSQL_PASSWORD="$2"
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
    exit 1
fi

if ! op whoami &>/dev/null; then
    echo -e "${RED}❌ Não autenticado no 1Password${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   CRIAR ITENS CONFIGURAÇÕES AVANÇADAS ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Vault: ${VAULT}${NC}"
echo -e "${CYAN}Domínio: mfotrust.com${NC}"
[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
echo ""

# Solicitar senhas se não fornecidas
if [ -z "$SSH_PASSWORD" ] && [ "$DRY_RUN" = false ]; then
    read -sp "🔑 Senha SSH (não será exibida): " SSH_PASSWORD
    echo ""
fi

if [ -z "$MYSQL_PASSWORD" ] && [ "$DRY_RUN" = false ]; then
    read -sp "🔑 Senha MySQL (não será exibida): " MYSQL_PASSWORD
    echo ""
fi

# Conteúdo das notas
MYSQL_REMOTE_NOTES=$(cat <<'EOF'
MYSQL REMOTO - mfotrust.com

HOSTS DISPONÍVEIS:
- srv1596.hstgr.io (recomendado)
- 193.203.175.121 (IP alternativo)

PORTA: 3306

BANCO DE DADOS: u452314665_ufi6Z
USUÁRIO: u452314665_VQw4W
SENHA: [ver item HOSTINGER_MYSQL_MFOTRUST]

CONFIGURAÇÃO:
- Acesso remoto deve ser habilitado no painel
- IPs permitidos devem ser configurados
- Firewall deve permitir porta 3306

CONEXÃO:
mysql -h srv1596.hstgr.io -u u452314665_VQw4W -p u452314665_ufi6Z
EOF
)

PHPMYADMIN_NOTES=$(cat <<'EOF'
PHPMYADMIN - mfotrust.com

ACESSO:
- Via painel Hostinger: Sites → mfotrust.com → Bancos de Dados → PHP My Admin
- Link direto disponível no painel

CREDENCIAIS:
- Usuário: u452314665_VQw4W
- Senha: [ver item HOSTINGER_MYSQL_MFOTRUST]
- Banco: u452314665_ufi6Z

NOTA: Para login via link direto, usar credenciais do banco de dados
EOF
)

GIT_NOTES=$(cat <<'EOF'
GIT - mfotrust.com

REPOSITÓRIO GIT PRIVADO:
- Chave SSH disponível no painel
- Adicionar chave ao GitHub/Bitbucket para repositórios privados

DEPLOYMENT:
- Repositórios públicos: https://github.com/user/repo.git
- Repositórios privados: git@github.com:user/repo.git
- Diretório padrão: public_html
- Diretório deve estar vazio para deploy

CONFIGURAÇÃO:
- Gerar chave SSH no painel se necessário
- Configurar repositório e branch
- Especificar diretório de instalação (opcional)
EOF
)

IP_MANAGER_NOTES=$(cat <<'EOF'
GERENCIADOR DE IP - mfotrust.com

FUNCIONALIDADES:
1. Permitir Endereço de IP
   - Liberar IPs bloqueados
   - Acesso ao site

2. Bloquear Endereço de IP
   - Bloquear IPs específicos
   - Proteção contra acesso não autorizado

USO:
- IPs permitidos: Para liberar acesso
- IPs bloqueados: Para restringir acesso
- Notas: Documentar motivo de cada IP

LOCALIZAÇÃO:
Painel → Sites → mfotrust.com → Avançado → Gerenciador de IP
EOF
)

REDIRECTS_NOTES=$(cat <<'EOF'
REDIRECIONAMENTOS - mfotrust.com

TIPO: Redirecionamento 301 (Permanente)

CONFIGURAÇÃO:
- Redirecionar: http://mfotrust.com/caminho
- Redirecionar para: http://dominio.com
- Pode usar URL ou IP

NOTA IMPORTANTE:
- Para HTTPS, usar opção "Forçar SSL" na área SSL
- Não usar redirecionamento para HTTPS

LOCALIZAÇÃO:
Painel → Sites → mfotrust.com → Domínios → Redirecionamentos
EOF
)

# Função para criar item
create_item() {
    local title="$1"
    local category="$2"
    local notes="$3"
    local username="${4:-}"
    local password="${5:-}"
    local hostname="${6:-}"
    local port="${7:-}"
    local database="${8:-}"
    local url="${9:-}"

    echo -e "${YELLOW}📝 Criando: ${title}${NC}"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}   [DRY-RUN] Seria criado:${NC}"
        echo -e "${CYAN}   - Título: ${title}${NC}"
        echo -e "${CYAN}   - Categoria: ${category}${NC}"
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
            hostname="$hostname" \
            port="$port" \
            url="$url" \
            --tag "environment:vps" \
            --tag "service:hostinger" \
            --tag "type:credentials" \
            --tag "status:inactive" \
            --tag "project:mfotrust" \
            2>/dev/null; then
            echo -e "${GREEN}   ✅ Criado com sucesso${NC}"
        else
            echo -e "${RED}   ❌ Erro ao criar${NC}"
            return 1
        fi
    elif [ "$category" = "DATABASE" ]; then
        if op item create \
            --category "DATABASE" \
            --title "$title" \
            --vault "$VAULT" \
            hostname="$hostname" \
            port="$port" \
            database="$database" \
            username="$username" \
            password="$password" \
            --tag "environment:vps" \
            --tag "service:hostinger" \
            --tag "type:credentials" \
            --tag "status:active" \
            --tag "project:mfotrust" \
            --tag "priority:high" \
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

# Verificar itens existentes
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

# 1. Acesso SSH
create_item \
    "HOSTINGER_SSH_MFOTRUST" \
    "LOGIN" \
    "" \
    "u452314665" \
    "$SSH_PASSWORD" \
    "185.173.111.131" \
    "65002" \
    "" \
    "" \
    "ssh://u452314665@185.173.111.131:65002"

# 2. Banco de Dados MySQL
create_item \
    "HOSTINGER_MYSQL_MFOTRUST" \
    "DATABASE" \
    "" \
    "u452314665_VQw4W" \
    "$MYSQL_PASSWORD" \
    "srv1596.hstgr.io" \
    "3306" \
    "u452314665_ufi6Z" \
    ""

# 3. MySQL Remoto
create_item \
    "HOSTINGER_MYSQL_REMOTE_MFOTRUST" \
    "SECURE_NOTE" \
    "$MYSQL_REMOTE_NOTES" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""

# 4. phpMyAdmin
create_item \
    "HOSTINGER_PHPMYADMIN_MFOTRUST" \
    "SECURE_NOTE" \
    "$PHPMYADMIN_NOTES" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""

# 5. GIT
create_item \
    "HOSTINGER_GIT_MFOTRUST" \
    "SECURE_NOTE" \
    "$GIT_NOTES" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""

# 6. Gerenciador de IP
create_item \
    "HOSTINGER_IP_MANAGER_MFOTRUST" \
    "SECURE_NOTE" \
    "$IP_MANAGER_NOTES" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""

# 7. Redirecionamentos
create_item \
    "HOSTINGER_REDIRECTS_MFOTRUST" \
    "SECURE_NOTE" \
    "$REDIRECTS_NOTES" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""

# Resumo
echo -e "${BLUE}📊 Resumo:${NC}"
echo ""
echo -e "${CYAN}Itens criados/atualizados:${NC}"
echo -e "   1. HOSTINGER_SSH_MFOTRUST (LOGIN)"
echo -e "   2. HOSTINGER_MYSQL_MFOTRUST (DATABASE)"
echo -e "   3. HOSTINGER_MYSQL_REMOTE_MFOTRUST (SECURE_NOTE)"
echo -e "   4. HOSTINGER_PHPMYADMIN_MFOTRUST (SECURE_NOTE)"
echo -e "   5. HOSTINGER_GIT_MFOTRUST (SECURE_NOTE)"
echo -e "   6. HOSTINGER_IP_MANAGER_MFOTRUST (SECURE_NOTE)"
echo -e "   7. HOSTINGER_REDIRECTS_MFOTRUST (SECURE_NOTE)"
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

