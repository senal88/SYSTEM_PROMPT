# ✅ Validação Pré-VPS - Checklist Completo

**Última atualização:** 2025-10-31  
**Versão:** 1.0.0

Este documento lista **todos** os requisitos e validações necessárias antes de fazer deploy da stack para a VPS Ubuntu.

---

## 🎯 Objetivo

Garantir que a stack esteja **100% funcional, validada e leve** antes do deploy remoto, evitando problemas em produção.

---

## 📋 Checklist Geral

### 1. Infraestrutura Local

- [ ] Docker e Docker Compose instalados e funcionando
- [ ] Colima rodando (macOS) ou Docker nativo (Linux)
- [ ] Portas necessárias livres (5678, 11434, 6333, 5432, 9000)
- [ ] Recursos suficientes (RAM: 8GB+, Disco: 20GB+)
- [ ] 1Password CLI autenticado (`op whoami`)

### 2. Configuração

- [ ] `.env` gerado a partir dos templates via `op inject`
- [ ] Todas as variáveis de ambiente obrigatórias preenchidas
- [ ] Secrets configurados no 1Password (vaults `1p_macos` e `1p_vps`)
- [ ] Tokens de API válidos (Hugging Face, OpenAI, etc.)

### 3. Stack AI

- [ ] `docker-compose-ai-stack.yml` validado sintaticamente
- [ ] Containers sobem sem erros (`docker compose up -d`)
- [ ] n8n acessível em http://localhost:5678
- [ ] Ollama responde em http://localhost:11434/api/tags
- [ ] Qdrant responde em http://localhost:6333/health
- [ ] PostgreSQL aceita conexões
- [ ] Hugging Face token válido e testado

### 4. Portainer

- [ ] Portainer corrigido e funcionando
- [ ] Acessível em http://localhost:9000
- [ ] Autenticação configurada
- [ ] Consegue gerenciar containers Docker

### 5. Validações de Funcionalidade

- [ ] n8n consegue conectar no PostgreSQL
- [ ] n8n consegue usar nós Hugging Face
- [ ] n8n consegue usar nó Ollama
- [ ] Qdrant aceita inserções de vetores
- [ ] Workflows demo importados e funcionando
- [ ] Volumes persistindo dados corretamente

---

## 🔧 Scripts de Validação

### Validação Automática

Execute o script completo de validação:

```bash
cd ~/Dotfiles/automation_1password
./scripts/validation/validate-ai-stack.sh
```

### Validações Individuais

**1. Docker:**
```bash
docker info
docker compose version
```

**2. Portas:**
```bash
./scripts/validation/validate-ai-stack.sh  # Inclui verificação de portas
```

**3. Containers:**
```bash
cd compose
docker compose -f docker-compose-ai-stack.yml ps
```

**4. Serviços:**
```bash
# PostgreSQL
docker exec platform_postgres_ai pg_isready -U n8n

# n8n
curl http://localhost:5678/healthz

# Qdrant
curl http://localhost:6333/health

# Ollama
curl http://localhost:11434/api/tags
```

**5. Hugging Face:**
```bash
# Verificar token
export HF_TOKEN=$(grep HUGGINGFACE_TOKEN compose/.env | cut -d'=' -f2)
curl -H "Authorization: Bearer ${HF_TOKEN}" https://huggingface.co/api/whoami
```

---

## 📊 Métricas de Performance

### Antes de Subir para VPS

| Métrica | Mínimo | Recomendado | Status |
|---------|--------|-------------|--------|
| **Uptime** | 24h sem crashes | 7 dias | [ ] |
| **RAM uso** | < 80% | < 60% | [ ] |
| **CPU uso** | < 80% | < 60% | [ ] |
| **Disco** | > 10GB livre | > 20GB livre | [ ] |
| **Latência n8n** | < 2s | < 500ms | [ ] |
| **Latência Ollama** | < 5s | < 2s | [ ] |

### Coletar Métricas

```bash
# Uptime dos containers
docker compose -f compose/docker-compose-ai-stack.yml ps --format "table {{.Name}}\t{{.Status}}\t{{.Uptime}}"

# Uso de recursos
docker stats --no-stream

# Espaço em disco
df -h
docker system df
```

---

## 🔒 Segurança

### Checklist de Segurança

- [ ] Senhas fortes configuradas (mínimo 16 caracteres)
- [ ] Tokens de API com permissões mínimas necessárias
- [ ] `.env` com permissão 600 (`chmod 600`)
- [ ] Secrets nunca commitados no Git
- [ ] Firewall configurado (se aplicável)
- [ ] Traefik com HTTPS habilitado (para VPS)
- [ ] Backups automáticos configurados

