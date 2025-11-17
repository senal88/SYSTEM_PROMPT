<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# 📦 Pacote Completo: Base de Conhecimento "GEM Expert AgentBuild"

## Integração Perplexity + Gemini CLI + Raycast + gemflow no macOS


***

## 🎯 Visão Geral da Integração

Este documento consolida o **setup completo** para transformar sua base de conhecimento AgentBuilder em um **agente executável com GUI nativa** no macOS, integrando:

1. **Perplexity** → Base de conhecimento (RAG)
2. **Gemini CLI** → Geração de prompts e planos
3. **Raycast** → Interface gráfica local
4. **gemflow** → Orquestração e execução segura
5. **AgentBuilder API** → Motor de decisão do agente

***

## 📋 1. Arquitetura da Solução

```
┌─────────────────────────────────────────────────────────────┐
│                    USUÁRIO (macOS)                          │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
          ┌───────────────────────┐
          │   RAYCAST (GUI)       │
          │   Script Command      │
          └───────────┬───────────┘
                      │ Prompt em linguagem natural
                      ▼
          ┌───────────────────────┐
          │  agent_gateway.py     │
          │  (Orquestrador)       │
          └───────┬───────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
        ▼                   ▼
┌───────────────┐   ┌──────────────────┐
│ AgentBuilder  │   │  Perplexity KB   │
│  API (OpenAI) │   │  (RAG + Sources) │
└───────┬───────┘   └──────────────────┘
        │
        ▼
┌───────────────────────┐
│  Resposta + Plano     │
│  JSON {"actions":[]}  │
└───────────┬───────────┘
            │
            ▼ Confirmação usuário
┌───────────────────────┐
│   gemflow Executor    │
│   (Planos locais)     │
└───────────────────────┘
```


***

## 📁 2. Estrutura de Arquivos da Base de Conhecimento

### **Hierarquia Completa**

```
10_knowledge_base/                    # ← Upload para Perplexity
│
├── README_index.md                   # Índice principal (escopo, prioridades)
├── 30_prompts_library.md             # System prompts + schemas JSON
├── 99_changelog_governance.md        # SLAs + versionamento SemVer
│
├── 40_tools/                         # Especificações de Ferramentas
│   ├── index.json                    # Índice + políticas globais
│   ├── customers_api.json            # Spec completa (Bearer, retries)
│   ├── orders_api.json               # CRUD de pedidos
│   ├── knowledge_search.json         # RAG interno (top_k, threshold)
│   ├── code_executor.json            # Sandbox Python (limites)
│   └── web_fetch.json                # Scraping (robots.txt, max_bytes)
│
├── 50_corpus/                        # Documentação Técnica
│   ├── metadata.json                 # Config RAG (chunk 800, overlap 150)
│   └── docs/
│       ├── agent_vs_workflow.md      # Decisão arquitetural
│       ├── rag_practices.md          # Chunking + re-ranking + citação
│       ├── security_guardrails.md    # PII + prompt injection
│       ├── tools_integration.md      # APIs + circuit breaker
│       ├── observability_costs.md    # SLAs + telemetria
│       ├── deployment_chatkit_sdk.md # Opções de implantação
│       └── prompt_testing_versioning.md # Golden tests + CI/CD
│
├── 60_glossary.csv                   # 42 termos técnicos
├── 70_eval_set.jsonl                 # 10 casos de teste
```


### **Metadados dos Arquivos-Chave**

| Arquivo | Tipo | Tamanho Aprox. | Prioridade | Uso no Agente |
| :-- | :-- | :-- | :-- | :-- |
| `README_index.md` | Índice | 8 KB | **Crítica** | Orienta busca no RAG |
| `30_prompts_library.md` | Prompts | 15 KB | **Crítica** | System prompt + schemas |
| `40_tools/index.json` | Config | 2 KB | **Crítica** | Políticas de ferramentas |
| `50_corpus/metadata.json` | Config | 5 KB | **Crítica** | Parâmetros RAG |
| `50_corpus/docs/*.md` | Técnico | 120 KB | **Crítica** | Conhecimento core |
| `60_glossary.csv` | Taxonomia | 3 KB | Alta | Consistência terminológica |
| `70_eval_set.jsonl` | Testes | 2 KB | Alta | Validação de qualidade |
| `99_changelog_governance.md` | Governança | 10 KB | Média | SLAs e políticas |


