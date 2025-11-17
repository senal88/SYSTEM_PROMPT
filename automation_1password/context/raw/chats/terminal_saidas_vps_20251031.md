Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.8.0-86-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Oct 31 18:27:17 UTC 2025

  System load:  0.13               Processes:             153
  Usage of /:   15.3% of 95.82GB   Users logged in:       0
  Memory usage: 17%                IPv4 address for eth0: 147.79.81.59
  Swap usage:   0%                 IPv6 address for eth0: 2a02:4780:14:2242::1

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

15 updates can be applied immediately.
2 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

7 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


1 updates could not be installed automatically. For more details,
see /var/log/unattended-upgrades/unattended-upgrades.log

Last login: Fri Oct 31 18:23:18 2025 from 138.99.33.154
luiz.sena88@senamfo:~$ cat ~/.ssh/config 
# Configuração SSH para VPS Ubuntu - Desenvolvimento Remoto
# Baseado nas melhores práticas de arquitetura

# --- GitHub ---
Host github.com
    HostName github.com
    User git
    IdentityFile /home/luiz.sena88/.ssh/id_ed25519_universal
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes

# --- Hugging Face ---
Host hf.co
    HostName hf.co
    User git
    IdentityFile /home/luiz.sena88/.ssh/id_ed25519_universal
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes

# --- VPS Ubuntu - Desenvolvimento Remoto ---
Host vps
    HostName 147.79.81.59
    User luiz.sena88
    Port 22
    IdentityFile /home/luiz.sena88/.ssh/id_ed25519_universal
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes
    RemoteCommand cd /home/luiz.sena88
    RequestTTY yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes
    ForwardAgent yes
    ForwardX11 no
    ForwardX11Trusted no

# --- Configurações Globais ---
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes
    AddKeysToAgent yes
    UseKeychain yes
    IdentitiesOnly yes
