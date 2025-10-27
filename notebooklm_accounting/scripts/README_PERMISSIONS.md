# 🔍 Scripts de Verificação de Permissões

> Conjunto completo de scripts para análise e verificação de permissões de arquivos e diretórios

## 📋 **Scripts Disponíveis**

### 1. **`permissions-checker.sh`** - Verificação Completa
Script principal para análise detalhada de permissões com relatórios completos.

**Características:**
- ✅ Análise recursiva de diretórios
- ✅ Verificação de permissões (leitura, escrita, execução)
- ✅ Relatórios detalhados em texto
- ✅ Estatísticas completas
- ✅ Identificação de problemas
- ✅ Suporte a argumentos de linha de comando

### 2. **`quick-permissions-check.sh`** - Verificação Rápida
Script para verificação rápida e resumo básico de permissões.

**Características:**
- ⚡ Execução rápida
- 📊 Estatísticas básicas
- 🔍 Verificação de problemas
- 📁 Estrutura de diretórios
- 📄 Tipos de arquivo

### 3. **`permissions-analyzer.py`** - Análise Avançada
Script Python para análise avançada com exportação em múltiplos formatos.

**Características:**
- 🐍 Análise em Python
- 📊 Exportação JSON/CSV
- 📈 Estatísticas avançadas
- 🔍 Detecção de problemas
- 📋 Relatórios personalizados

## 🚀 **Como Usar**

### **Verificação Rápida**
```bash
# Executar verificação rápida
./scripts/quick-permissions-check.sh

# Com ajuda
./scripts/quick-permissions-check.sh --help
```

### **Verificação Completa**
```bash
# Análise completa do diretório padrão
./scripts/permissions-checker.sh

# Análise de diretório específico
./scripts/permissions-checker.sh -d /Users/outro-usuario

# Limitar profundidade
./scripts/permissions-checker.sh -m 5

# Modo silencioso
./scripts/permissions-checker.sh -q

# Arquivo de saída personalizado
./scripts/permissions-checker.sh -o meu-relatorio.txt
```

### **Análise Avançada (Python)**
```bash
# Análise básica
python3 scripts/permissions-analyzer.py

# Análise com opções
python3 scripts/permissions-analyzer.py -d /Users/luiz.sena88 -m 5

# Exportar para JSON
python3 scripts/permissions-analyzer.py -o analysis.json

# Exportar problemas para CSV
python3 scripts/permissions-analyzer.py -c issues.csv

# Gerar relatório em texto
python3 scripts/permissions-analyzer.py -r report.txt

# Modo verboso
python3 scripts/permissions-analyzer.py -v
```

## 📊 **Exemplos de Uso**

### **1. Verificação Básica**
```bash
# Verificação rápida
./scripts/quick-permissions-check.sh
```

**Saída esperada:**
```
🔍 Verificação Rápida de Permissões
===================================
📁 Diretório: /Users/luiz.sena88
👤 Usuário: luiz.sena88
📅 Data: 2024-01-01 10:00:00

🔐 Permissões Básicas:
-------------------
✅ Leitura: OK
✅ Escrita: OK
✅ Execução: OK

📊 Estatísticas Rápidas:
----------------------
📁 Diretórios: 150
📄 Arquivos: 1250
🔗 Links: 5
💾 Tamanho total: 2.5GB
```

### **2. Análise Completa**
```bash
# Análise completa com relatório
./scripts/permissions-checker.sh -o relatorio-completo.txt
```

**Arquivos gerados:**
- `permissions-report-20240101-100000.txt` - Relatório detalhado
- `permissions-summary-20240101-100000.txt` - Resumo executivo
- `permissions-check.log` - Log de execução

### **3. Análise Avançada**
```bash
# Análise com exportação JSON
python3 scripts/permissions-analyzer.py -o analysis.json -c issues.csv
```

**Arquivos gerados:**
- `analysis.json` - Dados completos em JSON
- `issues.csv` - Problemas de permissão em CSV

## 📋 **Interpretação dos Resultados**

### **Legenda de Ícones**
- 📁 = Diretório
- 📄 = Arquivo
- ⚡ = Executável
- 📝 = Arquivo de texto
- 🖼️ = Imagem
- 📕 = PDF
- 📦 = Arquivo compactado

### **Permissões**
- ✅ = Permitido
- ❌ = Negado
- R W X = Leitura Escrita Execução

