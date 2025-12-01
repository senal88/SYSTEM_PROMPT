# 🚀 PLANEJAMENTO DE IMPLANTAÇÃO DEFINITIVA - SISTEMA DE PROMPTS GLOBAL

**Versão:** 3.0.0
**Data:** 2025-01-15
**Status:** 🎯 Planejamento Completo para Aprovação
**Objetivo:** Implantação definitiva e máxima conexão entre macOS Silicon e VPS Ubuntu

---

## 📋 ÍNDICE

1. [Visão Geral](#visão-geral)
2. [Objetivos](#objetivos)
3. [Estrutura Completa](#estrutura-completa)
4. [Fases de Execução](#fases-de-execução)
5. [Validação e Testes](#validação-e-testes)
6. [Sincronização Bidirecional](#sincronização-bidirecional)
7. [Métodos de Utilização](#métodos-de-utilização)
8. [Melhores Práticas](#melhores-práticas)

---

## 🎯 VISÃO GERAL

Este documento define o planejamento completo para implantação definitiva do sistema de prompts globais, garantindo máxima conexão e funcionalidade entre:

- **macOS Silicon** (`/Users/luiz.sena88/Dotfiles`)
- **VPS Ubuntu** (`/home/admin/Dotfiles`)

### Escopo

- ✅ Sistema de prompts estruturado e versionado
- ✅ Sincronização automática bidirecional
- ✅ Integração com IDEs (Cursor, VSCode, Codex)
- ✅ Configuração MCP servers completa
- ✅ Validação exaustiva e testes
- ✅ Documentação completa e atualizada
- ✅ Scripts de automação robustos

---

## 🎯 OBJETIVOS

### Objetivos Principais

1. **Conectividade Total**
   - Sincronização bidirecional confiável
   - Validação automática de integridade
   - Recuperação automática de falhas

2. **Funcionalidade Máxima**
   - Todos os prompts acessíveis em ambos os ambientes
   - Scripts funcionais e testados
   - Integração completa com IDEs

3. **Robustez e Confiabilidade**
   - Validação pré-deploy rigorosa
   - Testes exaustivos
   - Logs detalhados

4. **Documentação Completa**
   - Guias de utilização
   - Troubleshooting
   - Métodos de manutenção

---

## 📁 ESTRUTURA COMPLETA

### Estrutura macOS

```
~/Dotfiles/
├── system_prompts/
│   └── global/
│       ├── prompts/
│       │   ├── system/              # Prompts de sistema (Cursor, VSCode, Codex)
│       │   ├── audit/               # Prompts de auditoria
│       │   └── revision/            # Prompts de revisão
│       ├── docs/                    # Documentação completa
│       ├── scripts/                 # Scripts de automação
│       ├── governance/              # Governança e regras
│       ├── consolidated/            # Arquivos consolidados
│       ├── audit/                   # Resultados de auditorias
│       ├── logs/                    # Logs de execução
│       └── templates/               # Templates reutilizáveis
├── configs/
│   ├── cursor/
│   │   ├── settings.json
│   │   └── keybindings.json
│   ├── vscode/
│   │   └── settings.json
│   └── mcp/
│       ├── cursor-mcp-servers.json
│       └── claude-mcp-servers.json
└── scripts/
    ├── sync/
    │   ├── sync-system-prompts.sh   # Sincronização sistema prompts
    │   └── sync-global-configs.sh   # Sincronização configurações
    └── install/
        └── setup-system-prompts.sh  # Setup inicial
```

### Estrutura VPS

```
/home/admin/Dotfiles/
├── system_prompts/
│   └── global/
│       ├── prompts/
│       │   ├── system/
│       │   ├── audit/
│       │   └── revision/
│       ├── docs/
│       ├── scripts/
│       ├── governance/
│       ├── consolidated/
│       ├── audit/
│       ├── logs/
│       └── templates/
├── configs/
│   ├── mcp/
│   │   └── servers.json
│   └── shell/
│       └── bashrc-ubuntu.sh
└── scripts/
    └── sync/
        └── sync-from-macos.sh
```

---

## 🔄 FASES DE EXECUÇÃO

### FASE 0: VALIDAÇÃO RIGOROSA PRÉ-EXECUÇÃO (OBRIGATÓRIA)

**Esta fase DEVE ser executada ANTES de qualquer outra fase.**

#### 0.1 Validação de Dependências do Sistema

**Ferramentas Obrigatórias:**
- ✅ **1Password CLI**: `command -v op` → DEVE existir e estar autenticado
- ✅ **jq**: `command -v jq` → DEVE existir
- ✅ **Git**: `command -v git` → DEVE existir
- ✅ **SSH**: `command -v ssh` → DEVE existir
- ✅ **curl**: `command -v curl` → DEVE existir
- ✅ **rsync**: `command -v rsync` → DEVE existir (para sincronização eficiente)

**Ferramentas Opcionais:**
- ⚠️ **GitHub CLI**: `command -v gh` → Validar se existe
- ⚠️ **Docker**: `command -v docker` → Validar se existe
- ⚠️ **Node.js**: `command -v node` → Validar se existe

#### 0.2 Validação de Credenciais no 1Password

**Credenciais Obrigatórias:**
- ✅ **API-VPS-HOSTINGER**: Token válido (não placeholder)
- ✅ **Gemini-API-Keys**: Chaves válidas (não placeholder)
- ✅ **GitHub-Token**: Token válido se necessário
- ✅ **HuggingFace-Token**: Token válido se necessário

**Validação Específica:**
- ✅ Token Hostinger: Testar API → `curl -X GET "https://developers.hostinger.com/api/vps/v1/virtual-machines"`
- ✅ Token GitHub: Testar → `gh api user`
- ✅ Chaves Gemini: Validar formato e tamanho mínimo

#### 0.3 Validação de Conectividade

**SSH:**
- ✅ Testar conexão VPS: `ssh -o ConnectTimeout=5 admin-vps "echo OK"`
- ✅ Validar chave SSH: `ssh-add -l`
- ✅ Validar config SSH: `~/.ssh/config`

**APIs:**
- ✅ Hostinger API: Testar requisição de teste
- ✅ GitHub API: Testar autenticação
- ✅ Outras APIs conforme necessário

#### 0.4 Validação de Estrutura

**Diretórios:**
- ✅ `~/Dotfiles/system_prompts/global/` → DEVE existir
- ✅ `~/Dotfiles/configs/` → DEVE existir
- ✅ `~/Dotfiles/scripts/sync/` → DEVE existir

**Arquivos:**
- ✅ Scripts principais com permissões corretas (755)
- ✅ JSON/YAML válidos (testar com `jq` ou `yq`)

#### 0.5 Checklist de Validação Pré-Execução

**ANTES de executar qualquer fase:**

- [ ] Todas as ferramentas obrigatórias instaladas e funcionando
- [ ] Todas as credenciais no 1Password validadas (SEM placeholders)
- [ ] Todas as variáveis de ambiente validadas (SEM placeholders)
- [ ] Nomenclaturas seguem padrão obrigatório
- [ ] Duplicidades identificadas e removidas
- [ ] Obsoletos identificados e arquivados
- [ ] Todos os arquivos JSON/YAML válidos
- [ ] Todos os scripts válidos e com permissões corretas
- [ ] Conectividade SSH validada
- [ ] Conectividade APIs validada
- [ ] Estrutura de diretórios completa
- [ ] Nenhum placeholder encontrado em nenhum lugar

**SE QUALQUER ITEM FALHAR → PARAR execução e CORRIGIR antes de continuar**

---

### FASE 1: PREPARAÇÃO E ESTRUTURAÇÃO LOCAL (macOS)

#### 1.1 Criar Estrutura de Diretórios

```bash
# Criar estrutura completa no macOS
mkdir -p ~/Dotfiles/system_prompts/global/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections,guides},scripts/{sync,install,validate,test},governance/{rules,validation},consolidated,audit,logs,templates}
```

#### 1.2 Validar e Organizar Prompts Existentes

**Ações:**
- ✅ Validar todos os prompts em `prompts/`
- ✅ Organizar por categoria (system, audit, revision)
- ✅ Validar formato Markdown
- ✅ Verificar duplicidades
- ✅ Arquivar obsoletos

#### 1.3 Criar Scripts de Automação

**Scripts a criar:**
1. `scripts/sync/sync-system-prompts.sh` - Sincronização principal
2. `scripts/install/setup-system-prompts.sh` - Setup inicial
3. `scripts/validate/validate-prompts.sh` - Validação de prompts
4. `scripts/test/test-sync.sh` - Testes de sincronização

#### 1.4 Configurar Integrações IDEs

**Cursor:**
- ✅ Configurar `configs/cursor/settings.json`
- ✅ Configurar `configs/cursor/keybindings.json`
- ✅ Configurar `configs/mcp/cursor-mcp-servers.json`

**VSCode:**
- ✅ Configurar `configs/vscode/settings.json`
- ✅ Validar extensões recomendadas

**Codex:**
- ✅ Configurar `~/.codex/config.toml`
- ✅ Configurar MCP servers

---

### FASE 2: PREPARAÇÃO E ESTRUTURAÇÃO REMOTA (VPS)

#### 2.1 Validar Conexão SSH

**Validações:**
- ✅ Testar conexão: `ssh admin-vps "echo OK"`
- ✅ Validar autenticação sem senha
- ✅ Validar alias SSH configurado

#### 2.2 Criar Estrutura na VPS

```bash
# Criar estrutura completa na VPS
ssh admin-vps "mkdir -p /home/admin/Dotfiles/system_prompts/global/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections,guides},scripts/{sync,install,validate,test},governance/{rules,validation},consolidated,audit,logs,templates}"
```

#### 2.3 Validar Permissões

**Ações:**
- ✅ Configurar permissões corretas (755 para scripts, 644 para arquivos)
- ✅ Validar propriedade dos arquivos (usuário: admin)

#### 2.4 Configurar Shell na VPS

**Ações:**
- ✅ Validar `~/.bashrc` ou `/home/admin/.bashrc`
- ✅ Adicionar source para scripts de shell
- ✅ Validar variáveis de ambiente

---

### FASE 3: SCRIPTS DE SINCRONIZAÇÃO BIDIRECIONAL

#### 3.1 Script Principal de Sincronização

**Arquivo:** `scripts/sync/sync-system-prompts.sh`

**Funcionalidades:**
- ✅ Sincronização bidirecional (macOS ↔ VPS)
- ✅ Validação de integridade (checksums)
- ✅ Logs detalhados
- ✅ Recuperação de falhas
- ✅ Detecção de conflitos
- ✅ Backup antes de sincronizar

**Métodos de Sincronização:**
- **Push (macOS → VPS)**: Enviar alterações do macOS para VPS
- **Pull (VPS → macOS)**: Buscar alterações da VPS para macOS
- **Sync (Bidirecional)**: Sincronizar ambos os lados
- **Dry-run**: Simular sem executar

#### 3.2 Script de Validação

**Arquivo:** `scripts/validate/validate-prompts.sh`

**Validações:**
- ✅ Formato Markdown válido
- ✅ Estrutura de frontmatter (se aplicável)
- ✅ Links internos válidos
- ✅ Referências a arquivos existentes
- ✅ Nomenclatura padronizada

#### 3.3 Script de Testes

**Arquivo:** `scripts/test/test-sync.sh`

**Testes:**
- ✅ Teste de conexão SSH
- ✅ Teste de sincronização push
- ✅ Teste de sincronização pull
- ✅ Teste de validação de integridade
- ✅ Teste de detecção de conflitos

---

### FASE 4: INTEGRAÇÃO COM IDEs

#### 4.1 Cursor 2.0

**Configurações:**
- ✅ System prompt em `configs/cursor/settings.json`
- ✅ MCP servers em `configs/mcp/cursor-mcp-servers.json`
- ✅ Keybindings personalizados
- ✅ Extensões recomendadas

**Prompts:**
- ✅ `prompts/system/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md`
- ✅ Outros prompts específicos do Cursor

#### 4.2 VSCode

**Configurações:**
- ✅ Settings em `configs/vscode/settings.json`
- ✅ Extensões recomendadas
- ✅ Tasks e launch configurations

#### 4.3 Codex

**Configurações:**
- ✅ `~/.codex/config.toml`
- ✅ MCP servers configurados
- ✅ Custom prompts em `~/.codex/prompts/`

**Sincronização:**
- ✅ Prompts sincronizados via script
- ✅ Configurações sincronizadas via script

---

### FASE 5: MCP SERVERS E INTEGRAÇÕES

#### 5.1 Configuração MCP Servers

**Servers a configurar:**
- ✅ `hostinger-mcp` - API Hostinger
- ✅ `filesystem` - Sistema de arquivos
- ✅ `git` - Controle de versão
- ✅ `github` - Integração GitHub
- ✅ `docker` - Containers
- ✅ Outros conforme necessário

**Validação:**
- ✅ Testar conexão de cada server
- ✅ Validar variáveis de ambiente
- ✅ Testar funcionalidades principais

#### 5.2 Sincronização de Configurações MCP

**Ações:**
- ✅ Sincronizar `configs/mcp/*.json` entre macOS e VPS
- ✅ Validar paths e variáveis de ambiente
- ✅ Testar funcionalidade após sincronização

---

### FASE 6: VALIDAÇÃO EXAUSTIVA E TESTES

#### 6.1 Testes de Funcionalidade

**Testes Locais (macOS):**
- ✅ Listar todos os prompts
- ✅ Validar formato de cada prompt
- ✅ Testar scripts de automação
- ✅ Testar integrações IDEs
- ✅ Testar MCP servers

**Testes Remotos (VPS):**
- ✅ Testar estrutura de diretórios
- ✅ Validar permissões
- ✅ Testar scripts sincronizados
- ✅ Validar configurações

#### 6.2 Testes de Sincronização

**Cenários de Teste:**
1. **Sincronização Inicial**: macOS → VPS (primeira vez)
2. **Sincronização Incremental**: Alterações no macOS → VPS
3. **Sincronização Reversa**: Alterações na VPS → macOS
4. **Detecção de Conflitos**: Alterações simultâneas
5. **Recuperação de Falhas**: Interrupção durante sincronização

#### 6.3 Testes de Integração

**Testes:**
- ✅ Integração com Cursor após sincronização
- ✅ Integração com VSCode após sincronização
- ✅ Integração com Codex após sincronização
- ✅ MCP servers funcionando em ambos os ambientes

---

### FASE 7: DOCUMENTAÇÃO COMPLETA

#### 7.1 Documentação de Uso

**Documentos a criar/atualizar:**
1. **README.md principal** - Visão geral do sistema
2. **GUIA_UTILIZACAO.md** - Como usar o sistema
3. **GUIA_SINCRONIZACAO.md** - Como sincronizar
4. **GUIA_PROMPS.md** - Como criar e gerenciar prompts
5. **TROUBLESHOOTING.md** - Solução de problemas

#### 7.2 Documentação Técnica

**Documentos:**
- ✅ Arquitetura do sistema
- ✅ Estrutura de diretórios detalhada
- ✅ Formatos de arquivos
- ✅ APIs de scripts
- ✅ Métodos de validação

#### 7.3 Documentação de Manutenção

**Documentos:**
- ✅ Guia de atualização
- ✅ Guia de backup
- ✅ Guia de recuperação
- ✅ Checklist de manutenção

---

### FASE 8: IMPLANTAÇÃO E DEPLOY

#### 8.1 Deploy Inicial macOS

**Ações:**
- ✅ Validar estrutura completa
- ✅ Aplicar configurações IDEs
- ✅ Testar todas as integrações
- ✅ Validar scripts locais

#### 8.2 Deploy Inicial VPS

**Ações:**
- ✅ Sincronizar estrutura completa
- ✅ Aplicar configurações
- ✅ Validar scripts remotos
- ✅ Testar conectividade

#### 8.3 Validação Final

**Checklist:**
- [ ] Todos os prompts acessíveis em macOS
- [ ] Todos os prompts acessíveis em VPS
- [ ] Sincronização funcionando bidirecionalmente
- [ ] IDEs integradas e funcionais
- [ ] MCP servers configurados e funcionais
- [ ] Documentação completa e atualizada
- [ ] Scripts testados e validados
- [ ] Logs funcionando corretamente

---

## ✅ VALIDAÇÃO E TESTES

### Validações Obrigatórias

#### Validação de Integridade

```bash
# Gerar checksums de todos os arquivos
find ~/Dotfiles/system_prompts/global -type f -exec sha256sum {} \; > checksums-macos.txt
find /home/admin/Dotfiles/system_prompts/global -type f -exec sha256sum {} \; > checksums-vps.txt

# Comparar checksums
diff checksums-macos.txt checksums-vps.txt
```

#### Validação de Formato

```bash
# Validar JSON
find ~/Dotfiles/system_prompts/global -name "*.json" -exec jq . {} \; > /dev/null

# Validar Markdown
find ~/Dotfiles/system_prompts/global -name "*.md" -exec markdownlint {} \;
```

#### Validação de Permissões

```bash
# Scripts devem ser executáveis
find ~/Dotfiles/system_prompts/global/scripts -type f -name "*.sh" ! -perm +111

# Arquivos não devem ter permissões perigosas
find ~/Dotfiles/system_prompts/global -type f -perm +222
```

### Testes Automatizados

#### Suite de Testes

**Arquivo:** `scripts/test/test-all.sh`

**Testes incluídos:**
1. Teste de estrutura de diretórios
2. Teste de formato de arquivos
3. Teste de permissões
4. Teste de conectividade SSH
5. Teste de sincronização
6. Teste de integrações IDEs
7. Teste de MCP servers

---

## 🔄 SINCRONIZAÇÃO BIDIRECIONAL

### Estratégia de Sincronização

#### Método 1: Push (macOS → VPS)

**Uso:** Quando fazer alterações no macOS e quer enviar para VPS

```bash
./scripts/sync/sync-system-prompts.sh push
```

**Ações:**
- ✅ Backup automático na VPS antes de sobrescrever
- ✅ Validação de integridade após envio
- ✅ Logs detalhados
- ✅ Notificação de conflitos

#### Método 2: Pull (VPS → macOS)

**Uso:** Quando fazer alterações na VPS e quer buscar para macOS

```bash
./scripts/sync/sync-system-prompts.sh pull
```

**Ações:**
- ✅ Backup automático no macOS antes de sobrescrever
- ✅ Validação de integridade após recebimento
- ✅ Logs detalhados
- ✅ Notificação de conflitos

#### Método 3: Sync (Bidirecional)

**Uso:** Sincronizar ambos os lados (resolver conflitos manualmente)

```bash
./scripts/sync/sync-system-prompts.sh sync
```

**Ações:**
- ✅ Detectar alterações em ambos os lados
- ✅ Identificar conflitos
- ✅ Sincronizar arquivos sem conflitos
- ✅ Reportar conflitos para resolução manual

#### Método 4: Dry-run (Simulação)

**Uso:** Ver o que seria sincronizado sem executar

```bash
./scripts/sync/sync-system-prompts.sh dry-run
```

**Ações:**
- ✅ Listar arquivos que seriam sincronizados
- ✅ Mostrar diferenças
- ✅ Identificar conflitos potenciais
- ✅ Não fazer alterações

### Detecção de Conflitos

**Estratégia:**
- ✅ Comparar timestamps e checksums
- ✅ Identificar arquivos modificados em ambos os lados
- ✅ Criar backup de conflitos
- ✅ Reportar para resolução manual

### Backup Automático

**Estratégia:**
- ✅ Criar backup antes de qualquer sincronização
- ✅ Manter últimos N backups
- ✅ Rotacionar backups antigos
- ✅ Validar integridade dos backups

---

## 📚 MÉTODOS DE UTILIZAÇÃO

### Uso Básico

#### Listar Prompts Disponíveis

```bash
# macOS
ls -R ~/Dotfiles/system_prompts/global/prompts/

# VPS
ls -R /home/admin/Dotfiles/system_prompts/global/prompts/
```

#### Criar Novo Prompt

```bash
# Criar prompt de sistema
cat > ~/Dotfiles/system_prompts/global/prompts/system/MEU_PROMPT.md << 'EOF'
# Meu Prompt

Descrição do prompt...

Conteúdo do prompt...
EOF

# Sincronizar
./scripts/sync/sync-system-prompts.sh push
```

#### Editar Prompt Existente

```bash
# Editar prompt
vim ~/Dotfiles/system_prompts/global/prompts/system/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md

# Sincronizar alterações
./scripts/sync/sync-system-prompts.sh push
```

### Uso Avançado

#### Sincronização Automática

**Cron job (macOS):**
```bash
# Adicionar ao crontab
crontab -e

# Sincronizar a cada 6 horas
0 */6 * * * /Users/luiz.sena88/Dotfiles/system_prompts/global/scripts/sync/sync-system-prompts.sh push >> /tmp/sync-prompts.log 2>&1
```

**Cron job (VPS):**
```bash
# Adicionar ao crontab
crontab -e

# Sincronizar diariamente
0 2 * * * /home/admin/Dotfiles/system_prompts/global/scripts/sync/sync-from-macos.sh >> /var/log/sync-prompts.log 2>&1
```

#### Integração com Git

**Workflow:**
1. Fazer alterações localmente
2. Testar alterações
3. Sincronizar com VPS
4. Fazer commit no Git
5. Push para repositório

#### Validação Contínua

**Script de validação:**
```bash
# Validar todos os prompts
./scripts/validate/validate-prompts.sh

# Validar estrutura
./scripts/validate/validate-structure.sh

# Validar integrações
./scripts/validate/validate-integrations.sh
```

---

## 🎯 MELHORES PRÁTICAS

### Gerenciamento de Prompts

#### Nomenclatura

**Padrão:**
- ✅ UPPERCASE_SNAKE_CASE para nomes de arquivos
- ✅ Versões no formato: `_v2.0.0`
- ✅ Datas no formato: `_YYYYMMDD`

**Exemplos:**
- ✅ `CURSOR_2.0_SYSTEM_PROMPT_FINAL.md`
- ✅ `PROMPT_AUDITORIA_VPS_v1.0.0.md`
- ✅ `PROMPT_REVISAO_MEMORIAS_20251128.md`

#### Estrutura de Prompt

**Template:**
```markdown
# TÍTULO DO PROMPT

**Versão:** X.Y.Z
**Data:** YYYY-MM-DD
**Status:** [Status]
**Autor:** [Autor]

---

## SEÇÃO 1

Conteúdo...

## SEÇÃO 2

Conteúdo...

---

**Última Atualização:** YYYY-MM-DD
```

### Versionamento

**Estratégia:**
- ✅ Semver para versões principais
- ✅ Timestamps para versões de desenvolvimento
- ✅ Changelog detalhado

### Segurança

**Práticas:**
- ✅ NUNCA commitar credenciais
- ✅ Usar 1Password para todos os secrets
- ✅ Validar permissões de arquivos
- ✅ Validar integridade antes de sincronizar

### Logs e Monitoramento

**Práticas:**
- ✅ Logs detalhados de todas as operações
- ✅ Rotação de logs
- ✅ Alertas para falhas críticas
- ✅ Monitoramento de integridade

---

## 📋 CHECKLIST DE IMPLANTAÇÃO

### Pré-Implantação

- [ ] FASE 0 completa e validada
- [ ] Todas as dependências instaladas
- [ ] Todas as credenciais validadas
- [ ] Conectividade SSH testada
- [ ] Estrutura de diretórios criada

### Implantação Local (macOS)

- [ ] Estrutura criada e validada
- [ ] Prompts organizados e validados
- [ ] Scripts criados e testados
- [ ] Configurações IDEs aplicadas
- [ ] MCP servers configurados
- [ ] Testes locais passando

### Implantação Remota (VPS)

- [ ] Estrutura criada na VPS
- [ ] Sincronização inicial executada
- [ ] Scripts validados na VPS
- [ ] Configurações aplicadas
- [ ] Testes remotos passando

### Validação Final

- [ ] Sincronização bidirecional funcionando
- [ ] Todos os prompts acessíveis
- [ ] IDEs integradas e funcionais
- [ ] MCP servers operacionais
- [ ] Documentação completa
- [ ] Testes exaustivos passando

---

## 🚀 PRÓXIMOS PASSOS APÓS APROVAÇÃO

1. **Executar FASE 0** (Validação Rigorosa)
2. **Executar FASE 1** (Preparação macOS)
3. **Executar FASE 2** (Preparação VPS)
4. **Executar FASE 3** (Scripts de Sincronização)
5. **Executar FASE 4** (Integração IDEs)
6. **Executar FASE 5** (MCP Servers)
7. **Executar FASE 6** (Validação e Testes)
8. **Executar FASE 7** (Documentação)
9. **Executar FASE 8** (Deploy Final)
10. **Validação Final e Entrega**

---

## 📞 SUPORTE E MANUTENÇÃO

### Contatos

- **Documentação:** `~/Dotfiles/system_prompts/global/docs/`
- **Logs:** `~/Dotfiles/system_prompts/global/logs/`
- **Troubleshooting:** `~/Dotfiles/system_prompts/global/docs/TROUBLESHOOTING.md`

### Manutenção Periódica

**Semanal:**
- ✅ Validar sincronização
- ✅ Verificar logs
- ✅ Atualizar documentação se necessário

**Mensal:**
- ✅ Revisar e atualizar prompts
- ✅ Validar integrações
- ✅ Atualizar dependências
- ✅ Backup completo

---

**Última Atualização:** 2025-01-15
**Versão do Planejamento:** 3.0.0
**Status:** 🎯 Aguardando Aprovação para Execução