***

## 🛠️ 3. Setup do Ambiente Local (macOS Silicon)

### **A. Dependências do Sistema**

```bash
# 1. Instalar Homebrew (se ainda não tiver)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Instalar ferramentas essenciais
brew install jq python@3.11 git

# 3. Verificar instalações
jq --version      # ≥ 1.6
python3 --version # ≥ 3.11
git --version     # ≥ 2.40
```


### **B. Estrutura do Projeto Local**

```bash
# Criar estrutura (se ainda não existe)
mkdir -p ~/Projetos/perplexity/{30_scripts/{pipeline,helpers,plans},90_output/{dist,execution_logs,quarantine}}

cd ~/Projetos/perplexity

# Estrutura esperada:
.
├── 10_knowledge_base/          # KB pronta para upload
├── 20_source_data/             # Pipeline ETL
├── 30_scripts/
│   ├── gemflow                 # Orquestrador
│   ├── agent_gateway.py        # Gateway AgentBuilder ← NOVO
│   ├── chat-com-agentbuilder.sh # Raycast Script ← NOVO
│   ├── pipeline/
│   ├── helpers/
│   └── plans/
└── 90_output/
```


***

## 🔑 4. Configuração de Credenciais

### **A. Chaves de API (Segurança)**

```bash
# Criar arquivo .env no diretório do projeto
cat > ~/Projetos/perplexity/.env << 'EOF'
# OpenAI AgentBuilder API
OPENAI_API_KEY="sk-proj-..."

# Perplexity API (para enriquecimento)
PERPLEXITY_API_KEY="pplx-..."

# Agent ID (após criar agente no OpenAI)
AGENT_ID="asst_..."
EOF

# Proteger o arquivo
chmod 600 ~/Projetos/perplexity/.env

# Adicionar ao .gitignore
echo ".env" >> ~/Projetos/perplexity/.gitignore
```


### **B. Alternativa: Keychain do macOS (Recomendado)**

```bash
# Armazenar chave de forma segura
security add-generic-password \
  -a "$USER" \
  -s "openai_agentbuilder" \
  -w "sk-proj-SEU_TOKEN_AQUI"

# Recuperar em scripts
export OPENAI_API_KEY=$(security find-generic-password \
  -a "$USER" \
  -s "openai_agentbuilder" \
  -w)
```


***

## 💻 5. Implementação dos Componentes

### **A. Gateway do Agente (`agent_gateway.py`)**

```bash
cat > ~/Projetos/perplexity/30_scripts/agent_gateway.py << 'GATEWAY_EOF'
#!/usr/bin/env python3
"""
Agent Gateway - Orquestrador local para AgentBuilder
Integra: Raycast → OpenAI AgentBuilder → gemflow
"""

import os
import sys
import json
import subprocess
from pathlib import Path
from openai import OpenAI

# Configuração
PROJECT_ROOT = Path.home() / "Projetos" / "perplexity"
ENV_FILE = PROJECT_ROOT / ".env"

# Carregar variáveis de ambiente
if ENV_FILE.exists():
    with open(ENV_FILE) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, value = line.strip().split('=', 1)
                os.environ[key] = value.strip('"')

client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
AGENT_ID = os.environ.get("AGENT_ID")

def call_agent(user_prompt: str) -> dict:
    """Envia prompt ao AgentBuilder e retorna resposta estruturada"""
    try:
        # Criar thread
        thread = client.beta.threads.create()
        
        # Adicionar mensagem
        client.beta.threads.messages.create(
            thread_id=thread.id,
            role="user",
            content=user_prompt
        )
        
        # Executar agente
        run = client.beta.threads.runs.create(
            thread_id=thread.id,
            assistant_id=AGENT_ID
        )
        
        # Aguardar conclusão
        while run.status in ["queued", "in_progress"]:
            run = client.beta.threads.runs.retrieve(
                thread_id=thread.id,
                run_id=run.id
            )
        
        # Obter resposta
        messages = client.beta.threads.messages.list(thread_id=thread.id)
        assistant_message = messages.data[^0].content[^0].text.value
        
        # Tentar extrair plano JSON
        plan = None
        if "```
            json_block = assistant_message.split("```json").split("```
            plan = json.loads(json_block)
        
        return {
            "success": True,
            "response": assistant_message,
            "plan": plan
        }
    
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }

