# Plano de Ação Final Completo - automation_1password

**Data:** 2025-10-31  
**Versão:** 2.0.0  
**Ambientes:** macOS Silicon + VPS Ubuntu 22.04 LTS  
**Status:** Execução Pendente

---

## 🎯 Objetivo

Validar, testar e finalizar todas as implementações criadas, garantindo funcionamento completo em ambos os ambientes (macOS Silicon e VPS Ubuntu).

---

## 📋 Fase 1: Correção Crítica (URGENTE)

### 1.1. Correção de Terminal

**Problema:** Terminal com erro de configuração, acesso bloqueado

**Ação:**
```bash
# Executar correção automática
cd ~/Dotfiles/automation_1password
bash scripts/bootstrap/fix_terminal_config.sh

# Se necessário, recarregar terminal
exec zsh
# ou logout/login
```

**Validação:**
```bash
# Testar comandos essenciais
ls
cd
pwd
echo $PATH
which git
which op
```

**Checklist:**
- [ ] Script executado completamente
- [ ] Terminal funcional após correção
- [ ] PATH contém diretórios essenciais
- [ ] Comandos básicos funcionando
- [ ] Backup criado em `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`

**Tempo estimado:** 5-10 minutos

---

## 📋 Fase 2: Validação 1Password (ALTA PRIORIDADE)

### 2.1. Validação macOS Silicon

**Testes:**
```bash
cd ~/Dotfiles/automation_1password

# 1. Autenticação
op whoami

# 2. Verificar vaults
op vault list

# 3. Testar leitura de secret
op read op://1p_macos/database/postgres_password

# 4. Testar script de validação
bash scripts/validation/validate_environment_macos.sh
```

**Checklist:**
- [ ] Autenticação 1Password funcionando
- [ ] Vaults acessíveis (`1p_macos`)
- [ ] Secrets podem ser lidos
- [ ] Script de validação passa todos os testes

**Tempo estimado:** 10-15 minutos

### 2.2. Validação VPS Ubuntu

**Testes:**
```bash
# Conectar ao VPS
ssh vps

# No VPS
cd ~/Dotfiles/automation_1password

# 1. Autenticação 1Password
op whoami

# 2. Verificar vaults
op vault list

# 3. Testar SSH + 1Password
bash scripts/bootstrap/test_ssh_1password.sh

# 4. Testar script completo
bash scripts/bootstrap/setup_vps_complete.sh
```

**Checklist:**
- [ ] SSH conecta ao VPS
- [ ] 1Password autenticado no VPS
- [ ] Vaults acessíveis (`1p_vps`)
- [ ] SSH agent funcionando
- [ ] Autenticação GitHub via SSH funcionando

**Tempo estimado:** 15-20 minutos

---

## 📋 Fase 3: Validação Otimização Memória (ALTA PRIORIDADE)

### 3.1. Testes macOS

**Execução:**
```bash
cd ~/Dotfiles/automation_1password

# 1. Diagnóstico inicial
make diagnose.memory

# 2. Limpeza de processos órfãos
make cleanup.orphans

# 3. Sincronização otimizada (teste pequeno)
BATCH_SIZE=10 bash scripts/projetos/sync_cursorrules_optimized.sh

# 4. Monitoramento (se necessário)
bash scripts/maintenance/monitor_memory.sh <PID>
```

**Checklist:**
- [ ] Diagnóstico executa sem erros
- [ ] Limpeza funciona corretamente
- [ ] Sincronização processa em lotes
- [ ] Monitoramento grava logs CSV
- [ ] Memória não esgota durante execução

**Tempo estimado:** 20-30 minutos

---

## 📋 Fase 4: Validação LM Studio (MÉDIA PRIORIDADE)

### 4.1. Testes Locais

**Execução:**
```bash
cd ~/Dotfiles/automation_1password

# 1. Verificar conexão LM Studio
make lmstudio.test

# 2. Listar modelos disponíveis
curl http://localhost:1234/v1/models

# 3. Testar preset com modelo
bash scripts/lmstudio/select_and_test_model.sh
# Selecionar opção 3, 4 ou 5

# 4. Validar presets deployados
ls -la ~/.lmstudio/hub/presets/automation-1password/
```

**Checklist:**
- [ ] LM Studio respondendo na porta 1234
- [ ] Modelos disponíveis listados
- [ ] Presets deployados corretamente
- [ ] Teste com preset retorna resposta válida
- [ ] System prompt contém contexto correto

**Tempo estimado:** 15-20 minutos

---

## 📋 Fase 5: Validação System Prompt (MÉDIA PRIORIDADE)

### 5.1. Testes macOS

**Execução:**
```bash
cd ~/Dotfiles/automation_1password

# 1. Listar prompts
bash scripts/prompts/manage_system_prompt.sh list

# 2. Validar prompt
bash scripts/prompts/manage_system_prompt.sh validate <nome>

# 3. Criar backup
bash scripts/prompts/manage_system_prompt.sh backup
```

### 5.2. Testes VPS (via SSH)

**Execução:**
```bash
# Do macOS
ssh vps

# No VPS
cd ~/Dotfiles/automation_1password

# 1. Validar prompt no VPS
bash scripts/prompts/manage_system_prompt.sh validate <nome>

# 2. Testar sincronização
make prompt.sync NAME=<nome> VPS_HOST=147.79.81.59 VPS_USER=luiz.sena88
```

