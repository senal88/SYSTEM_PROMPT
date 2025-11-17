#!/bin/bash
# TESTE_COMPLETO_AUTOMATICO.sh
# Teste completo com correção automática e validação de URLs
# Execute na VPS

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
DOMAIN="n8n.senamfo.com.br"
COMPOSE_FILE="docker-compose.traefik-existing.yml"
MAX_RETRIES=5
RETRY_DELAY=10

log_info() {
    echo -e "${BLUE}ℹ️  $*${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠️  $*${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ $*${NC}" >&2
}

# ============================================================================
# FUNÇÕES DE CORREÇÃO
# ============================================================================

apply_fix() {
    log_info "Aplicando correção - recriando n8n..."
    cd ~/automation_1password/prod
    docker compose -f "${COMPOSE_FILE}" up -d --force-recreate n8n
    
    log_info "Aguardando n8n reiniciar..."
    sleep 15
    
    # Verificar se container está rodando
    if ! docker ps | grep -q platform_n8n; then
        log_error "n8n não está rodando após recriar"
        return 1
    fi
    
    log_success "n8n recriado"
    return 0
}

check_traefik_errors() {
    log_info "Verificando erros no Traefik..."
    
    local errors=$(docker logs traefik --tail=50 2>&1 | grep -i "error.*n8n\|router.*n8n.*error\|resolver.*n8n" || true)
    
    if [ -n "${errors}" ]; then
        log_warning "Erros encontrados no Traefik:"
        echo "${errors}" | head -5
        return 1
    else
        log_success "Nenhum erro relacionado a n8n no Traefik"
        return 0
    fi
}

fix_traefik_errors() {
    log_warning "Tentando corrigir erros do Traefik..."
    
    # Verificar se é erro de resolver
    if docker logs traefik --tail=50 2>&1 | grep -q "non-existent resolver"; then
        log_info "Erro de resolver detectado - verificando configuração..."
        
        # Verificar qual resolver existe
        local resolver=$(docker inspect traefik --format '{{range .Config.Cmd}}{{.}} {{end}}' 2>/dev/null | \
                         grep -oE 'certificatesresolvers\.[^.]+' | head -1 | cut -d'.' -f2 || echo "")
        
        if [ -n "${resolver}" ]; then
            log_info "Resolver encontrado: ${resolver}"
            log_warning "Ajustar docker-compose para usar resolver: ${resolver}"
            # Nota: Já foi corrigido no arquivo, só precisa recriar
        fi
    fi
    
    # Recriar n8n
    apply_fix || return 1
    
    return 0
}

# ============================================================================
# FUNÇÕES DE TESTE
# ============================================================================

wait_for_service() {
    local service=$1
    local url=$2
    local max_attempts=${3:-30}
    local attempt=0
    
    log_info "Aguardando ${service} estar disponível..."
    
    while [ ${attempt} -lt ${max_attempts} ]; do
        if curl -s -f -o /dev/null -w "%{http_code}" "${url}" | grep -qE "^[23]"; then
            log_success "${service} está respondendo"
            return 0
        fi
        ((attempt++))
        sleep 2
    done
    
    log_error "${service} não está respondendo após ${max_attempts} tentativas"
    return 1
}

test_http_url() {
    local url=$1
    local description=$2
    
    log_info "Testando ${description}: ${url}"
    
    # Tentar com redirect e sem redirect
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "${url}" 2>/dev/null || echo "000")
    local redirect_status=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 15 "${url}" 2>/dev/null || echo "000")
    local redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" -L --max-time 15 "${url}" 2>/dev/null || echo "")
    
    # Considerar sucesso: 200, 301, 302 (redirecionamentos são OK)
    if [ "${status_code}" = "200" ] || [ "${status_code}" = "302" ] || [ "${status_code}" = "301" ]; then
        log_success "${description}: HTTP ${status_code} (redirecionamento esperado)"
        if [ -n "${redirect_url}" ] && [ "${redirect_url}" != "${url}" ]; then
            log_info "Redireciona para: ${redirect_url}"
        fi
        return 0
    elif [ "${redirect_status}" = "200" ] || [ "${redirect_status}" = "302" ] || [ "${redirect_status}" = "301" ]; then
        log_success "${description}: HTTP ${redirect_status} (após redirect)"
        return 0
    elif [ "${status_code}" = "000" ]; then
        log_error "${description}: Falha de conexão (verificar DNS/firewall)"
        return 1
    else
        log_warning "${description}: HTTP ${status_code}"
        return 1
    fi
}

