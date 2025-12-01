# Relatório de Configuração IA - {PLATFORM}

**Timestamp:** {TIMESTAMP}
**Hostname:** {HOSTNAME}
**Platform:** {PLATFORM}
**Collection Version:** 1.0

---

## Resumo Executivo

Este relatório contém a coleta completa de configurações de IA no sistema {PLATFORM}.

### Status Geral

| Componente | Status | Observações |
|------------|--------|-------------|
| System Prompt Global | ✅/❌ | {STATUS} |
| Cursor IDE | ✅/❌ | {VERSION} |
| API Keys | ✅/❌ | {COUNT} configuradas |
| Ferramentas CLI | ✅/❌ | {COUNT} instaladas |
| Extensões IDE | ✅/❌ | {COUNT} instaladas |

---

## 1. System Prompt

### 1.1 Arquivo Global

- **Status:** {EXISTS}
- **Caminho:** {PATH}
- **Checksum:** {CHECKSUM}
- **Tamanho:** {SIZE} bytes
- **Versão:** {VERSION}

### 1.2 Cursor Rules

- **Status:** {EXISTS}
- **Caminho:** {PATH}
- **Checksum:** {CHECKSUM}

### 1.3 Configurações Cursor

- **System Prompt Habilitado:** {ENABLED}
- **Caminho do Prompt:** {PROMPT_PATH}
- **Modelo de Chat:** {CHAT_MODEL}

---

## 2. Ferramentas de IA

### 2.1 Cursor IDE

- **Instalado:** {INSTALLED}
- **Versão:** {VERSION}
- **Caminho:** {PATH}
- **Extensões:** {EXT_COUNT}

### 2.2 Ferramentas CLI

| Ferramenta | Instalado | Versão | Caminho |
|------------|-----------|--------|---------|
| ollama | {STATUS} | {VERSION} | {PATH} |
| python3 | {STATUS} | {VERSION} | {PATH} |
| huggingface-cli | {STATUS} | {VERSION} | {PATH} |

### 2.3 Bibliotecas Python

| Biblioteca | Instalado | Versão |
|------------|-----------|--------|
| openai | {STATUS} | {VERSION} |
| anthropic | {STATUS} | {VERSION} |
| google.generativeai | {STATUS} | {VERSION} |

---

## 3. API Keys

### 3.1 Status das Chaves

| API | Configurada | Prefixo |
|-----|-------------|---------|
| OpenAI | {STATUS} | {PREFIX} |
| Anthropic | {STATUS} | {PREFIX} |
| Gemini | {STATUS} | {PREFIX} |
| Hugging Face | {STATUS} | {PREFIX} |

### 3.2 Arquivos de Configuração

- **.env:** {EXISTS}
- **.env.local:** {EXISTS}
- **.bashrc:** {EXISTS}
- **.zshrc:** {EXISTS}

---

## 4. Ambiente

### 4.1 Sistema

- **Hostname:** {HOSTNAME}
- **OS Version:** {OS_VERSION}
- **Architecture:** {ARCHITECTURE}
- **Kernel:** {KERNEL}

### 4.2 Shell

- **Shell Atual:** {SHELL}
- **Versão:** {SHELL_VERSION}
- **Aliases Encontrados:** {ALIAS_COUNT}

### 4.3 Variáveis de Ambiente

- **PATH:** {PATH_VALUE}
- **HOME:** {HOME_VALUE}
- **EDITOR:** {EDITOR_VALUE}

---

## 5. Extensões IDE

### 5.1 Cursor

- **Extensões Instaladas:** {EXT_COUNT}
- **Diretório:** {EXT_DIR}

### 5.2 Extensões Conhecidas

| Extensão | ID | Instalado |
|----------|----|-----------|
| GitHub Copilot | GitHub.copilot | {STATUS} |
| Codeium | Codeium.codeium | {STATUS} |
| TabNine | TabNine.tabnine-vscode | {STATUS} |

---

## 6. Recomendações

### 6.1 Ações Imediatas

1. {RECOMMENDATION_1}
2. {RECOMMENDATION_2}
3. {RECOMMENDATION_3}

### 6.2 Melhorias Sugeridas

1. {IMPROVEMENT_1}
2. {IMPROVEMENT_2}

---

## 7. Próximos Passos

1. Revisar configurações coletadas
2. Aplicar system prompt onde necessário
3. Configurar ferramentas faltantes
4. Validar configurações
5. Executar auditoria completa

---

## 8. Arquivos de Relatório

- **JSON Consolidado:** `consolidated_{TIMESTAMP}.json`
- **Relatório Markdown:** `report_{TIMESTAMP}.md`
- **Relatórios Individuais:** Disponíveis em `reports/`

---

*Gerado automaticamente pelo sistema de coleta IA*
*Versão: 1.0*

