# �� SOLUÇÃO: Homebrew não encontrado no PATH

## Problema
Homebrew está instalado em `/opt/homebrew` mas não está disponível no PATH atual.

## Solução Rápida

### Opção 1: Recarregar o shell (Recomendado)

O Homebrew já está configurado no seu `~/.zshrc`, você só precisa recarregar:

```bash
source ~/.zshrc
```

Depois disso, teste:
```bash
brew --version
```

### Opção 2: Carregar Homebrew manualmente nesta sessão

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Opção 3: Usar caminho completo

Enquanto não recarregar o shell, você pode usar o caminho completo:

```bash
/opt/homebrew/bin/brew install --cask 1password-cli
```

## Depois de resolver

Após recarregar o shell e ter `brew` funcionando, instale o 1Password CLI:

```bash
# Método 1: Via script automatizado
cd ~/Dotfiles/system_prompts/global
./scripts/instalar-1password-cli.sh

# Método 2: Manualmente
brew install --cask 1password-cli
```

## Verificar instalação

```bash
op --version
op signin
op vault list
```