luiz.sena88@senamfo:~$ eval "$(op signin)"
Enter the password for luiz.sena88@icloud.com at my.1password.com: 
luiz.sena88@senamfo:~$ op whoami
URL:          https://my.1password.com
Email:        luiz.sena88@icloud.com
User ID:      BOAC3NIIQZBF5CFNGZO36FBRIM
User Type:    HUMAN
luiz.sena88@senamfo:~$ op vault list 
ID                            NAME
gkpsbgizlks2zknwzqpppnb2ze    1p_macos
oa3tidekmeu26nxiier2qbi7v4    1p_vps
syz4hgfg6c62ndrxjmoortzhia    default importado
7bgov3zmccio5fxc5v7irhy5k4    Personal
luiz.sena88@senamfo:~$ ls -la 
total 596
drwxr-x--- 34 luiz.sena88 luiz.sena88  4096 Oct 31 09:09  .
drwxr-xr-x  4 root        root         4096 Oct 15 05:24  ..
-rw-------  1 luiz.sena88 luiz.sena88 29912 Oct 31 18:29  .bash_history
-rw-r--r--  1 luiz.sena88 luiz.sena88   220 Oct 15 05:24  .bash_logout
-rw-r--r--  1 luiz.sena88 luiz.sena88 14525 Oct 29 09:21  .bashrc
-rw-rw-r--  1 luiz.sena88 luiz.sena88  3968 Oct 20 20:53  .bashrc.bak.20251020205311
drwx------  7 luiz.sena88 luiz.sena88  4096 Oct 21 03:17  .cache
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 15 12:42  .codex
drwxrwxr-x  9 luiz.sena88 luiz.sena88  4096 Oct 25 14:05  .config
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 28 20:16  .cursor
drwxrwxr-x  5 luiz.sena88 luiz.sena88  4096 Oct 25 14:32  .cursor-server
-rw-rw-r--  1 luiz.sena88 luiz.sena88   152 Oct 27 14:21  .cursorignore
-rw-rw-r--  1 luiz.sena88 luiz.sena88  6923 Oct 27 14:21  .cursorrules
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 15 06:32  .dotnet
-rw-rw-r--  1 luiz.sena88 luiz.sena88  2444 Oct 29 09:16  .env
-rw-rw-r--  1 luiz.sena88 luiz.sena88  1152 Oct 29 09:16  .env.1p
-rw-rw-r--  1 luiz.sena88 luiz.sena88 30797 Oct 15 14:36  .env.exemple
-rw-rw-r--  1 luiz.sena88 luiz.sena88 29989 Oct 15 12:17  .env.temporario
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 21 04:59  .gemini
-rw-rw-r--  1 luiz.sena88 luiz.sena88   108 Oct 28 20:22  .gitconfig
drwxrwxr-x  4 luiz.sena88 luiz.sena88  4096 Oct 27 14:16  .local
drwxrwxr-x  4 luiz.sena88 luiz.sena88  4096 Oct 17 05:10  .npm
drwxrwxr-x  8 luiz.sena88 luiz.sena88  4096 Oct 17 05:10  .nvm
-rw-r--r--  1 luiz.sena88 luiz.sena88   807 Oct 29 09:21  .profile
-rw-rw-r--  1 luiz.sena88 luiz.sena88   807 Oct 20 20:53  .profile.bak.20251020205311
drwx------  2 luiz.sena88 luiz.sena88  4096 Oct 31 02:20  .ssh
-rw-r--r--  1 luiz.sena88 luiz.sena88     0 Oct 15 05:47  .sudo_as_admin_successful
drwxr-x---  5 luiz.sena88 luiz.sena88  4096 Oct 29 10:30  .vscode-server
-rw-rw-r--  1 luiz.sena88 luiz.sena88   230 Oct 18 05:25  .wget-hsts
-rw-rw-r--  1 luiz.sena88 docker      50610 Oct 15 12:02  .zcompdump
-rw-rw-r--  1 luiz.sena88 luiz.sena88   293 Oct 17 06:25  .zsh_secrets
-rw-rw-r--  1 luiz.sena88 docker       4155 Oct 29 09:21  .zshrc
-rw-rw-r--  1 luiz.sena88 luiz.sena88   828 Oct 20 20:53  .zshrc.bak.20251020205311
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 28 12:05  1p_vps
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 29 09:02  1password-connect
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 22 01:32  BNI_2024_Cont-bil_Completo-gemini
-rw-rw-r--  1 luiz.sena88 luiz.sena88 12784 Oct 25 13:07  KB_MASTER.YAML.sh
drwxrwxr-x  9 luiz.sena88 luiz.sena88  4096 Oct 21 04:57  Projetos
-rw-rw-r--  1 luiz.sena88 luiz.sena88  6780 Oct 25 14:47  RELATORIO_FINAL_AUDITORIA.md
-rw-rw-r--  1 luiz.sena88 luiz.sena88  7057 Oct 28 20:21  RELATORIO_FINAL_VPS_UBUNTU.md
-rwxrwxr-x  1 luiz.sena88 luiz.sena88  2924 Oct 28 12:00  audit_clean_docker_env.sh
drwxr-xr-x  3 root        root         4096 Oct 28 12:00  auditoria
-rwxrwxr-x  1 luiz.sena88 luiz.sena88   878 Oct 21 05:48  backup_rclone.sh
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 29 02:00  backups
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 17 06:13  bin
-rw-rw-r--  1 luiz.sena88 luiz.sena88 50363 Oct 21 15:04  config_gemini.md
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 22 21:37  contexto_global_vps
drwxrwxr-x  7 luiz.sena88 luiz.sena88  4096 Oct 27 14:21  cursor-automation-framework
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 27 14:20  cursor-setup
-rwxrwxr-x  1 luiz.sena88 luiz.sena88 17762 Oct 25 14:47  cursor_audit_framework.py
-rw-rw-r--  1 luiz.sena88 luiz.sena88  1110 Oct 28 20:20  cursor_audit_report.md
-rw-rw-r--  1 luiz.sena88 luiz.sena88  1361 Oct 25 15:16  cursor_fix_report.md
-rwxrwxr-x  1 luiz.sena88 luiz.sena88  6055 Oct 25 14:47  cursor_fix_script.sh
drwxrwxr-x  4 luiz.sena88 luiz.sena88  4096 Oct 29 14:07  dev-prod
drwxrwxr-x 17 luiz.sena88 luiz.sena88  4096 Oct 15 11:35  docker-stack
drwxr-xr-x  4 luiz.sena88 luiz.sena88  4096 Oct 21 15:52  dotfiles
-rw-rw-r--  1 luiz.sena88 luiz.sena88 21483 Oct 21 14:08  erro_zshrc_gemini.md
-rw-rw-r--  1 luiz.sena88 luiz.sena88  4172 Oct 23 11:39  execucao_vps.md
-rwxrwxr-x  1 luiz.sena88 luiz.sena88  2703 Oct 20 21:16  fix_cwd_cleanup.sh
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 28 13:29  infra
drwxrwxr-x  8 luiz.sena88 luiz.sena88  4096 Oct 28 18:50  install-cli-action
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 28 20:19  projects
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 28 20:19  scripts
drwx------  4 luiz.sena88 luiz.sena88  4096 Oct 28 13:02  snap
-rw-rw-r--  1 luiz.sena88 luiz.sena88   857 Oct 21 15:19  ssh_macos.md
-rw-rw-r--  1 luiz.sena88 luiz.sena88  6379 Oct 21 15:18  ssh_vps.md
-rw-rw-r--  1 luiz.sena88 luiz.sena88 13744 Oct 21 15:22  ssh_vps_fix.md
-rw-rw-r--  1 luiz.sena88 luiz.sena88 14105 Oct 21 15:26  ssh_vps_fix.md.save
drwxrwxr-x  2 luiz.sena88 luiz.sena88  4096 Oct 28 11:57  stack-prod
-rwxrwxr-x  1 luiz.sena88 luiz.sena88 10302 Oct 28 20:21  vps_setup_complete.sh
-rwxrwxr-x  1 luiz.sena88 luiz.sena88  8880 Oct 28 20:21  vps_setup_user.sh
drwxrwxr-x  3 luiz.sena88 luiz.sena88  4096 Oct 31 09:09 '~'
luiz.sena88@senamfo:~$ tree -L 3 -a
.
├── .bash_history
├── .bash_logout
├── .bashrc
├── .bashrc.bak.20251020205311
├── .cache
│   ├── Microsoft
│   │   └── DeveloperTools
│   ├── cloud-code
│   │   └── install_id.txt
│   ├── google-vscode-extension
│   │   └── auth
│   ├── motd.legal-displayed
│   ├── node-gyp
│   │   └── 22.20.0
│   └── vscode-ripgrep
│       └── ripgrep-v13.0.0-10-x86_64-unknown-linux-musl.tar.gz
├── .codex
│   ├── auth.json
│   ├── config.toml
│   └── sessions
│       └── 2025
├── .config
│   ├── agents
│   │   ├── codex_gpt5
│   │   └── gemini
│   ├── codex
│   ├── configstore
│   │   └── update-notifier-@google
│   ├── gcloud
│   │   ├── .last_survey_prompt.yaml
│   │   ├── access_tokens.db
│   │   ├── active_config
│   │   ├── config_sentinel
│   │   ├── configurations
│   │   ├── credentials.db
│   │   ├── default_configs.db
│   │   ├── gce
│   │   ├── legacy_credentials
│   │   └── logs
│   ├── gemini
│   ├── op
│   │   ├── config
│   │   └── plugins.sh
│   └── rclone
│       └── rclone.conf
├── .cursor
│   ├── cli-config.json
│   ├── cli-config.json.bad
│   ├── ide_state.json
│   └── rules
├── .cursor-server
│   ├── bin
│   │   ├── 45fd70f3fe72037444ba35c9e51ce86a1977ac10
│   │   ├── 5c17eb2968a37f66bc6662f48d6356a100b67be0
│   │   └── multiplex-server
│   ├── data
│   │   ├── CachedExtensionVSIXs
│   │   ├── CachedProfilesData
│   │   ├── Machine
│   │   ├── User
│   │   ├── clp
│   │   ├── languagepacks.json
│   │   ├── logs
│   │   └── machineid
│   └── extensions
│       ├── anysphere.cursorpyright-1.0.10
│       ├── extensions.json
│       ├── mechatroner.rainbow-csv-3.3.0-universal
│       ├── ms-azuretools.vscode-containers-2.1.0-universal
│       ├── ms-azuretools.vscode-docker-2.0.0-universal
│       ├── ms-ceintl.vscode-language-pack-pt-br-1.99.0-universal
│       ├── ms-python.python-2023.6.0
│       ├── ms-toolsai.jupyter-2025.3.0-universal
│       ├── ms-toolsai.jupyter-keymap-1.1.2-universal
│       ├── ms-toolsai.jupyter-renderers-1.3.0-universal
│       ├── ms-toolsai.vscode-jupyter-cell-tags-0.1.9-universal
│       ├── ms-toolsai.vscode-jupyter-slideshow-0.1.6-universal
│       └── ms-vscode.makefile-tools-0.12.17
├── .cursorignore
├── .cursorrules
├── .dotnet
│   └── corefx
│       └── cryptography
├── .env
├── .env.1p
├── .env.exemple
├── .env.temporario
├── .gemini
│   ├── config.yaml
│   ├── google_accounts.json
│   ├── installation_id
│   ├── oauth_creds.json
│   ├── settings.json
│   ├── settings.json.orig
│   └── tmp
│       ├── 5b23015ac2fce1a55462ad80533e141098f4073ed37dd1564ad80b16e0ba77b3
│       ├── 9f8f7eca04341535f4156fad8d167ef6ac2cd0eaee66109d5f72d592b54d4ac9
│       ├── bin
│       └── ee1daaf32dcd2d125294932713276015fbc82345c41492e96b6bb84a6ad16ae6
├── .gitconfig
├── .local
│   ├── bin
│   │   └── cursor-agent -> /home/luiz.sena88/.local/share/cursor-agent/versions/2025.10.22-f894c20/cursor-agent
│   └── share
│       ├── cursor-agent
│       └── nano
├── .npm
│   ├── _cacache
│   │   ├── content-v2
│   │   ├── index-v5
│   │   └── tmp
│   ├── _logs
│   │   ├── 2025-10-29T09_22_07_478Z-debug-0.log
│   │   └── 2025-10-29T09_22_07_589Z-debug-0.log
│   └── _update-notifier-last-checked
├── .nvm
│   ├── .cache
│   │   └── bin
│   ├── .dockerignore
│   ├── .editorconfig
│   ├── .git
│   │   ├── FETCH_HEAD
│   │   ├── HEAD
│   │   ├── branches
│   │   ├── config
│   │   ├── description
│   │   ├── hooks
│   │   ├── index
│   │   ├── info
│   │   ├── logs
│   │   ├── objects
│   │   ├── packed-refs
│   │   ├── refs
│   │   └── shallow
│   ├── .gitattributes
│   ├── .github
│   │   ├── FUNDING.yml
│   │   ├── ISSUE_TEMPLATE.md
│   │   ├── SECURITY.md
│   │   ├── THREAT_MODEL.md
│   │   ├── external-threat-actor.png
│   │   ├── insider-threat-actor-and-libs.png
│   │   └── workflows
│   ├── .gitignore
│   ├── .mailmap
│   ├── .npmrc
│   ├── .travis.yml
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── Dockerfile
│   ├── GOVERNANCE.md
│   ├── LICENSE.md
│   ├── Makefile
│   ├── PROJECT_CHARTER.md
│   ├── README.md
│   ├── ROADMAP.md
│   ├── alias
│   │   ├── default
│   │   └── lts
│   ├── bash_completion
│   ├── install.sh
│   ├── nvm-exec
│   ├── nvm.sh
│   ├── package.json
│   ├── rename_test.sh
│   ├── test
│   │   ├── common.sh
│   │   ├── fast
│   │   ├── install_script
│   │   ├── installation_iojs
│   │   ├── installation_node
│   │   ├── mocks
│   │   ├── slow
│   │   ├── sourcing
│   │   └── xenial
│   ├── update_test_mocks.sh
│   └── versions
│       └── node
├── .profile
├── .profile.bak.20251020205311
├── .ssh
│   ├── authorized_keys
│   ├── config
│   ├── config.save
│   ├── id_ed25519_universal
│   ├── id_ed25519_universal.pub
│   ├── known_hosts
│   └── known_hosts.old
├── .sudo_as_admin_successful
├── .vscode-server
│   ├── .cli.7d842fb85a0275a4a8e4d7e040d2625abbf7f084.log
│   ├── cli
│   │   └── servers
│   ├── code-03c265b1adee71ac88f833e065f7bb956b60550a
│   ├── code-7d842fb85a0275a4a8e4d7e040d2625abbf7f084
│   ├── data
│   │   ├── CachedExtensionVSIXs
│   │   ├── CachedProfilesData
│   │   ├── Machine
│   │   ├── User
│   │   ├── clp
│   │   ├── languagepacks.json
│   │   ├── logs
│   │   └── machineid
│   └── extensions
│       ├── .obsolete
│       ├── extensions.json
│       ├── github.copilot-1.372.0
│       ├── github.copilot-chat-0.32.3
│       ├── github.vscode-pull-request-github-0.120.1
│       ├── google.gemini-cli-vscode-ide-companion-0.7.0
│       ├── google.geminicodeassist-2.55.0
│       ├── mechatroner.rainbow-csv-3.23.0
│       ├── meteorstudio.cursorcode-0.2.1
│       ├── ms-ceintl.vscode-language-pack-pt-br-1.105.2025101509
│       ├── openai.chatgpt-0.4.30-linux-x64
│       └── openai.chatgpt-0.4.31
├── .wget-hsts
├── .zcompdump
├── .zsh_secrets
├── .zshrc
├── .zshrc.bak.20251020205311
├── 1p_vps
│   ├── .env
│   ├── data
│   └── docker-compose.yml
├── 1password-connect
│   ├── .env
│   ├── 1password_urls.json
│   ├── MANUAL_SETUP.md
│   ├── README.md
│   ├── comunity_1password.jsonl
│   ├── credentials.json.template
│   ├── deploy.sh
│   ├── docker-compose.yml
│   └── setup.sh
├── BNI_2024_Cont-bil_Completo-gemini
│   ├── BNI_Agente_Contabil_Arquitetura.md
│   ├── BNI_Agente_Contabil_Documentacao.tar.gz
│   ├── GEMINI.md
│   ├── README_BNI_Agente_Contabil.md
│   ├── analise_arquivos.md
│   ├── bni_database_schema.sql
│   ├── bni_er_diagram.mmd
│   ├── bni_er_diagram.png
│   ├── bni_seed_data.sql
│   └── resumo_agentbuilder.md
├── KB_MASTER.YAML.sh
├── Projetos
│   ├── .devcontainer
│   │   └── devcontainer.json
│   ├── .env
│   ├── .vscode
│   │   └── settings.json
│   ├── config
│   │   ├── .copilot_rules.json
│   │   ├── codex_sdk_agent.py
│   │   ├── sdk_config_v1.json
│   │   ├── system_codex.txt
│   │   └── vscode_codex_settings.json
│   ├── credentials
│   │   ├── client_secret.json
│   │   └── gcp_service_account.json
│   ├── gcp_ai_pro_config.tar.gz
│   ├── logs
│   │   └── README.md
│   ├── manual_instalacao_agentkit.md
│   ├── prompts
│   │   └── system_message_v1.json
│   ├── scripts
│   │   ├── backup_rclone.sh
│   │   ├── codex_cli.sh
│   │   ├── codex_cli_agent.sh
│   │   ├── diagnostico_rclone.sh
│   │   ├── healthcheck_env.sh
│   │   ├── inicia_copilot.sh
│   │   ├── post_exec_validation.sh
│   │   └── validate_output.py
│   └── setup_dev_env.sh
├── RELATORIO_FINAL_AUDITORIA.md
├── RELATORIO_FINAL_VPS_UBUNTU.md
├── audit_clean_docker_env.sh
├── auditoria
│   ├── audit_clean_20251028_120029.log
│   └── backups_20251028_120029
│       └── portainer_compose_backup.tar.gz
├── backup_rclone.sh
├── backups
│   └── cursor
│       ├── cursor_config_20251029_020002.tar.gz
│       ├── cursor_config_20251030_020001.tar.gz
│       ├── cursor_config_20251031_020002.tar.gz
│       ├── ssh_config_20251029_020002.tar.gz
│       ├── ssh_config_20251030_020001.tar.gz
│       └── ssh_config_20251031_020002.tar.gz
├── bin
│   └── sync-gemini-secrets.sh
├── config_gemini.md
├── contexto_global_vps
│   └── generate_ai_context.sh
├── cursor-automation-framework
│   ├── .cursorrules
│   ├── config
│   │   ├── common
│   │   ├── macos
│   │   └── ubuntu
│   ├── scripts
│   │   ├── 1password
│   │   ├── common
│   │   ├── macos
│   │   └── ubuntu
│   ├── secrets
│   ├── setup-final.sh
│   ├── templates
│   │   ├── ci-cd
│   │   └── project
│   └── tests
├── cursor-setup
│   └── logs
├── cursor_audit_framework.py
├── cursor_audit_report.md
├── cursor_fix_report.md
├── cursor_fix_script.sh
├── dev-prod
│   ├── diagnostics
│   │   └── 1password
│   └── vps-senamfo
│       ├── .env.global
│       ├── dns
│       ├── inventory.yaml
│       ├── logs
│       ├── scripts
│       └── state
├── docker-stack
│   ├── .env.global
│   ├── agentkit
│   ├── appsmith
│   ├── audit
│   │   ├── audit_report.md
│   │   ├── audit_status.json
│   │   └── healthcheck.sh
│   ├── chromadb
│   ├── deploy.sh
│   ├── dify
│   ├── env_overview.yml
│   ├── n8n
│   ├── nextjs
│   ├── nocodb
│   ├── openwebui
│   ├── pgvector
│   ├── portainer
│   │   ├── .env.portainer
│   │   ├── .portainer.yml
│   │   └── docker-compose.yml
│   ├── postgres
│   ├── redis
│   │   ├── .env.redis
│   │   └── redis.yml
│   ├── streamlit
│   └── traefik
│       ├── .env.traefik
│       ├── acme.json
│       ├── traefik.yaml
│       └── traefik.yml -> traefik.yaml
├── dotfiles
│   ├── .git
│   │   ├── .DS_Store
│   │   ├── COMMIT_EDITMSG
│   │   ├── config
│   │   ├── hooks
│   │   ├── info
│   │   ├── logs
│   │   ├── objects
│   │   └── refs
│   ├── credentials
│   │   ├── client_secret.json
│   │   └── gcp_service_account.json
│   ├── credentials.zip
│   ├── export_1password_env.sh
│   └── sync_1password_env.sh
├── erro_zshrc_gemini.md
├── execucao_vps.md
├── fix_cwd_cleanup.sh
├── infra
│   ├── audit_stack_prod.sh
│   ├── deploy_stack_prod.sh
│   └── stack-prod
│       ├── .env
│       ├── .env.connect
│       ├── .env.template
│       ├── Makefile
│       ├── data
│       ├── docker-compose.yml
│       └── scripts
├── install-cli-action
│   ├── .git
│   │   ├── HEAD
│   │   ├── branches
│   │   ├── config
│   │   ├── description
│   │   ├── hooks
│   │   ├── index
│   │   ├── info
│   │   ├── logs
│   │   ├── objects
│   │   ├── packed-refs
│   │   └── refs
│   ├── .github
│   │   └── workflows
│   ├── .gitignore
│   ├── .husky
│   │   ├── pre-commit
│   │   └── pre-push
│   ├── .prettierignore
│   ├── CONTRIBUTING.md
│   ├── LICENSE
│   ├── README.md
│   ├── action.yml
│   ├── dist
│   │   ├── index.js
│   │   └── package.json
│   ├── eslint.config.js
│   ├── jest.config.js
│   ├── lint-staged.config.js
│   ├── package-lock.json
│   ├── package.json
│   ├── src
│   │   └── index.ts
│   ├── test
│   │   └── assert-version.sh
│   └── tsconfig.json
├── projects
├── scripts
│   ├── backup_cursor.sh
│   └── system_monitor.sh
├── snap
│   ├── cursor
│   │   ├── 1
│   │   ├── common
│   │   └── current -> 1
│   └── gemini
│       ├── 2
│       ├── common
│       └── current -> 2
├── ssh_macos.md
├── ssh_vps.md
├── ssh_vps_fix.md
├── ssh_vps_fix.md.save
├── stack-prod
├── vps_setup_complete.sh
├── vps_setup_user.sh
└── ~
    └── Dotfiles
        └── automation_1password

