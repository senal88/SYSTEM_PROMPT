#!/bin/zsh
# Exportação Profissional 1Password - Versão Completa com Governança
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
export OP_ARCHIVE_DIR="${OP_EXPORTS_DIR}/archive"
export OP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
export OP_MACOS_VAULT="1p_macos"
export OP_VPS_VAULT="1p_vps"
export LOG_FILE="${MODULE_DIR}/export_${OP_TIMESTAMP}.log"

# CRIAR DIRETÓRIOS
mkdir -p "${OP_MACOS_DIR}" "${OP_VPS_DIR}" "${OP_ARCHIVE_DIR}"

# Função de logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

echo -e "${BLUE}🔐 Exportação Profissional 1Password${NC}"
echo -e "${BLUE}📅 Timestamp: ${OP_TIMESTAMP}${NC}"
echo -e "${BLUE}📝 Log: ${LOG_FILE}${NC}"
echo ""

log "=== Início da exportação ==="

# Verificar se 1Password CLI está instalado
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    log "ERRO: 1Password CLI não encontrado"
    echo -e "${YELLOW}   Instale com: brew install 1password-cli${NC}"
    exit 1
fi

# Verificar se está autenticado
if ! op whoami &>/dev/null; then
    echo -e "${YELLOW}⚠️  Não autenticado no 1Password CLI${NC}"
    log "AVISO: Não autenticado, tentando autenticar..."
    echo -e "${BLUE}   Autenticando...${NC}"
    eval $(op signin) || {
        echo -e "${RED}❌ Falha na autenticação${NC}"
        log "ERRO: Falha na autenticação"
        exit 1
    }
fi

USER=$(op whoami)
echo -e "${GREEN}✅ Autenticado como: ${USER}${NC}"
log "INFO: Autenticado como ${USER}"

# EXPORTAR OP_MACOS
echo -e "${BLUE}📦 Exportando ${OP_MACOS_VAULT}...${NC}"
log "INFO: Exportando cofre ${OP_MACOS_VAULT}"
op item list --vault "${OP_MACOS_VAULT}" --format json > "${OP_MACOS_DIR}/${OP_MACOS_VAULT}.json" 2>&1 | tee -a "${LOG_FILE}" || {
    echo -e "${YELLOW}⚠️  Cofre ${OP_MACOS_VAULT} não encontrado ou sem acesso${NC}"
    log "AVISO: Cofre ${OP_MACOS_VAULT} não encontrado ou sem acesso"
}

# EXPORTAR OP_VPS
echo -e "${BLUE}📦 Exportando ${OP_VPS_VAULT}...${NC}"
log "INFO: Exportando cofre ${OP_VPS_VAULT}"
op item list --vault "${OP_VPS_VAULT}" --format json > "${OP_VPS_DIR}/${OP_VPS_VAULT}.json" 2>&1 | tee -a "${LOG_FILE}" || {
    echo -e "${YELLOW}⚠️  Cofre ${OP_VPS_VAULT} não encontrado ou sem acesso${NC}"
    log "AVISO: Cofre ${OP_VPS_VAULT} não encontrado ou sem acesso"
}

# Verificar se jq está instalado
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠️  jq não encontrado. Instalando...${NC}"
    log "INFO: Instalando jq"
    if command -v brew &> /dev/null; then
        brew install jq
    else
        echo -e "${RED}❌ Homebrew não encontrado. Instale jq manualmente${NC}"
        log "ERRO: Homebrew não encontrado para instalar jq"
        exit 1
    fi
fi

