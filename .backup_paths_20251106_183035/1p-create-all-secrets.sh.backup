#!/bin/bash
# 1p-create-all-secrets.sh
# Criar todos os secrets necessários automaticamente
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔐 Criando todos os secrets necessários no 1Password"
echo ""

# Verificar autenticação
if ! op whoami &>/dev/null 2>&1; then
    echo -e "${RED}❌ 1Password não autenticado${NC}"
    echo "Execute: unset OP_CONNECT_HOST OP_CONNECT_TOKEN && op signin"
    exit 1
fi

echo -e "${GREEN}✅ 1Password autenticado${NC}"
echo ""

# Função para gerar senha forte
generate_password() {
    openssl rand -base64 32 | tr -d '=+/' | cut -c1-32
}

# Traefik (já foi criado, pular se existir)
if op item get "Traefik" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Traefik já existe${NC}"
else
    echo "📝 Criando Traefik..."
    op item create --vault 1p_macos \
        --category password \
        --title Traefik \
        email=luizfernandomoreirasena@gmail.com \
        dashboard_auth="admin:\$$2y\$05\$$(openssl rand -base64 16 | base64 | head -c 31)=="
fi

# Databases
echo ""
echo "📝 Criando databases..."

for db in PostgreSQL MongoDB Redis; do
    if op item get "$db" --vault 1p_macos &>/dev/null 2>&1; then
        echo -e "${YELLOW}⏭️  $db já existe${NC}"
    else
        echo "  Criando $db..."
        if [ "$db" = "PostgreSQL" ]; then
            op item create --vault 1p_macos \
                --category password \
                --title "$db" \
                username=postgres \
                password="$(generate_password)" \
                database=platform_db
        elif [ "$db" = "MongoDB" ]; then
            op item create --vault 1p_macos \
                --category password \
                --title "$db" \
                username=admin \
                password="$(generate_password)" \
                init_database=platform_db
        else
            # Redis
            op item create --vault 1p_macos \
                --category password \
                --title "$db" \
                password="$(generate_password)"
        fi
    fi
done

# MongoDB Express
if op item get "Mongo-Express" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Mongo-Express já existe${NC}"
else
    echo "  Criando Mongo-Express..."
    op item create --vault 1p_macos \
        --category password \
        --title Mongo-Express \
        username=admin \
        password="$(generate_password)"
fi

# MinIO
if op item get "MinIO" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  MinIO já existe${NC}"
else
    echo "  Criando MinIO..."
    op item create --vault 1p_macos \
        --category password \
        --title MinIO \
        username=minioadmin \
        password="$(generate_password)"
fi

# Appsmith
echo ""
echo "📝 Criando Appsmith..."
if op item get "Appsmith" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Appsmith já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title Appsmith \
        email=admin@platform.local \
        password="$(generate_password)" \
        encryption_password="$(generate_password)" \
        encryption_salt="$(openssl rand -base64 16)"
fi

# n8n
echo ""
echo "📝 Criando n8n..."
if op item get "n8n" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  n8n já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title n8n \
        encryption_key="$(generate_password)" \
        jwt_secret="$(generate_password)" \
        admin_user=admin \
        admin_password="$(generate_password)"
fi

# Grafana
echo ""
echo "📝 Criando Grafana..."
if op item get "Grafana" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Grafana já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title Grafana \
        admin_user=admin \
        admin_password="$(generate_password)"
fi

# ChromaDB
echo ""
echo "📝 Criando ChromaDB..."
if op item get "ChromaDB" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  ChromaDB já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title ChromaDB \
        api_key="chroma-$(generate_password)"
fi

# Dify
echo ""
echo "📝 Criando Dify..."
if op item get "Dify" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Dify já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title Dify \
        secret_key="$(generate_password)"
fi

# Flowise
echo ""
echo "📝 Criando Flowise..."
if op item get "Flowise" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Flowise já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title Flowise \
        admin_user=admin \
        admin_password="$(generate_password)"
fi

# LibreChat
echo ""
echo "📝 Criando LibreChat..."
if op item get "LibreChat" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  LibreChat já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title LibreChat \
        jwt_secret="$(generate_password)" \
        refresh_secret="$(generate_password)"
fi

# Baserow
echo ""
echo "📝 Criando Baserow..."
if op item get "Baserow" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  Baserow já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title Baserow \
        secret_key="$(generate_password)" \
        jwt_signing_key="$(generate_password)"
fi

# NextCloud
echo ""
echo "📝 Criando NextCloud..."
if op item get "NextCloud" --vault 1p_macos &>/dev/null 2>&1; then
    echo -e "${YELLOW}⏭️  NextCloud já existe${NC}"
else
    op item create --vault 1p_macos \
        --category password \
        --title NextCloud \
        admin_user=admin \
        admin_password="$(generate_password)"
fi

echo ""
echo -e "${GREEN}✅ Todos os secrets criados com sucesso!${NC}"
echo ""
echo "📋 Verificar:"
echo "  op item list --vault 1p_macos"
echo ""

