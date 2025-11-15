# Configuração do Cursor IDE

Guia completo para configurar o system prompt no Cursor IDE.

## Método Automático (Recomendado)

```bash
cd /root/SYSTEM_PROMPT
./scripts/shared/apply_cursor_prompt.sh
```

Este script:
1. Copia `system_prompt_global.txt` para `~/.cursorrules`
2. Configura `settings.json` do Cursor
3. Habilita system prompt no Cursor IDE

## Método Manual

### 1. Copiar System Prompt

```bash
# macOS
cp /root/SYSTEM_PROMPT/system_prompt_global.txt ~/.cursorrules

# Ubuntu
cp /root/SYSTEM_PROMPT/system_prompt_global.txt ~/.cursorrules
```

### 2. Configurar settings.json

**macOS:**
```bash
nano ~/Library/Application\ Support/Cursor/User/settings.json
```

**Ubuntu:**
```bash
nano ~/.config/Cursor/User/settings.json
```

Adicione ou edite:

```json
{
  "cursor.systemPrompt.enabled": true,
  "cursor.systemPrompt": "/root/SYSTEM_PROMPT/system_prompt_global.txt"
}
```

### 3. Reiniciar Cursor

Feche e reabra o Cursor IDE para aplicar as mudanças.

## Verificação

### Verificar .cursorrules

```bash
# Verificar se existe
ls -la ~/.cursorrules

# Verificar conteúdo
head -20 ~/.cursorrules
```

### Verificar settings.json

```bash
# macOS
cat ~/Library/Application\ Support/Cursor/User/settings.json | grep systemPrompt

# Ubuntu
cat ~/.config/Cursor/User/settings.json | grep systemPrompt
```

### Testar no Cursor

1. Abra o Cursor IDE
2. Pressione `Cmd+L` (macOS) ou `Ctrl+L` (Ubuntu) para abrir o chat
3. Faça uma pergunta técnica
4. Verifique se a resposta segue o padrão do system prompt

## Modelos Disponíveis

Configure o modelo no `settings.json`:

```json
{
  "cursor.chat.model": "claude-3-5-sonnet"
}
```

Modelos suportados:
- `claude-3-5-sonnet` (recomendado)
- `claude-3-opus`
- `gpt-4-turbo`
- `gpt-4`

## Troubleshooting

### System Prompt não funciona

1. Verificar se está habilitado:
   ```bash
   grep "cursor.systemPrompt.enabled" ~/.config/Cursor/User/settings.json
   ```

2. Verificar caminho do arquivo:
   ```bash
   ls -la $(grep "cursor.systemPrompt" ~/.config/Cursor/User/settings.json | cut -d'"' -f4)
   ```

3. Reiniciar Cursor completamente

### .cursorrules não é reconhecido

- Verificar se o arquivo está no home: `~/.cursorrules`
- Verificar permissões: `chmod 644 ~/.cursorrules`
- Reiniciar Cursor

### Settings.json não existe

O Cursor cria automaticamente. Se não existir:

1. Abra o Cursor
2. Vá em Settings (Cmd+, ou Ctrl+,)
3. Isso cria o arquivo automaticamente
4. Adicione as configurações manualmente

## Atualização

Para atualizar o system prompt:

```bash
# Atualizar arquivo
nano /root/SYSTEM_PROMPT/system_prompt_global.txt

# Re-aplicar
./scripts/shared/apply_cursor_prompt.sh

# Reiniciar Cursor
```

## Sincronização

Para sincronizar entre Mac e VPS:

```bash
./scripts/shared/sync_system_prompt.sh
```

Isso sincroniza:
- `system_prompt_global.txt`
- `~/.cursorrules` (opcional)

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

