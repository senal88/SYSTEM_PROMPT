# ARQUITETURA IDEAL DE COLETAS - System Prompts Globais

**Versão:** 2.0.0
**Data:** 2025-11-28
**Status:** Ativo

---

## 1. VISÃO GERAL

Sistema de coleta automatizada e inteligente para gerar system prompts globais consolidados, otimizados para importação em LLMs (ChatGPT, Claude, Gemini, Perplexity, etc.).

### 1.1 Objetivos

- **Coleta Automatizada**: Scripts que coletam informações do ambiente macOS e VPS
- **Consolidação Inteligente**: Agregação de dados de múltiplas fontes
- **Formato Otimizado**: Saída em formato ideal para importação em LLMs
- **Versionamento**: Histórico de auditorias com timestamps
- **Proteção iCloud**: Respeito às políticas globais de proteção

---

## 2. ARQUITETURA DE COLETAS

### 2.1 Estrutura de Diretórios

```
~/Dotfiles/system_prompts/global/
├── audit/                          # Auditorias históricas
│   └── YYYYMMDD_HHMMSS/           # Timestamp da auditoria
│       ├── macos/                  # Dados coletados do macOS
│       │   ├── 01_sistema_hardware.txt
│       │   ├── 02_versoes_ferramentas.txt
│       │   ├── 03_homebrew.txt
│       │   ├── 04_shell_config.txt
│       │   ├── 05_aplicativos.txt
│       │   ├── 06_ides_editores.txt
│       │   ├── 07_projetos_repos.txt
│       │   ├── 08_llms_locais.txt
│       │   ├── 09_seguranca_acesso.txt
│       │   ├── 10_cloud_sync.txt
│       │   ├── 11_dotfiles_structure.txt
│       │   └── 12_atalhos_automacoes.txt
│       ├── vps/                    # Dados coletados do VPS (opcional)
│       ├── analysis/               # Análises intermediárias
│       └── consolidated/           # Arquivos consolidados
│           └── SYSTEM_PROMPT_GLOBAL_COMPLETO.md
├── scripts/                        # Scripts de automação
│   ├── master-auditoria-completa.sh    # Coleta completa
│   ├── analise-e-sintese.sh            # Análise e síntese
│   ├── verificar-dependencias.sh       # Verificação de dependências
│   └── consolidar-llms-full.sh         # Geração llms-full.txt
├── templates/                      # Templates para geração
├── universal.md                    # Prompt universal base
├── icloud_protection.md           # Política de proteção iCloud
└── llms-full.txt                  # Arquivo consolidado final (gerado)

```

### 2.2 Fluxo de Coleta

