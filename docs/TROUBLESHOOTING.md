# Solução de Problemas

Este guia ajuda a resolver problemas comuns do sistema de System Prompt Universal.

## Problemas Comuns

### 1. Scripts não executam

**Sintoma:** `Permission denied` ao executar scripts

**Solução:**
```bash
# Tornar scripts executáveis
chmod +x scripts/**/*.sh

# Verificar permissões
ls -la scripts/**/*.sh
```

### 2. System Prompt não aplicado no Cursor

**Sintoma:** Cursor não usa o system prompt

**Solução:**
1. Verificar se `.cursorrules` existe:
   ```bash
   ls -la ~/.cursorrules
   ```

2. Verificar `settings.json`:
   ```bash
   # macOS
   cat ~/Library/Application\ Support/Cursor/User/settings.json | grep systemPrompt

   # Ubuntu
   cat ~/.config/Cursor/User/settings.json | grep systemPrompt
   ```

3. Re-executar aplicação:
   ```bash
   ./scripts/shared/apply_cursor_prompt.sh
   ```

4. Reiniciar Cursor IDE

### 3. API Keys não detectadas

**Sintoma:** Scripts reportam `configured: false` para API keys

**Solução:**
1. Verificar variáveis de ambiente:
   ```bash
   echo $OPENAI_API_KEY
   echo $ANTHROPIC_API_KEY
   ```

2. Carregar variáveis:
   ```bash
   # Adicionar ao ~/.bashrc ou ~/.zshrc
   export OPENAI_API_KEY="sua-chave"
   source ~/.bashrc  # ou ~/.zshrc
   ```

3. Verificar arquivos `.env`:
   ```bash
   cat ~/.env | grep API_KEY
   ```

### 4. JSON inválido gerado

**Sintoma:** Erro ao processar JSON com `jq`

**Solução:**
1. Validar JSON:
   ```bash
   jq . /tmp/ia_collection/system_prompt_macos.json
   ```

2. Verificar erros no script:
   ```bash
   ./scripts/macos/collect_system_prompt_macos.sh 2>&1
   ```

3. Verificar se `jq` está instalado:
   ```bash
   which jq
   # Se não estiver: brew install jq (macOS) ou apt-get install jq (Ubuntu)
   ```

### 5. Sincronização falha

**Sintoma:** `sync_system_prompt.sh` não conecta ao servidor remoto

**Solução:**
1. Verificar conectividade:
   ```bash
   ping remote-host
   ssh user@remote-host "echo OK"
   ```

2. Verificar SSH configurado:
   ```bash
   ssh-keygen -t rsa
   ssh-copy-id user@remote-host
   ```

3. Verificar caminhos:
   ```bash
   # Verificar caminho remoto existe
   ssh user@remote-host "ls -la /root/SYSTEM_PROMPT/system_prompt_global.txt"
   ```

### 6. Python libraries não encontradas

**Sintoma:** Erro ao executar scripts de API

**Solução:**
```bash
# Verificar Python
python3 --version

# Instalar bibliotecas
pip3 install openai anthropic google-generativeai

# Verificar instalação
python3 -c "import openai; print(openai.__version__)"
```

### 7. Checksums diferentes entre ambientes

**Sintoma:** `compare_environments.sh` mostra checksums diferentes

**Solução:**
1. Sincronizar:
   ```bash
   ./scripts/shared/sync_system_prompt.sh
   ```

2. Verificar manualmente:
   ```bash
   # Mac
   shasum -a 256 ~/.system_prompts/system_prompt_global.txt

   # VPS
   sha256sum ~/.system_prompts/system_prompt_global.txt
   ```

3. Re-aplicar se necessário:
   ```bash
   ./scripts/shared/apply_cursor_prompt.sh
   ```

### 8. Relatórios não gerados

**Sintoma:** Arquivos de relatório não aparecem

**Solução:**
1. Verificar diretório de saída:
   ```bash
   echo $OUTPUT_DIR
   # Padrão: /tmp/ia_collection
   ```

2. Verificar permissões:
   ```bash
   ls -la /tmp/ia_collection/
   mkdir -p /tmp/ia_collection/reports
   ```

3. Executar com output explícito:
   ```bash
   OUTPUT_DIR=/tmp/ia_collection ./scripts/macos/collect_all_ia_macos.sh
   ```

## Diagnóstico

### Executar Validação Completa

```bash
./scripts/shared/validate_ia_system.sh
```

Isso verifica:
- System prompt global
- Configurações do Cursor
- API keys
- Ferramentas instaladas
- Ambiente

### Executar Auditoria

```bash
./scripts/shared/audit_system_prompts.sh
```

Isso gera relatório detalhado de:
- Arquivos de prompt
- Checksums
- Configurações
- Sincronização

### Verificar Logs

```bash
# Ver logs de coleta
cat /tmp/ia_collection/reports/*.log

# Ver erros
./scripts/macos/collect_all_ia_macos.sh 2>&1 | tee collection.log
```

## Comandos Úteis

### Verificar Estrutura

```bash
tree -L 3 SYSTEM_PROMPT/
```

### Verificar Scripts

```bash
find scripts -name "*.sh" -exec ls -la {} \;
```

### Testar Script Individual

```bash
# Executar com debug
bash -x scripts/macos/collect_system_prompt_macos.sh
```

### Limpar Arquivos Temporários

```bash
rm -rf /tmp/ia_collection/*
rm -rf SYSTEM_PROMPT/reports/*
```

## Obter Ajuda

Se o problema persistir:

1. Execute validação completa:
   ```bash
   ./scripts/shared/validate_ia_system.sh > validation.log 2>&1
   ```

2. Execute auditoria:
   ```bash
   ./scripts/shared/audit_system_prompts.sh > audit.log 2>&1
   ```

3. Colete informações do sistema:
   ```bash
   # macOS
   ./scripts/macos/collect_all_ia_macos.sh

   # Ubuntu
   ./scripts/ubuntu/collect_all_ia_ubuntu.sh
   ```

4. Revise os logs e relatórios gerados

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

