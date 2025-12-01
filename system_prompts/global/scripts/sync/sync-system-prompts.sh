#!/usr/bin/env bash
################################################################################
# 🔄 SCRIPT DE SINCRONIZAÇÃO BIDIRECIONAL - SISTEMA DE PROMPTS GLOBAL
#
# DESCRIÇÃO:
#   Sincroniza o sistema de prompts entre macOS e VPS Ubuntu de forma
#   bidirecional, com validação de integridade, detecção de conflitos e
#   backups automáticos.
#
# VERSÃO: 1.0.0
# DATA: 2025-01-15
# STATUS: ATIVO
################################################################################

set -euo pipefail

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_DOTFILES="${VPS_DOTFILES:-/home/admin/Dotfiles}"
VPS_SYSTEM_PROMPTS="${VPS_DOTFILES}/system_prompts/global"
MACOS_SYSTEM_PROMPTS="${DOTFILES_DIR}/system_prompts/global"
BACKUP_DIR="${MACOS_SYSTEM_PROMPTS}/logs/backups"
LOG_FILE="${MACOS_SYSTEM_PROMPTS}/logs/sync-$(date +%Y%m%d_%H%M%S).log"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Funções de log
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
        "DEBUG")
            echo -e "${CYAN}[DEBUG]${NC} ${message}" | tee -a "${LOG_FILE}"
            ;;
    esac

    echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Validar conexão SSH
validate_ssh() {
    log "INFO" "Testando conexão SSH com ${VPS_USER}@${VPS_HOST}..."
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log "SUCCESS" "Conexão SSH estabelecida"
        return 0
    else
        log "ERROR" "Não foi possível conectar via SSH"
        log "INFO" "Verifique:"
        log "INFO" "  - Alias SSH: ssh ${VPS_HOST}"
        log "INFO" "  - Chaves SSH autorizadas"
        log "INFO" "  - Host acessível"
        return 1
    fi
}

# Criar backup
create_backup() {
    local location="$1"
    local backup_name="backup-$(date +%Y%m%d_%H%M%S)"

    log "INFO" "Criando backup em ${location}..."

    if [[ "$location" == "macos" ]]; then
        mkdir -p "${BACKUP_DIR}"
        rsync -av --exclude='logs/' --exclude='audit/' "${MACOS_SYSTEM_PROMPTS}/" "${BACKUP_DIR}/${backup_name}/" || {
            log "ERROR" "Falha ao criar backup macOS"
            return 1
        }
        log "SUCCESS" "Backup macOS criado: ${BACKUP_DIR}/${backup_name}"
    elif [[ "$location" == "vps" ]]; then
        ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_SYSTEM_PROMPTS}/logs/backups" || true
        ssh "${VPS_USER}@${VPS_HOST}" "rsync -av --exclude='logs/' --exclude='audit/' ${VPS_SYSTEM_PROMPTS}/ ${VPS_SYSTEM_PROMPTS}/logs/backups/${backup_name}/" || {
            log "ERROR" "Falha ao criar backup VPS"
            return 1
        }
        log "SUCCESS" "Backup VPS criado: ${VPS_SYSTEM_PROMPTS}/logs/backups/${backup_name}"
    fi
}

# Gerar checksum de arquivo
generate_checksum() {
    local file="$1"
    if [[ -f "$file" ]]; then
        sha256sum "$file" | cut -d' ' -f1
    else
        echo ""
    fi
}

# Detectar diferenças
detect_differences() {
    local macos_file="$1"
    local vps_file="$2"

    if [[ ! -f "$macos_file" ]] && ssh "${VPS_USER}@${VPS_HOST}" "test -f ${vps_file}" >/dev/null 2>&1; then
        echo "missing_macos"
    elif [[ -f "$macos_file" ]] && ! ssh "${VPS_USER}@${VPS_HOST}" "test -f ${vps_file}" >/dev/null 2>&1; then
        echo "missing_vps"
    elif [[ -f "$macos_file" ]] && ssh "${VPS_USER}@${VPS_HOST}" "test -f ${vps_file}" >/dev/null 2>&1; then
        local macos_checksum=$(generate_checksum "$macos_file")
        local vps_checksum=$(ssh "${VPS_USER}@${VPS_HOST}" "sha256sum ${vps_file} 2>/dev/null | cut -d' ' -f1")

        if [[ "$macos_checksum" != "$vps_checksum" ]]; then
            echo "different"
        else
            echo "identical"
        fi
    else
        echo "missing_both"
    fi
}

