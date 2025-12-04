# 📋 Registro e Verificação de Dispositivo no Hotspot (Baseado em MAC)

**Template para cadastro/ajuste de dispositivo no dashboard do Hotspot**

---

## 1. Dados do Hotspot / Controlador

### Informações do Sistema

- **Provedor / Sistema de Hotspot:** `{{HOTSPOT_NOME_PROVEDOR}}`
- **URL/IP do dashboard:** `{{HOTSPOT_DASHBOARD_URL}}`

### Tipo de Autenticação

- [ ] Usuário/Senha
- [ ] SSO / Diretório corporativo
- [ ] Token / API Key
- [ ] Outro: `{{HOTSPOT_TIPO_AUTENTICACAO_OUTRO}}`

### Credenciais de Acesso

- **Usuário administrador responsável:** `{{HOTSPOT_USUARIO_ADMIN}}`
- **Perfil/política associada** (VLAN, banda, QoS, tempo de sessão): `{{HOTSPOT_PERFIL_POLITICA}}`

### API Disponível

- [ ] Sim – endpoint: `{{HOTSPOT_API_ENDPOINT}}`
- [ ] Não

---

## 2. Dados do Dispositivo / Usuário

### Identificação do Usuário

- **Nome do usuário/linha:** `{{HOTSPOT_USUARIO_CONTA}}`
- **Identificador interno** (CPF/CNPJ/matrícula/etc.): `{{HOTSPOT_IDENTIFICADOR_INTERNO}}`
- **Nome do dispositivo no painel:** `{{HOTSPOT_NOME_DISPOSITIVO}}`

### Informações do Sistema

- **Sistema operacional:** macOS Tahoe 26.x (Apple Silicon)
- **Hostname** (hostname): `{{HOSTNAME_VAL}}`
- **ComputerName** (scutil): `{{COMPUTER_NAME_VAL}}`

---

## 3. Dados de Rede do Cliente

**Coletados automaticamente pelo script de diagnóstico**

- **IP local via DHCP:** `{{IP_ADDR}}`
- **Máscara de sub-rede:** `{{SUBNET_MASK}}`
- **Gateway/roteador:** `{{ROUTER_ADDR}}`
- **DNS configurado no cliente:** `{{DNS_LINE}}`

---

## 4. MACs Relevantes

### MACs Identificados

- **MAC atual em uso na interface Wi-Fi** (ifconfig): `{{MAC_IFCONFIG}}`
- **MAC associado ao serviço** (networksetup -getmacaddress): `{{MAC_SERVICE}}`
- **MAC informado na mensagem do Hotspot:** `{{HOTSPOT_MAC_INFORMADO}}`
- **Situação quanto a "Endereço Wi-Fi privado":** `{{PRIVATE_MAC_STATUS}}`

### Análise

- **Coincidência entre MACs:** `{{HOTSPOT_COMPAT_STATUS}}`

⚠️ **IMPORTANTE:** O MAC que será cadastrado deve ser o MAC que o Hotspot realmente enxerga na rede.

---

## 5. Registro / Ajuste no Dashboard

### MAC a ser Cadastrado

Selecione o MAC que será efetivamente cadastrado:

- [ ] **MAC atual em uso** (ifconfig): `{{MAC_IFCONFIG}}`
  - *Usar se o Hotspot enxergar este MAC*

- [ ] **MAC informado pelo Hotspot:** `{{HOTSPOT_MAC_INFORMADO}}`
  - *Usar se este for o MAC que o Hotspot reportou na mensagem*

- [ ] **MAC físico exigido por política interna:** `{{MAC_FISICO_POLITICA}}`
  - *Usar se a política exigir MAC físico (desativar "Endereço Wi-Fi privado")*

### Configurações no Dashboard

- **Política/perfil atribuído ao dispositivo:** `{{HOTSPOT_PERFIL_APLICADO}}`
- **Data/hora do cadastro ou ajuste:** `{{DATA_HORA_CADASTRO}}`
- **Responsável técnico pelo cadastro:** `{{RESPONSAVEL_CADASTRO}}`

---

## 6. Validação Pós-Cadastro

### Teste de Navegação

- [ ] Sim - Realizado com sucesso
- [ ] Não - Não realizado
- [ ] Parcial - Funcionou parcialmente

### Status no Dashboard

Após o cadastro e reconexão, verificar o status:

- [ ] Conectado / Ativo
- [ ] Bloqueado
- [ ] Em quarentena
- [ ] Pendente de aprovação

### Observações e Logs

**Mensagens do portal cativo:**
```
{{OBSERVACOES_PORTAL_CATIVO}}
```

**Logs adicionais:**
```
{{OBSERVACOES_LOGS}}
```

**Erros encontrados:**
```
{{ERROS_ENCONTRADOS}}
```

---

## 7. Checklist de Ações

### Antes do Cadastro

- [ ] Executar script de diagnóstico: `diagnostico_hotspot_mac.sh`
- [ ] Identificar o MAC correto a ser cadastrado
- [ ] Verificar política de MAC (físico vs privado)
- [ ] Revisar perfil/política a ser aplicada

### Durante o Cadastro

- [ ] Acessar dashboard do Hotspot
- [ ] Localizar/criar registro do dispositivo
- [ ] Cadastrar MAC correto
- [ ] Aplicar perfil/política adequada
- [ ] Salvar alterações

### Após o Cadastro

- [ ] Desconectar Wi-Fi do dispositivo
- [ ] Reconectar Wi-Fi para forçar nova autenticação
- [ ] Verificar se acesso é liberado
- [ ] Validar navegação na internet
- [ ] Verificar status no dashboard
- [ ] Documentar resultado

---

## 8. Troubleshooting

### Problema: MAC cadastrado mas acesso ainda bloqueado

**Possíveis causas:**
- MAC cadastrado não corresponde ao MAC em uso
- Cache de autenticação no Hotspot
- Política/perfil incorreto aplicado
- "Endereço Wi-Fi privado" ainda ativo

**Ações:**
1. Desconectar e reconectar Wi-Fi
2. Verificar MAC atual vs MAC cadastrado
3. Verificar se "Endereço Wi-Fi privado" está desativado (se necessário)
4. Aguardar alguns minutos para sincronização do dashboard
5. Contatar administrador do Hotspot se persistir

### Problema: MAC muda a cada conexão

**Causa:** "Endereço Wi-Fi privado" está ativo

**Solução:**
1. Desativar "Endereço Wi-Fi privado" nas configurações do macOS
2. Usar MAC físico para cadastro
3. Ou cadastrar múltiplos MACs no dashboard (se permitido)

---

## 9. Referências

- **Script de diagnóstico:** `diagnostico_hotspot_mac.sh`
- **Relatório gerado:** `diag_hotspot_YYYYMMDD_HHMMSS.md`
- **Log bruto:** `diag_hotspot_raw_YYYYMMDD_HHMMSS.log`

---

**Template criado em:** 2025-01-15
**Versão:** 1.0.0
**Status:** Pronto para uso

---

*Este template deve ser preenchido com os dados coletados pelo script de diagnóstico e com as informações específicas do dashboard do Hotspot.*
