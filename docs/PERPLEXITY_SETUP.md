# Configuração do Perplexity Pro

Guia para configurar Custom Instructions no Perplexity Pro usando o system prompt.

## Gerar Instruções

```bash
cd /root/SYSTEM_PROMPT
./scripts/shared/apply_perplexity_prompt.sh
```

Isso gera o arquivo `configs/perplexity_custom_instructions.txt`.

## Aplicar Manualmente

### 1. Acessar Perplexity

1. Acesse https://www.perplexity.ai/
2. Faça login na sua conta Pro

### 2. Abrir Settings

1. Clique no ícone de perfil (canto superior direito)
2. Selecione "Settings" ou "Preferences"
3. Procure por "Custom Instructions" ou "System Prompt"

### 3. Copiar Instruções

1. Abra o arquivo gerado:
   ```bash
   cat configs/perplexity_custom_instructions.txt
   ```

2. Copie todo o conteúdo (exceto os comentários no início)

3. Cole no campo de Custom Instructions

### 4. Salvar

1. Clique em "Save" ou "Apply"
2. As instruções serão aplicadas imediatamente

## Verificação

### Testar no Perplexity

1. Abra uma nova pesquisa no Perplexity
2. Faça uma pergunta técnica
3. Verifique se a resposta segue o padrão:
   - Respostas baseadas em evidências
   - Fontes citadas
   - Tom técnico e objetivo
   - Sem perguntas ao final

### Verificar Configuração

1. Vá em Settings novamente
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
   ./scripts/shared/apply_perplexity_prompt.sh
   ```

3. Copiar novo conteúdo para Perplexity

4. Salvar no Perplexity

## Características do Perplexity

### Vantagens

- Foco em fontes e evidências
- Citações automáticas
- Pesquisa em tempo real
- Múltiplas perspectivas

### Ajustes Recomendados

O system prompt pode ser ajustado para:
- Priorizar fontes confiáveis
- Incluir referências
- Manter foco em precisão
- Evitar especulações

## Troubleshooting

### Instruções não funcionam

1. Verificar se está salvo:
   - Vá em Settings
   - Verifique se o conteúdo está lá

2. Limpar cache do navegador:
   - Limpar cookies do Perplexity
   - Fazer logout e login novamente

3. Verificar plano Pro:
   - Custom Instructions podem estar disponíveis apenas no plano Pro
   - Verificar assinatura

### Localização das Configurações

A localização exata pode variar:
- Settings → Preferences → Custom Instructions
- Profile → Settings → System Prompt
- Account → Preferences → Instructions

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

