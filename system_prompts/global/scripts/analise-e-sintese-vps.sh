#!/usr/bin/env bash

################################################################################
# 📊 ANÁLISE E SÍNTESE VPS - Gerador de System Prompt VPS
# Analisa dados coletados da VPS e gera system_prompt VPS consolidado
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Analisar e sintetizar dados da VPS para system prompts
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
AUDIT_BASE="${DOTFILES_DIR}/system_prompts/global/audit"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# VALIDAÇÃO
# ============================================================================

validate_audit_exists() {
    if [ ! -d "${AUDIT_BASE}" ]; then
        log_error "Erro: nenhum diretório de auditoria encontrado em ${AUDIT_BASE}"
        log_info "Execute primeiro: ~/Dotfiles/system_prompts/global/scripts/coleta-vps.sh"
        exit 1
    fi

    # Encontrar última auditoria VPS
    LATEST_AUDIT=$(ls -td "${AUDIT_BASE}"/*/vps 2>/dev/null | head -1 | xargs dirname | xargs basename)

    if [ -z "${LATEST_AUDIT}" ]; then
        log_error "Erro: nenhum snapshot de auditoria VPS encontrado em ${AUDIT_BASE}"
        log_info "Execute primeiro: ~/Dotfiles/system_prompts/global/scripts/coleta-vps.sh"
        exit 1
    fi

    echo "${LATEST_AUDIT}"
}

# ============================================================================
# ANÁLISE E SÍNTESE
# ============================================================================

analyze_and_synthesize() {
    local LATEST_AUDIT="$1"
    local AUDIT_DIR="${AUDIT_BASE}/${LATEST_AUDIT}/vps"
    local ANALYSIS_DIR="${DOTFILES_DIR}/system_prompts/global/analysis/${LATEST_AUDIT}"
    local PROMPTS_DIR="${DOTFILES_DIR}/system_prompts/global/prompts/${LATEST_AUDIT}"

    mkdir -p "${ANALYSIS_DIR}" "${PROMPTS_DIR}"

    print_header "📊 ANÁLISE E SÍNTESE - VPS Ubuntu"

    log_info "Analisando auditoria: ${LATEST_AUDIT}"
    log_info "Diretório de auditoria: ${AUDIT_DIR}"

    # Consolidar contexto bruto
    local CONTEXT_FILE="${ANALYSIS_DIR}/CONTEXT_VPS_RAW.txt"
    {
        echo "########################################################"
        echo "# CONTEXTO CONSOLIDADO - VPS Ubuntu senamfo.com.br"
        echo "# SNAPSHOT: ${LATEST_AUDIT}"
        echo "# BASE: ${AUDIT_DIR}"
        echo "# Data de Geração: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "########################################################"
        echo ""

        for f in \
            "01_sistema_hardware.txt" \
            "02_recursos_sistema.txt" \
            "03_processos_top.txt" \
            "04_servicos_ativos.txt" \
            "05_docker_geral.txt" \
            "06_docker_containers.txt" \
            "07_docker_swarm_stacks.txt" \
            "08_docker_networks_volumes.txt" \
            "09_rede_interfaces.txt" \
            "10_rede_portas_ativas.txt" \
            "11_estrutura_diretorios.txt" \
            "12_git_repos.txt" \
            "13_shell_config.txt" \
            "14_pacotes_apt.txt" \
            "15_firewall.txt"
        do
            if [ -f "${AUDIT_DIR}/${f}" ]; then
                echo "=========================================="
                echo "===== ${f} ====="
                echo "=========================================="
                cat "${AUDIT_DIR}/${f}"
                echo ""
                echo ""
            fi
        done
    } > "${CONTEXT_FILE}"

    log_success "Contexto consolidado criado: ${CONTEXT_FILE}"

    # Gerar prompt de sistema
    local PROMPT_FILE="${PROMPTS_DIR}/system_prompt_vps_global_${LATEST_AUDIT}.md"
    cat > "${PROMPT_FILE}" << EOM
# SYSTEM PROMPT — VPS Ubuntu senamfo.com.br

**Versão:** 1.0.0
**Data de Geração:** $(date '+%Y-%m-%d %H:%M:%S')
**Snapshot:** ${LATEST_AUDIT}
**Status:** Ativo

---

## 🎯 IDENTIDADE

Você é um assistente técnico especializado em interpretar, diagnosticar e orientar a gestão da infraestrutura da **VPS Ubuntu senamfo.com.br** (Ubuntu 24.04 LTS).

**Domínio:** senamfo.com.br
**IP:** 147.79.81.59
**Usuário:** admin
**Ambiente:** Produção

---

## 📚 CONTEXTO CONSOLIDADO

Use como base de contexto o arquivo consolidado:

- **CONTEXTO CONSOLIDADO:** \`${CONTEXT_FILE}\`
- **Diretório de Auditoria:** \`${AUDIT_DIR}\`
- **Snapshot:** \`${LATEST_AUDIT}\`

---

## ⚙️ REGRAS DE OPERAÇÃO

### 1. Comunicação

- Responder sempre em **português do Brasil**
- Utilizar termos técnicos em inglês entre parênteses apenas quando necessário para precisão
- Ser técnico, objetivo e completo

### 2. Precisão de Informações

- **Nunca inventar** serviços, containers, stacks ou configurações que não existam no contexto consolidado
- Quando uma informação não estiver presente no contexto:
  - Deixar explícito que "não há dados suficientes no snapshot atual"
  - Se necessário, sugerir nova auditoria ou coleta adicional (sem assumir valores)

### 3. Prioridades

- **Diagnóstico de problemas:** logs, serviços, recursos
- **Organização e documentação:** stacks Docker, Swarm, Traefik, Portainer, n8n, Coolify
- **Propostas de melhoria:** seguras e reversíveis
- **Automação:** scripts, pipelines, CI/CD

### 4. Segurança

- **Nunca propor ações destrutivas** sem listar:
  - Backups recomendados
  - Comandos exatos a serem executados
  - Possíveis efeitos colaterais e como reverter
- **Nunca expor credenciais** em texto claro
- Validar comandos antes de sugerir execução

### 5. Infraestrutura

- **Docker:** Containers, Compose, Swarm (se configurado)
- **Serviços:** Coolify, n8n, Traefik, PostgreSQL, Redis
- **Rede:** Interfaces, portas, firewall (UFW)
- **Sistema:** Ubuntu 24.04 LTS, systemd, APT

---

## 📋 FORMATO PADRÃO DE RESPOSTA

### [Contexto Relevante Detectado]

Resumo do que foi identificado no contexto consolidado relacionado à solicitação.

### [Diagnóstico]

Análise técnica do estado atual, problemas identificados ou oportunidades de melhoria.

### [Plano de Ação por Etapas]

Passos numerados e ordenados para resolver ou implementar.

### [Comandos Sugeridos]

Comandos CLI exatos, prontos para execução (quando aplicável).

### [Validações Pós-Ação]

Como verificar que a ação foi bem-sucedida.

---

## 🔗 REFERÊNCIAS

- **Repositório GitHub:** https://github.com/senal88/infraestrutura-vps
- **Diretório Local:** \`/home/admin/infra-vps\`
- **Dotfiles:** \`/home/admin/Dotfiles\`
- **Documentação:** \`/home/admin/infra-vps/documentacao/\`

---

**Versão:** 1.0.0
**Última Atualização:** $(date '+%Y-%m-%d %H:%M:%S')
**Status:** Ativo e Pronto para Uso

EOM

    log_success "Prompt de sistema gerado: ${PROMPT_FILE}"

    # Criar arquivo consolidado para LLMs (formato texto)
    local LLMS_FILE="${PROMPTS_DIR}/vps-full_${LATEST_AUDIT}.txt"
    {
        echo "=================================================================================="
        echo "SYSTEM PROMPT VPS - LLMS FULL CONSOLIDADO"
        echo "=================================================================================="
        echo ""
        echo "Versão: 1.0.0"
        echo "Data de Geração: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Snapshot: ${LATEST_AUDIT}"
        echo "Fonte: Auditoria completa VPS Ubuntu 24.04 LTS"
        echo ""
        echo "=================================================================================="
        echo "ÍNDICE"
        echo "=================================================================================="
        echo ""
        echo "1. IDENTIDADE E CONTEXTO OPERACIONAL"
        echo "2. AMBIENTE TÉCNICO DETALHADO (VPS Ubuntu)"
        echo "3. INFRAESTRUTURA E SERVIÇOS"
        echo "4. DOCKER E CONTAINERS"
        echo "5. REDE E SEGURANÇA"
        echo "6. ESTRUTURA DE DIRETÓRIOS E REPOSITÓRIOS"
        echo "7. REGRAS DE OPERAÇÃO"
        echo "8. FORMATO PADRÃO DE RESPOSTA"
        echo ""
        echo "=================================================================================="
        echo "CONTEÚDO DETALHADO"
        echo "=================================================================================="
        echo ""
        cat "${CONTEXT_FILE}"
    } > "${LLMS_FILE}"

    log_success "Arquivo consolidado para LLMs gerado: ${LLMS_FILE}"

    echo ""
    log_success "✅ Análise e síntese concluídas com sucesso!"
    echo ""
    log_info "📁 Contexto consolidado: ${CONTEXT_FILE}"
    log_info "📄 Prompt de sistema: ${PROMPT_FILE}"
    log_info "📄 Arquivo LLMs: ${LLMS_FILE}"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "📊 ANÁLISE E SÍNTESE VPS Ubuntu"

    local LATEST_AUDIT=$(validate_audit_exists)
    analyze_and_synthesize "${LATEST_AUDIT}"
}

main "$@"

