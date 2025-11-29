# 📋 INCORPORAÇÃO DE PROMPTS REVISADOS

**Versão:** 2.0.0
**Data:** 2025-11-28
**Status:** Completo
**Fonte:** `/Users/luiz.sena88/aprimorar_prompts.md`

---

## 🎯 OBJETIVO

Revisar prompts do documento `aprimorar_prompts.md` e incorporar apenas aqueles que:
1. Fazem parte do contexto do sistema
2. Ainda não existem no sistema atual

---

## ✅ PROMPTS INCORPORADOS

### 1. PROMPT_MCP_SERVERS

**Arquivo:** `prompts_temp/stage_00_coleta/PROMPT_MCP_SERVERS_20251128_083308.md`

**Descrição:** Guia completo para configuração de MCP Servers no Cursor, incluindo:
- Stack MCP recomendada (Filesystem, GitHub, Hugging Face)
- Dependências mínimas no macOS Silicon
- Integração com ChatGPT Plus 5.1
- Repositórios GitHub prontos para uso

**Relevância:** ✅ Alto - Específico para integração Cursor + MCP + GitHub + Hugging Face

**Status:** Incorporado e adaptado para todos os engines

---

### 2. PROMPT_SETUP_MACOS_WINDOWS_EXPERIENCE

**Arquivo:** `prompts_temp/stage_00_coleta/PROMPT_SETUP_MACOS_WINDOWS_EXPERIENCE_20251128_083308.md`

**Descrição:** Guia para setup macOS familiar ao Windows sem mascarar o macOS:
- Equivalências Windows → macOS
- Setup básico (navegação, produtividade, terminal)
- Raciocínio mental Windows → macOS
- Caminho de aprendizado progressivo

**Relevância:** ✅ Médio - Útil para usuários vindos do Windows, mas específico demais para ser global

**Status:** Incorporado em `prompts_temp/` para possível uso futuro

---

### 3. PROMPT_MODO_ADAPTATIVO

**Arquivo:** `prompts_temp/stage_00_coleta/PROMPT_MODO_ADAPTATIVO_20251128_083308.md`

**Descrição:** Seção de modo operacional adaptativo permanente:
- Princípios de adaptação automática
- Regras de evolução incremental
- Integração com ecossistema existente
- Provisionamento inteligente

**Relevância:** ✅ Alto - Complementa prompts existentes com filosofia adaptativa

**Status:** Incorporado e pode ser integrado aos prompts principais

---

## ❌ PROMPTS NÃO INCORPORADOS

### Motivos de Exclusão

1. **SYSTEM PROMPT UNIFICADO V3.0** (linhas 565-690)
   - **Motivo:** Versão anterior/obsoleta do `CURSOR_2.0_SYSTEM_PROMPT_FINAL.md` atual
   - **Status:** Já existe versão mais atual e completa

2. **EVOLUÇÃO FINAL DO SYSTEM PROMPT V3** (linhas 1016-1110)
   - **Motivo:** Conteúdo já incorporado no `CURSOR_2.0_SYSTEM_PROMPT_FINAL.md`
   - **Status:** Redundante com versão atual

3. **Configuração de Repositório GitHub** (linhas 1118-1191)
   - **Motivo:** Não é um prompt, é configuração de repositório
   - **Status:** Informação útil mas não é system prompt

4. **Scripts de Auditoria** (várias seções)
   - **Motivo:** Scripts já existem e estão mais atualizados
   - **Status:** Redundante

---

## 📊 ESTATÍSTICAS

- **Prompts Analisados:** Múltiplos (documento de 3032 linhas)
- **Prompts Incorporados:** 3
- **Prompts Rejeitados:** Vários (redundantes ou não relevantes)
- **Engines Criados:** 18 (3 prompts × 6 engines)
- **Status:** ✅ Completo

---

## 🔄 PRÓXIMOS PASSOS

### Para Prompts Incorporados

1. **Revisar em stage_01_interpretacao**
   - Validar conteúdo extraído
   - Ajustar se necessário

2. **Estruturar em stage_02_estrutura**
   - Aplicar formatação padronizada
   - Adicionar metadados completos

3. **Refinar em stage_03_refinamento**
   - Validar precisão técnica
   - Testar em múltiplos contextos

4. **Pré-release em stage_04_pre_release**
   - Avaliação final
   - Decisão sobre promoção para `global/`

### Para PROMPT_MODO_ADAPTATIVO

- **Considerar integração** aos prompts principais existentes
- **Adicionar seção** ao `CURSOR_2.0_SYSTEM_PROMPT_FINAL.md` se aprovado

---

## 📝 NOTAS

- Todos os prompts incorporados estão em `prompts_temp/stage_00_coleta/`
- Adaptações para engines foram geradas automaticamente
- Validação completa realizada sem erros
- Script de revisão criado: `scripts/revisar-e-incorporar-prompts.sh`

---

**Versão:** 2.0.0
**Última Atualização:** 2025-11-28
**Status:** Completo

