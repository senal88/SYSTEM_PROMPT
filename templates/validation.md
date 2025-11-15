# Checklist de Validação - System Prompt IA

**Data:** {DATE}
**Ambiente:** {PLATFORM}
**Hostname:** {HOSTNAME}

---

## 1. System Prompt Global

- [ ] Arquivo `system_prompt_global.txt` existe
- [ ] Arquivo está no local correto (`~/.system_prompts/`)
- [ ] Checksum do arquivo é válido
- [ ] Versão do prompt está atualizada
- [ ] Conteúdo do prompt está completo

### Verificação de Integridade

```bash
# Verificar existência
ls -la ~/.system_prompts/system_prompt_global.txt

# Verificar checksum
sha256sum ~/.system_prompts/system_prompt_global.txt

# Verificar tamanho
stat -c%s ~/.system_prompts/system_prompt_global.txt
```

---

## 2. Cursor IDE

- [ ] Cursor IDE está instalado
- [ ] Arquivo `~/.cursorrules` existe
- [ ] Arquivo `settings.json` existe
- [ ] `cursor.systemPrompt.enabled` está definido como `true`
- [ ] `cursor.systemPrompt` aponta para o arquivo correto
- [ ] Modelo de chat está configurado
- [ ] Extensões de IA estão instaladas

### Verificação de Configuração

```bash
# Verificar .cursorrules
cat ~/.cursorrules

# Verificar settings.json
cat ~/.config/Cursor/User/settings.json | grep -i systemprompt
```

---

## 3. API Keys

- [ ] `OPENAI_API_KEY` está configurada
- [ ] `ANTHROPIC_API_KEY` está configurada
- [ ] `GEMINI_API_KEY` está configurada (se necessário)
- [ ] `HUGGINGFACE_API_KEY` está configurada (se necessário)
- [ ] Chaves estão em arquivos seguros (`.env`, não em código)
- [ ] Chaves não estão expostas em logs ou relatórios

### Verificação de Segurança

```bash
# Verificar variáveis de ambiente (sem mostrar valores)
env | grep -E "API_KEY|TOKEN" | sed 's/=.*/=***/'

# Verificar arquivos .env
grep -h "API_KEY" ~/.env ~/.env.local 2>/dev/null | sed 's/=.*/=***/'
```

---

## 4. Ferramentas CLI

- [ ] `python3` está instalado
- [ ] Bibliotecas Python de IA estão instaladas:
  - [ ] `openai`
  - [ ] `anthropic`
  - [ ] `google-generativeai`
  - [ ] `transformers` (se necessário)
- [ ] `ollama` está instalado (se necessário)
- [ ] `huggingface-cli` está instalado (se necessário)

### Verificação de Instalação

```bash
# Verificar Python
python3 --version

# Verificar bibliotecas
python3 -c "import openai; print(openai.__version__)"
python3 -c "import anthropic; print(anthropic.__version__)"
python3 -c "import google.generativeai; print('OK')"

# Verificar CLI tools
which ollama
which huggingface-cli
```

---

## 5. Ambiente

- [ ] Shell está configurado corretamente
- [ ] Aliases relevantes estão definidos
- [ ] Variáveis de ambiente estão carregadas
- [ ] PATH inclui diretórios necessários
- [ ] Editor padrão está configurado

### Verificação de Ambiente

```bash
# Verificar shell
echo $SHELL

# Verificar aliases
alias | grep -E "system-prompt|cursor|ia|ai"

# Verificar PATH
echo $PATH
```

---

## 6. Extensões IDE

- [ ] Extensões de IA estão instaladas no Cursor:
  - [ ] GitHub Copilot (se necessário)
  - [ ] Codeium (se necessário)
  - [ ] Outras extensões relevantes
- [ ] Extensões estão ativadas
- [ ] Extensões estão atualizadas

### Verificação de Extensões

```bash
# Listar extensões do Cursor
ls -la ~/.config/Cursor/User/extensions/
```

---

## 7. Sincronização (Mac ↔ VPS)

- [ ] System prompt está sincronizado entre ambientes
- [ ] Configurações estão consistentes
- [ ] Scripts de sincronização estão funcionando
- [ ] Última sincronização foi bem-sucedida

### Verificação de Sincronização

```bash
# Comparar checksums entre ambientes
# No Mac:
sha256sum ~/.system_prompts/system_prompt_global.txt

# No VPS:
sha256sum ~/.system_prompts/system_prompt_global.txt
```

---

## 8. Automação

- [ ] Cron jobs estão configurados (Ubuntu)
- [ ] Launch agents estão configurados (macOS)
- [ ] Coletas automáticas estão funcionando
- [ ] Relatórios estão sendo gerados
- [ ] Notificações estão configuradas (se necessário)

### Verificação de Automação

```bash
# Ubuntu - Verificar cron
crontab -l | grep -i "ia_collection\|system_prompt"

# macOS - Verificar launchd
launchctl list | grep -i "ia_collection\|system_prompt"
```

---

## 9. Documentação

- [ ] README.md está atualizado
- [ ] Documentação de instalação está completa
- [ ] Guias de configuração estão disponíveis
- [ ] Troubleshooting está documentado
- [ ] Referência de API está atualizada

---

## 10. Testes Finais

- [ ] Todos os scripts de coleta executam sem erros
- [ ] Relatórios JSON são gerados corretamente
- [ ] Relatórios Markdown são legíveis
- [ ] Scripts de aplicação funcionam
- [ ] Scripts de validação detectam problemas
- [ ] Sincronização funciona corretamente

---

## Resultado da Validação

**Status Geral:** ✅ Aprovado / ⚠️ Parcial / ❌ Falhou

**Itens Pendentes:**
1. {ITEM_1}
2. {ITEM_2}
3. {ITEM_3}

**Ações Necessárias:**
1. {ACTION_1}
2. {ACTION_2}

---

*Checklist gerado automaticamente pelo sistema de validação IA*

