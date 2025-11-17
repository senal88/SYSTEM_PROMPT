# ✅ Template para Diagnóstico Automatizado com LLMs

**Versão:** 2.1.0  
**Data:** 2025-10-31  
**Origem do Contexto Automatizado:**  
- `.cursorrules` · `# Last Updated: 2025-10-30` · `# Version: 2.0.0`  
- `RESUMO_CLEANUP_20251029.md` · governança e backups  
- `context/prompts/prompt_recurrent_audit_v2_2025_10_30.md` · engenharia de contexto  
- Diretórios monitorados: `$REPO_ROOT/**/*`, `$HOME/**/*` (via Cursor Rules e collectors)

---

## 🎯 Objetivo

Fornecer um artefato markdown padronizado para análise por LLMs (ChatGPT Codex 5, Cursor IDE, pipelines Hugging Face, MCP). Este relatório reflete o estado atual do macOS principal de desenvolvimento, com placeholders bem definidos para ambientes Ubuntu espelhados.

---

## ⚙️ Boas práticas para GPTs customizados

### 🔧 Instruções Personalizadas (ChatGPT / Custom GPTs)

**"Como você gostaria que o ChatGPT respondesse?"**

> Respostas técnicas, terminal-friendly, com foco em automação, diagnóstico e manutenção. Usar markdown estruturado, comandos shell prontos para execução e sugestões práticas.

**"O que o ChatGPT deve saber sobre você?"**

> Usuário avançado operando macOS (Apple Silicon) com ambientes espelhados em VPS Ubuntu. Busca automação total (sem digitar senhas), auditorias recorrentes e integração com Hugging Face/MCP/CI. 1Password CLI provê cofres, segredos e agente SSH.

---

## 🧱 Estrutura do Template Markdown

