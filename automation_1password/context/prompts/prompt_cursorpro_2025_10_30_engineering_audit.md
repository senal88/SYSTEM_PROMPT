# [translate:Prompt de Auditoria, Estrutura e Automação — Contexto & Governança]

**Path recomendado para salvar:**  
context/prompts/prompt_cursorpro_2025_10_30_engineering_audit.md

---

## Auditoria e Padronização Modular - Engenharia de Contexto

### 1. Coleta de Estado Atual

- Faça varredura recursiva em todos diretórios e arquivos (.md, .sh, .yaml/.yml, .env, .op, configs).
- Gere tabela detalhada: nome do arquivo, path completo, data “Last Updated”, versão, metadata de criação/modificação.

### 2. Diagnóstico e Lacunas

- Relacione todos artefatos (docs/scripts/configs) aos context packs/.cursorrules.
- Identifique lacunas: datas fora do padrão, falta de manifest, docs/sensíveis fora do .gitignore/600.
- Indique arquivos críticos para atualização.

### 3. Estrutura Modular Recomendada

- Proponha hierarquia lógica final:
  - Docs essenciais (max 5 artefatos): governanca.md, plataforma_automacao.md, operacoes_e_runbooks.md, contexto_manifesto.md, llm_interface.md.
  - Packs contextuais segmentados por função (dev/prod, secrets, tokens, scripts, context).
  - Tags/context hints e segregação de ambiente.

### 4. Salvamento de Prompts, Respostas e Logs

- Salve prompts em `context/prompts/` com padrão: prompt_{engine}_{date}_{contexto}.md
- Salve respostas em `context/raw/chats/` (chat_{engine}_{date}_{modulo}.md).
- Relatórios automáticos e manifestos em: exports/export_full_{date}.md, context/indexes/context_manifest_{date}.json, organized/ORGANIZACAO_CONCLUIDA.md

### 5. Automação & Agentes

- Recomende plano sequencial (Makefile ou scripts):
  - make update.headers
  - make backup.full
  - make context.index
  - make validate.all
  - make export.context
- Relacione CLI agents/módulos e explique resultado de cada comando.

### 6. Governança, Backup e Sincronização

- Confirme que dados/sensíveis estão sob .gitignore, permissions 600, cofre OP, prefixos/tags por contexto.
- Programe rotina automática de autenticação e ingestão de env/secrets ao abrir terminal.
- Documente como registrar output, gerar changelog e exportar resumos para ingestão LLM, backup ou restore.

---

**Output desejado:**
- Tabela de datas/versão por arquivo/diretório
- Diagnóstico de lacunas e plano de correções
- Estrutura modular ideal da pasta
- Listagem de agentes/skills e comandos automáticos
- Onde salvar outputs, manifestos, relatórios e como nomear cada arquivo

