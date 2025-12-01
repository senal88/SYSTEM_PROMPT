# Guia de Setup – Claude Code Pro

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

Claude Code Pro é uma das principais IAs assistentes de código neste ecossistema, focada em geração, refatoração e análise de código de alta complexidade. Sua integração é crucial para tarefas que exigem um profundo entendimento do contexto do código.

Este guia detalha como configurar e integrar o Claude Code Pro com as IDEs padrão (Cursor e VS Code) e como garantir que ele utilize os prompts e segredos governados pelo repositório.

---

## 2. Pré-requisitos

1. **Conta Anthropic:** É necessário ter uma conta ativa na plataforma da Anthropic com acesso ao Claude Code Pro.
2. **Chave de API:** Uma chave de API (API Key) válida deve ser gerada no dashboard da Anthropic em [console.anthropic.com](https://console.anthropic.com/).
3. **1Password e CLI:** O 1Password deve ser o cofre de senhas principal, e o 1Password CLI (`op`) deve estar instalado e configurado no ambiente local (macOS).

### 2.1. Instalação do 1Password CLI

Se o 1Password CLI ainda não estiver instalado:

```bash
# Via Homebrew (recomendado)
brew install --cask 1password/tap/1password-cli

# Verificar instalação
op --version

# Fazer login (primeira vez)
op signin
```

**Nota:** O comando `op signin` solicitará suas credenciais do 1Password e estabelecerá uma sessão. Para automações, considere usar `op account add` seguido de `eval $(op signin)` ou integração com biometria via 1Password app.

---

## 3. Armazenamento Seguro da Chave de API

**Nunca armazene a chave de API diretamente em arquivos de configuração ou no código-fonte.** A política deste repositório é utilizar o 1Password como a única fonte da verdade para segredos.

### 3.1. Salvar a Chave no 1Password

1. **Obter a chave da API Anthropic:**
   - Acesse [console.anthropic.com](https://console.anthropic.com/) e faça login.
   - Navegue até **API Keys** e gere uma nova chave.
   - Copie a chave (ela será exibida apenas uma vez).

2. **Criar item no 1Password:**

   ```bash
   # Via CLI (método recomendado)
   op item create \
     --category="API Credential" \
     --title="Anthropic API Key (Claude)" \
     --vault="Development" \
     --tags="api-key,claude,anthropic,ai" \
     credential="sk-ant-..." \
     --generate-password=off

   # Ou via interface gráfica do 1Password:
   # - Tipo: "API Credential" ou "Login"
   # - Nome: "Anthropic API Key (Claude)"
   # - Campo username: anthropic
   # - Campo password/credential: cole a chave sk-ant-...
   # - Tags: api-key, claude, anthropic, ai
   # - Vault: Development (ou seu vault preferido)
   ```

3. **Verificar a chave armazenada:**

   ```bash
   # Listar item para confirmar
   op item list --tags claude

   # Testar leitura da chave (sem exibir no terminal)
   op read "op://Development/Anthropic API Key (Claude)/credential" > /dev/null && \
     echo "✅ Chave acessível via 1Password CLI"
   ```

### 3.2. Configurar Referência Segura

Crie um formato de referência padronizado para uso em scripts e automações:

**Formato de referência:**

```text
op://Development/Anthropic API Key (Claude)/credential
```

**Nomenclatura padronizada:**

- **Vault:** `Development` (ou `Personal` conforme sua organização)
- **Item:** `Anthropic API Key (Claude)`
- **Campo:** `credential` (ou `password` se usando tipo Login)
- **Tags:** `api-key`, `claude`, `anthropic`, `ai`

### 3.3. Script de Validação

O script `scripts/auditar-1password-secrets_v1.0.0_20251130.sh` já está configurado para buscar e validar chaves da Anthropic:

```bash
# Executar auditoria completa
cd ~/Dotfiles/system_prompts/global
./scripts/auditar-1password-secrets_v1.0.0_20251130.sh

# O script irá:
# - Verificar se o 1Password CLI está instalado
# - Buscar items com tags "anthropic" ou "claude"
# - Validar se as chaves estão acessíveis
# - Gerar relatório em audit/<timestamp>/1password/
```

---

## 4. Integração com IDEs

A interação com o Claude Code Pro ocorre principalmente através de extensões nas IDEs.

### 4.1. Integração com Cursor 2.1 (IDE Principal)

O Cursor possui integração nativa com modelos da Anthropic. A configuração é feita para que o Cursor utilize a chave de API gerenciada pelo 1Password.

#### 4.1.1. Configuração de Modelo no Cursor

1. **Abrir Configurações do Cursor:**
   - `Cmd+,` (macOS) ou `Ctrl+,` (Linux/Windows)
   - Navegar até **Models** ou **AI Settings**

2. **Configurar Claude como modelo:**
   - Selecionar modelo: `claude-3-5-sonnet-20241022` (ou versão mais recente)
   - **Importante:** Não cole a API key diretamente na interface

#### 4.1.2. Carregar Chave via Variável de Ambiente

O Cursor deve ser iniciado com a variável `ANTHROPIC_API_KEY` já exportada:

**Método 1: Via ~/.zshrc (Persistente)**

Adicione ao `~/.zshrc`:

```bash
# Carregar chave do Claude via 1Password CLI
if command -v op &> /dev/null; then
  export ANTHROPIC_API_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential" 2>/dev/null)
fi
```

Depois recarregue:

```bash
source ~/.zshrc
```

**Método 2: Via Script de Inicialização (Recomendado)**

Crie `~/Dotfiles/scripts/load_ai_keys.sh`:

```bash
#!/usr/bin/env bash
# Carrega todas as chaves de API de IAs via 1Password

if ! command -v op &> /dev/null; then
  echo "⚠️  1Password CLI não encontrado"
  return 1
fi

# Verificar autenticação do 1Password
if ! op account list &> /dev/null; then
  echo "🔐 Autenticando no 1Password..."
  eval $(op signin)
fi

# Anthropic (Claude)
export ANTHROPIC_API_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential" 2>/dev/null)
[ -n "$ANTHROPIC_API_KEY" ] && echo "✅ ANTHROPIC_API_KEY carregada" || echo "❌ Falha ao carregar ANTHROPIC_API_KEY"

# OpenAI (se aplicável)
export OPENAI_API_KEY=$(op read "op://Development/OpenAI API Key/credential" 2>/dev/null)
[ -n "$OPENAI_API_KEY" ] && echo "✅ OPENAI_API_KEY carregada" || echo "⚠️  OPENAI_API_KEY não encontrada"

# Outras chaves...
```

Tornar executável e adicionar ao `~/.zshrc`:

```bash
chmod +x ~/Dotfiles/scripts/load_ai_keys.sh

# Adicionar ao ~/.zshrc
echo 'source ~/Dotfiles/scripts/load_ai_keys.sh' >> ~/.zshrc
source ~/.zshrc
```

**Método 3: Launcher Manual**

Para sessões específicas, crie um launcher:

```bash
#!/usr/bin/env bash
# ~/Dotfiles/scripts/launch_cursor_with_keys.sh

# Carregar chaves
eval $(op signin --account my.1password.com 2>/dev/null)
export ANTHROPIC_API_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential")

# Iniciar Cursor
open -a "Cursor"
```

#### 4.1.3. Uso do System Prompt Universal

Configure o `.cursorrules` no repositório para injetar contextos automaticamente:

```bash
# No diretório do projeto
cat > .cursorrules << 'EOF'
# System Prompt para Claude via Cursor

Você é um assistente de código expert seguindo as diretrizes do sistema.

## Contexto do Projeto
- Repositório: SYSTEM_PROMPT
- Estrutura: ~/Dotfiles/system_prompts/
- Secrets: Gerenciados via 1Password CLI
- Shell padrão: zsh (macOS), bash (Linux/DevContainer)

## Diretrizes de Segurança
- NUNCA exponha API keys ou secrets
- Use referências op:// para 1Password
- Valide paths absolutos
- Documente comandos shell

## Referências
- System Prompt Global: global/prompts/system/
- Scripts: global/scripts/
- Documentação: global/docs/
EOF
```

### 4.2. Integração com VS Code (IDE Secundário)

A integração no VS Code depende de extensões de terceiros ou da extensão oficial da Anthropic, se disponível.

#### 4.2.1. Instalar a Extensão

```bash
# Via linha de comando
code --install-extension anthropics.claude-vscode

# Ou buscar no Marketplace:
# - Abrir VS Code
# - Cmd+Shift+X (macOS) ou Ctrl+Shift+X (Linux/Windows)
# - Buscar por "Claude" ou "Anthropic"
# - Instalar a extensão oficial
```

#### 4.2.2. Configurar a Extensão

1. **Abrir Settings do VS Code:**
   - `Cmd+,` (macOS) ou `Ctrl+,` (Linux/Windows)
   - Buscar por "Claude" ou "Anthropic"

2. **Configurar API Key via variável de ambiente:**

   Editar `settings.json` do VS Code (`Cmd+Shift+P` > "Preferences: Open Settings (JSON)"):

   ```json
   {
     "claude.apiKey": "${env:ANTHROPIC_API_KEY}",
     "claude.model": "claude-3-5-sonnet-20241022"
   }
   ```

3. **Garantir que VS Code carrega as variáveis:**

   No workspace, criar `.vscode/settings.json`:

   ```json
   {
     "terminal.integrated.defaultProfile.osx": "zsh",
     "terminal.integrated.defaultProfile.linux": "bash",
     "terminal.integrated.env.osx": {
       "ANTHROPIC_API_KEY": "${env:ANTHROPIC_API_KEY}"
     },
     "terminal.integrated.env.linux": {
       "ANTHROPIC_API_KEY": "${env:ANTHROPIC_API_KEY}"
     }
   }
   ```

4. **Iniciar VS Code com variáveis carregadas:**

   ```bash
   # Carregar chaves antes de abrir o VS Code
   source ~/Dotfiles/scripts/load_ai_keys.sh
   code .
   ```

#### 4.2.3. Alternativa: Claude CLI Extension

Se preferir interagir via CLI dentro do VS Code:

```bash
# Instalar Claude CLI (Node.js)
npm install -g @anthropic-ai/claude-cli

# Configurar
claude configure

# Usar no terminal integrado
claude "Explique este código" < arquivo.py
```

---

## 5. Boas Práticas e Fluxo de Trabalho

### 5.1. Workflow Diário

```bash
# 1. Autenticar no 1Password (se necessário)
eval $(op signin)

# 2. Carregar todas as chaves de API
source ~/Dotfiles/scripts/load_ai_keys.sh

# 3. Verificar que as chaves foram carregadas
env | grep -E "ANTHROPIC|OPENAI|GEMINI"

# 4. Iniciar sua IDE
cursor .
# ou
code .
```

### 5.2. Script de Auditoria Periódica

Execute o script de auditoria regularmente para garantir que tudo está configurado:

```bash
# Executar auditoria completa
cd ~/Dotfiles/system_prompts/global
./scripts/auditar-1password-secrets_v1.0.0_20251130.sh

# Verificar relatório gerado
ls -la audit/*/1password/relatorio_*.md

# Abrir último relatório
open "$(find audit -name 'relatorio_*.md' | sort -r | head -1)"
```

### 5.3. Contexto e System Prompts

Ao usar o Claude para tarefas complexas, sempre forneça contexto máximo:

1. **Usar prompts do repositório:**

   ```bash
   # Listar prompts disponíveis
   ls -la global/prompts/system/

   # Exemplo de uso em script
   SYSTEM_PROMPT=$(cat global/prompts/system/PROMPT_GEMINI_REPO_GITHUB.md)
   ```

2. **Configurar .cursorrules por projeto:**
   - Cada repositório pode ter seu próprio `.cursorrules`
   - Referências aos prompts globais do sistema
   - Diretrizes de segurança específicas

3. **Template de .cursorrules:**

   ```markdown
   # System Prompt - [Nome do Projeto]

   ## Contexto
   - Tipo: [web/cli/api/etc]
   - Stack: [tecnologias]
   - Secrets: Via 1Password (referências op://)

   ## Diretrizes de Segurança
   - ❌ NUNCA: Hard-code de API keys
   - ✅ SEMPRE: Usar variáveis de ambiente
   - ✅ SEMPRE: Referências op:// em docs
   - ✅ SEMPRE: Validar inputs

   ## Padrões de Código
   - Shell: zsh (macOS), bash (Linux)
   - Documentação: Markdown com exemplos
   - Testes: [framework de testes]
   ```

### 5.4. Verificação de Segurança

Periodicamente, execute verificações para garantir que nenhum secret vazou:

```bash
# Verificar secrets em arquivos do repositório
cd ~/Dotfiles/system_prompts/global
./scripts/verificar_secrets_restantes.sh

# Verificar histórico git (caso necessário)
git log -p | grep -i "sk-ant-" && echo "⚠️ POSSÍVEL VAZAMENTO!" || echo "✅ Nenhum secret encontrado"

# Verificar arquivos de configuração locais (não versionados)
grep -r "sk-ant-" ~/.config/ ~/.cursor/ ~/.vscode/ 2>/dev/null || echo "✅ Configs limpas"
```

### 5.5. Rotação de Chaves

Recomenda-se rotacionar as API keys periodicamente:

```bash
# 1. Gerar nova chave no console da Anthropic
# 2. Atualizar no 1Password
op item edit "Anthropic API Key (Claude)" credential="sk-ant-NOVA_CHAVE"

# 3. Recarregar variáveis de ambiente
source ~/Dotfiles/scripts/load_ai_keys.sh

# 4. Testar nova chave
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 10,
    "messages": [{"role": "user", "content": "Hello"}]
  }'

# 5. Revogar chave antiga no console da Anthropic
```

### 5.6. Troubleshooting

#### Problema: "API key not found"

```bash
# Verificar se 1Password CLI está autenticado
op account list

# Re-autenticar se necessário
eval $(op signin)

# Verificar se o item existe
op item get "Anthropic API Key (Claude)"

# Testar leitura da chave
op read "op://Development/Anthropic API Key (Claude)/credential"
```

#### Problema: Cursor/VS Code não reconhece a chave

```bash
# Verificar se a variável está exportada
echo $ANTHROPIC_API_KEY

# Se vazio, carregar novamente
source ~/Dotfiles/scripts/load_ai_keys.sh

# Reiniciar a IDE APÓS carregar as variáveis
killall Cursor && open -a Cursor
# ou
killall Code && code .
```

#### Problema: "Permission denied" no 1Password CLI

```bash
# Verificar permissões do op
ls -la $(which op)

# Reinstalar se necessário
brew reinstall --cask 1password-cli

# Garantir que o 1Password app está rodando
open -a "1Password"
```

---

## 6. Integração com DevContainers

Para ambientes de desenvolvimento em containers (`.devcontainer`), a estratégia de secrets precisa ser adaptada:

### 6.1. Método Seguro: Mount de Secrets

No `devcontainer.json`:

```json
{
  "name": "system_prompts_dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "remoteEnv": {
    "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
  },
  "settings": {
    "terminal.integrated.defaultProfile.linux": "bash"
  },
  "mounts": [
    "source=${localEnv:HOME}/.config/op,target=/home/vscode/.config/op,type=bind,consistency=cached"
  ],
  "postCreateCommand": "echo '✅ DevContainer pronto com secrets do host'"
}
```

### 6.2. Alternativa: Secret Injection via Script

Criar `~/Dotfiles/scripts/inject_secrets_to_container.sh`:

```bash
#!/usr/bin/env bash
# Injeta secrets do 1Password no container ativo

CONTAINER_ID=$(docker ps -q --filter "label=devcontainer.local_folder=${PWD}")

if [ -z "$CONTAINER_ID" ]; then
  echo "❌ Nenhum DevContainer ativo encontrado"
  exit 1
fi

# Carregar chave do 1Password
ANTHROPIC_KEY=$(op read "op://Development/Anthropic API Key (Claude)/credential")

# Injetar no container
docker exec -it "$CONTAINER_ID" bash -c "echo 'export ANTHROPIC_API_KEY=${ANTHROPIC_KEY}' >> ~/.bashrc"

echo "✅ Secrets injetados no container $CONTAINER_ID"
```

---

## 7. Checklist de Configuração Completa

Use este checklist para validar que tudo está configurado corretamente:

- [ ] **1Password CLI instalado e configurado**

  ```bash
  op --version && op account list
  ```

- [ ] **API Key da Anthropic salva no 1Password**

  ```bash
  op item get "Anthropic API Key (Claude)"
  ```

- [ ] **Script de carregamento criado e funcional**

  ```bash
  source ~/Dotfiles/scripts/load_ai_keys.sh
  echo $ANTHROPIC_API_KEY | grep -q "sk-ant-" && echo "✅" || echo "❌"
  ```

- [ ] **~/.zshrc configurado para carregar chaves automaticamente**

  ```bash
  grep -q "load_ai_keys" ~/.zshrc && echo "✅" || echo "❌"
  ```

- [ ] **Cursor configurado com modelo Claude**
  - Abrir Cursor > Settings > Models
  - Verificar: `claude-3-5-sonnet-20241022` selecionado

- [ ] **VS Code (se usado) com extensão instalada**

  ```bash
  code --list-extensions | grep -q "anthropic" && echo "✅" || echo "❌"
  ```

- [ ] **.cursorrules criado no repositório**

  ```bash
  test -f .cursorrules && echo "✅" || echo "❌"
  ```

- [ ] **Script de auditoria executado sem erros**

  ```bash
  ./scripts/auditar-1password-secrets_v1.0.0_20251130.sh
  ```

- [ ] **Verificação de segurança: nenhum secret em plain text**

  ```bash
  ./scripts/verificar_secrets_restantes.sh
  ```

- [ ] **Teste de API funcional**

  ```bash
  curl -s https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d '{"model":"claude-3-5-sonnet-20241022","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}' \
    | jq -r '.content[0].text' && echo "✅ API funcionando"
  ```

---

## 8. Referências e Recursos

- **Documentação Oficial:**
  - [Anthropic API Docs](https://docs.anthropic.com/)
  - [Claude Models Overview](https://docs.anthropic.com/claude/docs/models-overview)
  - [1Password CLI Documentation](https://developer.1password.com/docs/cli)

- **Scripts do Repositório:**
  - `scripts/auditar-1password-secrets_v1.0.0_20251130.sh` - Auditoria completa
  - `scripts/verificar_secrets_restantes.sh` - Verificação de segurança
  - `scripts/load_ai_keys.sh` - Carregamento de chaves (criar conforme seção 4.1.2)

- **System Prompts:**
  - `global/prompts/system/` - Prompts globais do sistema
  - `.cursorrules` - Regras específicas por projeto

- **Configurações:**
  - `.vscode/settings.json` - Settings do VS Code no workspace
  - `.devcontainer/devcontainer.json` - Configuração de DevContainer

---

**Fim do Documento**

*Versão 1.0.0 - Última atualização: 2025-12-01*

*Integração completa com 1Password CLI implementada*
