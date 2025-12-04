#!/bin/bash
#
# Script: deploy_antigravity_macos.sh
# Descrição: Executa a demonstração do "antigravity" em macOS.
#
# Autor: Gemini
# Data: 2025-12-02
# Versão: 1.0.0

# --- Variáveis ---
LOG_FILE="../logs/antigravity_deploy_$(date +%Y%m%d_%H%M%S).log"
URL="https://xkcd.com/353/"

# --- Funções ---

# Função para registrar mensagens com data e hora
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Função para verificar o sistema operacional
check_os() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log "ERRO: Este script foi projetado para ser executado apenas no macOS."
        exit 1
    fi
    log "INFO: Verificação do sistema operacional (macOS) bem-sucedida."
}

# Função principal de deploy
deploy_antigravity() {
    log "INFO: Iniciando o deploy do 'antigravity'."
    
    log "INFO: Tentando abrir a URL: $URL"
    open "$URL"
    
    if [[ $? -eq 0 ]]; then
        log "SUCESSO: A URL do 'antigravity' (XKCD 353) foi aberta no navegador padrão."
        echo "Demonstração 'antigravity' concluída com sucesso!"
    else
        log "ERRO: Falha ao tentar abrir a URL no navegador."
        echo "Ocorreu um erro. Verifique os logs em: $LOG_FILE"
        exit 1
    fi
}

# --- Execução ---

# Garante que o diretório de log exista
mkdir -p "$(dirname "$LOG_FILE")"

log "============================================="
log "Início do Script de Deploy Antigravity"
log "============================================="

check_os
deploy_antigravity

log "============================================="
log "Fim do Script de Deploy Antigravity"
log "============================================="

exit 0
