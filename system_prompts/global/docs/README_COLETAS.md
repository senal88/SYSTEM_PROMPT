# 📋 GUIA RÁPIDO - Sistema de Coletas e Consolidação

**Versão:** 2.0.0
**Data:** 2025-11-28

---

## 🚀 Início Rápido

### 1. Verificar Dependências

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./verificar-dependencias.sh
```

Este script verifica e instala automaticamente:
- Ferramentas básicas do sistema
- Homebrew packages necessários
- Permissões de acesso
- Estrutura de diretórios

### 2. Executar Coleta Completa

```bash
./master-auditoria-completa.sh
```

Coleta informações de:
- macOS (sistema, hardware, ferramentas, configurações)
- VPS Ubuntu (opcional, se configurado)

### 3. Gerar Arquivo Consolidado para LLMs

```bash
./consolidar-llms-full.sh
```

Gera o arquivo `llms-full.txt` otimizado para importação em LLMs.

---

## 📁 Arquivos Criados

### Documentação

- **`ARQUITETURA_COLETAS.md`**: Arquitetura completa do sistema de coletas
- **`README_COLETAS.md`**: Este guia rápido

### Scripts

- **`verificar-dependencias.sh`**: Verifica e instala dependências
- **`master-auditoria-completa.sh`**: Coleta completa de dados (já existente)
- **`analise-e-sintese.sh`**: Análise e síntese (já existente)
- **`consolidar-llms-full.sh`**: Gera arquivo consolidado para LLMs

### Output

- **`llms-full.txt`**: Arquivo consolidado final (548 linhas, 16KB)
  - Localização: `~/Dotfiles/system_prompts/global/llms-full.txt`
  - Formato: Texto puro otimizado para LLMs
  - Conteúdo: System prompt completo com todas as informações do ambiente

---

## 📊 Estrutura do llms-full.txt

O arquivo consolidado contém:

1. **Identidade e Contexto Operacional**
2. **Ambiente Técnico Detalhado** (macOS + VPS)
3. **Preferências e Comportamento**
4. **Áreas de Especialização**
5. **Estrutura de Projetos e Repositórios**
6. **Ferramentas e Plataformas de IA**
7. **Segurança e Secrets**
8. **Padrões de Trabalho**
9. **Preferências Técnicas Específicas**
10. **Objetivos e Diretrizes**
11. **Contextos Específicos**
12. **Comandos e Aliases Comuns**
13. **Restrições e Limitações**
14. **Política de Proteção iCloud**
15. **Métricas de Sucesso**

---

## 🔄 Fluxo Completo

```bash
# Pipeline completo (executar em sequência)
cd ~/Dotfiles/system_prompts/global/scripts

# 1. Verificar dependências
./verificar-dependencias.sh

# 2. Coletar dados
./master-auditoria-completa.sh

# 3. Gerar arquivo consolidado
./consolidar-llms-full.sh
```

---

## 📥 Como Usar o llms-full.txt

### ChatGPT

1. Abra ChatGPT
2. Vá em Settings → Custom Instructions
3. Cole o conteúdo completo de `llms-full.txt`

### Claude

1. Abra Claude
2. Vá em Settings → Custom Instructions
3. Cole o conteúdo completo de `llms-full.txt`

### Gemini

1. Abra Google Gemini
2. Vá em Settings → Custom Instructions
3. Cole o conteúdo completo de `llms-full.txt`

### Perplexity

1. Abra Perplexity
2. Vá em Settings → Custom Instructions
3. Cole o conteúdo completo de `llms-full.txt`

---

## 🔧 Manutenção

### Atualizar Coleta

Execute periodicamente (recomendado: semanalmente):

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./master-auditoria-completa.sh && ./consolidar-llms-full.sh
```

### Automatizar com Cron

Adicione ao crontab para execução automática:

```bash
# Executar diariamente às 02:00
0 2 * * * /Users/luiz.sena88/Dotfiles/system_prompts/global/scripts/master-auditoria-completa.sh && /Users/luiz.sena88/Dotfiles/system_prompts/global/scripts/consolidar-llms-full.sh
```

---

## 📝 Notas Importantes

- **Proteção iCloud**: Todas as coletas respeitam a política de proteção iCloud
- **Segurança**: Nenhuma credencial é exposta nos arquivos gerados
- **Versionamento**: Cada auditoria é salva com timestamp único
- **Retenção**: Manter últimas 10 auditorias (limpar manualmente se necessário)

---

## 🆘 Troubleshooting

### Erro: "Nenhuma auditoria encontrada"

Execute primeiro:
```bash
./master-auditoria-completa.sh
```

### Erro: "Permissão negada"

Adicione permissão de execução:
```bash
chmod +x verificar-dependencias.sh
chmod +x consolidar-llms-full.sh
```

### Erro: "Homebrew não encontrado"

Instale o Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

**Última Atualização:** 2025-11-28
**Status:** Ativo e Funcional

