# 📝 System Prompts - Infraestrutura Híbrida

**Versão:** 2.0.1
**Última Atualização:** 2025-01-17
**Base:** `~/Dotfiles` (governança centralizada)

---

## 📋 Visão Geral

Este diretório contém system prompts especializados para diferentes modelos de IA, todos focados em **infraestrutura híbrida** (macOS Silicon dev + VPS Ubuntu prod) com **automação padronizada híbrida do 1Password**.

**Localização Original**: `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/prompts/system_prompts/`
**Localização Padronizada**: `~/Dotfiles/prompts/system_prompts/`

---

## 🎯 System Prompts Disponíveis

### 1. Claude

**Arquivo:** `4.0.prompt_claude_infraestrutura.md`

**Foco:**
- Infraestrutura híbrida macOS + VPS
- Automação 1Password padronizada
- Docker, Coolify, Traefik, n8n, Chatwoot
- Scripts de automação e validação

**Uso:** Para conversas com Claude (Claude Desktop, API, etc.)

---

### 2. ChatGPT 5 Codex

**Arquivo:** `4.1.prompt_chatgpt-codex_infraestrutura.md`

**Foco:**
- Integração Codex CLI, IDE, Cloud, SDK
- Infraestrutura híbrida macOS + VPS
- Automação 1Password padronizada
- Deploy com Codex (CLI, Cloud, GitHub Actions)

**Uso:** Para ChatGPT Plus/Pro com Codex habilitado

---

### 3. Gemini

**Arquivo:** `4.2.prompt_gemini_infraestrutura.md`

**Foco:**
- Integração Gemini API, CLI (gcloud), Vertex AI
- Infraestrutura híbrida macOS + VPS
- Automação 1Password padronizada
- Análise de logs e geração de scripts com Gemini

**Uso:** Para Google Gemini (API, CLI, Vertex AI)

---

### 4. Cursor 2.0

**Arquivo:** `4.3.prompt_cursor_infraestrutura.md`

**Foco:**
- Integração Cursor 2.0 (GPT-5, Claude Sonnet 4.5, Gemini 2.5)
- Infraestrutura híbrida macOS + VPS
- Automação 1Password padronizada
- Edição de código e geração de scripts

**Uso:** Para Cursor 2.0 (Editor, Chat, Comandos)

---

### 5. GitHub Copilot

**Arquivo:** `4.4.prompt_github-copilot_infraestrutura.md`

**Foco:**
- Integração GitHub Copilot (CLI, IDE, Chat)
- Infraestrutura híbrida macOS + VPS
- Automação 1Password padronizada
- Geração de código e automação

**Uso:** Para GitHub Copilot (CLI, extensão IDE, Chat)

---

### 6. Versões Antigas (Histórico)

- `1.1.prompt_chatgpt-plus.md` - Versão anterior ChatGPT Plus
- `1.2.prompt_chatgpt-plus.md` - Versão anterior ChatGPT Plus
- `2.0.prompt_chatgpt-codex.md` - Versão anterior Codex
- `3.0.prompt_codespace_devcontainer.md` - Codespace/DevContainer
- `3.1.prompt_codex_setup_completo.md` - Setup completo Codex

---

## 🏗️ Estrutura Comum

Todos os system prompts seguem a mesma estrutura:

1. **Identidade e Contexto**
   - Especialização
   - Ambientes de trabalho (macOS + VPS)
   - Estrutura do projeto

2. **Automação Híbrida 1Password**
   - Princípios fundamentais
   - Segregação por ambiente
   - Nomenclatura padronizada
   - Integração específica do modelo

3. **Infraestrutura VPS**
   - Serviços principais
   - Planos de implantação
   - Docker Compose
   - Deploy com o modelo específico

4. **Padrões de Trabalho**
   - Fluxo de trabalho
   - Scripts de automação
   - Integração com o modelo