**Checklist:**
- [ ] Prompts listados corretamente
- [ ] Validação passa sem erros
- [ ] Backup criado com sucesso
- [ ] Sincronização SSH funciona
- [ ] Prompt no VPS igual ao macOS

**Tempo estimado:** 15-20 minutos

---

## 📋 Fase 6: Testes de Integração (MÉDIA PRIORIDADE)

### 6.1. Fluxo Completo de Sincronização

**Teste:**
```bash
cd ~/Dotfiles/automation_1password

# Fluxo automático completo
make sync.cursorrules.auto

# Verificar logs
tail -f exports/sync_*.log
```

**Checklist:**
- [ ] Fluxo executa sem interrupções
- [ ] Diagnóstico executado
- [ ] Limpeza executada
- [ ] Sincronização processa projetos
- [ ] Validação final passa

**Tempo estimado:** 30-60 minutos (depende do número de projetos)

### 6.2. Fluxo VPS Completo

**Teste:**
```bash
# Do macOS
ssh vps "cd ~/Dotfiles/automation_1password && bash scripts/bootstrap/setup_vps_complete.sh"
```

**Checklist:**
- [ ] Setup completo executa
- [ ] Dependências instaladas
- [ ] SSH configurado
- [ ] 1Password funcionando
- [ ] Validação final passa

**Tempo estimado:** 10-15 minutos

---

## 📋 Fase 7: Documentação e Finalização (BAIXA PRIORIDADE)

### 7.1. Completar Documentação

**Tarefas:**
- [ ] Criar quick start guide para novos usuários
- [ ] Quick start VPS
- [ ] Quick start LM Studio
- [ ] Atualizar README.md com novos recursos

**Tempo estimado:** 1-2 horas

### 7.2. Completar Makefile Targets

**Pendentes:**
- [ ] `prompt.init` - Inicializar estrutura de prompts
- [ ] `prompt.create` - Criar novo prompt (NAME=nome)

**Tempo estimado:** 30 minutos

### 7.3. Melhorias Futuras

**Baixa prioridade:**
- [ ] Alertas automáticos de memória (mem-013)
- [ ] Estimativa de tempo na sincronização (mem-014)
- [ ] Dashboard de métricas históricas (mem-015)
- [ ] Integração presets LM Studio com scripts (lmstudio-005)

---

## 📊 Cronograma Estimado

| Fase | Prioridade | Tempo Estimado | Status |
|------|------------|----------------|--------|
| 1. Correção Terminal | 🔴 CRÍTICO | 5-10 min | ⚠️ Pendente |
| 2. Validação 1Password | 🟡 ALTA | 25-35 min | ⚠️ Pendente |
| 3. Validação Memória | 🟡 ALTA | 20-30 min | ⚠️ Pendente |
| 4. Validação LM Studio | 🟢 MÉDIA | 15-20 min | ⚠️ Pendente |
| 5. Validação System Prompt | 🟢 MÉDIA | 15-20 min | ⚠️ Pendente |
| 6. Testes Integração | 🟢 MÉDIA | 40-75 min | ⚠️ Pendente |
| 7. Documentação | 🔵 BAIXA | 2-3 horas | ⚠️ Pendente |

**Total estimado:** 2.5-4.5 horas (fases críticas e altas: 1-1.5 horas)

---

## ✅ Checklist Final de Validação

### Ambiente macOS Silicon
- [ ] Terminal funcionando
- [ ] 1Password autenticado
- [ ] Scripts executáveis
- [ ] Makefile targets funcionando
- [ ] LM Studio conectado
- [ ] Diagnóstico memória OK
- [ ] Sincronização otimizada OK

### Ambiente VPS Ubuntu
- [ ] SSH conecta
- [ ] 1Password autenticado
- [ ] Scripts executáveis
- [ ] SSH agent funcionando
- [ ] GitHub autenticado via SSH
- [ ] Setup completo executado

### Integrações
- [ ] LM Studio presets funcionando
- [ ] System prompts sincronizam
- [ ] Automação completa testada

---

## 🚀 Comandos Rápidos

### Correção Imediata
```bash
cd ~/Dotfiles/automation_1password
bash scripts/bootstrap/fix_terminal_config.sh
exec zsh
```

### Teste Rápido macOS
```bash
make diagnose.memory
op whoami
make lmstudio.test
```

### Teste Rápido VPS
```bash
ssh vps "cd ~/Dotfiles/automation_1password && op whoami && bash scripts/bootstrap/test_ssh_1password.sh"
```

### Ver Status Geral
```bash
make help
```

---

## 📚 Referências

### Scripts Principais
- `scripts/bootstrap/fix_terminal_config.sh` - Correção terminal
- `scripts/bootstrap/test_ssh_1password.sh` - Teste VPS
- `scripts/maintenance/diagnose_memory.sh` - Diagnóstico memória
- `scripts/lmstudio/select_and_test_model.sh` - Teste LM Studio

### Runbooks
- `docs/runbooks/otimizacao-memoria-projetos.md`
- `docs/runbooks/testes-configuracao-vps.md`
- `docs/runbooks/lmstudio-integration.md`

### Documentos de Referência
- `exports/indice_chat_completo_20251031.md`
- `exports/sumarizacao_executado_20251031.md`
- Este documento

---

**Última atualização:** 2025-10-31  
**Próxima execução:** Após correção terminal (Fase 1)  
**Responsável:** Sistema de Automação 1Password

