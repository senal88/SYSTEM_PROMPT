# 🚀 AI Stack Integrada - Guia Completo

**Última atualização:** 2025-10-31  
**Versão:** 1.0.0

## 📋 Visão Geral

Esta stack integra o [n8n Self-hosted AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit) com Hugging Face e componentes adicionais para criar um ambiente completo de automação com IA.

### Componentes Incluídos

✅ **n8n** - Plataforma low-code com 400+ integrações e nós AI avançados  
✅ **Ollama** - Execução local de LLMs (Llama, Mistral, Phi, etc.)  
✅ **Qdrant** - Vector store de alta performance para embeddings  
✅ **PostgreSQL + pgvector** - Banco de dados vetorial para n8n e Qdrant  
✅ **Hugging Face** - Integração completa (token, cache, datasets, inference server)

---

## 🔧 Pré-requisitos

### 1. Docker e Docker Compose

```bash
# Verificar instalação
docker --version
docker compose version

# Para Apple Silicon (M1/M2/M3)
docker info | grep Architecture
# Deve mostrar: Architecture: aarch64
```

### 2. 1Password CLI Configurado

```bash
# Verificar autenticação
op whoami

# Secrets necessários no vault `1p_macos`:
# - PostgreSQL/username
# - PostgreSQL/password
# - PostgreSQL/database
# - n8n/encryption_key
# - n8n/jwt_secret
# - HuggingFace-Token/credential
```

### 3. Recursos do Sistema

**Mínimo recomendado:**
- CPU: 4 cores
- RAM: 8GB
- Disco: 20GB livres

**Para GPU (NVIDIA):**
- NVIDIA Docker runtime instalado
- CUDA 11.8+ ou 12.0+

---

## 🚀 Instalação Rápida

### Passo 1: Preparar Ambiente

```bash
cd ~/Dotfiles/automation_1password/compose

# Gerar .env a partir do template
op inject -i env-ai-stack.template -o .env
chmod 600 .env
```

### Passo 2: Iniciar Stack

**Para CPU (Mac/Apple Silicon ou servidores sem GPU):**
```bash
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d
```

**Para GPU NVIDIA:**
```bash
docker compose -f docker-compose-ai-stack.yml --profile gpu-nvidia up -d
```

**Com Hugging Face Inference Server:**
```bash
docker compose -f docker-compose-ai-stack.yml --profile cpu --profile hf-inference up -d
```

### Passo 3: Importar Workflows Demo (Opcional)

```bash
# Importar workflows de exemplo do starter kit
docker compose -f docker-compose-ai-stack.yml --profile init up n8n-import
```

### Passo 4: Verificar Status

```bash
# Ver containers rodando
docker compose -f docker-compose-ai-stack.yml ps

# Ver logs
docker compose -f docker-compose-ai-stack.yml logs -f n8n
```

---

## 🔗 Acessos

| Serviço | URL Local | Descrição |
|---------|-----------|-----------|
| **n8n** | http://localhost:5678 | Interface principal de automação |
| **Ollama** | http://localhost:11434 | API de LLMs locais |
| **Qdrant** | http://localhost:6333 | Dashboard do vector store |
| **Qdrant Admin** | http://localhost:6333/dashboard | Interface web |
| **HF Inference** | http://localhost:8080 | Server de inferência (se habilitado) |

---

## 🤗 Configuração Hugging Face Completa

### 1. Configurar Token

O token já está configurado via `.env` (via 1Password):

```bash
# Verificar se está configurado
grep HUGGINGFACE_TOKEN compose/.env
```

### 2. Configurar Cache

Os caches do Hugging Face são mapeados automaticamente no container:

```bash
# No container n8n, os caches estão em:
# - /data/huggingface/hub        (modelos baixados)
# - /data/huggingface/datasets   (datasets)
# - /data/huggingface/transformers (transformers cache)
```

### 3. Usar no n8n

No n8n, use o nó "Hugging Face" e configure:

- **API Token:** `${HUGGINGFACE_TOKEN}` (já configurado)
- **Model Name:** Escolha do Hugging Face Hub
- **Task Type:** Text Generation, Classification, etc.

### 4. Baixar Modelos/Datasets Manualmente

```bash
# Entrar no container n8n
docker exec -it platform_n8n bash

# Configurar token
export HF_TOKEN=$(grep HUGGINGFACE_TOKEN /home/node/.n8n/.env | cut -d'=' -f2)

# Baixar modelo
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.2 --token $HF_TOKEN

# Baixar dataset
python3 -c "from datasets import load_dataset; load_dataset('squad', split='train')"
```

