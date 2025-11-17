# Agent Skills - Guia Completo para Claude

## 📋 Visão Geral

**Agent Skills** são capacidades modulares que estendem a funcionalidade do Claude. Cada Skill empacota instruções, metadados e recursos opcionais (scripts, templates) que o Claude usa automaticamente quando relevante.

---

## 🎯 Por Que Usar Skills

Skills são recursos reutilizáveis baseados em filesystem que fornecem ao Claude expertise específica de domínio: workflows, contexto e melhores práticas que transformam agentes de propósito geral em especialistas.

### Benefícios Principais

* **Especializar Claude**: Adaptar capacidades para tarefas específicas de domínio
* **Reduzir repetição**: Criar uma vez, usar automaticamente
* **Compor capacidades**: Combinar Skills para construir workflows complexos

**Diferenciação**: Ao contrário de prompts (instruções de nível de conversa para tarefas únicas), Skills são carregados sob demanda e eliminam a necessidade de fornecer repetidamente a mesma orientação em múltiplas conversas.

---

## 🔧 Como Skills Funcionam

### Arquitetura Baseada em Filesystem

Skills aproveitam o ambiente VM do Claude para fornecer capacidades além do que é possível apenas com prompts. O Claude opera em uma máquina virtual com acesso a filesystem, permitindo que Skills existam como diretórios contendo instruções, código executável e materiais de referência.

### Progressive Disclosure (Divulgação Progressiva)

A arquitetura baseada em filesystem permite **divulgação progressiva**: Claude carrega informações em estágios conforme necessário, em vez de consumir contexto antecipadamente.

### Três Tipos de Conteúdo, Três Níveis de Carregamento

Skills podem conter três tipos de conteúdo, cada um carregado em momentos diferentes:

#### Level 1: Metadata (sempre carregado)

**Tipo de conteúdo**: Instruções. O frontmatter YAML do Skill fornece informações de descoberta:

```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---
```

**Carregamento**: O Claude carrega este metadata na inicialização e o inclui no system prompt. Esta abordagem leve significa que você pode instalar muitos Skills sem penalidade de contexto; o Claude só sabe que cada Skill existe e quando usá-lo.

**Custo de tokens**: ~100 tokens por Skill

#### Level 2: Instructions (carregado quando acionado)

**Tipo de conteúdo**: Instruções. O corpo principal de `SKILL.md` contém conhecimento processual: workflows, melhores práticas e orientações:

```markdown
# PDF Processing

## Quick start

Use pdfplumber to extract text from PDFs:

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For advanced form filling, see [FORMS.md](FORMS.md).
```

**Carregamento**: Quando você solicita algo que corresponde à descrição de um Skill, o Claude lê `SKILL.md` do filesystem via bash. Só então este conteúdo entra na janela de contexto.

**Custo de tokens**: Menos de 5K tokens

#### Level 3: Resources and Code (carregado conforme necessário)

**Tipos de conteúdo**: Instruções, código e recursos. Skills podem empacotar materiais adicionais:

```
pdf-skill/
├── SKILL.md (instruções principais)
├── FORMS.md (guia de preenchimento de formulários)
├── REFERENCE.md (referência detalhada de API)
└── scripts/
    └── fill_form.py (script utilitário)
```

**Conteúdo**:
- **Instruções**: Arquivos markdown adicionais (FORMS.md, REFERENCE.md) contendo orientações e workflows especializados
- **Código**: Scripts executáveis (fill_form.py, validate.py) que o Claude executa via bash; scripts fornecem operações determinísticas sem consumir contexto
- **Recursos**: Materiais de referência como schemas de banco de dados, documentação de API, templates ou exemplos

**Carregamento**: Claude acessa esses arquivos apenas quando referenciados. O modelo de filesystem significa que cada tipo de conteúdo tem diferentes pontos fortes: instruções para orientação flexível, código para confiabilidade, recursos para consulta factual.

**Custo de tokens**: Efetivamente ilimitado (código executado via bash não consome tokens)

### Tabela de Carregamento

| Nível | Quando Carregado | Custo de Tokens | Conteúdo |
|-------|------------------|-----------------|----------|
| **Level 1: Metadata** | Sempre (na inicialização) | ~100 tokens por Skill | `name` e `description` do frontmatter YAML |
| **Level 2: Instructions** | Quando Skill é acionado | Menos de 5K tokens | Corpo do SKILL.md com instruções e orientações |
| **Level 3+: Resources** | Conforme necessário | Efetivamente ilimitado | Arquivos empacotados executados via bash sem carregar conteúdo no contexto |

A divulgação progressiva garante que apenas conteúdo relevante ocupe a janela de contexto a qualquer momento.

