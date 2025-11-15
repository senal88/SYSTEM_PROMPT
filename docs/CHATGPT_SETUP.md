# Configuração do ChatGPT Plus

Guia para configurar Custom Instructions no ChatGPT Plus usando o system prompt.

## Gerar Instruções

```bash
cd /root/SYSTEM_PROMPT
./scripts/shared/apply_chatgpt_prompt.sh
```

Isso gera o arquivo `configs/chatgpt_custom_instructions.txt`.

## Aplicar Manualmente

### 1. Acessar ChatGPT

1. Acesse https://chat.openai.com/
2. Faça login na sua conta Plus

### 2. Abrir Custom Instructions

1. Clique no seu perfil (canto inferior esquerdo)
2. Selecione "Custom instructions"
3. Ou acesse diretamente: https://chat.openai.com/?customInstructions=true

### 3. Copiar Instruções

1. Abra o arquivo gerado:
   ```bash
   cat configs/chatgpt_custom_instructions.txt
   ```

2. Copie todo o conteúdo (exceto os comentários no início)

3. Cole no campo "How would you like ChatGPT to respond?"

### 4. Salvar

1. Clique em "Save"
2. As instruções serão aplicadas imediatamente

## Verificação

### Testar no ChatGPT

1. Abra uma nova conversa no ChatGPT
2. Faça uma pergunta técnica
3. Verifique se a resposta segue o padrão do system prompt:
   - Respostas completas e finais
   - Sem perguntas ao final
   - Tom técnico e objetivo
   - Sem emojis ou informalidades

### Verificar Configuração

1. Vá em Custom Instructions novamente
2. Verifique se o conteúdo está salvo
3. Edite se necessário

## Atualização

Para atualizar as instruções:

1. Editar `system_prompt_global.txt`:
   ```bash
   nano /root/SYSTEM_PROMPT/system_prompt_global.txt
   ```

2. Re-gerar instruções:
   ```bash
   ./scripts/shared/apply_chatgpt_prompt.sh
   ```

3. Copiar novo conteúdo para ChatGPT

4. Salvar no ChatGPT

## Limitações

- Custom Instructions têm limite de caracteres (varia)
- Algumas instruções podem ser ignoradas pelo modelo
- Instruções são aplicadas globalmente a todas as conversas

## Dicas

### Instruções Eficazes

- Seja específico e claro
- Use formatação Markdown quando apropriado
- Teste diferentes formulações
- Revise periodicamente

### Testes

Teste com diferentes tipos de perguntas:
- Técnicas
- Criativas
- Analíticas
- Práticas

## Troubleshooting

### Instruções não funcionam

1. Verificar se está salvo:
   - Vá em Custom Instructions
   - Verifique se o conteúdo está lá

2. Limpar cache do navegador:
   - Limpar cookies do ChatGPT
   - Fazer logout e login novamente

3. Tentar em modo anônimo:
   - Abrir ChatGPT em aba anônima
   - Verificar se funciona

### Limite de caracteres

Se exceder o limite:
- Resumir instruções
- Remover comentários
- Focar nas instruções essenciais

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

