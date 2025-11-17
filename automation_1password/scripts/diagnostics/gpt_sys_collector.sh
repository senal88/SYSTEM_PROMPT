#!/usr/bin/env bash
set -euo pipefail

# gpt_sys_collector.sh
# Generates a markdown report with system diagnostics suitable for LLM ingestion.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"
REPORT_DIR="${REPO_ROOT}/diagnostics"
REPORT_FILE="${REPORT_DIR}/system_report_${TIMESTAMP}.md"

mkdir -p "${REPORT_DIR}"

uname_s="$(uname -s)"

if [[ "${uname_s}" == "Darwin" ]]; then
  os_version="macOS $(sw_vers -productVersion) (Build $(sw_vers -buildVersion))"
  hostname_val="$(hostname)"
  ip_local="$(ipconfig getifaddr en0 || echo '{{IP_PLACEHOLDER}}')"
  uptime_val="$(uptime)"
  arch_val="$(uname -m)"
  cpu_model="$(sysctl -n machdep.cpu.brand_string)"
  cpu_cores="$(sysctl -n hw.ncpu)"
  ram_total="$(python3 - <<'PY'
import subprocess
mem_bytes = int(subprocess.check_output(['sysctl', '-n', 'hw.memsize']).decode())
print(f"{mem_bytes/1024**3:.1f} GiB")
PY
)"
  cpu_usage="$(top -l 1 | grep 'CPU usage' || true)"
  mem_usage="$(top -l 1 | grep 'PhysMem' || true)"
  disk_usage="$(df -h /)"
  services_output="$(
    docker info --format '{{.ServerVersion}}' 2>/dev/null || echo 'docker not available'
  )"
  services_output+="
$(launchctl print system/com.openssh.sshd 2>/dev/null | head -n 10 || echo 'sshd status unavailable')"
  firewall_status="$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null || echo 'firewall status unavailable')"
  package_output="$(brew list --versions 2>/dev/null | grep -E 'nginx|docker|postgres|python' || echo 'brew packages unavailable')"
else
  os_version="$(lsb_release -ds 2>/dev/null || cat /etc/os-release)"
  hostname_val="$(hostname)"
  ip_local="$(hostname -I | awk '{print $1}')"
  uptime_val="$(uptime -p 2>/dev/null || uptime)"
  arch_val="$(uname -m)"
  cpu_model="$(lscpu | grep 'Model name' | cut -d':' -f2 | sed 's/^ //')"
  cpu_cores="$(nproc)"
  ram_total="$(python3 - <<'PY'
import psutil
print(f"{psutil.virtual_memory().total/1024**3:.1f} GiB")
PY
)"
  cpu_usage="$(top -bn1 | grep 'Cpu(s)' || true)"
  mem_usage="$(free -h || true)"
  disk_usage="$(df -h /)"
  services_output="$(systemctl status nginx docker sshd postgresql --no-pager 2>&1 || echo 'systemctl status unavailable')"
  firewall_status="$(sudo ufw status 2>&1 || echo 'ufw status unavailable')"
  package_output="$(dpkg -l 2>/dev/null | grep -E 'nginx|docker|postgres|python' || echo 'dpkg output unavailable')"
fi

ports_output="$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null || echo 'lsof output unavailable')"
login_history="$(last -n 10 2>/dev/null || echo 'login history unavailable')"

cat <<EOF > "${REPORT_FILE}"
# 🧠 CONTEXTO PARA INTERPRETAÇÃO DE SISTEMA

## 🔍 METADADOS DO HOST
- SO: ${os_version}
- Hostname: ${hostname_val}
- IP Local: ${ip_local}
- Uptime: ${uptime_val}
- Arquitetura: ${arch_val}
- CPU: ${cpu_model} - ${cpu_cores} cores
- RAM: ${ram_total}

## 📊 USO DE RECURSOS
### CPU:
${cpu_usage}

### Memória:
${mem_usage}

### Disco:
${disk_usage}

## 🧪 SERVIÇOS MONITORADOS
${services_output}

## 📦 VERSÕES DE PACOTES
${package_output}

## 🔐 SEGURANÇA
Firewall: ${firewall_status}
Últimos logins:
${login_history}

## ⚙️ PORTAS E PROCESSOS ATIVOS
${ports_output}

# ✅ OBJETIVO DA INTERPRETAÇÃO
1. Diagnosticar gargalos de desempenho.
2. Identificar comportamentos anômalos.
3. Recomendação de manutenções.
4. Sugestões de automação.
EOF

echo "Relatório gerado em: ${REPORT_FILE}"