221 directories, 234 files
luiz.sena88@senamfo:~$ docker ps -a 
CONTAINER ID   IMAGE                           COMMAND                  CREATED      STATUS                          PORTS                                                                                                                       NAMES
e38821edf1cd   langgenius/dify-web:latest      "/bin/sh ./entrypoin…"   3 days ago   Up 3 days                       3000/tcp, 0.0.0.0:3001->80/tcp, [::]:3001->80/tcp                                                                           dify-web
5a8cbdc1142f   langgenius/dify-api:latest      "/bin/bash /entrypoi…"   3 days ago   Restarting (3) 45 seconds ago                                                                                                                               dify-api
91f49a782a00   grafana/grafana-oss:latest      "/run.sh"                3 days ago   Restarting (1) 52 seconds ago                                                                                                                               grafana
9ae37e6d51b9   portainer/portainer-ce:latest   "/portainer -H unix:…"   3 days ago   Up 3 days                       8000/tcp, 9000/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp                                                             portainer
cd1800a6f7bb   postgres:16-alpine              "docker-entrypoint.s…"   3 days ago   Up 3 days                       0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp                                                                                 postgres
9a4006b84d9e   1password/connect-api:latest    "connect-api"            3 days ago   Up 3 days                       8443/tcp, 0.0.0.0:8082->8080/tcp, [::]:8082->8080/tcp                                                                       op-connect-api
2ab9ef19e299   redis:alpine                    "docker-entrypoint.s…"   3 days ago   Up 3 days                       6379/tcp                                                                                                                    redis
953271912fe0   1password/connect-sync:latest   "connect-sync"           3 days ago   Up 3 days                                                                                                                                                   op-connect-sync
d18baafc52dc   traefik:v2.10                   "/entrypoint.sh --pr…"   3 days ago   Up 3 days                       0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   traefik
luiz.sena88@senamfo:~$ ssh -T hf.co
/home/luiz.sena88/.ssh/config: line 11: Bad configuration option: usekeychain
/home/luiz.sena88/.ssh/config: line 20: Bad configuration option: usekeychain
/home/luiz.sena88/.ssh/config: line 30: Bad configuration option: usekeychain
/home/luiz.sena88/.ssh/config: line 48: Bad configuration option: usekeychain
/home/luiz.sena88/.ssh/config: terminating, 4 bad configuration options
luiz.sena88@senamfo:~$ cat .env.1p
## vps
CF_API_KEY=c6oR2pFzX8EKzrH-hVHrakpH8m0pA8vlxLgqp1dD
CF_ZONE_ID=752bcd1ee31ef52b136a97313664140c
CF_EMAIL=luizfernandomoreirasena@gmail.com
SMTP_USER=luizfernandomoreirasena@gmail.com
SMTP_PASSWORD=nkpu slpt cxtb wymy
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
OP_CONNECT_TOKEN=ops_PLACEHOLDER_REMOVED_FOR_SECURITY
CONNECT_SERVER_VPS=luiz.sena88@senamfo:~$ env 
SHELL=/bin/bash
OP_GEMINI_CLIENT_SECRET_REF=op://Infra/Gemini OAuth Client/file
PYTHONUNBUFFERED=1
LESS=-R
NVM_INC=/home/luiz.sena88/.nvm/versions/node/v24.11.0/include/node
HISTCONTROL=ignoreboth
HISTSIZE=10000
AGENTKIT_HOME=/home/luiz.sena88/Projetos/agentkit
OP_GEMINI_SERVICE_ACCOUNT_REF=op://Infra/Gemini Service Account/file
EDITOR=vim
PWD=/home/luiz.sena88
LOGNAME=luiz.sena88
XDG_SESSION_TYPE=tty
GOOGLE_APPLICATION_CREDENTIALS=/home/luiz.sena88/Projetos/credentials/gcp_service_account.json
NODE_ENV=development
HOME=/home/luiz.sena88
LANG=C.UTF-8
LS_COLORS=di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34:
OP_SESSION_BOAC3NIIQZBF5CFNGZO36FBRIM=XPMXCnRGdBLonsHue0gNgEL0gqypVaN2U_b2C6hn-yQ
PROMPT_COMMAND=history -a
SSH_CONNECTION=138.99.33.154 24198 147.79.81.59 22
NVM_DIR=/home/luiz.sena88/.nvm
LESSCLOSE=/usr/bin/lesspipe %s %s
XDG_SESSION_CLASS=user
PYTHONPATH=:~/projects:~/projects
TERM=xterm-256color
LESSOPEN=| /usr/bin/lesspipe %s
USER=luiz.sena88
VISUAL=vim
OP_GEMINI_API_KEY_REF=op://Infra/Gemini API Key/GEMINI_API_KEY
SHLVL=1
NVM_CD_FLAGS=
GIT_EDITOR=vim
PAGER=less
XDG_SESSION_ID=688
XDG_RUNTIME_DIR=/run/user/1001
PS1=\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ 
SSH_CLIENT=138.99.33.154 24198 22
PYENV_ROOT=/home/luiz.sena88/.pyenv
XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
PROJECT_ROOT=/home/luiz.sena88/Projetos/agentkit
PATH=/home/luiz.sena88/.local/bin:/home/luiz.sena88/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/.npm-global/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/.npm-global/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/.nvm/versions/node/v24.11.0/bin:/home/luiz.sena88/.pyenv/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/bin:/home/luiz.sena88/.nvm/versions/node/v24.11.0/bin:/home/luiz.sena88/.pyenv/bin:/home/luiz.sena88/.local/bin:/home/luiz.sena88/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/luiz.sena88/.nvm/versions/node/v24.11.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin
HISTIGNORE=ls:bg:fg:history
GCP_PROJECT=gcp-ai-setup-24410
HISTFILESIZE=20000
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus
NVM_BIN=/home/luiz.sena88/.nvm/versions/node/v24.11.0/bin
SSH_TTY=/dev/pts/0
_=/usr/bin/env
luiz.sena88@senamfo:~$ cat ~/.bashrc 
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# >>> gcp dev env >>>
export GCP_PROJECT='gcp-ai-setup-24410'
export GOOGLE_APPLICATION_CREDENTIALS='/home/luiz.sena88/Projetos/credentials/gcp_service_account.json'
if [ -d "\$HOME/google-cloud-sdk/bin" ] && [[ :\$PATH: != *:"\$HOME/google-cloud-sdk/bin:"* ]]; then
  export PATH="\$HOME/google-cloud-sdk/bin:\$PATH"
