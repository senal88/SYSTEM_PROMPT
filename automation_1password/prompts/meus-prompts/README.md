# 🚀 Meus Prompts - Estrutura de Prompts para Agente DevOps Senior

**Data de Criação**: 2025-11-03  
**Versão**: 1.0.0  
**Autor**: Luiz Sena (DevOps Senior)  
**Status**: Produção

---

## 📋 Visão Geral

Esta estrutura contém prompts XML estruturados para uso com **Vibe Prompter**, **N8N**, **Cursor 2.0** e outros sistemas de automação. Os prompts foram desenvolvidos seguindo as melhores práticas de engenharia de prompt das principais empresas de IA (Google, OpenAI, Anthropic).

### Objetivo

Fornecer prompts de alta performance, focados em precisão, segurança e integração com infraestrutura híbrida (macOS Silicon Dev + VPS Ubuntu Prod).

---

## 📁 Estrutura de Diretórios

```
meus-prompts/
├── README.md (este arquivo)
├── v1-seguranca/
│   └── agente-devops-senior-v1-seguranca.xml
├── v2-otimizacao/
│   └── agente-devops-senior-v2-otimizacao.xml
├── v3-completo/
│   └── agente-devops-senior-v3.xml
├── exemplos/
│   ├── exemplo-validacao-xml.xml
│   ├── exemplo-injecao-secrets.xml
│   └── exemplo-monitoramento-docker.xml
└── templates/
    ├── template-prompt-base.xml
    └── template-tarefa.xml
```

---

## 🎯 Variantes de Prompts

### V1 - Variante Segurança (`v1-seguranca/`)

**Prioridade**: Segurança > Performance

- ✅ Foco absoluto em segurança e compliance
- ✅ Auditoria completa de todas as ações
- ✅ Validação tripla de secrets
- ✅ Logs sanitizados (sem PII ou secrets)
- ✅ Confirmações obrigatórias antes de ações críticas

**Ideal para**:
- Operações críticas em produção
- Ambientes com requisitos de compliance rigorosos
- Auditorias e validações de segurança

**Métricas**:
- Latência: < 2s (mesmo com validações extras)
- Token Usage: < 3000 tokens
- Incidentes de Segurança: 0 por mês

---

### V2 - Variante Otimização (`v2-otimizacao/`)

**Prioridade**: Performance > Validações Extensas

- ✅ Execução otimizada e paralela quando seguro
- ✅ Cache estratégico de resultados
- ✅ Respostas concisas (YAML estruturado)
- ✅ Validações essenciais apenas
- ✅ Alta throughput (> 10 tarefas/min)

**Ideal para**:
- Operações rotineiras e automações de alta frequência
- Quando custo de tokens é crítico
- Operações não críticas em desenvolvimento

**Métricas**:
- Latência: < 1s (mais agressivo)
- Token Usage: < 2000 tokens (33% menos que V3)
- Throughput: > 10 tarefas/minuto

---

### V3 - Variante Completa (`v3-completo/`)

**Prioridade**: Balanceamento Perfeito

- ✅ Equilíbrio entre segurança e performance
- ✅ Contexto completo do sistema híbrido
- ✅ Todas as tarefas e ferramentas mapeadas
- ✅ Exemplos práticos (Few-Shot Learning)
- ✅ Guardrails robustos mas não excessivos

**Ideal para**:
- Uso geral e operações do dia a dia
- Quando você precisa do melhor dos dois mundos
- Documentação e referência completa

**Métricas**:
- Latência: < 2s
- Token Usage: < 3000 tokens
- Taxa de Sucesso: > 99%

---

## 🛠️ Como Usar com Vibe Prompter

### Instalação e Configuração

1. **Instalar Vibe Prompter** (VS Code Extension ou VS Code Online)
   ```bash
   # No VS Code, pressione F1 e procure:
   # Extensions: Install Extensions
   # Busque: "Vibe Prompter"
   ```

2. **Abrir Vibe Prompter**
   - `F1` → `Vibe Prompter: New Prompt`
   - Ou usar template: `Vibe Prompter: Open Template`

3. **Importar Prompt Existente**
   - `F1` → `Vibe Prompter: Import Prompt`
   - Selecione o arquivo XML desejado:
     - `v3-completo/agente-devops-senior-v3.xml` (recomendado para começar)

---

## 📝 Uso Prático

### 1. Validar um Prompt XML

```bash
# No terminal (macOS ou VPS):
xmllint --noout prompts/meus-prompts/v3-completo/agente-devops-senior-v3.xml

# Se retornar sem erros, o XML está válido!
```

### 2. Usar no N8N

1. **Importar Prompt como Contexto**
   ```javascript
   // No N8N, criar um nó "Code" ou "Function"
   const fs = require('fs');
   const promptXML = fs.readFileSync(
     '/home/luiz.sena88/automation_1password/prompts/meus-prompts/v3-completo/agente-devops-senior-v3.xml',
     'utf8'
   );
   
   // Passar para o LLM como system prompt
   return {
     systemPrompt: promptXML,
     userQuery: $input.item.json.query
   };
   ```

2. **Usar Variante Baseada em Contexto**
   ```javascript
   // Escolher variante baseada em tipo de operação
   const promptVariant = operationType === 'critical' 
     ? 'v1-seguranca/agente-devops-senior-v1-seguranca.xml'
     : operationType === 'routine'
     ? 'v2-otimizacao/agente-devops-senior-v2-otimizacao.xml'
     : 'v3-completo/agente-devops-senior-v3.xml';
   ```

### 3. Usar no Cursor 2.0

1. **Adicionar ao Context**
   - `Cmd+Shift+P` → `Cursor: Add Context`
   - Selecione: `prompts/meus-prompts/v3-completo/agente-devops-senior-v3.xml`

