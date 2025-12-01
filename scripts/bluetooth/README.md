# Sistema de Monitoramento e Automação - Mouse Bluetooth Dell MS3320W

Sistema completo de diagnóstico, monitoramento e reconexão automática para o mouse Bluetooth Dell MS3320W no macOS.

## 📋 Visão Geral

Este sistema foi desenvolvido para resolver problemas de desconexão frequente do mouse Dell MS3320W, fornecendo:

- **Diagnóstico completo** do estado do dispositivo e sistema Bluetooth
- **Monitoramento contínuo** em tempo real
- **Reconexão automática** quando desconexões são detectadas
- **Análise de padrões** e geração de relatórios
- **Logging detalhado** para troubleshooting

## 🚀 Instalação Rápida

```bash
cd ~/Dotfiles/scripts/bluetooth
./dell-ms3320w-setup.sh
```

O script de setup irá:
1. Instalar dependências necessárias (`blueutil`, `bluetoothconnector`)
2. Configurar permissões dos scripts
3. Executar diagnóstico inicial
4. Opcionalmente instalar monitoramento automático em background

## 📦 Dependências

- **Homebrew** (gerenciador de pacotes)
- **blueutil** (controle do Bluetooth via CLI)
- **bluetoothconnector** (conexão/desconexão de dispositivos)
- **bc** (calculadora - geralmente já vem com macOS)

Todas as dependências são instaladas automaticamente pelo script de setup.

## 🔧 Scripts Disponíveis

### 1. `dell-ms3320w-setup.sh`
**Script master de instalação e configuração**

Executa a instalação completa do sistema:
- Instala dependências
- Configura permissões
- Executa diagnóstico inicial
- Opcionalmente instala LaunchAgent

**Uso:**
```bash
./dell-ms3320w-setup.sh
```

---

### 2. `dell-ms3320w-diagnostico.sh`
**Coleta informações completas do sistema**

Coleta e registra:
- Estado do sistema Bluetooth
- Dispositivos pareados
- Logs do sistema
- Configurações de energia
- Interferências potenciais

**Uso:**
```bash
./dell-ms3320w-diagnostico.sh
```

**Saída:** Log em `~/.local/logs/bluetooth/dell-ms3320w-diagnostico-YYYYMMDD_HHMMSS.log`

---

### 3. `dell-ms3320w-monitor.sh`
**Monitoramento contínuo em tempo real**

Monitora a conexão do mouse:
- Verifica conexão a cada 5 segundos
- Detecta desconexões imediatamente
- Chama script de reconexão automaticamente
- Registra todos os eventos

**Uso:**
```bash
./dell-ms3320w-monitor.sh
```

**Parar:** Pressione `Ctrl+C`

**Saída:**
- Log em `~/.local/logs/bluetooth/dell-ms3320w-monitor-YYYYMMDD_HHMMSS.log`
- Status JSON em `~/.local/logs/bluetooth/dell-ms3320w-status.json`

---

### 4. `dell-ms3320w-reconnect.sh`
**Reconexão automática com retry inteligente**

Tenta reconectar o mouse usando múltiplos métodos:
1. `bluetoothconnector` (método preferencial)
2. Reset do Bluetooth via `blueutil`
3. Interface do sistema via AppleScript

**Uso:**
```bash
./dell-ms3320w-reconnect.sh
```

**Parâmetros:**
- Máximo de 5 tentativas
- Backoff exponencial entre tentativas
- Logging detalhado de cada tentativa

**Saída:** Log em `~/.local/logs/bluetooth/dell-ms3320w-reconnect-YYYYMMDD_HHMMSS.log`

---

### 5. `dell-ms3320w-launchagent.sh`
**Instala monitoramento automático em background**

Cria um LaunchAgent do macOS para:
- Iniciar monitoramento automaticamente no login
- Manter monitoramento ativo em background
- Reiniciar automaticamente se o processo falhar

**Uso:**
```bash
./dell-ms3320w-launchagent.sh
```

