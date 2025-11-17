# 📋 Guia: Coleta Híbrida macOS → VPS Ubuntu

**Baseado em:** `Cursor_Coleta_Hibrido_macOS_VPS.md`  
**Adaptado para:** `automation_1password`  
**Foco:** DevOps híbrido sem inventar mudanças

---

## 🎯 Objetivo

Coletar dados completos do ambiente macOS Silicon e organizá-los para implantação ordenada na VPS Ubuntu (147.79.81.59) com sincronização segura via 1Password.

---

## 🚀 Script de Coleta

**Script:** `scripts/collection/collect-hybrid-environment.sh`

**Execução:**

```bash
cd ~/Dotfiles/automation_1password
./scripts/collection/collect-hybrid-environment.sh
```

**Saída:** Dados coletados em `dados/`

---

## 📊 Coletas Realizadas

### 1. Informações do Sistema ✅

- macOS version
- Arquitetura (arm64)
- CPU cores
- RAM
- **Arquivo:** `dados/01_system_info.txt`

### 2. Docker + Colima ✅

- Status Colima
- Versões Docker/Colima
- Containers ativos
- Imagens Docker
- **Arquivo:** `dados/02_docker_status.txt`

### 3. Stacks Docker ✅

- Containers rodando
- Volumes Docker
- Redes Docker
- **Arquivo:** `dados/03_docker_stacks.txt`

### 6. 1Password Inventory ✅

- **SEM valores de secrets!**
- Apenas metadata (titles, categories)
- Vaults: `1p_macos` e `1p_vps`
- **Arquivo:** `dados/06_1password_inventory.json`

### 7. Variáveis de Ambiente ✅

- **APENAS nomes de variáveis!**
- Estrutura de arquivos `.env`
- **Arquivo:** `dados/07_env_vars_keys.txt`

### 8. Informações Git ✅

- Remote repositories
- Branches
- Commits recentes
- **Arquivo:** `dados/08_git_info.txt`

### 9. Configuração de Rede ✅

- Portas mapeadas
- Networks Docker
- **Arquivo:** `dados/09_ports_mapping.txt`

---

## ⚠️ Segurança

- ✅ **NUNCA expõe valores de secrets**
- ✅ Apenas metadata do 1Password
- ✅ Apenas nomes de variáveis de ambiente
- ✅ Nenhuma credencial hardcoded

---

## 📁 Estrutura Gerada

```
automation_1password/
├── dados/
│   ├── 01_system_info.txt
│   ├── 02_docker_status.txt
│   ├── 03_docker_stacks.txt
│   ├── 06_1password_inventory.json
│   ├── 07_env_vars_keys.txt
│   ├── 08_git_info.txt
│   └── 09_ports_mapping.txt
│
└── prod/
    └── (preparação para deploy)
```

---

## 🔄 Próximos Passos

1. **Coletar dados:** `./scripts/collection/collect-hybrid-environment.sh`
2. **Revisar dados:** `ls -la dados/`
3. **Analisar dados:** `./scripts/collection/analyze-collected-data.sh`
4. **Preparar deploy:** `./scripts/collection/prepare-vps-deployment.sh`
5. **Sincronizar VPS:** `./scripts/collection/sync-to-vps.sh`
6. **Deploy na VPS:** (após validação completa)

---

## 🎯 Ambiente Híbrido

| Ambiente | Sistema          | Vault      | Função                |
| -------- | ---------------- | ---------- | --------------------- |
| **DEV**  | macOS Silicon    | `1p_macos` | Desenvolvimento local |
| **PROD** | VPS Ubuntu 22.04 | `1p_vps`   | Produção remota       |

**IP VPS:** 147.79.81.59  
**Domínio:** senamfo.com.br

---

**Status:** Script pronto e funcional. Execute quando quiser coletar dados do ambiente.
