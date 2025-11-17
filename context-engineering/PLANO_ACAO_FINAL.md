# Plano de Ação Final - Sistema Completo DevOps Híbrido

## 🎯 Objetivo

Estruturar e implementar sistema completo de DevOps híbrido com melhorias práticas, integrações completas e automação total para ambientes macOS Silicon (dev) e VPS Ubuntu (prod).

---

## 📊 Estrutura do Plano

### 1. Configuração Base ✅
### 2. Integrações Essenciais ⚠️
### 3. Automação e Deploy ⚠️
### 4. Monitoramento e Segurança ⚠️
### 5. Documentação e Manutenção ⚠️

---

## FASE 1: Configuração Base ✅ (COMPLETA)

### 1.1 1Password CLI - Automação Completa ✅

**Status:** ✅ Implementado e Funcional

**Arquivos Criados:**
- `~/.config/op/op_config.sh` - Configuração centralizada
- `~/.config/op/vault_config.json` - Mapeamento de vaults
- `~/Dotfiles/automation_1password/scripts/op-export-vault.sh` - Exportação
- `~/Dotfiles/automation_1password/scripts/op-init.sh` - Inicialização
- `~/Dotfiles/automation_1password/README.md` - Documentação

**Funcionalidades:**
- ✅ Wrapper inteligente do `op` (resolve conflito CLI/Connect)
- ✅ Funções de gerenciamento (op-signin-auto, op-vault-switch, etc.)
- ✅ Detecção automática de contexto (macOS vs VPS)
- ✅ Exportação de dados das vaults

**Ações Concluídas:**
- [x] Comentar OP_CONNECT_* no .zprofile
- [x] Criar wrapper inteligente no .zshrc
- [x] Implementar funções de gerenciamento
- [x] Criar script de exportação
- [x] Documentar tudo

### 1.2 Context Engineering - Sistema Completo ✅

**Status:** ✅ Implementado e Funcional

**Arquivos Criados:**
- `context-engineering/.cursorrules` - Regras globais
- `context-engineering/cursor-rules/` - Regras específicas por ambiente
- `vscode/snippets/` - Snippets VSCode/Cursor
- `raycast/snippets/` - Snippets Raycast
- `context-engineering/scripts/` - Scripts de setup
- `context-engineering/templates/` - Templates para LLMs

**Funcionalidades:**
- ✅ Cursor Rules para todos os ambientes
- ✅ Snippets para 1Password, Python, Shell
- ✅ Configurações VSCode/Cursor
- ✅ Scripts de setup automatizado

---

## FASE 2: Integrações Essenciais ⚠️ (PENDENTE)

### 2.1 Hugging Face - Integração Completa

#### 2.1.1 Configuração de Tokens

**Ação:**
```bash
# Criar item no 1Password
op item create \
  --category=password \
  --title="Hugging Face Token" \
  --vault=1p_macos \
  --field="username=senal88" \
  --field="password=<token>" \
  --field="url=https://huggingface.co/settings/tokens"
```

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/hf-setup.sh`

```bash
#!/bin/bash
# Setup Hugging Face CLI com 1Password

set -euo pipefail

# Obter token do 1Password
HF_TOKEN=$(op item get "Hugging Face Token" --vault 1p_macos --field password)

# Login no Hugging Face CLI
echo "$HF_TOKEN" | huggingface-cli login

# Configurar variáveis de ambiente
export HF_TOKEN="$HF_TOKEN"
export HF_ENDPOINT_URL="https://endpoints.huggingface.co/senal88/endpoints/all-minilm-l6-v2-bks"

echo "✅ Hugging Face configurado"
```

#### 2.1.2 Funções de Gerenciamento

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/hf-functions.sh`

```bash
# Funções Hugging Face
hf-login() {
    local token=$(op item get "Hugging Face Token" --vault 1p_macos --field password)
    echo "$token" | huggingface-cli login
}

hf-deploy-model() {
    local model_path="$1"
    huggingface-cli upload senal88/"$model_path" "$model_path"
}

hf-query-endpoint() {
    local prompt="$1"
    curl -X POST "$HF_ENDPOINT_URL" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"inputs\": \"$prompt\"}"
}
```

