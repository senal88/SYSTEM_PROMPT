# 🚀 DEPLOY GITHUB E VPS - Status e Soluções

**Data:** 2025-11-28
**Versão:** 2.0.0

---

## ⚠️ PROBLEMA IDENTIFICADO

O push para o GitHub está falhando devido a um arquivo grande no histórico:

```
File: raycast/raycast-profile/NodeJS/runtime/22.14.0/bin/node (103.59 MB)
Limite GitHub: 100.00 MB
```

O arquivo foi adicionado no commit `7375e42` e ainda está no histórico do Git.

---

## ✅ SOLUÇÕES DISPONÍVEIS

### Opção 1: Usar Git LFS (Recomendado)

```bash
# Instalar Git LFS
brew install git-lfs

# Inicializar Git LFS no repositório
cd ~/Dotfiles
git lfs install

# Rastrear arquivos grandes
git lfs track "raycast/raycast-profile/NodeJS/**"

# Adicionar e commitar
git add .gitattributes
git commit -m "chore: usar Git LFS para arquivos grandes do Raycast"

# Push
git push origin main
```

### Opção 2: Remover do Histórico (Avançado)

**⚠️ ATENÇÃO:** Esta operação reescreve o histórico do Git e pode afetar outros desenvolvedores.

```bash
# Instalar git-filter-repo (recomendado)
brew install git-filter-repo

# Remover arquivo do histórico
cd ~/Dotfiles
git filter-repo --path raycast/raycast-profile/NodeJS/runtime/22.14.0/bin/node --invert-paths

# Force push (CUIDADO!)
git push origin main --force
```

### Opção 3: Criar Branch Limpa (Mais Seguro)

```bash
# Criar branch apenas com commits novos (sem arquivo grande)
cd ~/Dotfiles
git checkout -b main-clean $(git log --oneline --all | grep "reorganização" | head -1 | cut -d' ' -f1)

# Push da branch limpa
git push origin main-clean

# Depois, fazer merge seletivo no GitHub
```

---

## 🚀 DEPLOY NA VPS

### Script Criado

Foi criado o script `scripts/deploy-completo-vps.sh` para deploy automatizado.

### Executar Deploy

```bash
cd ~/Dotfiles/system_prompts/global
./scripts/deploy-completo-vps.sh
```

### Pré-requisitos

1. **SSH configurado:**
   ```bash
   # Verificar alias
   ssh admin-vps

   # Ou configurar em ~/.ssh/config:
   Host admin-vps
       HostName senamfo.com.br
       User admin
       IdentityFile ~/.ssh/id_rsa
   ```

2. **Chaves SSH autorizadas na VPS**

3. **Estrutura de diretórios na VPS:**
   - `/home/admin/Dotfiles/system_prompts/global/`

### Deploy Manual (Alternativa)

Se o script automático não funcionar:

```bash
# 1. Criar estrutura
ssh admin-vps "mkdir -p /home/admin/Dotfiles/system_prompts/global/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections},consolidated,scripts,governance}"

# 2. Enviar arquivos principais
scp -r ~/Dotfiles/system_prompts/global/prompts/* admin-vps:/home/admin/Dotfiles/system_prompts/global/prompts/
scp -r ~/Dotfiles/system_prompts/global/scripts/* admin-vps:/home/admin/Dotfiles/system_prompts/global/scripts/
scp -r ~/Dotfiles/system_prompts/global/docs/* admin-vps:/home/admin/Dotfiles/system_prompts/global/docs/

# 3. Configurar permissões
ssh admin-vps "chmod +x /home/admin/Dotfiles/system_prompts/global/scripts/*.sh"
```

---

## 📋 STATUS ATUAL

- ✅ **Commits locais:** Criados e prontos
- ✅ **Script de deploy VPS:** Criado
- ⚠️ **Push GitHub:** Bloqueado por arquivo grande
- ⏳ **Deploy VPS:** Aguardando configuração SSH

---

## 🎯 PRÓXIMOS PASSOS RECOMENDADOS

1. **Resolver problema do GitHub:**
   - Escolher uma das opções acima (recomendado: Git LFS)
   - Fazer push após resolver

2. **Configurar SSH para VPS:**
   - Verificar chaves SSH
   - Testar conexão: `ssh admin-vps`
   - Executar deploy: `./scripts/deploy-completo-vps.sh`

3. **Validar deploy:**
   - Verificar arquivos na VPS
   - Testar scripts
   - Validar estrutura

---

**Última Atualização:** 2025-11-28
