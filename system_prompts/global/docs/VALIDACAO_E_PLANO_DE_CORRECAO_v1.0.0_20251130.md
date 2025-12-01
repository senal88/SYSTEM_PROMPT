# ETAPA 3: Relatório de Validação e Plano de Correção

- **Versão:** 1.0.0
- **Data:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Relatório de Validação Estruturada

A seguir, a validação do estado final do repositório após a execução das Etapas 1 e 2.

### 1.1. Cobertura de Ferramentas e IDEs

| Status    | Verificação                                                               |
| :-------- | :------------------------------------------------------------------------ |
| ✅ **OK** | Todas as ferramentas listadas no ecossistema foram mencionadas no documento `SYSTEM_PROMPT_UNIVERSAL_v1.0.0_20251130.md`. |
| ✅ **OK** | Todos os 11 guias de setup (`CLAUDE_SETUP`, `GEMINI_SETUP`, etc.) foram criados com sucesso no diretório `docs/`. |
| ✅ **OK** | O documento mestre `SETUP_COMPLETO_IA_E_IDES_v1.0.0_20251130.md` foi criado com sucesso em `docs/`.      |

**Conclusão:** A cobertura de documentação para o ecossistema de ferramentas está **completa**.

### 1.2. Governança de Nomenclatura e Cabeçalhos

| Status          | Verificação                                                                                                 |
| :-------------- | :---------------------------------------------------------------------------------------------------------- |
| ✅ **OK**       | A grande maioria dos arquivos nos diretórios governados (`docs`, `scripts`, `audit`, etc.) foi renomeada com sucesso para incluir versão e data. |
| ✅ **OK**       | Os novos arquivos gerados (`docs/*_SETUP_...md`, `SYSTEM_PROMPT_UNIVERSAL...md`) já foram criados seguindo o padrão de nomenclatura e contendo os cabeçalhos internos corretos. |
| ⚠️ **Atenção** | Foi identificada uma não conformidade residual. O script de renomeação não cobriu arquivos que estão diretamente na raiz de uma pasta de auditoria (ex: `audit/<run_id>/relatorio.md`). |

---

## 2. Plano de Correção Automática

Com base na validação acima, a única ação de correção necessária é ajustar o script de governança para incluir os arquivos que não foram renomeados.

| ARQUIVO_ATUAL                                                                 | ARQUIVO_DESEJADO                                                                                        | AÇÃO              | PRIORIDADE |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------- | :--------- |
| `audit/.../RELATORIO_FINAL_REVISADO.md`                                       | `audit/.../RELATORIO_FINAL_REVISADO_v1.0.0_20251130.md`                                                  | Renomear          | Média      |
| `scripts/atualizar-nomes-governanca...sh`                                     | (o mesmo)                                                                                               | Atualizar Lógica  | Alta       |
| `scripts/master-update.sh`                                                    | (o mesmo)                                                                                               | Atualizar Lógica  | Média      |

**Descrição dos Scripts de Correção:**

Para implementar estas correções e garantir a validação contínua, os seguintes scripts serão gerados:

1.  **`scripts/shared/atualizar_nomes_governanca.sh`**: Uma versão **refatorada** e mais robusta do script original. Ele será ajustado para incluir os padrões de caminho que faltaram e será mais flexível.
2.  **`scripts/shared/validar_estrutura_system_prompt.sh`**: Um **novo** script de validação que verificará se todos os arquivos seguem as convenções, se os diretórios esperados existem e se não há mais conflitos de merge, gerando um relatório de conformidade.
3.  **`scripts/macos/aplicar_setup_ia_macos.sh`**: Um **novo** script orquestrador para o ambiente macOS, que guiará o usuário na configuração inicial (ex: chamar outros scripts, testar conexões, etc.).
4.  **`scripts/ubuntu/aplicar_setup_ia_ubuntu.sh`**: Um **novo** script similar ao de macOS, mas adaptado para o ambiente de servidor Ubuntu.
