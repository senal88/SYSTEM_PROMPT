# Resumo de Otimização de Memória - 2025-10-30

## 🔍 Problema Identificado

A execução de scripts de sincronização de `.cursorrules` e análise de projetos esgotou a RAM do sistema após processar **935 projetos** de uma vez, causando:

- Múltiplos processos `find` rodando simultaneamente
- Processamento de diretórios grandes como `node_modules`, `venv`, `.git`
- Logs grandes gerados (202KB + 63KB)
- Possíveis processos órfãos de `git init` e outras operações

## 📊 Análise dos Logs

### Logs Gerados
- `projetos_sync_cursorrules_20251030_203411.log`: **2359 linhas, 202KB**
- `projetos_analysis_20251030_204426.log`: **1365 linhas, 63KB**

### Estatísticas
- **935 projetos processados** em uma única execução
- **966 inicializações de `.git`** detectadas
- Processamento incluiu diretórios `node_modules` (problema crítico)
- Sem processamento em lotes

## ✅ Soluções Implementadas

### 1. Script de Diagnóstico de Memória
**Arquivo**: `scripts/maintenance/diagnose_memory.sh`

**Funcionalidades**:
- Verifica uso total de RAM
- Lista top 20 processos por consumo de memória
- Identifica processos `find`, `fd`, `git`, `python`, `node` ativos
- Verifica status de Docker/Colima
- Analisa tamanho dos logs recentes
- Detecta processos zombie

**Uso**:
```bash
bash scripts/maintenance/diagnose_memory.sh
```

### 2. Script de Limpeza de Processos Órfãos
**Arquivo**: `scripts/maintenance/cleanup_orphan_processes.sh`

**Funcionalidades**:
- Identifica e finaliza processos `find` órfãos (rodando há mais de 5 minutos)
- Limpa processos `git` relacionados a `git init`/`git status`
- Remove processos `fd` órfãos
- Verifica processos Python/Node de automação
- Opcional: para containers Docker e Colima se não estiverem em uso

**Uso**:
```bash
bash scripts/maintenance/cleanup_orphan_processes.sh
```

**Nota**: O script pede confirmação antes de finalizar processos.

### 3. Script Otimizado de Sincronização
**Arquivo**: `scripts/projetos/sync_cursorrules_optimized.sh`

**Melhorias Implementadas**:

#### Processamento em Lotes
- Processa **50 projetos por vez** (configurável via `BATCH_SIZE`)
- Pausa de 2 segundos entre lotes para liberar memória
- Monitora uso de memória entre lotes

#### Exclusões Inteligentes
- **Ignora completamente**:
  - `node_modules/`
  - `.git/`
  - `venv/`, `.venv/`
  - `__pycache__/`
  - `.next/`
  - `dist/`, `build/`, `target/`
- Verifica se o caminho contém esses diretórios antes de processar

#### Validação de Projetos
- Função `is_valid_project()` melhorada
- Ignora diretórios conhecidos como não-projetos
- Valida indicadores de projeto antes de processar

#### Configurações
```bash
BATCH_SIZE=50    # Projetos por lote (padrão: 50)
MAX_DEPTH=3      # Profundidade máxima (padrão: 3)
```

**Uso**:
```bash
# Com configurações padrão
bash scripts/projetos/sync_cursorrules_optimized.sh

# Com lote menor (mais conservador)
BATCH_SIZE=25 bash scripts/projetos/sync_cursorrules_optimized.sh

# Com profundidade reduzida
MAX_DEPTH=2 BATCH_SIZE=30 bash scripts/projetos/sync_cursorrules_optimized.sh
```

### 4. Script de Monitoramento de Memória
**Arquivo**: `scripts/maintenance/monitor_memory.sh`

**Funcionalidades**:
- Monitora uso de memória em tempo real
- Acompanha processo específico por PID
- Gera log CSV com métricas de memória
- Intervalo configurável (padrão: 5 segundos)

**Uso**:
```bash
# Monitorar processo específico
bash scripts/maintenance/monitor_memory.sh [PID]

# Em segundo plano enquanto executa outro script
bash scripts/projetos/sync_cursorrules_optimized.sh &
SYNC_PID=$!
bash scripts/maintenance/monitor_memory.sh $SYNC_PID
```

## 📋 Recomendações de Uso

### Antes de Executar Scripts Pesados

1. **Verificar memória disponível**:
   ```bash
   bash scripts/maintenance/diagnose_memory.sh
   ```

2. **Limpar processos órfãos**:
   ```bash
   bash scripts/maintenance/cleanup_orphan_processes.sh
   ```

3. **Parar Docker/Colima se não estiver em uso**:
   ```bash
   docker stop $(docker ps -q)  # Se houver containers
   colima stop                   # Se estiver rodando
   ```

### Durante a Execução

1. **Usar versão otimizada**:
   ```bash
   bash scripts/projetos/sync_cursorrules_optimized.sh
   ```

2. **Monitorar memória em paralelo**:
   ```bash
   bash scripts/projetos/sync_cursorrules_optimized.sh &
   SYNC_PID=$!
   bash scripts/maintenance/monitor_memory.sh $SYNC_PID
   ```

3. **Executar em lotes menores se necessário**:
   ```bash
   BATCH_SIZE=25 bash scripts/projetos/sync_cursorrules_optimized.sh
   ```

### Após a Execução

1. **Verificar processos órfãos**:
   ```bash
   bash scripts/maintenance/cleanup_orphan_processes.sh
   ```

2. **Revisar logs de memória**:
   ```bash
   cat exports/memory_monitor_*.log
   ```

3. **Limpar logs antigos se necessário**:
   ```bash
   # Manter apenas últimos 5 logs
   ls -t exports/*.log | tail -n +6 | xargs rm -f
   ```

## 🎯 Comparação: Versão Original vs Otimizada

| Aspecto | Original | Otimizada |
|---------|----------|-----------|
| **Processamento** | Todos de uma vez | Lotes de 50 |
| **Exclusões** | Apenas básicas | Completas (node_modules, venv, etc) |
| **Controle de memória** | Nenhum | Pausas e monitoramento |
| **Profundidade** | 3 níveis | 3 níveis (configurável) |
| **Validação** | Básica | Melhorada |
| **Logs** | Apenas execução | Execução + diagnóstico |

## 📝 Próximos Passos Recomendados

1. ✅ **Imediato**: Executar diagnóstico de memória atual
2. ✅ **Imediato**: Limpar processos órfãos se houver
3. 🔄 **Teste**: Executar versão otimizada com `BATCH_SIZE=25` para teste
4. 📊 **Monitorar**: Acompanhar uso de memória durante execução
5. 🧹 **Limpar**: Remover logs antigos após validação
6. 📚 **Documentar**: Adicionar ao runbook de operações

## ⚠️ Avisos Importantes

1. **Não execute a versão original** (`sync_cursorrules.sh`) em projetos com muitos `node_modules` sem antes limpar processos órfãos.

2. **Monitore o uso de memória** durante execuções grandes, especialmente em máquinas com menos RAM.

3. **Ajuste `BATCH_SIZE`** conforme sua RAM disponível:
   - 8GB RAM: `BATCH_SIZE=25`
   - 16GB RAM: `BATCH_SIZE=50`
   - 24GB+ RAM: `BATCH_SIZE=75-100`

4. **Limpe logs antigos** periodicamente para liberar espaço em disco.

---

**Última atualização**: 2025-10-30  
**Versão**: 1.0.0

