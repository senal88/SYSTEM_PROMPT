# 📋 GUIA RÁPIDO - Sistema de Coletas VPS

**Versão:** 2.0.0
**Data:** 2025-11-28
**Status:** Ativo e Funcional

---

## 🚀 Início Rápido

### 1. Deploy dos Scripts (do macOS)

Execute do macOS para fazer deploy dos scripts na VPS:

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./deploy-scripts-vps.sh
```

Este script:
- Testa conexão SSH com a VPS
- Cria estrutura de diretórios na VPS
- Envia scripts de coleta e análise
- Configura permissões de execução
- Valida instalação

### 2. Executar Coleta Completa da VPS

Na VPS (via SSH):

```bash
ssh admin-vps
cd /home/admin/Dotfiles/system_prompts/global/scripts
./coleta-vps.sh
```

Ou diretamente:

```bash
ssh admin-vps "/home/admin/Dotfiles/system_prompts/global/scripts/coleta-vps.sh"
```

### 3. Gerar Prompt Consolidado para LLMs

Na VPS (após coleta):

```bash
ssh admin-vps
cd /home/admin/Dotfiles/system_prompts/global/scripts
./analise-e-sintese-vps.sh
```

Ou diretamente:

```bash
ssh admin-vps "/home/admin/Dotfiles/system_prompts/global/scripts/analise-e-sintese-vps.sh"
```

---

## 📁 Arquivos Criados

### Estrutura na VPS

```
/home/admin/Dotfiles/system_prompts/global/
├── scripts/
│   ├── coleta-vps.sh              # Script de coleta completa
│   └── analise-e-sintese-vps.sh   # Script de análise e síntese
├── audit/
│   └── YYYYMMDD_HHMMSS/
│       └── vps/                    # Dados coletados da VPS
│           ├── 01_sistema_hardware.txt
│           ├── 02_recursos_sistema.txt
│           ├── 03_processos_top.txt
│           ├── 04_servicos_ativos.txt
│           ├── 05_docker_geral.txt
│           ├── 06_docker_containers.txt
│           ├── 07_docker_swarm_stacks.txt
│           ├── 08_docker_networks_volumes.txt
│           ├── 09_rede_interfaces.txt
│           ├── 10_rede_portas_ativas.txt
│           ├── 11_estrutura_diretorios.txt
│           ├── 12_git_repos.txt
│           ├── 13_shell_config.txt
│           ├── 14_pacotes_apt.txt
│           └── 15_firewall.txt
├── analysis/
│   └── YYYYMMDD_HHMMSS/
│       └── CONTEXT_VPS_RAW.txt    # Contexto consolidado
└── prompts/
    └── YYYYMMDD_HHMMSS/
        ├── system_prompt_vps_global_YYYYMMDD_HHMMSS.md  # Prompt completo
        └── vps-full_YYYYMMDD_HHMMSS.txt                  # Arquivo para LLMs
```

---

## 📊 O Que É Coletado

### Sistema e Hardware
- Informações do sistema operacional (Ubuntu 24.04 LTS)
- Versão do kernel
- Uptime do sistema

### Recursos do Sistema
- Uso de disco (df -h)
- Uso de memória (free -h)
- Informações da CPU

### Processos
- Top 25 processos por memória
- Top 25 processos por CPU

### Serviços Systemd
- Serviços ativos
- Serviços falhados

### Docker
- Informações gerais do Docker
- Containers rodando
- Imagens disponíveis
- Docker Swarm (se configurado)
- Redes e volumes Docker

### Rede
- Interfaces de rede
- Tabela de roteamento
- Portas ativas (ss -tulpn)

### Estrutura de Diretórios
- ~/Dotfiles (até 3 níveis)
- ~/infra-vps (até 3 níveis)
- ~/scripts (até 2 níveis)

### Git
- Status do repositório infra-vps
- Branch atual
- Últimos commits
- Status Git

### Shell Configuration
- .bashrc
- .bash_profile
- Variáveis de ambiente importantes

### Pacotes APT
- Lista de pacotes instalados
- Contagem total

### Firewall
- Status do UFW (se configurado)

---

## 🔄 Fluxo Completo

### Pipeline Completo (do macOS)

```bash
# 1. Deploy dos scripts
cd ~/Dotfiles/system_prompts/global/scripts
./deploy-scripts-vps.sh