```
┌─────────────────────────────────────────────────────────────┐
│ FASE 1: COLETA macOS                                        │
├─────────────────────────────────────────────────────────────┤
│ 1. Sistema e Hardware                                       │
│ 2. Versões de Ferramentas                                   │
│ 3. Homebrew Packages                                        │
│ 4. Shell Configuration                                       │
│ 5. Aplicativos Instalados                                   │
│ 6. IDEs e Editores                                          │
│ 7. Projetos e Repositórios Git                              │
│ 8. LLMs Locais                                              │
│ 9. Segurança e Acesso                                       │
│ 10. Cloud Sync                                              │
│ 11. Dotfiles Structure                                      │
│ 12. Atalhos e Automações                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ FASE 2: COLETA VPS (Opcional)                              │
├─────────────────────────────────────────────────────────────┤
│ 1. Sistema Ubuntu                                           │
│ 2. Docker e Containers                                      │
│ 3. Estrutura de Diretórios                                  │
│ 4. Shell Config                                             │
│ 5. Traefik                                                  │
│ 6. Serviços Systemd                                         │
│ 7. Rede e Firewall                                          │
│ 8. Pacotes Instalados                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ FASE 3: ANÁLISE E SÍNTESE                                   │
├─────────────────────────────────────────────────────────────┤
│ 1. Extração de Informações Chave                           │
│ 2. Consolidação de Dados                                    │
│ 3. Aplicação de Templates                                   │
│ 4. Integração de Políticas Globais                          │
│ 5. Formatação para LLMs                                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ FASE 4: GERAÇÃO llms-full.txt                              │
├─────────────────────────────────────────────────────────────┤
│ 1. Consolidação Completa                                    │
│ 2. Otimização para Importação                               │
│ 3. Remoção de Redundâncias                                 │
│ 4. Formatação Final                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. COMPONENTES DE COLETA

### 3.1 Coleta macOS

**Script:** `master-auditoria-completa.sh`

**Módulos de Coleta:**

1. **Sistema e Hardware**
   - Versão macOS
   - Modelo do Mac
   - Chip/Processador
   - Memória RAM
   - Espaço em disco

2. **Versões de Ferramentas**
   - Python, Node.js, Docker, Git
   - Ollama, 1Password CLI
   - Cursor, VS Code
   - Homebrew

3. **Homebrew Packages**
   - Formulae instalados
   - Casks instalados
   - Services ativos
   - Taps configurados

4. **Shell Configuration**
   - `.zshrc` completo
   - `.bashrc` completo
   - Aliases definidos
   - Variáveis de ambiente
   - PATH configurado
   - Funções shell

5. **Aplicativos**
   - `/Applications` (sistema)
   - `~/Applications` (usuário)
   - Login items

6. **IDEs e Editores**
   - VS Code: settings, extensions
   - Cursor: settings, extensions
   - Raycast: configurações

7. **Projetos e Repositórios**
   - Estrutura de diretórios principais
   - Repositórios Git com remotes
   - Branches ativos

8. **LLMs Locais**
   - Ollama modelos
   - LM Studio
   - ChromaDB
   - Python envs

9. **Segurança e Acesso**
   - Chaves SSH
   - SSH config
   - 1Password vaults e items

10. **Cloud Sync**
    - iCloud Drive
    - Google Drive
    - Dropbox
    - OneDrive

11. **Dotfiles Structure**
    - Estrutura completa do Dotfiles
    - Scripts disponíveis
    - `.config` structure

12. **Atalhos e Automações**
    - Shortcuts.app
    - Automator Services

### 3.2 Coleta VPS (Opcional)

**Script:** `master-auditoria-completa.sh` (módulo VPS)

**Módulos de Coleta:**

1. **Sistema**
   - Versão Ubuntu
   - CPU, Memória, Disco
   - IP Público

2. **Docker**
   - Versão Docker e Compose
   - Containers ativos
   - Services (Swarm)
   - Networks e Volumes

3. **Estrutura**
   - Diretórios principais
   - Repositórios Git

4. **Shell Config**
   - `.bashrc`
   - Aliases
   - Cron jobs

5. **Traefik**
   - Configuração
   - Dynamic config

6. **Serviços**
   - Systemd services ativos

7. **Rede**
   - Interfaces de rede
   - Portas abertas
   - Firewall (UFW)

8. **Pacotes**
   - APT packages críticos
   - NPM global

---

## 4. PROCESSAMENTO E CONSOLIDAÇÃO

### 4.1 Análise e Síntese

**Script:** `analise-e-sintese.sh`

**Processos:**

1. **Extração de Informações Chave**
   - Versão macOS
   - Hardware specs
   - Contagem de pacotes/ferramentas
   - IDEs e extensões

2. **Consolidação de Dados**
   - Agregação de múltiplas fontes
   - Remoção de duplicatas
   - Normalização de formatos

3. **Aplicação de Templates**
   - Template base universal
   - Integração de políticas
   - Formatação estruturada

4. **Geração de Output**
   - Markdown estruturado
   - Variáveis substituídas
   - Timestamps atualizados

### 4.2 Geração llms-full.txt

**Script:** `consolidar-llms-full.sh`

**Processos:**

1. **Consolidação Completa**
   - Leitura de todas as auditorias
   - Integração de `universal.md`
   - Integração de `icloud_protection.md`
   - Dados da última auditoria

2. **Otimização para LLMs**
   - Formato texto puro otimizado
   - Remoção de markdown desnecessário
   - Estrutura hierárquica clara
   - Seções bem delimitadas

3. **Remoção de Redundâncias**
   - Informações duplicadas
   - Dados obsoletos
   - Formatação excessiva

4. **Formatação Final**
   - Encoding UTF-8
   - Quebras de linha consistentes
   - Seções numeradas
   - Índice no início

---

## 5. DEPENDÊNCIAS E REQUISITOS

### 5.1 Ferramentas Necessárias

**macOS:**

- `bash` (versão 3.2+)
- `grep`, `awk`, `sed`
- `git`
- `brew` (Homebrew)
- `ssh` (para VPS)
- `scp` (para VPS)

**Opcional:**

- `jq` (para JSON)
- `yq` (para YAML)
- `tree` (para estrutura de diretórios)

### 5.2 Verificação de Dependências

**Script:** `verificar-dependencias.sh`

Verifica e instala automaticamente:

- Ferramentas básicas do sistema
- Homebrew packages necessários
- Permissões de acesso
- Estrutura de diretórios

---

## 6. POLÍTICAS E RESTRIÇÕES

### 6.1 Proteção iCloud

**Arquivo:** `icloud_protection.md`

**Regras Aplicadas:**

- Nunca interferir com iCloud Control
- Nunca interferir com iOS 26.1 OTA
- Bloquear sincronização local indevida
- Proteger espaço em disco
- Operar em modo seguro e conservador

### 6.2 Diretórios Autorizados

Toda automação deve ocorrer somente em:

- `/Users/luiz.sena88/Dotfiles/icloud_control/`
- `/Users/luiz.sena88/Dotfiles/icloud_control/`
- `/Users/luiz.sena88/Dotfiles/logs/`
- `/Users/luiz.sena88/Dotfiles/icloud_control/.state/`

### 6.3 Formatos Bloqueados

Proibir sincronizações locais dos formatos:

- Mídia: `.raw .mov .mkv .mp4 .avi`
- Arquivos: `.zip .rar .tar .gz .pkg .dmg .iso .img .backup .ipa .ipsw`
- Desenvolvimento: `.venv .pyc .cache .node .jsbundle .dylib`

---

## 7. USO E AUTOMAÇÃO

### 7.1 Execução Manual

```bash
# Coleta completa
cd ~/Dotfiles/system_prompts/global/scripts
./master-auditoria-completa.sh

