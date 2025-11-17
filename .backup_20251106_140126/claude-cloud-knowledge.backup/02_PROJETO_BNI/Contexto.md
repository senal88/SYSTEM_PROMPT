# Contexto Completo do Projeto - BNI Documentos e Infraestrutura

**Data de Criação:** 2025-11-04
**Horário:** 12:20 UTC / 09:20 BRT
**Última Atualização:** 2025-01-15 10:45 UTC
**Status:** ✅ ATUALIZADO - Projeto organizado e alinhado
**Branch Git:** `main` (confirmada e acessível pelo Claude)

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Diretrizes para LLMs](#diretrizes-para-llms)
3. [Diretrizes para Humanos](#diretrizes-para-humanos)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Configuração Atual](#configuração-atual)
6. [Estado do Deploy](#estado-do-deploy)
7. [Variáveis e Segredos](#variáveis-e-segredos)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

### Projeto Principal

- **Repositório:** `BNI_DOCUMENTOS_BRUTOS`
- **Propósito:** Gestão documental para BNI (Banco Nacional de Imóveis)
- **Localização:** `/Users/luiz.sena88/database/BNI_DOCUMENTOS_BRUTOS`
- **GitHub:** `https://github.com/senal88/gestao-documentos-digitais.git`
- **Branch Principal:** `main` (confirmada - melhor que default/teab)
- **Status Git:** Organizado e alinhado

### Infraestrutura

- **Ambiente Local:** macOS Silicon (`/Users/luiz.sena88/infra/stack-local`)
- **Ambiente Produção:** VPS Ubuntu (`/home/luiz.sena88/infra/stack-prod`)
- **Domínio:** `senamfo.com.br`
- **IP VPS:** `147.79.81.59`

### Stack de Serviços

- **Traefik:** Reverse proxy com SSL Let's Encrypt
- **Dify:** Plataforma LLM (API + Web)
- **N8N:** Automação de workflows
- **Grafana:** Monitoramento e dashboards
- **Nocodb:** Banco de dados NoSQL
- **Portainer:** Gerenciamento Docker
- **PostgreSQL:** Banco de dados principal
- **Redis:** Cache e filas

---

## 🤖 Diretrizes para LLMs

### Regras de Cursor (.cursorrules)

```markdown
# Cursor Rules - BNI Documentos
# Estas regras também funcionam com GitHub Copilot no Codespaces

## Linguagem e Estilo
- Sempre responder em **português**
- Usar português brasileiro
- Código deve ter comentários em português quando necessário

## Python
- Usar Python 3.11+
- Formatação: Black com linha máxima de 100 caracteres
- Imports organizados com isort
- Type hints quando apropriado
- Docstrings em português para funções públicas

## Estrutura de Arquivos
- Seguir a política de governança documental
- Nomes de arquivos sem espaços ou acentos
- Formato: `TIPO_ANO_MES_DESCRITOR.ext`

## Convenções
- Variáveis e funções em snake_case
- Classes em PascalCase
- Constantes em UPPER_SNAKE_CASE
- CSV encoding: UTF-8
- Datas: formato ISO 8601 (YYYY-MM-DD)

## Governança
- Sempre verificar POLITICA_GESTAO_DOCUMENTAL_BNI.md antes de criar arquivos
- Registrar mudanças em LOG_RENOMEACOES.csv quando renomear arquivos
- Manter consistência com TEMPLATE_NOME_ARQUIVO.md
```

### Comportamento Esperado de LLMs

1. **Sempre responder em português brasileiro**
2. **Respeitar estrutura de diretórios** conforme política documental
3. **Verificar políticas** antes de criar/modificar arquivos
4. **Usar snake_case** para variáveis Python
5. **Comentar código** em português quando necessário
6. **Validar formato** de nomes de arquivos (sem espaços/acentos)

### Contexto de Deploy Atual (Temporário)

⚠️ **IMPORTANTE:** Este documento é temporário e reflete o estado durante o deploy inicial.

**Status Atual:**

- Deploy em andamento na VPS Ubuntu
- Certificados SSL Let's Encrypt sendo obtidos
- Proxy Cloudflare desabilitado temporariamente
- 8/9 containers healthy (78% operacional)

**Ações Pendentes:**

- Obter certificados SSL para todos os domínios
- Reativar proxy Cloudflare após certificados
- Configurar Portainer (primeiro acesso)
- Resolver saúde do Portainer

---

## 👥 Diretrizes para Humanos

### Estrutura de Trabalho

1. **Documentação:** Sempre em `00_DOCUMENTACAO_POLITICAS/`
2. **Dados:** Em `00_ANALISES_E_DADOS/`
3. **Templates:** Consultar antes de criar novos arquivos
4. **Logs:** Registrar mudanças em `LOG_RENOMEACOES.csv`

### Política de Nomenclatura

- **Formato:** `TIPO_ANO_MES_DESCRITOR.ext`
- **Exemplo:** `RELATORIO_2025_11_ANALISE_DOCUMENTOS.pdf`
- **Sem espaços:** Usar underscore `_`
- **Sem acentos:** Remover acentuação

### Versionamento

- **Git:** Usar commits descritivos em português
- **Datas:** Sempre formato ISO 8601 (YYYY-MM-DD)
- **Logs:** Registrar todas as mudanças significativas

### Segurança

- **1Password:** Usar para todos os segredos
- **Vaults:** `1p_macos` (local) e `1p_vps` (produção)
- **Service Account Tokens:** Configurados globalmente, não em 1Password
- **Nunca commitar:** `.env`, tokens, senhas, chaves privadas

---

## 📁 Estrutura do Projeto

### BNI_DOCUMENTOS_BRUTOS

```
BNI_DOCUMENTOS_BRUTOS/
├── 00_DOCUMENTACAO_POLITICAS/
│   ├── POLITICA_GESTAO_DOCUMENTAL_BNI.md
│   ├── TEMPLATE_NOME_ARQUIVO.md
│   ├── LOG_RENOMEACOES.csv
│   └── GUIA_*.md (vários guias)
├── 00_ANALISES_E_DADOS/
│   ├── DADOS_VALIDADOS_PARA_DASHBOARD/
│   └── NOCODB_IMPORT/
├── .cursorrules
├── .gitignore
└── [outros diretórios conforme política]
```

### Infraestrutura

```
infra/
├── stack-local/          # macOS Silicon
│   ├── docker-compose.yml
│   └── .env
├── stack-prod/           # VPS Ubuntu
│   ├── docker-compose.yml
│   ├── .env
│   ├── scripts/
│   │   ├── deploy.sh
│   │   ├── inject-env.sh
│   │   └── healthcheck.sh
│   └── docs/
└── README.md
```

### hf_workspace (Hugging Face)

```
hf_workspace/
├── docs/                 # Documentação completa
├── scripts/              # Scripts de automação
├── config/               # Configurações
└── requirements.txt
```

---

## ⚙️ Configuração Atual

### Ambientes

#### macOS Silicon (Local)

- **Localização:** `/Users/luiz.sena88/infra/stack-local`
- **1Password Vault:** `1p_macos`
- **Domínio:** `localhost` (variável `DOMAIN_LOCAL`)
- **Status:** Funcional

#### VPS Ubuntu (Produção)

- **Localização:** `/home/luiz.sena88/infra/stack-prod`
- **1Password Vault:** `1p_vps`
- **Domínio:** `senamfo.com.br` (variável `DOMAIN_PROD`)
- **IP:** `147.79.81.59`
- **Status:** Deploy em andamento

### DNS e Cloudflare

**Domínio:** `senamfo.com.br`

**Registros Principais:**

- `senamfo.com.br` → A → 147.79.81.59
- `manager.senamfo.com.br` → A → 147.79.81.59
- Subdomínios → CNAME → manager.senamfo.com.br

**Status Atual (Temporário):**

- ⚠️ Proxy Cloudflare DESABILITADO (para obter certificados SSL)
- ⚠️ Todos os domínios devem estar com nuvem cinza (DNS only)
- ✅ Após certificados: Reativar proxy (nuvem laranja)

**Registros CAA:**

- `0 issue "letsencrypt.org"` ✅
- `0 issuewild "letsencrypt.org"` ✅
- ⚠️ Remover: `0 issue "mailto:..."` (incorreto)

### Docker Stacks

#### Stack Produção (stack-prod)

**Containers:**

1. **traefik** - Reverse proxy (unhealthy - aguardando certificados)
2. **dify-api** - API Dify (healthy)
3. **dify-web** - Web Dify (healthy)
4. **n8n** - Automação (healthy)
5. **grafana** - Monitoramento (healthy)
6. **nocodb** - Banco NoSQL (healthy)
7. **portainer** - Gerenciamento Docker (unhealthy - primeiro acesso)
8. **postgres** - PostgreSQL (healthy)
9. **redis** - Redis (healthy)

**Status:** 8/9 healthy (78% operacional)

**Networks:**

- `traefik_net` (bridge)

**Volumes:**

- `postgres_data`
- `redis_data`
- `grafana_data`
- `n8n_data`
- `dify_data`
- `nocodb_data`
- `data/letsencrypt` (certificados SSL)
- `data/portainer` (dados Portainer)

---

## 🔐 Variáveis e Segredos

### Gerenciamento de Segredos

**Ferramenta:** 1Password CLI (`op`)

**Vaults:**

- `1p_macos`: Segredos para ambiente local (macOS)
- `1p_vps`: Segredos para ambiente produção (VPS Ubuntu)

**Service Account Tokens:**

- **macOS:** `OP_SERVICE_ACCOUNT_TOKEN` configurado globalmente
- **VPS:** `OP_SERVICE_ACCOUNT_TOKEN` configurado globalmente
- ⚠️ **NUNCA** armazenar em 1Password (dependência circular)

### Variáveis Críticas (Produção)

**Cloudflare:**

- `CF_EMAIL` - Email do Cloudflare
- `CF_API_TOKEN` - Token API Cloudflare (op://1p_vps/Cloudflare API Token/credential)

**SMTP (Gmail):**

- `SMTP_HOST` - smtp.gmail.com
- `SMTP_PORT` - 587
- `SMTP_USER` - Email Gmail
- `SMTP_PASSWORD` - Senha de app Gmail (op://1p_vps/SMTP Gmail Prod/password)

**PostgreSQL:**

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

**Redis:**

- `REDIS_PASSWORD`

**Dify:**

- `CELERY_BROKER_URL` - redis://:password@redis:6379/0

**Traefik:**

- `TRAEFIK_DASHBOARD_AUTH` - Autenticação básica

**Domínio:**

- `DOMAIN_PROD` - senamfo.com.br

### Injeção de Variáveis

**Script:** `infra/stack-prod/scripts/inject-env.sh`

**Processo:**

1. Lê `env.op.template`
2. Resolve referências `op://` via 1Password CLI
3. Gera `.env` com valores reais
4. Docker Compose usa `.env`

**Template:** `infra/stack-prod/env.op.template`

---

## 🚀 Estado do Deploy

### Status Atual (2025-11-04 12:20 UTC)

**Fase:** Deploy em andamento - Aguardando certificados SSL

**Containers:**

- ✅ 8/9 healthy (88% operacional)
- ⚠️ Traefik: unhealthy (aguardando certificados)
- ⚠️ Portainer: unhealthy (requer primeiro acesso)

**Certificados SSL:**

- ⚠️ Em processo de obtenção
- ⚠️ Proxy Cloudflare desabilitado temporariamente
- ⏳ Aguardando Let's Encrypt emitir certificados

**DNS:**

- ✅ Todos apontando para 147.79.81.59
- ✅ /etc/hosts limpo na VPS
- ✅ Propagação completa

**Rate Limit Let's Encrypt:**

- ✅ Expirado (último erro às 10:31 UTC)
- ✅ Aguardando tentativas automáticas do Traefik

### Ações Pendentes

1. **Imediatas:**
   - ✅ Proxy Cloudflare desabilitado
   - ✅ DNS configurado
   - ⏳ Aguardar certificados SSL (5-20 minutos)

2. **Após Certificados:**
   - Reativar proxy Cloudflare (nuvem laranja)
   - Verificar saúde do Traefik
   - Configurar Portainer (primeiro acesso)

3. **Configurações:**
   - Portainer: Acessar e configurar ambiente Docker
   - Nocodb: Primeiro acesso e configuração inicial
   - Dify: Configuração de workspaces

### URLs de Acesso (Após Certificados)

- `https://senamfo.com.br` - Dify Web
- `https://api.senamfo.com.br` - Dify API
- `https://n8n.senamfo.com.br` - N8N
- `https://grafana.senamfo.com.br` - Grafana
- `https://traefik.senamfo.com.br` - Traefik Dashboard
- `https://portainer.senamfo.com.br` - Portainer
- `https://nocodb.senamfo.com.br` - Nocodb

---

## 🔧 Troubleshooting

### Problemas Comuns

#### 1. Certificados SSL Não Obtidos

**Sintomas:**

- Traefik unhealthy
- Logs: "Unable to obtain ACME certificate"
- Logs: "Cannot retrieve the ACME challenge"

**Soluções:**

1. Verificar proxy Cloudflare (deve estar desabilitado)
2. Verificar DNS (deve apontar para 147.79.81.59)
3. Verificar /etc/hosts na VPS (não deve ter entradas senamfo.com.br)
4. Limpar acme.json: `sudo rm -f data/letsencrypt/acme.json`
5. Reiniciar Traefik: `docker compose restart traefik`
6. Aguardar 5-20 minutos

#### 2. Portainer Unhealthy

**Sintomas:**

- Container restartando
- Erro: "database schema mismatch"

**Soluções:**

1. Remover banco antigo: `sudo rm -f data/portainer/portainer.db`
2. Reiniciar: `docker compose up -d portainer`
3. Acessar e configurar primeiro acesso

#### 3. 1Password CLI Não Autenticado

**Sintomas:**

- `op: command not found`
- `no active session found`

**Soluções:**

1. Instalar 1Password CLI
2. Configurar `OP_SERVICE_ACCOUNT_TOKEN` globalmente
3. Verificar: `op vault list`
4. NUNCA usar `op://` para Service Account Token

#### 4. DNS Resolvendo Incorretamente

**Sintomas:**

- `dig senamfo.com.br` retorna localhost
- Traefik não consegue validar domínios

**Soluções:**

1. Verificar /etc/hosts: `cat /etc/hosts | grep senamfo`
2. Remover entradas: `amfo.com.br/d"sudo sed -i "/sen /etc/hosts`
3. Verificar DNS externo: `dig +short senamfo.com.br A @8.8.8.8`

### Comandos Úteis

```bash
# Status dos containers
docker compose ps

# Logs do Traefik
docker compose logs traefik --tail 50

# Verificar certificados
dockcertificateer compose logs traefik | grep -i

# Reiniciar Traefik
docker compose restart traefik

# Verificar DNS
dig +short senamfo.com.br A

# Verificar 1Password
op vault list
op item get "Cloudflare API Token" --vault 1p_vps

# Injetar variáveis
cd ~/infra/stack-prod
bash scripts/inject-env.sh
```

---

## 📝 Notas Importantes

### Temporário vs Permanente

**Este documento é TEMPORÁRIO** e reflete o estado durante o deploy inicial.

**Data de Obsoleto:** 2025-11-11 (7 dias)

**Após obsoleto:**

- Atualizar com estado final do deploy
- Remover seções temporárias
- Manter apenas informações permanentes

### Próximas Atualizações

1. **Após certificados obtidos:**
   - Atualizar status do Traefik
   - Documentar processo de reativação do proxy
   - Adicionar URLs finais

2. **Após configuração completa:**
   - Remover seções temporárias
   - Documentar configurações finais
   - Adicionar procedimentos de manutenção

3. **Documentação permanente:**
   - Criar versão final do documento
   - Integrar com política documental
   - Manter atualizado

---

## 📚 Referências

### Documentação Interna

- `POLITICA_GESTAO_DOCUMENTAL_BNI.md` - Política de governança
- `TEMPLATE_NOME_ARQUIVO.md` - Template para novos arquivos
- `LOG_RENOMEACOES.csv` - Log de mudanças

### Documentação Externa

- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Let's Encrypt](https://letsencrypt.org/docs/)
- [Cloudflare DNS](https://developers.cloudflare.com/dns/)
- [1Password CLI](https://developer.1password.com/docs/cli/)

### Scripts e Automação

- `infra/stack-prod/scripts/deploy.sh` - Deploy completo
- `infra/stack-prod/scripts/inject-env.sh` - Injeção de variáveis
- `infra/stack-prod/scripts/healthcheck.sh` - Verificação de saúde
- `hf_workspace/scripts/` - Scripts diversos

---

## ✅ Checklist Final

### Para LLMs

- [x] Documento criado com data/horário
- [x] Diretrizes do .cursorrules incluídas
- [x] Contexto de deploy atual documentado
- [x] Estrutura de projeto mapeada
- [x] Variáveis e segredos documentados
- [x] Troubleshooting incluído

### Para Humanos

- [x] Visão geral do projeto
- [x] Estrutura de diretórios
- [x] Configurações atuais
- [x] Estado do deploy
- [x] Comandos úteis
- [x] Referências externas

### Próximos Passos

- [ ] Aguardar certificados SSL
- [ ] Reativar proxy Cloudflare
- [ ] Atualizar documento após deploy completo
- [ ] Criar versão permanente

---

**Documento criado em:** 2025-11-04 12:20 UTC
**Próxima revisão:** 2025-11-11
**Status:** ⚠️ TEMPORÁRIO - Deploy em andamento
