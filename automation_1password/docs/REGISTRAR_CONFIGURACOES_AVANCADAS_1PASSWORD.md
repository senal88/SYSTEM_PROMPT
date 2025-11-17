# Registrar Configurações Avançadas no 1Password

**Data:** 2025-11-17
**Domínio:** mfotrust.com
**Plano:** Business Web Hosting

---

## 📋 Informações a Registrar

### 1. Acesso SSH (LOGIN)

**Item:** `HOSTINGER_SSH_MFOTRUST`
- **Categoria:** LOGIN
- **Vault:** 1p_vps
- **Campos:**
  - **username:** u452314665
  - **password:** [senha SSH do 1Password ou Hostinger]
  - **hostname:** 185.173.111.131
  - **port:** 65002
  - **url:** ssh://u452314665@185.173.111.131:65002
  - **notes:** Acesso SSH para mfotrust.com - Porta 65002 - Status: INACTIVE (habilitar se necessário)
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:credentials
  - status:inactive
  - project:mfotrust

**Comando SSH:**
```bash
ssh -p 65002 u452314665@185.173.111.131
```

---

### 2. Banco de Dados MySQL (DATABASE)

**Item:** `HOSTINGER_MYSQL_MFOTRUST`
- **Categoria:** DATABASE
- **Vault:** 1p_vps
- **Campos:**
  - **hostname:** srv1596.hstgr.io (ou 193.203.175.121)
  - **port:** 3306
  - **database:** u452314665_ufi6Z
  - **username:** u452314665_VQw4W
  - **password:** [senha MySQL do 1Password]
  - **connection_string:** mysql://u452314665_VQw4W:[senha]@srv1596.hstgr.io:3306/u452314665_ufi6Z
  - **notes:** Banco de dados MySQL para mfotrust.com - Criado em 2025-11-14 - Tamanho: 3 MB
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:credentials
  - status:active
  - project:mfotrust
  - priority:high

**Informações Adicionais:**
- **Host alternativo:** 193.203.175.121
- **phpMyAdmin:** Disponível via painel Hostinger
- **Acesso remoto:** Configurável via MySQL Remoto

---

### 3. MySQL Remoto (SECURE_NOTE)

**Item:** `HOSTINGER_MYSQL_REMOTE_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    MYSQL REMOTO - mfotrust.com

    HOSTS DISPONÍVEIS:
    - srv1596.hstgr.io (recomendado)
    - 193.203.175.121 (IP alternativo)

    PORTA: 3306

    BANCO DE DADOS: u452314665_ufi6Z
    USUÁRIO: u452314665_VQw4W
    SENHA: [ver item HOSTINGER_MYSQL_MFOTRUST]

    CONFIGURAÇÃO:
    - Acesso remoto deve ser habilitado no painel
    - IPs permitidos devem ser configurados
    - Firewall deve permitir porta 3306

    CONEXÃO:
    mysql -h srv1596.hstgr.io -u u452314665_VQw4W -p u452314665_ufi6Z
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

### 4. phpMyAdmin (SECURE_NOTE)

**Item:** `HOSTINGER_PHPMYADMIN_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    PHPMYADMIN - mfotrust.com

    ACESSO:
    - Via painel Hostinger: Sites → mfotrust.com → Bancos de Dados → PHP My Admin
    - Link direto disponível no painel

    CREDENCIAIS:
    - Usuário: u452314665_VQw4W
    - Senha: [ver item HOSTINGER_MYSQL_MFOTRUST]
    - Banco: u452314665_ufi6Z

    NOTA: Para login via link direto, usar credenciais do banco de dados
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

### 5. GIT (SECURE_NOTE)

**Item:** `HOSTINGER_GIT_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    GIT - mfotrust.com

    REPOSITÓRIO GIT PRIVADO:
    - Chave SSH disponível no painel
    - Adicionar chave ao GitHub/Bitbucket para repositórios privados

    DEPLOYMENT:
    - Repositórios públicos: https://github.com/user/repo.git
    - Repositórios privados: git@github.com:user/repo.git
    - Diretório padrão: public_html
    - Diretório deve estar vazio para deploy

    CONFIGURAÇÃO:
    - Gerar chave SSH no painel se necessário
    - Configurar repositório e branch
    - Especificar diretório de instalação (opcional)
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

### 6. Gerenciador de IP (SECURE_NOTE)

**Item:** `HOSTINGER_IP_MANAGER_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    GERENCIADOR DE IP - mfotrust.com

    FUNCIONALIDADES:
    1. Permitir Endereço de IP
       - Liberar IPs bloqueados
       - Acesso ao site

    2. Bloquear Endereço de IP
       - Bloquear IPs específicos
       - Proteção contra acesso não autorizado

    USO:
    - IPs permitidos: Para liberar acesso
    - IPs bloqueados: Para restringir acesso
    - Notas: Documentar motivo de cada IP

    LOCALIZAÇÃO:
    Painel → Sites → mfotrust.com → Avançado → Gerenciador de IP
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

