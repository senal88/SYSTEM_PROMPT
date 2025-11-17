# ⏱️ Fix: Erro 504 Gateway Timeout - Setup n8n

**Problema:** Erro 504 ao tentar criar conta owner no n8n

---

## 🔍 Diagnóstico

**Erro:** `Request failed with status code 504`

**Causa:** Timeout do Traefik muito baixo para operações longas (setup inicial)

---

## ✅ Correção Aplicada

**Arquivo:** `docker-compose.traefik-existing.yml`

**Mudanças:**
- ✅ Timeout de leitura: 300s (5 minutos)
- ✅ Timeout de escrita: 300s (5 minutos)
- ✅ Timeout idle: 90s

**Labels adicionadas:**
```yaml
- "traefik.http.services.n8n.loadbalancer.server.transport.respondingTimeouts.readTimeout=300s"
- "traefik.http.services.n8n.loadbalancer.server.transport.respondingTimeouts.writeTimeout=300s"
- "traefik.http.services.n8n.loadbalancer.server.transport.respondingTimeouts.idleTimeout=90s"
```

---

## 🚀 Aplicar Correção

**Já aplicado automaticamente!**

Container n8n foi recriado com novas configurações.

---

## ✅ Próximos Passos

### 1. Aguardar n8n Reiniciar

```bash
# Verificar status
docker compose -f docker-compose.traefik-existing.yml ps n8n
```

### 2. Tentar Setup Novamente

**No navegador:**
1. Acessar: `https://n8n.senamfo.com.br`
2. Aguardar carregar completamente
3. Preencher formulário de setup:
   - Email: `luizfernandomoreirasena@gmail.com`
   - Nome: `Luiz Fernando`
   - Sobrenome: `Moreira Sena`
   - Senha: (sua senha)
4. Clicar em "Set up owner account"

**Agora deve funcionar sem timeout!**

---

## 🔍 Se Ainda Falhar

### Verificar Logs

```bash
# Logs do n8n
docker logs platform_n8n --tail=50

# Logs do Traefik
docker logs traefik --tail=50 | grep n8n
```

### Verificar se n8n está Processando

```bash
# Verificar se n8n está respondendo
curl -I https://n8n.senamfo.com.br/healthz

# Verificar uso de recursos
docker stats platform_n8n --no-stream
```

### Alternativa: Acesso Direto Temporário

**Se Traefik ainda causar problemas:**

```bash
# Expor porta temporariamente
# Editar docker-compose.traefik-existing.yml
# Descomentar: ports: - "5678:5678"
# Acessar: http://147.79.81.59:5678
# Depois voltar configuração Traefik
```

---

## 📊 Timeouts Configurados

| Timeout | Valor | Descrição |
|---------|-------|-----------|
| readTimeout | 300s | Tempo para ler resposta |
| writeTimeout | 300s | Tempo para escrever requisição |
| idleTimeout | 90s | Tempo de conexão idle |

**Suficiente para setup inicial do n8n.**

---

## ✅ Status

**Correção:** Aplicada  
**Container:** Recriado  
**Próximo:** Tentar setup novamente no navegador

---

**Timeouts aumentados - tente criar a conta novamente!**