fi
# <<< gcp dev env <<<


# --- SHELL CORE ENVIRONMENT ---
eval "$([ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv)"  # macOS only, no effect on Linux

# PATH configuration (universal, reforça $HOME sempre)
export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# aliases
alias checksh="shellcheck"
alias ll="ls -lah"

# pyenv initialization
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
fi

# pipx applications
if command -v pipx >/dev/null; then
        export PATH="$HOME/.local/bin:$PATH"
fi

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # Isso funciona no bash e zsh

# Carrega secrets se existir
if [ -f "$HOME/.zsh_secrets" ]; then
        source "$HOME/.zsh_secrets"
fi

# Carrega o .env do projeto padrão se existir (pode editar para outros caminhos/nomes)
if [ -f "$HOME/Projetos/agentkit/.env" ]; then
        set -a
        source "$HOME/Projetos/agentkit/.env"
        set +a
fi

# Defina variável de root do projeto (sempre em $HOME)
export AGENTKIT_HOME="$HOME/Projetos/agentkit"

# --- COPILOT UNIVERSAL --- #
# Função robusta: determina raiz do git, valida regras e faz log da execução. 
inicia_copilot() {
    local repo_root
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$AGENTKIT_HOME")"
    local rules="$repo_root/config/.copilot_rules.json"
    local log_file="$repo_root/logs/copilot_exec.log"
    if [ ! -f "$rules" ]; then
        echo "[ERRO] Regras Copilot não encontradas em $rules. Aborte." >&2
        return 1
    fi
    mkdir -p "$(dirname "$log_file")"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Iniciando Copilot em $repo_root" >> "$log_file"
    sh "$repo_root/scripts/inicia_copilot.sh"
}
alias inicia_copilot=inicia_copilot

