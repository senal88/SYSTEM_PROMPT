# Inventory Report - Hybrid Dev/Prod Setup

**Data:** 2025-11-02 20:57:58
**Ambiente:** macOS Silicon → VPS Ubuntu

---

## 1. System Specifications

=== MACOS SYSTEM INFO ===
ProductName:		macOS
ProductVersion:		26.0.1
BuildVersion:		25A362

=== ARCHITECTURE ===
arm64

=== CPU CORES ===
10

=== RAM ===
24 GB

=== DISK ===
/dev/disk3s3s1   926Gi    11Gi   540Gi     3%    447k  4.3G    0%   /

## 2. Docker Status

=== COLIMA STATUS ===
time="2025-11-02T20:57:46-03:00" level=info msg="colima is running using macOS Virtualization.Framework"
time="2025-11-02T20:57:46-03:00" level=info msg="arch: aarch64"
time="2025-11-02T20:57:46-03:00" level=info msg="runtime: docker"
time="2025-11-02T20:57:46-03:00" level=info msg="mountType: virtiofs"
time="2025-11-02T20:57:46-03:00" level=info msg="docker socket: unix:///Users/luiz.sena88/.colima/default/docker.sock"
time="2025-11-02T20:57:46-03:00" level=info msg="containerd socket: unix:///Users/luiz.sena88/.colima/default/containerd.sock"

=== DOCKER VERSION ===
Docker version 28.5.1, build e180ab8ab8

=== COLIMA VERSION ===
colima version 0.9.1

=== DOCKER PS ===
NAMES                IMAGE                           STATUS
op-connect-sync      1password/connect-sync:latest   Up 2 days (unhealthy)
op-connect-api       1password/connect-api:latest    Up 2 days (unhealthy)
platform_portainer   portainer/portainer-ce:latest   Up 2 days
platform_n8n         n8nio/n8n:latest                Up 2 days
platform_redis       redis:7-alpine                  Up 2 days (healthy)
platform_postgres    pgvector/pgvector:pg16          Up 2 days (healthy)
platform_traefik     traefik:v3.1                    Up 2 days
platform_mongodb     mongo:7                         Up 2 days (healthy)
platform_chromadb    chromadb/chroma:latest          Up 2 days

=== DOCKER IMAGES ===
REPOSITORY               TAG               SIZE
portainer/portainer-ce   latest            238MB
appsmith/appsmith-ce     latest            4.36GB

## 3. Docker Stacks Running

=== DOCKER STACKS ===
NAMES                IMAGE                           PORTS                                                                                      STATUS
op-connect-sync      1password/connect-sync:latest                                                                                              Up 2 days (unhealthy)
op-connect-api       1password/connect-api:latest    0.0.0.0:8081->8080/tcp, [::]:8081->8080/tcp, 0.0.0.0:8444->8443/tcp, [::]:8444->8443/tcp   Up 2 days (unhealthy)
platform_portainer   portainer/portainer-ce:latest   8000/tcp, 9443/tcp, 0.0.0.0:9000->9000/tcp, [::]:9000->9000/tcp                            Up 2 days
platform_n8n         n8nio/n8n:latest                0.0.0.0:5678->5678/tcp, [::]:5678->5678/tcp                                                Up 2 days
platform_redis       redis:7-alpine                  6379/tcp                                                                                   Up 2 days (healthy)
platform_postgres    pgvector/pgvector:pg16          5432/tcp                                                                                   Up 2 days (healthy)
platform_traefik     traefik:v3.1                    0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp           Up 2 days
platform_mongodb     mongo:7                         27017/tcp                                                                                  Up 2 days (healthy)
platform_chromadb    chromadb/chroma:latest          0.0.0.0:8000->8000/tcp, [::]:8000->8000/tcp                                                Up 2 days

