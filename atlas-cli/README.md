# 🚀 Atlas CLI - Pinagem Automática de Extensões

Scripts para pinagem automática das extensões **Promptheus**, **WebPilot** e **AIPRM** via Atlas CLI.

## 📁 **Estrutura**

```
atlas-cli/
├── pin-extensoes.sh          # Script unificado (detecta ambiente)
├── pin-extensoes-macos.sh    # Script específico para macOS
├── pin-extensoes-vps.sh      # Script específico para VPS Ubuntu
└── README.md                 # Esta documentação
```

## 🎯 **Extensões Suportadas**

- **Promptheus** - Gerenciamento de prompts
- **WebPilot** - Navegação web
- **AIPRM** - Templates de prompts

## 🚀 **Uso Rápido**

### Script Unificado (Recomendado)
```bash
# Navegar para o diretório
cd ~/Dotfiles/atlas-cli

# Tornar executável
chmod +x pin-extensoes.sh

# Executar (detecta ambiente automaticamente)
./pin-extensoes.sh
```

### Scripts Específicos

#### macOS
```bash
# Executar script específico para macOS
./pin-extensoes-macos.sh
```

#### VPS Ubuntu
```bash
# Executar script específico para VPS
./pin-extensoes-vps.sh
```

## 📋 **Pré-requisitos**

### 1. Atlas CLI Instalado
```bash
# Verificar se está instalado
atlas-cli --version

# Se não estiver instalado:
# 1. Acesse: https://atlas.anthropic.com/
# 2. Baixe e instale o Atlas CLI
```

### 2. Atlas CLI Autenticado
```bash
# Fazer login
atlas-cli login

# Verificar status
atlas-cli status
```

### 3. Extensões Instaladas
```bash
# Listar extensões instaladas
atlas-cli extensions list

# Instalar extensões se necessário
atlas-cli extensions install Promptheus
atlas-cli extensions install WebPilot
atlas-cli extensions install AIPRM
```

## 🔧 **Funcionalidades**

### ✅ **Validações Automáticas**
- Verifica se Atlas CLI está instalado
- Verifica se Atlas CLI está autenticado
- Valida cada extensão antes de fixar

### ✅ **Detecção de Ambiente**
- **macOS:** Detecta automaticamente
- **VPS Ubuntu:** Detecta automaticamente
- **Caminhos:** Ajusta automaticamente

### ✅ **Relatórios Detalhados**
- Status de cada extensão
- Contadores de sucesso/falha
- Resumo final completo

## 📊 **Exemplo de Saída**

```
╔══════════════════════════════════════════════════════════════╗
║                ATLAS CLI - PINAGEM DE EXTENSÕES                ║
║                    Script Unificado                            ║
╚══════════════════════════════════════════════════════════════╝

[13:45:23] Ambiente detectado: 🍏 macOS Silicon
[13:45:23] Diretório de trabalho: /Users/luiz.sena88/Dotfiles/atlas-cli
[13:45:23] Verificando Atlas CLI...
[SUCCESS] ✅ Atlas CLI encontrado
[13:45:23] Verificando autenticação do Atlas CLI...
[SUCCESS] ✅ Atlas CLI autenticado
[13:45:23] Iniciando pinagem das extensões...
[13:45:23] Fixando extensão: Promptheus
[SUCCESS] ✅ Promptheus fixada com sucesso
[13:45:23] Fixando extensão: WebPilot
[SUCCESS] ✅ WebPilot fixada com sucesso
[13:45:23] Fixando extensão: AIPRM
[SUCCESS] ✅ AIPRM fixada com sucesso

╔══════════════════════════════════════════════════════════════╗
║                    RESUMO DA PINAGEM                          ║
╚══════════════════════════════════════════════════════════════╝

[INFO] Ambiente: 🍏 macOS Silicon
[INFO] Extensões processadas: 3
[INFO] Extensões fixadas com sucesso: 3

[SUCCESS] 🎉 Todas as extensões foram fixadas com sucesso!

[INFO] Extensões fixadas:
  ✅ Promptheus
  ✅ WebPilot
  ✅ AIPRM

[13:45:24] Pinagem de extensões Atlas CLI concluída! 🚀
```

## 🚨 **Solução de Problemas**

### ❌ **Atlas CLI não encontrado**
```bash
# Instalar Atlas CLI
# 1. Acesse: https://atlas.anthropic.com/
# 2. Baixe e instale
# 3. Execute o script novamente
```

### ❌ **Atlas CLI não autenticado**
```bash
# Fazer login
atlas-cli login

# Verificar status
atlas-cli status
```

### ❌ **Extensões não encontradas**
```bash
# Listar extensões instaladas
atlas-cli extensions list

# Instalar extensões necessárias
atlas-cli extensions install Promptheus
atlas-cli extensions install WebPilot
atlas-cli extensions install AIPRM
```

### ❌ **Falha na pinagem**
```bash
# Verificar se Atlas está rodando
atlas-cli status

# Reiniciar Atlas se necessário
# 1. Feche o Atlas
# 2. Abra novamente
# 3. Execute o script
```

## 🔄 **Personalização**

### Adicionar Novas Extensões
Edite o array `EXTENSOES` em qualquer script:

```bash
# Adicionar nova extensão
EXTENSOES=("Promptheus" "WebPilot" "AIPRM" "NovaExtensao")
```

### Modificar Caminhos
Edite a variável `WORKDIR` nos scripts específicos:

```bash
# macOS
WORKDIR="/Users/luiz.sena88/Dotfiles/atlas-cli"

# VPS Ubuntu
WORKDIR="/home/luiz.sena88/Dotfiles/atlas-cli"
```

## 📚 **Comandos Úteis**

```bash
# Verificar status do Atlas CLI
atlas-cli status

# Listar extensões instaladas
atlas-cli extensions list

# Listar extensões fixadas
atlas-cli extensions pinned

# Desfixar extensão
atlas-cli extensions unpin NomeDaExtensao

# Fixar extensão manualmente
atlas-cli extensions pin NomeDaExtensao
```

## 🎉 **Resultado Final**

**Após executar o script:**
- ✅ Promptheus fixada na barra
- ✅ WebPilot fixada na barra
- ✅ AIPRM fixada na barra
- ✅ Todas as extensões sempre visíveis

**SISTEMA DE PINAGEM AUTOMÁTICA FUNCIONANDO! 🚀**
