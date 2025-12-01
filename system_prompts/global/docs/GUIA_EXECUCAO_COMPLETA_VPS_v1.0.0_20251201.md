# 🚀 Guia de Execução Completa - VPS Ubuntu

**Versão:** 1.0.0
**Data:** 2025-12-01
**Status:** ✅ Pronto para Execução

---

## 📋 Visão Geral

Este guia documenta o processo completo de execução de pendências locais e deploy na VPS Ubuntu, seguindo as melhores práticas ordenadas:

1. **COLETA** - Verificar status atual
2. **ANÁLISE** - Processar pendências locais
3. **DESENVOLVIMENTO** - Preparar deploy
4. **IMPLANTAÇÃO** - Deploy na VPS

---

## 🎯 Pré-requisitos

### Local (macOS)

- ✅ Repositório `Dotfiles` clonado e atualizado
- ✅ Repositório `infra-vps` clonado e atualizado
- ✅ 1Password CLI instalado e autenticado
- ✅ SSH configurado para acesso à VPS

### VPS (Ubuntu)

- ✅ Acesso SSH configurado
- ✅ Git instalado
- ✅ Bash disponível
- ✅ Permissões adequadas para criar diretórios

---

## 🔧 Execução Local

### Passo 1: Testar em Modo Dry-Run

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./executar-pendencias-e-deploy-vps_v1.0.0_20251201.sh --dry-run
```

**O que faz:**

- Verifica estrutura de diretórios
- Verifica status Git
- Simula todas as operações sem fazer alterações
- Valida conexão SSH com VPS

### Passo 2: Executar Correções Locais

```bash
# Executar apenas correções locais (sem deploy VPS)
./executar-pendencias-e-deploy-vps_v1.0.0_20251201.sh --skip-vps
```

**O que faz:**

- Executa correções em `infra-vps`
- Organiza secrets no 1Password
- Valida scripts
- Não faz deploy na VPS

### Passo 3: Execução Completa

```bash
# Executar tudo (correções locais + deploy VPS)
./executar-pendencias-e-deploy-vps_v1.0.0_20251201.sh
```

**O que faz:**

- Todas as correções locais
- Validação de estrutura
- Deploy completo na VPS
- Configuração de scripts na VPS

---

## 📊 Fases de Execução

### FASE 1: COLETA - Verificar Status Atual

**Objetivo:** Coletar informações sobre o estado atual do sistema

**Ações:**

1. Verificar estrutura de diretórios locais
2. Verificar status Git dos repositórios
3. Contar scripts disponíveis
4. Verificar pendências críticas (secrets hardcoded)

**Saída Esperada:**

```
✅ Dotfiles root existe
✅ System Prompts Global existe
✅ Infra VPS existe
✅ Scripts encontrados: XX
```

---

### FASE 2: ANÁLISE - Processar Pendências Locais

**Objetivo:** Executar todas as correções necessárias localmente

**Ações:**

1. Executar correções em `infra-vps`
   - Remover secrets hardcoded
   - Corrigir remote Git
   - Organizar arquivos
2. Organizar secrets no 1Password
   - Verificar itens existentes
   - Documentar secrets faltantes
3. Validar scripts
   - Verificar sintaxe
   - Testar execução

**Saída Esperada:**

```
✅ Correções em infra-vps concluídas
✅ Secrets organizados no 1Password
✅ Scripts validados
```

---

### FASE 3: DESENVOLVIMENTO - Preparar Deploy

**Objetivo:** Preparar ambiente para deploy na VPS

**Ações:**

1. Criar estrutura de logs
2. Preparar scripts para VPS
   - Verificar permissões de execução
3. Validar conexão SSH com VPS
4. Verificar estrutura existente na VPS

**Saída Esperada:**

```
✅ Estrutura de logs criada
✅ Permissões de execução verificadas
✅ Conexão SSH estabelecida
✅ Estrutura na VPS verificada
```

---

### FASE 4: IMPLANTAÇÃO - Deploy na VPS

**Objetivo:** Deploy completo do sistema na VPS

**Ações:**

1. Criar estrutura na VPS (verificando antes)
   - Evitar duplicação de diretórios
   - Criar apenas se não existir
2. Clonar/Atualizar repositório SYSTEM_PROMPT
   - Git clone se não existir
   - Git pull se já existir
3. Sincronizar infra-vps (se existir)
   - Git clone se não existir
   - Git pull se já existir
4. Configurar permissões de execução
5. Validar instalação

**Saída Esperada:**

```
✅ Estrutura na VPS verificada/criada
✅ Repositório SYSTEM_PROMPT clonado/atualizado
✅ Infra-vps sincronizado
✅ Permissões configuradas
✅ Instalação validada
```

---

## 🔍 Verificação Pós-Deploy

### Na VPS

```bash
# Conectar na VPS
ssh admin-vps