# Análise e síntese
./analise-e-sintese.sh

# Geração llms-full.txt
./consolidar-llms-full.sh
```

### 7.2 Execução Automatizada

```bash
# Pipeline completo
./master-auditoria-completa.sh && \
./analise-e-sintese.sh && \
./consolidar-llms-full.sh
```

### 7.3 Integração com Cron

```bash
# Executar diariamente às 02:00
0 2 * * * /Users/luiz.sena88/Dotfiles/system_prompts/global/scripts/master-auditoria-completa.sh
```

---

## 8. FORMATO llms-full.txt

### 8.1 Estrutura do Arquivo

```
================================================================================
SYSTEM PROMPT GLOBAL - LLMS FULL CONSOLIDADO
================================================================================

Versão: 1.0.0
Data de Geração: DD/MM/YYYY HH:MM:SS
Fonte: Auditoria completa macOS Silicon + VPS Ubuntu

================================================================================
ÍNDICE
================================================================================

1. IDENTIDADE E CONTEXTO OPERACIONAL
2. AMBIENTE TÉCNICO DETALHADO
3. PREFERÊNCIAS E COMPORTAMENTO
4. ÁREAS DE ESPECIALIZAÇÃO
5. ESTRUTURA DE PROJETOS E REPOSITÓRIOS
6. FERRAMENTAS E PLATAFORMAS DE IA
7. SEGURANÇA E SECRETS
8. PADRÕES DE TRABALHO
9. PREFERÊNCIAS TÉCNICAS ESPECÍFICAS
10. OBJETIVOS E DIRETRIZES
11. CONTEXTOS ESPECÍFICOS
12. COMANDOS E ALIASES COMUNS
13. RESTRIÇÕES E LIMITAÇÕES
14. POLÍTICA DE PROTEÇÃO ICLOUD
15. MÉTRICAS DE SUCESSO

================================================================================
[CONTEÚDO DETALHADO]
================================================================================
```

### 8.2 Otimizações para LLMs

- **Formato texto puro**: Sem markdown complexo
- **Seções numeradas**: Facilita navegação
- **Índice no início**: Referência rápida
- **Estrutura hierárquica**: Informações organizadas
- **Sem redundâncias**: Dados únicos e consolidados
- **Encoding UTF-8**: Suporte completo a caracteres

---

## 9. VERSIONAMENTO E HISTÓRICO

### 9.1 Estrutura de Versionamento

- **Auditorias**: Timestamp `YYYYMMDD_HHMMSS`
- **Arquivos consolidados**: Versão semântica `X.Y.Z`
- **Changelog**: Registro de mudanças significativas

### 9.2 Retenção de Dados

- **Auditorias**: Manter últimas 10 execuções
- **Consolidados**: Manter todas as versões
- **Backup**: Automático antes de substituições

---

## 10. MANUTENÇÃO E MELHORIAS

### 10.1 Checklist de Manutenção

- [ ] Verificar dependências mensalmente
- [ ] Revisar templates trimestralmente
- [ ] Atualizar políticas conforme necessário
- [ ] Limpar auditorias antigas
- [ ] Validar formato de saída

### 10.2 Melhorias Futuras

- [ ] Coleta incremental (apenas mudanças)
- [ ] Integração com APIs (GitHub, Docker Hub)
- [ ] Dashboard web para visualização
- [ ] Exportação em múltiplos formatos (JSON, YAML)
- [ ] Compressão e otimização de tamanho

---

**Última Atualização:** 2025-11-28
**Versão:** 2.0.0
**Status:** Ativo e em Produção
