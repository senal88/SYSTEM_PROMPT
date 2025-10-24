# Prompt para Codex: Automação Completa do 1Password no macOS Silicon

## Contexto
Automatização segura e eficiente do 1Password no macOS Silicon (Tahoe/M1+) com foco em uso de Service Accounts, secret references, vaults segregados, integrações CI/CD e injeção dinâmica de secrets para desenvolvimento e produção.

---

## Prompt Estruturado para LLM (e Codex)

**Objetivo:**
Executar todas as fases do framework detalhado abaixo, realizando cada etapa, validando resultados e exportando configurações para scripts automatizados e CI/CD.

### Framework Automatizável (Fases e Objetivos)

#### 1. Identificação
- Checar sistema operacional: `system_profiler SPSoftwareDataType`
- Checar arquitetura: `uname -m` (resultado esperado: arm64)
- Listar ambientes (dev, staging, prod) e pipelines CI/CD envolvidos
- Auditar compliance e fluxos que usarão segredos automatizados
- Identificar equipe, contas, e cofres (vaults) necessários

#### 2. Análise
- Instalar 1Password 8 (>= 8.10.36), CLI última versão
- Habilitar Touch ID/Apple Watch: Settings > Developer > Integrate with CLI
- Mapear permissões e acessos
- Criar cofres (vaults) para cada ambiente/escopo
- Definir padrões de nomenclatura para vaults, itens e campos
- Identificar e importar secrets existentes (.env/config)

#### 3. Desenvolvimento e Implantação
##### 3.1 CLI e Service Account
- Instalar via Homebrew: `brew install --cask 1password/tap/1password-cli`
- Criar Service Account e definir OP_SERVICE_ACCOUNT_TOKEN
- Exportar: `export OP_SERVICE_ACCOUNT_TOKEN='<token>'`
- Validar acesso: `op vault list`

##### 3.2 Estruturação dos Vaults e Itens
- Criar vaults (ex: dev, staging, prod)
- Itens: seguir padrão de campos (ex: password, api_key, secret_key_base)
- Naming: <ambiente>_<app>_<tipo>

##### 3.3 Secret References e Configuração Automática
- Obter references: `op item get <item> --format json`
- Usar sintaxe: `op://vault/item/field`
- Templates: criar .env.template apenas com secret references
- Injetar com: `op inject -i .env.template -o .env` ou `op run --env-file <template> -- <cmd>`

##### 3.4 Integração CI/CD
- Adicionar Service Account token como secret seguro (GitHub/GitLab/Actions etc)
- No workflow, carregar segredos via Action oficial:
```
- name: Load secrets
  uses: 1password/load-secrets-action@v3
  env:
    OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}
```
- Validar limpeza/masking automático

##### 3.5 SDKs/Integração Programática
- (Opcional) Integrar via Go/JS/TS SDK quando necessário
- Sempre injetar secrets via referência, nunca plaintext

#### 4. Governança e Manutenção
- Rotacionar tokens (cada 30-90 dias)
- Auditar logs periodicamente
- Atualizar scripts e CLI sempre com releases estáveis
- Documentar fluxos e runbooks
- Treinar participantes para manipulação de secret references


---

## Convenções e Nomenclatura de Variáveis de Ambiente

| Variável                        | Padrão                      | Sensível | Governança                                                                              |
|---------------------------------|-----------------------------|----------|-----------------------------------------------------------------------------------------|
| OP_SERVICE_ACCOUNT_TOKEN        | Global (MAIÚSCULAS, OP_)    | Crítica  | Rotação a cada 90 dias, nunca em git, só em secrets manager                             |
| OP_CONNECT_HOST                 | Aplicação (MAIÚSCULAS, OP_) | Média    | https obrigatório, ambiente seguro                                                      |
| OP_CONNECT_TOKEN                | Aplicação (MAIÚSCULAS, OP_) | Crítica  | Rotação mensal, apenas em secrets manager                                               |
| OP_ACCOUNT                      | Usuário (MAIÚSCULAS, OP_)   | Baixa    | Definir por sessão ou ~/.zshrc                                                          |
| APP_ENV                         | Aplicação (MAIÚSCULAS)      | Baixa    | Valores padronizados: development, staging, production                                   |
| {APP}_DB_PASSWORD               | Aplicação (prefixo APP_)    | Crítica  | Sempre como reference, nunca plaintext, rotacionar cada 30-60 dias                       |
| {APP}_API_KEY                   | Aplicação (prefixo APP_)    | Crítica  | Apenas reference, nunca plaintext, auditar uso                                           |
| {APP}_{ENV}_SECRET_KEY_BASE     | Framework (prefixo APP_ENV) | Crítica  | Alta entropia, never reuse, rotacionar anual                                             |

**Regras Gerais:**
- SEMPRE Nomear MAIÚSCULAS, separando com underscore
- Prefixo OP_ para variáveis oficiais CLI/Service, APP_ para contexto da aplicação
- Separar secrets por ambiente (vault e variável)
- Templates .env nunca com valores reais, apenas references
- Nunca commitar segredos nem tokens em repositórios
- Governança clara: rotação e revogação programada, logging, revisão de permissões

---

## Exemplos de Template (.env.template)
```env
APP_ENV=production
POSTGRES_PASSWORD=op://production/postgres/password
API_KEY=op://production/stripe/key
SECRET_KEY_BASE=op://$APP_ENV/rails-app/secret_key_base
```

## Execução automatizada (bash/script)
```bash
export OP_SERVICE_ACCOUNT_TOKEN="<token>"
op inject -i .env.template -o .env
# ou
op run --env-file .env.template -- your_app_command.sh
```

---

## Documentação das Variáveis de Ambiente
Veja anexo CSV para consulta estruturada e ingestão por LLMs.

---

## Observações Finais
- Validar sempre os outputs e logging: nunca exibir valores sensíveis
- Rotacionar e revogar tokens em caso de suspeita
- Seguir guidelines oficiais de naming e governança

(Fim do prompt)