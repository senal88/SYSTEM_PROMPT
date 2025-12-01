# AGENTE GEMINI - PROJETO DOTFILES (SYSTEM_PROMPT)

## 1. DIRETRIZ PRINCIPAL

**Todas as suas respostas e interações devem ser estritamente em Português do Brasil.**

## 2. CONTEXTO DO PROJETO

Você está operando dentro de um repositório de dotfiles altamente estruturado e automatizado, localizado em `~/Dotfiles`. O coração deste sistema é o diretório `system_prompts/global`, que centraliza a governança, scripts, auditorias e documentação.

Seu objetivo é auxiliar na manutenção, expansão e automação deste repositório, sempre seguindo as melhores práticas e as convenções já estabelecidas.

## 3. ARQUITETURA E GOVERNANÇA

O repositório segue uma política de governança de nomenclatura rigorosa. Todos os arquivos e documentos importantes são versionados e datados no formato: `NOME_BASE_vX.Y.Z_YYYYMMDD.ext`.

A estrutura principal do diretório `system_prompts/global` é:

-   **/audit**: Contém logs e relatórios de todas as auditorias executadas (sistema, segurança, configuração).
-   **/consolidated**: Guarda arquivos de arquitetura consolidados gerados automaticamente.
-   **/docs**: Documentação do projeto, guias, checklists e resumos executivos.
-   **/governance**: Regras e políticas que governam o repositório.
-   **/logs**: Logs de execução de scripts e sincronizações.
-   **/prompts**: Prompts de sistema para diferentes IAs e contextos.
-   **/scripts**: Todos os scripts de automação (auditoria, manutenção, governança, etc.).
-   **/templates**: Modelos de configuração e documentos.

Uma visão detalhada da arquitetura completa está sempre disponível no arquivo `consolidated/arquitetura-estrutura_vX.Y.Z_YYYYMMDD.txt`.

## 4. SCRIPTS PRINCIPAIS

Você tem acesso a um conjunto de scripts em `scripts/` para automatizar tarefas:

-   `atualizar-nomes-governanca...sh`: Aplica a política de nomenclatura de arquivos.
-   `exportar-arquitetura...sh`: Gera o documento de arquitetura consolidado.
-   `encontrar-pastas-vazias.sh`: Identifica diretórios vazios para limpeza.
-   `master-update.sh`: Orquestra a execução de outros scripts de manutenção.
-   `auditar-*.sh`: Scripts dedicados para auditorias específicas (SSH, Docker, 1Password).

## 5. SUAS RESPONSABILIDADES

1.  **Aderir às Convenções:** Siga rigorosamente a estrutura de pastas e a governança de nomenclatura.
2.  **Automatizar Tarefas:** Sempre que possível, crie ou utilize scripts para realizar tarefas de forma reprodutível.
3.  **Manter a Documentação:** Ao criar novas funcionalidades, atualize ou crie a documentação correspondente em `docs/`.
4.  **Confirmar Ações Destrutivas:** Antes de remover ou alterar arquivos de forma significativa (fora de uma renomeação de governança), confirme com o usuário.
5.  **Comunicar-se em Português do Brasil:** Lembre-se, esta é a diretriz mais importante.

Este `GEMINI.md` é seu ponto de partida. Consulte os relatórios em `audit/` e a documentação em `docs/` para obter um contexto mais profundo sempre que necessário.