# --- OPCIONAL: Para múltiplos projetos, exporte PROJECT_ROOT ou AGENTKIT_HOME para cada ---
# export AGENTKIT_HOME="$HOME/outro-projeto"

# --- NOTAS ---
# 1. $HOME sempre resolve para /Users/nome (macOS) OU /home/nome (Linux/Ubuntu).
# 2. Não use paths hard-coded absolutos!
# 3. Scripts, workspace e DevContainer sempre usam $HOME/projecto
# 4. Se copiar para bash, apenas troque [ e ] por test e fi na lógica condicional.

# ---------- UNIVERSAL SHELL CONFIG (macOS/Linux) ----------
[ -x /opt/homebrew/bin/brew ] && eval "$('/opt/homebrew/bin/brew' shellenv)"

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Aliases
alias checksh="shellcheck"
alias ll="ls -lah"

# pyenv initialization
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# pipx applications
if command -v pipx >/dev/null; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# nvm universal for bash/zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Vírus e .env secretos (opcional)
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"
[ -f "$HOME/.bash_secrets" ] && source "$HOME/.bash_secrets"

# Carrega .env pessoal do projeto, se existir
[ -f "$HOME/Projetos/agentkit/.env" ] && set -a && source "$HOME/Projetos/agentkit/.env" && set +a

