# 📊 Guia de Uso - Estrutura de Dados Contábeis para NotebookLM

> Guia completo para implementação e uso da estrutura de dados contábeis com NotebookLM

## 🎯 Visão Geral

Esta estrutura foi desenvolvida para organizar dados contábeis de forma que possam ser facilmente processados pelo NotebookLM, permitindo análises inteligentes, geração de relatórios e insights contábeis automatizados.

## 🚀 Início Rápido

### 1. **Preparação do Ambiente**

```bash
# Navegar para o diretório
cd /Users/luiz.sena88/Dotfiles/notebooklm_accounting

# Verificar estrutura criada
ls -la

# Executar processamento de dados
python scripts/data_processing.py

# Configurar integração com NotebookLM
python scripts/notebooklm_integration.py
```

### 2. **Configuração Inicial**

1. **Editar informações da empresa:**
   ```bash
   # Editar arquivo de configuração
   nano config/company_info.json
   ```

2. **Configurar plano de contas:**
   ```bash
   # Personalizar plano de contas
   nano config/chart_of_accounts.json
   ```

3. **Ajustar configurações do NotebookLM:**
   ```bash
   # Configurar análise
   nano config/notebooklm_config.json
   ```

## 📁 Estrutura de Arquivos

```
notebooklm_accounting/
├── README.md                           # Documentação principal
├── GUIA_USO.md                        # Este guia
├── data/                              # Dados contábeis
│   ├── raw/                           # Dados brutos
│   ├── processed/                     # Dados processados
│   └── exports/                        # Dados para NotebookLM
├── templates/                         # Templates contábeis
│   ├── balance_sheet/                 # Balanço Patrimonial
│   ├── income_statement/              # DRE
│   ├── cash_flow/                     # Fluxo de Caixa
│   └── general_ledger/                 # Razão Geral
├── config/                            # Configurações
│   ├── chart_of_accounts.json         # Plano de contas
│   ├── company_info.json              # Informações da empresa
│   └── notebooklm_config.json         # Configurações NotebookLM
├── scripts/                           # Scripts de automação
│   ├── data_processing.py              # Processamento de dados
│   └── notebooklm_integration.py      # Integração NotebookLM
└── analysis/                          # Análises e insights
    ├── prompts/                       # Prompts especializados
    └── reports/                       # Relatórios gerados
```

## 🔧 Configuração Detalhada

### 1. **Configuração da Empresa**

Edite o arquivo `config/company_info.json`:

```json
{
  "company": {
    "basic_info": {
      "name": "Sua Empresa Ltda",
      "cnpj": "12.345.678/0001-90",
      "regime_tributario": "Lucro Real",
      "setor_atividade": "Tecnologia"
    }
  }
}
```

### 2. **Configuração do Plano de Contas**

Personalize o arquivo `config/chart_of_accounts.json`:

```json
{
  "chart_of_accounts": {
    "accounts": {
      "1": {
        "code": "1",
        "name": "ATIVO",
        "type": "ASSET"
      }
    }
  }
}
```

### 3. **Configuração do NotebookLM**

Ajuste o arquivo `config/notebooklm_config.json`:

```json
{
  "notebooklm_config": {
    "analysis_settings": {
      "default_period": "monthly",
      "key_metrics": [
        "revenue_growth",
        "profit_margin",
        "cash_flow"
      ]
    }
  }
}
```

## 📊 Processamento de Dados

### 1. **Importar Dados Brutos**

```bash
# Colocar arquivos CSV/Excel na pasta data/raw/
cp seus_dados.csv data/raw/

# Processar dados
python scripts/data_processing.py --input data/raw/seus_dados.csv
```

### 2. **Estruturar Dados**

```bash
# Executar processamento completo
python scripts/data_processing.py

# Verificar dados processados
ls -la data/processed/
```

### 3. **Exportar para NotebookLM**

```bash
# Gerar arquivos de exportação
python scripts/data_processing.py --export

# Verificar arquivos exportados
ls -la data/exports/
```

## 🤖 Integração com NotebookLM

### 1. **Configurar NotebookLM**

```bash
# Gerar configurações
python scripts/notebooklm_integration.py

# Verificar arquivos gerados
ls -la analysis/prompts/
```

### 2. **Importar Dados no NotebookLM**

1. Acesse o NotebookLM
2. Crie um novo notebook
3. Importe os arquivos de `data/exports/`
4. Configure as análises desejadas

### 3. **Usar Prompts Especializados**

Os prompts estão disponíveis em `analysis/prompts/analysis_prompts.json`:

- **Análise de Balanço**: Estrutura financeira e liquidez
- **Análise de DRE**: Rentabilidade e eficiência
- **Análise de Fluxo de Caixa**: Gestão de recursos
- **Análise de Indicadores**: Métricas financeiras

