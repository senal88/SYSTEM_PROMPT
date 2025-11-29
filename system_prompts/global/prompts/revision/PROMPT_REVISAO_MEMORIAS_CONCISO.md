# PROMPT CONCISO DE REVISÃO DE MEMÓRIAS

**Versão:** 2.0.0
**Uso:** Cole este prompt quando desejar uma revisão completa das informações armazenadas

---

## 📋 SOLICITAÇÃO

Com base nas minhas personalizações, nas memórias atualmente armazenadas e ativas, e nos dados coletados do sistema de auditorias (`~/Dotfiles/system_prompts/global/llms-full.txt` e auditorias em `~/Dotfiles/system_prompts/global/audit/`), você deve:

### 1. RESUMO EXECUTIVO
Apresente um resumo objetivo e estruturado das informações disponíveis sobre mim, incluindo:
- **Perfil Técnico:** Hardware (MacBook Pro M4, 24GB), macOS 26.1, ferramentas instaladas, ambiente de desenvolvimento
- **Ambiente Produção:** VPS Ubuntu, Docker Swarm, Traefik, Coolify, domínio senamfo.com.br
- **Preferências:** Comunicação em português, CLI sobre GUI, respostas completas sem perguntas finais
- **Especializações:** DevOps, Arquitetura IA/LLMs, Gestão Patrimonial, Automação
- **Objetivos:** Projetos Multi Family Office, gestão imobiliária BNI, infraestrutura VPS

### 2. CONTEXTO DA INTERAÇÃO
Informe o contexto atual considerando:
- Interações anteriores relevantes e decisões tomadas
- Última auditoria executada (data e timestamp)
- Estado atual do sistema e arquivos de referência
- Mudanças detectadas desde a última interação

### 3. STATUS DAS MEMÓRIAS
Especifique:
- Se há memórias ativas habilitadas e seu conteúdo essencial
- Versão e data do arquivo `llms-full.txt` consolidado
- Quantidade e datas das auditorias disponíveis
- Status dos scripts de automação e última execução

### 4. ANÁLISE DE QUALIDADE
Identifique e alerte sobre:
- **Lacunas:** Informações ausentes ou áreas não cobertas
- **Inconsistências:** Dados contraditórios ou conflitantes
- **Desatualizações:** Informações com mais de 30 dias ou mudanças não refletidas

### 5. RECOMENDAÇÕES
Apresente recomendações específicas para:
- Executar nova auditoria completa (se necessário)
- Revisar, atualizar ou excluir memórias específicas
- Executar scripts de consolidação (`consolidar-llms-full.sh`)

### 6. AÇÕES DISPONÍVEIS
Liste comandos executáveis prontos para:
- Executar auditoria: `cd ~/Dotfiles/system_prompts/global/scripts && ./master-auditoria-completa.sh`
- Gerar consolidado: `cd ~/Dotfiles/system_prompts/global/scripts && ./consolidar-llms-full.sh`
- Pipeline completo: `cd ~/Dotfiles/system_prompts/global/scripts && ./master-auditoria-completa.sh && ./consolidar-llms-full.sh`

---

## ✅ FORMATO ESPERADO

Organize a resposta em seções numeradas (1-6) conforme acima, de forma estruturada, técnica e completa. Não faça perguntas ao final — apresente opções de ação prontas para execução.

**Referências:**
- Arquivo consolidado: `~/Dotfiles/system_prompts/global/llms-full.txt`
- System prompt completo: `~/Dotfiles/system_prompts/global/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md`
- Auditorias: `~/Dotfiles/system_prompts/global/audit/`
- Arquitetura: `~/Dotfiles/system_prompts/global/ARQUITETURA_COLETAS.md`

---

**Versão:** 2.0.0
**Data:** 2025-11-28