# Sincronizar push (macOS → VPS)
sync_push() {
    print_header "🔄 SINCRONIZAÇÃO PUSH (macOS → VPS)"

    if ! validate_ssh; then
        return 1
    fi

    log "INFO" "Iniciando sincronização push..."

    # Criar backup na VPS
    create_backup "vps"

    # Criar estrutura na VPS se não existir
    ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_SYSTEM_PROMPTS}/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections,guides},scripts/{sync,install,validate,test},governance/{rules,validation},consolidated,audit,logs,templates}"

    # Sincronizar arquivos (usando rsync para eficiência)
    log "INFO" "Sincronizando arquivos para VPS..."

    rsync -avz --progress \
        --exclude='logs/backups/' \
        --exclude='audit/' \
        --exclude='*.log' \
        "${MACOS_SYSTEM_PROMPTS}/" "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/" || {
        log "ERROR" "Falha ao sincronizar arquivos"
        return 1
    }

    # Configurar permissões
    log "INFO" "Configurando permissões na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "find ${VPS_SYSTEM_PROMPTS}/scripts -type f -name '*.sh' -exec chmod +x {} \;"

    log "SUCCESS" "Sincronização push concluída!"
    return 0
}

# Sincronizar pull (VPS → macOS)
sync_pull() {
    print_header "🔄 SINCRONIZAÇÃO PULL (VPS → macOS)"

    if ! validate_ssh; then
        return 1
    fi

    log "INFO" "Iniciando sincronização pull..."

    # Criar backup no macOS
    create_backup "macos"

    # Criar estrutura local se não existir
    mkdir -p "${MACOS_SYSTEM_PROMPTS}/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections,guides},scripts/{sync,install,validate,test},governance/{rules,validation},consolidated,audit,logs,templates}"

    # Sincronizar arquivos
    log "INFO" "Sincronizando arquivos da VPS..."

    rsync -avz --progress \
        --exclude='logs/backups/' \
        --exclude='audit/' \
        --exclude='*.log' \
        "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/" "${MACOS_SYSTEM_PROMPTS}/" || {
        log "ERROR" "Falha ao sincronizar arquivos"
        return 1
    }

    # Configurar permissões
    log "INFO" "Configurando permissões localmente..."
    find "${MACOS_SYSTEM_PROMPTS}/scripts" -type f -name "*.sh" -exec chmod +x {} \;

    log "SUCCESS" "Sincronização pull concluída!"
    return 0
}

