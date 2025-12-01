# 🗑️ Revisão Completa - Arquivos Obsoletos e Redundantes

**Data:** 2025-12-01
**Versão:** 1.0.0
**Status:** ✅ **AUDITORIA CONCLUÍDA**

---

## 📊 Resumo Executivo

### VPS Ubuntu

**Diretórios Obsoletos Identificados:**

- `~/legacy/` - 84K
- `~/backups/` - 4.0K
- `~/.audit/` - 156K
- `~/infra-vps/legacy/` - 84K

**Arquivos de Backup:**

- `~/.config/op/credentials.backup*` (3 arquivos)
- Scripts de backup em `~/infra-vps/scripts/`

**Total Estimado:** ~328K

### macOS Silicon

**Diretórios Obsoletos Identificados:**

- `~/Dotfiles/infra-vps/legacy/` - 9.2M
- `~/Dotfiles/scripts/backups/` - **18G** ⚠️
- `~/Dotfiles/.backup_*` (múltiplos diretórios de backup)
- `~/Dotfiles/system_prompts/global/prompts_temp/`
- `~/Dotfiles/system_prompts/global/scripts/legacy/`
- `~/Dotfiles/automation_1password/compose/n8n-ai-starter/` - 8.0M
- `~/Dotfiles/cursor/awesome-cursorrules/` - 9.3M
- `~/Dotfiles/cursor/claude-task-master/` - 38M
- `~/Dotfiles/cursor/system-prompts-and-models-of-ai-tools/` - 3.3M
- `~/Dotfiles/gemini/` (Google Cloud SDK completo)
- `~/Dotfiles/codex/`
- `~/Dotfiles/infraestrutura-vps/`

**Arquivos de Backup:**

- Milhares de arquivos `.backup` em `~/.backup_paths_20251106_*/`
- Arquivos marcados como `OBSOLETO`

**Total Estimado:** ~77GB+ (principalmente `scripts/backups/` com 18GB)

---

## 🎯 Recomendações de Limpeza

### Prioridade ALTA (Limpar Imediatamente)

#### VPS Ubuntu:

1. ✅ `~/legacy/` - Verificar conteúdo e remover se não necessário
2. ✅ `~/backups/` - Verificar se backups são necessários
3. ✅ `~/.audit/` - Logs antigos podem ser removidos
4. ✅ `~/infra-vps/legacy/` - Legacy do infra-vps
5. ✅ `~/.config/op/credentials.backup*` - Backups antigos do token (já corrigido)

#### macOS Silicon:

1. ⚠️ **`~/Dotfiles/scripts/backups/` - 18GB** - **CRÍTICO**

   - Revisar conteúdo antes de excluir
   - Fazer backup externo se necessário
   - Remover após confirmação

2. ✅ `~/Dotfiles/.backup_*` (todos os diretórios)

   - Backups de novembro/2025
   - Podem ser removidos após validação

3. ✅ `~/Dotfiles/infra-vps/legacy/` - 9.2M

   - Legacy do infra-vps
   - Remover após validação

4. ✅ Submódulos não versionados:

   - `automation_1password/compose/n8n-ai-starter/` - 8.0M
   - `cursor/awesome-cursorrules/` - 9.3M
   - `cursor/claude-task-master/` - 38M
   - `cursor/system-prompts-and-models-of-ai-tools/` - 3.3M
   - `gemini/` (Google Cloud SDK completo)
   - `codex/`

5. ✅ `~/Dotfiles/infraestrutura-vps/` - Duplicado de `infra-vps`

### Prioridade MÉDIA (Revisar e Limpar)

1. ✅ Arquivos marcados como `OBSOLETO`:

   - `infra-vps/documentacao/OBSOLETO_ARQUITETURA_COMPLETA_VPS_AUDITORIA.md`

2. ✅ Diretórios temporários:

   - `system_prompts/global/prompts_temp/`
   - `system_prompts/global/scripts/legacy/`

3. ✅ Arquivos não versionados no Git:
   - Revisar e adicionar ao `.gitignore` ou versionar

---

## 🛠️ Scripts de Limpeza

### Auditoria

```bash
./system_prompts/global/scripts/auditar-arquivos-obsoletos_v1.0.0_20251201.sh --all
```

### Limpeza (Dry-Run primeiro)

```bash
# Modo dry-run (não remove nada)
./system_prompts/global/scripts/limpar-arquivos-obsoletos_v1.0.0_20251201.sh --all --dry-run

# Executar limpeza real
./system_prompts/global/scripts/limpar-arquivos-obsoletos_v1.0.0_20251201.sh --all
```

---

## 📋 Checklist de Limpeza

### VPS Ubuntu

- [ ] Revisar `~/legacy/` e remover se não necessário
- [ ] Revisar `~/backups/` e remover se não necessário
- [ ] Limpar `~/.audit/` (logs antigos)
- [ ] Remover `~/infra-vps/legacy/`
- [ ] Limpar backups antigos do 1Password (`~/.config/op/credentials.backup*`)

### macOS Silicon

- [ ] **CRÍTICO:** Revisar `~/Dotfiles/scripts/backups/` (18GB)
- [ ] Remover diretórios `.backup_*` após validação
- [ ] Remover `~/Dotfiles/infra-vps/legacy/`
- [ ] Remover submódulos não versionados:
  - [ ] `automation_1password/compose/n8n-ai-starter/`
  - [ ] `cursor/awesome-cursorrules/`
  - [ ] `cursor/claude-task-master/`
  - [ ] `cursor/system-prompts-and-models-of-ai-tools/`
  - [ ] `gemini/`
  - [ ] `codex/`
- [ ] Remover `~/Dotfiles/infraestrutura-vps/` (duplicado)
- [ ] Revisar e remover arquivos `OBSOLETO`
- [ ] Limpar diretórios temporários (`prompts_temp/`, `scripts/legacy/`)

---

## ⚠️ Avisos Importantes

1. **Backup antes de excluir:** O script de limpeza cria backups automáticos, mas é recomendado fazer backup manual de itens críticos.

2. **Revisar conteúdo:** Antes de excluir diretórios grandes (especialmente `scripts/backups/` com 18GB), revisar o conteúdo para garantir que não há dados importantes.

3. **Validação pós-limpeza:** Após a limpeza, validar que tudo continua funcionando corretamente.

4. **Atualizar .gitignore:** Adicionar padrões de arquivos obsoletos ao `.gitignore` para evitar acúmulo futuro.

---

## 📊 Estatísticas

### Espaço Liberado Estimado

**VPS Ubuntu:**

- ~328K (diretórios obsoletos)
- ~12K (arquivos de backup)

**macOS Silicon:**

- ~77GB+ (principalmente `scripts/backups/` com 18GB)
- ~58M (submódulos não versionados)
- ~9.2M (legacy infra-vps)

**Total:** ~77GB+ (principalmente no macOS)

---

## 🚀 Próximos Passos

1. ✅ Executar auditoria completa (CONCLUÍDO)
2. ⏳ Revisar relatório detalhado
3. ⏳ Executar limpeza em modo dry-run
4. ⏳ Validar itens críticos antes de excluir
5. ⏳ Executar limpeza real
6. ⏳ Validar sistema após limpeza
7. ⏳ Atualizar `.gitignore` com padrões de obsoletos
8. ⏳ Criar rotina de limpeza periódica

---

**Última Atualização:** 2025-12-01
**Versão:** 1.0.0
**Status:** ✅ **AUDITORIA CONCLUÍDA - AGUARDANDO APROVAÇÃO PARA LIMPEZA**