---

## 🏗️ Arquitetura de Skills

### Ambiente de Execução

Skills executam em um ambiente de execução de código onde o Claude tem:
- Acesso a filesystem
- Comandos bash
- Capacidades de execução de código

**Analogia**: Skills existem como diretórios em uma máquina virtual, e o Claude interage com eles usando os mesmos comandos bash que você usaria para navegar arquivos no seu computador.

### Como Claude Acessa Conteúdo de Skill

Quando um Skill é acionado:

1. **Claude usa bash**: `bash: read pdf-skill/SKILL.md` → Instruções carregadas no contexto
2. **Claude determina**: Se precisa de arquivos adicionais (ex: FORMS.md não é necessário para extração simples)
3. **Claude executa**: Usa instruções do SKILL.md para completar a tarefa
4. **Se necessário**: Lê arquivos adicionais via bash
5. **Se scripts mencionados**: Executa via bash e recebe apenas a saída (o código do script nunca entra no contexto)

### O Que Esta Arquitetura Permite

**Acesso a arquivos sob demanda**: Claude lê apenas os arquivos necessários para cada tarefa específica. Um Skill pode incluir dezenas de arquivos de referência, mas se sua tarefa só precisa do schema de vendas, o Claude carrega apenas esse arquivo. O restante permanece no filesystem consumindo zero tokens.

**Execução eficiente de scripts**: Quando o Claude executa `validate_form.py`, o código do script nunca carrega na janela de contexto. Apenas a saída do script (como "Validação passou" ou mensagens de erro específicas) consome tokens. Isso torna scripts muito mais eficientes do que ter o Claude gerar código equivalente sob demanda.

**Sem limite prático em conteúdo empacotado**: Como arquivos não consomem contexto até serem acessados, Skills podem incluir documentação abrangente de API, grandes datasets, exemplos extensos ou quaisquer materiais de referência que você precise. Não há penalidade de contexto para conteúdo empacotado que não é usado.

---

## 📍 Onde Skills Funcionam

Skills estão disponíveis em todos os produtos de agentes Claude:

### Claude API

**Suporte**: Pre-built Agent Skills e Custom Skills

**Funcionamento**: Especifique o `skill_id` relevante no parâmetro `container` junto com a ferramenta de execução de código.

**Pré-requisitos**: Requer três headers beta:
- `code-execution-2025-08-25` - Skills executam no container de execução de código
- `skills-2025-10-02` - Habilita funcionalidade de Skills
- `files-api-2025-04-14` - Necessário para upload/download de arquivos para/do container

**Pre-built Skills**: Use referenciando seu `skill_id` (ex: `pptx`, `xlsx`)

**Custom Skills**: Crie e faça upload via Skills API (`/v1/skills` endpoints). Custom Skills são compartilhados em toda a organização.

**Documentação**: [Use Skills with the Claude API](/en/api/skills-guide)

### Claude Code

**Suporte**: Apenas Custom Skills

**Funcionamento**: Crie Skills como diretórios com arquivos `SKILL.md`. O Claude descobre e usa automaticamente.

**Características**: Custom Skills no Claude Code são baseados em filesystem e não requerem uploads de API.

**Documentação**: [Use Skills in Claude Code](/en/docs/claude-code/skills)

### Claude Agent SDK

**Suporte**: Custom Skills através de configuração baseada em filesystem

**Funcionamento**: Crie Skills como diretórios com arquivos `SKILL.md` em `.claude/skills/`. Habilite Skills incluindo `"Skill"` na configuração `allowed_tools`.

**Características**: Skills no Agent SDK são automaticamente descobertos quando o SDK executa.

**Documentação**: [Agent Skills in the SDK](/en/api/agent-sdk/skills)

### Claude.ai

**Suporte**: Pre-built Agent Skills e Custom Skills

**Pre-built Skills**: Funcionam automaticamente nos bastidores quando você cria documentos. Claude os usa sem requerer configuração.

**Custom Skills**: Faça upload como arquivos zip através de Settings > Features. Disponível em planos Pro, Max, Team e Enterprise com execução de código habilitada. Custom Skills são individuais para cada usuário; não são compartilhados em toda a organização e não podem ser gerenciados centralmente por admins.

**Documentação**: Ver recursos no Claude Help Center

---

## 📝 Estrutura de Skill

### Requisito Básico

Todo Skill requer um arquivo `SKILL.md` com frontmatter YAML:

```yaml
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
[Clear, step-by-step guidance for Claude to follow]

## Examples
[Concrete examples of using this Skill]
```

### Campos Obrigatórios

**`name`**:
- Máximo 64 caracteres
- Deve conter apenas letras minúsculas, números e hífens
- Não pode conter tags XML
- Não pode conter palavras reservadas: "anthropic", "claude"

