# 🤗 Guia Completo: Hugging Face Integration

**Última atualização:** 2025-10-31  
**Versão:** 1.0.0

## 📋 Visão Geral

Este guia detalha todas as funcionalidades e integrações do Hugging Face disponíveis na stack, incluindo uso de tokens, cache, datasets e modelos.

---

## 🔑 1. Autenticação e Tokens

### Obter Token

1. Acesse: https://huggingface.co/settings/tokens
2. Crie um novo token (read ou write)
3. Token já está configurado via 1Password no item `HuggingFace-Token`

### Configurar no Projeto

```bash
# O token já está no template
grep HUGGINGFACE_TOKEN compose/env-ai-stack.template

# Após injetar com 1Password:
op inject -i compose/env-ai-stack.template -o compose/.env

# Verificar se está configurado
grep HUGGINGFACE_TOKEN compose/.env
```

### Testar Token

```bash
export HF_TOKEN=$(grep HUGGINGFACE_TOKEN compose/.env | cut -d'=' -f2)
curl -H "Authorization: Bearer ${HF_TOKEN}" https://huggingface.co/api/whoami
```

---

## 💾 2. Sistema de Cache

### Estrutura de Cache

O Hugging Face usa três tipos de cache principais:

```
/data/huggingface/
├── hub/              # Modelos baixados (modelos completos)
├── datasets/         # Datasets processados
├── transformers/      # Cache do Transformers library
└── modules/          # Módulos adicionais
```

### Configuração no Docker

Os caches estão mapeados no `docker-compose-ai-stack.yml`:

```yaml
volumes:
  huggingface_cache:
    name: ${PROJECT_SLUG:-platform}_huggingface_cache
```

E montados no container n8n como `/data/huggingface`.

### Variáveis de Ambiente

```bash
HF_HOME=/data/huggingface
HF_DATASETS_CACHE=/data/huggingface/datasets
HF_HUB_CACHE=/data/huggingface/hub
TRANSFORMERS_CACHE=/data/huggingface/transformers
```

Já configuradas automaticamente no container n8n.

---

## 📚 3. Trabalhando com Datasets

### Baixar Dataset

**Via Python (dentro do container):**

```bash
# Entrar no container
docker exec -it platform_n8n bash

# Baixar dataset
python3 << EOF
from datasets import load_dataset
dataset = load_dataset('squad', split='train')
print(f"Dataset carregado: {len(dataset)} exemplos")
EOF
```

**Via Hugging Face CLI:**

```bash
docker exec -it platform_n8n bash
export HF_TOKEN=$(grep HUGGINGFACE_TOKEN /home/node/.n8n/.env | cut -d'=' -f2)

# Baixar dataset
huggingface-cli download --dataset squad --token ${HF_TOKEN}
```

### Usar Dataset no n8n

1. Use o nó "Hugging Face Dataset"
2. Configure:
   - **Dataset Name:** `squad`, `glue`, `super_glue`, etc.
   - **Split:** `train`, `validation`, `test`
   - **Token:** `${HUGGINGFACE_TOKEN}`

### Datasets Populares

| Dataset | Descrição | Tamanho |
|---------|-----------|---------|
| `squad` | Question Answering | ~100MB |
| `glue` | General Language Understanding | ~500MB |
| `super_glue` | Enhanced GLUE | ~200MB |
| `imdb` | Sentiment Analysis | ~80MB |
| `wikitext` | Text Generation | ~500MB |

---

## 🧠 4. Trabalhando com Modelos

### Baixar Modelo

**Via Hugging Face CLI:**

```bash
docker exec -it platform_n8n bash
export HF_TOKEN=$(grep HUGGINGFACE_TOKEN /home/node/.n8n/.env | cut -d'=' -f2)

# Baixar modelo
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.2 \
    --token ${HF_TOKEN} \
    --local-dir /data/huggingface/models/mistral-7b
```

**Via Python:**

