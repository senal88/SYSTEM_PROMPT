# 🎯 Plano de Ação Completo - Infraestrutura Definitiva
**Data:** 2025-10-31  
**Objetivo:** Criar ambiente de produção 100% funcional e integrado  
**Ambientes:** macOS Silicon + VPS Ubuntu

---

## 📋 DIAGNÓSTICO ATUAL

### ✅ O Que Está Funcionando
- Docker/Colima instalado e operacional
- 1Password CLI instalado com `op-cli` funcionando
- Raycast instalado
- Portainer deployado (porta 9000)
- Templates env criados

### ❌ O Que NÃO Está Funcionando
1. **1Password Connect**: NÃO há servidor rodando
2. **Docker Stacks**: Configurações incompletas, sem scripts Raycast
3. **HuggingFace Pro**: Não integrado
4. **VPS Ubuntu**: Nada implementado ainda
5. **MCP Servers**: Não configurados

---

## 🚀 FASE 1: 1Password Connect - AUTOMAÇÃO REAL

### Objetivo
**CRIAR servidor Connect funcional no macOS** que:
- Fornece API REST para acessar vaults
- Permite integração automática com apps
- Elimina necessidade de `op signin` manual
- Funciona 24/7 em background

### Passos

#### 1.1 Criar credentials.json
```bash
# NÃO USAR credenciais hardcoded!
# Buscar do 1Password via op-cli
```

#### 1.2 Deploy Connect Server
```bash
cd connect
docker compose up -d
```

#### 1.3 Validar Health
```bash
curl http://localhost:8080/v1/health
curl http://localhost:8080/v1/vaults
```

#### 1.4 Integrar no Ambiente
```bash
# Carregar variáveis automaticamente no shell
source env/macos.env
```

---

## 🐳 FASE 2: Docker Stacks Completas + Raycast

### Objetivo
**Todas as stacks Docker** com:
- Scripts de deploy/teste/teardown
- Snippets Raycast para comandos frequentes
- Shortcuts Raycast para abrir interfaces
- Comandos CLI unificados

### Stacks Prioritárias

#### 2.1 Portainer (✅ Deployado)
**Ações:**
- ✅ Container rodando
- ⏳ Criar script Raycast para abrir
- ⏳ Shortcut `CMD+Space → "Portainer"`

#### 2.2 Traefik
**Ações:**
- Deploy com Let's Encrypt
- Dashboard protegido
- Scripts de controle

#### 2.3 Databases
- PostgreSQL + pgvector
- MongoDB
- Redis

#### 2.4 Low-Code Platforms
- Appsmith
- n8n
- Flowise
- Baserow

#### 2.5 AI/LLM
- LibreChat
- Dify
- ChromaDB

---

## 🤖 FASE 3: HuggingFace Pro Integration

### Objetivo
**Integração completa HuggingFace Pro** com:
- Acesso automático ao 1TB dataset
- Pipeline para upload/download
- Agentes de processamento
- Integração com MCP

### Passos

#### 3.1 Token e Configuração
```bash
# Token já existe no 1p_macos
op-cli item get HuggingFace-Token --vault 1p_macos
```

#### 3.2 Instalar Transformers/Datasets
```bash
pip install transformers datasets huggingface_hub
```

#### 3.3 Configurar Caches
```bash
export HF_HOME=~/huggingface
export HF_DATASETS_CACHE=~/huggingface/datasets
export HF_HUB_CACHE=~/huggingface/hub
```

#### 3.4 Criar Dataset para Documentos
```python
# Script para processar documentos fiscais/contábeis
# Upload automático para Hub
```

---

## 🎯 FASE 4: Raycast Completo

### Objetivo
**Interface unificada** para:
- Acessar todas as ferramentas
- Executar comandos complexos com 1 clique
- Integrar com 1Password
- Mostrar status de serviços

### Scripts a Criar

#### 4.1 Docker Management
```
portainer-open.sh       # Abre Portainer
docker-status.sh        # Status de containers
stack-deploy.sh         # Deploy stack
stack-logs.sh           # Ver logs
```

#### 4.2 1Password Integration
```
op-search.sh            # Buscar senha
op-generate.sh          # Gerar senha
op-cli-status.sh        # Status CLI
```

#### 4.3 HuggingFace
```
hf-download.sh          # Baixar dataset
hf-upload.sh            # Upload dataset
hf-training-status.sh   # Status treinamento
```

