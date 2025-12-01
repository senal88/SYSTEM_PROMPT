# Guia de Instalação

Este guia detalha como instalar e configurar o sistema de System Prompt Universal.

## Pré-requisitos

### macOS Silicon

- macOS 12.0 ou superior
- Shell bash ou zsh
- Acesso de escrita ao diretório home
- Cursor IDE instalado (opcional, mas recomendado)

### VPS Ubuntu

- Ubuntu 20.04 ou superior
- Shell bash
- Acesso root ou sudo
- Python 3.8+ (para scripts de API)

## Instalação Passo a Passo

### 1. Obter o Sistema

```bash
# Se já estiver no diretório correto
cd /root/SYSTEM_PROMPT

# Ou copiar de outro local
cp -r /caminho/origem/SYSTEM_PROMPT /root/
cd /root/SYSTEM_PROMPT
```

### 2. Tornar Scripts Executáveis

```bash
# Tornar todos os scripts executáveis
find scripts -name "*.sh" -exec chmod +x {} \;

# Ou manualmente
chmod +x scripts/**/*.sh
```

### 3. Verificar Estrutura

```bash
# Verificar estrutura de diretórios
tree -L 3 SYSTEM_PROMPT/

# Deve mostrar:
# SYSTEM_PROMPT/
# ├── system_prompt_global.txt
# ├── prompts/
# ├── scripts/
# │   ├── macos/
# │   ├── ubuntu/
# │   └── shared/
# ├── templates/
# ├── configs/
# ├── reports/
# └── docs/
```

### 4. Configurar System Prompt Global

O arquivo `system_prompt_global.txt` já está incluído. Verifique se está completo:

```bash
# Verificar conteúdo
head -20 system_prompt_global.txt

# Verificar tamanho (deve ter pelo menos alguns KB)
wc -l system_prompt_global.txt
```

### 5. Instalar Dependências (Opcional)

#### jq (Recomendado para processamento JSON)

**macOS:**
```bash
brew install jq
```

**Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install -y jq
```

#### Python e Bibliotecas (Para APIs)

```bash
# Verificar Python
python3 --version

# Instalar bibliotecas (se necessário)
pip3 install openai anthropic google-generativeai
```

### 6. Configurar Variáveis de Ambiente

Crie ou edite `~/.env` ou adicione ao seu shell profile:

```bash
# Adicionar ao ~/.bashrc ou ~/.zshrc
export OPENAI_API_KEY="sua-chave-aqui"
export ANTHROPIC_API_KEY="sua-chave-aqui"
export GEMINI_API_KEY="sua-chave-aqui"
export HUGGINGFACE_API_KEY="sua-chave-aqui"
```

**Importante:** Nunca commite arquivos `.env` com chaves reais!

### 7. Testar Instalação

```bash
# Executar validação
./scripts/shared/validate_ia_system.sh

# Executar coleta de teste
# macOS:
./scripts/macos/collect_all_ia_macos.sh

# Ubuntu:
./scripts/ubuntu/collect_all_ia_ubuntu.sh
```

## Configuração Inicial

### 1. Aplicar System Prompt no Cursor

```bash
./scripts/shared/apply_cursor_prompt.sh
```

Isso irá:
- Copiar `system_prompt_global.txt` para `~/.cursorrules`
- Configurar `settings.json` do Cursor
- Habilitar system prompt no Cursor IDE

### 2. Configurar Outras Ferramentas

Siga os guias específicos em `docs/`:
- [CURSOR_SETUP.md](CURSOR_SETUP.md)
- [CHATGPT_SETUP.md](CHATGPT_SETUP.md)
- [PERPLEXITY_SETUP.md](PERPLEXITY_SETUP.md)
- [CLAUDE_SETUP.md](CLAUDE_SETUP.md)
- [GEMINI_SETUP.md](GEMINI_SETUP.md)
- [OPENAI_SETUP.md](OPENAI_SETUP.md)

### 3. Configurar Automação (Opcional)

Ver [AUTOMATION.md](AUTOMATION.md) para configurar:
- Cron jobs (Ubuntu)
- Launch agents (macOS)

## Verificação Pós-Instalação

Execute o checklist completo:

```bash
# 1. Validação completa
./scripts/shared/validate_ia_system.sh

# 2. Auditoria
./scripts/shared/audit_system_prompts.sh

# 3. Coleta completa
# macOS:
./scripts/macos/collect_all_ia_macos.sh

# Ubuntu:
./scripts/ubuntu/collect_all_ia_ubuntu.sh
```

## Solução de Problemas

Se encontrar problemas durante a instalação:

1. Verifique permissões dos scripts:
   ```bash
   ls -la scripts/**/*.sh
   ```

2. Verifique dependências:
   ```bash
   which python3
   which jq
   ```

3. Consulte [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Próximos Passos

Após instalação bem-sucedida:

1. ✅ Revisar [CONFIGURATION.md](CONFIGURATION.md)
2. ✅ Configurar automação (opcional)
3. ✅ Sincronizar entre ambientes (se aplicável)
4. ✅ Executar validação periódica

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

