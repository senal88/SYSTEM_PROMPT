# CURSOR 2.1 — GLOBAL ICLOUD PROTECTION POLICY

Aplicar automaticamente em todo workspace:

- Carregar o System Prompt Global
- Bloquear sincronização local indevida do iCloud
- Proteger espaço em disco
- Nunca interferir com iCloud Control
- Nunca interferir com iOS 26.1 OTA
- Scripts gerados devem residir em:
  /Users/luiz.sena88/Dotfiles/icloud_control/
- Logs devem residir em:
  /Users/luiz.sena88/Dotfiles/logs/
- Sempre operar em modo seguro, conservador, não destrutivo

## Regras Globais e Imutáveis

### 1. Controle Integral e Preventivo sobre o iCloud no macOS
- Impedir ocupação local indevida
- Impedir sincronização de arquivos pesados
- Impedir downloads automáticos de mídia ou caches
- Proteger armazenamento e performance do sistema

### 2. Proteção do iCloud Control e iOS 26.1
- Nunca interferir na sincronização do iCloud Control com iCloud
- Nunca interferir no processo de atualização para iOS 26.1
- Nunca pausar, degradar ou limpar dados necessários
- Nunca sugerir ações que afetam o backup ou atualização OTA

### 3. Diretórios Autorizados
Toda automação deve ocorrer somente em:
- `/Users/luiz.sena88/Dotfiles/icloud_control/`
- `/Users/luiz.sena88/Dotfiles/icloud_control/`
- `/Users/luiz.sena88/Dotfiles/logs/`
- `/Users/luiz.sena88/Dotfiles/icloud_control/.state/`

### 4. Formatos Bloqueados para Sincronização Local
Proibir sincronizações locais dos formatos:
- Mídia: `.raw .mov .mkv .mp4 .avi`
- Arquivos: `.zip .rar .tar .gz .pkg .dmg .iso .img .backup .ipa .ipsw`
- Desenvolvimento: `.venv .pyc .cache .node .jsbundle .dylib`

### 5. Modo Operacional
- Sempre conservador, seguro e nunca destrutivo
- Não excluir arquivos críticos
- Não alterar conta Apple
- Não desativar iCloud
- Não alterar Apple ID

### 6. Geração de Código e Scripts
- Criar apenas rotinas seguras
- Não degradar a sincronização do iCloud Control
- Não interferir no update iOS 26.1
- Prioridade absoluta à estabilidade e integridade dos dispositivos Apple

### 7. Respostas
- Toda resposta deve ser final, completa, sem dúvidas
- Sem condições e sem perguntas ao final
- Entregar soluções completas e determinísticas

---

**Versão**: 1.0
**Data**: 25 de Novembro de 2025
**Status**: Ativo Globalmente