# Projeto root (pode personalizar; sempre em $HOME)
export PROJECT_ROOT="$HOME/Projetos/agentkit"

# Função robusta e universal (bash e zsh): sempre busca .copilot_rules.json corretamente
inicia_copilot() {
  local repo_root rules log_file
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PROJECT_ROOT")"
  rules="$repo_root/config/.copilot_rules.json"
  log_file="$repo_root/logs/copilot_exec.log"
  
  if [ ! -f "$rules" ]; then
    echo "[ERRO] Regras Copilot NÃO encontradas em $rules" >&2
    return 1
  fi

  mkdir -p "$(dirname "$log_file")"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Iniciando Copilot em $repo_root" >> "$log_file"
  
  sh "$repo_root/scripts/inicia_copilot.sh"
}
alias inicia_copilot=inicia_copilot

# Variável de projeto para alternar rapidamente
export AGENTKIT_HOME="$HOME/Projetos/agentkit"
# Alias alternativo se quiser para outros projetos
# alias inicia_copilot="sh $AGENTKIT_HOME/scripts/inicia_copilot.sh"

# NOTAS UNIVERSAIS:
# - $HOME resolve automaticamente para o diretório home correto em QUALQUER UNIX (macOS/Linux)
# - Nunca escreva /Users/luiz.sena88 ou /home/luiz.sena88 diretamente.
# - Todos os scripts, automações e DevContainers podem usar $PROJECT_ROOT ou $AGENTKIT_HOME.
# - Se usar multifolders, basta exportar PROJECT_ROOT conforme o repositório atual.

