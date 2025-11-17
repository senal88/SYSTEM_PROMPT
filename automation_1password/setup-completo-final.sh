#!/bin/bash
# setup-completo-final.sh  
# Setup automático final com 1Password injection
# Last Updated: 2025-10-31

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║        🤖 SETUP AUTOMÁTICO FINAL - CONFIGURA TUDO              ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar 1Password
if ! op whoami &>/dev/null 2>&1; then
    echo "❌ Faça login no 1Password Desktop App primeiro"
    exit 1
fi

echo "✅ 1Password OK"

# Verificar Colima  
if ! colima status &>/dev/null 2>&1; then
    echo "📦 Iniciando Colima..."
    colima start --cpu 4 --memory 8 --disk 60 --arch aarch64 --dns 1.1.1.1 || true
    sleep 5
fi

echo "✅ Colima OK"
echo ""

# Gerar .env com valores reais
cd compose
echo "📝 Gerando .env com secrets do 1Password..."

cat > .env << 'EOF'
# === Projeto ===
PROJECT_SLUG=platform
PRIMARY_DOMAIN=localhost

# === Traefik ===
TRAEFIK_EMAIL=luiz.sena88@icloud.com

# === PostgreSQL ===
POSTGRES_USER=postgres
POSTGRES_DB=platform_db
EOF

# Injetar password PostgreSQL
POSTGRES_PASS=$(op read "op://1p_macos/PostgreSQL/password" 2>/dev/null || echo "changeme")
echo "POSTGRES_PASSWORD=$POSTGRES_PASS" >> .env

echo "" >> .env
echo "# === MongoDB ===" >> .env
echo "MONGO_ROOT_USERNAME=admin" >> .env
MONGO_PASS=$(op read "op://1p_macos/MongoDB/password" 2>/dev/null || echo "changeme")
echo "MONGO_ROOT_PASSWORD=$MONGO_PASS" >> .env
echo "MONGO_INIT_DB=platform_db" >> .env
MONGO_EXPRESS_USER=$(op read "op://1p_macos/Mongo-Express/username" 2>/dev/null || echo "admin")
MONGO_EXPRESS_PASS=$(op read "op://1p_macos/Mongo-Express/password" 2>/dev/null || echo "changeme")
echo "MONGO_EXPRESS_USER=$MONGO_EXPRESS_USER" >> .env
echo "MONGO_EXPRESS_PASSWORD=$MONGO_EXPRESS_PASS" >> .env

echo "" >> .env
echo "# === Redis ===" >> .env
REDIS_PASS=$(op read "op://1p_macos/Redis/password" 2>/dev/null || echo "changeme")
echo "REDIS_PASSWORD=$REDIS_PASS" >> .env

echo "" >> .env
echo "# === MinIO ===" >> .env
echo "MINIO_ROOT_USER=minioadmin" >> .env
MINIO_PASS=$(op read "op://1p_macos/MinIO/password" 2>/dev/null || echo "changeme")
echo "MINIO_ROOT_PASSWORD=$MINIO_PASS" >> .env

chmod 600 .env

echo "✅ .env gerado"
echo ""

# Deploy simples (10 serviços)
read -p "🚀 Fazer deploy? (s/n): " RESPONSE

if [[ "$RESPONSE" =~ ^[Ss]$ ]]; then
    docker compose up -d
    sleep 15
    echo ""
    echo "✅ Deploy concluído!"
    echo ""
    docker compose ps
    echo ""
    echo "🌐 Acesse: http://localhost:8080"
else
    echo "Execute: cd compose && docker compose up -d"
fi

