#!/usr/bin/env bash

# Auditoria consolidada de SSH + 1Password
# Contexto: macOS Silicon (luiz.sena88) + 1Password SSH Agent + VPS/ GitHub/ Hugging Face

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${BASE_DIR}/logs/ssh"
mkdir -p "${LOG_DIR}"

LOG_FILE="${LOG_DIR}/ssh-audit_$(date +%Y%m%d_%H%M%S).log"

{
    echo "=================================================="
    echo "AUDITORIA SSH - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "BASE_DIR=${BASE_DIR}"
    echo "=================================================="
    echo

    echo "--------------------------------------------------"
    echo "[1] Ambiente SSH e agente 1Password"
    echo "--------------------------------------------------"
    echo "SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-<vazio>}"

    if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "${SSH_AUTH_SOCK}" ]; then
        echo "Socket SSH detectado:"
        ls -l "${SSH_AUTH_SOCK}" || echo "Falha ao inspecionar SSH_AUTH_SOCK"
    else
        echo "Nenhum socket SSH válido detectado em SSH_AUTH_SOCK."
    fi

    echo
    echo "--------------------------------------------------"
    echo "[2] Conteúdo de ~/.ssh"
    echo "--------------------------------------------------"
    if [ -d "${HOME}/.ssh" ]; then
        ls -la "${HOME}/.ssh" || echo "Falha ao listar ~/.ssh"
    else
        echo "Diretório ~/.ssh não existe."
    fi

    echo
    echo "--------------------------------------------------"
    echo "[3] Conteúdo atual de ~/.ssh/config"
    echo "--------------------------------------------------"
    if [ -f "${HOME}/.ssh/config" ]; then
        cat "${HOME}/.ssh/config"
    else
        echo "Arquivo ~/.ssh/config inexistente."
    fi

    echo
    echo "--------------------------------------------------"
    echo "[4] ssh -G github.com (parâmetros efetivos)"
    echo "--------------------------------------------------"
    ssh -G github.com 2>/dev/null | sed -n '1,80p' || echo "Falha ao obter ssh -G github.com"

    echo
    echo "--------------------------------------------------"
    echo "[5] ssh -G admin-vps (parâmetros efetivos)"
    echo "--------------------------------------------------"
    ssh -G admin-vps 2>/dev/null | sed -n '1,80p' || echo "Falha ao obter ssh -G admin-vps"

    echo
    echo "--------------------------------------------------"
    echo "[6] ssh -G vps (parâmetros efetivos)"
    echo "--------------------------------------------------"
    ssh -G vps 2>/dev/null | sed -n '1,80p' || echo "Falha ao obter ssh -G vps"

    echo
    echo "--------------------------------------------------"
    echo "[7] Testes de conexão simbólicos (sem abortar em caso de falha)"
    echo "--------------------------------------------------"

    echo
    echo ">>> Teste: GitHub (ssh -T git@github.com)"
    ssh -T git@github.com 2>&1 || echo "ssh -T git@github.com retornou código de erro (esperado se não houver TTY ou se for apenas teste)."

    echo
    echo ">>> Teste: VPS root (ssh vps 'hostname; whoami')"
    ssh vps 'hostname; whoami' 2>&1 || echo "ssh vps retornou código de erro."

    echo
    echo ">>> Teste: VPS admin (ssh admin-vps 'hostname; whoami')"
    ssh admin-vps 'hostname; whoami' 2>&1 || echo "ssh admin-vps retornou código de erro."

    echo
    echo "--------------------------------------------------"
    echo "[8] Resumo final"
    echo "--------------------------------------------------"
    echo "Log gerado em: ${LOG_FILE}"
    echo "Auditoria concluída."
    echo "=================================================="
} | tee "${LOG_FILE}"
