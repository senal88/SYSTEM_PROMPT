# 🏛️ GOVERNANÇA IDEs - Sistema Completo

**Versão:** 2.0.0
**Data:** 2025-11-28
**Status:** Ativo

---

## 🎯 OBJETIVO

Implementar governança completa para IDEs (Cursor, VSCode, etc.) com:
- Validações de paths antes de operações
- Prevenção de erros de interpretação
- Padrões claros de estrutura
- Versionamento e rastreabilidade
- Conexão entre todos os sistemas

---

## 📋 REGRAS FUNDAMENTAIS

### 1. Validação de Paths

**ANTES de qualquer operação em paths do HOME:**

1. **Validar existência do diretório**
2. **Validar permissões**
3. **Validar contexto atual vs histórico**
4. **Verificar versão e data de última atualização**

### 2. Estrutura Padrão HOME

```
~/Dotfiles/
├── system_prompts/global/     # System prompts globais
├── infra-vps/                 # Infraestrutura VPS
├── logs/                      # Logs centralizados
├── icloud_control/            # Controle iCloud
└── [outros projetos]/
```

### 3. Versionamento Obrigatório

Todos os arquivos devem ter:
- **Versão:** X.Y.Z (semântica)
- **Data:** YYYY-MM-DD
- **Última Atualização:** YYYY-MM-DD

### 4. Validação de Contexto

Antes de operar, validar:
- Arquivo existe?
- Versão atual?
- Data atualizada?
- Path correto?
- Contexto completo disponível?

---

## 🔍 VALIDAÇÕES IMPLEMENTADAS

### Validação de Paths HOME

```bash
# Validar antes de operar
validate_home_path() {
    local path="$1"

    # Verificar se está dentro de HOME
    if [[ ! "$path" =~ ^${HOME} ]]; then
        return 1
    fi

    # Verificar existência
    if [ ! -e "$path" ]; then
        return 1
    fi

    # Verificar permissões
    if [ ! -r "$path" ]; then
        return 1
    fi

    return 0
}
```

### Validação de Versão

```bash
# Verificar versão do arquivo
check_file_version() {
    local file="$1"
    local expected_version="$2"

    if grep -q "Versão.*${expected_version}" "$file"; then
        return 0
    fi

    return 1
}
```

---

## 📊 MATRIZ DE VALIDAÇÃO

| Validação | Quando Aplicar | Ação se Falhar |
|-----------|----------------|----------------|
| Path existe | Antes de ler/escrever | Criar ou reportar erro |
| Versão atual | Antes de usar | Atualizar ou alertar |
| Data atualizada | Antes de operar | Verificar contexto |
| Permissões | Antes de modificar | Solicitar ou alertar |
| Contexto completo | Antes de decisão | Coletar contexto |

---

## 🎯 REGRAS PARA LLMs

### Antes de Qualquer Operação

1. **SEMPRE validar path existe**
2. **SEMPRE verificar versão do arquivo**
3. **SEMPRE confirmar data de atualização**
4. **SEMPRE verificar contexto completo**
5. **NUNCA assumir estrutura sem validar**

### Formato de Resposta Obrigatório

```
[Validação de Path]
- Path verificado: ✅/❌
- Versão do arquivo: X.Y.Z
- Data de atualização: YYYY-MM-DD

[Contexto Detectado]
- Arquivos relacionados encontrados
- Estrutura atual vs esperada

[Decisão]
- Baseada em validações acima
- Com referências específicas

[Ação Proposta]
- Com validações prévias
- Com rollback se necessário
```

---

**Versão:** 2.0.0
**Última Atualização:** 2025-11-28

