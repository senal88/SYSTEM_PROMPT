#!/bin/bash
# vps_prerequisites_check.sh
# Verifica pré-requisitos na VPS Ubuntu antes do deploy

echo "=== VPS PRE-REQUISITES CHECK ==="
echo ""

echo "=== SYSTEM INFO ==="
lsb_release -a
echo ""

echo "=== DOCKER ==="
docker --version || echo "Docker NÃO instalado"
docker-compose --version || echo "Docker Compose NÃO instalado"
echo ""

echo "=== RUNTIMES ==="
python3 --version || echo "Python3 NÃO instalado"
node --version || echo "Node NÃO instalado"
echo ""

echo "=== 1PASSWORD CLI ==="
op --version || echo "1Password CLI NÃO instalado"
echo ""

echo "=== NETWORK ==="
curl -I https://senamfo.com.br 2>&1 | head -3 || echo "Domínio não acessível"
echo ""

echo "=== DISK SPACE ==="
df -h /
echo ""

echo "=== FIREWALL ==="
sudo ufw status || echo "UFW não configurado"
echo ""

echo "=== GIT ==="
git --version || echo "Git NÃO instalado"
echo ""

echo "✅ Checklist completo"
