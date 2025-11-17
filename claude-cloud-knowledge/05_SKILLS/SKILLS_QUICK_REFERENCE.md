# Skills - Referência Rápida

## 🎯 Conceitos-Chave

**Skills** = Capacidades modulares que estendem Claude
**Progressive Disclosure** = Carregamento sob demanda (economia de tokens)
**Filesystem-based** = Skills existem como diretórios com arquivos

---

## 📋 Estrutura Mínima

```yaml
---
name: skill-name
description: O que faz e quando usar
---

# Conteúdo do Skill
```

---

## 🔄 Níveis de Carregamento

| Nível | Quando | Tokens | Conteúdo |
|-------|--------|--------|----------|
| 1. Metadata | Sempre | ~100 | name + description |
| 2. Instructions | Quando acionado | <5K | SKILL.md |
| 3. Resources | Conforme necessário | Ilimitado* | Scripts, recursos |

*Scripts executados via bash não consomem tokens

---

## 📦 Pre-built Skills Disponíveis

- `pptx` - PowerPoint
- `xlsx` - Excel
- `docx` - Word
- `pdf` - PDF

---

## 🎨 Onde Funcionam

- ✅ Claude API (pre-built + custom)
- ✅ Claude Code (custom apenas)
- ✅ Claude Agent SDK (custom)
- ✅ Claude.ai (pre-built + custom)

---

## ⚠️ Limitações

- Custom Skills NÃO sincronizam entre superfícies
- Compartilhamento varia por superfície
- Restrições de rede dependem do produto
- API: Sem acesso à rede
- Claude Code: Acesso total à rede

---

## 🔒 Segurança

- Use apenas Skills de fontes confiáveis
- Audite todos os arquivos antes de usar
- Cuidado com Skills que buscam dados externos
- Trate como instalar software

---

## 📝 Checklist de Criação

- [ ] SKILL.md com frontmatter YAML
- [ ] name válido (64 chars, lowercase, hyphens)
- [ ] description clara (o que + quando)
- [ ] Instruções organizadas
- [ ] Exemplos incluídos
- [ ] Scripts testados (se aplicável)
- [ ] Recursos documentados

---

**Versão:** 1.0.0

