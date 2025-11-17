# Registrar Informações PHP no 1Password

**Data:** 2025-11-17
**Domínio:** mfotrust.com
**Servidor:** br-asc-web1596.main-hosting.eu

---

## 📋 Informações PHP a Registrar

### Item: HOSTINGER_PHP_INFO_MFOTRUST (SECURE_NOTE)

**Categoria:** SECURE_NOTE
**Vault:** 1p_vps

**Campos:**
- **notes:**
  ```
  INFORMAÇÕES PHP - mfotrust.com

  VERSÃO: PHP 8.2.28
  SERVIDOR: br-asc-web1596.main-hosting.eu
  SISTEMA: Linux 5.14.0-503.38.1.el9_5.x86_64
  BUILD DATE: Mar 12 2025

  CONFIGURAÇÃO:
  - Server API: CGI/FastCGI
  - Virtual Directory Support: disabled
  - Configuration File: /opt/alt/php82/etc/php.ini
  - Additional .ini files: /opt/alt/php82/link/conf

  EXTENSÕES PRINCIPAIS:
  - bcmath: enabled
  - bz2: enabled
  - calendar: enabled
  - curl: enabled
  - dom: enabled
  - exif: enabled
  - fileinfo: enabled
  - gd: enabled
  - intl: enabled
  - json: enabled
  - mbstring: enabled
  - mysqlnd: enabled
  - opcache: enabled
  - pdo: enabled
  - phar: enabled
  - posix: enabled
  - soap: enabled
  - sockets: enabled
  - zip: enabled
  - zlib: enabled

  BANCOS DE DADOS:
  - mysqli: enabled (mysqlnd)
  - pdo_mysql: enabled (mysqlnd)
  - pdo_pgsql: enabled
  - pdo_sqlite: enabled

  SEGURANÇA:
  - OpenSSL: enabled
  - LDAP: enabled
  - IMAP: enabled

  PERFORMANCE:
  - Zend OPcache: v8.2.28
  - JIT: enabled

  STREAMS:
  - https, ftps, compress.zlib, compress.bzip2
  - php, file, glob, data, http, ftp, phar, zip

  SOCKET TRANSPORTS:
  - tcp, udp, unix, udg, ssl, tls, tlsv1.0, tlsv1.1, tlsv1.2, tlsv1.3

  NOTAS:
  - PHP gerenciado via CloudLinux Alt-PHP
  - Configuração em /opt/alt/php82/etc/php.ini
  - Extensões adicionais em /opt/alt/php82/link/conf
  ```

**Tags:**
- environment:vps
- service:hostinger
- type:note
- status:active
- project:mfotrust

---

## 🔧 Como Criar

### Via CLI 1Password

```bash
op item create \
  --category "SECURE_NOTE" \
  --title "HOSTINGER_PHP_INFO_MFOTRUST" \
  --vault "1p_vps" \
  notesPlain="[conteúdo das notas acima]" \
  --tag "environment:vps" \
  --tag "service:hostinger" \
  --tag "type:note" \
  --tag "status:active" \
  --tag "project:mfotrust"
```

---

## 📝 Informações Adicionais

### Versão PHP
- **Atual:** PHP 8.2.28
- **Build:** Mar 12 2025
- **Zend Engine:** v4.2.28

### Localização de Arquivos
- **php.ini:** /opt/alt/php82/etc/php.ini
- **Extensões:** /opt/alt/php82/link/conf
- **Binários:** /opt/alt/php82/usr/bin

### Extensões Críticas
- ✅ MySQL/MySQLi (mysqlnd)
- ✅ PDO (MySQL, PostgreSQL, SQLite)
- ✅ GD (manipulação de imagens)
- ✅ cURL (requisições HTTP)
- ✅ OpenSSL (criptografia)
- ✅ OPcache (performance)
- ✅ mbstring (multibyte strings)
- ✅ ZIP (compressão)

---

**Última atualização:** 2025-11-17

