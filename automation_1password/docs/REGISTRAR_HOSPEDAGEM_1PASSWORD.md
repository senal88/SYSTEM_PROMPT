# Registrar Informações de Hospedagem no 1Password

**Data:** 2025-11-17
**Domínio:** mfotrust.com
**Plano:** Business Web Hosting

---

## 📋 Informações a Registrar

### 1. Credenciais FTP (LOGIN)

**Item:** `HOSTINGER_FTP_MFOTRUST`
- **Categoria:** LOGIN
- **Vault:** 1p_vps
- **Campos:**
  - **username:** u452314665
  - **password:** [senha FTP do 1Password ou Hostinger]
  - **url:** ftp://mfotrust.com
  - **hostname:** ftp://185.173.111.131
  - **notes:** Credenciais FTP para mfotrust.com - Business Web Hosting
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:credentials
  - status:active
  - project:mfotrust

---

### 2. Informações do Plano (SECURE_NOTE)

**Item:** `HOSTINGER_PLAN_DETAILS_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    PLANO: Business Web Hosting
    DOMÍNIO: mfotrust.com
    EXPIRA: 2026-11-14

    RECURSOS:
    - Espaço em disco: 50 GB
    - RAM: 1536 MB
    - CPU: 2 núcleos
    - Inodes: 600.000
    - Addons/Sites: 50
    - Máximo de processos: 120
    - PHP workers: 60
    - Largura de banda: Ilimitado

    SERVIDOR:
    - Nome: server1596
    - Localização: South America (Brazil)
    - Backups: EUA
    - IP do site: 185.173.111.131

    ACESSO:
    - Site: https://mfotrust.com
    - Site WWW: https://www.mfotrust.com
    - FTP IP: ftp://185.173.111.131
    - FTP Host: ftp://mfotrust.com
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust
  - priority:high

---

### 3. Informações do Servidor (SECURE_NOTE)

**Item:** `HOSTINGER_SERVER_INFO_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    SERVIDOR: server1596
    LOCALIZAÇÃO: South America (Brazil)
    BACKUPS: EUA

    IP DO SITE: 185.173.111.131

    NAMESERVERS ATUAIS:
    - ns1.dns-parking.com
    - ns2.dns-parking.com

    NAMESERVERS HOSTINGER:
    - ns1.dns-parking.com
    - ns2.dns-parking.com

    NOTA: Nameservers estão como dns-parking (verificar se deve atualizar)
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

### 4. Detalhes FTP (SECURE_NOTE)

**Item:** `HOSTINGER_FTP_DETAILS_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    FTP - mfotrust.com

    IP: ftp://185.173.111.131
    Hostname: ftp://mfotrust.com
    Username: u452314665
    Password: [ver item HOSTINGER_FTP_MFOTRUST]

    CAMINHO DE UPLOAD:
    public_html

    PROTOCOLO: FTP
    PORTA: 21 (padrão)
    SEGURANÇA: FTPS recomendado (porta 990)
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

## 🔧 Como Criar os Itens

### Opção 1: Via Interface Web 1Password

1. Abrir 1Password
2. Selecionar vault: **1p_vps**
3. Criar cada item seguindo os templates acima
4. Adicionar tags conforme especificado

### Opção 2: Via CLI 1Password

```bash
# 1. Credenciais FTP
op item create \
  --category "LOGIN" \
  --title "HOSTINGER_FTP_MFOTRUST" \
  --vault "1p_vps" \
  username="u452314665" \
  password="[SENHA_FTP]" \
  url="ftp://mfotrust.com" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:credentials" \
  --tag "status:active" \
  --tag "project:mfotrust"

# 2. Informações do Plano
op item create \
  --category "SECURE_NOTE" \
  --title "HOSTINGER_PLAN_DETAILS_MFOTRUST" \
  --vault "1p_vps" \
  notesPlain="[conteúdo das notas acima]" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:note" \
  --tag "status:active" \
  --tag "project:mfotrust" \
  --tag "priority:high"

# 3. Informações do Servidor
op item create \
  --category "SECURE_NOTE" \
  --title "HOSTINGER_SERVER_INFO_MFOTRUST" \
  --vault "1p_vps" \
  notesPlain="[conteúdo das notas acima]" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:note" \
  --tag "status:active" \
  --tag "project:mfotrust"

# 4. Detalhes FTP
op item create \
  --category "SECURE_NOTE" \
  --title "HOSTINGER_FTP_DETAILS_MFOTRUST" \
  --vault "1p_vps" \
  notesPlain="[conteúdo das notas acima]" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:note" \
  --tag "status:active" \
  --tag "project:mfotrust"
```

---

## 📝 Checklist de Criação

- [ ] Item 1: HOSTINGER_FTP_MFOTRUST (LOGIN)
  - [ ] Username preenchido
  - [ ] Password preenchido
  - [ ] URL preenchida
  - [ ] Tags adicionadas

- [ ] Item 2: HOSTINGER_PLAN_DETAILS_MFOTRUST (SECURE_NOTE)
  - [ ] Todas as informações do plano
  - [ ] Detalhes do servidor
  - [ ] Tags adicionadas

- [ ] Item 3: HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)
  - [ ] Informações do servidor
  - [ ] IPs e nameservers
  - [ ] Tags adicionadas

- [ ] Item 4: HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)
  - [ ] Detalhes de conexão FTP
  - [ ] Caminhos e portas
  - [ ] Tags adicionadas

---

## 🔗 Relacionamento entre Itens

### Estrutura
```
HOSTINGER_PLAN_DETAILS_MFOTRUST (SECURE_NOTE)
  ├── Referencia: HOSTINGER_FTP_MFOTRUST (LOGIN)
  ├── Referencia: HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)
  └── Referencia: HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)

HOSTINGER_FTP_MFOTRUST (LOGIN)
  └── Credenciais principais FTP

HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)
  └── Informações técnicas do servidor

HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)
  └── Detalhes de configuração FTP
```

---

## ✅ Validação

Após criar os itens, verificar:

```bash
# Listar itens criados
op item list --vault "1p_vps" | grep -i "HOSTINGER.*MFOTRUST"

# Verificar um item específico
op item get "HOSTINGER_FTP_MFOTRUST" --vault "1p_vps"

# Validar tags
op item get "HOSTINGER_PLAN_DETAILS_MFOTRUST" --vault "1p_vps" --format json | jq '.tags'
```

---

## 🔗 Referências

- [Padrões de Nomenclatura](../standards/nomenclature.md)
- [Mapeamento de Categorias](../standards/categories.md)
- [Sistema de Tags](../standards/tags.md)
- [Templates de Itens](../templates/item-templates.yaml)

---

**Última atualização:** 2025-11-17