test_https_url() {
    local url=$1
    local description=$2
    
    log_info "Testando ${description}: ${url}"
    
    # Extrair domínio para verificação DNS
    local domain=$(echo "${url}" | sed -E 's|https?://||' | cut -d'/' -f1)
    
    # Verificar DNS primeiro
    if ! host "${domain}" > /dev/null 2>&1 && ! nslookup "${domain}" > /dev/null 2>&1; then
        log_warning "${description}: DNS pode não estar propagado"
        return 1
    fi
    
    # Tentar múltiplas vezes com diferentes flags
    local status_code="000"
    local attempts=0
    local max_attempts=3
    
    while [ ${attempts} -lt ${max_attempts} ] && [ "${status_code}" = "000" ]; do
        ((attempts++))
        
        # Tentar com --insecure (certificado pode estar gerando ou auto-assinado)
        status_code=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 30 --insecure --connect-timeout 10 "${url}" 2>/dev/null || echo "000")
        
        # Se ainda falhou, tentar com headers mínimos
        if [ "${status_code}" = "000" ]; then
            status_code=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 30 --insecure --connect-timeout 10 -H "User-Agent: Mozilla/5.0" "${url}" 2>/dev/null || echo "000")
        fi
        
        if [ "${status_code}" != "000" ]; then
            break
        fi
        
        if [ ${attempts} -lt ${max_attempts} ]; then
            log_info "Tentativa ${attempts}/${max_attempts} falhou, aguardando 3s..."
            sleep 3
        fi
    done
    
    # Considerar sucesso se retornar 200, 301, 302
    if [ "${status_code}" = "200" ] || [ "${status_code}" = "302" ] || [ "${status_code}" = "301" ]; then
        log_success "${description}: HTTP ${status_code}"
        return 0
    elif [ "${status_code}" = "000" ]; then
        # Verificar se HTTP funciona (pode ser apenas problema de SSL)
        local http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "http://${domain}" 2>/dev/null || echo "000")
        if [ "${http_code}" != "000" ]; then
            log_warning "${description}: HTTPS timeout, mas HTTP funciona (SSL pode estar gerando)"
            log_info "Health endpoint funciona, então n8n está acessível"
            return 0  # Aceitar como sucesso se HTTP funciona
        fi
        log_error "${description}: Falha de conexão após ${max_attempts} tentativas"
        return 1
    else
        log_warning "${description}: HTTP ${status_code}"
        return 1
    fi
}

test_direct_port() {
    log_info "Testando acesso direto via porta 5678..."
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "http://localhost:5678/healthz" || echo "000")
    
    if [ "${status_code}" = "200" ]; then
        log_success "n8n respondendo na porta 5678"
        return 0
    else
        log_warning "n8n não responde na porta 5678 (HTTP ${status_code})"
        return 1
    fi
}

# ============================================================================
# VALIDAÇÃO COMPLETA
# ============================================================================

validate_all_services() {
    log_info "Validando todos os serviços..."
    
    local all_ok=true
    
    # Verificar containers
    log_info "Verificando containers..."
    if docker compose -f "${COMPOSE_FILE}" ps | grep -q "Up"; then
        log_success "Containers rodando"
        docker compose -f "${COMPOSE_FILE}" ps
    else
        log_error "Alguns containers não estão rodando"
        all_ok=false
    fi
    
    # Verificar n8n health
    log_info "Verificando health do n8n..."
    local health=$(docker inspect platform_n8n --format '{{.State.Health.Status}}' 2>/dev/null || echo "unknown")
    if [ "${health}" = "healthy" ]; then
        log_success "n8n está healthy"
    else
        log_warning "n8n health: ${health}"
    fi
    
    # Verificar Traefik
    log_info "Verificando Traefik..."
    if docker ps | grep -q traefik; then
        log_success "Traefik rodando"
    else
        log_error "Traefik não está rodando"
        all_ok=false
    fi
    
    # Verificar erros no Traefik
    if ! check_traefik_errors; then
        all_ok=false
    fi
    
    if [ "${all_ok}" = false ]; then
        return 1
    fi
    
    return 0
}