# Sincronizar bidirecional
sync_bidirectional() {
    print_header "🔄 SINCRONIZAÇÃO BIDIRECIONAL"

    if ! validate_ssh; then
        return 1
    fi

    log "INFO" "Analisando diferenças..."

    # Lista de arquivos para comparar
    local files_to_check=(
        "prompts/system/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md"
        "prompts/audit/PROMPT_AUDITORIA_VPS.md"
        "README.md"
        "CHANGELOG.md"
    )

    local conflicts=()

    # Verificar cada arquivo
    for file in "${files_to_check[@]}"; do
        local macos_file="${MACOS_SYSTEM_PROMPTS}/${file}"
        local vps_file="${VPS_SYSTEM_PROMPTS}/${file}"

        local status=$(detect_differences "$macos_file" "$vps_file")

        case "$status" in
            "different")
                log "WARNING" "Conflito detectado: ${file}"
                conflicts+=("$file")
                ;;
            "missing_macos")
                log "INFO" "Arquivo existe apenas na VPS: ${file} (será copiado para macOS)"
                ;;
            "missing_vps")
                log "INFO" "Arquivo existe apenas no macOS: ${file} (será copiado para VPS)"
                ;;
            "identical")
                log "DEBUG" "Arquivo idêntico: ${file}"
                ;;
        esac
    done

    # Se houver conflitos, reportar
    if [[ ${#conflicts[@]} -gt 0 ]]; then
        log "WARNING" "Conflitos detectados (${#conflicts[@]} arquivos):"
        for conflict in "${conflicts[@]}"; do
            log "WARNING" "  - ${conflict}"
        done
        log "INFO" "Execute sync push ou pull individualmente para resolver conflitos"
        return 1
    fi

    # Sincronizar arquivos faltantes
    log "INFO" "Sincronizando arquivos faltantes..."

    # Push primeiro (macOS → VPS)
    sync_push

    # Pull depois (VPS → macOS)
    sync_pull

    log "SUCCESS" "Sincronização bidirecional concluída!"
    return 0
}

# Dry-run (simulação)
dry_run() {
    print_header "🔍 DRY-RUN (Simulação)"

    if ! validate_ssh; then
        return 1
    fi

    log "INFO" "Simulando sincronização (sem fazer alterações)..."

    # Listar arquivos que seriam sincronizados
    log "INFO" "Arquivos que seriam sincronizados no push:"
    rsync -avn --exclude='logs/' --exclude='audit/' "${MACOS_SYSTEM_PROMPTS}/" "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/" | grep -E '^(sending|^[^/].*$)' || true

    log "INFO" "Arquivos que seriam sincronizados no pull:"
    rsync -avn --exclude='logs/' --exclude='audit/' "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/" "${MACOS_SYSTEM_PROMPTS}/" | grep -E '^(receiving|^[^/].*$)' || true

    log "SUCCESS" "Dry-run concluído!"
    return 0
}

# Validar integridade
validate_integrity() {
    print_header "✅ VALIDAÇÃO DE INTEGRIDADE"

    if ! validate_ssh; then
        return 1
    fi

    log "INFO" "Validando integridade dos arquivos..."

    # Gerar checksums no macOS
    local macos_checksums="${MACOS_SYSTEM_PROMPTS}/logs/checksums-macos.txt"
    find "${MACOS_SYSTEM_PROMPTS}" -type f -not -path "*/logs/*" -not -path "*/audit/*" -exec sha256sum {} \; > "${macos_checksums}"

    # Gerar checksums na VPS
    local vps_checksums="${MACOS_SYSTEM_PROMPTS}/logs/checksums-vps.txt"
    ssh "${VPS_USER}@${VPS_HOST}" "find ${VPS_SYSTEM_PROMPTS} -type f -not -path '*/logs/*' -not -path '*/audit/*' -exec sha256sum {} \;" > "${vps_checksums}"

    # Comparar checksums
    if diff -q "${macos_checksums}" "${vps_checksums}" >/dev/null 2>&1; then
        log "SUCCESS" "Integridade validada: todos os arquivos são idênticos"
        rm -f "${macos_checksums}" "${vps_checksums}"
        return 0
    else
        log "WARNING" "Diferenças detectadas na integridade"
        log "INFO" "Verificar logs: ${macos_checksums} e ${vps_checksums}"
        return 1
    fi
}

# Menu principal
main() {
    local command="${1:-help}"

    # Criar diretório de logs
    mkdir -p "$(dirname "${LOG_FILE}")"

    case "$command" in
        "push")
            sync_push
            ;;
        "pull")
            sync_pull
            ;;
        "sync")
            sync_bidirectional
            ;;
        "dry-run")
            dry_run
            ;;
        "validate")
            validate_integrity
            ;;
        "help"|*)
            print_header "🔄 SINCRONIZAÇÃO BIDIRECIONAL - SISTEMA DE PROMPTS"
            echo ""
            echo "Uso: $0 [comando]"
            echo ""
            echo "Comandos disponíveis:"
            echo "  push       - Sincronizar macOS → VPS (envia alterações do macOS)"
            echo "  pull       - Sincronizar VPS → macOS (busca alterações da VPS)"
            echo "  sync       - Sincronização bidirecional (detecta e resolve conflitos)"
            echo "  dry-run    - Simular sincronização sem fazer alterações"
            echo "  validate   - Validar integridade dos arquivos sincronizados"
            echo "  help       - Mostrar esta ajuda"
            echo ""
            echo "Variáveis de ambiente:"
            echo "  VPS_HOST         - Host SSH da VPS (padrão: admin-vps)"
            echo "  VPS_USER         - Usuário SSH (padrão: admin)"
            echo "  VPS_DOTFILES     - Caminho Dotfiles na VPS (padrão: /home/admin/Dotfiles)"
            echo "  DOTFILES_DIR     - Caminho Dotfiles local (padrão: ~/Dotfiles)"
            echo ""
            echo "Logs: ${LOG_FILE}"
            echo ""
            ;;
    esac
}

main "$@"
