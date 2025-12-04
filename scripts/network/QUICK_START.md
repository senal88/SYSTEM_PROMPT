# 🚀 Quick Start - Correção de Erro DNS Cursor

## Problema
```
ConnectError: [unavailable] getaddrinfo ENOTFOUND api2.cursor.sh
```

## Solução Rápida (3 passos)

### 1️⃣ Diagnosticar
```bash
cd ~/Dotfiles/scripts/network
./diagnose-dns-error.sh api2.cursor.sh
```

### 2️⃣ Corrigir
```bash
./fix-dns-and-trust-network.sh api2.cursor.sh
```

### 3️⃣ Validar
```bash
./test-cursor-connectivity.sh api2.cursor.sh
```

## ⚠️ Se estiver em rede pública (Insper, etc.)

Após executar o script de correção, faça manualmente:

1. **System Preferences > Network**
2. Selecione sua conexão > **Advanced**
3. Aba **Proxies** > **Desmarque "Automatic Proxy Configuration"**
4. Clique em **OK** e **Apply**

## 📚 Documentação Completa

- [README.md](./README.md) - Documentação completa dos scripts
- [../docs/DIAGNOSTICO_ERRO_DNS_CURSOR.md](../../docs/DIAGNOSTICO_ERRO_DNS_CURSOR.md) - Diagnóstico técnico detalhado

## 🆘 Ainda com problemas?

1. Verifique se completou autenticação em portal captivo (se aplicável)
2. Reinicie a conexão de rede
3. Reinicie o Cursor.app
4. Execute os scripts novamente
