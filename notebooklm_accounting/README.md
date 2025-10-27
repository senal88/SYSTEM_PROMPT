# 📊 Estrutura de Dados Contábeis para NotebookLM

> Organização completa de dados contábeis para análise e processamento com IA

## 🎯 Objetivo

Esta estrutura foi desenvolvida para organizar dados contábeis de forma que possam ser facilmente processados pelo NotebookLM, permitindo análises inteligentes, geração de relatórios e insights contábeis automatizados.

## 📁 Estrutura de Diretórios

```
notebooklm_accounting/
├── README.md                           # Este arquivo
├── data/                              # Dados contábeis estruturados
│   ├── raw/                           # Dados brutos (CSV, Excel, PDF)
│   ├── processed/                     # Dados processados e limpos
│   └── exports/                       # Dados exportados para NotebookLM
├── templates/                         # Templates e modelos
│   ├── balance_sheet/                 # Balanço Patrimonial
│   ├── income_statement/              # DRE (Demonstração do Resultado)
│   ├── cash_flow/                     # Fluxo de Caixa
│   └── general_ledger/                # Razão Geral
├── reports/                           # Relatórios gerados
│   ├── monthly/                       # Relatórios mensais
│   ├── quarterly/                     # Relatórios trimestrais
│   └── annual/                        # Relatórios anuais
├── analysis/                          # Análises e insights
│   ├── financial_ratios/              # Indicadores financeiros
│   ├── trends/                        # Análise de tendências
│   └── forecasts/                     # Projeções e previsões
├── config/                            # Configurações
│   ├── chart_of_accounts.json         # Plano de contas
│   ├── company_info.json              # Informações da empresa
│   └── notebooklm_config.json         # Configurações do NotebookLM
└── scripts/                           # Scripts de automação
    ├── data_processing.py              # Processamento de dados
    ├── report_generator.py             # Geração de relatórios
    └── notebooklm_integration.py       # Integração com NotebookLM
```

## 🏗️ Componentes Principais

### 1. **Dados Estruturados**
- **Formato Padrão**: CSV/JSON para fácil importação
- **Codificação**: UTF-8 para suporte a caracteres especiais
- **Validação**: Estrutura consistente e validada

### 2. **Templates Contábeis**
- **Balanço Patrimonial**: Ativo, Passivo e Patrimônio Líquido
- **DRE**: Receitas, Custos e Despesas
- **Fluxo de Caixa**: Operacional, Investimento e Financiamento
- **Razão Geral**: Lançamentos contábeis detalhados

### 3. **Análises Inteligentes**
- **Indicadores Financeiros**: Liquidez, Rentabilidade, Endividamento
- **Análise de Tendências**: Crescimento, Sazonalidade
- **Projeções**: Baseadas em dados históricos

### 4. **Integração NotebookLM**
- **Prompts Especializados**: Para análise contábil
- **Templates de Perguntas**: Perguntas comuns e específicas
- **Configurações**: Otimizadas para dados contábeis

## 🚀 Como Usar

### 1. **Preparação dos Dados**
```bash
# Organizar dados brutos na pasta data/raw/
# Executar script de processamento
python scripts/data_processing.py
```

### 2. **Configuração do NotebookLM**
```bash
# Configurar informações da empresa
python scripts/notebooklm_integration.py --setup
```

### 3. **Geração de Relatórios**
```bash
# Gerar relatórios automáticos
python scripts/report_generator.py --period monthly
```

## 📋 Checklist de Implementação

- [ ] Estrutura de diretórios criada
- [ ] Templates contábeis configurados
- [ ] Scripts de processamento implementados
- [ ] Configurações do NotebookLM definidas
- [ ] Dados de exemplo adicionados
- [ ] Documentação completa

## 🔧 Configurações Avançadas

### Variáveis de Ambiente
```bash
# Configurar no arquivo .env
ACCOUNTING_DATA_PATH=/path/to/accounting/data
NOTEBOOKLM_API_KEY=your_api_key
COMPANY_ID=your_company_id
```

### Integração com Sistemas
- ERP (Sistema de Gestão)
- CRM (Gestão de Clientes)
- Sistemas Bancários
- APIs de Terceiros

## 📊 Exemplos de Uso

### Análise de Balanço
```python
# Exemplo de análise automática
from scripts.analysis import BalanceSheetAnalyzer

analyzer = BalanceSheetAnalyzer('data/processed/balance_sheet_2024.csv')
analysis = analyzer.analyze()
print(analysis.summary)
```

### Geração de Relatório
```python
# Exemplo de geração de relatório
from scripts.reports import MonthlyReportGenerator

generator = MonthlyReportGenerator()
report = generator.generate('2024-01')
report.export_to_notebooklm()
```

## 🤝 Contribuição

1. Fork o repositório
2. Crie uma branch para sua feature
3. Implemente as mudanças
4. Teste com dados reais
5. Documente as alterações
6. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

**Última atualização**: $(date)
**Versão**: 1.0.0
**Status**: ✅ Em Desenvolvimento
