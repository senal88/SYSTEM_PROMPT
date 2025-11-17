# Template de Prompt para LLM

## Estrutura de Prompt Eficaz

### 1. Contexto Inicial
```
Você é um assistente especializado em [área específica].
Estou trabalhando em [contexto do projeto].
```

### 2. Tarefa Específica
```
Preciso [tarefa específica e clara].
```

### 3. Informações de Entrada
```
Tenho os seguintes dados:
- [Dado 1]
- [Dado 2]
```

### 4. Restrições e Requisitos
```
Restrições:
- [Restrição 1]
- [Restrição 2]

Requisitos:
- [Requisito 1]
- [Requisito 2]
```

### 5. Formato de Saída Esperado
```
Espero receber:
- [Formato 1]
- [Formato 2]
```

### 6. Exemplos (Opcional)
```
Exemplo de saída esperada:
[Exemplo]
```

## Exemplo Completo

```
Você é um assistente especializado em DevOps e automação.

Estou trabalhando em um projeto de automação de deployment 
para VPS Ubuntu usando Docker Compose.

Preciso criar um script que:
1. Faz deploy automático de containers
2. Usa 1Password para gerenciar secrets
3. Valida configuração antes de deploy

Restrições:
- Não hardcodar secrets
- Compatível com bash e zsh
- Deve funcionar em VPS Ubuntu

Requisitos:
- Usar 1Password CLI para secrets
- Logging detalhado
- Tratamento de erros robusto

Formato esperado:
- Script bash executável
- Comentários em português
- Funções bem organizadas
```