# No final, toda automação e workspace funcionam de primeira sem ajustes manuais em ambos os sistemas!
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Aliases para desenvolvimento
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias h='history'
alias c='clear'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop'
alias tree='tree -C'
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'

# Aliases para Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gpl='git pull'

# Aliases para desenvolvimento
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Função para criar e ativar venv
mkvenv() {
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
}

# Função para backup
backup() {
    local backup_name="backup_$(date +%Y%m%d_%H%M%S)"
    tar -czf ~/backups/${backup_name}.tar.gz "$@"
    echo "Backup criado: ~/backups/${backup_name}.tar.gz"
}

# Função para status do sistema
status() {
    echo "=== STATUS DO SISTEMA ==="
    echo "Uptime: $(uptime)"
    echo "Memória: $(free -h | grep Mem)"
    echo "Disco: $(df -h / | tail -1)"
    echo "Processos: $(ps aux | wc -l)"
    echo "Usuários conectados: $(who | wc -l)"
    echo "========================"
}


# Prompt personalizado
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Cores para ls
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34:'


# Variáveis de ambiente para desenvolvimento
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:bg:fg:history'
export PROMPT_COMMAND='history -a'

# Python
export PYTHONPATH="${PYTHONPATH}:~/projects"
export PYTHONUNBUFFERED=1

# Node.js
export NODE_ENV=development
export PATH=~/.npm-global/bin:$PATH

# Git
export GIT_EDITOR=vim

# Cursor Agent
export PATH="$HOME/.local/bin:$PATH"


# Aliases para desenvolvimento
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias h='history'
alias c='clear'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop'
alias tree='tree -C'
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Aliases para Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gpl='git pull'

# Aliases para Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'

# Aliases para desenvolvimento
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Função para criar e ativar venv
mkvenv() {
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
}

# Função para backup
backup() {
    local backup_name="backup_$(date +%Y%m%d_%H%M%S)"
    tar -czf ~/backups/${backup_name}.tar.gz "$@"
    echo "Backup criado: ~/backups/${backup_name}.tar.gz"
}

# Função para limpeza do sistema
cleanup() {
    sudo apt autoremove -y
    sudo apt autoclean
    sudo apt clean
    docker system prune -f
    echo "Sistema limpo!"
}

# Função para status do sistema
status() {
    echo "=== STATUS DO SISTEMA ==="
    echo "Uptime: $(uptime)"
    echo "Memória: $(free -h | grep Mem)"
    echo "Disco: $(df -h / | tail -1)"
    echo "Processos: $(ps aux | wc -l)"
    echo "Usuários conectados: $(who | wc -l)"
    echo "========================"
}


# Prompt personalizado
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Cores para ls
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34:'


# Variáveis de ambiente para desenvolvimento
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:bg:fg:history'
export PROMPT_COMMAND='history -a'

# Python
export PYTHONPATH="${PYTHONPATH}:~/projects"
export PYTHONUNBUFFERED=1

# Node.js
export NODE_ENV=development
export PATH=~/.npm-global/bin:$PATH

# Git
export GIT_EDITOR=vim

# Cursor Agent
export PATH="$HOME/.local/bin:$PATH"

