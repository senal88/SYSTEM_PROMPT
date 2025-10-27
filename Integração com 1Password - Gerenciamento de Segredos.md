# Integração com 1Password - Gerenciamento de Segredos

**Sistema de Análise Tributária - Grupo Varela**

Guia completo para integração com 1Password CLI para gerenciamento seguro de segredos e automação de deploy.

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Instalação](#instalação)
3. [Configuração](#configuração)
4. [Estrutura de Vaults](#estrutura-de-vaults)
5. [Templates de Secrets](#templates-de-secrets)
6. [Automação de Deploy](#automação-de-deploy)
7. [Integração com Docker](#integração-com-docker)
8. [Rotação de Secrets](#rotação-de-secrets)
9. [Backup e Recuperação](#backup-e-recuperação)
10. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

### Por que usar 1Password?

✅ **Segurança:**
- Secrets nunca ficam em arquivos `.env` no Git
- Criptografia AES-256
- Auditoria de acesso
- Compartilhamento seguro entre equipe

✅ **Automação:**
- Injeção automática de secrets
- Deploy sem intervenção manual
- Rotação automatizada de senhas
- Sincronização entre macOS e VPS

✅ **Organização:**
- Vaults separados por ambiente
- Tags e categorias
- Histórico de versões
- Busca rápida

### Arquitetura da Integração

```
┌─────────────────────────────────────────────────────────────┐
│                    1Password Cloud                           │
│  - Vaults (Dev, Staging, Production)                        │
│  - Items (API Keys, Passwords, Certificates)                │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                                       ▼
┌──────────────────┐                  ┌──────────────────┐
│   macOS Local    │                  │   VPS Ubuntu     │
│   1Password CLI  │                  │   1Password CLI  │
└──────────────────┘                  └──────────────────┘
        │                                       │
        ▼                                       ▼
┌──────────────────┐                  ┌──────────────────┐
│  .env.template   │                  │  .env.template   │
│  op inject       │                  │  op inject       │
│  → .env          │                  │  → .env          │
└──────────────────┘                  └──────────────────┘
        │                                       │
        ▼                                       ▼
┌──────────────────┐                  ┌──────────────────┐
│  Docker Compose  │                  │  Docker Compose  │
│  (Local Dev)     │                  │  (Production)    │
└──────────────────┘                  └──────────────────┘
```

---

## 🚀 Instalação

### 1. Instalar 1Password CLI no macOS

```bash
# Método 1: Homebrew (recomendado)
brew install --cask 1password-cli

# Método 2: Download direto
curl -sS https://downloads.1password.com/mac/1Password-CLI-latest.pkg -o 1password-cli.pkg
sudo installer -pkg 1password-cli.pkg -target /

# Verificar instalação
op --version
```

### 2. Instalar 1Password CLI na VPS Ubuntu

```bash
# Conectar na VPS
ssh vps

# Adicionar repositório oficial
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list

# Atualizar e instalar
sudo apt update
sudo apt install 1password-cli

# Verificar instalação
op --version
```

### 3. Instalar 1Password Desktop (macOS)

```bash
# Baixar da App Store ou site oficial
# https://1password.com/downloads/mac/

# Ou via Homebrew
brew install --cask 1password
```

---

## ⚙️ Configuração

### 1. Autenticar 1Password CLI no macOS

```bash
# Método 1: Usar 1Password Desktop (recomendado)
# 1. Abrir 1Password Desktop
# 2. Preferences → Developer → Enable CLI integration
# 3. Testar conexão
op account list

# Método 2: Login manual
op signin
# Seguir instruções interativas
```

### 2. Autenticar 1Password CLI na VPS

```bash
# Conectar na VPS
ssh vps

# Opção 1: Service Account (recomendado para servidores)
# 1. Criar Service Account em 1Password.com
# 2. Copiar token
export OP_SERVICE_ACCOUNT_TOKEN="ops_xxx..."

# Adicionar ao .bashrc para persistir
echo 'export OP_SERVICE_ACCOUNT_TOKEN="ops_xxx..."' >> ~/.bashrc

# Testar
op vault list

# Opção 2: Login interativo (não recomendado para automação)
op signin
```

### 3. Configurar Biometria (macOS)

```bash
# Habilitar Touch ID para 1Password CLI
# 1. Abrir 1Password Desktop
# 2. Preferences → Security → Unlock with Touch ID
# 3. Preferences → Developer → Enable Touch ID for CLI

# Testar
op item get "VPS-PostgreSQL" --fields password
# Deve solicitar Touch ID
```

---

## 🗂️ Estrutura de Vaults

### Vaults Recomendados

```
1Password Account
├── Private (Vault pessoal)
│   ├── VPS-SSH-Keys
│   ├── GitHub-Tokens
│   └── Personal-APIs
│
├── Varela-Dev (Desenvolvimento)
│   ├── Dev-PostgreSQL
│   ├── Dev-JWT-Secret
│   ├── Dev-API-Keys
│   └── Dev-Traefik-Auth
│
├── Varela-Staging (Homologação)
│   ├── Staging-PostgreSQL
│   ├── Staging-JWT-Secret
│   ├── Staging-API-Keys
│   └── Staging-Traefik-Auth
│
└── Varela-Production (Produção)
    ├── Prod-PostgreSQL
    ├── Prod-JWT-Secret
    ├── Prod-NocoDB-JWT
    ├── Prod-Gemini-API
    ├── Prod-OpenAI-API
    └── Prod-Traefik-Auth
```

### Criar Vaults

```bash
# Criar vault de produção
op vault create "Varela-Production"

# Criar vault de desenvolvimento
op vault create "Varela-Dev"

# Listar vaults
op vault list
```

---

## 🔐 Templates de Secrets

### 1. Criar Items no 1Password

#### PostgreSQL Password

```bash
# Via CLI
op item create \
  --category=password \
  --title="Prod-PostgreSQL" \
  --vault="Varela-Production" \
  password=$(openssl rand -base64 32) \
  username=varela_user \
  database=varela_tax \
  host=postgres \
  port=5432 \
  notes="PostgreSQL password for production"

# Via GUI (mais fácil)
# 1. Abrir 1Password Desktop
# 2. Varela-Production → New Item → Password
# 3. Preencher campos:
#    - Title: Prod-PostgreSQL
#    - Username: varela_user
#    - Password: (gerar senha forte)
#    - Database: varela_tax
#    - Host: postgres
#    - Port: 5432
```

#### JWT Secret

```bash
op item create \
  --category=password \
  --title="Prod-JWT-Secret" \
  --vault="Varela-Production" \
  password=$(openssl rand -hex 32) \
  notes="JWT secret for backend authentication"
```

#### NocoDB JWT Secret

```bash
op item create \
  --category=password \
  --title="Prod-NocoDB-JWT" \
  --vault="Varela-Production" \
  password=$(openssl rand -hex 32) \
  notes="NocoDB JWT secret"
```

#### Gemini API Key

```bash
op item create \
  --category=api-credential \
  --title="Prod-Gemini-API" \
  --vault="Varela-Production" \
  credential=$(cat gemini_api_key.txt) \
  url=https://ai.google.dev/ \
  notes="Google Gemini API key for AI analysis"
```

#### OpenAI API Key

```bash
op item create \
  --category=api-credential \
  --title="Prod-OpenAI-API" \
  --vault="Varela-Production" \
  credential=$(cat openai_api_key.txt) \
  url=https://platform.openai.com/ \
  notes="OpenAI API key for AgentKit"
```

#### Traefik Basic Auth

```bash
# Gerar hash de senha
TRAEFIK_HASH=$(htpasswd -nb admin sua_senha_forte)

op item create \
  --category=password \
  --title="Prod-Traefik-Auth" \
  --vault="Varela-Production" \
  password="$TRAEFIK_HASH" \
  username=admin \
  notes="Traefik dashboard basic auth"
```

### 2. Verificar Items Criados

```bash
# Listar todos os items do vault
op item list --vault="Varela-Production"

# Ver detalhes de um item
op item get "Prod-PostgreSQL" --vault="Varela-Production"

# Ver apenas o campo password
op item get "Prod-PostgreSQL" --vault="Varela-Production" --fields password
```

---

## 📝 Templates de Secrets

### 1. Criar `.env.template`

```bash
# Criar arquivo template
cat > .env.template << 'EOF'
# PostgreSQL
POSTGRES_PASSWORD=op://Varela-Production/Prod-PostgreSQL/password

# JWT & Auth
JWT_SECRET=op://Varela-Production/Prod-JWT-Secret/password
NOCODB_JWT_SECRET=op://Varela-Production/Prod-NocoDB-JWT/password

# LLM APIs
GEMINI_API_KEY=op://Varela-Production/Prod-Gemini-API/credential
OPENAI_API_KEY=op://Varela-Production/Prod-OpenAI-API/credential

# Traefik
TRAEFIK_AUTH=op://Varela-Production/Prod-Traefik-Auth/password

# Application
NODE_ENV=production
EOF
```

### 2. Sintaxe de Referências 1Password

```bash
# Formato geral
op://[vault]/[item]/[field]

# Exemplos
op://Varela-Production/Prod-PostgreSQL/password
op://Varela-Production/Prod-PostgreSQL/username
op://Varela-Production/Prod-PostgreSQL/database

# Campos customizados
op://Varela-Production/Prod-PostgreSQL/custom-field-name

# Seções
op://Varela-Production/Prod-PostgreSQL/section-name/field-name
```

### 3. Injetar Secrets

```bash
# Gerar .env a partir do template
op inject -i .env.template -o .env

# Verificar conteúdo (cuidado em produção!)
cat .env

# Resultado:
# POSTGRES_PASSWORD=xK9mP2vL8qR5nH3jT6wY...
# JWT_SECRET=a1b2c3d4e5f6g7h8i9j0...
# GEMINI_API_KEY=AIzaSyD...
# ...
```

---

## 🤖 Automação de Deploy

### 1. Script de Deploy Local (macOS)

```bash
# Criar script deploy-local.sh
cat > deploy-local.sh << 'EOF'
#!/bin/bash
set -e

echo "========================================="
echo "Deploy Local - Desenvolvimento"
echo "========================================="

# Verificar se 1Password CLI está instalado
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI não encontrado!"
    echo "Instale com: brew install --cask 1password-cli"
    exit 1
fi

# Verificar autenticação
if ! op account list &> /dev/null; then
    echo "❌ 1Password não autenticado!"
    echo "Execute: op signin"
    exit 1
fi

echo "✓ 1Password CLI autenticado"

# Injetar secrets de desenvolvimento
echo "Injetando secrets do vault Varela-Dev..."
op inject -i .env.template.dev -o .env

echo "✓ Secrets injetados"

# Iniciar Docker Compose
echo "Iniciando containers..."
docker-compose -f docker-compose.dev.yml up -d

echo "✓ Containers iniciados"

# Verificar status
echo ""
echo "Status dos containers:"
docker-compose -f docker-compose.dev.yml ps

echo ""
echo "========================================="
echo "Deploy local concluído!"
echo "========================================="
echo ""
echo "URLs de acesso:"
echo "  Frontend:   http://localhost:3000"
echo "  Backend:    http://localhost:3001"
echo "  Streamlit:  http://localhost:8501"
echo ""
EOF

chmod +x deploy-local.sh
```

### 2. Script de Deploy Remoto (VPS)

```bash
# Criar script deploy-remote.sh
cat > deploy-remote.sh << 'EOF'
#!/bin/bash
set -e

echo "========================================="
echo "Deploy Remoto - Produção"
echo "========================================="

VPS_HOST="vps"
VPS_USER="luiz.sena88"
VPS_PATH="~/app-tributario"

# Verificar se 1Password CLI está instalado
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI não encontrado!"
    exit 1
fi

# Verificar autenticação
if ! op account list &> /dev/null; then
    echo "❌ 1Password não autenticado!"
    exit 1
fi

echo "✓ 1Password CLI autenticado"

# Injetar secrets de produção localmente
echo "Injetando secrets do vault Varela-Production..."
op inject -i .env.template -o .env.prod

echo "✓ Secrets injetados"

# Fazer commit das mudanças (exceto .env)
echo "Fazendo commit das mudanças..."
git add .
git commit -m "chore: update deployment" || true
git push origin main

echo "✓ Código enviado para GitHub"

# Copiar .env para VPS
echo "Copiando .env para VPS..."
scp .env.prod $VPS_HOST:$VPS_PATH/.env

echo "✓ .env copiado"

# Remover .env local
rm .env.prod

# Executar deploy na VPS
echo "Executando deploy na VPS..."
ssh $VPS_HOST << ENDSSH
cd $VPS_PATH
git pull origin main
./deploy.sh
ENDSSH

echo "✓ Deploy executado"

echo ""
echo "========================================="
echo "Deploy remoto concluído!"
echo "========================================="
echo ""
echo "URLs de acesso:"
echo "  Frontend:   https://app-contabil.senamfo.com.br"
echo "  Backend:    https://api.senamfo.com.br"
echo "  Streamlit:  https://streamlit.senamfo.com.br"
echo ""
EOF

chmod +x deploy-remote.sh
```

### 3. Script de Deploy na VPS (Modificado)

```bash
# Modificar deploy.sh para usar 1Password
cat > deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "========================================="
echo "Deploy - Sistema de Análise Tributária"
echo "Grupo Varela - LC 214/2025"
echo "========================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}➜${NC} $1"
}

# Verificar se está rodando como root
if [ "$EUID" -eq 0 ]; then 
    print_error "Não execute este script como root"
    exit 1
fi

# Verificar se 1Password CLI está instalado e configurado
if command -v op &> /dev/null; then
    print_info "1Password CLI encontrado"
    
    # Verificar se Service Account está configurado
    if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
        print_success "Service Account configurado"
        
        # Injetar secrets do 1Password
        if [ -f .env.template ]; then
            print_info "Injetando secrets do 1Password..."
            op inject -i .env.template -o .env
            print_success "Secrets injetados do 1Password"
        else
            print_error "Arquivo .env.template não encontrado!"
            exit 1
        fi
    else
        print_info "Service Account não configurado, usando .env existente"
    fi
else
    print_info "1Password CLI não encontrado, usando .env existente"
fi

# Verificar se o arquivo .env existe
if [ ! -f .env ]; then
    print_error "Arquivo .env não encontrado!"
    echo ""
    echo "Opções:"
    echo "1. Configure 1Password Service Account:"
    echo "   export OP_SERVICE_ACCOUNT_TOKEN='ops_xxx...'"
    echo ""
    echo "2. Ou crie um arquivo .env manualmente com:"
    echo "   POSTGRES_PASSWORD=..."
    echo "   JWT_SECRET=..."
    echo "   # etc..."
    exit 1
fi

print_success "Arquivo .env encontrado"

# Continuar com o deploy normal...
# (resto do script deploy.sh original)

# Iniciar containers
print_info "Iniciando containers..."
docker-compose up -d
print_success "Containers iniciados"

# Aplicar migrations
print_info "Aplicando migrations..."
docker-compose exec -T backend pnpm db:push || true
print_success "Migrations aplicadas"

# Popular banco
print_info "Populando banco de dados..."
docker-compose exec -T backend npx tsx scripts/seed-database.ts || true
print_success "Banco de dados populado"

echo ""
echo "========================================="
echo "Deploy concluído com sucesso!"
echo "========================================="
EOF

chmod +x deploy.sh
```

---

## 🐳 Integração com Docker

### 1. Docker Compose com 1Password

```yaml
# docker-compose.yml (modificado)
version: '3.8'

services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile.backend
    environment:
      # Secrets injetados via .env (gerado pelo 1Password)
      DATABASE_URL: postgresql://varela_user:${POSTGRES_PASSWORD}@postgres:5432/varela_tax
      JWT_SECRET: ${JWT_SECRET}
      GEMINI_API_KEY: ${GEMINI_API_KEY}
      OPENAI_API_KEY: ${OPENAI_API_KEY}
    env_file:
      - .env  # Gerado por: op inject -i .env.template -o .env
```

### 2. Docker Secrets (Alternativa)

```yaml
# docker-compose.yml (usando Docker Secrets)
version: '3.8'

services:
  backend:
    secrets:
      - postgres_password
      - jwt_secret
      - gemini_api_key
      - openai_api_key
    environment:
      DATABASE_URL: postgresql://varela_user:$(cat /run/secrets/postgres_password)@postgres:5432/varela_tax

secrets:
  postgres_password:
    external: true
  jwt_secret:
    external: true
  gemini_api_key:
    external: true
  openai_api_key:
    external: true
```

```bash
# Criar secrets no Docker usando 1Password
op item get "Prod-PostgreSQL" --fields password | \
  docker secret create postgres_password -

op item get "Prod-JWT-Secret" --fields password | \
  docker secret create jwt_secret -

op item get "Prod-Gemini-API" --fields credential | \
  docker secret create gemini_api_key -

op item get "Prod-OpenAI-API" --fields credential | \
  docker secret create openai_api_key -
```

---

## 🔄 Rotação de Secrets

### 1. Script de Rotação Automática

```bash
# Criar script rotate-secrets.sh
cat > rotate-secrets.sh << 'EOF'
#!/bin/bash
set -e

echo "========================================="
echo "Rotação de Secrets"
echo "========================================="

VAULT="Varela-Production"

# Função para rotacionar senha
rotate_password() {
    local ITEM_NAME=$1
    local NEW_PASSWORD=$(openssl rand -base64 32)
    
    echo "Rotacionando: $ITEM_NAME"
    
    # Atualizar no 1Password
    op item edit "$ITEM_NAME" \
      --vault="$VAULT" \
      password="$NEW_PASSWORD"
    
    echo "✓ $ITEM_NAME rotacionado"
}

# Rotacionar PostgreSQL password
rotate_password "Prod-PostgreSQL"

# Rotacionar JWT secrets
rotate_password "Prod-JWT-Secret"
rotate_password "Prod-NocoDB-JWT"

echo ""
echo "========================================="
echo "Rotação concluída!"
echo "========================================="
echo ""
echo "IMPORTANTE: Execute deploy para aplicar novos secrets:"
echo "  ./deploy-remote.sh"
EOF

chmod +x rotate-secrets.sh
```

### 2. Rotação Agendada (Cron)

```bash
# Adicionar ao crontab (rotação mensal)
crontab -e

# Adicionar linha:
# 0 2 1 * * /home/luiz.sena88/app-tributario/rotate-secrets.sh && /home/luiz.sena88/app-tributario/deploy-remote.sh >> /home/luiz.sena88/logs/rotate-secrets.log 2>&1
```

---

## 💾 Backup e Recuperação

### 1. Exportar Vault

```bash
# Exportar vault completo (criptografado)
op vault export "Varela-Production" \
  --output-file="varela-production-backup.1pux"

# Armazenar em local seguro
# NÃO commitar no Git!
```

### 2. Importar Vault

```bash
# Importar vault de backup
op vault import \
  --file="varela-production-backup.1pux" \
  --vault="Varela-Production-Restored"
```

### 3. Backup de Items Individuais

```bash
# Exportar item específico (JSON)
op item get "Prod-PostgreSQL" \
  --vault="Varela-Production" \
  --format=json > prod-postgres-backup.json

# Restaurar item
op item create --template="$(cat prod-postgres-backup.json)"
```

---

## 🔍 Troubleshooting

### Problema: "You are not currently signed in"

```bash
# Solução 1: Verificar autenticação
op account list

# Solução 2: Fazer login novamente
op signin

# Solução 3: Verificar Service Account Token
echo $OP_SERVICE_ACCOUNT_TOKEN
```

### Problema: "Item not found"

```bash
# Verificar se item existe
op item list --vault="Varela-Production" | grep "Prod-PostgreSQL"

# Verificar nome exato
op item get "Prod-PostgreSQL" --vault="Varela-Production"

# Listar todos os items
op item list --vault="Varela-Production"
```

### Problema: "Permission denied"

```bash
# Verificar permissões do vault
op vault get "Varela-Production"

# Verificar permissões do Service Account
# (no 1Password.com → Service Accounts → Permissions)
```

### Problema: "op inject failed"

```bash
# Verificar sintaxe do template
cat .env.template

# Testar injeção com debug
op inject -i .env.template -o .env --verbose

# Verificar se referências estão corretas
# Formato: op://[vault]/[item]/[field]
```

---

## 📚 Recursos Adicionais

### Documentação Oficial

- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [1Password Service Accounts](https://developer.1password.com/docs/service-accounts/)
- [Secret References](https://developer.1password.com/docs/cli/secrets-reference-syntax/)

### Exemplos de Uso

```bash
# Listar contas
op account list

# Listar vaults
op vault list

# Listar items de um vault
op item list --vault="Varela-Production"

# Ver item completo
op item get "Prod-PostgreSQL"

# Ver apenas um campo
op item get "Prod-PostgreSQL" --fields password

# Criar item
op item create --category=password --title="Test" password="test123"

# Editar item
op item edit "Test" password="newpassword"

# Deletar item
op item delete "Test"

# Injetar secrets em arquivo
op inject -i template.txt -o output.txt

# Injetar secrets em comando
op run -- docker-compose up -d

# Usar secret em variável
PASSWORD=$(op item get "Prod-PostgreSQL" --fields password)
```

---

## ✅ Checklist de Implementação

### Configuração Inicial

- [ ] Instalar 1Password Desktop (macOS)
- [ ] Instalar 1Password CLI (macOS)
- [ ] Instalar 1Password CLI (VPS)
- [ ] Autenticar 1Password CLI (macOS)
- [ ] Criar Service Account (VPS)
- [ ] Configurar Touch ID (macOS)

### Estrutura de Vaults

- [ ] Criar vault "Varela-Production"
- [ ] Criar vault "Varela-Dev"
- [ ] Criar vault "Varela-Staging"

### Criar Items

- [ ] Prod-PostgreSQL
- [ ] Prod-JWT-Secret
- [ ] Prod-NocoDB-JWT
- [ ] Prod-Gemini-API
- [ ] Prod-OpenAI-API
- [ ] Prod-Traefik-Auth

### Templates

- [ ] Criar .env.template
- [ ] Criar .env.template.dev
- [ ] Testar injeção local
- [ ] Testar injeção remota

### Scripts de Automação

- [ ] Criar deploy-local.sh
- [ ] Criar deploy-remote.sh
- [ ] Modificar deploy.sh
- [ ] Criar rotate-secrets.sh
- [ ] Configurar cron para rotação

### Testes

- [ ] Testar deploy local
- [ ] Testar deploy remoto
- [ ] Testar rotação de secrets
- [ ] Testar backup e restauração

---

**Desenvolvido por:** Manus AI  
**Integração:** 1Password CLI + Docker + VPS  
**Status:** Guia Completo de Implementação