## 📈 Análises Disponíveis

### 1. **Análise de Balanço Patrimonial**

```python
# Prompts disponíveis:
"Analise o balanço patrimonial da empresa, identificando pontos fortes e fracos na estrutura financeira, com foco em liquidez, endividamento e composição do patrimônio."
```

### 2. **Análise de Demonstração do Resultado**

```python
# Prompts disponíveis:
"Examine a demonstração do resultado do exercício, analisando a evolução das receitas, custos e despesas, identificando tendências e oportunidades de melhoria."
```

### 3. **Análise de Fluxo de Caixa**

```python
# Prompts disponíveis:
"Avalie o fluxo de caixa da empresa, identificando as principais fontes e usos de recursos, e propondo estratégias para otimização da gestão financeira."
```

### 4. **Análise de Indicadores Financeiros**

```python
# Prompts disponíveis:
"Calcule e interprete os principais indicadores financeiros, comparando com benchmarks do setor e identificando áreas que necessitam atenção."
```

## 🔍 Perguntas Sugeridas

### **Perguntas Básicas:**
- Qual a evolução da receita nos últimos 12 meses?
- Como está a margem de lucro da empresa?
- Quais são os principais custos operacionais?
- Como está a situação de liquidez?

### **Perguntas Avançadas:**
- Qual a projeção de crescimento para o próximo ano?
- Quais são os principais riscos financeiros?
- Como está a performance em relação ao setor?
- Quais são as oportunidades de otimização?

## 📋 Relatórios Automáticos

### 1. **Relatório Mensal Executivo**

- Resumo Executivo
- Análise de Receitas
- Análise de Custos
- Indicadores Financeiros
- Projeções

### 2. **Análise de Liquidez**

- Posição de Caixa
- Fluxo de Caixa Projetado
- Análise de Contas a Receber
- Análise de Contas a Pagar

### 3. **Relatório Trimestral Completo**

- Demonstrações Financeiras
- Análise Comparativa
- Indicadores de Performance
- Análise de Tendências
- Recomendações Estratégicas

## 🛠️ Manutenção e Atualização

### 1. **Atualização de Dados**

```bash
# Atualizar dados mensalmente
python scripts/data_processing.py --update

# Sincronizar com sistemas externos
python scripts/data_processing.py --sync
```

### 2. **Backup e Segurança**

```bash
# Backup dos dados
tar -czf backup_$(date +%Y%m%d).tar.gz data/

# Verificar integridade
python scripts/validate_data.py
```

### 3. **Monitoramento**

```bash
# Verificar status do sistema
python scripts/status_check.py

# Gerar relatório de status
python scripts/status_report.py
```

## 🔧 Troubleshooting

### **Problemas Comuns:**

1. **Erro de importação de dados:**
   ```bash
   # Verificar formato dos arquivos
   python scripts/validate_data.py --check-format
   ```

2. **Erro de processamento:**
   ```bash
   # Verificar logs
   tail -f logs/processing.log
   ```

3. **Erro de integração com NotebookLM:**
   ```bash
   # Verificar configurações
   python scripts/notebooklm_integration.py --validate
   ```

### **Soluções:**

1. **Dados corrompidos:**
   - Verificar encoding (UTF-8)
   - Validar formato de datas
   - Verificar separadores

2. **Performance lenta:**
   - Otimizar consultas
   - Reduzir volume de dados
   - Usar cache

3. **Erros de configuração:**
   - Verificar arquivos JSON
   - Validar sintaxe
   - Testar configurações

## 📞 Suporte

### **Recursos Disponíveis:**

- **Documentação**: `README.md` e `GUIA_USO.md`
- **Exemplos**: Pasta `examples/`
- **Logs**: Pasta `logs/`
- **Configurações**: Pasta `config/`

### **Contato:**

- **Email**: luizfernandomoreirasena@gmail.com
- **Issues**: GitHub Issues
- **Documentação**: Wiki do projeto

## 🎯 Próximos Passos

### **Implementação:**

1. ✅ Estrutura criada
2. ✅ Templates configurados
3. ✅ Scripts implementados
4. ✅ Documentação completa
5. 🔄 **Próximo**: Teste com dados reais
6. 🔄 **Próximo**: Integração com NotebookLM
7. 🔄 **Próximo**: Treinamento da equipe

### **Melhorias Futuras:**

- Integração com mais sistemas ERP
- Análises mais avançadas
- Relatórios personalizados
- Dashboard em tempo real
- Integração com BI tools

---

**Última atualização**: $(date)
**Versão**: 1.0.0
**Status**: ✅ Implementação Completa