#### 2.1.3 Integração com .zshrc

**Adicionar ao .zshrc:**
```bash
# Hugging Face Integration
if [ -f "$HOME/Dotfiles/automation_1password/scripts/hf-functions.sh" ]; then
    source "$HOME/Dotfiles/automation_1password/scripts/hf-functions.sh"
fi
```

### 2.2 GitHub - Integração Completa

#### 2.2.1 Configuração de Tokens

**Ação:**
```bash
# Criar item no 1Password
op item create \
  --category=password \
  --title="GitHub Token" \
  --vault=1p_macos \
  --field="username=luiz.sena88" \
  --field="password=<token>" \
  --field="url=https://github.com/settings/tokens"
```

#### 2.2.2 Scripts de Gerenciamento

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/gh-setup.sh`

```bash
#!/bin/bash
# Setup GitHub CLI com 1Password

set -euo pipefail

# Obter token do 1Password
GH_TOKEN=$(op item get "GitHub Token" --vault 1p_macos --field password)

# Login no GitHub CLI
echo "$GH_TOKEN" | gh auth login --with-token

# Configurar Git
git config --global user.name "Luiz Sena"
git config --global user.email "luiz.sena88@icloud.com"
git config --global init.defaultBranch main

echo "✅ GitHub configurado"
```

#### 2.2.3 Configuração de SSH

**Ação:**
```bash
# Obter SSH key do 1Password (se existir)
op item get "GitHub SSH Key" --vault 1p_macos --field "private_key" > ~/.ssh/id_ed25519_github
chmod 600 ~/.ssh/id_ed25519_github

# Adicionar ao SSH config
cat >> ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
EOF
```

### 2.3 Sincronização entre Ambientes

#### 2.3.1 Script de Sincronização

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/sync-configs.sh`

```bash
#!/bin/bash
# Sincronizar configurações entre macOS e VPS

set -euo pipefail

VPS_HOST="${1:-vps-hostname}"
VPS_USER="${2:-user}"

# Arquivos a sincronizar
FILES=(
    ".config/op/op_config.sh"
    ".config/op/vault_config.json"
    "Dotfiles/automation_1password/"
    "Dotfiles/context-engineering/"
    "Dotfiles/vscode/"
)

# Sincronizar via rsync
for file in "${FILES[@]}"; do
    rsync -avz "$HOME/$file" "$VPS_USER@$VPS_HOST:~/$file"
done

echo "✅ Configurações sincronizadas"
```

---

## FASE 3: Automação e Deploy ⚠️ (PENDENTE)

### 3.1 Scripts de Deploy para VPS

#### 3.1.1 Deploy Principal

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/deploy-to-vps.sh`

```bash
#!/bin/bash
# Deploy automatizado para VPS

set -euo pipefail

VPS_HOST="${1:-vps-hostname}"
VPS_USER="${2:-user}"
PROJECT_DIR="${3:-~/infra/stack-prod}"

# Validar pré-requisitos
op-config-check || exit 1

# Obter secrets do 1Password
export POSTGRES_PASSWORD=$(op item get "PostgreSQL Password" --vault 1p_vps --field password)
export GRAFANA_PASSWORD=$(op item get "Grafana Password" --vault 1p_vps --field password)

# Deploy via SSH
ssh "$VPS_USER@$VPS_HOST" << EOF
cd $PROJECT_DIR
git pull
docker-compose down
docker-compose up -d --build
docker-compose ps
EOF

echo "✅ Deploy concluído"
```

#### 3.1.2 Validação Pré-Deploy

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/validate-deploy.sh`

```bash
#!/bin/bash
# Validar ambiente antes de deploy

set -euo pipefail

# Verificar 1Password
op-config-check || exit 1

# Verificar Docker
docker ps > /dev/null || exit 1

# Verificar Git
git status > /dev/null || exit 1

# Verificar conexão VPS
ssh -o ConnectTimeout=5 "$VPS_USER@$VPS_HOST" echo "OK" || exit 1

echo "✅ Validação passou"
```

### 3.2 Backup Automatizado