**Gerenciamento:**
```bash
# Verificar status
launchctl list | grep dell-ms3320w

# Parar serviço
launchctl unload ~/Library/LaunchAgents/com.dotfiles.dell-ms3320w-monitor.plist

# Reiniciar serviço
launchctl unload ~/Library/LaunchAgents/com.dotfiles.dell-ms3320w-monitor.plist && \
launchctl load ~/Library/LaunchAgents/com.dotfiles.dell-ms3320w-monitor.plist
```

---

### 6. `dell-ms3320w-analise.sh`
**Análise de padrões e geração de relatórios**

Analisa logs coletados e gera relatório com:
- Estatísticas de desconexão/reconexão
- Padrões temporais
- Análise de causas
- Recomendações

**Uso:**
```bash
./dell-ms3320w-analise.sh
```

**Saída:** Relatório Markdown em `~/.local/logs/bluetooth/reports/analise-YYYYMMDD_HHMMSS.md`

---

## 📁 Estrutura de Diretórios

```
~/Dotfiles/scripts/bluetooth/
├── dell-ms3320w-setup.sh          # Script master de instalação
├── dell-ms3320w-diagnostico.sh    # Diagnóstico do sistema
├── dell-ms3320w-monitor.sh        # Monitoramento contínuo
├── dell-ms3320w-reconnect.sh      # Reconexão automática
├── dell-ms3320w-launchagent.sh    # Instalação de serviço
├── dell-ms3320w-analise.sh        # Análise de logs
└── README.md                       # Esta documentação

~/.local/logs/bluetooth/
├── dell-ms3320w-diagnostico-*.log # Logs de diagnóstico
├── dell-ms3320w-monitor-*.log     # Logs de monitoramento
├── dell-ms3320w-reconnect-*.log   # Logs de reconexão
├── dell-ms3320w-status.json       # Status atual (JSON)
└── reports/
    └── analise-*.md                # Relatórios de análise
```

---

## 🔍 Fluxo de Trabalho Recomendado

### Primeira Execução

1. **Instalação completa:**
   ```bash
   ./dell-ms3320w-setup.sh
   ```

2. **Revisar diagnóstico inicial:**
   ```bash
   cat ~/.local/logs/bluetooth/dell-ms3320w-diagnostico-*.log | tail -50
   ```

3. **Iniciar monitoramento manual (para testes):**
   ```bash
   ./dell-ms3320w-monitor.sh
   ```
   Deixe rodar por algumas horas para coletar dados.

### Uso Contínuo

1. **Instalar monitoramento automático:**
   ```bash
   ./dell-ms3320w-launchagent.sh
   ```

2. **Verificar status periodicamente:**
   ```bash
   cat ~/.local/logs/bluetooth/dell-ms3320w-status.json
   ```

3. **Analisar padrões (após 24-48h):**
   ```bash
   ./dell-ms3320w-analise.sh
   ```

### Troubleshooting

1. **Se o mouse desconectar:**
   - O sistema tentará reconectar automaticamente
   - Verifique logs: `tail -f ~/.local/logs/bluetooth/dell-ms3320w-*.log`

2. **Se a reconexão automática falhar:**
   ```bash
   ./dell-ms3320w-reconnect.sh
   ```

3. **Para diagnóstico completo:**
   ```bash
   ./dell-ms3320w-diagnostico.sh
   ```

---

## ⚙️ Configurações

### Ajustar Intervalo de Verificação

Edite `dell-ms3320w-monitor.sh` e modifique:
```bash
CHECK_INTERVAL=5  # Segundos entre verificações
```

### Ajustar Número de Tentativas de Reconexão

Edite `dell-ms3320w-reconnect.sh` e modifique:
```bash
MAX_RETRIES=5           # Número máximo de tentativas
RETRY_DELAY=3           # Delay inicial entre tentativas (segundos)
BACKOFF_MULTIPLIER=1.5  # Multiplicador de backoff exponencial
```

### Ajustar Nome do Dispositivo

Se o nome do mouse for diferente, edite os scripts e modifique:
```bash
MOUSE_NAME="MS3320W"
MOUSE_NAME_ALT="Dell.*Mouse"
```

---

## 📊 Interpretando os Logs

### Níveis de Log

- **INFO**: Informações gerais
- **SUCCESS**: Operação bem-sucedida
- **WARN**: Aviso (não crítico)
- **ERROR**: Erro detectado
- **DEBUG**: Informações detalhadas para troubleshooting