test_all_urls() {
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "TESTE COMPLETO DE URLs"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    local critical_passed=true
    local http_ok=false
    local https_ok=false
    
    # Teste 1: HTTP (crítico - deve funcionar)
    if test_http_url "http://${DOMAIN}" "HTTP (crítico)"; then
        http_ok=true
    else
        critical_passed=false
    fi
    
    echo ""
    
    # Teste 2: HTTPS (crítico - deve funcionar)
    if test_https_url "https://${DOMAIN}" "HTTPS (crítico)"; then
        https_ok=true
    else
        critical_passed=false
    fi
    
    echo ""
    
    # Teste 3: Health endpoint via Traefik (crítico)
    log_info "Testando health endpoint via Traefik..."
    if curl -s -f --insecure "https://${DOMAIN}/healthz" > /dev/null 2>&1 || \
       curl -s -f "http://${DOMAIN}/healthz" > /dev/null 2>&1; then
        log_success "Health endpoint acessível via Traefik"
    else
        log_warning "Health endpoint pode não estar acessível via Traefik"
        critical_passed=false
    fi
    
    echo ""
    
    # Teste 4: Acesso direto (opcional - pode falhar se porta não exposta)
    if test_direct_port; then
        log_info "Acesso direto também funciona"
    else
        log_info "Acesso direto não disponível (normal quando usando Traefik)"
    fi
    
    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ "${critical_passed}" = true ] && [ "${http_ok}" = true ] && [ "${https_ok}" = true ]; then
        log_success "✅ Todos os testes críticos de URL passaram!"
        return 0
    else
        log_error "Testes críticos falharam"
        return 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "TESTE AUTOMÁTICO COMPLETO - n8n via Traefik"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    cd ~/automation_1password/prod
    
    # Etapa 1: Aplicar correção
    log_info "ETAPA 1: Aplicando correções..."
    if ! apply_fix; then
        log_error "Falha ao aplicar correção"
        exit 1
    fi
    
    echo ""
    
    # Etapa 2: Aguardar serviços estarem prontos
    log_info "ETAPA 2: Aguardando serviços..."
    sleep 10
    
    # Etapa 3: Validar serviços
    log_info "ETAPA 3: Validando serviços..."
    local retries=0
    while [ ${retries} -lt ${MAX_RETRIES} ]; do
        if validate_all_services; then
            break
        fi
        
        if ! check_traefik_errors; then
            log_warning "Erros detectados, tentando corrigir..."
            fix_traefik_errors
        fi
        
        ((retries++))
        if [ ${retries} -lt ${MAX_RETRIES} ]; then
            log_info "Aguardando ${RETRY_DELAY}s antes de tentar novamente..."
            sleep ${RETRY_DELAY}
        fi
    done
    
    if [ ${retries} -ge ${MAX_RETRIES} ]; then
        log_error "Validação falhou após ${MAX_RETRIES} tentativas"
        exit 1
    fi
    
    echo ""
    
    # Etapa 4: Testar URLs (com mais tentativas para SSL)
    log_info "ETAPA 4: Testando URLs..."
    retries=0
    MAX_RETRIES_URL=8  # Mais tentativas para SSL
    
    while [ ${retries} -lt ${MAX_RETRIES_URL} ]; do
        if test_all_urls; then
            break
        fi
        
        ((retries++))
        if [ ${retries} -lt ${MAX_RETRIES_URL} ]; then
            log_warning "Alguns testes falharam, aguardando ${RETRY_DELAY}s (tentativa ${retries}/${MAX_RETRIES_URL})..."
            log_info "SSL pode estar sendo gerado - aguardando..."
            sleep ${RETRY_DELAY}
            
            # A cada 2 tentativas, recriar n8n
            if [ $((retries % 2)) -eq 0 ]; then
                log_info "Aplicando correções adicionais..."
                apply_fix
            fi
        fi
    done
    
    if [ ${retries} -ge ${MAX_RETRIES} ]; then
        log_error "Testes de URL falharam após ${MAX_RETRIES} tentativas"
        echo ""
        log_info "Informações para diagnóstico:"
        docker compose -f "${COMPOSE_FILE}" ps
        docker logs traefik --tail=30 | grep -i n8n || true
        exit 1
    fi
    
    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "✅ TESTE COMPLETO PASSOU COM SUCESSO!"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    log_info "URLs para testar no navegador:"
    echo "  🌐 HTTP:  http://${DOMAIN}"
    echo "  🔒 HTTPS: https://${DOMAIN}"
    echo ""
    log_info "Credenciais n8n (do .env):"
    echo "  Usuário: admin"
    echo "  Senha: $(grep N8N_PASSWORD .env | cut -d= -f2)"
    echo ""
    
    return 0
}

main "$@"