```bash
python3 << EOF
from transformers import AutoModel, AutoTokenizer
import os

model_name = "mistralai/Mistral-7B-Instruct-v0.2"
token = os.environ.get("HUGGINGFACE_TOKEN")

model = AutoModel.from_pretrained(model_name, token=token)
tokenizer = AutoTokenizer.from_pretrained(model_name, token=token)

print(f"Modelo {model_name} baixado com sucesso!")
EOF
```

### Usar Modelo no n8n

1. Use o nó "Hugging Face Model"
2. Configure:
   - **Model Name:** `mistralai/Mistral-7B-Instruct-v0.2`
   - **Task:** `text-generation`, `text-classification`, etc.
   - **Token:** `${HUGGINGFACE_TOKEN}`

### Modelos Recomendados

#### Para Text Generation

| Modelo | Tamanho | Uso |
|--------|---------|-----|
| `mistralai/Mistral-7B-Instruct-v0.2` | 7B | Conversação, instruções |
| `meta-llama/Llama-2-7b-chat-hf` | 7B | Chat, Q&A |
| `microsoft/phi-2` | 2.7B | Rápido, eficiente |
| `google/flan-t5-base` | 250M | Base, rápido |

#### Para Embeddings

| Modelo | Dimensões | Uso |
|--------|-----------|-----|
| `sentence-transformers/all-MiniLM-L6-v2` | 384 | Geral |
| `sentence-transformers/all-mpnet-base-v2` | 768 | Alta qualidade |

#### Para Classificação

| Modelo | Task | Uso |
|--------|------|-----|
| `distilbert-base-uncased-finetuned-sst-2-english` | Sentiment | Análise de sentimento |
| `cardiffnlp/twitter-roberta-base-sentiment` | Sentiment | Twitter |

---

## 🔌 5. Hugging Face Inference Server

### Habilitar Inference Server

O inference server está disponível como profile opcional:

```bash
docker compose -f docker-compose-ai-stack.yml \
    --profile cpu \
    --profile hf-inference \
    up -d
```

### Configurar Modelo

Edite `.env`:

```bash
HF_MODEL_ID=mistralai/Mistral-7B-Instruct-v0.2
```

Ou modelos menores para teste:

```bash
HF_MODEL_ID=microsoft/phi-2
```

### Usar Inference API

```bash
# Testar endpoint
curl http://localhost:8080/generate \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": "What is machine learning?",
    "parameters": {
      "max_new_tokens": 100,
      "temperature": 0.7
    }
  }'
```

### Integrar com n8n

1. Use o nó "HTTP Request"
2. URL: `http://huggingface-inference:80/generate`
3. Method: `POST`
4. Body: JSON com `inputs` e `parameters`

---

## 🔄 6. Integração com Ollama (Alternativa Local)

Se preferir modelos completamente locais (sem sair do servidor):

### Baixar Modelo via Ollama

```bash
docker exec -it platform_ollama ollama pull llama3.2:1b
docker exec -it platform_ollama ollama pull mistral
docker exec -it platform_ollama ollama pull phi
```

### Usar no n8n

1. Use o nó "Ollama"
2. Configure:
   - **Ollama Host:** `http://ollama:11434`
   - **Model:** `llama3.2:1b`, `mistral`, etc.
   - **Prompt:** Sua pergunta ou instrução

### Comparação: Hugging Face vs Ollama

| Aspecto | Hugging Face | Ollama |
|---------|--------------|--------|
| **Modelos** | Todos do Hub | Modelos suportados |
| **Armazenamento** | Cache persistente | Volume Docker |
| **Performance** | Depende do modelo | Otimizado local |
| **Uso de GPU** | Suportado | Suportado (NVIDIA) |
| **Internet** | Requer (download) | Não (após download) |

---

## 📊 7. Casos de Uso Práticos

### Caso 1: Chatbot com Contexto

**Stack:**
- n8n (orquestração)
- Ollama (LLM local)
- Qdrant (vector store para contexto)
- Hugging Face (embeddings)

**Workflow:**
1. Recebe pergunta do usuário
2. Gera embedding da pergunta (HF)
3. Busca contexto similar no Qdrant
4. Gera resposta com Ollama + contexto
5. Retorna resposta

