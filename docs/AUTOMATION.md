# Configuração de Automação

Guia para configurar execução automática de coletas e validações.

## Ubuntu - Cron Jobs

### Coleta Diária

Adicionar ao crontab:

```bash
crontab -e
```

Adicionar linha:

```cron
# Coleta diária às 9:00
0 9 * * * /root/SYSTEM_PROMPT/scripts/ubuntu/collect_all_ia_ubuntu.sh >> /var/log/ia_collection.log 2>&1
```

### Auditoria Semanal

```cron
# Auditoria semanal às 10:00 de segunda-feira
0 10 * * 1 /root/SYSTEM_PROMPT/scripts/shared/audit_system_prompts.sh >> /var/log/ia_audit.log 2>&1
```

### Validação Mensal

```cron
# Validação mensal no dia 1 às 11:00
0 11 1 * * /root/SYSTEM_PROMPT/scripts/shared/validate_ia_system.sh >> /var/log/ia_validation.log 2>&1
```

### Exemplo Completo

```cron
# System Prompt IA - Automação
# Coleta diária
0 9 * * * /root/SYSTEM_PROMPT/scripts/ubuntu/collect_all_ia_ubuntu.sh >> /var/log/ia_collection.log 2>&1

# Auditoria semanal (segunda-feira)
0 10 * * 1 /root/SYSTEM_PROMPT/scripts/shared/audit_system_prompts.sh >> /var/log/ia_audit.log 2>&1

# Validação mensal (dia 1)
0 11 1 * * /root/SYSTEM_PROMPT/scripts/shared/validate_ia_system.sh >> /var/log/ia_validation.log 2>&1
```

### Verificar Cron Jobs

```bash
# Listar jobs
crontab -l

# Verificar logs
tail -f /var/log/ia_collection.log
```

## macOS - Launch Agents

### Criar Launch Agent

Criar arquivo `~/Library/LaunchAgents/com.systemprompt.ia.collection.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.systemprompt.ia.collection</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USERNAME/SYSTEM_PROMPT/scripts/macos/collect_all_ia_macos.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/USERNAME/Library/Logs/ia_collection.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/USERNAME/Library/Logs/ia_collection.error.log</string>
</dict>
</plist>
```

**Importante:** Substituir `USERNAME` pelo seu usuário.

### Carregar Launch Agent

```bash
# Carregar
launchctl load ~/Library/LaunchAgents/com.systemprompt.ia.collection.plist

# Verificar
launchctl list | grep systemprompt

# Descarregar (se necessário)
launchctl unload ~/Library/LaunchAgents/com.systemprompt.ia.collection.plist
```

### Múltiplos Launch Agents

#### Coleta Diária

`~/Library/LaunchAgents/com.systemprompt.ia.collection.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.systemprompt.ia.collection</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USERNAME/SYSTEM_PROMPT/scripts/macos/collect_all_ia_macos.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/USERNAME/Library/Logs/ia_collection.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/USERNAME/Library/Logs/ia_collection.error.log</string>
</dict>
</plist>
```

#### Auditoria Semanal

`~/Library/LaunchAgents/com.systemprompt.ia.audit.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.systemprompt.ia.audit</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USERNAME/SYSTEM_PROMPT/scripts/shared/audit_system_prompts.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>1</integer>
        <key>Hour</key>
        <integer>10</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/USERNAME/Library/Logs/ia_audit.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/USERNAME/Library/Logs/ia_audit.error.log</string>
</dict>
</plist>
```

## Scripts de Instalação

### Ubuntu

Criar `install_cron.sh`:

```bash
#!/bin/bash
# Adicionar cron jobs para automação

(crontab -l 2>/dev/null; cat << EOF

# System Prompt IA - Automação
0 9 * * * /root/SYSTEM_PROMPT/scripts/ubuntu/collect_all_ia_ubuntu.sh >> /var/log/ia_collection.log 2>&1
0 10 * * 1 /root/SYSTEM_PROMPT/scripts/shared/audit_system_prompts.sh >> /var/log/ia_audit.log 2>&1
0 11 1 * * /root/SYSTEM_PROMPT/scripts/shared/validate_ia_system.sh >> /var/log/ia_validation.log 2>&1
EOF
) | crontab -

echo "✅ Cron jobs instalados"
crontab -l
```

### macOS

Criar `install_launchd.sh`:

```bash
#!/bin/bash
# Instalar launch agents

USERNAME=$(whoami)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Coleta diária
cat > ~/Library/LaunchAgents/com.systemprompt.ia.collection.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.systemprompt.ia.collection</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_DIR/scripts/macos/collect_all_ia_macos.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/$USERNAME/Library/Logs/ia_collection.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/$USERNAME/Library/Logs/ia_collection.error.log</string>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.systemprompt.ia.collection.plist
echo "✅ Launch agent instalado"
```

## Verificação

### Ubuntu

```bash
# Verificar cron jobs
crontab -l

# Verificar execução
tail -f /var/log/ia_collection.log
```

### macOS

```bash
# Verificar launch agents
launchctl list | grep systemprompt

# Verificar logs
tail -f ~/Library/Logs/ia_collection.log
```

## Desinstalação

### Ubuntu

```bash
# Remover cron jobs
crontab -l | grep -v "SYSTEM_PROMPT" | crontab -
```

### macOS

```bash
# Descarregar launch agents
launchctl unload ~/Library/LaunchAgents/com.systemprompt.ia.*.plist

# Remover arquivos
rm ~/Library/LaunchAgents/com.systemprompt.ia.*.plist
```

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