# Verificar estrutura
ls -la ~/Dotfiles/system_prompts/global/scripts/

# Verificar infra-vps
ls -la ~/Dotfiles/infra-vps/scripts/

# Testar execução de um script
cd ~/Dotfiles/system_prompts/global/scripts
./testar_scripts_system_prompts_global.sh
```

### Localmente

```bash
# Verificar logs
ls -la ~/Dotfiles/system_prompts/global/logs/

# Verificar status Git
cd ~/Dotfiles
git status

cd ~/Dotfiles/infra-vps
git status
```

---

## ⚠️ Troubleshooting

### Erro: Conexão SSH Falhou

**Sintoma:**

```
❌ Não foi possível conectar via SSH
```

**Solução:**

1. Verificar alias SSH: `ssh admin-vps`
2. Verificar chaves SSH autorizadas na VPS
3. Testar conexão manual: `ssh admin@<IP_VPS>`

### Erro: Diretório Já Existe

**Sintoma:**

```
⚠️ Diretório já existe na VPS: /home/admin/Dotfiles
```

**Solução:**

- Isso é normal e esperado
- O script verifica antes de criar
- Não causa problemas

### Erro: Git Clone Falhou

**Sintoma:**

```
⚠️ Git clone pode ter falhado
```

**Solução:**

1. Verificar acesso ao repositório GitHub
2. Verificar se repositório já existe (fazer pull ao invés de clone)
3. Verificar permissões na VPS

### Erro: Permissões de Execução

**Sintoma:**

```
⚠️ Configuração de permissões pode ter falhado
```

**Solução:**

```bash
# Na VPS, executar manualmente:
chmod +x ~/Dotfiles/system_prompts/global/scripts/*.sh
chmod +x ~/Dotfiles/infra-vps/scripts/*.sh
```

---

## 📝 Checklist de Execução

### Antes de Executar

- [ ] Repositórios locais atualizados (`git pull`)
- [ ] 1Password CLI autenticado (`op signin`)
- [ ] Conexão SSH com VPS testada (`ssh admin-vps`)
- [ ] Backup de configurações importantes

### Durante Execução

- [ ] Fase 1 (Coleta) concluída sem erros
- [ ] Fase 2 (Análise) concluída sem erros
- [ ] Fase 3 (Desenvolvimento) concluída sem erros
- [ ] Fase 4 (Implantação) concluída sem erros

### Após Execução

- [ ] Logs revisados (`~/Dotfiles/system_prompts/global/logs/`)
- [ ] Estrutura na VPS verificada
- [ ] Scripts na VPS testados
- [ ] Documentação atualizada

---

## 🎯 Próximos Passos Após Deploy

1. **Executar Scripts na VPS:**

   ```bash
   ssh admin-vps
   cd ~/Dotfiles/system_prompts/global/scripts
   ./master-auditoria-completa_v1.0.0_20251130.sh
   ```

2. **Configurar Secrets na VPS:**

   ```bash
   # Na VPS, configurar 1Password CLI
   op signin

   # Verificar secrets
   op read 'op://1p_vps/Postgres-Prod/USER'
   ```

3. **Executar Deploy de Infraestrutura:**
   ```bash
   cd ~/Dotfiles/infra-vps
   ./scripts/executar-correcoes-completas.sh
   ```

---

## 📚 Documentação Relacionada

- **Auditoria infra-vps:** `~/Dotfiles/infra-vps/AUDITORIA_COMPLETA_INFRA_VPS_v1.0.0_20251201.md`
- **Mapeamento de Secrets:** `~/Dotfiles/infra-vps/vaults-1password/docs/MAPEAMENTO_SECRETS_COMPLETO_v1.0.0_20251201.md`
- **Organização Secrets:** `~/Dotfiles/system_prompts/global/docs/ORGANIZACAO_SECRETS_1PASSWORD_v1.0.0_20251201.md`

---

**Última Atualização:** 2025-12-01
**Próxima Revisão:** Após execução completa
