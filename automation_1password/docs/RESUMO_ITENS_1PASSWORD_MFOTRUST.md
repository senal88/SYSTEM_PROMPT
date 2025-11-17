# Resumo Completo - Itens 1Password para mfotrust.com

**Data:** 2025-11-17
**Vault:** 1p_vps
**Total de Itens:** 11

---

## 📋 Lista Completa de Itens

### Credenciais (3 itens)

#### 1. HOSTINGER_FTP_MFOTRUST (LOGIN)
- **Categoria:** LOGIN
- **Campos:** username, password, url, hostname
- **Tags:** environment:vps, service:hostinger, type:credentials, status:active, project:mfotrust

#### 2. HOSTINGER_SSH_MFOTRUST (LOGIN)
- **Categoria:** LOGIN
- **Campos:** username, password, hostname, port, url
- **Tags:** environment:vps, service:hostinger, type:credentials, status:inactive, project:mfotrust
- **Comando:** `ssh -p 65002 u452314665@185.173.111.131`

#### 3. HOSTINGER_MYSQL_MFOTRUST (DATABASE)
- **Categoria:** DATABASE
- **Campos:** hostname, port, database, username, password, connection_string
- **Tags:** environment:vps, service:hostinger, type:credentials, status:active, project:mfotrust, priority:high
- **Host:** srv1596.hstgr.io (ou 193.203.175.121)
- **Database:** u452314665_ufi6Z
- **User:** u452314665_VQw4W

---

### Informações Técnicas (8 itens)

#### 4. HOSTINGER_PLAN_DETAILS_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Detalhes completos do plano Business Web Hosting
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust, priority:high

#### 5. HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Informações do servidor (server1596, IPs, nameservers)
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

#### 6. HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Detalhes de configuração FTP (portas, protocolos, caminhos)
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

#### 7. HOSTINGER_MYSQL_REMOTE_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Configuração de acesso remoto MySQL
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

#### 8. HOSTINGER_PHPMYADMIN_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Informações de acesso ao phpMyAdmin
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

#### 9. HOSTINGER_GIT_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Configuração de Git e deployment
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

#### 10. HOSTINGER_IP_MANAGER_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Gerenciamento de IPs permitidos/bloqueados
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

#### 11. HOSTINGER_REDIRECTS_MFOTRUST (SECURE_NOTE)
- **Categoria:** SECURE_NOTE
- **Conteúdo:** Configuração de redirecionamentos 301
- **Tags:** environment:vps, service:hostinger, type:note, status:active, project:mfotrust

---

## 🚀 Scripts de Criação

### Script 1: Hospedagem Básica
```bash
./vaults-1password/scripts/criar-itens-hospedagem-1password.sh \
  --ftp-password SENHA_FTP
```

**Cria:**
- HOSTINGER_FTP_MFOTRUST
- HOSTINGER_PLAN_DETAILS_MFOTRUST
- HOSTINGER_SERVER_INFO_MFOTRUST
- HOSTINGER_FTP_DETAILS_MFOTRUST

### Script 2: Configurações Avançadas
```bash
./vaults-1password/scripts/criar-itens-configuracoes-avancadas-1password.sh \
  --ssh-password SENHA_SSH \
  --mysql-password SENHA_MYSQL
```

**Cria:**
- HOSTINGER_SSH_MFOTRUST
- HOSTINGER_MYSQL_MFOTRUST
- HOSTINGER_MYSQL_REMOTE_MFOTRUST
- HOSTINGER_PHPMYADMIN_MFOTRUST
- HOSTINGER_GIT_MFOTRUST
- HOSTINGER_IP_MANAGER_MFOTRUST
- HOSTINGER_REDIRECTS_MFOTRUST

---

## 📊 Estrutura Hierárquica

```
HOSTINGER_PLAN_DETAILS_MFOTRUST (SECURE_NOTE) [ROOT]
│
├── HOSTINGER_FTP_MFOTRUST (LOGIN)
├── HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)
│
├── HOSTINGER_SSH_MFOTRUST (LOGIN)
│
├── HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)
│
├── HOSTINGER_MYSQL_MFOTRUST (DATABASE) [HIGH PRIORITY]
│   ├── HOSTINGER_MYSQL_REMOTE_MFOTRUST (SECURE_NOTE)
│   └── HOSTINGER_PHPMYADMIN_MFOTRUST (SECURE_NOTE)
│
├── HOSTINGER_GIT_MFOTRUST (SECURE_NOTE)
├── HOSTINGER_IP_MANAGER_MFOTRUST (SECURE_NOTE)
└── HOSTINGER_REDIRECTS_MFOTRUST (SECURE_NOTE)
```

---

## ✅ Checklist Final

### Credenciais
- [ ] HOSTINGER_FTP_MFOTRUST (LOGIN)
- [ ] HOSTINGER_SSH_MFOTRUST (LOGIN)
- [ ] HOSTINGER_MYSQL_MFOTRUST (DATABASE)

### Informações
- [ ] HOSTINGER_PLAN_DETAILS_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_SERVER_INFO_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_FTP_DETAILS_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_MYSQL_REMOTE_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_PHPMYADMIN_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_GIT_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_IP_MANAGER_MFOTRUST (SECURE_NOTE)
- [ ] HOSTINGER_REDIRECTS_MFOTRUST (SECURE_NOTE)

### Validação
- [ ] Todos os itens criados
- [ ] Tags adicionadas corretamente
- [ ] Senhas preenchidas
- [ ] Relacionamentos documentados

---

## 🔗 Documentação Relacionada

- [Registrar Hospedagem](./REGISTRAR_HOSPEDAGEM_1PASSWORD.md)
- [Registrar Configurações Avançadas](./REGISTRAR_CONFIGURACOES_AVANCADAS_1PASSWORD.md)
- [Padrões de Nomenclatura](../standards/nomenclature.md)
- [Mapeamento de Categorias](../standards/categories.md)
- [Sistema de Tags](../standards/tags.md)

---

**Última atualização:** 2025-11-17

