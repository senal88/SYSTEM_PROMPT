# Scripts de Diagnóstico e Correção de Rede

Este diretório contém scripts para diagnosticar e corrigir problemas de conectividade de rede, especialmente relacionados a erros DNS e redes não confiáveis.

## 📋 Scripts Disponíveis

### 1. `diagnose-dns-error.sh`
**Diagnóstico completo de problemas DNS**

Executa uma análise detalhada do sistema de rede para identificar problemas de resolução DNS e conectividade.

**Uso:**
```bash
./diagnose-dns-error.sh [domínio]
```

**Exemplo:**
```bash
./diagnose-dns-error.sh api2.cursor.sh
```

**O que faz:**
- ✅ Verifica conectividade básica
- ✅ Analisa servidores DNS configurados
- ✅ Testa resolução DNS para o domínio alvo
- ✅ Verifica conectividade TCP/HTTPS
- ✅ Analisa configurações de firewall e proxy
- ✅ Verifica status de rede confiável (macOS)
- ✅ Gera relatório completo com recomendações

**Saída:**
- Log detalhado em `~/.dotfiles/logs/dns-diagnostic-YYYYMMDD_HHMMSS.log`
- Relatório colorido no terminal com status de cada verificação

---

### 2. `fix-dns-and-trust-network.sh`
**Correção automática de DNS e rede confiável**

Corrige automaticamente problemas de DNS e configura a rede para ser confiável, especialmente útil em redes públicas (como Insper).

**Uso:**
```bash
./fix-dns-and-trust-network.sh [domínio]
```

**Exemplo:**
```bash
./fix-dns-and-trust-network.sh api2.cursor.sh
```

**O que faz:**
- ✅ Configura servidores DNS confiáveis (Google: 8.8.8.8, 8.8.4.4 e Cloudflare: 1.1.1.1, 1.0.0.1)
- ✅ Limpa cache DNS do sistema
- ✅ Configura rede para permitir conexões diretas
- ✅ Desabilita proxy automático se configurado
- ✅ Verifica e configura firewall para Cursor.app
- ✅ Testa conectividade após correções
- ✅ Cria script de manutenção contínua

**Requer:**
- Permissões sudo para algumas operações (será solicitado)

**Nota:** Algumas configurações de rede confiável no macOS requerem ação manual (veja instruções no final da execução).

---

### 3. `test-cursor-connectivity.sh`
**Teste rápido de conectividade**

Executa testes rápidos de conectividade para verificar se o problema foi resolvido.

**Uso:**
```bash
./test-cursor-connectivity.sh [domínio]
```

**Exemplo:**
```bash
./test-cursor-connectivity.sh api2.cursor.sh
```

**O que faz:**
- ✅ Testa conectividade básica
- ✅ Testa resolução DNS
- ✅ Testa conexão HTTPS
- ✅ Testa porta 443
- ✅ Fornece feedback visual rápido

---

## 🚀 Fluxo de Uso Recomendado

### Para resolver erro "getaddrinfo ENOTFOUND api2.cursor.sh":

1. **Diagnosticar o problema:**
   ```bash
   cd ~/Dotfiles/scripts/network
   ./diagnose-dns-error.sh api2.cursor.sh
   ```

2. **Aplicar correções automáticas:**
   ```bash
   ./fix-dns-and-trust-network.sh api2.cursor.sh
   ```

3. **Seguir instruções manuais** (se aparecerem):
   - Tornar rede confiável em System Preferences
   - Configurar firewall se necessário
   - Completar autenticação em portal captivo (se aplicável)

4. **Verificar se foi resolvido:**
   ```bash
   ./test-cursor-connectivity.sh api2.cursor.sh
   ```

---

## 🔧 Configuração para Redes Públicas (Insper, etc.)

### Problema Comum
Em redes públicas, o macOS pode bloquear conexões para serviços externos por questões de segurança.

### Solução Automática
O script `fix-dns-and-trust-network.sh` tenta automatizar o máximo possível, mas algumas configurações requerem ação manual:

1. **Tornar rede confiável:**
   - System Preferences > Network
   - Selecione sua conexão (Wi-Fi/Ethernet) > Advanced
   - Aba "Proxies" > Desmarque "Automatic Proxy Configuration"
   - Clique em "OK" e "Apply"

2. **Verificar firewall:**
   - System Preferences > Security & Privacy > Firewall
   - Se ativo, adicione Cursor.app nas exceções

3. **Portal captivo:**
   - Se a rede requer autenticação, abra um navegador primeiro
   - Complete a autenticação
   - Depois execute os scripts novamente

---

## 📊 Logs

Todos os scripts geram logs detalhados em:
- `~/.dotfiles/logs/dns-diagnostic-*.log` (diagnóstico)
- `~/.dotfiles/logs/network-fix-*.log` (correções)

---

## 🛠️ Manutenção

O script de correção cria automaticamente um script de manutenção contínua:
- `~/Dotfiles/scripts/network/maintain-network-trust.sh`

Este script pode ser executado periodicamente para manter as configurações de DNS corretas.

---

## ⚠️ Troubleshooting

### Problema: Script não consegue configurar DNS
**Solução:** Execute com sudo ou configure manualmente em System Preferences > Network > Advanced > DNS

### Problema: Rede ainda não confiável após script
**Solução:** Siga as instruções manuais exibidas pelo script. macOS não permite tornar redes confiáveis completamente via linha de comando.

### Problema: Conectividade funciona mas Cursor ainda falha
**Solução:**
1. Verifique se Cursor.app está nas exceções do firewall
2. Reinicie o Cursor.app
3. Verifique se há atualizações pendentes do Cursor

### Problema: Portal captivo bloqueando
**Solução:**
1. Abra um navegador e complete a autenticação
2. Aguarde alguns segundos
3. Execute os scripts novamente

---

## 📝 Notas Técnicas

### DNS Servers Configurados
- **Google DNS:** 8.8.8.8, 8.8.4.4
- **Cloudflare DNS:** 1.1.1.1, 1.0.0.1

### Cache DNS
O script limpa o cache DNS usando:
- `dscacheutil -flushcache`
- `killall -HUP mDNSResponder`

### Compatibilidade
- ✅ macOS 10.14+ (Mojave e superior)
- ✅ Requer `networksetup` (incluído no macOS)
- ✅ Requer `curl` (incluído no macOS)

---

## 🔗 Referências

- [Apple - networksetup](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/networksetup.8.html)
- [macOS Network Configuration](https://support.apple.com/guide/terminal/configure-network-settings-apdb66b5242-4d78-4d75-9cda-1de894efe949/mac)
- [Cursor Documentation](https://cursor.sh/docs)

---

**Última atualização:** 2025-01-17
**Versão:** 1.0.0