### Verificações

```bash
# Permissões de arquivos sensíveis
ls -la compose/.env
# Deve mostrar: -rw------- (600)

# Secrets no Git (não devem aparecer)
git grep -i "password\|token\|secret" -- "*.yml" "*.yaml" "*.env" | grep -v "op://"
# Não deve retornar resultados
```

---

## 📦 Otimização para VPS

### 1. Reduzir Tamanho das Imagens

```bash
# Limpar imagens não utilizadas
docker system prune -a --volumes

# Ver tamanho atual
docker images --format "table {{.Repository}}\t{{.Size}}"
```

### 2. Configurar Profiles Apropriados

Para VPS sem GPU:
```bash
# Usar profile CPU
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d
```

Para VPS com GPU NVIDIA:
```bash
# Usar profile GPU
docker compose -f docker-compose-ai-stack.yml --profile gpu-nvidia up -d
```

### 3. Limitar Recursos

Adicionar limits no `docker-compose-ai-stack.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 4G
    reservations:
      cpus: '1.0'
      memory: 2G
```

### 4. Remover Serviços Opcionais

Se não usar Hugging Face Inference Server:
```bash
# Não incluir profile hf-inference
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d
```

---

## 🧪 Testes de Carga

### Teste Básico

```bash
# Testar n8n com múltiplas requisições
for i in {1..10}; do
  curl -s http://localhost:5678/healthz
  echo "Request $i"
done
```

### Teste Ollama

```bash
# Testar geração de texto
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:1b",
  "prompt": "Hello, how are you?",
  "stream": false
}'
```

---

## 📝 Documentação

### Antes de Deploy

- [ ] README atualizado com instruções de deploy
- [ ] Troubleshooting documentado
- [ ] Credenciais de acesso documentadas (sem valores)
- [ ] Procedimentos de backup documentados
- [ ] Procedimentos de restore documentados

---

## 🚀 Procedimento de Deploy VPS

### Passo 1: Preparar VPS

```bash
# No VPS, instalar pré-requisitos
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER

# Clonar repositório
git clone <repo-url> ~/automation_1password
cd ~/automation_1password
```

### Passo 2: Configurar Secrets

```bash
# Autenticar 1Password no VPS
op signin

# Gerar .env
cd compose
op inject -i env-ai-stack.template -o .env
chmod 600 .env
```

### Passo 3: Deploy

```bash
# Iniciar stack
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d

# Verificar logs
docker compose -f docker-compose-ai-stack.yml logs -f
```

### Passo 4: Validação Pós-Deploy

```bash
# Executar validação no VPS
./scripts/validation/validate-ai-stack.sh

# Testar endpoints
curl http://localhost:5678/healthz
curl http://localhost:11434/api/tags
```

---

## ✅ Checklist Final

Antes de considerar a stack pronta para VPS:

- [ ] ✅ Todas as validações passaram
- [ ] ✅ Performance dentro dos limites
- [ ] ✅ Segurança verificada
- [ ] ✅ Documentação completa
- [ ] ✅ Testes de carga executados
- [ ] ✅ Backup configurado
- [ ] ✅ Rollback plan documentado
- [ ] ✅ Monitoramento configurado (opcional)

---

## 🐛 Problemas Conhecidos e Soluções

### Portainer não inicia

**Solução:**
```bash
./scripts/maintenance/fix-portainer.sh
```

### Porta 9000 em uso

**Solução:**
```bash
lsof -Pi :9000 -sTCP:LISTEN
kill <PID>
```

### Ollama não baixa modelos

**Solução:**
```bash
docker exec -it platform_ollama ollama pull llama3.2:1b
```

### n8n não conecta no PostgreSQL

**Solução:**
```bash
# Verificar se PostgreSQL está healthy
docker compose -f docker-compose-ai-stack.yml ps postgres-ai

# Ver logs
docker compose -f docker-compose-ai-stack.yml logs postgres-ai
```

---

## 📞 Suporte

Se encontrar problemas não documentados:

1. Verificar logs: `docker compose logs -f`
2. Executar validação: `./scripts/validation/validate-ai-stack.sh`
3. Consultar documentação: `docs/README_AI_STACK.md`
4. Ver troubleshooting: `docs/HUGGINGFACE_GUIA_COMPLETO.md`

---

**Próximo passo após validação:** Ver `docs/DEPLOY_VPS.md` (a ser criado) para procedimento completo de deploy.