=== DOCKER VOLUMES ===
VOLUME NAME                                                        DRIVER
8d7952a6ba5c64f26cc9d814a7390a602e973c08cbf1f03c68203d437fba4ace   local
19b33cd01beaf2a20cf9c5637a441c5ec8613b691f949a02a6914b03225ec06a   local
61dc1f58fbfbbf6a6221013941bef42f834514eb523c31a9eed8a59c1203cb9b   local
83d9bdfbc62ba2f6a0ee22b2710f1786f2dae0ac1411731c39e5a54da0ae98e6   local
123b4d456c61bd8394a9a55068df43fc53ec11b04f3db6eb5af6a925c1c96d86   local
731a0e410168eebb30abf79184edf72d4bda6f5a0d3462095e1d661989c1f14a   local
2778c0014b1601bd21d7ad451047df0ccc78ef3c96f284b6a118b3e801121ebf   local
buildx_buildkit_colima_builder0_state                              local
compose_appsmith_data                                              local
compose_chromadb_data                                              local
compose_mongodb_data                                               local
compose_n8n_data                                                   local
compose_nocodb_data                                                local
compose_portainer_data                                             local
compose_postgres_data                                              local
compose_redis_data                                                 local
compose_traefik_certs                                              local
e437c8e5f7e2b420bcedd4dae37128fe977d7974d28a6772aaa55b4548f81128   local
f98bc5e5ef505ea2b0d8fb7b0faf81e4b738f506824dec0365825eb5b1fb1091   local
fde8e38357804d4a4c5b4baab2b7dd04007444e856d33af76214427680866579   local
infra_portainer_data                                               local

=== DOCKER NETWORKS ===
NAME                      DRIVER    SCOPE
bridge                    bridge    local
compose_app_network       bridge    local
connect_net               bridge    local
host                      host      local
none                      null      local
stack-local_traefik_net   bridge    local
traefik_net               bridge    local

## 6. 1Password Inventory (1p_macos)

[]

## 7. Environment Variables (Keys Only)

⚠️ **Segurança:** Apenas nomes de variáveis, sem valores!

=== ENVIRONMENT VARIABLES (KEYS ONLY) ===
ANTHROPIC_API_KEY
CURSOR_API_KEY
GEMINI_API_KEY
GIT_TOKEN
HF_TOKEN
OP_CONNECT_HOST
OP_CONNECT_TOKEN
OPENAI_API_KEY
PERPLEXITY_API_KEY

=== .env FILES STRUCTURE ===
File: /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env.real
      67 /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env.real
File: /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env.temp
      58 /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env.temp
File: /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env.template
     194 /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env.template
File: /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env
      35 /Users/luiz.sena88/Dotfiles/automation_1password/compose/.env
File: /Users/luiz.sena88/Dotfiles/automation_1password/compose/n8n-ai-starter/.env.example
      13 /Users/luiz.sena88/Dotfiles/automation_1password/compose/n8n-ai-starter/.env.example
File: /Users/luiz.sena88/Dotfiles/automation_1password/connect/.env
      10 /Users/luiz.sena88/Dotfiles/automation_1password/connect/.env

## 8. Git Configuration

=== GIT REMOTE ===
origin	https://github.com/senal88/ls-edia-config.git (fetch)
origin	https://github.com/senal88/ls-edia-config.git (push)

=== GIT STATUS ===
 M ../../.cursorrules
 M ../../.gitignore
 D ../../IMPLEMENTACAO_COMPLETA.md
 M ../../connect/docker-compose.yml
 M ../secrets/inject_secrets_macos.sh
 M ../secrets/sync_1password_env.sh
 m ../../../codex
