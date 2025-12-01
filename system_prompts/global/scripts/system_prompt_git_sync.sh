#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# CONFIGURAÇÃO
###############################################################################

# Caminho local onde o repositório SYSTEM_PROMPT está clonado.
# Preencha com o caminho EXATO do clone local desse repositório.
SYSTEM_PROMPT_REPO_DIR="/Users/luiz.sena88/Dotfiles"

# Branch padrão de trabalho (ex.: main).
SYSTEM_PROMPT_BRANCH="main"

# URLs aceitáveis para o remote origin do repositório SYSTEM_PROMPT.
# Você pode manter as duas opções (SSH e HTTPS) e usar a que já estiver configurada.
SYSTEM_PROMPT_REMOTE_SSH="git@github.com:senal88/SYSTEM_PROMPT.git"
SYSTEM_PROMPT_REMOTE_HTTPS="https://github.com/senal88/SYSTEM_PROMPT.git"

###############################################################################
# VALIDAÇÕES BÁSICAS
###############################################################################

if [ -z "${SYSTEM_PROMPT_REPO_DIR}" ] || [ "${SYSTEM_PROMPT_REPO_DIR}" = "{{SYSTEM_PROMPT_REPO_DIR}}" ]; then
  echo "[ERRO] Variável SYSTEM_PROMPT_REPO_DIR não configurada."
  echo "       Edite o arquivo scripts/system_prompt_git_sync.sh e defina o caminho local do clone do repositório SYSTEM_PROMPT."
  exit 1
fi

if [ -z "${SYSTEM_PROMPT_BRANCH}" ] || [ "${SYSTEM_PROMPT_BRANCH}" = "{{SYSTEM_PROMPT_BRANCH}}" ]; then
  echo "[ERRO] Variável SYSTEM_PROMPT_BRANCH não configurada."
  echo "       Edite o arquivo scripts/system_prompt_git_sync.sh e defina a branch padrão (ex.: main)."
  exit 1
fi

if [ ! -d "${SYSTEM_PROMPT_REPO_DIR}" ]; then
  echo "[ERRO] Diretório ${SYSTEM_PROMPT_REPO_DIR} não existe."
  echo "       Verifique o caminho configurado em SYSTEM_PROMPT_REPO_DIR."
  exit 1
fi

if [ ! -d "${SYSTEM_PROMPT_REPO_DIR}/.git" ]; then
  echo "[ERRO] Diretório ${SYSTEM_PROMPT_REPO_DIR} não é um repositório Git."
  exit 1
fi

###############################################################################
# NAVEGAR PARA O REPOSITÓRIO
###############################################################################

cd "${SYSTEM_PROMPT_REPO_DIR}"

echo "=================================================="
echo "SYNC SYSTEM_PROMPT - $(date '+%Y-%m-%d %H:%M:%S')"
echo "REPO_DIR: ${SYSTEM_PROMPT_REPO_DIR}"
echo "BRANCH  : ${SYSTEM_PROMPT_BRANCH}"
echo "=================================================="
echo

###############################################################################
# VALIDAR REMOTE ORIGIN
###############################################################################

ORIGIN_URL="$(git remote get-url origin || echo "")"

if [ -z "${ORIGIN_URL}" ]; then
  echo "[ERRO] Remote 'origin' não está configurado neste repositório."
  exit 1
fi

if [ "${ORIGIN_URL}" != "${SYSTEM_PROMPT_REMOTE_SSH}" ] && [ "${ORIGIN_URL}" != "${SYSTEM_PROMPT_REMOTE_HTTPS}" ]; then
  echo "[ERRO] Remote 'origin' não aponta para o repositório SYSTEM_PROMPT esperado."
  echo "       Origin atual : ${ORIGIN_URL}"
  echo "       Esperado (SSH): ${SYSTEM_PROMPT_REMOTE_SSH}"
  echo "       Ou       (HTTPS): ${SYSTEM_PROMPT_REMOTE_HTTPS}"
  echo "       Ajuste o remote antes de rodar este script."
  exit 1
fi

echo "[OK] Remote origin confirmado: ${ORIGIN_URL}"
echo

###############################################################################
# STATUS ANTES DO SYNC
###############################################################################

echo "--------------------------------------------------"
echo "[1] Status atual (antes do sync)"
echo "--------------------------------------------------"
git status
echo

###############################################################################
# ATUALIZAR A PARTIR DO REMOTO (PULL)
###############################################################################

echo "--------------------------------------------------"
echo "[2] git fetch + pull --ff-only origin ${SYSTEM_PROMPT_BRANCH}"
echo "--------------------------------------------------"

git fetch origin "${SYSTEM_PROMPT_BRANCH}"
git pull --ff-only origin "${SYSTEM_PROMPT_BRANCH}"

echo
echo "[OK] Repositório local atualizado a partir do remoto."
echo

###############################################################################
# ADICIONAR E COMMITAR ALTERAÇÕES LOCAIS (SE EXISTIREM)
###############################################################################

echo "--------------------------------------------------"
echo "[3] Verificando alterações locais para commit"
echo "--------------------------------------------------"

# Verifica se existem alterações (rastreadas ou não) no subdiretório específico.
if git status --porcelain system_prompts/global | grep -q .; then
  echo "[INFO] Alterações locais detectadas em 'system_prompts/global'. Preparando commit..."

  git add system_prompts/global

  # Mensagem de commit padrão com timestamp.
  COMMIT_MSG="chore(system_prompt): sync prompts, docs e scripts $(date '+%Y-%m-%d_%H%M%S')"

  # Se ainda houver algo para commitar, o commit será criado.
  if ! git diff --cached --quiet; then
    git commit -m "${COMMIT_MSG}"
    echo "[OK] Commit criado: ${COMMIT_MSG}"

    echo
    echo "--------------------------------------------------"
    echo "[4] Enviando alterações para o remoto (git push)"
    echo "--------------------------------------------------"

    git push origin "${SYSTEM_PROMPT_BRANCH}"
    echo "[OK] Push concluído para origin/${SYSTEM_PROMPT_BRANCH}."
  else
    echo "[INFO] Nenhuma alteração efetiva no índice após 'git add'. Nada para commitar."
  fi
else
  echo "[INFO] Nenhuma alteração local detectada em 'system_prompts/global'. Nada para commitar ou enviar."
fi

###############################################################################
# STATUS FINAL
###############################################################################

echo
echo "--------------------------------------------------"
echo "[5] Status final após sync"
echo "--------------------------------------------------"
git status
echo

echo "=================================================="
echo "SYNC SYSTEM_PROMPT - FINALIZADO COM SUCESSO"
echo "=================================================="