### Eventos Importantes

- `DESCONEXÃO DETECTADA`: Mouse desconectou
- `RECONEXÃO BEM-SUCEDIDA`: Mouse reconectou com sucesso
- `Tentativa X/Y de reconexão`: Tentativa de reconexão em andamento

### Arquivo de Status JSON

O arquivo `dell-ms3320w-status.json` contém:
```json
{
  "device": "Dell MS3320W",
  "status": "connected|disconnected",
  "timestamp": "2025-11-28T10:30:00Z",
  "last_check": "2025-11-28 10:30:00",
  "check_count": 1234,
  "disconnect_count": 5,
  "reconnect_count": 5
}
```

---

## 🐛 Troubleshooting

### Problema: Scripts não executam

**Solução:**
```bash
chmod +x ~/Dotfiles/scripts/bluetooth/*.sh
```

### Problema: blueutil não encontrado

**Solução:**
```bash
brew install blueutil
```

### Problema: bluetoothconnector não encontrado

**Solução:**
```bash
brew install bluetoothconnector
```

### Problema: Mouse não é detectado

**Soluções:**
1. Verificar se o mouse está ligado
2. Verificar bateria do mouse
3. Verificar se o mouse está no modo de pareamento
4. Executar diagnóstico: `./dell-ms3320w-diagnostico.sh`
5. Tentar parear manualmente via Preferências do Sistema

### Problema: Reconexão não funciona

**Soluções:**
1. Verificar se o mouse está no alcance
2. Verificar interferências (WiFi, outros dispositivos Bluetooth)
3. Tentar resetar Bluetooth: `blueutil -p 0 && sleep 2 && blueutil -p 1`
4. Verificar logs: `tail -f ~/.local/logs/bluetooth/dell-ms3320w-reconnect-*.log`

### Problema: LaunchAgent não inicia

**Soluções:**
1. Verificar logs: `cat ~/.local/logs/bluetooth/dell-ms3320w-launchagent.err.log`
2. Verificar permissões do script: `chmod +x ~/Dotfiles/scripts/bluetooth/dell-ms3320w-monitor.sh`
3. Recarregar: `launchctl unload ~/Library/LaunchAgents/com.dotfiles.dell-ms3320w-monitor.plist && launchctl load ~/Library/LaunchAgents/com.dotfiles.dell-ms3320w-monitor.plist`

---

## 🔒 Segurança e Privacidade

- Todos os logs são armazenados localmente em `~/.local/logs/bluetooth/`
- Nenhuma informação é enviada para serviços externos
- Logs podem conter endereços MAC e informações do sistema
- Recomenda-se revisar logs antes de compartilhar

---

## 📝 Notas Técnicas

### Métodos de Detecção de Conexão

O sistema usa múltiplos métodos para detectar se o mouse está conectado:
1. **IORegistry**: Verifica dispositivos USB/HID conectados
2. **system_profiler**: Verifica dispositivos Bluetooth pareados
3. **bluetoothconnector**: Lista dispositivos Bluetooth (se disponível)

### Métodos de Reconexão

O sistema tenta reconectar usando múltiplos métodos em ordem de preferência:
1. **bluetoothconnector**: Método mais direto e confiável
2. **Reset Bluetooth**: Desliga e liga o Bluetooth
3. **AppleScript**: Interface do sistema (método de fallback)

### Retry com Backoff Exponencial

O sistema implementa retry inteligente com backoff exponencial:
- Tentativa 1: Aguarda 3 segundos
- Tentativa 2: Aguarda 4.5 segundos (3 * 1.5)
- Tentativa 3: Aguarda 6.75 segundos (4.5 * 1.5)
- E assim por diante...

---

## 📚 Referências

- [blueutil GitHub](https://github.com/toy/blueutil)
- [bluetoothconnector GitHub](https://github.com/lapfelix/BluetoothConnector)
- [macOS LaunchAgent Documentation](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html)

---

## 🤝 Contribuindo

Para melhorias ou correções, edite os scripts conforme necessário. Todos os scripts são modulares e podem ser ajustados independentemente.

---

**Última atualização:** 2025-11-28
**Versão:** 1.0.0

