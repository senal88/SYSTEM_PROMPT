#!/usr/bin/env python3
"""
Script de processamento de dados contábeis para NotebookLM
Processa dados brutos e os converte para formato estruturado
"""

import json
import csv
import pandas as pd
from datetime import datetime, timedelta
from pathlib import Path
import logging
from typing import Dict, List, Any, Optional

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class AccountingDataProcessor:
    """Processador de dados contábeis para NotebookLM"""
    
    def __init__(self, config_path: str = "config/notebooklm_config.json"):
        """Inicializa o processador com configurações"""
        self.config_path = Path(config_path)
        self.config = self.load_config()
        self.data_path = Path("data")
        self.processed_path = self.data_path / "processed"
        self.exports_path = self.data_path / "exports"
        
        # Criar diretórios se não existirem
        self.processed_path.mkdir(parents=True, exist_ok=True)
        self.exports_path.mkdir(parents=True, exist_ok=True)
    
    def load_config(self) -> Dict[str, Any]:
        """Carrega configurações do arquivo JSON"""
        try:
            with open(self.config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            logger.error(f"Arquivo de configuração não encontrado: {self.config_path}")
            return {}
        except json.JSONDecodeError as e:
            logger.error(f"Erro ao decodificar JSON: {e}")
            return {}
    
    def process_balance_sheet(self, raw_data: Dict[str, Any]) -> Dict[str, Any]:
        """Processa dados do balanço patrimonial"""
        logger.info("Processando balanço patrimonial...")
        
        # Estrutura base do balanço
        balance_sheet = {
            "company": raw_data.get("company", ""),
            "period": raw_data.get("period", ""),
            "currency": "BRL",
            "assets": {
                "current_assets": {
                    "cash_and_equivalents": {
                        "cash": raw_data.get("cash", 0),
                        "bank_accounts": raw_data.get("bank_accounts", 0),
                        "financial_investments": raw_data.get("financial_investments", 0)
                    },
                    "receivables": {
                        "customers": raw_data.get("customers", 0),
                        "notes_receivable": raw_data.get("notes_receivable", 0)
                    },
                    "inventory": {
                        "merchandise": raw_data.get("merchandise", 0),
                        "raw_materials": raw_data.get("raw_materials", 0)
                    }
                },
                "non_current_assets": {
                    "long_term_receivables": raw_data.get("long_term_receivables", 0),
                    "investments": raw_data.get("investments", 0),
                    "fixed_assets": {
                        "real_estate": raw_data.get("real_estate", 0),
                        "machinery": raw_data.get("machinery", 0),
                        "vehicles": raw_data.get("vehicles", 0),
                        "accumulated_depreciation": raw_data.get("accumulated_depreciation", 0)
                    }
                }
            },
            "liabilities": {
                "current_liabilities": {
                    "suppliers": raw_data.get("suppliers", 0),
                    "loans_and_financing": raw_data.get("current_loans", 0),
                    "tax_and_labor_obligations": raw_data.get("tax_obligations", 0)
                },
                "non_current_liabilities": {
                    "long_term_loans": raw_data.get("long_term_loans", 0),
                    "provisions": raw_data.get("provisions", 0)
                }
            },
            "equity": {
                "share_capital": raw_data.get("share_capital", 0),
                "capital_reserves": raw_data.get("capital_reserves", 0),
                "retained_earnings": raw_data.get("retained_earnings", 0),
                "accumulated_profits_losses": raw_data.get("accumulated_profits", 0)
            }
        }
        
        # Calcular totais
        balance_sheet["totals"] = self.calculate_balance_totals(balance_sheet)
        
        # Calcular métricas de análise
        balance_sheet["analysis_metrics"] = self.calculate_balance_metrics(balance_sheet)
        
        return balance_sheet
    
    def process_income_statement(self, raw_data: Dict[str, Any]) -> Dict[str, Any]:
        """Processa dados da demonstração do resultado"""
        logger.info("Processando demonstração do resultado...")
        
        income_statement = {
            "company": raw_data.get("company", ""),
            "period": raw_data.get("period", ""),
            "currency": "BRL",
            "revenue": {
                "gross_revenue": {
                    "product_sales": raw_data.get("product_sales", 0),
                    "service_revenue": raw_data.get("service_revenue", 0),
                    "other_revenue": raw_data.get("other_revenue", 0)
                },
                "revenue_deductions": {
                    "sales_taxes": raw_data.get("sales_taxes", 0),
                    "returns_and_cancellations": raw_data.get("returns", 0),
                    "discounts": raw_data.get("discounts", 0)
                }
            },
            "costs_and_expenses": {
                "cost_of_sales": {
                    "cost_of_goods_sold": raw_data.get("cost_of_goods_sold", 0),
                    "cost_of_services": raw_data.get("cost_of_services", 0)
                },
                "operating_expenses": {
                    "administrative_expenses": raw_data.get("admin_expenses", 0),
                    "selling_expenses": raw_data.get("selling_expenses", 0)
                },
                "financial_expenses": raw_data.get("financial_expenses", 0),
                "other_expenses": raw_data.get("other_expenses", 0)
            },
            "financial_income": {
                "interest_income": raw_data.get("interest_income", 0),
                "other_financial_income": raw_data.get("other_financial_income", 0)
            }
        }
        
        # Calcular totais
        income_statement["calculated_totals"] = self.calculate_income_totals(income_statement)
        
        # Calcular métricas de análise
        income_statement["analysis_metrics"] = self.calculate_income_metrics(income_statement)
        
        return income_statement
    
    def calculate_balance_totals(self, balance_sheet: Dict[str, Any]) -> Dict[str, Any]:
        """Calcula totais do balanço patrimonial"""
        # Total do Ativo
        current_assets = (
            balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["cash"] +
            balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["bank_accounts"] +
            balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["financial_investments"] +
            balance_sheet["assets"]["current_assets"]["receivables"]["customers"] +
            balance_sheet["assets"]["current_assets"]["receivables"]["notes_receivable"] +
            balance_sheet["assets"]["current_assets"]["inventory"]["merchandise"] +
            balance_sheet["assets"]["current_assets"]["inventory"]["raw_materials"]
        )
        
        non_current_assets = (
            balance_sheet["assets"]["non_current_assets"]["long_term_receivables"] +
            balance_sheet["assets"]["non_current_assets"]["investments"] +
            balance_sheet["assets"]["non_current_assets"]["fixed_assets"]["real_estate"] +
            balance_sheet["assets"]["non_current_assets"]["fixed_assets"]["machinery"] +
            balance_sheet["assets"]["non_current_assets"]["fixed_assets"]["vehicles"] +
            balance_sheet["assets"]["non_current_assets"]["fixed_assets"]["accumulated_depreciation"]
        )
        
        total_assets = current_assets + non_current_assets
        
        # Total do Passivo
        current_liabilities = (
            balance_sheet["liabilities"]["current_liabilities"]["suppliers"] +
            balance_sheet["liabilities"]["current_liabilities"]["loans_and_financing"] +
            balance_sheet["liabilities"]["current_liabilities"]["tax_and_labor_obligations"]
        )
        
        non_current_liabilities = (
            balance_sheet["liabilities"]["non_current_liabilities"]["long_term_loans"] +
            balance_sheet["liabilities"]["non_current_liabilities"]["provisions"]
        )
        
        total_liabilities = current_liabilities + non_current_liabilities
        
        # Total do Patrimônio Líquido
        total_equity = (
            balance_sheet["equity"]["share_capital"] +
            balance_sheet["equity"]["capital_reserves"] +
            balance_sheet["equity"]["retained_earnings"] +
            balance_sheet["equity"]["accumulated_profits_losses"]
        )
        
        return {
            "total_assets": total_assets,
            "total_liabilities": total_liabilities,
            "total_equity": total_equity,
            "balance_check": abs(total_assets - (total_liabilities + total_equity)) < 0.01
        }
    
    def calculate_income_totals(self, income_statement: Dict[str, Any]) -> Dict[str, Any]:
        """Calcula totais da demonstração do resultado"""
        # Receita Líquida
        gross_revenue = (
            income_statement["revenue"]["gross_revenue"]["product_sales"] +
            income_statement["revenue"]["gross_revenue"]["service_revenue"] +
            income_statement["revenue"]["gross_revenue"]["other_revenue"]
        )
        
        revenue_deductions = (
            income_statement["revenue"]["revenue_deductions"]["sales_taxes"] +
            income_statement["revenue"]["revenue_deductions"]["returns_and_cancellations"] +
            income_statement["revenue"]["revenue_deductions"]["discounts"]
        )
        
        net_revenue = gross_revenue - revenue_deductions
        
        # Custo dos Produtos/Serviços Vendidos
        cost_of_sales = (
            income_statement["costs_and_expenses"]["cost_of_sales"]["cost_of_goods_sold"] +
            income_statement["costs_and_expenses"]["cost_of_sales"]["cost_of_services"]
        )
        
        # Lucro Bruto
        gross_profit = net_revenue - cost_of_sales
        
        # Despesas Operacionais
        operating_expenses = (
            income_statement["costs_and_expenses"]["operating_expenses"]["administrative_expenses"] +
            income_statement["costs_and_expenses"]["operating_expenses"]["selling_expenses"]
        )
        
        # Resultado Operacional
        operating_income = gross_profit - operating_expenses
        
        # Resultado Financeiro
        financial_income = (
            income_statement["financial_income"]["interest_income"] +
            income_statement["financial_income"]["other_financial_income"]
        )
        
        financial_expenses = income_statement["costs_and_expenses"]["financial_expenses"]
        financial_result = financial_income - financial_expenses
        
        # Resultado antes dos Impostos
        income_before_taxes = operating_income + financial_result
        
        # Imposto de Renda (estimativa de 15%)
        income_tax = income_before_taxes * 0.15
        
        # Resultado Líquido
        net_income = income_before_taxes - income_tax
        
        return {
            "net_revenue": net_revenue,
            "gross_profit": gross_profit,
            "operating_income": operating_income,
            "financial_result": financial_result,
            "income_before_taxes": income_before_taxes,
            "income_tax": income_tax,
            "net_income": net_income
        }
    
    def calculate_balance_metrics(self, balance_sheet: Dict[str, Any]) -> Dict[str, Any]:
        """Calcula métricas de análise do balanço"""
        current_assets = (
            balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["cash"] +
            balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["bank_accounts"] +
            balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["financial_investments"] +
            balance_sheet["assets"]["current_assets"]["receivables"]["customers"] +
            balance_sheet["assets"]["current_assets"]["receivables"]["notes_receivable"] +
            balance_sheet["assets"]["current_assets"]["inventory"]["merchandise"] +
            balance_sheet["assets"]["current_assets"]["inventory"]["raw_materials"]
        )
        
        current_liabilities = (
            balance_sheet["liabilities"]["current_liabilities"]["suppliers"] +
            balance_sheet["liabilities"]["current_liabilities"]["loans_and_financing"] +
            balance_sheet["liabilities"]["current_liabilities"]["tax_and_labor_obligations"]
        )
        
        total_assets = balance_sheet["totals"]["total_assets"]
        total_liabilities = balance_sheet["totals"]["total_liabilities"]
        total_equity = balance_sheet["totals"]["total_equity"]
        
        return {
            "liquidity_ratios": {
                "current_ratio": current_assets / current_liabilities if current_liabilities > 0 else 0,
                "quick_ratio": (current_assets - balance_sheet["assets"]["current_assets"]["inventory"]["merchandise"] - 
                              balance_sheet["assets"]["current_assets"]["inventory"]["raw_materials"]) / current_liabilities if current_liabilities > 0 else 0,
                "cash_ratio": (balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["cash"] + 
                              balance_sheet["assets"]["current_assets"]["cash_and_equivalents"]["bank_accounts"]) / current_liabilities if current_liabilities > 0 else 0
            },
            "leverage_ratios": {
                "debt_to_equity": total_liabilities / total_equity if total_equity > 0 else 0,
                "debt_to_assets": total_liabilities / total_assets if total_assets > 0 else 0,
                "equity_ratio": total_equity / total_assets if total_assets > 0 else 0
            }
        }
    
    def calculate_income_metrics(self, income_statement: Dict[str, Any]) -> Dict[str, Any]:
        """Calcula métricas de análise da demonstração do resultado"""
        net_revenue = income_statement["calculated_totals"]["net_revenue"]
        gross_profit = income_statement["calculated_totals"]["gross_profit"]
        operating_income = income_statement["calculated_totals"]["operating_income"]
        net_income = income_statement["calculated_totals"]["net_income"]
        
        return {
            "profitability_ratios": {
                "gross_margin": gross_profit / net_revenue if net_revenue > 0 else 0,
                "operating_margin": operating_income / net_revenue if net_revenue > 0 else 0,
                "net_margin": net_income / net_revenue if net_revenue > 0 else 0
            }
        }
    
    def export_to_notebooklm(self, processed_data: Dict[str, Any], filename: str = "accounting_data.json"):
        """Exporta dados processados para formato compatível com NotebookLM"""
        logger.info(f"Exportando dados para NotebookLM: {filename}")
        
        export_data = {
            "notebooklm_export": {
                "version": "1.0.0",
                "export_date": datetime.now().isoformat(),
                "data_type": "accounting",
                "company": processed_data.get("company", ""),
                "period": processed_data.get("period", ""),
                "currency": "BRL",
                "data": processed_data
            }
        }
        
        export_path = self.exports_path / filename
        with open(export_path, 'w', encoding='utf-8') as f:
            json.dump(export_data, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Dados exportados com sucesso para: {export_path}")
        return export_path
    
    def process_csv_file(self, csv_path: str) -> Dict[str, Any]:
        """Processa arquivo CSV com dados contábeis"""
        logger.info(f"Processando arquivo CSV: {csv_path}")
        
        try:
            df = pd.read_csv(csv_path, encoding='utf-8')
            logger.info(f"Arquivo CSV carregado com {len(df)} registros")
            
            # Converter para dicionário
            data = df.to_dict('records')
            
            # Processar dados
            processed_data = {
                "company": "Empresa Exemplo",
                "period": "2024-01",
                "raw_data": data
            }
            
            return processed_data
            
        except Exception as e:
            logger.error(f"Erro ao processar arquivo CSV: {e}")
            return {}
    
    def run_processing(self, input_file: str = None):
        """Executa o processamento completo"""
        logger.info("Iniciando processamento de dados contábeis...")
        
        if input_file:
            # Processar arquivo específico
            if input_file.endswith('.csv'):
                raw_data = self.process_csv_file(input_file)
            else:
                logger.error("Formato de arquivo não suportado")
                return
        else:
            # Usar dados de exemplo
            raw_data = {
                "company": "Empresa Exemplo Ltda",
                "period": "2024-01",
                "cash": 15000.00,
                "bank_accounts": 125000.00,
                "financial_investments": 50000.00,
                "customers": 85000.00,
                "notes_receivable": 25000.00,
                "merchandise": 120000.00,
                "raw_materials": 35000.00,
                "suppliers": 45000.00,
                "current_loans": 30000.00,
                "tax_obligations": 18000.00,
                "long_term_loans": 80000.00,
                "provisions": 10000.00,
                "share_capital": 200000.00,
                "capital_reserves": 25000.00,
                "retained_earnings": 150000.00,
                "accumulated_profits": 125000.00,
                "product_sales": 450000.00,
                "service_revenue": 75000.00,
                "other_revenue": 5000.00,
                "sales_taxes": 45000.00,
                "returns": 2000.00,
                "discounts": 3000.00,
                "cost_of_goods_sold": 180000.00,
                "cost_of_services": 25000.00,
                "admin_expenses": 85000.00,
                "selling_expenses": 45000.00,
                "financial_expenses": 8000.00,
                "other_expenses": 2000.00,
                "interest_income": 3000.00,
                "other_financial_income": 1000.00
            }
        
        # Processar balanço patrimonial
        balance_sheet = self.process_balance_sheet(raw_data)
        
        # Processar demonstração do resultado
        income_statement = self.process_income_statement(raw_data)
        
        # Combinar dados processados
        processed_data = {
            "company": raw_data.get("company", ""),
            "period": raw_data.get("period", ""),
            "balance_sheet": balance_sheet,
            "income_statement": income_statement
        }
        
        # Exportar para NotebookLM
        export_path = self.export_to_notebooklm(processed_data)
        
        logger.info("Processamento concluído com sucesso!")
        return processed_data

def main():
    """Função principal"""
    processor = AccountingDataProcessor()
    processor.run_processing()

if __name__ == "__main__":
    main()
