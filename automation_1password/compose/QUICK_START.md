# ⚡ Quick Start - AI Stack

**Início rápido em 5 minutos!**

---

## 🚀 Passo 1: Preparar Ambiente

```bash
cd ~/Dotfiles/automation_1password/compose

# Gerar .env a partir do template (requer 1Password autenticado)
op inject -i env-ai-stack.template -o .env
chmod 600 .env
```

---

## 🐳 Passo 2: Iniciar Stack

**Para CPU (Mac/Apple Silicon ou servidores sem GPU):**
```bash
docker compose -f docker-compose-ai-stack.yml --profile cpu up -d
```

**Para GPU NVIDIA:**
```bash
docker compose -f docker-compose-ai-stack.yml --profile gpu-nvidia up -d
```

---

## ✅ Passo 3: Validar

```bash
# Verificar se containers estão rodando
docker compose -f docker-compose-ai-stack.yml ps

# Ou executar validação completa
cd ..
./scripts/validation/validate-ai-stack.sh
```

---

## 🌐 Passo 4: Acessar

| Serviço | URL | Descrição |
|---------|-----|-----------|
| **n8n** | http://localhost:5678 | Automação low-code |
| **Ollama** | http://localhost:11434 | LLMs locais |
| **Qdrant** | http://localhost:6333 | Vector store |

---

## 🔧 Comandos Úteis

```bash
# Ver logs
docker compose -f docker-compose-ai-stack.yml logs -f

# Parar stack
docker compose -f docker-compose-ai-stack.yml stop

# Reiniciar stack
docker compose -f docker-compose-ai-stack.yml restart

# Ver uso de recursos
docker stats
```

---

## 🐛 Problemas?

- **Portainer não funciona?** → `./scripts/maintenance/fix-portainer.sh`
- **Token inválido?** → Verificar no 1Password e regenerar `.env`
- **Portas em uso?** → Ver `docs/VALIDACAO_PRE_VPS.md`

---

**Documentação completa:** Ver `README_AI_STACK.md`

