# 🌳 REPOSITÓRIO RAYCAST AUTOMATION - ESTRUTURA COMENTADA

## 📁 **raycast-automation/** - Scripts de Automação

```
raycast-automation/
├── 🎯 raycast-manager.sh          # GERENCIADOR PRINCIPAL
│   └── Interface unificada para todos os comandos
│   └── Comandos: install, backup, restore, sync, status, etc.
│
├── 📦 install.sh                  # INSTALADOR COMPLETO
│   └── Instala Raycast + 1Password + Scripts
│   └── Configura atalhos e permissões
│
├── 🔐 setup-1password.sh          # CONFIGURAÇÃO 1PASSWORD
│   └── Configura 1Password CLI
│   └── Limpa configurações corrompidas
│
├── 🧪 test-installation.sh        # TESTE DE INSTALAÇÃO
│   └── Verifica se tudo está funcionando
│   └── Testa Homebrew, Raycast, 1Password, scripts
│
├── 💾 backup-raycast.sh           # BACKUP DO RAYCAST
│   └── Faz backup completo do perfil
│   └── Exclui opcionalmente arquivos SQLite
│
├── 🔄 restore-raycast.sh          # RESTORE DO RAYCAST
│   └── Restaura backup do Raycast
│   └── Faz backup de segurança antes do restore
│
├── 🔄 sync-raycast.sh             # SINCRONIZAÇÃO BIDIRECIONAL
│   └── Sincroniza Raycast ↔ Backup
│   └── Sincronização inteligente
│
├── 🆕 replace-spotlight.sh        # SUBSTITUIÇÃO SPOTLIGHT
│   └── Substitui Spotlight pelo Raycast
│   └── Configura Raycast como launcher principal
│
├── 📚 README.md                   # DOCUMENTAÇÃO PRINCIPAL
│   └── Guia de instalação e uso
│   └── Comandos e exemplos
│
├── 📋 IMPLEMENTACAO_COMPLETA.md   # DOCUMENTAÇÃO TÉCNICA
│   └── Detalhes da implementação
│   └── Status e métricas
│
└── 📖 COMANDOS_COMPLETOS.md       # REFERÊNCIA DE COMANDOS
    └── Todos os comandos com URLs completas
    └── Exemplos de uso
```

## 📁 **raycast-profile/** - Backup do Perfil Raycast

```
raycast-profile/
├── 📊 backup-info.json            # METADADOS DO BACKUP
│   └── Timestamp, tamanho, arquivos
│   └── Informações do backup
│
├── 🔧 NodeJS/                     # RUNTIME NODE.JS
│   └── runtime/22.14.0/
│       ├── LICENSE
│       └── bin/node               # Executável Node.js
│
├── 🔌 extensions/                 # EXTENSÕES INSTALADAS
│   ├── 7d8f2db3-1793-4441-9316-fca194f35fa8/
│   │   └── com.raycast.api.cache/
│   │       ├── fc9a898b13e811da52c4c120534a4d7861b050/
│   │       └── journal            # Cache da extensão
│   ├── 80b2f7bf-85ba-4946-8b87-c0f015284bf5/
│   ├── ba9ecf89-7162-4f6a-a417-5087d8d48a98/
│   │   └── com.raycast.api.cache/
│   │       ├── 5ae5ee845bfaad87a38502aa6bde6517c0dee766/
│   │       ├── 677ce7eb5809aa0e989cd54084fb4918f33028d8/
│   │       └── journal            # Cache da extensão
│   └── cc6ad684-021a-412a-a3a4-8ad001a4f8d3/
│
├── 📈 posthog.*                   # ANALYTICS POSTHOG
│   ├── posthog.anonymousId        # ID anônimo
│   ├── posthog.distinctId         # ID único
│   ├── posthog.enabledFeatureFlagPayloads
│   ├── posthog.enabledFeatureFlags
│   ├── posthog.queueFolder
│   ├── posthog.registerProperties
│   └── posthog.replayFolder
│
├── 🗄️ raycast-activities-enc.sqlite*  # BANCO DE DADOS ATIVIDADES
│   ├── raycast-activities-enc.sqlite   # Banco principal
│   ├── raycast-activities-enc.sqlite-shm # Shared memory
│   └── raycast-activities-enc.sqlite-wal # Write-ahead log
│
├── 😀 raycast-emoji.sqlite*       # BANCO DE DADOS EMOJIS
│   ├── raycast-emoji.sqlite       # Banco principal
│   ├── raycast-emoji.sqlite-shm   # Shared memory
│   └── raycast-emoji.sqlite-wal   # Write-ahead log
│
└── 🔐 raycast-enc.sqlite*         # BANCO DE DADOS PRINCIPAL
    ├── raycast-enc.sqlite         # Banco principal
    ├── raycast-enc.sqlite-shm     # Shared memory
    └── raycast-enc.sqlite-wal     # Write-ahead log
```

## 🎯 **FUNCIONALIDADES POR ARQUIVO**

### 🚀 **Scripts Principais**
- **raycast-manager.sh**: Interface unificada
- **install.sh**: Instalação automática completa
- **setup-1password.sh**: Configuração 1Password CLI

### 💾 **Sistema de Backup**
- **backup-raycast.sh**: Backup completo
- **restore-raycast.sh**: Restore com segurança
- **sync-raycast.sh**: Sincronização bidirecional

### 🆕 **Substituição Spotlight**
- **replace-spotlight.sh**: Substitui Spotlight pelo Raycast
- **verify-spotlight-replacement.sh**: Verifica substituição

### 📚 **Documentação**
- **README.md**: Guia principal
- **IMPLEMENTACAO_COMPLETA.md**: Detalhes técnicos
- **COMANDOS_COMPLETOS.md**: Referência completa

## 📊 **ESTATÍSTICAS DO REPOSITÓRIO**

### 📁 **raycast-automation/**
- **Arquivos:** 11 arquivos
- **Scripts:** 8 scripts executáveis
- **Documentação:** 3 arquivos MD
- **Tamanho:** ~50KB

### 📁 **raycast-profile/**
- **Arquivos:** 24 arquivos
- **Diretórios:** 17 diretórios
- **Tamanho:** 140MB
- **Banco de dados:** 3 bancos SQLite
- **Extensões:** 4 extensões instaladas

## 🔧 **COMANDOS PRINCIPAIS**

```bash
# Gerenciador principal
~/Dotfiles/raycast-automation/raycast-manager.sh [comando]

# Comandos mais usados
install           # Instalação completa
backup            # Backup do Raycast
restore           # Restore do Raycast
sync              # Sincronização bidirecional
replace-spotlight # Substituir Spotlight
status            # Status do sistema
```

## 🎉 **RESULTADO FINAL**

**Sistema completo e funcional:**
- ✅ 8 scripts de automação
- ✅ 3 arquivos de documentação
- ✅ Backup completo do perfil Raycast
- ✅ Sistema de sincronização
- ✅ Substituição do Spotlight
- ✅ Interface unificada
- ✅ URLs completas em toda documentação

**REPOSITÓRIO RAYCAST AUTOMATION COMPLETO E ORGANIZADO! 🚀**
