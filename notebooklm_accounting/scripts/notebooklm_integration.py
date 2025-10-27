#!/usr/bin/env python3
"""
Script de integração com NotebookLM para análise contábil
Gera prompts especializados e configurações otimizadas
"""

import json
import logging
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class NotebookLMIntegration:
    """Integração com NotebookLM para análise contábil"""
    
    def __init__(self, config_path: str = "config/notebooklm_config.json"):
        """Inicializa a integração com NotebookLM"""
        self.config_path = Path(config_path)
        self.config = self.load_config()
        self.prompts_path = Path("analysis/prompts")
        self.prompts_path.mkdir(parents=True, exist_ok=True)
    
    def load_config(self) -> Dict[str, Any]:
        """Carrega configurações do NotebookLM"""
        try:
            with open(self.config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            logger.error(f"Arquivo de configuração não encontrado: {self.config_path}")
            return {}
        except json.JSONDecodeError as e:
            logger.error(f"Erro ao decodificar JSON: {e}")
            return {}
    
    def generate_analysis_prompts(self) -> Dict[str, str]:
        """Gera prompts especializados para análise contábil"""
        logger.info("Gerando prompts de análise contábil...")
        
        prompts = {
            "balance_sheet_analysis": """
            Analise o balanço patrimonial da empresa com foco nos seguintes aspectos:
            
            1. **Estrutura Financeira:**
               - Avalie a composição do ativo (circulante vs não circulante)
               - Analise a estrutura do passivo e patrimônio líquido
               - Identifique a proporção de capital próprio vs capital de terceiros
            
            2. **Liquidez:**
               - Calcule e interprete os indicadores de liquidez
               - Avalie a capacidade de pagamento de curto prazo
               - Identifique possíveis problemas de liquidez
            
            3. **Endividamento:**
               - Analise a estrutura de dívidas
               - Avalie a capacidade de pagamento de longo prazo
               - Identifique riscos de endividamento
            
            4. **Patrimônio Líquido:**
               - Avalie a evolução do patrimônio líquido
               - Analise a composição das reservas
               - Identifique a qualidade do patrimônio
            
            Forneça recomendações específicas para melhoria da estrutura financeira.
            """,
            
            "income_statement_analysis": """
            Analise a demonstração do resultado do exercício com foco em:
            
            1. **Análise de Receitas:**
               - Avalie a evolução das receitas por categoria
               - Identifique tendências de crescimento ou declínio
               - Analise a sazonalidade das receitas
            
            2. **Análise de Custos e Despesas:**
               - Avalie a evolução dos custos em relação às receitas
               - Identifique os principais componentes de custos
               - Analise a eficiência operacional
            
            3. **Análise de Rentabilidade:**
               - Calcule e interprete as margens de lucro
               - Compare com benchmarks do setor
               - Identifique oportunidades de melhoria
            
            4. **Análise de Resultado Financeiro:**
               - Avalie o resultado financeiro
               - Analise a gestão de recursos financeiros
               - Identifique oportunidades de otimização
            
            Forneça insights sobre a performance financeira e recomendações estratégicas.
            """,
            
            "cash_flow_analysis": """
            Analise o fluxo de caixa da empresa considerando:
            
            1. **Fluxo Operacional:**
               - Avalie a geração de caixa das operações
               - Identifique os principais drivers de caixa
               - Analise a qualidade do resultado operacional
            
            2. **Fluxo de Investimento:**
               - Avalie os investimentos em ativos fixos
               - Analise a política de investimentos
               - Identifique necessidades futuras de investimento
            
            3. **Fluxo de Financiamento:**
               - Avalie a política de financiamento
               - Analise o pagamento de dividendos
               - Identifique necessidades futuras de financiamento
            
            4. **Gestão de Caixa:**
               - Avalie a posição de caixa atual
               - Identifique riscos de liquidez
               - Proponha estratégias de otimização
            
            Forneça recomendações para melhoria da gestão de caixa.
            """,
            
            "financial_ratios_analysis": """
            Calcule e analise os principais indicadores financeiros:
            
            1. **Indicadores de Liquidez:**
               - Liquidez Corrente, Seca e Imediata
               - Interpretação e comparação com benchmarks
               - Recomendações para melhoria
            
            2. **Indicadores de Rentabilidade:**
               - Margem Bruta, Operacional e Líquida
               - ROA, ROE e ROI
               - Análise de tendências e comparação setorial
            
            3. **Indicadores de Endividamento:**
               - Participação de Capital de Terceiros
               - Composição do Endividamento
               - Grau de Endividamento
            
            4. **Indicadores de Eficiência:**
               - Giro do Ativo, Estoque e Contas a Receber
               - Análise de eficiência operacional
               - Identificação de gargalos
            
            Forneça uma análise comparativa e recomendações específicas.
            """,
            
            "trend_analysis": """
            Realize análise de tendências dos indicadores financeiros:
            
            1. **Análise Temporal:**
               - Evolução dos principais indicadores
               - Identificação de tendências de crescimento/declínio
               - Análise de sazonalidade
            
            2. **Análise Comparativa:**
               - Comparação com períodos anteriores
               - Análise de variações significativas
               - Identificação de pontos de inflexão
            
            3. **Análise Setorial:**
               - Comparação com benchmarks do setor
               - Identificação de posicionamento competitivo
               - Análise de performance relativa
            
            4. **Projeções:**
               - Projeções baseadas em tendências históricas
               - Cenários otimista, realista e pessimista
               - Identificação de riscos e oportunidades
            
            Forneça insights estratégicos e recomendações de ação.
            """,
            
            "budget_analysis": """
            Analise o orçamento e projeções financeiras:
            
            1. **Análise Orçamentária:**
               - Comparação orçado vs realizado
               - Identificação de desvios significativos
               - Análise das causas dos desvios
            
            2. **Análise de Projeções:**
               - Avaliação da qualidade das projeções
               - Identificação de premissas críticas
               - Análise de cenários alternativos
            
            3. **Análise de Performance:**
               - Avaliação do cumprimento de metas
               - Identificação de indicadores de alerta
               - Análise de performance por área
            
            4. **Recomendações:**
               - Ajustes necessários no orçamento
               - Melhorias no processo de planejamento
               - Estratégias para cumprimento de metas
            
            Forneça insights sobre o processo de planejamento e recomendações de melhoria.
            """,
            
            "cost_analysis": """
            Analise a estrutura de custos da empresa:
            
            1. **Análise de Custos por Categoria:**
               - Custos diretos vs indiretos
               - Custos fixos vs variáveis
               - Análise de comportamento dos custos
            
            2. **Análise de Rentabilidade por Produto/Serviço:**
               - Margem de contribuição por produto
               - Análise de rentabilidade relativa
               - Identificação de produtos/serviços críticos
            
            3. **Análise de Eficiência:**
               - Análise de produtividade
               - Identificação de gargalos operacionais
               - Análise de utilização de recursos
            
            4. **Otimização de Custos:**
               - Identificação de oportunidades de redução
               - Análise de trade-offs
               - Estratégias de otimização
            
            Forneça recomendações específicas para otimização de custos.
            """,
            
            "risk_analysis": """
            Analise os riscos financeiros da empresa:
            
            1. **Riscos de Liquidez:**
               - Análise de capacidade de pagamento
               - Identificação de riscos de liquidez
               - Estratégias de mitigação
            
            2. **Riscos de Crédito:**
               - Análise de inadimplência
               - Avaliação de política de crédito
               - Estratégias de gestão de risco
            
            3. **Riscos Operacionais:**
               - Análise de dependência de fornecedores
               - Identificação de riscos operacionais
               - Estratégias de diversificação
            
            4. **Riscos de Mercado:**
               - Análise de exposição a variações cambiais
               - Identificação de riscos de taxa de juros
               - Estratégias de hedge
            
            Forneça uma matriz de riscos e recomendações de mitigação.
            """
        }
        
        return prompts
    
    def generate_question_templates(self) -> Dict[str, List[str]]:
        """Gera templates de perguntas para NotebookLM"""
        logger.info("Gerando templates de perguntas...")
        
        questions = {
            "financial_analysis": [
                "Qual a evolução da receita nos últimos 12 meses?",
                "Como está a margem de lucro da empresa?",
                "Quais são os principais custos operacionais?",
                "Como está a situação de liquidez?",
                "Qual a estrutura de endividamento?",
                "Como está a rentabilidade dos investimentos?",
                "Quais são os principais indicadores financeiros?",
                "Como está a performance em relação ao setor?"
            ],
            
            "trend_analysis": [
                "Qual a tendência de crescimento da empresa?",
                "Como estão evoluindo os custos operacionais?",
                "Qual a sazonalidade das receitas?",
                "Como está a evolução da margem de lucro?",
                "Quais são as tendências de mercado?",
                "Como está a evolução do patrimônio líquido?",
                "Qual a tendência dos indicadores de liquidez?",
                "Como estão evoluindo os investimentos?"
            ],
            
            "budget_analysis": [
                "Como está o cumprimento do orçamento?",
                "Quais são os principais desvios orçamentários?",
                "Como está a performance por área?",
                "Quais são as projeções para o próximo período?",
                "Como está a qualidade das previsões?",
                "Quais são os riscos orçamentários?",
                "Como está a eficiência do planejamento?",
                "Quais são as oportunidades de melhoria?"
            ],
            
            "cost_analysis": [
                "Quais são os principais componentes de custos?",
                "Como está a evolução dos custos por categoria?",
                "Qual a rentabilidade por produto/serviço?",
                "Quais são os gargalos operacionais?",
                "Como está a eficiência produtiva?",
                "Quais são as oportunidades de redução de custos?",
                "Como está a alocação de custos indiretos?",
                "Quais são os custos críticos da operação?"
            ],
            
            "risk_analysis": [
                "Quais são os principais riscos financeiros?",
                "Como está a exposição a riscos de crédito?",
                "Quais são os riscos de liquidez?",
                "Como está a gestão de riscos operacionais?",
                "Quais são os riscos de mercado?",
                "Como está a diversificação de riscos?",
                "Quais são as estratégias de mitigação?",
                "Como está o monitoramento de riscos?"
            ]
        }
        
        return questions
    
    def generate_analysis_config(self) -> Dict[str, Any]:
        """Gera configuração de análise para NotebookLM"""
        logger.info("Gerando configuração de análise...")
        
        config = {
            "analysis_config": {
                "version": "1.0.0",
                "company": "Empresa Exemplo Ltda",
                "analysis_period": "2024",
                "currency": "BRL",
                "language": "pt-BR",
                "analysis_focus": [
                    "Análise de rentabilidade",
                    "Gestão de fluxo de caixa",
                    "Controle de custos",
                    "Análise de indicadores financeiros",
                    "Projeções e planejamento"
                ],
                "key_metrics": [
                    "Receita Líquida",
                    "Margem Bruta",
                    "Margem Operacional",
                    "Margem Líquida",
                    "ROA (Retorno sobre Ativos)",
                    "ROE (Retorno sobre Patrimônio)",
                    "Liquidez Corrente",
                    "Liquidez Seca",
                    "Endividamento",
                    "Giro do Ativo"
                ],
                "analysis_frequency": {
                    "daily": ["Posição de Caixa", "Vendas do Dia"],
                    "weekly": ["Resumo de Vendas", "Análise de Custos"],
                    "monthly": ["Demonstrações Financeiras", "Análise de Variações"],
                    "quarterly": ["Análise Completa", "Tendências"],
                    "annually": ["Auditoria", "Orçamento"]
                },
                "reporting_templates": [
                    {
                        "name": "Relatório Executivo Mensal",
                        "sections": [
                            "Resumo Executivo",
                            "Análise de Receitas",
                            "Análise de Custos",
                            "Indicadores Financeiros",
                            "Projeções"
                        ]
                    },
                    {
                        "name": "Análise de Liquidez",
                        "sections": [
                            "Posição de Caixa",
                            "Fluxo de Caixa Projetado",
                            "Análise de Contas a Receber",
                            "Análise de Contas a Pagar"
                        ]
                    }
                ],
                "data_sources": [
                    "Sistema ERP",
                    "Extratos Bancários",
                    "Notas Fiscais",
                    "Folha de Pagamento",
                    "Relatórios Contábeis"
                ],
                "integration_settings": {
                    "auto_refresh": True,
                    "real_time_analysis": True,
                    "alert_thresholds": {
                        "liquidity_ratio": 1.0,
                        "debt_ratio": 0.5,
                        "profit_margin": 0.05
                    }
                }
            }
        }
        
        return config
    
    def export_prompts(self, prompts: Dict[str, str], filename: str = "analysis_prompts.json"):
        """Exporta prompts para arquivo JSON"""
        logger.info(f"Exportando prompts para: {filename}")
        
        export_data = {
            "notebooklm_prompts": {
                "version": "1.0.0",
                "export_date": datetime.now().isoformat(),
                "prompts": prompts
            }
        }
        
        export_path = self.prompts_path / filename
        with open(export_path, 'w', encoding='utf-8') as f:
            json.dump(export_data, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Prompts exportados com sucesso para: {export_path}")
        return export_path
    
    def export_questions(self, questions: Dict[str, List[str]], filename: str = "question_templates.json"):
        """Exporta templates de perguntas para arquivo JSON"""
        logger.info(f"Exportando templates de perguntas para: {filename}")
        
        export_data = {
            "notebooklm_questions": {
                "version": "1.0.0",
                "export_date": datetime.now().isoformat(),
                "questions": questions
            }
        }
        
        export_path = self.prompts_path / filename
        with open(export_path, 'w', encoding='utf-8') as f:
            json.dump(export_data, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Templates de perguntas exportados para: {export_path}")
        return export_path
    
    def export_config(self, config: Dict[str, Any], filename: str = "analysis_config.json"):
        """Exporta configuração de análise para arquivo JSON"""
        logger.info(f"Exportando configuração para: {filename}")
        
        export_path = self.prompts_path / filename
        with open(export_path, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Configuração exportada para: {export_path}")
        return export_path
    
    def generate_notebooklm_setup(self) -> str:
        """Gera instruções de configuração do NotebookLM"""
        logger.info("Gerando instruções de configuração do NotebookLM...")
        
        setup_instructions = """
        # Configuração do NotebookLM para Análise Contábil
        
        ## 1. Preparação dos Dados
        
        ### Dados Necessários:
        - Balanço Patrimonial (últimos 12 meses)
        - Demonstração do Resultado (últimos 12 meses)
        - Fluxo de Caixa (últimos 12 meses)
        - Dados de Orçamento (se disponível)
        
        ### Formato dos Dados:
        - Arquivos CSV ou Excel
        - Codificação UTF-8
        - Separador decimal: vírgula (,)
        - Formato de data: DD/MM/AAAA
        
        ## 2. Configuração do NotebookLM
        
        ### Passo 1: Criar Novo Notebook
        1. Acesse o NotebookLM
        2. Clique em "Criar Novo Notebook"
        3. Selecione "Análise Contábil"
        
        ### Passo 2: Importar Dados
        1. Faça upload dos arquivos de dados
        2. Configure o mapeamento de campos
        3. Valide a importação
        
        ### Passo 3: Configurar Análises
        1. Selecione os tipos de análise desejados
        2. Configure os períodos de análise
        3. Defina os indicadores-chave
        
        ## 3. Prompts Especializados
        
        ### Análise de Balanço:
        "Analise o balanço patrimonial da empresa, identificando pontos fortes e fracos na estrutura financeira, com foco em liquidez, endividamento e composição do patrimônio."
        
        ### Análise de DRE:
        "Examine a demonstração do resultado do exercício, analisando a evolução das receitas, custos e despesas, identificando tendências e oportunidades de melhoria."
        
        ### Análise de Fluxo de Caixa:
        "Avalie o fluxo de caixa da empresa, identificando as principais fontes e usos de recursos, e propondo estratégias para otimização da gestão financeira."
        
        ## 4. Perguntas Sugeridas
        
        ### Perguntas Básicas:
        - Qual a evolução da receita nos últimos 12 meses?
        - Como está a margem de lucro da empresa?
        - Quais são os principais custos operacionais?
        - Como está a situação de liquidez?
        
        ### Perguntas Avançadas:
        - Qual a projeção de crescimento para o próximo ano?
        - Quais são os principais riscos financeiros?
        - Como está a performance em relação ao setor?
        - Quais são as oportunidades de otimização?
        
        ## 5. Relatórios Automáticos
        
        ### Relatório Mensal:
        - Resumo Executivo
        - Análise de Receitas
        - Análise de Custos
        - Indicadores Financeiros
        - Projeções
        
        ### Relatório Trimestral:
        - Demonstrações Financeiras
        - Análise Comparativa
        - Indicadores de Performance
        - Análise de Tendências
        - Recomendações Estratégicas
        
        ## 6. Integração com Sistemas
        
        ### ERP:
        - Configurar conexão com sistema ERP
        - Mapear campos de dados
        - Configurar sincronização automática
        
        ### Bancos:
        - Integrar com extratos bancários
        - Configurar conciliação automática
        - Monitorar posição de caixa
        
        ## 7. Monitoramento e Alertas
        
        ### Indicadores de Alerta:
        - Liquidez abaixo de 1.0
        - Endividamento acima de 50%
        - Margem de lucro abaixo de 5%
        
        ### Ações Automáticas:
        - Envio de relatórios por email
        - Alertas por WhatsApp/SMS
        - Notificações no sistema
        
        ## 8. Manutenção e Atualização
        
        ### Frequência de Atualização:
        - Dados diários: Posição de caixa
        - Dados semanais: Vendas e custos
        - Dados mensais: Demonstrações completas
        
        ### Backup e Segurança:
        - Backup diário dos dados
        - Criptografia de dados sensíveis
        - Controle de acesso por usuário
        
        ## 9. Suporte e Treinamento
        
        ### Documentação:
        - Manual do usuário
        - Guias de configuração
        - FAQ e troubleshooting
        
        ### Treinamento:
        - Sessões de treinamento online
        - Materiais de apoio
        - Suporte técnico especializado
        
        ## 10. Próximos Passos
        
        1. Configurar o ambiente
        2. Importar dados históricos
        3. Configurar análises automáticas
        4. Treinar equipe
        5. Implementar monitoramento
        6. Otimizar processos
        
        ---
        
        **Última atualização**: $(date)
        **Versão**: 1.0.0
        **Status**: ✅ Configuração Completa
        """
        
        return setup_instructions
    
    def run_integration(self):
        """Executa a integração completa com NotebookLM"""
        logger.info("Iniciando integração com NotebookLM...")
        
        # Gerar prompts de análise
        prompts = self.generate_analysis_prompts()
        self.export_prompts(prompts)
        
        # Gerar templates de perguntas
        questions = self.generate_question_templates()
        self.export_questions(questions)
        
        # Gerar configuração de análise
        config = self.generate_analysis_config()
        self.export_config(config)
        
        # Gerar instruções de configuração
        setup_instructions = self.generate_notebooklm_setup()
        
        # Salvar instruções
        setup_path = Path("analysis/notebooklm_setup.md")
        with open(setup_path, 'w', encoding='utf-8') as f:
            f.write(setup_instructions)
        
        logger.info("Integração com NotebookLM concluída com sucesso!")
        logger.info(f"Arquivos gerados em: {self.prompts_path}")
        logger.info(f"Instruções de configuração: {setup_path}")

def main():
    """Função principal"""
    integration = NotebookLMIntegration()
    integration.run_integration()

if __name__ == "__main__":
    main()