**`description`**:
- Deve ser não vazio
- Máximo 1024 caracteres
- Não pode conter tags XML
- Deve incluir tanto o que o Skill faz quanto quando o Claude deve usá-lo

### Estrutura de Diretório Recomendada

```
your-skill/
├── SKILL.md (obrigatório - instruções principais)
├── EXAMPLES.md (opcional - exemplos adicionais)
├── REFERENCE.md (opcional - referência detalhada)
├── scripts/
│   ├── validate.py (opcional - scripts executáveis)
│   └── process.py (opcional - scripts executáveis)
└── resources/
    ├── schema.json (opcional - recursos de referência)
    └── templates/ (opcional - templates)
```

---

## 🔒 Considerações de Segurança

### Aviso Importante

**Use Skills apenas de fontes confiáveis**: Aqueles que você criou ou obteve da Anthropic. Skills fornecem ao Claude novas capacidades através de instruções e código, e embora isso os torne poderosos, também significa que um Skill malicioso pode direcionar o Claude a invocar ferramentas ou executar código de maneiras que não correspondem ao propósito declarado do Skill.

### Principais Considerações de Segurança

* **Audite completamente**: Revise todos os arquivos empacotados no Skill: SKILL.md, scripts, imagens e outros recursos. Procure padrões incomuns como chamadas de rede inesperadas, padrões de acesso a arquivos ou operações que não correspondem ao propósito declarado do Skill

* **Fontes externas são arriscadas**: Skills que buscam dados de URLs externas apresentam risco particular, pois o conteúdo buscado pode conter instruções maliciosas. Mesmo Skills confiáveis podem ser comprometidos se suas dependências externas mudarem ao longo do tempo

* **Uso indevido de ferramentas**: Skills maliciosos podem invocar ferramentas (operações de arquivo, comandos bash, execução de código) de maneiras prejudiciais

* **Exposição de dados**: Skills com acesso a dados sensíveis podem ser projetados para vazar informações para sistemas externos

* **Trate como instalar software**: Use apenas Skills de fontes confiáveis. Tenha especial cuidado ao integrar Skills em sistemas de produção com acesso a dados sensíveis ou operações críticas

---

## 📦 Skills Disponíveis

### Pre-built Agent Skills

Os seguintes Pre-built Agent Skills estão disponíveis para uso imediato:

* **PowerPoint (pptx)**: Criar apresentações, editar slides, analisar conteúdo de apresentação
* **Excel (xlsx)**: Criar planilhas, analisar dados, gerar relatórios com gráficos
* **Word (docx)**: Criar documentos, editar conteúdo, formatar texto
* **PDF (pdf)**: Gerar documentos PDF formatados e relatórios

**Disponibilidade**: Claude API e claude.ai

**Tutorial**: [Quickstart tutorial](/en/docs/agents-and-tools/agent-skills/quickstart)

### Custom Skills

Para exemplos completos de Custom Skills, consulte o [Skills cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills).

---

## ⚠️ Limitações e Restrições

### Disponibilidade Entre Superfícies

**Custom Skills não sincronizam entre superfícies**. Skills enviados para uma superfície não estão automaticamente disponíveis em outras:

* Skills enviados para Claude.ai devem ser separadamente enviados para a API
* Skills enviados via API não estão disponíveis no Claude.ai
* Skills do Claude Code são baseados em filesystem e separados tanto do Claude.ai quanto da API

Você precisará gerenciar e enviar Skills separadamente para cada superfície onde deseja usá-los.

### Escopo de Compartilhamento

Skills têm diferentes modelos de compartilhamento dependendo de onde você os usa:

* **Claude.ai**: Apenas usuário individual; cada membro da equipe deve enviar separadamente
* **Claude API**: Em toda a workspace; todos os membros da workspace podem acessar Skills enviados
* **Claude Code**: Pessoal (`~/.claude/skills/`) ou baseado em projeto (`.claude/skills/`); também pode ser compartilhado via Claude Code Plugins

Claude.ai atualmente não suporta gerenciamento centralizado de admin ou distribuição organizacional de Custom Skills.

### Restrições de Ambiente de Runtime

O ambiente de runtime exato disponível para seu Skill depende da superfície do produto onde você o usa:

#### Claude.ai
* **Acesso à rede variável**: Dependendo das configurações de usuário/admin, Skills podem ter acesso total, parcial ou nenhum acesso à rede

