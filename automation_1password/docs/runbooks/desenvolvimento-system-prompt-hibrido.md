Last Updated: 2025-10-30
Version: 1.0.0

# Desenvolvimento de System Prompt Global Híbrido

## 1. Visão Geral

Este runbook documenta o processo de desenvolvimento de **system prompts globais híbridos** que funcionam tanto no **macOS Silicon** quanto no **VPS Ubuntu**, utilizando SSH para sincronização e desenvolvimento colaborativo entre os dois ambientes.

### 1.1. Objetivo

Criar e manter system prompts que:
- Funcionam em ambos os ambientes (macOS + Ubuntu)
- Detecção automática de ambiente
- Sincronização via SSH entre local e VPS
- Versionamento e backup automático
- Validação em ambos os ambientes

### 1.2. Estrutura

```
prompts/system/
├── shared/          # Prompts compartilhados (híbridos)
│   ├── global_hybrid.md
│   └── .template.md
├── macos/           # Específicos macOS
│   └── macos_only.md
├── ubuntu/          # Específicos Ubuntu
│   └── ubuntu_only.md
└── versions/        # Versões históricas e backups
    └── backup_YYYYMMDD_HHMMSS/
```

## 2. Scripts de Gerenciamento

### 2.1. manage_system_prompt.sh

Script principal para gerenciar system prompts.

**Comandos Disponíveis**:

```bash
# Inicializar estrutura
bash scripts/prompts/manage_system_prompt.sh init

# Criar novo prompt
bash scripts/prompts/manage_system_prompt.sh create global_hybrid

# Listar prompts
bash scripts/prompts/manage_system_prompt.sh list

# Mostrar prompt
bash scripts/prompts/manage_system_prompt.sh show global_hybrid

# Sincronizar com VPS
bash scripts/prompts/manage_system_prompt.sh sync global_hybrid \
  --vps-host 147.79.81.59 \
  --vps-user luiz.sena88

# Comparar versões
bash scripts/prompts/manage_system_prompt.sh diff global_hybrid \
  --vps-host 147.79.81.59 \
  --vps-user luiz.sena88

# Validar prompt
bash scripts/prompts/manage_system_prompt.sh validate global_hybrid

# Backup
bash scripts/prompts/manage_system_prompt.sh backup
```

### 2.2. ssh_dev_prompt.sh

Interface interativa para desenvolvimento via SSH.

**Uso**:
```bash
bash scripts/prompts/ssh_dev_prompt.sh
```

**Funcionalidades**:
- Menu interativo
- Edição local e remota
- Sincronização bidirecional
- Testes em ambos ambientes
- Deploy completo automatizado

## 3. Fluxo de Desenvolvimento

### 3.1. Inicialização

```bash
# 1. Inicializar estrutura
bash scripts/prompts/manage_system_prompt.sh init

# 2. Criar prompt base
bash scripts/prompts/manage_system_prompt.sh create global_hybrid

# 3. Editar prompt
bash scripts/prompts/manage_system_prompt.sh edit global_hybrid
# ou
${EDITOR} prompts/system/shared/global_hybrid.md
```

### 3.2. Desenvolvimento Local (macOS)

```bash
# Editar no macOS
nano prompts/system/shared/global_hybrid.md

# Validar
bash scripts/prompts/manage_system_prompt.sh validate global_hybrid

# Testar localmente
bash scripts/prompts/manage_system_prompt.sh show global_hybrid
```

### 3.3. Sincronização com VPS

```bash
# Enviar para VPS
bash scripts/prompts/manage_system_prompt.sh sync global_hybrid \
  --vps-host 147.79.81.59 \
  --vps-user luiz.sena88

# Ou usar interface interativa
bash scripts/prompts/ssh_dev_prompt.sh
# Escolher opção 3: Sincronizar local → VPS
```

### 3.4. Desenvolvimento Remoto (VPS)

```bash
# Conectar ao VPS
ssh luiz.sena88@147.79.81.59

# Editar prompt no VPS
nano ~/Dotfiles/automation_1password/prompts/system/shared/global_hybrid.md

# Testar no VPS
cat ~/Dotfiles/automation_1password/prompts/system/shared/global_hybrid.md
```

### 3.5. Trazer Mudanças do VPS

```bash
# Usando interface interativa
bash scripts/prompts/ssh_dev_prompt.sh
# Escolher opção 4: Sincronizar VPS → local

# Ou manualmente
scp luiz.sena88@147.79.81.59:~/Dotfiles/automation_1password/prompts/system/shared/global_hybrid.md \
    prompts/system/shared/
```

## 4. Template de System Prompt Híbrido

### 4.1. Estrutura Recomendada

```markdown
# System Prompt: {{NAME}}
## Ambiente: Híbrido (macOS Silicon + VPS Ubuntu)

## Context

### Ambiente macOS Silicon
- Sistema: macOS
- Shell: zsh
- 1Password: Desktop App + CLI
- Autenticação: Biométrica

### Ambiente VPS Ubuntu
- Sistema: Ubuntu
- Shell: bash
- 1Password: CLI (headless)
- Autenticação: Service Account Token

## Rules

### Detecção de Ambiente
- Use: `[[ "$(uname)" == "Darwin" ]]` para macOS
- Use: `[[ "$(uname)" == "Linux" ]]` para Ubuntu

### 1Password Integration
- macOS: `op signin` (interativo/biométrico)
- Ubuntu: `OP_SERVICE_ACCOUNT_TOKEN` (variável de ambiente)

## Examples

[Exemplos de código híbrido]

## Output Format
- Markdown
- JSON
- YAML
```

