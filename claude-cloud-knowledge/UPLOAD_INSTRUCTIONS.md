# Instruções de Upload - Claude Cloud Pro

## 🎯 Modelo Recomendado

**Claude Sonnet 4.5** (ou mais recente)
- Capacidade: 200K tokens
- Ideal para: Desenvolvimento complexo, automação DevOps, integrações

---

## 📤 Como Fazer Upload

### Opção 1: Upload Individual (Recomendado)

1. Acesse **Claude Cloud Pro Console**
2. Vá em **Settings** → **Knowledge** → **Add Files**
3. Crie as seguintes pastas:
   ```
   00_CONTEXTO_GLOBAL
   01_CONFIGURACOES
   02_PROJETO_BNI
   03_AUTOMACAO
   04_REFERENCIAS
   ```
4. Faça upload na ordem:
   - **00_CONTEXTO_GLOBAL/** (3 arquivos)
   - **01_CONFIGURACOES/** (3 arquivos)
   - **02_PROJETO_BNI/** (3 arquivos)
   - **03_AUTOMACAO/** (3 arquivos)
   - **04_REFERENCIAS/** (3 arquivos)

### Opção 2: Upload Consolidado

1. Use o arquivo **CONSOLIDADO_COMPLETO.md**
2. Faça upload único deste arquivo
3. Organize manualmente no console se necessário

---

## 📋 Checklist de Upload

### 00_CONTEXTO_GLOBAL/
- [ ] Ambientes.md
- [ ] Infraestrutura.md
- [ ] Stack.md

### 01_CONFIGURACOES/
- [ ] 1Password.md
- [ ] GitHub.md
- [ ] HuggingFace.md

### 02_PROJETO_BNI/
- [ ] Contexto.md
- [ ] Skills.md
- [ ] Credenciais.md

### 03_AUTOMACAO/
- [ ] Scripts.md
- [ ] Integrações.md
- [ ] Deploy.md

### 04_REFERENCIAS/
- [ ] Guias.md
- [ ] API.md
- [ ] Troubleshooting.md

### 05_SKILLS/
- [ ] SKILLS_COMPLETE_GUIDE.md
- [ ] SKILLS_QUICK_REFERENCE.md
- [ ] SKILLS_EXAMPLES.md

---

## ✅ Validação Pós-Upload

Após upload, teste com estas perguntas:

1. "Qual é a estrutura dos ambientes configurados?"
2. "Como funciona o sistema 1Password?"
3. "Quais scripts estão disponíveis para automação?"
4. "Como configurar Hugging Face CLI?"
5. "Qual é o contexto do projeto BNI?"

---

## 🔄 Atualização

Para atualizar a documentação:

```bash
cd ~/Dotfiles/context-engineering/scripts
./consolidate-docs-for-claude.sh
```

Depois, re-upload os arquivos atualizados no Claude Cloud Pro.

---

**Localização dos arquivos:** `~/Dotfiles/claude-cloud-knowledge/`
**Última atualização:** 2025-11-05

