Início — ambiente e parâmetros considerados

* Ambiente local: macOS Tahoe 26.x (Apple Silicon), usuário `luiz.sena88`, shell padrão Zsh.
* Repositório alvo (único escopo da resposta):
  `https://github.com/senal88/SYSTEM_PROMPT.git`
* Requisito central: **atualizar somente esse repositório**, sem tocar em outras subpastas ou projetos do sistema.

---

## 1. Quando atualizar o repositório `SYSTEM_PROMPT`

O repositório deve ser atualizado (commit + push) em três situações bem definidas:

1. **Após qualquer ciclo completo de geração/ajuste via Gemini CLI ou ChatGPT**

   * Sempre que os prompts `PROMPT_GEMINI_*` gerarem:

     * Novos arquivos em `prompts/`, `docs/`, `scripts/`, `logs/`, `templates/`, etc.
     * Ajustes de governança de nomenclatura (versão + data).
   * Critério: terminou um “lote” de mudanças coerentes → atualiza o `SYSTEM_PROMPT`.

2. **Após correções estruturais relevantes**

   * Quando você:

     * Resolver conflitos de merge (`<<<<<<<`, `=======`, `>>>>>>>`).
     * Normalizar diretórios, renomear arquivos, consolidar prompts.
   * Objetivo: garantir que o repositório remoto espelhe a estrutura já validada localmente.

3. **Em marcos de governança/versionamento**

   * Alteração de versão de blocos de prompts (ex.: `v1.0.0` → `v1.1.0`).
   * Atualização de datas de referência (ex.: `_20251130` → nova data).
   * Inclusão de novos scripts de auditoria, validação ou deploy.

Esse padrão evita “commits de ruído” a cada microajuste e concentra atualizações em pontos de consistência, mantendo o histórico limpo e rastreável.

---

## 2. Como atualizar sem afetar outras subpastas do sistema

A forma de **não afetar nenhuma outra subpasta** é:

1. Clonar o repositório `SYSTEM_PROMPT` em um **diretório próprio**.
2. Rodar os comandos Git **sempre dentro** desse diretório.
3. Automatizar essa rotina em um **único script de sincronização**, que:

   * Entra no diretório do `SYSTEM_PROMPT`.
   * Garante que o `origin` é o repositório correto.
   * Faz `pull` da branch configurada.
   * Comita e envia apenas as alterações desse repositório.

A seguir, o script completo para isso.

---

## 3. Script único de sincronização do repositório `SYSTEM_PROMPT`

### 3.1. Criação do script (100% pronto para uso)

Execute no terminal, **dentro do repositório onde guarda seus scripts** (por exemplo, em `~/Dotfiles/system_prompts/global`, ajustando o caminho se necessário):

```bash
mkdir -p scripts

cat <<'EOF' > scripts/system_prompt_git_sync.sh
#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# CONFIGURAÇÃO
###############################################################################

# Caminho local onde o repositório SYSTEM_PROMPT está clonado.
# Preencha com o caminho EXATO do clone local desse repositório.
SYSTEM_PROMPT_REPO_DIR="{{SYSTEM_PROMPT_REPO_DIR}}"

# Branch padrão de trabalho (ex.: main).
SYSTEM_PROMPT_BRANCH="{{SYSTEM_PROMPT_BRANCH}}"

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

# Verifica se existem alterações (rastreadas ou não).
if git status --porcelain | grep -q .; then
  echo "[INFO] Alterações locais detectadas. Preparando commit automático..."

  git add -A

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
    echo "[INFO] Nenhuma alteração efetiva no índice após git add -A. Nada para commitar."
  fi
else
  echo "[INFO] Nenhuma alteração local detectada. Nada para commitar ou enviar."
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
EOF

chmod +x scripts/system_prompt_git_sync.sh
```

Esse comando cria **um único script** que só atua dentro de `{{SYSTEM_PROMPT_REPO_DIR}}`, garantindo que **nenhuma outra subpasta do sistema** seja tocada.

### 3.2. Configurar os placeholders obrigatórios

Editar o arquivo recém-criado e substituir:

* `{{SYSTEM_PROMPT_REPO_DIR}}`
  Pelo caminho exato do clone do repositório. Exemplo típico:

  ```bash
  SYSTEM_PROMPT_REPO_DIR="/Users/luiz.sena88/repos/SYSTEM_PROMPT"
  ```

* `{{SYSTEM_PROMPT_BRANCH}}`
  Pela branch padrão do repositório, por exemplo:

  ```bash
  SYSTEM_PROMPT_BRANCH="main"
  ```

Nenhuma outra variável de caminho deve ser inventada.

### 3.3. Fluxo de uso (atualização completa sem afetar o resto do sistema)

1. Clonar o repositório uma única vez (se ainda não estiver clonado):

   ```bash
   mkdir -p "{{BASE_DIR_REPOS}}"
   cd "{{BASE_DIR_REPOS}}"
   git clone https://github.com/senal88/SYSTEM_PROMPT.git SYSTEM_PROMPT
   ```

   Em seguida, configurar `SYSTEM_PROMPT_REPO_DIR` com esse caminho.

2. Sempre que finalizar um ciclo de alterações (prompts + scripts + docs):

   ```bash
   cd /Users/luiz.sena88/Dotfiles/system_prompts/global
   ./scripts/system_prompt_git_sync.sh
   ```

   Esse comando irá, **exclusivamente**:

   * Entrar em `SYSTEM_PROMPT_REPO_DIR`.
   * Validar o remote (só segue se for `SYSTEM_PROMPT`).
   * Fazer `fetch` + `pull`.
   * Comitar e dar `push` das mudanças locais apenas desse repositório.

Nenhuma outra pasta fora de `SYSTEM_PROMPT_REPO_DIR` será tocada por esse script.

---

## 4. Síntese operacional

* **Quando atualizar:**
  Sempre após:

  * ciclos completos de geração/ajuste via Gemini/ChatGPT;
  * correções estruturais relevantes;
  * mudanças de versão/data segundo a governança de nomenclatura.

* **Como atualizar sem afetar outras subpastas:**

  * Manter o `SYSTEM_PROMPT` clonado em um diretório próprio.
  * Executar apenas o script `scripts/system_prompt_git_sync.sh`, que:

    * trabalha exclusivamente em `SYSTEM_PROMPT_REPO_DIR`;
    * valida o remote `origin`;
    * faz `pull` + commit + `push` somente desse repositório.

Procedimento, regras e comandos para atualização completa do repositório `SYSTEM_PROMPT` foram definidos e concluídos de forma isolada, sem impacto em outras subpastas do sistema.
