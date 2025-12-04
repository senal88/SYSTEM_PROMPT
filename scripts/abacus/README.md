# Scripts Abacus AI

Este diretório contém scripts para configuração, uso e automação do Abacus AI.

## Estrutura

```
abacus/
├── README.md                    # Este arquivo
├── setup-abacus-ai.sh           # Script de setup completo
├── load-abacus-keys.sh          # Carregar credenciais do 1Password
├── test-abacus-api.sh           # Testar conexão com API
├── monitor-credits.sh           # Monitorar créditos disponíveis
└── examples/
    ├── example-chatllm.sh       # Exemplos de uso do ChatLLM
    └── example-deep-agent.sh    # Exemplos de uso do Deep Agent
```

## Scripts Principais

### setup-abacus-ai.sh

Script completo de configuração do Abacus AI:

- Verifica pré-requisitos (1Password CLI, jq)
- Valida/cria credenciais no 1Password
- Configura variáveis de ambiente no `.zshrc`
- Cria scripts auxiliares

**Uso:**
```bash
cd ~/Dotfiles/scripts/abacus
./setup-abacus-ai.sh
```

### load-abacus-keys.sh

Carrega credenciais do Abacus AI do 1Password para variáveis de ambiente.

**Uso:**
```bash
source ~/Dotfiles/scripts/abacus/load-abacus-keys.sh
```

### test-abacus-api.sh

Testa a conexão com a API do Abacus AI.

**Uso:**
```bash
~/Dotfiles/scripts/abacus/test-abacus-api.sh
```

### monitor-credits.sh

Monitora créditos disponíveis do Abacus AI.

**Uso:**
```bash
# Verificar créditos (threshold padrão: 100000)
~/Dotfiles/scripts/abacus/monitor-credits.sh

# Com threshold customizado
~/Dotfiles/scripts/abacus/monitor-credits.sh 50000
```

## Exemplos

### example-chatllm.sh

Demonstra uso básico do ChatLLM AI Super Assistant:

- Tradução
- Geração de código
- Análise de código
- Roteamento automático

**Uso:**
```bash
~/Dotfiles/scripts/abacus/examples/example-chatllm.sh
```

### example-deep-agent.sh

Demonstra uso do Deep Agent:

- Pesquisa profunda
- Geração de imagens
- Criação de apresentações

**Uso:**
```bash
~/Dotfiles/scripts/abacus/examples/example-deep-agent.sh
```

## Requisitos

- 1Password CLI (`op`) instalado e autenticado
- `jq` instalado (para parsing JSON)
- Credenciais do Abacus AI no 1Password:
  - `Abacus-AI-API-Key` (vault: `1p_macos`)
  - `Abacus-AI-Account` (vault: `1p_macos`)

## Documentação Completa

- **Setup Completo**: `~/Dotfiles/system_prompts/global/docs/ABACUS_SETUP_v1.0.0_20251202.md`
- **ChatLLM Guide**: `~/Dotfiles/system_prompts/global/docs/ABACUS_CHATLLM_GUIDE_v1.0.0_20251202.md`
- **Deep Agent Guide**: `~/Dotfiles/system_prompts/global/docs/ABACUS_DEEP_AGENT_GUIDE_v1.0.0_20251202.md`

## Troubleshooting

### Erro: "1Password não autenticado"

```bash
op signin --account my.1password.com
```

### Erro: "ABACUS_API_KEY não definida"

```bash
source ~/Dotfiles/scripts/abacus/load-abacus-keys.sh
```

### Erro: "jq não instalado"

```bash
brew install jq
```

---

**Última atualização:** 2025-12-02
**Versão:** 1.0.0











