# Diagnóstico e Correção: Erro getaddrinfo ENOTFOUND api2.cursor.sh

## 📋 Resumo Executivo

**Erro:** `ConnectError: [unavailable] getaddrinfo ENOTFOUND api2.cursor.sh`
**Request ID:** 05e1cca2-11c1-453d-a592-57ca3e1ab327
**Contexto:** Ambiente de desenvolvimento Cursor.app no macOS
**Severidade:** Alta (bloqueia funcionalidades do Cursor)

---

## 🔍 Diagnóstico Detalhado

### 1. Análise do Erro

O erro `getaddrinfo ENOTFOUND` indica que o sistema não consegue resolver o nome de domínio `api2.cursor.sh` para um endereço IP. Este é um erro de resolução DNS (Domain Name System).

**Stack Trace:**
```
ConnectError: [unavailable] getaddrinfo ENOTFOUND api2.cursor.sh
```

**Possíveis Causas:**

1. **Problemas de DNS:**
   - Servidores DNS não respondendo
   - DNS bloqueado ou filtrado pela rede
   - Cache DNS corrompido
   - Configuração DNS incorreta

2. **Rede Não Confiável (macOS):**
   - macOS bloqueia conexões em redes públicas por padrão
   - Proxy automático configurado incorretamente
   - Firewall bloqueando conexões

3. **Problemas de Conectividade:**
   - Rede desconectada ou instável
   - Portal captivo não autenticado
   - Firewall de rede bloqueando

4. **Problemas Específicos do Cursor:**
   - Cursor.app não tem permissões de rede
   - Firewall do macOS bloqueando Cursor
   - Proxy configurado no Cursor mas não funcionando

### 2. Contexto de Execução

**Sistema Operacional:** macOS (darwin 25.1.0)
**Aplicação:** Cursor.app
**Domínio Afetado:** api2.cursor.sh
**Ambiente:** Desenvolvimento local

**Observações:**
- O erro ocorre quando o Cursor tenta se conectar à API
- Pode afetar funcionalidades que dependem de conexão com servidores
- Especialmente comum em redes públicas (universidades, cafés, etc.)

---

## 💡 Solução Proposta

### Abordagem: Correção Automatizada em Múltiplas Camadas

A solução proposta utiliza uma abordagem em camadas para garantir máxima compatibilidade e robustez:

1. **Camada 1: Diagnóstico Automático**
   - Identifica a causa raiz do problema
   - Verifica todas as configurações relevantes
   - Gera relatório detalhado

2. **Camada 2: Correção Automática**
   - Configura DNS confiável
   - Limpa cache DNS
   - Configura rede para permitir conexões

3. **Camada 3: Configuração Manual (quando necessário)**
   - Instruções claras para ações manuais
   - Guia passo a passo para tornar rede confiável
   - Verificação de firewall e proxy

4. **Camada 4: Validação e Teste**
   - Testes de conectividade após correções
   - Verificação de resolução DNS
   - Teste de conexão HTTPS

### Vantagens da Abordagem

- ✅ **Minimamente Invasiva:** Não altera configurações desnecessárias
- ✅ **Robusta:** Funciona em diferentes cenários de rede
- ✅ **Transparente:** Logs detalhados de todas as operações
- ✅ **Recuperável:** Pode ser executado múltiplas vezes sem problemas
- ✅ **Educativa:** Explica o que está sendo feito e por quê

---

## 🛠️ Implementação

### Scripts Criados

#### 1. `diagnose-dns-error.sh`
Script de diagnóstico completo que:
- Verifica conectividade básica
- Analisa servidores DNS
- Testa resolução DNS
- Verifica firewall e proxy
- Gera relatório com recomendações

**Localização:** `~/Dotfiles/scripts/network/diagnose-dns-error.sh`

#### 2. `fix-dns-and-trust-network.sh`
Script de correção automática que:
- Configura DNS confiável (Google + Cloudflare)
- Limpa cache DNS
- Configura rede para conexões diretas
- Verifica firewall
- Testa conectividade após correções

**Localização:** `~/Dotfiles/scripts/network/fix-dns-and-trust-network.sh`

#### 3. `test-cursor-connectivity.sh`
Script de teste rápido que:
- Testa conectividade básica
- Testa resolução DNS
- Testa conexão HTTPS
- Fornece feedback visual

**Localização:** `~/Dotfiles/scripts/network/test-cursor-connectivity.sh`

### Passos de Implementação

#### Passo 1: Executar Diagnóstico
```bash
cd ~/Dotfiles/scripts/network
./diagnose-dns-error.sh api2.cursor.sh
```

**Resultado Esperado:**
- Identificação da causa raiz
- Relatório detalhado com status de cada verificação
- Log salvo em `~/.dotfiles/logs/dns-diagnostic-*.log`

#### Passo 2: Aplicar Correções Automáticas
```bash
./fix-dns-and-trust-network.sh api2.cursor.sh
```

**O que faz:**
1. Identifica interface de rede ativa
2. Configura DNS confiável (8.8.8.8, 8.8.4.4, 1.1.1.1, 1.0.0.1)
3. Limpa cache DNS do sistema
4. Desabilita proxy automático se configurado
5. Verifica configurações de firewall
6. Testa conectividade após correções

**Requer:** Permissões sudo (será solicitado)

#### Passo 3: Ações Manuais (se necessário)

Se o script indicar que ações manuais são necessárias:

**A. Tornar Rede Confiável:**
1. System Preferences > Network
2. Selecione sua conexão (Wi-Fi/Ethernet) > Advanced
3. Aba "Proxies" > Desmarque "Automatic Proxy Configuration"
4. Clique em "OK" e "Apply"

