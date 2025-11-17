#!/usr/bin/env bash
set -euo pipefail

# collect_system_context.sh
# Gera um relatório detalhado para alimentar templates LLM.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_DIR="${REPO_ROOT}/exports/llm_context"
OUTPUT_FILE="${OUTPUT_DIR}/system_context_${TIMESTAMP}.md"

mkdir -p "${OUTPUT_DIR}"

HOSTNAME="$(hostname)"
OS_NAME="$(sw_vers -productName 2>/dev/null || uname -s)"
OS_VERSION="$(sw_vers -productVersion 2>/dev/null || uname -r)"
ARCH="$(uname -m)"
CPU_MODEL="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || lscpu | grep 'Model name' | cut -d':' -f2-)"
CPU_CORES="$(sysctl -n hw.ncpu 2>/dev/null || nproc)"
RAM_GB="$(python3 - <<'PY'
import platform, subprocess
if platform.system() == "Darwin":
    mem = int(subprocess.check_output(["sysctl", "-n", "hw.memsize"]).decode())
    print(mem // 1024 // 1024 // 1024)
else:
    import psutil
    print(int(psutil.virtual_memory().total // 1024 // 1024 // 1024))
PY
)"
UPTIME_STR="$(uptime)"

mkdir -p "${REPO_ROOT}/reports/macOS"

{
cat <<EOF
# 🧠 CONTEXTO COMPLETO DO SISTEMA - automation_1password

**Gerado:** $(date)  
**Hostname:** ${HOSTNAME}  
**OS:** ${OS_NAME} ${OS_VERSION}  
**Arch:** ${ARCH}

---

## 🔍 METADADOS DO AMBIENTE

### macOS Silicon
- **SO:** ${OS_NAME} ${OS_VERSION}
- **Chip:** ${CPU_MODEL}
- **Cores:** ${CPU_CORES}
- **RAM:** ${RAM_GB} GB
- **Uptime:** ${UPTIME_STR}

### Diretórios Críticos
\`\`\`
$(find "${REPO_ROOT}" -maxdepth 2 -type d | sort)
\`\`\`

---

## 📊 ESTADO ATUAL

### Docker/Colima
\`\`\`bash
$(docker context ls 2>/dev/null || echo "docker context ls indisponível")
$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "docker ps indisponível")
\`\`\`

### 1Password
\`\`\`bash
$(op whoami 2>&1 || echo "op whoami falhou")
$(op vault list --format=table 2>&1 || echo "op vault list falhou")
\`\`\`

### Processos Relevantes
\`\`\`bash
$(ps aux | grep -E 'docker|colima|1[Pp]assword|op ' | grep -v grep)
\`\`\`

---

## 🧪 SERVIÇOS E PORTAS

\`\`\`bash
$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | grep -E ':80|:443|:8080|:5432|:6379' || echo "Nenhuma porta crítica ativa")
\`\`\`

---

## 📦 ESTRUTURA DO PROJETO

### Scripts Disponíveis
$(find "${REPO_ROOT}/scripts" -type f -name "*.sh" | wc -l) scripts encontrados

### Documentação
$(find "${REPO_ROOT}/docs" -type f -name "*.md" | wc -l) documentos encontrados

### Runbooks Críticos
- $(ls -1 "${REPO_ROOT}/docs/runbooks"/*.md 2>/dev/null | sed 's|^.*/|- |')

---

## 🔐 CONFIGURAÇÃO 1PASSWORD

### Vaults Configurados
\`\`\`json
$(jq '.[] | {name, id}' "${REPO_ROOT}/reports/macOS/op_vaults.json" 2>/dev/null || echo "Executar inventário: make inventory-1p")
\`\`\`

### SSH Agent
- **Agent Socket:** ${SSH_AUTH_SOCK:-<não definido>}
- **Chaves Carregadas:**
\`\`\`
$(ssh-add -l 2>&1 || echo "Nenhuma chave carregada")
\`\`\`

---

## ⚙️ VARIÁVEIS DE AMBIENTE CONFIGURADAS

\`\`\`bash
$(head -20 "${REPO_ROOT}/reports/macOS/env_exports.txt" 2>/dev/null || echo "Executar var export: Fase 1")
\`\`\`

---

## ✅ CHECKLIST DE VALIDAÇÃO

- [ ] 1Password CLI autenticado
- [ ] SSH Agent configurado
- [ ] Colima rodando
- [ ] Docker contexto correto
- [ ] Vaults acessíveis
- [ ] VPS acessível via SSH
- [ ] DNS configurado

---

## 🎯 PRÓXIMAS AÇÕES RECOMENDADAS

1. Executar: \`make colima.start\`
2. Validar: \`make deploy.local\`
3. Sincronizar: \`make deploy.remote VPS_HOST={{VPS_HOST}} VPS_USER={{VPS_USER}}\`
4. Atualizar DNS: \`make update.dns DOMAIN={{PRIMARY_DOMAIN}}\`

---

**Gerado por:** scripts/llm/collect_system_context.sh  
**Versão:** 2.1.0
EOF
} > "${OUTPUT_FILE}"

echo "✅ Contexto salvo em: ${OUTPUT_FILE}"
