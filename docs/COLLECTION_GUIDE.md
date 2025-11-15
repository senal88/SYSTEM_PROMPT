# Guia de Coleta de Dados

Este guia explica como usar os scripts de coleta para obter informações sobre o sistema de IA.

## Visão Geral

Os scripts de coleta coletam informações sobre:

- System prompt e configurações
- Ferramentas de IA instaladas
- API keys configuradas
- Ambiente do sistema
- Extensões de IDE
- Configurações específicas por ferramenta

## Scripts de Coleta

### macOS

#### Coleta Completa

```bash
./scripts/macos/collect_all_ia_macos.sh
```

Executa todos os scripts individuais e gera relatório consolidado.

#### Scripts Individuais

```bash
# System Prompt
./scripts/macos/collect_system_prompt_macos.sh

# Cursor IDE
./scripts/macos/collect_cursor_config_macos.sh

# ChatGPT
./scripts/macos/collect_chatgpt_config_macos.sh

# Ferramentas de IA
./scripts/macos/collect_ia_tools_macos.sh

# API Keys
./scripts/macos/collect_api_keys_macos.sh

# Ambiente
./scripts/macos/collect_environment_macos.sh

# Extensões IDE
./scripts/macos/collect_ide_extensions_macos.sh
```

### Ubuntu

#### Coleta Completa

```bash
./scripts/ubuntu/collect_all_ia_ubuntu.sh
```

#### Scripts Individuais

```bash
# System Prompt
./scripts/ubuntu/collect_system_prompt_ubuntu.sh

# Cursor IDE
./scripts/ubuntu/collect_cursor_config_ubuntu.sh

# Claude API
./scripts/ubuntu/collect_claude_api_ubuntu.sh

# Gemini API
./scripts/ubuntu/collect_gemini_api_ubuntu.sh

# OpenAI API
./scripts/ubuntu/collect_openai_api_ubuntu.sh

# Ferramentas de IA
./scripts/ubuntu/collect_ia_tools_ubuntu.sh

# API Keys
./scripts/ubuntu/collect_api_keys_ubuntu.sh

# Ambiente
./scripts/ubuntu/collect_environment_ubuntu.sh
```

## Formato de Saída

### JSON

Cada script gera um arquivo JSON em `/tmp/ia_collection/`:

```json
{
  "timestamp": "2025-11-15T12:00:00Z",
  "platform": "macOS",
  "system_prompt": {
    "global_file": {
      "exists": true,
      "path": "/path/to/system_prompt_global.txt",
      "checksum": "sha256...",
      "size": 1234
    }
  }
}
```

### Markdown

O script master gera um relatório Markdown consolidado em `reports/report_TIMESTAMP.md`.

## Localização dos Arquivos

Por padrão, os arquivos são salvos em:

- **JSON individuais:** `/tmp/ia_collection/`
- **Relatórios consolidados:** `/tmp/ia_collection/reports/`

Para alterar o diretório:

```bash
export OUTPUT_DIR="/caminho/personalizado"
./scripts/macos/collect_all_ia_macos.sh
```

## Interpretação dos Resultados

### System Prompt

- `exists: true` - Arquivo encontrado
- `checksum` - Hash SHA256 para verificação de integridade
- `size` - Tamanho em bytes

### API Keys

- `configured: true` - Chave configurada
- `prefix` - Primeiros caracteres (sanitizado)
- `length` - Tamanho da chave

**Importante:** Valores completos de API keys nunca são exibidos por segurança.

### Ferramentas

- `installed: true` - Ferramenta instalada
- `version` - Versão detectada
- `path` - Caminho do executável

## Uso Avançado

### Coleta Automática

Configure automação para executar coletas periodicamente:

```bash
# Ver AUTOMATION.md para detalhes
```

### Integração com Outros Scripts

Os JSONs gerados podem ser processados por outros scripts:

```bash
# Exemplo: extrair checksum do system prompt
jq '.system_prompt.global_file.checksum' /tmp/ia_collection/system_prompt_macos.json
```

### Comparação Entre Ambientes

Use `compare_environments.sh` para comparar Mac vs VPS:

```bash
./scripts/shared/compare_environments.sh
```

## Troubleshooting

### Scripts não executam

```bash
# Verificar permissões
ls -la scripts/macos/*.sh

# Tornar executáveis
chmod +x scripts/**/*.sh
```

### JSON inválido

```bash
# Validar JSON
jq . /tmp/ia_collection/system_prompt_macos.json

# Verificar erros
./scripts/macos/collect_system_prompt_macos.sh 2>&1
```

### Arquivos não encontrados

Alguns arquivos podem não existir (normal). Os scripts reportam `exists: false` quando apropriado.

## Exemplos de Uso

### Coleta Diária

```bash
# Adicionar ao crontab (Ubuntu)
0 9 * * * /root/SYSTEM_PROMPT/scripts/ubuntu/collect_all_ia_ubuntu.sh
```

### Coleta Antes de Atualização

```bash
# Fazer backup antes de atualizar
./scripts/macos/collect_all_ia_macos.sh
# ... fazer atualizações ...
./scripts/macos/collect_all_ia_macos.sh
# Comparar resultados
```

### Validação com Coleta

```bash
# Executar coleta e validação juntos
./scripts/macos/collect_all_ia_macos.sh && \
./scripts/shared/validate_ia_system.sh
```

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