```markdown
# 🧠 CONTEXTO PARA INTERPRETAÇÃO DE SISTEMA
Relatório gerado automaticamente para apoiar diagnósticos assistidos por LLMs.

## 🔍 METADADOS DO HOST
- SO: macOS 26.0.1 (Build 25A362)
- Hostname: `MacBook-Pro.local`
- IP Local: `192.168.18.117`
- Uptime: `11:57  up 3 days, 16:09, 1 user, load averages: 2.42 2.39 2.99`
- Arquitetura: `arm64`
- CPU: `Apple M4 - 10 cores`
- RAM: `24.0 GiB total | Free: 0.4 GiB | Inactive: 9.6 GiB`

## 📊 USO DE RECURSOS
### CPU:
```text
CPU usage: 13.46% user, 14.10% sys, 72.43% idle 
```

### Memória:
```text
PhysMem: 23G used (2942M wired, 440M compressor), 424M unused.
```

### Disco:
```text
Filesystem        Size    Used   Avail Capacity iused ifree %iused  Mounted on
/dev/disk3s3s1   926Gi    11Gi   595Gi     2%    447k  4.3G    0%   /
```

## 🧪 SERVIÇOS MONITORADOS
macOS não usa `systemctl`. Substituir por inspeções equivalentes:

```text
docker info --format '{{.ServerVersion}}'
28.4.0
```

```text
launchctl print system/com.openssh.sshd | head -n 5
system/com.openssh.sshd = {
	active count = 0
	path = /System/Library/LaunchDaemons/ssh.plist
	type = LaunchDaemon
	state = not running
```

Para ambientes Ubuntu espelhados, utilizar:

```bash
systemctl status nginx docker sshd postgresql --no-pager
```

## 📦 VERSÕES DE PACOTES
```text
docker 28.5.1
docker-buildx 0.29.1
docker-completion 28.5.1
docker-compose 2.40.3
python@3.12 3.12.12
python@3.14 3.14.0_1
```

## 🔐 SEGURANÇA
- Firewall (macOS Application Firewall): `Firewall is disabled. (State = 0)`
- Últimos logins:
```text
luiz.sena88 ttys008  fe80::10de:d2c7:5dc7:4 Fri Oct 31 04:27 - 07:16  (02:49)
luiz.sena88 ttys008  fe80::10de:d2c7:5dc7:4 Fri Oct 31 04:26 - 04:27  (00:00)
luiz.sena88 ttys001  fe80::10de:d2c7:5dc7:4 Fri Oct 31 04:20 - 06:37  (02:17)
luiz.sena88 ttys017                         Fri Oct 31 01:14 - 01:14  (00:00)
luiz.sena88 ttys016                         Fri Oct 31 00:11 - 00:11  (00:00)
luiz.sena88 ttys029  fe80::10de:d2c7:5dc7:4 Wed Oct 29 23:56 - 07:57  (08:01)
luiz.sena88 console                         Mon Oct 27 19:51   still logged in
reboot time                                Mon Oct 27 19:48
shutdown time                              Mon Oct 27 19:22
luiz.sena88 ttys052                         Thu Oct 23 02:45 - shutdown (4+16:37)
```
- Para VPS Ubuntu: substituir por `sudo ufw status` e `last -n 10`.

## ⚙️ PORTAS E PROCESSOS ATIVOS
```text
lsof -nP -iTCP -sTCP:LISTEN
COMMAND     PID        USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
rapportd    646 luiz.sena88   11u  IPv4 0xc154c5ca314cd672      0t0  TCP *:52055 (LISTEN)
ControlCe   661 luiz.sena88    9u  IPv4 0x3922153bf7132d1b      0t0  TCP *:7000 (LISTEN)
...
Cursor    89683 luiz.sena88   18u  IPv6 0x38c22bbc0e9188a1      0t0  TCP *:59068 (LISTEN)
```
Para relatórios publicados, truncar ou anexar arquivo separado (`diagnostics/listen_ports_{{DATE}}.md`) para evitar excesso de linhas.

---

# ✅ OBJETIVO DA INTERPRETAÇÃO
1. Diagnosticar gargalos de desempenho.
2. Identificar comportamentos anômalos.
3. Recomendar manutenções preventivas.
4. Sugerir melhorias automatizáveis.

---

# 📋 RESPOSTA ESPERADA (GERADA PELA LLM)

## 🩺 Diagnóstico Geral
Contextualizar estado do host, ressaltar diferenças entre macOS local e VPS espelhada.

## ⚠️ Alertas e Riscos
Apontar firewall desativado, serviços críticos ausentes/inativos, pods/containers degradados, backups pendentes.

## 🛠️ Ações Recomendadas
- [ ] `colima start --cpu 4 --memory 8 --disk 60` (garantir ambiente Docker pronto)
- [ ] `bash scripts/maintenance/cleanup-obsolete-files.sh` (manter rotina mensal)
- [ ] `ssh {{VPS_USER}}@{{VPS_HOST}} 'sudo ufw enable && sudo ufw status'`

## 🤖 Sugestões de Automação
- Bash scripts versionados em `scripts/automation/`.
- Agendamentos com `launchd` (macOS) ou `systemd` timers (Ubuntu).
- Integração com 1Password CLI (`op inject`, `op read`) para segredos.

## 📚 Referências
- `docs/runbooks/`
- `.cursorrules` para governança de alterações assistidas por LLMs.
- Documentação oficial: Docker, Colima, 1Password CLI, Cloudflare API.
```

---

## 🤖 Exemplo de Coletor Automatizado (macOS + Ubuntu)

```bash
#!/usr/bin/env bash
# gpt_sys_collector.sh
set -euo pipefail

TARGET_OS="$(uname -s)"
REPORT_DIR="${REPO_ROOT:-$(pwd)}/diagnostics"
REPORT_FILE="${REPORT_DIR}/system_report_$(date +%Y%m%dT%H%M%S).md"
mkdir -p "${REPORT_DIR}"

if [[ "${TARGET_OS}" == "Darwin" ]]; then
  SO="macOS $(sw_vers -productVersion) (Build $(sw_vers -buildVersion))"
  HOST_IP="$(ipconfig getifaddr en0 || echo '{{IP_PLACEHOLDER}}')"
  CPU_USAGE="$(top -l 1 | grep 'CPU usage')"
  MEM_USAGE="$(top -l 1 | grep 'PhysMem')"
  FIREWALL="$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)"
else
  SO="$(lsb_release -ds || cat /etc/os-release)"
  HOST_IP="$(hostname -I | awk '{print $1}')"
  CPU_USAGE="$(top -bn1 | grep 'Cpu(s)')"
  MEM_USAGE="$(free -h)"
  FIREWALL="$(sudo ufw status 2>&1 || echo 'ufw not installed')"
fi

HOSTNAME="$(hostname)"
ARCH="$(uname -m)"
UPTIME_STR="$(uptime)"
CPU_MODEL="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || lscpu | grep 'Model name' | cut -d':' -f2)"
CPU_CORES="$(sysctl -n hw.ncpu 2>/dev/null || nproc)"
RAM_TOTAL="$(python3 - <<'PY'\nimport os\nimport platform\nif platform.system()=='Darwin':\n    import subprocess\n    mem=int(subprocess.check_output(['sysctl','-n','hw.memsize']).decode())\n    print(f\"{mem/1024**3:.1f} GiB\")\nelse:\n    import psutil\n    print(f\"{psutil.virtual_memory().total/1024**3:.1f} GiB\")\nPY)"
DISK_USAGE="$(df -h /)"
SERVICES="$( { systemctl status nginx docker sshd postgresql --no-pager 2>/dev/null || echo 'systemctl not available'; } )"
PORTS="$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null)"
LOGIN_HISTORY="$(last -n 10 2>/dev/null)"
PACKAGES="$( { brew list --versions | grep -E 'nginx|docker|postgres|python' 2>/dev/null || dpkg -l | grep -E 'nginx|docker|postgres|python' 2>/dev/null || echo 'package manager output unavailable'; } )"

cat <<EOF > "${REPORT_FILE}"
# 🧠 CONTEXTO PARA INTERPRETAÇÃO DE SISTEMA

## 🔍 METADADOS DO HOST
- SO: ${SO}
- Hostname: ${HOSTNAME}
- IP Local: ${HOST_IP}
- Uptime: ${UPTIME_STR}
- Arquitetura: ${ARCH}
- CPU: ${CPU_MODEL//  } - ${CPU_CORES} cores
- RAM: ${RAM_TOTAL}

## 📊 USO DE RECURSOS
### CPU:
${CPU_USAGE}

### Memória:
${MEM_USAGE}

### Disco:
${DISK_USAGE}

## 🧪 SERVIÇOS MONITORADOS
${SERVICES}

## 📦 VERSÕES DE PACOTES
${PACKAGES}

## 🔐 SEGURANÇA
Firewall: ${FIREWALL}
Últimos logins:
${LOGIN_HISTORY}

## ⚙️ PORTAS E PROCESSOS ATIVOS
${PORTS}

# ✅ OBJETIVO DA INTERPRETAÇÃO
1. Diagnosticar gargalos de desempenho.
2. Identificar comportamentos anômalos.
3. Recomendação de manutenções.
4. Sugestões de automação.
EOF
```

---

## 🔗 Integração com Hugging Face & MCP

- Entradas `.md` podem ser enviadas para `pipeline(task='text2text-generation')` no Hugging Face.  
- Use `context/prompts/prompt_recurrent_audit_v2_2025_10_30.md` como prompt-base em MCP.  
- Publique relatórios no `exports/` para consumo por GPTs customizados.

---

## 📂 Estrutura de Repositório Recomendada (Atual)

```
automation_1password/
├── diagnostics/
│   └── system_report_*.md
├── context/
│   └── prompts/...
├── scripts/
│   ├── maintenance/
│   ├── secrets/
│   └── validation/
├── templates/
│   └── (modelos adicionais para LLMs)
└── .cursorrules
```

Governança: `.cursorrules` direciona qualquer modificação em `$REPO_ROOT` e `$HOME` para atualizar este template (gatilho `# Last Updated`).

---

## ✅ Finalizado com

- 🧠 ChatGPT Codex 5 / Cursor IDE  
- 💻 macOS (Apple Silicon) + VPS Ubuntu (espelhamento planejado)  
- 🔁 Automatizável via `launchd`, `systemd`, `cron` e MCP  
- 🔐 Segredos mantidos no 1Password CLI (`op inject`, `op read`)  
- ☁️ DNS/Infra integrável com Cloudflare e docker-compose multi-container