2. **Usar em Comandos**
   ```
   "Colete status de todos os Docker containers usando o prompt V3"
   "Execute validação de segurança usando a variante V1"
   "Otimize a coleta de logs usando a variante V2"
   ```

---

## 🔄 Sincronização com GitHub

### Script de Sincronização Automática

```bash
#!/bin/bash
# scripts/sync-prompts-from-github.sh

COMMIT_ID="$1"
REPO_URL="https://github.com/senal88/ls-edia-config.git"
PROMPTS_DIR="/home/luiz.sena88/automation_1password/prompts/meus-prompts"
CACHE_DIR="/home/luiz.sena88/prompts-cache"

# Clonar repositório temporariamente
TEMP_DIR=$(mktemp -d)
git clone "$REPO_URL" "$TEMP_DIR"

# Copiar prompts atualizados
cp -r "$TEMP_DIR/automation_1password/prompts/meus-prompts"/* "$PROMPTS_DIR/"

# Atualizar cache do N8N
cp -r "$PROMPTS_DIR" "$CACHE_DIR/"

# Limpar
rm -rf "$TEMP_DIR"

echo "✅ Prompts sincronizados com sucesso (Commit: $COMMIT_ID)"
```

### Webhook do GitHub

Configure no GitHub:
- **URL**: `https://senamfo.com.br/api/n8n-webhook/sync-prompts`
- **Eventos**: `push` (apenas na branch `main`)
- **Secret**: Armazenado em `1p_vps` como `GITHUB_WEBHOOK_SECRET`

---

## 📊 Comparação de Variantes

| Característica | V1 Segurança | V2 Otimização | V3 Completo |
|---------------|--------------|--------------|-------------|
| **Latência Alvo** | < 2s | < 1s | < 2s |
| **Token Usage** | < 3000 | < 2000 | < 3000 |
| **Validações** | Tripla | Essenciais | Completa |
| **Confirmações** | Sempre | Mínimas | Quando necessário |
| **Auditoria** | Completa | Básica | Completa |
| **Cache** | Conservador | Agressivo | Balanceado |
| **Uso Ideal** | Crítico/Prod | Rotina/Dev | Geral |

---

## 🔒 Segurança e Guardrails

### Todos os Prompts Incluem:

✅ **Nunca Expor Secrets**
- NUNCA logar valores de API keys, tokens, ou senhas
- Sempre referenciar apenas nomes de variáveis
- Sanitizar logs automaticamente

✅ **Validação de Comandos**
- Verificar sintaxe antes de executar
- Confirmar ambiente (Dev vs Prod)
- Validar permissões necessárias

✅ **Prevenção de Prompt Injection**
- Detectar tentativas de injeção
- Recusar comandos maliciosos
- Reportar incidentes

✅ **Auditoria**
- Registrar todas as ações
- Incluir timestamp e usuário
- Manter logs sanitizados

---

## 🧪 Testes e Validação

### Validação de XML

```bash
# Validar todos os prompts
for file in prompts/meus-prompts/**/*.xml; do
  echo "Validando: $file"
  xmllint --noout "$file" || echo "❌ Erro em $file"
done
```

### Teste com Exemplo Real

```bash
# Usar exemplo de validação
curl -X POST http://localhost:5678/webhook/test-prompt \
  -H "Content-Type: application/xml" \
  -d @prompts/meus-prompts/exemplos/exemplo-validacao-xml.xml
```

---

## 📚 Recursos Adicionais

### Documentação Relacionada

- `~/Dotfiles/automation_1password/prompts/cursor_system_collection_complete.md` - Contexto completo do sistema
- `~/Dotfiles/automation_1password/docs/prompts/` - Outros prompts e guias

### Scripts Úteis

- `scripts/secrets/inject_secrets_macos.sh` - Injeção de secrets (macOS)
- `scripts/secrets/inject_secrets_vps.sh` - Injeção de secrets (VPS)
- `scripts/sync-prompts-from-github.sh` - Sincronização automática

---

## 🔄 Versionamento

### SemVer (Semantic Versioning)

- **Major** (X.0.0): Mudanças incompatíveis na estrutura XML
- **Minor** (0.X.0): Novas funcionalidades compatíveis
- **Patch** (0.0.X): Correções e melhorias

### Histórico

- **v3.0.0** (2025-11-03): Versão completa inicial
- **v2.0.0** (2025-11-03): Variante de otimização
- **v1.0.0** (2025-11-03): Variante de segurança

---

## 🤝 Contribuindo

Ao modificar prompts:

1. **Validar XML**: `xmllint --noout arquivo.xml`
2. **Testar com exemplo real**: Executar tarefa de teste
3. **Atualizar versão**: Incrementar SemVer apropriadamente
4. **Documentar mudanças**: Adicionar no CHANGELOG.md
5. **Commit e Push**: GitHub vai sincronizar automaticamente via webhook

---

## ❓ FAQ

### Qual variante devo usar?

- **V1**: Operações críticas, produção, compliance
- **V2**: Operações rotineiras, alta frequência, desenvolvimento
- **V3**: Uso geral, documentação, referência completa

### Como sincronizar prompts entre Dev e Prod?

Use o script `sync-prompts-from-github.sh` configurado com webhook do GitHub.

### Posso criar minha própria variante?

Sim! Use `templates/template-prompt-base.xml` como base e siga a estrutura XML.

### Os prompts são compatíveis com outros LLMs?

Sim, a estrutura XML é genérica e funciona com qualquer LLM que aceite system prompts estruturados (GPT-4, Claude, Gemini, etc.).

---

**Última Atualização**: 2025-11-03  
**Mantenedor**: Luiz Sena (luiz.sena88@icloud.com)