### **Formato de Saída**
```
[Tipo] Nome (Tamanho) Permissões | R W X | Data Modificação | Caminho
```

**Exemplo:**
```
📁 Documents (25 items) rwx r-x r-x luiz.sena88:staff 755 | ✅ ✅ ✅ | 2024-01-01 10:00 | /Documents
```

## 🔧 **Troubleshooting**

### **Problemas Comuns**

1. **Erro de permissão ao executar script:**
   ```bash
   chmod +x scripts/permissions-checker.sh
   ```

2. **Diretório não encontrado:**
   ```bash
   # Verificar se o diretório existe
   ls -la /Users/luiz.sena88
   ```

3. **Erro de Python:**
   ```bash
   # Verificar versão do Python
   python3 --version
   
   # Instalar dependências se necessário
   pip3 install -r requirements.txt
   ```

### **Soluções**

1. **Scripts não executáveis:**
   ```bash
   # Tornar todos os scripts executáveis
   chmod +x scripts/*.sh scripts/*.py
   ```

2. **Problemas de permissão:**
   ```bash
   # Verificar permissões do diretório
   ls -la /Users/luiz.sena88
   
   # Corrigir se necessário
   chmod 755 /Users/luiz.sena88
   ```

3. **Erros de análise:**
   ```bash
   # Verificar logs
   tail -f permissions-check.log
   
   # Executar com modo verboso
   python3 scripts/permissions-analyzer.py -v
   ```

## 📈 **Análise de Resultados**

### **Métricas Importantes**

1. **Taxa de Sucesso de Permissões:**
   - Leitura: > 95% ideal
   - Escrita: > 90% ideal
   - Execução: > 85% ideal

2. **Problemas Críticos:**
   - Diretórios sem execução
   - Arquivos de sistema sem leitura
   - Scripts sem execução

3. **Otimizações:**
   - Identificar arquivos desnecessários
   - Corrigir permissões incorretas
   - Organizar estrutura de diretórios

### **Relatórios Gerados**

1. **Relatório Detalhado:**
   - Lista completa de todos os itens
   - Permissões específicas
   - Tamanhos e datas
   - Problemas identificados

2. **Resumo Executivo:**
   - Estatísticas gerais
   - Taxa de sucesso
   - Problemas principais
   - Recomendações

3. **Análise JSON:**
   - Dados estruturados
   - Fácil processamento
   - Integração com outras ferramentas

## 🎯 **Casos de Uso**

### **1. Auditoria de Segurança**
```bash
# Verificação completa para auditoria
./scripts/permissions-checker.sh -d /Users/luiz.sena88 -o audit-report.txt
```

### **2. Limpeza de Sistema**
```bash
# Identificar arquivos problemáticos
python3 scripts/permissions-analyzer.py -c cleanup-issues.csv
```

### **3. Monitoramento Contínuo**
```bash
# Verificação rápida diária
./scripts/quick-permissions-check.sh > daily-check.log
```

### **4. Análise de Performance**
```bash
# Identificar maiores arquivos
python3 scripts/permissions-analyzer.py -o size-analysis.json
```

## 📚 **Integração com NotebookLM**

Os scripts de verificação de permissões podem ser integrados com a estrutura de dados contábeis para NotebookLM:

### **1. Análise de Dados Contábeis**
```bash
# Verificar permissões dos dados contábeis
./scripts/permissions-checker.sh -d /Users/luiz.sena88/Dotfiles/notebooklm_accounting
```

### **2. Relatórios Combinados**
```bash
# Análise completa do sistema
./scripts/permissions-checker.sh -d /Users/luiz.sena88 -o system-analysis.txt
python3 scripts/permissions-analyzer.py -d /Users/luiz.sena88 -o system-data.json
```

### **3. Monitoramento de Segurança**
```bash
# Verificação de segurança dos dados
./scripts/quick-permissions-check.sh
```

## 🔒 **Segurança e Privacidade**

### **Dados Sensíveis**
- Os scripts não acessam conteúdo de arquivos
- Apenas verificam permissões e metadados
- Não expõem informações pessoais

### **Logs e Auditoria**
- Todos os acessos são registrados
- Logs podem ser revisados
- Histórico de verificações mantido

### **Recomendações**
- Execute verificações regularmente
- Monitore mudanças de permissões
- Mantenha backups dos relatórios
- Revise problemas identificados

---

**Última atualização**: $(date)
**Versão**: 1.0.0
**Status**: ✅ Implementação Completa
