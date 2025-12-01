#!/usr/bin/env bash
set -euo pipefail

# Script: master-update.sh
# Objetivo:
# - Orquestrar a execução de scripts de manutenção e governança.

BASE_DIR=$(dirname "$0")

echo "=================================================="
echo "INICIANDO EXECUÇÃO MASTER DE ATUALIZAÇÃO"
echo "=================================================="
echo

# --- Etapa 1: Aplicar Governança de Nomes ---
# Temporariamente desabilitado para evitar re-execução
# echo "--> Etapa 1: Aplicando governança de nomes..."
# DRY_RUN=0 "${BASE_DIR}/atualizar-nomes-governanca_v1.0.0_20251130.sh"
# echo "Governança de nomes aplicada."
# echo

# --- Etapa 2: Identificar Pastas Vazias ---
echo "--> Etapa 2: Identificando pastas vazias..."
"${BASE_DIR}/encontrar-pastas-vazias.sh"
echo "Busca por pastas vazias concluída."
echo

echo "=================================================="
echo "EXECUÇÃO MASTER CONCLUÍDA"
echo "=================================================="