?? ../../../.bashrc
?? ../../../.config/
?? ../../../atlas-cli/Makefile
?? ../../../atlas-cli/atlas.env
?? ../../../atlas-cli/configure-atlas-cli.sh
?? ../../../atlas-cli/install-atlas-cli.sh
?? ../../.backups/
?? ../../.tmp_tree.txt
?? ../../.vscode/
?? ../../GUIA_PORTTAINER_PRIMEIRO_ACESSO.md
?? ../../GUIA_RAPIDO_USAR_AGORA.md
?? ../../IMPROVEMENTS_REPORT.md
?? ../../Makefile
?? ../../compose/
?? ../../configs/dns_cloudflare_localhost_full.txt
?? ../../configs/dns_cloudflare_localhost_template.txt
?? ../../connect/1Password.opvault/
?? ../../connect/dns.template.env
?? ../../context/
?? ../../dados/
?? ../../diagnostics/
?? ../../docs/HUGGINGFACE_GUIA_COMPLETO.md
?? ../../docs/PLANO_ACAO_COMPLETO.md
?? ../../docs/VALIDACAO_PRE_VPS.md
?? ../../docs/llm-cookbook.md
?? ../../docs/operations/analisar_adequar_automation_1password/
?? ../../docs/reports/
?? ../../docs/runbooks/automacao-cursor-pro.md
?? ../../docs/runbooks/deploy-stack-completa.md
?? ../../docs/runbooks/desenvolvimento-system-prompt-hibrido.md
?? ../../docs/runbooks/lmstudio-integration.md
?? ../../docs/runbooks/organizar-projetos-home.md
?? ../../docs/runbooks/otimizacao-memoria-projetos.md
?? ../../docs/runbooks/raycast-1password-integration.md
?? ../../docs/runbooks/restauracao-terminal.md
?? ../../docs/runbooks/stacks-completas-equivalencia.md
?? ../../docs/runbooks/testes-configuracao-vps.md
?? ../../env/README.md
?? ../../env/github-recovery-codes.txt
?? ../../env/infra.example.env.op
?? ../../env/macos.env.example
?? ../../env/n8n-recovery-codes.txt
?? ../../env/shared.env.example
?? ../../env/vps.env.example
?? ../../exports/
?? ../../gemini_setup_final.tar.gz
?? ../../gemini_setup_final/
?? ../../injetar_env_cloudflare_corretamente.json
?? ../../justfile
?? ../../prompts/
?? ../../reports/
?? ../1p-create-all-secrets.sh
?? ../audit/
?? ../bootstrap/fix_ssh_1password_vps.sh
?? ../bootstrap/fix_terminal_config.sh
?? ../bootstrap/setup_vps_complete.sh
?? ../bootstrap/test_ssh_1password.sh
?? ../cloudflare/
?? ./
?? ../context/
?? ../diagnostics/
?? ../export_architecture.sh
?? ../fix-op-connect-conflict.sh
?? ../huggingface/
?? ../lib/
?? ../llm/
?? ../lmstudio/
?? ../maintenance/
?? ../migration/
?? ../organization/
?? ../platform/
?? ../projetos/
?? ../prompts/
?? ../raycast/
?? ../secrets/load-infra-env.sh
?? ../secrets/op_login.sh
?? ../secrets/register-and-validate-api-keys.sh
?? ../secrets/reset_connect_env.sh
?? ../security/
?? ../setup-auto-completo.sh
?? ../traefik/
?? ../validation/validate-ai-stack.sh
?? ../validation/validate_architecture.sh
?? ../../settings.json
?? ../../setup-automatico.sh
?? ../../setup-completo-final.sh
?? ../../templates/projetos/
?? ../../../cursor/
?? ../../../gemini/
?? ../../../huggingface/
?? ../../../raycast/
?? ../../../templates/
?? ../../../tmux/
?? ../../../zsh/

=== GIT BRANCHES ===
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main

=== RECENT COMMITS ===
4bedf7e feat: Adiciona scripts de pinagem automática Atlas CLI
98961bc docs: Adiciona manual completo e checklist rápido
bb2963b feat: Adiciona substituição completa Spotlight → Raycast
4ea1c27 feat: Sistema completo de backup/restore do Raycast
649cdbf feat: Adiciona repositório final organizado do Raycast Automation
f22027d feat: Adiciona automação completa do Raycast com integração 1Password
d4d0515 feat: add automation 1password workspace
54e2f35 chore: finalize dotfiles-only layout
108d4fd refactor: scope dotfiles repo
5f8df61 docs: expand README with full LS-EDIA guide

## 9. Network & Ports Mapping

=== PORTS MAPPED ===
op-connect-sync	
op-connect-api	0.0.0.0:8081->8080/tcp, [::]:8081->8080/tcp, 0.0.0.0:8444->8443/tcp, [::]:8444->8443/tcp
platform_portainer	8000/tcp, 9443/tcp, 0.0.0.0:9000->9000/tcp, [::]:9000->9000/tcp
platform_n8n	0.0.0.0:5678->5678/tcp, [::]:5678->5678/tcp
platform_redis	6379/tcp
platform_postgres	5432/tcp
platform_traefik	0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
platform_mongodb	27017/tcp
platform_chromadb	0.0.0.0:8000->8000/tcp, [::]:8000->8000/tcp

=== DOCKER NETWORKS ===
NAME                      DRIVER
bridge                    bridge
compose_app_network       bridge
connect_net               bridge
host                      host
none                      null
stack-local_traefik_net   bridge
traefik_net               bridge

---

## Summary

✅ Dados coletados com sucesso do ambiente macOS Silicon
✅ Inventory pronto para análise e preparação de deploy na VPS
✅ Nenhuma credencial foi exposta (apenas metadata)

**Próximo passo:** Preparar deployment para VPS Ubuntu

