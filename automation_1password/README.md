# Automação Completa 1Password - macOS + VPS

Sistema completo de automação e gerenciamento do 1Password CLI para macOS Silicon e VPS Ubuntu.

## 🎯 Objetivo

Resolver definitivamente o conflito entre 1Password CLI e Connect, parametrizar secrets das vaults e automatizar a configuração em ambos os ambientes.

## 📋 Problema Resolvido

**Antes:** As variáveis `OP_CONNECT_HOST` e `OP_CONNECT_TOKEN` estavam sendo exportadas no `.zprofile`, causando conflito quando se tentava usar o 1Password CLI diretamente.

**Depois:** Sistema inteligente que separa CLI e Connect, com CLI como padrão e Connect disponível quando necessário.

## 🏗️ Estrutura

```
~/.config/op/
├── op_config.sh              # Configuração centralizada
├── vault_config.json          # Mapeamento de vaults e configurações
└── vault_data/               # Dados exportados das vaults
    ├── vault_1p_macos.json
    ├── vault_1p_vps.json
    ├── vault_personal.json
    └── vault_default_importado.json

~/Dotfiles/automation_1password/scripts/
├── op-export-vault.sh         # Exportar dados das vaults
└── op-init.sh                # Inicialização automática
```

## 🚀 Início Rápido

### 1. Inicialização Automática

```bash
# Carrega nova configuração no shell atual
source ~/.zshrc

# Ou execute o script de inicialização
op-init.sh
```

### 2. Verificar Configuração

```bash
op-config-check
```

Este comando verifica:
- ✅ Status de autenticação
- ✅ Configuração CLI/Connect
- ✅ Vault padrão configurado
- ✅ Vaults disponíveis

## 📖 Funções Disponíveis

### `op-signin-auto`
Auto-login com vault padrão baseado no contexto (macOS ou VPS).

```bash
op-signin-auto
```

### `op-vault-switch`
Trocar vault padrão dinamicamente.

```bash
# Por ID
op-vault-switch gkpsbgizlks2zknwzqpppnb2ze

# Por nome
op-vault-switch 1p_macos

# Listar vaults disponíveis
op-vault-switch
```

### `op-connect-enable`
Ativar modo Connect temporariamente (quando necessário).

```bash
op-connect-enable
```

### `op-connect-disable`
Desativar Connect e usar CLI (padrão).

```bash
op-connect-disable
```

### `op-config-check`
Verificar e corrigir configuração automaticamente.

```bash
op-config-check
```

## 🔧 Scripts

### `op-export-vault.sh`

Exporta e parametriza dados de todas as vaults.

**Uso:**
```bash
# Exportar todas as vaults (padrão: JSON)
op-export-vault.sh

# Exportar vault específica
op-export-vault.sh --vault gkpsbgizlks2zknwzqpppnb2ze

# Exportar em formato YAML
op-export-vault.sh --format yaml

# Exportar todas em YAML
op-export-vault.sh --all --format yaml
```

**Saída:**
- Arquivos JSON/YAML em `~/.config/op/vault_data/`
- Um arquivo por vault
- Estrutura organizada por categoria e tipo de item

### `op-init.sh`

Script de inicialização automática que:
- Verifica estrutura de diretórios
- Verifica autenticação
- Configura CLI/Connect
- Configura vault padrão
- Lista vaults disponíveis

**Uso:**
```bash
op-init.sh
```

## 📦 Vaults Configuradas

| ID | Nome | Contexto |
|----|------|----------|
| `gkpsbgizlks2zknwzqpppnb2ze` | `1p_macos` | macOS (padrão) |
| `oa3tidekmeu26nxiier2qbi7v4` | `1p_vps` | VPS Ubuntu (padrão) |
| `syz4hgfg6c62ndrxjmoortzhia` | `default_importado` | Vault importada |
| `7bgov3zmccio5fxc5v7irhy5k4` | `Personal` | Vault pessoal |

## 🔄 Como Funciona

### Wrapper Inteligente do `op`

O comando `op` agora é uma função wrapper que:
1. **Sempre desativa Connect** antes de executar comandos CLI
2. Executa o comando `op` real
3. Restaura Connect se estava ativo (para compatibilidade)

