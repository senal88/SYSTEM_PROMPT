# 🔍 Diagnóstico de Hotspot com Controle de Acesso por MAC

Solução completa para diagnosticar e resolver problemas de Hotspot com controle de acesso baseado em endereço MAC.

---

## 📋 Visão Geral

Esta solução foi desenvolvida para resolver problemas específicos de Hotspot que exigem cadastro de MAC no dashboard, especialmente em ambientes macOS (Apple Silicon) onde pode haver uso de "Endereço Wi-Fi privado".

### Cenário Típico

- **IP recebido:** `10.255.3.141` (IP privado atribuído via DHCP)
- **MAC informado pelo Hotspot:** `7A:93:43:66:C4:12`
- **Mensagem:** "O Hotspot não foi encontrado em nosso dashboard. Por favor, verifique se o MAC está devidamente cadastrado para continuar."

---

## 🚀 Uso Rápido

### 1. Executar Diagnóstico

```bash
cd ~/Dotfiles/scripts/network/hotspot-diagnosis
./diagnostico_hotspot_mac.sh
```

### 2. Revisar Relatório

O script gera automaticamente:

- **Relatório em Markdown:** `~/network_hotspot_diag/diag_hotspot_YYYYMMDD_HHMMSS.md`
- **Log bruto:** `~/network_hotspot_diag/diag_hotspot_raw_YYYYMMDD_HHMMSS.log`

### 3. Preencher Template para Cadastro

Use o template `TEMPLATE_HOTSPOT_REGISTRO_MAC.md` com os dados coletados para facilitar o cadastro no dashboard do Hotspot.

---

## 📁 Arquivos da Solução

### Scripts

- **`diagnostico_hotspot_mac.sh`** - Script principal de diagnóstico
  - Identifica serviço Wi-Fi e interface
  - Coleta dados de rede (IP, MAC, gateway, DNS)
  - Analisa uso de MAC privado vs MAC físico
  - Compara com dados informados pelo Hotspot
  - Gera relatório completo em Markdown

### Templates

- **`TEMPLATE_HOTSPOT_REGISTRO_MAC.md`** - Template para cadastro no dashboard
  - Campos para informações do Hotspot
  - Dados do dispositivo
  - MACs relevantes
  - Checklist de ações
  - Troubleshooting

### Documentação

- **`README.md`** - Este arquivo

---

## 🔧 Configuração

### Ajustar Dados do Hotspot

Edite o script `diagnostico_hotspot_mac.sh` e ajuste as variáveis no início:

```bash
HOTSPOT_IP_INFORMADO="10.255.3.141"
HOTSPOT_MAC_INFORMADO="7A:93:43:66:C4:12"
```

---

## 📊 O que o Script Faz

### 1. Identificação

- Identifica o serviço Wi-Fi ativo
- Localiza a interface física (ex: `en0`)
- Coleta informações do sistema (hostname, ComputerName)

### 2. Coleta de Dados

- **IP e configuração de rede:**
  - IP local via DHCP
  - Máscara de sub-rede
  - Gateway/roteador
  - Servidores DNS

- **Endereços MAC:**
  - MAC atual em uso (ifconfig)
  - MAC associado ao serviço (networksetup)
  - Comparação entre eles

### 3. Análise

- Detecta uso de "Endereço Wi-Fi privado"
- Compara MAC atual com MAC informado pelo Hotspot
- Identifica divergências

### 4. Relatório

- Gera relatório estruturado em Markdown
- Inclui logs brutos de todos os comandos
- Facilita envio para suporte técnico

---

## 🎯 Interpretação da Mensagem do Hotspot

### O que significa "Hotspot não foi encontrado em nosso dashboard"?

1. O sistema de Hotspot buscou o MAC apresentado na base de dispositivos cadastrados
2. **Não encontrou** esse MAC na lista de dispositivos autorizados
3. Por política de segurança, bloqueou ou não completou a autorização de acesso

### Condição Necessária

O dispositivo é liberado somente quando:

> O endereço MAC que o cliente está efetivamente usando na rede (naquele SSID) **coincide** com o endereço MAC cadastrado no dashboard.

---

## ⚠️ Endereço Wi-Fi Privado

### O que é?

Em ambientes Apple modernos, é comum o uso de **"Endereço Wi-Fi privado"** (MAC aleatório por SSID). Nesses casos:

- O Hotspot enxerga um MAC diferente do MAC físico da placa
- Se o dashboard estiver configurado com o MAC físico, e o cliente estiver usando MAC privado, haverá divergência
- O acesso não será reconhecido

### Soluções

1. **Desativar "Endereço Wi-Fi privado"** nas configurações do macOS
2. **Usar MAC físico** para cadastro no dashboard
3. **Cadastrar múltiplos MACs** no dashboard (se permitido pela política)

---

## 📝 Exemplo de Uso

### Passo 1: Executar Diagnóstico

```bash
./diagnostico_hotspot_mac.sh
```

**Saída esperada:**
```
╔════════════════════════════════════════════════════════════════════════════╗
║ 🔍 IDENTIFICAÇÃO DO SERVIÇO Wi-Fi
╚════════════════════════════════════════════════════════════════════════════╝

[✅] Serviço Wi-Fi identificado: Wi-Fi
[✅] Interface física identificada: en0

...

[✅] Diagnóstico concluído.
```

### Passo 2: Revisar Relatório

```bash
open ~/network_hotspot_diag/diag_hotspot_*.md
```

### Passo 3: Preencher Template

1. Abrir `TEMPLATE_HOTSPOT_REGISTRO_MAC.md`
2. Preencher com dados do relatório
3. Adicionar informações específicas do Hotspot
4. Usar para cadastro no dashboard

---

## 🔍 Troubleshooting

### Problema: Script não encontra serviço Wi-Fi

**Solução:**
- Verificar se Wi-Fi está ativo: `networksetup -listallnetworkservices`
- Verificar se interface existe: `ifconfig -a`

### Problema: MACs não coincidem

**Solução:**
- Verificar se "Endereço Wi-Fi privado" está ativo
- Desativar se necessário
- Usar o MAC que o Hotspot realmente enxerga

### Problema: Acesso ainda bloqueado após cadastro

**Solução:**
1. Desconectar e reconectar Wi-Fi
2. Aguardar sincronização do dashboard
3. Verificar se MAC cadastrado corresponde ao MAC em uso
4. Contatar administrador do Hotspot

---

## 📚 Referências Técnicas

### Comandos macOS Utilizados

- `networksetup` - Configuração de rede
- `ifconfig` - Informações de interface
- `route` - Tabela de roteamento
- `scutil` - Configurações do sistema

### Formato MAC

- Padrão: `XX:XX:XX:XX:XX:XX` (hexadecimal separado por dois pontos)
- Comparação é case-insensitive na maioria dos sistemas

---

## ✅ Checklist de Resolução

- [ ] Executar script de diagnóstico
- [ ] Identificar MAC correto a ser cadastrado
- [ ] Verificar política de MAC (físico vs privado)
- [ ] Preencher template para cadastro
- [ ] Cadastrar MAC no dashboard do Hotspot
- [ ] Desconectar e reconectar Wi-Fi
- [ ] Validar acesso liberado
- [ ] Documentar resultado

---

**Versão:** 1.0.0
**Data:** 2025-01-15
**Status:** ✅ Ativo e Funcional

---

*Esta solução foi desenvolvida especificamente para o caso: IP `10.255.3.141`, MAC `7A:93:43:66:C4:12` em ambiente macOS Tahoe 26.x (Apple Silicon).*
