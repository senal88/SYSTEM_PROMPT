#!/bin/bash
# Script de manutenção de rede confiável
# Executa verificações periódicas e corrige problemas comuns

DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
ACTIVE_INTERFACE=$(route get default 2>/dev/null | grep "interface" | awk '{print $2}' || echo "")
SERVICE_NAME=$(networksetup -listnetworkserviceorder | grep "$ACTIVE_INTERFACE" | awk -F  "(, )|(: )|[)]" '{print $2}' || echo "")

if [ -n "$SERVICE_NAME" ]; then
    # Verificar e corrigir DNS se necessário
    CURRENT_DNS=$(networksetup -getdnsservers "$SERVICE_NAME" 2>/dev/null || echo "")
    if [ -z "$CURRENT_DNS" ] || [ "$CURRENT_DNS" == "There aren't any DNS Servers set on $SERVICE_NAME." ]; then
        networksetup -setdnsservers "$SERVICE_NAME" 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1 2>/dev/null || true
    fi
fi