### 5. Usar com Ollama (Alternativa)

Se preferir modelos locais via Ollama:

1. No n8n, use o nó "Ollama"
2. Configure: `OLLAMA_HOST=http://ollama:11434`
3. Use modelos já baixados: `llama3.2`, `mistral`, `phi`, etc.

---

## 📊 Estrutura de Volumes

```
Volumes criados:
├── platform_postgres_ai_data      # Banco do n8n
├── platform_n8n_data              # Configurações do n8n
├── platform_n8n_shared             # Arquivos compartilhados
├── platform_ollama_data            # Modelos Ollama baixados
├── platform_qdrant_data            # Vector store
├── platform_huggingface_cache      # Cache HF (hub, datasets)
└── platform_huggingface_models     # Modelos HF baixados
```

---

## 🔄 Comandos Úteis

### Iniciar/Parar

```bash
# Iniciar
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d

# Parar
docker compose -f docker-compose-ai-stack.yml stop

# Parar e remover volumes (CUIDADO!)
docker compose -f docker-compose-ai-stack.yml down -v
```

### Atualizar

```bash
# Pull de imagens atualizadas
docker compose -f docker-compose-ai-stack.yml --profile cpu pull

# Recriar containers
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d --force-recreate
```

### Logs

```bash
# Todos os serviços
docker compose -f docker-compose-ai-stack.yml logs -f

# Apenas n8n
docker compose -f docker-compose-ai-stack.yml logs -f n8n

# Ollama
docker compose -f docker-compose-ai-stack.yml logs -f ollama
```

### Backup

```bash
# Backup do banco PostgreSQL
docker exec platform_postgres_ai pg_dump -U n8n n8n > backup_n8n_$(date +%Y%m%d).sql

# Backup de volumes
docker run --rm -v platform_n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n_backup_$(date +%Y%m%d).tar.gz /data
```

---

## 🐛 Troubleshooting

### Porta 5678 já em uso

```bash
# Verificar o que está usando
lsof -i :5678

# Parar serviço conflitante ou mudar porta no docker-compose
```

### Ollama não baixa modelos

```bash
# Verificar logs
docker compose -f docker-compose-ai-stack.yml logs ollama

# Baixar manualmente
docker exec -it platform_ollama ollama pull llama3.2:1b
```

### n8n não conecta no PostgreSQL

```bash
# Verificar se PostgreSQL está healthy
docker compose -f docker-compose-ai-stack.yml ps postgres-ai

# Verificar logs
docker compose -f docker-compose-ai-stack.yml logs postgres-ai

# Testar conexão manual
docker exec -it platform_postgres_ai psql -U n8n -d n8n
```

### Hugging Face token inválido

```bash
# Verificar token no .env
grep HUGGINGFACE_TOKEN compose/.env

# Atualizar token no 1Password e regenerar .env
op inject -i env-ai-stack.template -o .env
docker compose -f docker-compose-ai-stack.yml restart n8n
```

---

## 📚 Recursos Adicionais

### Documentação Oficial

- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Documentation](https://ollama.ai/docs)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
- [Hugging Face Documentation](https://huggingface.co/docs)

### Templates n8n

- [n8n AI Template Gallery](https://n8n.io/workflows/?category=ai)
- [Starter Kit Workflows](./n8n-ai-starter/n8n/demo-data/workflows/)

### Tutoriais

- [AI Agents for Developers: From Theory to Practice](https://n8n.io/blog/ai-agents-for-developers/)
- [Build an AI Workflow in n8n](https://n8n.io/blog/build-an-ai-workflow-in-n8n/)
- [Langchain Concepts in n8n](https://docs.n8n.io/langchain/)

---

## ✅ Checklist de Validação

Antes de subir para VPS, validar:

- [ ] Todos os containers estão rodando (`docker compose ps`)
- [ ] n8n acessível em http://localhost:5678
- [ ] Ollama responde em http://localhost:11434/api/tags
- [ ] Qdrant responde em http://localhost:6333/health
- [ ] PostgreSQL aceita conexões
- [ ] Hugging Face token válido (testado em workflow)
- [ ] Workflows demo importados e funcionando
- [ ] Volumes persistindo dados corretamente
- [ ] Logs sem erros críticos
- [ ] Recursos do sistema adequados (CPU/RAM)

---

**Próximos passos:** Ver `VALIDACAO_VPS.md` para checklist completo antes do deploy.