# CONVERTER PARA CSV
echo -e "${BLUE}🔄 Convertendo JSON para CSV...${NC}"
log "INFO: Convertendo JSON para CSV"

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
        # Converter para CSV com header completo
        jq -r '["ID","Title","Category","Created","Updated","URL","Username","Tags"] as $h | [$h] + [.[] | [.id, .title, .category, .created_at, .updated_at, (.fields[]? | select(.id=="url") | .value // ""), (.fields[]? | select(.id=="username") | .value // ""), (.tags[]? // "" | tostring)] | map(@csv) | join("\n")' \
            "$JSON_FILE" > "$CSV_FILE" 2>/dev/null || {
            # Fallback: apenas campos básicos
            jq -r '["ID","Title","Category","Created","Updated"] as $h | [$h] + [.[] | [.id, .title, .category, .created_at, .updated_at]] | map(@csv) | join("\n")' \
                "$JSON_FILE" > "$CSV_FILE"
        }

        # Contar itens
        ITEM_COUNT=$(jq '. | length' "$JSON_FILE" 2>/dev/null || echo "0")
        echo -e "${GREEN}✅ CSV criado: $(basename "$CSV_FILE") (${ITEM_COUNT} itens)${NC}"
        log "INFO: CSV criado para ${vault} com ${ITEM_COUNT} itens"
    else
        echo -e "${YELLOW}⚠️  JSON vazio ou não encontrado: $(basename "$JSON_FILE")${NC}"
        log "AVISO: JSON vazio ou não encontrado para ${vault}"
    fi
done

