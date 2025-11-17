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
