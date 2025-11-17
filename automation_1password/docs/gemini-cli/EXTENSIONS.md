# Extensões MCP para Gemini CLI - Guia Completo

Este documento detalha as extensões MCP (Model Context Protocol) recomendadas para o ambiente macOS Silicon + VPS Ubuntu com integração Hugging Face, GitHub, Codespaces, LLMs e Stacks Docker.

## 📋 Visão Geral

O Gemini CLI suporta extensões via MCP servers que expandem significativamente as capacidades do CLI. Este guia categoriza e recomenda extensões baseadas no seu contexto específico.

**Fonte oficial:** [geminicli.com/extensions/](https://geminicli.com/extensions/)

## 🎯 Categorização de Extensões

### Extensões Essenciais (Prioridade Máxima)

Essas extensões são **fundamentais** para o seu ambiente e devem ser instaladas primeiro.

#### 1. GitHub MCP Server
- **URL:** `https://github.com/github/github-mcp-server`
- **Tipo:** MCP
- **Downloads:** 24,220+
- **Por que é essencial:**
  - Integração oficial com GitHub
  - Suporte completo para repositórios, issues, PRs
  - Gerenciamento de Codespaces
  - Automação de workflows Git

**Instalação:**
```bash
gemini extensions install https://github.com/github/github-mcp-server
```

**Configuração:**
```bash
# Token do GitHub via 1Password
export GITHUB_TOKEN=$(op read "op://shared_infra/github/cli_token")
```

#### 2. Chrome DevTools MCP
- **URL:** `https://github.com/ChromeDevTools/chrome-devtools-mcp`
- **Tipo:** MCP
- **Downloads:** 13,822+
- **Por que é essencial:**
  - Ferramentas de desenvolvimento para coding agents
  - Debugging e profiling
  - Análise de performance
  - Útil para desenvolvimento com Cursor IDE

**Instalação:**
```bash
gemini extensions install https://github.com/ChromeDevTools/chrome-devtools-mcp
```

#### 3. MCP Toolbox for Databases
- **URL:** `https://github.com/googleapis/genai-toolbox`
- **Tipo:** Context
- **Downloads:** 11,279+
- **Por que é essencial:**
  - Suporte para 30+ bancos de dados
  - Postgres (parte do seu stack)
  - MongoDB (parte do seu stack)
  - Redis, ChromaDB, e outros

**Instalação:**
```bash
gemini extensions install https://github.com/googleapis/genai-toolbox
```

### Extensões Altamente Recomendadas

Essas extensões têm **alta aderência** ao seu contexto e são fortemente recomendadas.

#### 4. Terraform MCP Server
- **URL:** `https://github.com/hashicorp/terraform-mcp-server`
- **Tipo:** MCP + Context
- **Downloads:** 1,035+
- **Por que é recomendado:**
  - Infrastructure as Code (IaC)
  - Gerenciamento de VPS Ubuntu
  - Automação de stacks Docker
  - Deploy e configuração de infraestrutura

**Instalação:**
```bash
gemini extensions install https://github.com/hashicorp/terraform-mcp-server
```

#### 5. Grafana MCP
- **URL:** `https://github.com/grafana/mcp-grafana`
- **Tipo:** MCP
- **Downloads:** 1,791+
- **Por que é recomendado:**
  - Monitoramento de stacks Docker
  - Observabilidade de containers
  - Métricas e dashboards
  - Integração com Traefik, Portainer, etc.

**Instalação:**
```bash
gemini extensions install https://github.com/grafana/mcp-grafana
```

#### 6. MongoDB MCP
- **URL:** `https://github.com/mongodb-partners/mdb-gemini-cli-ext`
- **Tipo:** MCP
- **Downloads:** 790+
- **Por que é recomendado:**
  - Integração nativa com MongoDB
  - Parte do seu stack atual
  - Gerenciamento de coleções e queries
  - Otimização de performance

**Instalação:**
```bash
gemini extensions install https://github.com/mongodb-partners/mdb-gemini-cli-ext
```

#### 7. Neo4j MCP
- **URL:** `https://github.com/neo4j-contrib/mcp-neo4j`
- **Tipo:** MCP
- **Downloads:** 790+
- **Por que é recomendado:**
  - Suporte a grafos (se necessário)
  - Análise de relacionamentos
  - Queries complexas em grafos

**Instalação:**
```bash
gemini extensions install https://github.com/neo4j-contrib/mcp-neo4j
```

#### 8. Context7
- **URL:** `https://github.com/upstash/context7`
- **Tipo:** MCP
- **Downloads:** 36,095+
- **Por que é recomendado:**
  - Documentação de código atualizada
  - Contexto atualizado para prompts
  - Melhora qualidade das respostas do Gemini

**Instalação:**
```bash
gemini extensions install https://github.com/upstash/context7
```

### Extensões Úteis (Opcionais)

Essas extensões podem ser úteis dependendo de necessidades específicas.

#### 9. Cloud Run MCP
- **URL:** `https://github.com/GoogleCloudPlatform/cloud-run-mcp`
- **Tipo:** MCP + Context
- **Downloads:** 447+
- **Quando usar:**
  - Deploy de aplicações no Google Cloud Run
  - Integração com Google Cloud Platform

#### 10. Google Apps Script (clasp)
- **URL:** `https://github.com/google/clasp`
- **Tipo:** MCP
- **Downloads:** 5,267+
- **Quando usar:**
  - Automação com Google Workspace
  - Scripts do Google Sheets/Docs

#### 11. Stripe MCP
- **URL:** `https://github.com/stripe/ai`
- **Tipo:** MCP
- **Downloads:** 997+
- **Quando usar:**
  - Integração com pagamentos
  - Automação de transações

## ⚠️ Limites de Uso Recomendados

### Limites de Performance

- **Recomendado:** Máximo de **8 servidores MCP simultâneos**
- **Máximo absoluto:** **12 servidores MCP simultâneos**
- **Ideal:** **5-6 servidores** para melhor performance

### Por que há limites?

1. **Recursos do Sistema:**
   - Cada servidor MCP consome memória e CPU
   - Múltiplos servidores podem degradar performance
   - macOS Silicon e VPS têm recursos limitados

2. **Latência:**
   - Mais servidores = mais tempo de resposta
   - Comunicação entre servidores adiciona overhead
   - Pode causar timeouts (429 errors)

3. **Gerenciamento:**
   - Mais servidores = mais complexidade
   - Dificulta debugging e troubleshooting
   - Aumenta chance de conflitos

### Estratégia de Instalação

1. **Instale primeiro as essenciais** (3 extensões)
2. **Adicione as altamente recomendadas** conforme necessidade
3. **Monitore performance** e ajuste conforme necessário
4. **Desabilite extensões não utilizadas** regularmente

## 📊 Matriz de Decisão

| Extensão | Prioridade | Downloads | Uso no Ambiente |
|----------|------------|-----------|------------------|
| GitHub | 🔴 Crítica | 24,220+ | ✅ Repositórios, Codespaces |
| Chrome DevTools | 🔴 Crítica | 13,822+ | ✅ Desenvolvimento, Cursor IDE |
| Database Toolbox | 🔴 Crítica | 11,279+ | ✅ Postgres, MongoDB, Redis |
| Context7 | 🟡 Alta | 36,095+ | ✅ Documentação de código |
| Terraform | 🟡 Alta | 1,035+ | ✅ VPS, IaC, Docker |
| Grafana | 🟡 Alta | 1,791+ | ✅ Monitoramento, Stacks |
| MongoDB | 🟡 Alta | 790+ | ✅ Stack atual |
| Neo4j | 🟢 Média | 790+ | ⚠️ Se usar grafos |
| Cloud Run | 🟢 Baixa | 447+ | ⚠️ Se usar GCP |
| Stripe | 🟢 Baixa | 997+ | ⚠️ Se usar pagamentos |

## 🚀 Instalação Automatizada

Use o script de instalação inteligente:

```bash
cd scripts/gemini-cli
chmod +x install-mcp-extensions.sh

# Instalar apenas essenciais (recomendado)
./install-mcp-extensions.sh --essential

# Instalar todas as recomendadas
./install-mcp-extensions.sh --all

# Instalação personalizada interativa
./install-mcp-extensions.sh --custom
```

## 🔐 Configuração de Autenticação

### GitHub

```bash
# Via 1Password
export GITHUB_TOKEN=$(op read "op://shared_infra/github/cli_token")

# Verificar
echo $GITHUB_TOKEN
```

### MongoDB

```bash
# Configurar conexão MongoDB
export MONGODB_URI=$(op read "op://macos_silicon_workspace/mongodb/connection_string")
```

### Database Toolbox

Configure as conexões de banco de dados conforme necessário:

```bash
# Postgres
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_USER=$(op read "op://macos_silicon_workspace/postgres/username")
export POSTGRES_PASSWORD=$(op read "op://macos_silicon_workspace/postgres/password")
```

## 📝 Verificação e Gerenciamento

### Listar Extensões Instaladas

```bash
gemini extensions list
```

### Verificar Status

```bash
# Contar servidores MCP ativos
gemini extensions list | grep -c "MCP\|Context"

# Ver detalhes de uma extensão
gemini extensions show <nome-da-extensao>
```

### Desabilitar/Remover Extensões

```bash
# Remover extensão
gemini extensions remove <nome-da-extensao>

# Ou desabilitar temporariamente
# Edite ~/.config/gemini-cli/config.json
```

## 🐛 Troubleshooting

### Erro: "429 Too Many Requests"

**Causa:** Muitos servidores MCP ativos simultaneamente

**Solução:**
1. Reduza o número de servidores ativos
2. Desabilite extensões não utilizadas
3. Aumente o intervalo entre requisições

### Erro: "Extension not found"

**Causa:** URL da extensão incorreta ou repositório movido

**Solução:**
1. Verifique a URL no [catálogo oficial](https://geminicli.com/extensions/)
2. Confirme que o repositório ainda existe
3. Tente reinstalar com a URL atualizada

### Performance Degradada

**Causa:** Muitas extensões consumindo recursos

**Solução:**
1. Liste extensões instaladas: `gemini extensions list`
2. Identifique extensões não utilizadas
3. Remova ou desabilite extensões desnecessárias
4. Mantenha apenas 5-8 servidores ativos

## 📚 Referências

- [Catálogo Oficial de Extensões](https://geminicli.com/extensions/)
- [Documentação MCP](https://modelcontextprotocol.io/)
- [GitHub do Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [Guia de Extensões](https://github.com/google-gemini/gemini-cli/blob/main/docs/extensions.md)

## 🔄 Atualizações

Para atualizar extensões:

```bash
# Atualizar todas as extensões
gemini extensions update --all

# Atualizar extensão específica
gemini extensions update <nome-da-extensao>
```

---

**Última atualização:** 2025-11-03  
**Versão:** 1.0.0