#### 4.4 Quick Actions
```
open-localhost-services.sh  # Abrir todas UIs
backup-stack.sh             # Backup completo
restore-stack.sh            # Restore
```

---

## 🐧 FASE 5: VPS Ubuntu Espelhamento

### Objetivo
**Replicar EXATAMENTE** tudo do macOS na VPS

### Passos

#### 5.1 Setup Inicial
```bash
# SSH para VPS
ssh usuario@vps.senamfo.com.br
```

#### 5.2 Deploy 1Password Connect
```bash
# Mesmo setup do macOS
cd ~/automation_1password/connect
docker compose up -d
```

#### 5.3 Deploy Todas Stacks
```bash
# Usar mesmo docker-compose.yml
# Ajustar apenas domínios/production
```

#### 5.4 Validar Espelhamento
```bash
# Comparar serviços macOS vs VPS
# Garantir mesmas versões
```

---

## 🔗 FASE 6: MCP Servers

### Objetivo
**Configurar MCP servers** para:
- Acesso aos vaults 1Password
- Manipulação de datasets HuggingFace
- Controle de stacks Docker
- Integração com Cursor/Claude

### Servers Prioritários

#### 6.1 1Password MCP
```bash
# Integração com Connect Server
# Comandos: get, set, search, generate
```

#### 6.2 HuggingFace MCP
```bash
# Manipulação de datasets
# Comandos: upload, download, process
```

#### 6.3 Docker MCP
```bash
# Controle de containers
# Comandos: status, logs, deploy
```

---

## ✅ CRITÉRIOS DE SUCESSO

### Por Fase

#### FASE 1 ✅
- [ ] `curl http://localhost:8080/v1/vaults` retorna JSON
- [ ] Sem erros no `docker compose logs`
- [ ] Variáveis automáticas no shell

#### FASE 2 ✅
- [ ] Todas stacks deployadas
- [ ] Scripts Raycast funcionando
- [ ] Shortcuts criados

#### FASE 3 ✅
- [ ] `huggingface-cli login` funcional
- [ ] Datasets processados e no Hub
- [ ] Agentes básicos funcionando

#### FASE 4 ✅
- [ ] Scripts Raycast testados
- [ ] Integrações funcionando
- [ ] Interface intuitiva

#### FASE 5 ✅
- [ ] VPS idêntica ao macOS
- [ ] Todas stacks rodando
- [ ] Zero diferenças de config

#### FASE 6 ✅
- [ ] MCP servers respondendo
- [ ] Integração com Cursor testada
- [ ] Documentação completa

---

## 📝 ORDEM DE EXECUÇÃO

```
1. FASE 1 (1Password Connect)    ← CRÍTICO
2. FASE 2 (Docker + Raycast)     ← CRÍTICO
3. FASE 4 (Raycast completo)     ← DEPENDE DE 2
4. FASE 3 (HuggingFace)          ← PARALELO COM 4
5. FASE 5 (VPS)                  ← DEPENDE DE TODAS
6. FASE 6 (MCP)                  ← BOA PRA TER
```

---

## 🔄 PADRÃO DE TRABALHO

### Antes de Começar
1. ✅ Validar pré-requisitos
2. ✅ Backup de configs atuais
3. ✅ Criar branch Git
4. ✅ Documentar mudanças

### Durante Execução
1. ✅ Testar cada mudança
2. ✅ Commitar incrementalmente
3. ✅ Validar não quebrou nada
4. ✅ Documentar em tempo real

### Após Concluir
1. ✅ Validar critérios de sucesso
2. ✅ Rodar testes completos
3. ✅ Documentar final
4. ✅ Deploy/migrate se aplicável

---

## 📚 DOCUMENTAÇÃO EXIGIDA

Para cada fase:
- README explicando setup
- Scripts com comentários
- Runbook de operação
- Troubleshooting guide

---

## ⏱️ ESTIMATIVA

- **FASE 1:** 1-2 horas (Connect)
- **FASE 2:** 3-4 horas (Stacks)
- **FASE 4:** 2-3 horas (Raycast)
- **FASE 3:** 2-4 horas (HuggingFace)
- **FASE 5:** 4-6 horas (VPS)
- **FASE 6:** 2-3 horas (MCP)

**Total:** 14-22 horas de trabalho focado

---

## 🎯 PRÓXIMO PASSO IMEDIATO

**Vamos começar pela FASE 1** - o bloqueador crítico é a falta de automação real do 1Password.

**Começar agora?** `make 1password.connect.setup`