# GERAR SHA-256
echo -e "${BLUE}🔐 Gerando SHA-256...${NC}"
log "INFO: Gerando checksums SHA-256"
CHECKSUM_FILE="${MODULE_DIR}/checksums.txt"
shasum -a 256 "${OP_MACOS_DIR}"/*.{json,csv} "${OP_VPS_DIR}"/*.{json,csv} 2>/dev/null > "${CHECKSUM_FILE}" || {
    echo -e "${YELLOW}⚠️  Nenhum arquivo para gerar checksum${NC}"
    log "AVISO: Nenhum arquivo para gerar checksum"
}

# Adicionar checksum do próprio arquivo de checksums
if [[ -f "${CHECKSUM_FILE}" ]]; then
    CHECKSUM_HASH=$(shasum -a 256 "$CHECKSUM_FILE" | awk '{print $1}')
    echo "${CHECKSUM_HASH}  checksums.txt" >> "$CHECKSUM_FILE"
    echo -e "${GREEN}✅ Checksums gerados: checksums.txt${NC}"
    log "INFO: Checksums gerados"
fi

# CRIPTOGRAFAR COM GPG (opcional)
if command -v gpg &> /dev/null; then
    read -p "Deseja criptografar os arquivos CSV com GPG? (s/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${BLUE}🔒 Criptografando arquivos CSV...${NC}"
        log "INFO: Criptografando arquivos CSV"

        read -p "Email do destinatário GPG: " GPG_RECIPIENT

        for csv_file in "${OP_MACOS_DIR}"/*.csv "${OP_VPS_DIR}"/*.csv; do
            if [[ -f "$csv_file" ]]; then
                gpg --encrypt --recipient "$GPG_RECIPIENT" --armor "$csv_file" 2>/dev/null && {
                    echo -e "${GREEN}✅ Criptografado: $(basename "$csv_file").asc${NC}"
                    log "INFO: Criptografado $(basename "$csv_file")"
                } || {
                    echo -e "${YELLOW}⚠️  Falha ao criptografar: $(basename "$csv_file")${NC}"
                    log "AVISO: Falha ao criptografar $(basename "$csv_file")"
                }
            fi
        done
    fi
fi

# BACKUP COM TIMESTAMP (opcional)
read -p "Deseja criar backup com timestamp em archive/? (s/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    ARCHIVE_SUBDIR="${OP_ARCHIVE_DIR}/${OP_TIMESTAMP}"
    mkdir -p "${ARCHIVE_SUBDIR}"
    echo -e "${BLUE}📦 Criando backup em archive/${OP_TIMESTAMP}...${NC}"
    log "INFO: Criando backup em archive/${OP_TIMESTAMP}"

    cp "${OP_MACOS_DIR}"/*.{json,csv} "${ARCHIVE_SUBDIR}/" 2>/dev/null || true
    cp "${OP_VPS_DIR}"/*.{json,csv} "${ARCHIVE_SUBDIR}/" 2>/dev/null || true
    cp "${CHECKSUM_FILE}" "${ARCHIVE_SUBDIR}/" 2>/dev/null || true

    echo -e "${GREEN}✅ Backup criado em archive/${OP_TIMESTAMP}${NC}"
    log "INFO: Backup criado em archive/${OP_TIMESTAMP}"
fi

# LIMPAR ORIGINAIS JSON (remover JSON não criptografados)
echo -e "${BLUE}🧹 Removendo arquivos JSON originais...${NC}"
log "INFO: Removendo arquivos JSON originais"

for json_file in "${OP_MACOS_DIR}"/*.json "${OP_VPS_DIR}"/*.json; do
    if [[ -f "$json_file" ]]; then
        if command -v shred &> /dev/null; then
            shred -vfz -n 5 "$json_file" 2>/dev/null && {
                echo -e "${GREEN}✅ Removido com shred: $(basename "$json_file")${NC}"
                log "INFO: Removido com shred $(basename "$json_file")"
            }
        else
            rm -f "$json_file" && {
                echo -e "${GREEN}✅ Removido: $(basename "$json_file")${NC}"
                log "INFO: Removido $(basename "$json_file")"
            }
        fi
    fi
done

# Se CSV foi criptografado, remover originais não criptografados
if find "${OP_MACOS_DIR}" "${OP_VPS_DIR}" -name "*.csv.asc" 2>/dev/null | grep -q .; then
    read -p "Arquivos CSV foram criptografados. Remover originais não criptografados? (s/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        for csv_file in "${OP_MACOS_DIR}"/*.csv "${OP_VPS_DIR}"/*.csv; do
            if [[ -f "$csv_file" ]] && [[ -f "${csv_file}.asc" ]]; then
                if command -v shred &> /dev/null; then
                    shred -vfz -n 5 "$csv_file" 2>/dev/null && {
                        echo -e "${GREEN}✅ CSV original removido: $(basename "$csv_file")${NC}"
                        log "INFO: CSV original removido $(basename "$csv_file")"
                    }
                else
                    rm -f "$csv_file" && {
                        echo -e "${GREEN}✅ CSV original removido: $(basename "$csv_file")${NC}"
                        log "INFO: CSV original removido $(basename "$csv_file")"
                    }
                fi
            fi
        done
    fi
fi

# VERIFICAR INTEGRIDADE (opcional)
if [[ -f "${CHECKSUM_FILE}" ]]; then
    echo -e "${BLUE}🔍 Verificando integridade dos arquivos...${NC}"
    log "INFO: Verificando integridade"
    if shasum -a 256 -c "${CHECKSUM_FILE}" 2>/dev/null | grep -v "checksums.txt"; then
        echo -e "${GREEN}✅ Integridade verificada${NC}"
        log "INFO: Integridade verificada com sucesso"
    else
        echo -e "${YELLOW}⚠️  Alguns arquivos não puderam ser verificados${NC}"
        log "AVISO: Alguns arquivos não puderam ser verificados"
    fi
fi

# RESULTADO FINAL
echo ""
echo -e "${GREEN}✅ Exportação concluída!${NC}"
log "INFO: === Exportação concluída ==="

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
echo -e "  Archive: ${OP_ARCHIVE_DIR}"
echo -e "${BLUE}📝 Log: ${LOG_FILE}${NC}"
echo -e "${GREEN}✅ Processo concluído com sucesso!${NC}"

# Estatísticas
echo ""
echo -e "${BLUE}📈 Estatísticas:${NC}"
if [[ -f "${OP_MACOS_DIR}/${OP_MACOS_VAULT}.csv" ]]; then
    MACOS_COUNT=$(tail -n +2 "${OP_MACOS_DIR}/${OP_MACOS_VAULT}.csv" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${OP_MACOS_VAULT}: ${MACOS_COUNT} itens"
fi
if [[ -f "${OP_VPS_DIR}/${OP_VPS_VAULT}.csv" ]]; then
    VPS_COUNT=$(tail -n +2 "${OP_VPS_DIR}/${OP_VPS_VAULT}.csv" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${OP_VPS_VAULT}: ${VPS_COUNT} itens"
fi