## 5. Comandos SSH Essenciais

### 5.1. Configuração SSH

Garantir que SSH está configurado corretamente:

```bash
# No macOS, testar conexão
ssh -T luiz.sena88@147.79.81.59

# Se houver erro "UseKeychain", executar:
bash scripts/bootstrap/fix_ssh_1password_vps.sh
```

### 5.2. Sincronização Rápida

```bash
# Enviar arquivo específico
scp prompts/system/shared/global_hybrid.md \
    luiz.sena88@147.79.81.59:~/Dotfiles/automation_1password/prompts/system/shared/

# Baixar arquivo específico
scp luiz.sena88@147.79.81.59:~/Dotfiles/automation_1password/prompts/system/shared/global_hybrid.md \
    prompts/system/shared/

# Sincronizar diretório completo
rsync -avz prompts/system/ \
    luiz.sena88@147.79.81.59:~/Dotfiles/automation_1password/prompts/system/
```

### 5.3. Execução Remota

```bash
# Executar comando no VPS
ssh luiz.sena88@147.79.81.59 "cd ~/Dotfiles/automation_1password && bash scripts/prompts/manage_system_prompt.sh list"

# Executar interativo
ssh -t luiz.sena88@147.79.81.59 "cd ~/Dotfiles/automation_1password && bash scripts/prompts/ssh_dev_prompt.sh"
```

## 6. Validação e Testes

### 6.1. Validação Local

```bash
# Validar estrutura
bash scripts/prompts/manage_system_prompt.sh validate global_hybrid

# Verificar sintaxe Markdown (se tiver markdownlint)
markdownlint prompts/system/shared/global_hybrid.md
```

### 6.2. Validação no VPS

```bash
# Via SSH
ssh luiz.sena88@147.79.81.59 << 'EOF'
cd ~/Dotfiles/automation_1password
bash scripts/prompts/manage_system_prompt.sh validate global_hybrid
EOF
```

### 6.3. Comparação de Versões

```bash
# Comparar local vs VPS
bash scripts/prompts/manage_system_prompt.sh diff global_hybrid \
  --vps-host 147.79.81.59 \
  --vps-user luiz.sena88
```

## 7. Deploy e Versionamento

### 7.1. Deploy Completo

```bash
# Usando interface interativa
bash scripts/prompts/ssh_dev_prompt.sh
# Escolher opção 8: Deploy completo

# Fluxo automático:
# 1. Backup local
# 2. Validação local
# 3. Sync para VPS
# 4. Validação no VPS
```

### 7.2. Backup Automático

```bash
# Criar backup antes de mudanças
bash scripts/prompts/manage_system_prompt.sh backup

# Backups ficam em: prompts/system/versions/backup_YYYYMMDD_HHMMSS/
```

### 7.3. Restauração

```bash
# Listar backups
ls -la prompts/system/versions/

# Restaurar de backup
cp prompts/system/versions/backup_YYYYMMDD_HHMMSS/global_hybrid.md \
   prompts/system/shared/
```

## 8. Troubleshooting

### 8.1. Erro de Conexão SSH

```bash
# Testar conexão
ssh -v luiz.sena88@147.79.81.59

# Verificar configuração SSH
cat ~/.ssh/config

# Corrigir se necessário
bash scripts/bootstrap/fix_ssh_1password_vps.sh
```

### 8.2. Arquivo Não Encontrado no VPS

```bash
# Verificar se diretório existe
ssh luiz.sena88@147.79.81.59 "ls -la ~/Dotfiles/automation_1password/prompts/system/"

# Criar se necessário
ssh luiz.sena88@147.79.81.59 "mkdir -p ~/Dotfiles/automation_1password/prompts/system/shared"
```

### 8.3. Conflitos de Versão

```bash
# Comparar versões
bash scripts/prompts/manage_system_prompt.sh diff global_hybrid \
  --vps-host 147.79.81.59 \
  --vps-user luiz.sena88

# Resolver manualmente ou escolher versão:
# - Manter local
# - Trazer do VPS
# - Merge manual
```

## 9. Makefile Targets

Adicionar ao Makefile:

```makefile
prompt.init:
	bash scripts/prompts/manage_system_prompt.sh init

prompt.create:
	bash scripts/prompts/manage_system_prompt.sh create $(NAME)

prompt.dev:
	bash scripts/prompts/ssh_dev_prompt.sh

prompt.sync:
	bash scripts/prompts/manage_system_prompt.sh sync $(NAME) \
		--vps-host $(VPS_HOST) \
		--vps-user $(VPS_USER)
```

**Uso**:
```bash
make prompt.init
make prompt.create NAME=global_hybrid
make prompt.dev
make prompt.sync NAME=global_hybrid VPS_HOST=147.79.81.59 VPS_USER=luiz.sena88
```

## 10. Checklist de Desenvolvimento

Antes de considerar um prompt pronto:

- [ ] Prompt criado com template base
- [ ] Detecção de ambiente implementada (macOS/Ubuntu)
- [ ] Integração 1Password testada em ambos ambientes
- [ ] Validação local passou
- [ ] Sincronizado com VPS
- [ ] Validação no VPS passou
- [ ] Backup criado
- [ ] Documentado no runbook

---

**Última atualização**: 2025-10-30  
**Versão**: 1.0.0  
**Autor**: Sistema de Automação 1Password