def execute_plan(plan: dict) -> list:
    """Executa plano de ações localmente"""
    results = []
    
    for action in plan.get("actions", []):
        action_type = action.get("type")
        
        if action_type == "create_file":
            path = PROJECT_ROOT / action["path"]
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(action["content"])
            results.append(f"✅ Arquivo criado: {action['path']}")
        
        elif action_type == "run_shell":
            cmd = action["cmd"]
            result = subprocess.run(
                cmd,
                shell=True,
                cwd=PROJECT_ROOT,
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                results.append(f"✅ Comando executado: {cmd}")
            else:
                results.append(f"❌ Erro no comando: {result.stderr}")
        
        elif action_type == "run_gemflow":
            plan_path = PROJECT_ROOT / action["plan"]
            result = subprocess.run(
                ["./30_scripts/gemflow", "execute", str(plan_path)],
                cwd=PROJECT_ROOT,
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                results.append(f"✅ Plano gemflow executado: {action['plan']}")
            else:
                results.append(f"❌ Erro no gemflow: {result.stderr}")
    
    return results

def main():
    if len(sys.argv) < 2:
        print("Uso: agent_gateway.py 'seu prompt aqui'")
        sys.exit(1)
    
    user_prompt = " ".join(sys.argv[1:])
    
    # Chamar agente
    response = call_agent(user_prompt)
    
    if not response["success"]:
        print(f"❌ Erro: {response['error']}")
        sys.exit(1)
    
    # Exibir resposta
    print("🤖 AgentBuilder:")
    print(response["response"])
    print()
    
    # Se houver plano, solicitar confirmação
    if response["plan"]:
        print("📋 Plano de Ação Detectado:")
        print(json.dumps(response["plan"], indent=2))
        print()
        
        confirm = input("Executar este plano? [s/N]: ").strip().lower()
        if confirm == 's':
            results = execute_plan(response["plan"])
            print()
            print("📊 Resultados da Execução:")
            for result in results:
                print(result)
        else:
            print("❌ Execução cancelada pelo usuário")

if __name__ == "__main__":
    main()
GATEWAY_EOF

# Dar permissão de execução
chmod +x ~/Projetos/perplexity/30_scripts/agent_gateway.py
```


### **B. Script Command do Raycast**

```
cat > ~/Projetos/perplexity/30_scripts/chat-com-agentbuilder.sh << 'RAYCAST_EOF'
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chat com AgentBuilder
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Sua ideia ou pergunta" }
# @raycast.packageName GEM Expert AgentBuild

# Documentation:
# @raycast.description Converse com o AgentBuilder Expert usando linguagem natural
# @raycast.author Luiz Sena
# @raycast.authorURL https://github.com/seu-usuario

# Variáveis
PROJECT_DIR="$HOME/Projetos/perplexity"
GATEWAY="$PROJECT_DIR/30_scripts/agent_gateway.py"

# Validações
if [ ! -f "$GATEWAY" ]; then
    echo "❌ Erro: agent_gateway.py não encontrado"
    echo "Caminho esperado: $GATEWAY"
    exit 1
fi

# Executar gateway
cd "$PROJECT_DIR" || exit 1
python3 "$GATEWAY" "$1"
RAYCAST_EOF

# Dar permissão de execução
chmod +x ~/Projetos/perplexity/30_scripts/chat-com-agentbuilder.sh
```


### **C. Configurar Raycast**

```
# 1. Abrir Raycast Settings
open "raycast://extensions/script-commands"

# 2. Adicionar Script Directory
# Settings → Extensions → Script Commands → Add Script Directory
# Selecionar: ~/Projetos/perplexity/30_scripts/

# 3. Verificar comando disponível
# Raycast → Digitar "Chat com AgentBuilder"
```


---

## 🚀 6. Fluxo de Uso Completo

### **Passo 1: Preparar Base de Conhecimento**

```
cd ~/Projetos/perplexity

# Validar todos os JSONs
for file in 10_knowledge_base/40_tools/*.json 10_knowledge_base/50_corpus/metadata.json; do
    echo "Validando $file..."
    jq empty "$file" && echo "✅ Válido" || echo "❌ Erro"
done

# Executar plano de validação (se necessário)
./30_scripts/gemflow execute 30_scripts/plans/kb_agentbuilder_fix_v3.json

# Gerar pacote de publicação
./30_scripts/gemflow execute 30_scripts/plans/publish_to_perplexity_v105.json

# Verificar pacote gerado
ls -lh 90_output/dist/*.zip
```


### **Passo 2: Upload para Perplexity**

```
1. Acessar: https://www.perplexity.ai/spaces
2. Criar novo Space: "GEM Expert AgentBuild"
3. Upload dos arquivos de 10_knowledge_base/
4. Configurar instruções do Space (copiar de 30_prompts_library.md)
5. Testar com queries de 70_eval_set.jsonl
```


### **Passo 3: Criar Agente no OpenAI**

```
1. Acessar: https://platform.openai.com/assistants
2. Criar novo Assistant
3. Configurar:
   - Name: "GEM Expert AgentBuild"
   - Model: gpt-4o
   - Instructions: [copiar System Prompt de 30_prompts_library.md]
   - Tools: 
     * Code Interpreter (habilitado)
     * File Search (habilitado - apontar para arquivos do Perplexity)
4. Copiar Agent ID (asst_...) e adicionar ao .env
```


### **Passo 4: Uso via Raycast**

```
# Abrir Raycast (⌘ + Space)
# Digitar: "Chat com AgentBuilder"
# Inserir prompt: "Crie um workflow de triagem de tickets"

# O agente irá:
# 1. Consultar a KB no Perplexity (RAG)
# 2. Gerar resposta técnica + plano JSON
# 3. Solicitar sua confirmação
# 4. Executar ações localmente (criar arquivos, rodar gemflow)
```


---

## 📊 7. Validação e Testes

### **A. Teste Unitário do Gateway**

```
# Teste simples (sem confirmação de plano)
python3 ~/Projetos/perplexity/30_scripts/agent_gateway.py \
  "Explique a diferença entre Agent e Workflow em 2 parágrafos"

# Teste com geração de arquivo
python3 ~/Projetos/perplexity/30_scripts/agent_gateway.py \
  "Crie um arquivo test.md no meu projeto com um exemplo de workflow JSON"
```


### **B. Teste via Raycast**

```
1. Raycast → "Chat com AgentBuilder"
2. Prompt: "Liste os 5 guardrails essenciais para segurança de agentes"
3. Verificar:
   - ✅ Resposta cita docs/security_guardrails.md
   - ✅ Menciona PII, prompt injection, whitelist
   - ✅ Usa terminologia do glossário
```


### **C. Executar Eval Set**

```
# Script para testar todos os casos
cat > ~/Projetos/perplexity/30_scripts/run_eval_set.sh << 'EVAL_EOF'
#!/bin/bash

EVAL_FILE="10_knowledge_base/70_eval_set.jsonl"
RESULTS_FILE="90_output/eval_results_$(date +%Y%m%d_%H%M%S).jsonl"

while IFS= read -r line; do
    question=$(echo "$line" | jq -r '.question')
    echo "Testando: $question"
    
    response=$(python3 30_scripts/agent_gateway.py "$question" 2>&1)
    
    echo "$line" | jq -c ". + {response: \"$response\"}" >> "$RESULTS_FILE"
done < "$EVAL_FILE"

echo "✅ Resultados salvos em: $RESULTS_FILE"
EVAL_EOF

chmod +x ~/Projetos/perplexity/30_scripts/run_eval_set.sh
./30_scripts/run_eval_set.sh
```


---

## 🎯 8. Exemplos de Uso Práticos

### **Exemplo 1: Gerar Workflow Completo**

**Prompt Raycast:**

```
"Crie um workflow de onboarding de cliente que inclua:
1. Validação de dados
2. Criação de conta via customers_api
3. Envio de email de boas-vindas
4. Log de auditoria

Gere o arquivo workflow.json e o README.md correspondente."
```

**Resposta Esperada do Agente:**

```
{
  "response": "Criei um workflow de onboarding com 4 etapas...",
  "plan": {
    "actions": [
      {
        "type": "create_file",
        "path": "workflows/customer_onboarding.json",
        "content": "{\n  \"name\": \"customer_onboarding\",\n  \"steps\": [...]\n}"
      },
      {
        "type": "create_file",
        "path": "workflows/README.md",
        "content": "# Customer Onboarding Workflow\n\n..."
      }
    ]
  }
}
```


### **Exemplo 2: Validar Configuração RAG**

**Prompt Raycast:**

```
"Analise minha configuração RAG atual e sugira otimizações para documentação técnica de 50MB"
```

**Resposta Esperada:**

```
Sua configuração atual (chunk 800, overlap 150, threshold 0.75) 
está adequada para documentação técnica.[^1][^2]

Para 50MB (~25M tokens), recomendo:
- Custo de embedding: ~$3.25 (one-time)[^3]
- Storage vector DB: ~125MB
- Top_k aumentar para 10 (maior corpus)[^1]
- Considerar cache agressivo para queries frequentes[^4]

Fontes:
 docs/rag_practices.md[^2]
 50_corpus/metadata.json[^1]
 docs/observability_costs.md[^3]
 30_prompts_library.md[^4]
```


### **Exemplo 3: Debugging de Ferramenta**

**Prompt Raycast:**

```
"A chamada para customers_api está falhando com timeout. 
Gere um plano de debugging e execute o checklist de falhas."
```

**Resposta Esperada:**

```
Detectei timeout na customers_api. Checklist de debugging :[^2]

1. ✅ Verificar timeouts configurados: connect 2s, read 5s[^1]
2. 🔍 Validar conectividade de rede
3. 🔍 Verificar status do endpoint (429/503?)
4. 🔍 Revisar logs de circuit breaker

Executar plano de correção?

[Plan JSON]:
{
  "actions": [
    {
      "type": "run_shell",
      "cmd": "curl -w '@curl-format.txt' -o /dev/null -s https://api.example.com/customers/test"
    },
    {
      "type": "run_gemflow",
      "plan": "30_scripts/plans/debug_api_timeout.json"
    }
  ]
}
```


---

## 📈 9. Monitoramento e Governança

### **A. Métricas de Qualidade do Agente**

```
# Dashboard de métricas (manual)
cat > ~/Projetos/perplexity/30_scripts/agent_metrics.sh << 'METRICS_EOF'
#!/bin/bash

LOGS_DIR="90_output/execution_logs"
EVAL_RESULTS="90_output/eval_results_*.jsonl"

echo "📊 Métricas do Agente GEM Expert"
echo "=================================="
echo

# Taxa de sucesso
total=$(cat $EVAL_RESULTS | wc -l)
passed=$(cat $EVAL_RESULTS | jq -r 'select(.response != null) | .id' | wc -l)
echo "Taxa de Sucesso: $((passed * 100 / total))% ($passed/$total)"

# Citação de fontes
cited=$(cat $EVAL_RESULTS | jq -r 'select(.response | contains("

# Latência média (últimas 10 execuções)
echo
echo "Latência p95 (últimas 10): [pendente instrumentação]"
METRICS_EOF

chmod +x ~/Projetos/perplexity/30_scripts/agent_metrics.sh
```


### **B. Auditoria e Compliance**

```
# Verificar conformidade com SLAs
jq '.slas' 10_knowledge_base/99_changelog_governance.md

# SLAs esperados:
# - Disponibilidade: 99.9%
# - Latência p95 (orquestração): <500ms
# - Latência p95 (com tools): <2000ms
# - Taxa de Erro: <1%
# - Precisão: >90%
```


---

## 🔄 10. Manutenção e Atualização

### **Rotina de Atualização da KB**

```
# Mensal (ou quando houver mudanças)
cd ~/Projetos/perplexity

# 1. Atualizar documentos
# (editar arquivos em 10_knowledge_base/50_corpus/docs/)

# 2. Atualizar versão
# (incrementar em 99_changelog_governance.md)

# 3. Validar mudanças
./30_scripts/gemflow execute 30_scripts/plans/kb_agentbuilder_fix_v3.json

# 4. Re-gerar pacote
./30_scripts/gemflow execute 30_scripts/plans/publish_to_perplexity_v105.json

# 5. Upload para Perplexity
# (substituir arquivos no Space)

# 6. Executar eval set
./30_scripts/run_eval_set.sh

# 7. Comparar métricas
./30_scripts/agent_metrics.sh
```


---

## 🎓 11. Troubleshooting

### **Problema: Gateway não encontra chave API**

```
# Verificar .env
cat ~/Projetos/perplexity/.env

# Verificar variável carregada
python3 -c "import os; from pathlib import Path; \
exec(open(Path.home() / 'Projetos/perplexity/.env').read()); \
print(os.environ.get('OPENAI_API_KEY'))"
```


### **Problema: Raycast não exibe comando**

```
# Verificar permissões
ls -l ~/Projetos/perplexity/30_scripts/chat-com-agentbuilder.sh

# Deve mostrar: -rwxr-xr-x (executável)

# Re-adicionar Script Directory no Raycast
# Settings → Extensions → Script Commands → Reload
```


### **Problema: Agente não cita fontes**

```
Verificar:
1. Arquivos foram carregados no Perplexity Space? ✓
2. File Search habilitado no Assistant OpenAI? ✓
3. System Prompt inclui instrução de citação? ✓
   (ver 30_prompts_library.md - seção "Políticas de Resposta")
4. Eval set está testando citações? ✓
   (ver 70_eval_set.jsonl - campo "must_cite")
```


---

## ✅ 12. Checklist de Setup Completo

- [ ] **Dependências instaladas** (jq, python3, git)
- [ ] **Estrutura de diretórios criada**
- [ ] **Credenciais configuradas** (.env ou Keychain)
- [ ] **agent_gateway.py criado e executável**
- [ ] **chat-com-agentbuilder.sh criado e executável**
- [ ] **Raycast configurado** (Script Directory adicionado)
- [ ] **Base de conhecimento validada** (todos os JSONs passam em jq)
- [ ] **KB carregada no Perplexity Space**
- [ ] **Agente criado no OpenAI** (Agent ID copiado)
- [ ] **Teste unitário do gateway passou**
- [ ] **Teste via Raycast bem-sucedido**
- [ ] **Eval set executado** (>80% de taxa de sucesso)
- [ ] **Métricas documentadas** (latência, citações, precisão)

---

## 🚀 Próximos Passos Avançados

### **Fase 2: Automação Completa**

1. **CI/CD para KB:** Setup de pipeline GitHub Actions para validar commits em `10_knowledge_base/`
2. **Dashboard Grafana:** Instrumentar gateway com Prometheus para métricas em tempo real
3. **Feedback Loop:** Implementar sistema de rating de respostas (👍/👎) que alimenta re-treino
4. **Multi-agente:** Criar agentes especializados (Security Agent, RAG Agent, Cost Agent) com roteamento inteligente

### **Fase 3: Produção Enterprise**

1. **High Availability:** Deploy do gateway em servidor (Fly.io/Railway) com health checks
2. **Secrets Management:** Migrar de .env para Vault/AWS Secrets Manager
3. **Observabilidade Full:** OpenTelemetry + Jaeger para traces distribuídos
4. **Compliance:** Auditoria automática de logs + LGPD compliance checks

---

## 📚 Referências e Recursos

**Documentação Oficial:**

- [OpenAI Assistants API](https://platform.openai.com/docs/assistants)
- [Perplexity Spaces](https://www.perplexity.ai/hub/docs/spaces)
- [Raycast Script Commands](https://github.com/raycast/script-commands)

**Arquivos da Base de Conhecimento:**

- `README_index.md` - Índice completo com links
- `30_prompts_library.md` - Todos os prompts e schemas
- `99_changelog_governance.md` - SLAs e políticas

**Contato:**

- Governança: Ver `99_changelog_governance.md` seção "Contatos e Suporte"
- Issues: [GitHub do projeto]

---

**Status Final:** ✅ **Setup Completo e Operacional**
**Versão:** 1.1.0
**Data:** 2025-10-20
**Última Atualização deste Guia:** 2025-10-20 19:23 BRT

🎉 **Seu "GEM Expert AgentBuild" está pronto para uso com interface gráfica nativa no macOS!**

<div align="center">⁂</div>

[^1]: https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf

[^2]: https://www.perplexity.ai/hub/blog/introducing-internal-knowledge-search-and-spaces

[^3]: https://cloud.google.com/vertex-ai/generative-ai/docs/rag-engine/manage-your-rag-corpus

[^4]: https://www.perplexity.ai/help-center/en/articles/10352971-practical-tips-for-using-perplexity

