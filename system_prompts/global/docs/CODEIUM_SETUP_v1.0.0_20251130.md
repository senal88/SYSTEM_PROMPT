# Guia de Setup – Codeium

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

O Codeium serve como um assistente de código secundário neste ecossistema, atuando principalmente como uma alternativa ou complemento ao GitHub Copilot. Sua principal vantagem é a velocidade e, em muitos casos, um plano gratuito generoso que o torna uma excelente opção de "fallback" ou para ambientes onde uma licença do Copilot não está disponível.

O foco do Codeium é o autocompletar de código, similar ao Copilot. A estratégia de integração visa garantir que ele não entre em conflito com os outros assistentes de código mais proeminentes.

---

## 2. Pré-requisitos

1.  **Conta Codeium:** Uma conta gratuita ou paga no site do Codeium.
2.  **IDE Suportada:** VS Code é a principal IDE onde o Codeium será utilizado neste ecossistema. Embora possa haver extensões para outros editores, a configuração padrão foca no VS Code.

---

## 3. Integração com VS Code

A integração é feita através da extensão oficial no Marketplace.

1.  **Instalar a Extensão:**
    - No Marketplace de Extensões do VS Code, procure por `Codeium`.
    - Instale a extensão oficial.

2.  **Autenticação:**
    - Após a instalação, a extensão guiará você por um processo de login. Será necessário autenticar sua conta Codeium, geralmente via navegador.
    - Um ícone na barra de status do VS Code indicará quando o Codeium estiver ativo e autenticado.

---

## 4. Estratégia de Convivência e Gerenciamento de Conflitos

Executar múltiplos assistentes de autocomplete (como Copilot e Codeium) simultaneamente pode levar a conflitos na interface, com múltiplas sugestões sobrepondo-se e causando uma experiência de usuário ruim.

A estratégia neste repositório é **habilitar apenas um assistente de autocomplete por vez**.

### 4.1. Habilitando/Desabilitando Extensões por Workspace

O VS Code permite habilitar ou desabilitar extensões para um "Workspace" (área de trabalho) específico. Esta é a maneira recomendada de alternar entre Copilot e Codeium.

1.  **Abra a Visualização de Extensões:**
    - Clique no ícone de Extensões na barra lateral do VS Code.

2.  **Gerencie a Extensão:**
    - Encontre a extensão `GitHub Copilot` na lista.
    - Clique na engrenagem e selecione "Disable (Workspace)".
    - Faça o mesmo para a extensão `Codeium`, desabilitando a que você não deseja usar no momento.

-   **Recomendação:** Por padrão, deixe o **GitHub Copilot habilitado** e o **Codeium desabilitado** no Workspace principal, pois o Copilot é considerado a ferramenta primária de autocomplete. Ative o Codeium apenas quando desejar compará-lo com o Copilot ou se o Copilot estiver temporariamente indisponível.

### 4.2. Comandos para Alternância Rápida

Para facilitar a alternância, você pode usar a paleta de comandos do VS Code (`Cmd+Shift+P`):

-   `Extensions: Enable (Workspace)`: Permite habilitar rapidamente uma extensão para a área de trabalho atual.
-   `Extensions: Disable (Workspace)`: Permite desabilitar.

---

## 5. Casos de Uso Preferenciais

-   **Alternativa ao Copilot:** Se o Copilot estiver lento ou offline, desabilite-o e habilite o Codeium para manter a produtividade do autocomplete.
-   **Segunda Opinião:** Às vezes, o Copilot pode não dar a sugestão que você espera. Você pode desabilitá-lo temporariamente, habilitar o Codeium e tentar digitar o mesmo trecho de código para ver se ele oferece uma alternativa melhor.
-   **Ambientes sem Licença:** Em projetos ou ambientes onde uma licença do Copilot não está disponível, o Codeium (com seu plano gratuito) é a escolha padrão para autocomplete.

Em resumo, o Codeium é mantido como um assistente de "standby", pronto para ser ativado quando necessário, mas desabilitado por padrão para evitar conflitos com a ferramenta primária, o GitHub Copilot.
