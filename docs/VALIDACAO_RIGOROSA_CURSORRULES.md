# 🔒 Validação Rigorosa - Cursor Rules v3.0.0

**Versão**: 3.0.0
**Data**: 2025-11-17

---

## 🎯 Objetivo

O `.cursorrules` foi atualizado com **validação rigorosa pré-execução** que garante que:

1. ✅ **NENHUMA credencial com placeholder** seja aceita como válida
2. ✅ **TODAS as dependências** sejam validadas antes de usar
3. ✅ **TODAS as variáveis** sejam validadas antes de usar
4. ✅ **NENHUM erro potencial** passe desatualizado
5. ✅ **TODAS as nomenclaturas** sigam padrão obrigatório
6. ✅ **DUPLICIDADES e OBSOLETOS** sejam identificados e tratados

---

## 🚨 FASE 0: Validação Rigorosa Pré-Execução (OBRIGATÓRIA)

Esta fase **DEVE ser executada ANTES de qualquer outra fase**.

### Placeholders INVÁLIDOS (NUNCA Aceitar)

```
- "YOUR_API_KEY"
- "your-api-key-here"
- "placeholder"
- "REPLACE_ME"
- "INSERT_KEY_HERE"
- "example.com"
- "example@example.com"
- "1234567890"
- "changeme"
- "TODO"
- "FIXME"
- "TBD"
- "null"
- "undefined"
- "empty"
- ""
- Qualquer string com menos de 16 caracteres para senhas
- Qualquer string que contenha "example", "test", "demo", "sample"
- Qualquer string que seja apenas números sequenciais
- Qualquer string que seja apenas letras sequenciais
```

### Validações Obrigatórias

#### 1. Ferramentas do Sistema
- ✅ 1Password CLI instalado e autenticado
- ✅ jq instalado
- ✅ Git instalado e configurado
- ✅ SSH configurado
- ✅ curl instalado

#### 2. Credenciais no 1Password
- ✅ Item existe
- ✅ Campo preenchido (não vazio)
- ✅ NÃO é placeholder
- ✅ Formato válido
- ✅ Não expirado
- ✅ Único (sem duplicatas)

#### 3. Variáveis de Ambiente
- ✅ Definida
- ✅ Não vazia
- ✅ Não placeholder
- ✅ Formato correto
- ✅ Acessível (quando necessário)

#### 4. Nomenclaturas
- ✅ Segue padrão: `<prefixo>-<tipo>-<ambiente>-<versao>-<timestamp>.<extensao>`
- ✅ Prefixo válido
- ✅ Tipo válido
- ✅ Ambiente válido

#### 5. Duplicidades e Obsoletos
- ✅ Duplicatas identificadas e removidas
- ✅ Obsoletos identificados e arquivados
- ✅ Referências atualizadas

#### 6. Arquivos e Scripts
- ✅ JSON/YAML válidos
- ✅ Scripts com sintaxe válida
- ✅ Permissões corretas

#### 7. Conectividade
- ✅ SSH funcionando
- ✅ APIs respondendo

---

## 🔒 Regras Críticas

### NUNCA Aceitar Placeholders

**Qualquer valor que seja placeholder → REJEITAR imediatamente**

### NUNCA Executar Sem Validação

**FASE 0 DEVE ser executada ANTES de qualquer outra fase**

### NUNCA Ignorar Erros Críticos

**Erros críticos → PARAR execução imediatamente**

---

## ✅ Checklist de Validação

Antes de executar qualquer fase:

- [ ] Todas as ferramentas obrigatórias instaladas
- [ ] Todas as credenciais validadas (SEM placeholders)
- [ ] Todas as variáveis validadas (SEM placeholders)
- [ ] Nomenclaturas seguem padrão
- [ ] Duplicidades removidas
- [ ] Obsoletos arquivados
- [ ] Arquivos válidos
- [ ] Scripts válidos
- [ ] Conectividade validada
- [ ] Nenhum placeholder encontrado

**SE QUALQUER ITEM FALHAR → PARAR execução**

---

**Última atualização**: 2025-11-17
