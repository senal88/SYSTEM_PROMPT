#!/bin/zsh
# Exportação Essencial 1Password - Versão MVP
# Repositório: 10_INFRAESTRUTURA_VPS
# Compatível: macOS Tahoe 26.0.1
# Última Atualização: 2025-11-16

set -e

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# CONFIGURAÇÃO
# Obter diretório do script e calcular diretório base do módulo
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
MODULE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
export OP_EXPORTS_DIR="${MODULE_DIR}/exports"
export OP_MACOS_DIR="${OP_EXPORTS_DIR}/macos"
export OP_VPS_DIR="${OP_EXPORTS_DIR}/vps"
export OP_MACOS_VAULT="1p_macos"
export OP_VPS_VAULT="1p_vps"

# CRIAR DIRETÓRIOS
mkdir -p "${OP_MACOS_DIR}" "${OP_VPS_DIR}"

echo -e "${BLUE}🔐 Exportação Essencial 1Password${NC}"
echo ""

# Verificar se 1Password CLI está instalado
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    echo -e "${YELLOW}   Instale com: brew install 1password-cli${NC}"
    exit 1
fi

# Verificar se está autenticado
if ! op whoami &>/dev/null; then
    echo -e "${YELLOW}⚠️  Não autenticado no 1Password CLI${NC}"
    echo -e "${BLUE}   Autenticando...${NC}"
    eval $(op signin) || {
        echo -e "${RED}❌ Falha na autenticação${NC}"
        exit 1
    }
fi

USER=$(op whoami)
echo -e "${GREEN}✅ Autenticado como: ${USER}${NC}"
echo ""

# EXPORTAR 1P_MACOS
echo -e "${BLUE}📦 Exportando ${OP_MACOS_VAULT}...${NC}"
op item list --vault "${OP_MACOS_VAULT}" --format json > "${OP_MACOS_DIR}/${OP_MACOS_VAULT}.json" 2>/dev/null || {
    echo -e "${YELLOW}⚠️  Cofre ${OP_MACOS_VAULT} não encontrado ou sem acesso${NC}"
}

# EXPORTAR 1P_VPS
echo -e "${BLUE}📦 Exportando ${OP_VPS_VAULT}...${NC}"
op item list --vault "${OP_VPS_VAULT}" --format json > "${OP_VPS_DIR}/${OP_VPS_VAULT}.json" 2>/dev/null || {
    echo -e "${YELLOW}⚠️  Cofre ${OP_VPS_VAULT} não encontrado ou sem acesso${NC}"
}

# Verificar se jq está instalado
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠️  jq não encontrado. Instalando...${NC}"
    if command -v brew &> /dev/null; then
        brew install jq
    else
        echo -e "${RED}❌ Homebrew não encontrado. Instale jq manualmente${NC}"
        echo -e "${YELLOW}   Arquivos JSON exportados, mas conversão para CSV não realizada${NC}"
        exit 1
    fi
fi

# CONVERTER PARA CSV
echo -e "${BLUE}🔄 Convertendo JSON para CSV...${NC}"

# Mapear vaults para diretórios
declare -A VAULT_DIRS=(
    ["${OP_MACOS_VAULT}"]="${OP_MACOS_DIR}"
    ["${OP_VPS_VAULT}"]="${OP_VPS_DIR}"
)

for vault in "${OP_MACOS_VAULT}" "${OP_VPS_VAULT}"; do
    VAULT_DIR="${VAULT_DIRS[$vault]}"
    JSON_FILE="${VAULT_DIR}/${vault}.json"
    CSV_FILE="${VAULT_DIR}/${vault}.csv"

    if [[ -f "$JSON_FILE" ]] && [[ -s "$JSON_FILE" ]]; then
        # Converter para CSV com header
        jq -r '["ID","Title","Category","Created","Updated"] as $h | [$h] + [.[] | [.id, .title, .category, .created_at, .updated_at]] | map(@csv) | join("\n")' \
            "$JSON_FILE" > "$CSV_FILE" 2>/dev/null || {
            # Fallback: apenas ID, Title, Category
            jq -r '["ID","Title","Category"] as $h | [$h] + [.[] | [.id, .title, .category]] | map(@csv) | join("\n")' \
                "$JSON_FILE" > "$CSV_FILE"
        }
        echo -e "${GREEN}✅ CSV criado: $(basename "$CSV_FILE")${NC}"
    else
        echo -e "${YELLOW}⚠️  JSON vazio ou não encontrado: $(basename "$JSON_FILE")${NC}"
    fi
done

# GERAR SHA-256
echo -e "${BLUE}🔐 Gerando SHA-256...${NC}"
CHECKSUM_FILE="${MODULE_DIR}/checksums.txt"
shasum -a 256 "${OP_MACOS_DIR}"/*.{json,csv} "${OP_VPS_DIR}"/*.{json,csv} 2>/dev/null > "${CHECKSUM_FILE}" || true

# LIMPAR ORIGINAIS (remover JSON não criptografados)
echo -e "${BLUE}🧹 Removendo arquivos JSON originais...${NC}"
for json_file in "${OP_MACOS_DIR}"/*.json "${OP_VPS_DIR}"/*.json; do
    if [[ -f "$json_file" ]]; then
        if command -v shred &> /dev/null; then
            shred -vfz -n 5 "$json_file" 2>/dev/null && echo -e "${GREEN}✅ Removido com shred: $(basename "$json_file")${NC}"
        else
            rm -f "$json_file" && echo -e "${GREEN}✅ Removido: $(basename "$json_file")${NC}"
        fi
    fi
done

# RESULTADO FINAL
echo ""
echo -e "${GREEN}✅ Exportação concluída!${NC}"
echo ""
echo -e "${BLUE}📊 Arquivos gerados:${NC}"
echo -e "${BLUE}  macOS:${NC}"
ls -lh "${OP_MACOS_DIR}"/*.{csv,json} 2>/dev/null | awk '{print "    " $9 " (" $5 ")"}' || echo "    Nenhum arquivo encontrado"
echo -e "${BLUE}  VPS:${NC}"
ls -lh "${OP_VPS_DIR}"/*.{csv,json} 2>/dev/null | awk '{print "    " $9 " (" $5 ")"}' || echo "    Nenhum arquivo encontrado"

echo ""
echo -e "${BLUE}📁 Diretórios:${NC}"
echo -e "  macOS: ${OP_MACOS_DIR}"
echo -e "  VPS: ${OP_VPS_DIR}"
echo -e "${GREEN}✅ Processo concluído com sucesso!${NC}"