### Caso 2: Análise de Sentimento em Tempo Real

**Stack:**
- n8n (webhook trigger)
- Hugging Face (modelo de sentimento)
- PostgreSQL (armazenar resultados)

**Workflow:**
1. Recebe texto via webhook
2. Classifica sentimento (HF)
3. Armazena resultado no PostgreSQL
4. Notifica se sentimento negativo

### Caso 3: Geração de Texto com Fine-tuning

**Stack:**
- Hugging Face (modelo base)
- n8n (pipeline de fine-tuning)
- Datasets HF

**Workflow:**
1. Baixa dataset do HF
2. Prepara dados para fine-tuning
3. Executa fine-tuning (se tiver GPU)
4. Salva modelo customizado

---

## 🛠️ 8. Comandos Úteis

### Limpar Cache

```bash
# Limpar cache de modelos
docker exec platform_n8n rm -rf /data/huggingface/hub/*

# Limpar cache de datasets
docker exec platform_n8n rm -rf /data/huggingface/datasets/*

# Limpar tudo
docker volume rm platform_huggingface_cache
docker compose -f docker-compose-ai-stack.yml up -d n8n
```

### Ver Tamanho do Cache

```bash
docker exec platform_n8n du -sh /data/huggingface/*
```

### Listar Modelos Baixados

```bash
docker exec platform_n8n ls -lh /data/huggingface/hub/
```

### Verificar Token

```bash
docker exec platform_n8n bash -c 'export HF_TOKEN=$(grep HUGGINGFACE_TOKEN /home/node/.n8n/.env | cut -d"=" -f2) && huggingface-cli whoami --token ${HF_TOKEN}'
```

---

## 🐛 9. Troubleshooting

### Token Inválido

```bash
# Verificar token no .env
grep HUGGINGFACE_TOKEN compose/.env

# Atualizar token no 1Password e regenerar
op inject -i compose/env-ai-stack.template -o compose/.env
docker compose -f docker-compose-ai-stack.yml restart n8n
```

### Modelo não baixa

```bash
# Verificar logs
docker compose -f docker-compose-ai-stack.yml logs n8n | grep -i huggingface

# Verificar espaço em disco
df -h

# Baixar manualmente com verbose
docker exec -it platform_n8n bash
export HF_TOKEN=$(grep HUGGINGFACE_TOKEN /home/node/.n8n/.env | cut -d"=" -f2)
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.2 --token ${HF_TOKEN} -v
```

### Cache corrompido

```bash
# Limpar cache específico
docker exec platform_n8n rm -rf /data/huggingface/hub/models--mistralai--Mistral-7B-Instruct-v0.2

# Rebaixar modelo
docker exec -it platform_n8n bash
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.2 --token ${HF_TOKEN}
```

---

## 📚 10. Recursos Adicionais

### Documentação Oficial

- [Hugging Face Docs](https://huggingface.co/docs)
- [Transformers Library](https://huggingface.co/docs/transformers)
- [Datasets Library](https://huggingface.co/docs/datasets)
- [Hub API](https://huggingface.co/docs/hub/api)

### Modelos Populares

- [Model Hub](https://huggingface.co/models)
- [Datasets Hub](https://huggingface.co/datasets)
- [Spaces](https://huggingface.co/spaces)

### Tutoriais

- [Getting Started with Transformers](https://huggingface.co/docs/transformers/training)
- [Fine-tuning Guide](https://huggingface.co/docs/transformers/training)
- [Deploy Models](https://huggingface.co/docs/hub/models-using-transformers)

---

## ✅ Checklist de Configuração

- [ ] Token HF criado e configurado no 1Password
- [ ] Token injetado no `.env` via `op inject`
- [ ] Cache volumes criados e montados
- [ ] Modelo testado baixado com sucesso
- [ ] Dataset testado carregado com sucesso
- [ ] n8n consegue usar nós Hugging Face
- [ ] Inference server funcionando (se habilitado)
- [ ] Integração com Ollama testada (alternativa)

---

**Próximos passos:** Ver `README_AI_STACK.md` para instruções completas de instalação.