luiz.sena88@senamfo:~$ cd contexto_global_vps
luiz.sena88@senamfo:~/contexto_global_vps$ chmod +x *.sh 
luiz.sena88@senamfo:~/contexto_global_vps$ ./contexto_global_vps
-bash: ./contexto_global_vps: No such file or directory
luiz.sena88@senamfo:~/contexto_global_vps$ ls
generate_ai_context.sh
luiz.sena88@senamfo:~/contexto_global_vps$ ./generate_ai_context.sh
>>> Detectado Ubuntu. Coletando dados...
>>> Nota: Alguns comandos podem exigir 'sudo'. Se solicitado, digite sua senha.
[sudo] password for luiz.sena88: 
{
  "environment_context": {
    "source_script": "generate_ai_context.sh",
    "collection_timestamp": "2025-10-31T18:32:54Z",
    "detected_os": "Ubuntu",
    "remote_server": {
      "os": "Ubuntu 24.04.3 LTS",
      "architecture": "x86_64",
      "hostname": "senamfo",
      "hardware": {
        "cpu": "AMD EPYC 9354P 32-Core Processor",
        "ram_gb": "7",
        "storage_root": "Total: 96G, Usado: 15G, Livre: 82G",
        "gpu_available": false,
        "gpu_model": "Nenhuma GPU NVIDIA detectada"
      },
      "network": {
        "firewall": "UFW",
        "firewall_status": "active",
        "open_ports_detected": "22/tcp"
      },
      "ssh_server_security": {
        "port": "22 (padrão)",
        "password_auth": "não definido",
        "root_login": "no"
      },
      "tools": {
        "shell": "GNU bash, version 5.2.21(1)-release (x86_64-pc-linux-gnu)",
        "python_version": "Python 3.12.3"
      }
    }
  }
}
luiz.sena88@senamfo:~/contexto_global_vps$ cd stack-prod^C
luiz.sena88@senamfo:~/contexto_global_vps$ cd ~/stack-prod
luiz.sena88@senamfo:~/stack-prod$ ls -la 
total 8
drwxrwxr-x  2 luiz.sena88 luiz.sena88 4096 Oct 28 11:57 .
drwxr-x--- 34 luiz.sena88 luiz.sena88 4096 Oct 31 09:09 ..
luiz.sena88@senamfo:~/stack-prod$ cd ..
luiz.sena88@senamfo:~$ cd infra 
luiz.sena88@senamfo:~/infra$ ls -la 
total 24
drwxrwxr-x  3 luiz.sena88 luiz.sena88 4096 Oct 28 13:29 .
drwxr-x--- 34 luiz.sena88 luiz.sena88 4096 Oct 31 09:09 ..
-rwxrwxr-x  1 luiz.sena88 luiz.sena88  476 Oct 28 13:29 audit_stack_prod.sh
-rwxrwxr-x  1 luiz.sena88 luiz.sena88 5256 Oct 28 13:09 deploy_stack_prod.sh
drwxr-xr-x  4 luiz.sena88 luiz.sena88 4096 Oct 29 09:45 stack-prod
luiz.sena88@senamfo:~/infra$ chmod +x *.sh 
luiz.sena88@senamfo:~/infra$ ./audit_stack_prod.sh
mkdir: cannot create directory ‘/home/luiz.sena88/auditoria/deploy_logs’: Permission denied
luiz.sena88@senamfo:~/infra$ sudo ./audit_stack_prod.sh
🧾 Auditoria Stack PROD - 20251031_1834
CONTAINER ID   IMAGE                           COMMAND                  CREATED      STATUS                          PORTS                                                                                                                       NAMES
e38821edf1cd   langgenius/dify-web:latest      "/bin/sh ./entrypoin…"   3 days ago   Up 3 days                       3000/tcp, 0.0.0.0:3001->80/tcp, [::]:3001->80/tcp                                                                           dify-web
5a8cbdc1142f   langgenius/dify-api:latest      "/bin/bash /entrypoi…"   3 days ago   Restarting (3) 12 seconds ago                                                                                                                               dify-api
91f49a782a00   grafana/grafana-oss:latest      "/run.sh"                3 days ago   Restarting (1) 44 seconds ago                                                                                                                               grafana
9ae37e6d51b9   portainer/portainer-ce:latest   "/portainer -H unix:…"   3 days ago   Up 3 days                       8000/tcp, 9000/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp                                                             portainer
cd1800a6f7bb   postgres:16-alpine              "docker-entrypoint.s…"   3 days ago   Up 3 days                       0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp                                                                                 postgres
9a4006b84d9e   1password/connect-api:latest    "connect-api"            3 days ago   Up 3 days                       8443/tcp, 0.0.0.0:8082->8080/tcp, [::]:8082->8080/tcp                                                                       op-connect-api
2ab9ef19e299   redis:alpine                    "docker-entrypoint.s…"   3 days ago   Up 3 days                       6379/tcp                                                                                                                    redis
953271912fe0   1password/connect-sync:latest   "connect-sync"           3 days ago   Up 3 days                                                                                                                                                   op-connect-sync
d18baafc52dc   traefik:v2.10                   "/entrypoint.sh --pr…"   3 days ago   Up 3 days                       0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   traefik
NETWORK ID     NAME                     DRIVER    SCOPE
5de466bca578   bridge                   bridge    local
32f890141e95   host                     host      local
d526fa5cdee3   none                     null      local
4ab2d36f344f   stack-prod_traefik_net   bridge    local
DRIVER    VOLUME NAME
local     33ff8acf6142c9c3c7652ed86d1eac08778f47d123f946b5539a68df0a4887c3
local     e608b67cf434122144ae2c4fca61e618af4224e74a8e14da04a9ee61b4216b4a
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          9         9         4.459GB   29.04MB (0%)
Containers      9         9         37.08MB   0B (0%)
Local Volumes   2         2         300.6kB   0B (0%)
Build Cache     0         0         0B        0B
✅ Auditoria concluída em /home/luiz.sena88/auditoria/deploy_logs/audit_20251031_1834.log
luiz.sena88@senamfo:~/infra$ 