**B. Configurar Firewall:**
1. System Preferences > Security & Privacy > Firewall
2. Se ativo, clique em "Firewall Options"
3. Adicione Cursor.app nas exceções se necessário

**C. Portal Captivo (se aplicável):**
1. Abra um navegador
2. Complete a autenticação da rede
3. Aguarde alguns segundos
4. Execute os scripts novamente

#### Passo 4: Validar Correção
```bash
./test-cursor-connectivity.sh api2.cursor.sh
```

**Resultado Esperado:**
- Todos os testes passando (✅)
- DNS resolvendo corretamente
- Conexão HTTPS funcionando

### Estrutura de Arquivos

```
~/Dotfiles/
├── scripts/
│   └── network/
│       ├── diagnose-dns-error.sh          # Diagnóstico completo
│       ├── fix-dns-and-trust-network.sh   # Correção automática
│       ├── test-cursor-connectivity.sh    # Teste rápido
│       ├── maintain-network-trust.sh      # Manutenção contínua (gerado)
│       └── README.md                       # Documentação
├── docs/
│   └── DIAGNOSTICO_ERRO_DNS_CURSOR.md     # Este documento
└── logs/
    ├── dns-diagnostic-*.log               # Logs de diagnóstico
    └── network-fix-*.log                   # Logs de correção
```

---

## 🔬 Detalhes Técnicos

### Resolução DNS no macOS

O macOS usa o `mDNSResponder` para gerenciar resolução DNS. O processo de resolução segue esta ordem:

1. **Cache DNS local** (`dscacheutil`)
2. **Servidores DNS configurados** (via `networksetup`)
3. **mDNS (Bonjour)** para resolução local
4. **Fallback para DNS públicos**

### Comandos Utilizados

**Configurar DNS:**
```bash
networksetup -setdnsservers "Wi-Fi" 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1
```

**Limpar Cache DNS:**
```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

**Verificar DNS:**
```bash
networksetup -getdnsservers "Wi-Fi"
scutil --dns
```

**Testar Resolução:**
```bash
nslookup api2.cursor.sh
dig +short api2.cursor.sh
host api2.cursor.sh
```

### Redes Confiáveis no macOS

macOS classifica redes como "confiáveis" ou "não confiáveis" baseado em:
- Tipo de rede (pública/privada)
- Configurações de proxy
- Histórico de conexão

**Problema:** macOS não permite tornar redes confiáveis completamente via linha de comando. Algumas configurações requerem ação manual através de System Preferences.

**Solução Parcial:** Desabilitar proxy automático e configurar DNS manualmente ajuda, mas a configuração completa de "rede confiável" requer ação manual.

---

## 📊 Considerações Finais

### Limitações

1. **Redes Confiáveis:**
   - macOS não permite tornar redes confiáveis completamente via CLI
   - Requer ação manual em System Preferences
   - Script fornece instruções claras

2. **Firewall:**
   - Verificação de firewall requer permissões elevadas
   - Adição de exceções pode requerer ação manual
   - Script verifica e orienta

3. **Portal Captivo:**
   - Não pode ser automatizado
   - Requer autenticação manual no navegador
   - Script detecta e orienta

### Trabalhos Futuros

1. **Automação Adicional:**
   - Integração com System Preferences via AppleScript
   - Detecção automática de portal captivo
   - Configuração automática de firewall

2. **Monitoramento:**
   - Script de monitoramento contínuo
   - Alertas quando problemas são detectados
   - Relatórios periódicos

3. **Suporte Multiplataforma:**
   - Versão para Linux
   - Versão para Windows
   - Suporte para diferentes distribuições

### Implicações da Solução

**Positivas:**
- ✅ Resolve o problema na maioria dos casos
- ✅ Minimamente invasiva
- ✅ Fácil de reverter se necessário
- ✅ Educativa (usuário entende o que está sendo feito)

**Cuidados:**
- ⚠️ Requer permissões sudo para algumas operações
- ⚠️ Altera configurações de DNS (pode afetar outros aplicativos)
- ⚠️ Algumas configurações requerem ação manual

**Reversibilidade:**
- Todas as alterações podem ser revertidas
- DNS pode ser resetado para automático
- Cache DNS é temporário (limpa automaticamente)

---

## 📚 Referências

- [Apple - networksetup Manual](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/networksetup.8.html)
- [macOS Network Configuration](https://support.apple.com/guide/terminal/configure-network-settings-apdb66b5242-4d78-4d75-9cda-1de894efe949/mac)
- [DNS Resolution in macOS](https://developer.apple.com/documentation/foundation/urlsessionconfiguration)
- [Cursor Documentation](https://cursor.sh/docs)
- [getaddrinfo Error Codes](https://man7.org/linux/man-pages/man3/getaddrinfo.3.html)

---

## 🎯 Conclusão

A solução proposta oferece uma abordagem robusta e automatizada para resolver o erro `getaddrinfo ENOTFOUND api2.cursor.sh`. Através de diagnóstico detalhado, correção automática e instruções claras para ações manuais, o problema pode ser resolvido na maioria dos casos.

Os scripts criados são:
- ✅ **Completos:** Cobrem todos os aspectos do problema
- ✅ **Robustos:** Funcionam em diferentes cenários
- ✅ **Transparentes:** Logs detalhados de todas as operações
- ✅ **Educativos:** Explicam o que está sendo feito

**Próximos Passos:**
1. Execute o diagnóstico: `./diagnose-dns-error.sh api2.cursor.sh`
2. Aplique correções: `./fix-dns-and-trust-network.sh api2.cursor.sh`
3. Siga instruções manuais se necessário
4. Valide: `./test-cursor-connectivity.sh api2.cursor.sh`

---

**Última atualização:** 2025-01-17
**Versão:** 1.0.0
**Autor:** Sistema de Diagnóstico Automatizado