### 7. Redirecionamentos (SECURE_NOTE)

**Item:** `HOSTINGER_REDIRECTS_MFOTRUST`
- **Categoria:** SECURE_NOTE
- **Vault:** 1p_vps
- **Campos:**
  - **notes:**
    ```
    REDIRECIONAMENTOS - mfotrust.com

    TIPO: Redirecionamento 301 (Permanente)

    CONFIGURAÇÃO:
    - Redirecionar: http://mfotrust.com/caminho
    - Redirecionar para: http://dominio.com
    - Pode usar URL ou IP

    NOTA IMPORTANTE:
    - Para HTTPS, usar opção "Forçar SSL" na área SSL
    - Não usar redirecionamento para HTTPS

    LOCALIZAÇÃO:
    Painel → Sites → mfotrust.com → Domínios → Redirecionamentos
    ```
- **Tags:**
  - environment:vps
  - service:hostinger
  - type:note
  - status:active
  - project:mfotrust

---

## 🔧 Como Criar os Itens

### Via CLI 1Password

```bash
# 1. Acesso SSH
op item create \
  --category "LOGIN" \
  --title "HOSTINGER_SSH_MFOTRUST" \
  --vault "1p_vps" \
  username="u452314665" \
  password="[SENHA_SSH]" \
  hostname="185.173.111.131" \
  port="65002" \
  url="ssh://u452314665@185.173.111.131:65002" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:credentials" \
  --tag "status:inactive" \
  --tag "project:mfotrust"

# 2. Banco de Dados MySQL
op item create \
  --category "DATABASE" \
  --title "HOSTINGER_MYSQL_MFOTRUST" \
  --vault "1p_vps" \
  hostname="srv1596.hstgr.io" \
  port="3306" \
  database="u452314665_ufi6Z" \
  username="u452314665_VQw4W" \
  password="[SENHA_MYSQL]" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:credentials" \
  --tag "status:active" \
  --tag "project:mfotrust" \
  --tag "priority:high"

# 3-7. Secure Notes (usar script automatizado)
```

---

## 📝 Checklist Completo

### Credenciais
- [ ] HOSTINGER_SSH_MFOTRUST (LOGIN)
  - [ ] Username, password, hostname, port
  - [ ] Tags adicionadas
  - [ ] Status: inactive (habilitar se necessário)

- [ ] HOSTINGER_MYSQL_MFOTRUST (DATABASE)
  - [ ] Hostname, port, database, username, password
  - [ ] Connection string
  - [ ] Tags adicionadas
  - [ ] Priority: high

### Informações Técnicas
- [ ] HOSTINGER_MYSQL_REMOTE_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_PHPMYADMIN_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_GIT_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_IP_MANAGER_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_REDIRECTS_MFOTRUST (SECURE_NOTE)

---

## 🔗 Relacionamentos

```
HOSTINGER_PLAN_DETAILS_MFOTRUST
  ├── HOSTINGER_SSH_MFOTRUST
  ├── HOSTINGER_MYSQL_MFOTRUST
  │   ├── HOSTINGER_MYSQL_REMOTE_MFOTRUST
  │   └── HOSTINGER_PHPMYADMIN_MFOTRUST
  ├── HOSTINGER_GIT_MFOTRUST
  ├── HOSTINGER_IP_MANAGER_MFOTRUST
  └── HOSTINGER_REDIRECTS_MFOTRUST
```

---

## ✅ Validação

```bash
# Verificar todos os itens criados
op item list --vault "1p_vps" | grep -i "HOSTINGER.*MFOTRUST"

# Verificar item específico
op item get "HOSTINGER_SSH_MFOTRUST" --vault "1p_vps"
op item get "HOSTINGER_MYSQL_MFOTRUST" --vault "1p_vps"
```

---

**Última atualização:** 2025-11-17

