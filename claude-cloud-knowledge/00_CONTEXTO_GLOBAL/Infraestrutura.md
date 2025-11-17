# Infraestrutura Completa

## Stack Tecnológica

### Backend
- Python 3.11+
- Node.js LTS
- Docker & Docker Compose

### Banco de Dados
- PostgreSQL 16-alpine
- Redis alpine

### Serviços
- Traefik v2.10 (reverse proxy)
- Portainer (gerenciamento Docker)
- NocoDB (base de dados no-code)
- n8n (automação)
- Grafana (monitoramento)
- Dify (LLM platform)

## Portas e Serviços

### macOS Local
- Traefik: 80, 443, 8080
- Portainer: 9443
- PostgreSQL: 5432
- NocoDB: 8081
- n8n: 5678
- Grafana: 3000
- Redis: 6379
- Dify API: 5001
- Dify Web: 3001

## Arquitetura

```
macOS (Dev) → Docker Compose → Serviços Locais
VPS (Prod) → Docker Compose → Serviços Produção
Codespace → DevContainer → Ambiente Isolado
```
