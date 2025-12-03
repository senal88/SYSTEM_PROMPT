# Troubleshooting: Erro "zsh terminated with exit code 1"

**Versão:** 1.0.0
**Data:** 2025-12-02

---

## 🔴 Problema

```
O processo de terminal "/bin/zsh '-l'" foi terminado com o código de saída: 1.
```

---

## 🔍 Causa Comum

O zsh está sendo encerrado durante o carregamento de login shell (`-l`). Isso geralmente acontece quando:

1. Um script com `set -e` ou `set -euo pipefail` é **sourced** (não executado)
2. Algum comando dentro desse script retorna exit code diferente de 0
3. O `set -e` força o shell pai (zsh) a terminar

---

## ✅ Soluções

### Solução 1: Verificar Scripts Sourced no .zshrc

```bash
# Listar todas as linhas de source no .zshrc
grep -n "source\|^\." ~/.zshrc
```

**Scripts problemáticos comuns:**

- ❌ Scripts com `set -euo pipefail` que são sourced
- ❌ Scripts que fazem `exit 1` em vez de `return 1`
- ❌ Scripts que não validam comandos antes de executar

### Solução 2: Verificar load_ai_keys.sh

O script `~/Dotfiles/scripts/load_ai_keys.sh` já foi corrigido (v1.0.1):

```bash
# ✅ Versão correta (v1.0.1)
# Não usa set -e quando sourced
# Usa 'return 0' em vez de 'exit 0'

# Verificar versão instalada:
grep "VERSÃO" ~/Dotfiles/scripts/load_ai_keys.sh
# Deve mostrar: # VERSÃO: 1.0.1
```

Se a versão for **1.0.0**, atualize:

```bash
cp ~/Dotfiles/system_prompts/scripts/load_ai_keys.sh ~/Dotfiles/scripts/
```

### Solução 3: Proteção em Scripts de Setup

Scripts de setup (como `setup-segundo-cerebro.sh`) agora detectam se estão sendo sourced:

```bash
# ✅ Proteção adicionada (v1.0.1)
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "❌ ERRO: Este script deve ser executado, não sourced!"
    return 1 2>/dev/null || exit 1
fi
```

**Forma correta de usar:**

```bash
# ✅ Correto (executar)
bash ~/Dotfiles/system_prompts/segundo-cerebro-ia/scripts/setup-segundo-cerebro.sh

# ❌ Incorreto (source)
source ~/Dotfiles/system_prompts/segundo-cerebro-ia/scripts/setup-segundo-cerebro.sh
```

### Solução 4: Limpar Cache do Zsh

```bash
# Remover arquivos de cache compilados
rm -f ~/.zcompdump*
rm -f ~/.zsh_history.lock

# Recompilar .zshrc
zsh -c 'source ~/.zshrc'
```

### Solução 5: Modo de Debug

Ative debug temporário no .zshrc:

```bash
# Adicionar no INÍCIO do ~/.zshrc
set -x  # Mostra cada comando executado

# Depois de identificar o problema, remova ou comente:
# set -x
```

Execute um novo terminal e veja onde o erro ocorre.

---

## 🛡️ Prevenção

### Checklist de Boas Práticas

```bash
✅ Scripts que são SOURCED:
  - Não usar 'set -e' ou 'set -euo pipefail'
  - Usar 'return 0/1' em vez de 'exit 0/1'
  - Validar comandos com || echo "" ou || true
  - Exemplo: load_ai_keys.sh

✅ Scripts que são EXECUTADOS:
  - Podem usar 'set -euo pipefail'
  - Usar 'exit 0/1' normalmente
  - Adicionar proteção anti-source
  - Exemplo: setup-segundo-cerebro.sh
```

### Template de Script Sourced

```bash
#!/usr/bin/env bash
# Script: my-sourced-script.sh
# IMPORTANTE: Este script é para ser SOURCED, não executado

# ❌ NÃO usar set -e
# set -euo pipefail

# ✅ Validar comandos com fallback
SOME_VAR=$(some_command 2>/dev/null || echo "")

# ✅ Usar return em vez de exit
if [ -z "$SOME_VAR" ]; then
    echo "Aviso: comando falhou"
    return 0  # Não retornar 1 se não for crítico
fi

# ✅ Sempre retornar 0 ao final
return 0 2>/dev/null || true
```

### Template de Script Executável

```bash
#!/usr/bin/env bash
# Script: my-executable-script.sh
# IMPORTANTE: Este script deve ser EXECUTADO, não sourced

# ✅ Proteção anti-source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "❌ ERRO: Este script deve ser executado!"
    return 1 2>/dev/null || exit 1
fi

# ✅ Pode usar set -e
set -euo pipefail

# ✅ Usar exit normalmente
if [ $? -ne 0 ]; then
    exit 1
fi

exit 0
```

---

## 🧪 Testes

### Testar Script Sourced

```bash
# Deve funcionar sem erros
source ~/Dotfiles/scripts/load_ai_keys.sh
echo $?  # Deve retornar 0
```

### Testar Script Executável

```bash
# Deve funcionar
bash ~/Dotfiles/system_prompts/segundo-cerebro-ia/scripts/setup-segundo-cerebro.sh

# Deve dar erro com mensagem clara
source ~/Dotfiles/system_prompts/segundo-cerebro-ia/scripts/setup-segundo-cerebro.sh
# Resultado esperado: "❌ ERRO: Este script deve ser executado!"
```

---

## 📊 Diagnóstico Rápido

Execute este comando para verificar todos os scripts no sistema:

```bash
# Encontrar scripts com set -e que podem ser sourced
find ~/Dotfiles -name "*.sh" -type f -exec grep -l "set -e" {} \; | \
while read script; do
    if grep -q "source.*$(basename $script)" ~/.zshrc 2>/dev/null; then
        echo "⚠️  RISCO: $script tem 'set -e' e pode ser sourced"
    fi
done
```

---

## 🆘 Solução de Emergência

Se o terminal não abre de jeito nenhum:

```bash
# 1. Abrir VS Code (ou outro editor)
code ~/.zshrc

# 2. Comentar TODAS as linhas de source temporariamente
# Adicionar '#' no início de cada linha 'source ...'

# 3. Salvar e abrir novo terminal

# 4. Descomentar uma linha de cada vez para identificar o problema
```

---

## ✅ Verificação Final

Após aplicar correções:

```bash
# 1. Abrir novo terminal
# 2. Verificar se não há erros
echo "Terminal funcionando: $?"  # Deve mostrar 0

# 3. Verificar variáveis carregadas
env | grep -E "ANTHROPIC|OPENAI|GEMINI|PERPLEXITY"

# 4. Testar comandos básicos
which op
op --version
```

---

## 📚 Arquivos Corrigidos

| Arquivo | Versão | Status | Ação |
|---------|--------|--------|------|
| `scripts/load_ai_keys.sh` | v1.0.1 | ✅ | Sourced seguro |
| `segundo-cerebro-ia/scripts/setup-segundo-cerebro.sh` | v1.0.1 | ✅ | Anti-source |
| `scripts/update_n8n_vps.sh` | v1.0.0 | ✅ | Executável |

---

**Última Atualização:** 2025-12-02
**Autor:** Luiz Sena
