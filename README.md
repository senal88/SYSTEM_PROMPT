<<<<<<< HEAD
# System Prompt Universal para IAs Comerciais

Sistema completo para aplicar e gerenciar system prompts em todas as ferramentas de IA comerciais, maximizando a engenharia de contexto.

## Visão Geral

Este sistema permite:

- ✅ Aplicar system prompt unificado em múltiplas IAs comerciais
- ✅ Coletar e validar configurações automaticamente
- ✅ Sincronizar entre ambientes (macOS Silicon e VPS Ubuntu)
- ✅ Gerar relatórios e auditorias completas
- ✅ Automatizar coletas e validações

## Ferramentas Suportadas

- **Cursor IDE** - Configuração via `.cursorrules` e `settings.json`
- **ChatGPT Plus** - Custom Instructions
- **Perplexity Pro** - Custom Instructions
- **Claude Code** - System prompt via API
- **Gemini 2.5 Pro** - System instructions via API
- **OpenAI API** - System prompt via API
- **Extensões IDE** - GitHub Copilot, Codeium, etc.

## Estrutura do Projeto

```
SYSTEM_PROMPT/
├── system_prompt_global.txt    # Prompt principal
├── prompts/                     # Prompts específicos por ferramenta
├── scripts/
│   ├── macos/                  # Scripts para macOS Silicon
│   ├── ubuntu/                 # Scripts para VPS Ubuntu
│   └── shared/                 # Scripts compartilhados
├── templates/                  # Templates de saída
├── configs/                    # Configurações geradas
├── reports/                    # Relatórios gerados
└── docs/                      # Documentação completa
```

## Início Rápido

### 1. Instalação

```bash
# Clonar ou copiar o diretório SYSTEM_PROMPT
cd /root/SYSTEM_PROMPT

# Tornar scripts executáveis
chmod +x scripts/**/*.sh
```

### 2. Aplicar System Prompt no Cursor

```bash
./scripts/shared/apply_cursor_prompt.sh
```

### 3. Coletar Informações do Sistema

**macOS:**
```bash
./scripts/macos/collect_all_ia_macos.sh
```

**Ubuntu:**
```bash
./scripts/ubuntu/collect_all_ia_ubuntu.sh
```

### 4. Validar Configurações

```bash
./scripts/shared/validate_ia_system.sh
```

## Documentação Completa

- **[INSTALLATION.md](docs/INSTALLATION.md)** - Guia de instalação detalhado
- **[CONFIGURATION.md](docs/CONFIGURATION.md)** - Configuração por ferramenta
- **[COLLECTION_GUIDE.md](docs/COLLECTION_GUIDE.md)** - Guia de uso dos scripts de coleta
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Solução de problemas
- **[API_REFERENCE.md](docs/API_REFERENCE.md)** - Referência de APIs

## Documentação por Ferramenta

- **[CURSOR_SETUP.md](docs/CURSOR_SETUP.md)** - Configuração do Cursor IDE
- **[CHATGPT_SETUP.md](docs/CHATGPT_SETUP.md)** - Configuração do ChatGPT Plus
- **[PERPLEXITY_SETUP.md](docs/PERPLEXITY_SETUP.md)** - Configuração do Perplexity Pro
- **[CLAUDE_SETUP.md](docs/CLAUDE_SETUP.md)** - Configuração da Claude API
- **[GEMINI_SETUP.md](docs/GEMINI_SETUP.md)** - Configuração da Gemini API
- **[OPENAI_SETUP.md](docs/OPENAI_SETUP.md)** - Configuração da OpenAI API

## Scripts Principais

### Coleta

- `collect_all_ia_macos.sh` - Coleta completa (macOS)
- `collect_all_ia_ubuntu.sh` - Coleta completa (Ubuntu)
- Scripts individuais para cada componente

### Aplicação

- `apply_cursor_prompt.sh` - Aplica no Cursor IDE
- `apply_chatgpt_prompt.sh` - Gera instruções para ChatGPT
- `apply_perplexity_prompt.sh` - Gera instruções para Perplexity
- `apply_claude_prompt.sh` - Configura Claude API
- `apply_gemini_prompt.sh` - Configura Gemini API
- `apply_openai_prompt.sh` - Configura OpenAI API

### Validação

- `validate_ia_system.sh` - Validação completa
- `audit_system_prompts.sh` - Auditoria de prompts
- `compare_environments.sh` - Compara Mac vs VPS

### Sincronização

- `sync_system_prompt.sh` - Sincroniza entre ambientes

## Automação

O sistema suporta automação via:

- **Cron jobs** (Ubuntu) - Execução agendada
- **Launch agents** (macOS) - Execução agendada

Ver [docs/AUTOMATION.md](docs/AUTOMATION.md) para detalhes.

## Requisitos

- **macOS Silicon**: macOS 12+ com shell bash/zsh
- **Ubuntu**: Ubuntu 20.04+ com bash
- **Python 3**: Para scripts de API (opcional)
- **jq**: Para processamento JSON (opcional, mas recomendado)

## Licença

Uso interno - Sistema proprietário

## Suporte

Para problemas ou dúvidas, consulte:
1. [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
2. Execute `validate_ia_system.sh` para diagnóstico
3. Execute `audit_system_prompts.sh` para auditoria completa

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

=======
# SYSTEM_PROMPT
SYSTEM PROMPT GLOBAL – GOVERNANÇA, EXECUÇÃO E PRECISÃO
>>>>>>> 49cd5535eea46addd251ee55a7265f192ea78de2