5. **Segurança e Boas Práticas**
   - Credenciais
   - Automação
   - Deploy

6. **Estilo de Resposta**
   - Tom e linguagem
   - Estrutura recomendada
   - Código e exemplos

7. **Casos de Uso Específicos**
   - Configurar novo serviço
   - Migrar credenciais
   - Troubleshooting

8. **Limitações e Suposições**
   - Suposições
   - Limitações

9. **Prioridades**
   - Otimizações

---

## 🔐 Ambientes e Cofres 1Password

### macOS (Desenvolvimento)

- **Cofre:** `1p_macos` (ID: `gkpsbgizlks2zknwzqpppnb2ze`)
- **Autenticação:** TouchID (biometria)
- **Localização:** `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS`

### VPS Ubuntu (Produção)

- **Cofre:** `1p_vps` (ID: `oa3tidekmeu26nxiier2qbi7v4`)
- **Autenticação:** Service Account Token
- **IP:** 147.79.81.59
- **Domínio:** senamfo.com.br

### Compartilhado

- **Cofre:** `default` (ID: `syz4hgfg6c62ndrxjmoortzhia`)
- **Uso:** Fallback para credenciais compartilhadas

---

## 🚀 Como Usar

### 1. Selecionar Modelo

Escolha o system prompt apropriado para o modelo de IA que você está usando:

- **Claude** → `4.0.prompt_claude_infraestrutura.md`
- **ChatGPT Codex** → `4.1.prompt_chatgpt-codex_infraestrutura.md`
- **Gemini** → `4.2.prompt_gemini_infraestrutura.md`
- **Cursor 2.0** → `4.3.prompt_cursor_infraestrutura.md`
- **GitHub Copilot** → `4.4.prompt_github-copilot_infraestrutura.md`

### 2. Configurar System Prompt

Copie o conteúdo do arquivo selecionado e configure como system prompt na sua ferramenta de IA.

### 3. Iniciar Conversa

Inicie uma conversa com o modelo configurado e comece a trabalhar com infraestrutura híbrida.

---

## 📚 Documentação Relacionada

### Contexto Global

- `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md` - Contexto completo
- `~/Dotfiles/context/[ia]/CONTEXTO_[IA].md` - Contextos específicos por IA

### Framework de Implantação

- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/planos-implantacao/` - Planos passo a passo
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/curso-n8n/` - Curso estruturado (26 aulas)
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/repos-fazer-ai/` - Repositórios (Chatwoot, n8n)

### Sistema 1Password

- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/vaults-1password/config/vaults-map.yaml` - Mapeamento de cofres
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/vaults-1password/scripts/` - Scripts de automação
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/vaults-1password/standards/` - Padrões de nomenclatura
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/vaults-1password/docs/` - Documentação completa

### Documentação Principal

- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/documentacao/PLANO_IMPLANTACAO_INFRA_VPS.md` - Plano de implantação
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/documentacao/GITHUB_VPS_INTEGRATION.md` - Integração GitHub
- `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/README.md` - README principal do repositório

---

## ✅ Checklist de Uso

- [ ] System prompt selecionado
- [ ] Conteúdo copiado e configurado
- [ ] Modelo de IA configurado
- [ ] 1Password CLI instalado e configurado
- [ ] Acesso SSH à VPS configurado
- [ ] Docker e Docker Compose instalados
- [ ] Coolify configurado e funcionando

---

## 🔄 Atualizações

**Versão 2.0.1** (2025-01-17)
- Migração para `~/Dotfiles` (governança centralizada)
- Integração com sistema de contexto global
- Atualização de referências e paths

**Versão 1.0.0** (2025-11-17)
- Criação inicial dos system prompts
- Estrutura comum definida
- Integração com 1Password padronizada
- Documentação completa

---

**Última atualização:** 2025-01-17
**Versão:** 2.0.1
**Status:** ✅ Ativo e Integrado ao Contexto Global