#### Claude API
* **Sem acesso à rede**: Skills não podem fazer chamadas de API externas ou acessar a internet
* **Sem instalação de pacotes em runtime**: Apenas pacotes pré-instalados estão disponíveis. Você não pode instalar novos pacotes durante a execução
* **Apenas dependências pré-configuradas**: Verifique a [documentação da ferramenta de execução de código](/en/docs/agents-and-tools/tool-use/code-execution-tool) para a lista de pacotes disponíveis

#### Claude Code
* **Acesso total à rede**: Skills têm o mesmo acesso à rede que qualquer outro programa no computador do usuário
* **Instalação global de pacotes desencorajada**: Skills devem instalar pacotes apenas localmente para evitar interferir com o computador do usuário

**Planeje seus Skills para funcionar dentro dessas restrições.**

---

## 🎓 Melhores Práticas de Criação

### Escrevendo Descrições Eficazes

A `description` deve:
1. **Explicar o que o Skill faz**: Seja específico sobre as capacidades
2. **Indicar quando usar**: Inclua palavras-chave que acionam o Skill
3. **Ser concisa**: Máximo 1024 caracteres, mas seja direto

**Exemplo bom**:
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Exemplo ruim**:
```yaml
description: PDF stuff
```

### Estruturando Instruções

1. **Comece com Quick Start**: Seção rápida para tarefas comuns
2. **Organize por casos de uso**: Agrupe instruções relacionadas
3. **Inclua exemplos**: Código e exemplos concretos
4. **Referencie arquivos adicionais**: Use links para recursos adicionais quando apropriado

### Criando Scripts Eficientes

1. **Seja determinístico**: Scripts devem produzir resultados consistentes
2. **Forneça saída útil**: Mensagens de erro claras, saída formatada
3. **Documente dependências**: Liste pacotes necessários
4. **Teste antes de empacotar**: Certifique-se de que scripts funcionam

### Organizando Recursos

1. **Separe por tipo**: Instruções, scripts, recursos em subdiretórios
2. **Nomeie claramente**: Nomes de arquivos descritivos
3. **Documente estrutura**: README ou comentários explicando organização

---

## 📚 Exemplo Completo de Skill

### Estrutura

```
devops-automation/
├── SKILL.md
├── EXAMPLES.md
├── scripts/
│   ├── deploy.sh
│   └── validate.sh
└── resources/
    └── docker-compose.template.yml
```

### SKILL.md

```yaml
---
name: devops-automation
description: Automate DevOps tasks including deployment, validation, and infrastructure management. Use when working with Docker, deployment scripts, or infrastructure automation.
---

# DevOps Automation

## Quick Start

Deploy a service using Docker Compose:

```bash
bash scripts/deploy.sh production
```

## Common Tasks

### Deployment
See [EXAMPLES.md](EXAMPLES.md) for deployment scenarios.

### Validation
Run validation before deployment:
```bash
bash scripts/validate.sh
```

## Resources
- Docker Compose template: [resources/docker-compose.template.yml](resources/docker-compose.template.yml)
```

---

## 🔄 Fluxo de Uso Típico

1. **Claude detecta necessidade**: Baseado na descrição do Skill
2. **Claude carrega SKILL.md**: Via bash `read devops-automation/SKILL.md`
3. **Claude segue instruções**: Executa tarefas conforme SKILL.md
4. **Se necessário**: Carrega arquivos adicionais (EXAMPLES.md, etc.)
5. **Se scripts necessários**: Executa via bash e usa saída
6. **Completa tarefa**: Usando conhecimento do Skill

---

## 📊 Resumo de Decisões

### Quando Criar um Skill

✅ **Crie um Skill quando**:
- Você tem workflows repetitivos
- Precisa de conhecimento específico de domínio
- Quer compartilhar expertise entre conversas
- Precisa executar código determinístico

❌ **Não crie um Skill quando**:
- Tarefa é única e não será repetida
- Prompt simples é suficiente
- Não há código ou recursos complexos

### Quando Usar Pre-built vs Custom

**Use Pre-built**:
- Tarefas comuns (PowerPoint, Excel, Word, PDF)
- Quando pre-built já existe para sua necessidade

**Use Custom**:
- Workflows específicos da organização
- Conhecimento de domínio especializado
- Integrações com sistemas internos
- Processos únicos do seu ambiente

---

## 🔗 Recursos Adicionais

### Documentação Oficial
- [Quickstart Tutorial](/en/docs/agents-and-tools/agent-skills/quickstart)
- [API Guide](/en/api/skills-guide)
- [Best Practices](/en/docs/agents-and-tools/agent-skills/best-practices)

### Exemplos
- [Skills Cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills)

### Suporte
- Claude Help Center: Skills articles
- Community resources

---

**Última atualização:** 2025-11-05
**Versão:** 1.0.0
**Baseado em:** SKILLS.md oficial da Anthropic