# 2. Executar coleta na VPS
ssh admin-vps "/home/admin/Dotfiles/system_prompts/global/scripts/coleta-vps.sh"

# 3. Gerar prompt consolidado
ssh admin-vps "/home/admin/Dotfiles/system_prompts/global/scripts/analise-e-sintese-vps.sh"
```

### Pipeline Completo (na VPS)

```bash
# Conectar na VPS
ssh admin-vps

# Executar coleta
/home/admin/Dotfiles/system_prompts/global/scripts/coleta-vps.sh

# Gerar prompt consolidado
/home/admin/Dotfiles/system_prompts/global/scripts/analise-e-sintese-vps.sh
```

---

## 📥 Como Usar os Prompts Gerados

### Prompt Completo (Markdown)

Arquivo: `prompts/YYYYMMDD_HHMMSS/system_prompt_vps_global_YYYYMMDD_HHMMSS.md`

Use este arquivo para:
- Documentação completa
- Referência técnica
- Integração em documentação

### Arquivo Consolidado para LLMs (Texto)

Arquivo: `prompts/YYYYMMDD_HHMMSS/vps-full_YYYYMMDD_HHMMSS.txt`

Use este arquivo para:
- Importação em ChatGPT Custom Instructions
- Importação em Claude System Prompt
- Importação em Gemini Custom Instructions
- Importação em Perplexity Custom Instructions

---

## 🔧 Manutenção

### Atualizar Coleta

Execute periodicamente (recomendado: semanalmente):

```bash
ssh admin-vps "/home/admin/Dotfiles/system_prompts/global/scripts/coleta-vps.sh && /home/admin/Dotfiles/system_prompts/global/scripts/analise-e-sintese-vps.sh"
```

### Automatizar com Cron

Adicione ao crontab da VPS para execução automática:

```bash
# Executar diariamente às 02:00
0 2 * * * /home/admin/Dotfiles/system_prompts/global/scripts/coleta-vps.sh && /home/admin/Dotfiles/system_prompts/global/scripts/analise-e-sintese-vps.sh
```

### Limpar Auditorias Antigas

Manter apenas as últimas 10 auditorias:

```bash
ssh admin-vps "cd /home/admin/Dotfiles/system_prompts/global/audit && ls -td */ | tail -n +11 | xargs rm -rf"
```

---

## 📝 Notas Importantes

- **Segurança:** Nenhuma credencial é exposta nos arquivos gerados
- **Versionamento:** Cada auditoria é salva com timestamp único
- **Retenção:** Manter últimas 10 auditorias (limpar manualmente se necessário)
- **Dependências:** Scripts requerem Docker, systemctl, git (se aplicável)
- **Permissões:** Scripts são executáveis e não requerem sudo (exceto para UFW)

---

## 🆘 Troubleshooting

### Erro: "Nenhuma auditoria encontrada"

Execute primeiro:
```bash
ssh admin-vps "/home/admin/Dotfiles/system_prompts/global/scripts/coleta-vps.sh"
```

### Erro: "Permissão negada"

Adicione permissão de execução:
```bash
ssh admin-vps "chmod +x /home/admin/Dotfiles/system_prompts/global/scripts/*.sh"
```

### Erro: "DOTFILES_DIR não definido"

O script usa `~/.bashrc` que deve ter:
```bash
export DOTFILES_DIR="/home/admin/Dotfiles"
```

Se não estiver definido, o script usa `~/Dotfiles` como padrão.

### Erro: "Conexão SSH falhou"

Verifique:
- Alias SSH configurado: `ssh admin-vps`
- Chaves SSH autorizadas
- Host acessível

---

## 🔗 Integração com Sistema macOS

Os scripts VPS seguem o mesmo padrão dos scripts macOS:

- **Estrutura:** Mesma organização de diretórios
- **Formato:** Mesmo formato de saída
- **Versionamento:** Mesmo sistema de timestamps
- **Consolidação:** Mesmo processo de análise e síntese

Isso permite:
- Comparação entre ambientes
- Consolidação futura de prompts
- Manutenção unificada

---

**Última Atualização:** 2025-11-28
**Status:** Ativo e Funcional
**Versão:** 2.0.0