Isso garante que o CLI funcione sempre, sem conflitos.

### Detecção Automática de Contexto

O sistema detecta automaticamente o ambiente:
- **macOS**: Usa vault `1p_macos` como padrão
- **VPS Ubuntu**: Usa vault `1p_vps` como padrão

### Configuração Centralizada

Todas as configurações estão centralizadas em:
- `~/.config/op/op_config.sh` - Variáveis e funções
- `~/.config/op/vault_config.json` - Mapeamento de vaults

## 🛠️ Troubleshooting

### Erro: "op signin doesn't work with Connect"

**Solução:** O wrapper já resolve isso automaticamente. Se ainda ocorrer:

```bash
# Desativar Connect manualmente
op-connect-disable

# Verificar configuração
op-config-check
```

### Erro: "Vault padrão não configurado"

**Solução:**
```bash
# Carregar configuração
source ~/.config/op/op_config.sh

# Ou executar inicialização
op-init.sh
```

### Erro: "Arquivo de configuração não encontrado"

**Solução:** Verifique se os arquivos existem:
```bash
ls -la ~/.config/op/
```

Se não existirem, recrie:
```bash
mkdir -p ~/.config/op/vault_data
# Os arquivos devem ser criados automaticamente
```

### Erro ao exportar vaults

**Solução:**
```bash
# Verificar se está logado
op whoami

# Se não estiver, fazer login
op-signin-auto

# Tentar exportar novamente
op-export-vault.sh
```

## 📝 Exemplos de Uso

### Exemplo 1: Uso Básico do CLI

```bash
# Listar vaults
op vault list

# Listar items de uma vault
op item list --vault 1p_macos

# Obter item específico
op item get "Nome do Item" --vault 1p_macos
```

### Exemplo 2: Trocar Vault Padrão

```bash
# Trocar para vault VPS
op-vault-switch 1p_vps

# Verificar vault atual
op-config-check
```

### Exemplo 3: Exportar e Usar Dados

```bash
# Exportar todas as vaults
op-export-vault.sh

# Ver dados exportados
cat ~/.config/op/vault_data/vault_1p_macos.json | jq '.[0]'

# Usar em script
jq -r '.[] | select(.title == "Meu Item") | .fields[0].value' \
  ~/.config/op/vault_data/vault_1p_macos.json
```

### Exemplo 4: Usar Connect Quando Necessário

```bash
# Ativar Connect
op-connect-enable

# Usar comandos Connect
op item list

# Desativar Connect
op-connect-disable
```

## 🔐 Segurança

- **Tokens Connect**: Armazenados em `~/.config/op/vault_config.json`
- **Dados Exportados**: Armazenados em `~/.config/op/vault_data/`
- **Permissões**: Arquivos com permissões restritas (600)

**Recomendação:** Não commitar arquivos de configuração em repositórios públicos.

## 🚀 Implantação na VPS Ubuntu

Para replicar na VPS:

1. **Copiar arquivos:**
```bash
# Do macOS
scp -r ~/.config/op user@vps:~/.config/
scp -r ~/Dotfiles/automation_1password user@vps:~/Dotfiles/
```

2. **Adicionar ao `.zshrc` ou `.bashrc` na VPS:**
```bash
# Carregar configuração 1Password
if [ -f "$HOME/.config/op/op_config.sh" ]; then
    source "$HOME/.config/op/op_config.sh"
fi

# Funções do .zshrc (copiar seção completa)
```

3. **Inicializar:**
```bash
op-init.sh
```

## 📚 Referências

- [1Password CLI Documentation](https://developer.1password.com/docs/cli)
- [1Password Connect Documentation](https://support.1password.com/connect/)

## 🔄 Changelog

### 2025-11-04
- ✅ Resolvido conflito CLI/Connect definitivamente
- ✅ Criado wrapper inteligente do `op`
- ✅ Implementado sistema de configuração centralizada
- ✅ Criado script de exportação de vaults
- ✅ Criado script de inicialização automática
- ✅ Documentação completa

## 📞 Suporte

Para problemas ou dúvidas:
1. Execute `op-config-check` para diagnóstico
2. Verifique logs de erro
3. Consulte esta documentação

---

**Status:** ✅ Completo e Funcional
**Última atualização:** 2025-11-04