#### 3.2.1 Script de Backup

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/backup-all.sh`

```bash
#!/bin/bash
# Backup completo de configurações

set -euo pipefail

BACKUP_DIR="$HOME/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup 1Password
op-export-vault.sh --all
cp -r ~/.config/op/vault_data "$BACKUP_DIR/"

# Backup dotfiles
cp -r ~/Dotfiles "$BACKUP_DIR/"

# Backup configurações shell
cp ~/.zshrc ~/.zprofile "$BACKUP_DIR/"

# Compactar
tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"
rm -rf "$BACKUP_DIR"

echo "✅ Backup criado: $BACKUP_DIR.tar.gz"
```

---

## FASE 4: Monitoramento e Segurança ⚠️ (PENDENTE)

### 4.1 Health Checks

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/health-check.sh`

```bash
#!/bin/bash
# Health check de todos os serviços

# Verificar 1Password
op-config-check

# Verificar Docker
docker ps

# Verificar serviços locais
curl -f http://localhost:8080/ping || echo "Traefik não responde"
curl -f http://localhost:5432 || echo "PostgreSQL não responde"

# Verificar VPS (se configurado)
# ssh vps-host "docker-compose ps"
```

### 4.2 Alertas Automatizados

**Integração com n8n:**
- Webhook para notificações
- Alertas de erro
- Status de deploy

---

## FASE 5: Documentação e Manutenção ⚠️ (PENDENTE)

### 5.1 Runbooks Operacionais

**Criar:** `~/Dotfiles/docs/runbooks/`

- Deploy manual
- Rollback
- Troubleshooting
- Recuperação de desastres

### 5.2 Changelog Automatizado

**Script a Criar:** `~/Dotfiles/automation_1password/scripts/update-changelog.sh`

---

## 📋 Checklist de Implementação

### Fase 2: Integrações (Prioridade Alta)
- [x] Implementar `hf-setup.sh` e `hf-functions.sh` ✅
- [x] Implementar `gh-setup.sh` ✅
- [ ] Criar items no 1Password para tokens (Hugging Face, GitHub) - Executar scripts
- [ ] Configurar SSH para GitHub - Executar gh-setup.sh
- [ ] Implementar `sync-configs.sh`
- [ ] Testar todas as integrações

### Fase 3: Automação (Prioridade Alta)
- [ ] Implementar `deploy-to-vps.sh`
- [ ] Implementar `validate-deploy.sh`
- [ ] Implementar `backup-all.sh`
- [ ] Configurar cron jobs para backup
- [ ] Testar deploy completo

### Fase 4: Monitoramento (Prioridade Média)
- [ ] Implementar `health-check.sh`
- [ ] Configurar alertas no n8n
- [ ] Criar dashboards no Grafana
- [ ] Configurar notificações

### Fase 5: Documentação (Prioridade Média)
- [ ] Criar runbooks operacionais
- [ ] Documentar processos completos
- [ ] Criar guias de troubleshooting
- [ ] Atualizar README principal

---

## 🎯 Métricas de Sucesso

### Objetivos
- ✅ 100% das configurações versionadas
- ✅ 0% de secrets hardcoded
- ✅ Deploy automatizado funcional
- ✅ Backup diário automático
- ✅ Monitoramento ativo
- ✅ Documentação completa

### KPIs
- Tempo de deploy: < 5 minutos
- Tempo de rollback: < 2 minutos
- Uptime dos serviços: > 99.9%
- Cobertura de backup: 100%

---

## 📅 Cronograma Sugerido

### Semana 1: Integrações
- Dias 1-2: Hugging Face
- Dias 3-4: GitHub
- Dia 5: Sincronização e testes

### Semana 2: Automação
- Dias 1-2: Scripts de deploy
- Dias 3-4: Backup e validação
- Dia 5: Testes completos

### Semana 3: Monitoramento e Documentação
- Dias 1-2: Health checks e alertas
- Dias 3-4: Runbooks e documentação
- Dia 5: Revisão final

---

**Status:** Em Planejamento
**Última atualização:** 2025-11-04
**Versão:** 1.0.0

