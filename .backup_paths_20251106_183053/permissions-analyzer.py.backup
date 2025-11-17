#!/usr/bin/env python3
"""
Script de análise avançada de permissões
Analisa permissões de forma mais detalhada e gera relatórios em formato JSON
"""

import os
import stat
import json
import csv
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional
import argparse
import logging

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class PermissionsAnalyzer:
    """Analisador avançado de permissões"""
    
    def __init__(self, target_dir: str = "/Users/luiz.sena88"):
        """Inicializa o analisador"""
        self.target_dir = Path(target_dir)
        self.analysis_data = {
            "metadata": {
                "target_directory": str(self.target_dir),
                "analysis_date": datetime.now().isoformat(),
                "analyzer_version": "1.0.0"
            },
            "summary": {
                "total_items": 0,
                "directories": 0,
                "files": 0,
                "symlinks": 0,
                "total_size": 0,
                "permission_issues": 0
            },
            "permissions": {
                "readable": 0,
                "writable": 0,
                "executable": 0,
                "unreadable": 0,
                "unwritable": 0,
                "unexecutable": 0
            },
            "file_types": {},
            "largest_files": [],
            "permission_issues": [],
            "directory_structure": {}
        }
    
    def analyze_permissions(self, max_depth: int = 10) -> Dict[str, Any]:
        """Analisa permissões recursivamente"""
        logger.info(f"Iniciando análise de permissões em: {self.target_dir}")
        
        if not self.target_dir.exists():
            raise FileNotFoundError(f"Diretório não encontrado: {self.target_dir}")
        
        if not self.target_dir.is_dir():
            raise NotADirectoryError(f"O caminho não é um diretório: {self.target_dir}")
        
        # Analisar diretório recursivamente
        self._analyze_directory_recursive(self.target_dir, max_depth, 0)
        
        # Calcular estatísticas finais
        self._calculate_final_statistics()
        
        logger.info("Análise de permissões concluída")
        return self.analysis_data
    
    def _analyze_directory_recursive(self, directory: Path, max_depth: int, current_depth: int):
        """Analisa diretório recursivamente"""
        if current_depth > max_depth:
            logger.warning(f"Profundidade máxima atingida: {directory}")
            return
        
        try:
            # Analisar o próprio diretório
            self._analyze_item(directory, current_depth)
            
            # Analisar conteúdo do diretório
            if directory.is_dir() and os.access(directory, os.R_OK):
                for item in directory.iterdir():
                    if item.is_dir():
                        self._analyze_directory_recursive(item, max_depth, current_depth + 1)
                    else:
                        self._analyze_item(item, current_depth + 1)
        except PermissionError:
            logger.warning(f"Sem permissão para acessar: {directory}")
            self.analysis_data["permission_issues"] += 1
        except Exception as e:
            logger.error(f"Erro ao analisar {directory}: {e}")
    
    def _analyze_item(self, item_path: Path, depth: int):
        """Analisa um item específico (arquivo ou diretório)"""
        try:
            # Informações básicas
            stat_info = item_path.stat()
            item_type = "directory" if item_path.is_dir() else "file"
            
            # Contar itens
            if item_path.is_dir():
                self.analysis_data["summary"]["directories"] += 1
            else:
                self.analysis_data["summary"]["files"] += 1
                # Tamanho do arquivo
                file_size = stat_info.st_size
                self.analysis_data["summary"]["total_size"] += file_size
                
                # Adicionar aos maiores arquivos
                self._add_to_largest_files(item_path, file_size)
            
            # Analisar permissões
            self._analyze_item_permissions(item_path, stat_info)
            
            # Analisar tipo de arquivo
            if item_path.is_file():
                self._analyze_file_type(item_path)
            
            # Estrutura de diretórios
            self._update_directory_structure(item_path, depth)
            
        except Exception as e:
            logger.error(f"Erro ao analisar item {item_path}: {e}")
            self.analysis_data["summary"]["permission_issues"] += 1
    
    def _analyze_item_permissions(self, item_path: Path, stat_info: os.stat_result):
        """Analisa permissões de um item"""
        # Verificar permissões de leitura
        if os.access(item_path, os.R_OK):
            self.analysis_data["permissions"]["readable"] += 1
        else:
            self.analysis_data["permissions"]["unreadable"] += 1
            self._add_permission_issue(item_path, "Sem permissão de leitura")
        
        # Verificar permissões de escrita
        if os.access(item_path, os.W_OK):
            self.analysis_data["permissions"]["writable"] += 1
        else:
            self.analysis_data["permissions"]["unwritable"] += 1
            if not item_path.is_dir():  # Diretórios sem escrita são mais críticos
                self._add_permission_issue(item_path, "Sem permissão de escrita")
        
        # Verificar permissões de execução
        if os.access(item_path, os.X_OK):
            self.analysis_data["permissions"]["executable"] += 1
        else:
            self.analysis_data["permissions"]["unexecutable"] += 1
            if item_path.is_dir():  # Diretórios sem execução são críticos
                self._add_permission_issue(item_path, "Sem permissão de execução")
    
    def _analyze_file_type(self, file_path: Path):
        """Analisa tipo de arquivo"""
        suffix = file_path.suffix.lower()
        if suffix:
            if suffix not in self.analysis_data["file_types"]:
                self.analysis_data["file_types"][suffix] = 0
            self.analysis_data["file_types"][suffix] += 1
    
    def _add_to_largest_files(self, file_path: Path, file_size: int):
        """Adiciona arquivo à lista dos maiores"""
        largest_files = self.analysis_data["largest_files"]
        
        # Adicionar arquivo à lista
        largest_files.append({
            "path": str(file_path),
            "size": file_size,
            "size_formatted": self._format_size(file_size)
        })
        
        # Manter apenas os 10 maiores
        largest_files.sort(key=lambda x: x["size"], reverse=True)
        if len(largest_files) > 10:
            largest_files.pop()
    
    def _add_permission_issue(self, item_path: Path, issue: str):
        """Adiciona problema de permissão à lista"""
        self.analysis_data["permission_issues"].append({
            "path": str(item_path),
            "issue": issue,
            "timestamp": datetime.now().isoformat()
        })
    
    def _update_directory_structure(self, item_path: Path, depth: int):
        """Atualiza estrutura de diretórios"""
        if depth <= 3:  # Limitar profundidade para estrutura
            relative_path = str(item_path.relative_to(self.target_dir))
            if relative_path == ".":
                relative_path = "/"
            
            if relative_path not in self.analysis_data["directory_structure"]:
                self.analysis_data["directory_structure"][relative_path] = {
                    "depth": depth,
                    "item_count": 0,
                    "total_size": 0
                }
            
            self.analysis_data["directory_structure"][relative_path]["item_count"] += 1
            if item_path.is_file():
                self.analysis_data["directory_structure"][relative_path]["total_size"] += item_path.stat().st_size
    
    def _calculate_final_statistics(self):
        """Calcula estatísticas finais"""
        summary = self.analysis_data["summary"]
        summary["total_items"] = summary["directories"] + summary["files"]
        
        # Calcular percentuais de permissões
        total_items = summary["total_items"]
        if total_items > 0:
            permissions = self.analysis_data["permissions"]
            permissions["read_percentage"] = (permissions["readable"] / total_items) * 100
            permissions["write_percentage"] = (permissions["writable"] / total_items) * 100
            permissions["execute_percentage"] = (permissions["executable"] / total_items) * 100
    
    def _format_size(self, size_bytes: int) -> str:
        """Formata tamanho em bytes para formato legível"""
        for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
            if size_bytes < 1024.0:
                return f"{size_bytes:.1f}{unit}"
            size_bytes /= 1024.0
        return f"{size_bytes:.1f}PB"
    
    def export_to_json(self, output_file: str = None) -> str:
        """Exporta análise para arquivo JSON"""
        if output_file is None:
            output_file = f"permissions-analysis-{datetime.now().strftime('%Y%m%d-%H%M%S')}.json"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(self.analysis_data, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Análise exportada para: {output_file}")
        return output_file
    
    def export_to_csv(self, output_file: str = None) -> str:
        """Exporta problemas de permissão para CSV"""
        if output_file is None:
            output_file = f"permission-issues-{datetime.now().strftime('%Y%m%d-%H%M%S')}.csv"
        
        with open(output_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['Path', 'Issue', 'Timestamp'])
            
            for issue in self.analysis_data["permission_issues"]:
                writer.writerow([issue['path'], issue['issue'], issue['timestamp']])
        
        logger.info(f"Problemas de permissão exportados para: {output_file}")
        return output_file
    
    def generate_report(self) -> str:
        """Gera relatório em texto"""
        report_lines = []
        
        # Cabeçalho
        report_lines.append("🔍 RELATÓRIO DE ANÁLISE DE PERMISSÕES")
        report_lines.append("=" * 50)
        report_lines.append(f"Data: {self.analysis_data['metadata']['analysis_date']}")
        report_lines.append(f"Diretório: {self.analysis_data['metadata']['target_directory']}")
        report_lines.append("")
        
        # Resumo
        summary = self.analysis_data["summary"]
        report_lines.append("📊 RESUMO GERAL:")
        report_lines.append("-" * 20)
        report_lines.append(f"Total de itens: {summary['total_items']}")
        report_lines.append(f"Diretórios: {summary['directories']}")
        report_lines.append(f"Arquivos: {summary['files']}")
        report_lines.append(f"Tamanho total: {self._format_size(summary['total_size'])}")
        report_lines.append(f"Problemas encontrados: {len(self.analysis_data['permission_issues'])}")
        report_lines.append("")
        
        # Permissões
        permissions = self.analysis_data["permissions"]
        report_lines.append("🔐 PERMISSÕES:")
        report_lines.append("-" * 15)
        report_lines.append(f"Legíveis: {permissions['readable']} ({permissions.get('read_percentage', 0):.1f}%)")
        report_lines.append(f"Graváveis: {permissions['writable']} ({permissions.get('write_percentage', 0):.1f}%)")
        report_lines.append(f"Executáveis: {permissions['executable']} ({permissions.get('execute_percentage', 0):.1f}%)")
        report_lines.append("")
        
        # Tipos de arquivo
        if self.analysis_data["file_types"]:
            report_lines.append("📄 TIPOS DE ARQUIVO:")
            report_lines.append("-" * 20)
            sorted_types = sorted(self.analysis_data["file_types"].items(), key=lambda x: x[1], reverse=True)
            for ext, count in sorted_types[:10]:  # Top 10
                report_lines.append(f"  {ext}: {count} arquivos")
            report_lines.append("")
        
        # Maiores arquivos
        if self.analysis_data["largest_files"]:
            report_lines.append("📁 MAIORES ARQUIVOS:")
            report_lines.append("-" * 20)
            for file_info in self.analysis_data["largest_files"][:5]:  # Top 5
                report_lines.append(f"  {file_info['size_formatted']} - {file_info['path']}")
            report_lines.append("")
        
        # Problemas de permissão
        if self.analysis_data["permission_issues"]:
            report_lines.append("⚠️  PROBLEMAS DE PERMISSÃO:")
            report_lines.append("-" * 30)
            for issue in self.analysis_data["permission_issues"][:10]:  # Top 10
                report_lines.append(f"  {issue['issue']}: {issue['path']}")
            report_lines.append("")
        
        return "\n".join(report_lines)

def main():
    """Função principal"""
    parser = argparse.ArgumentParser(description="Analisador avançado de permissões")
    parser.add_argument("-d", "--directory", default="/Users/luiz.sena88", 
                       help="Diretório a ser analisado")
    parser.add_argument("-m", "--max-depth", type=int, default=10,
                       help="Profundidade máxima de análise")
    parser.add_argument("-o", "--output", help="Arquivo de saída JSON")
    parser.add_argument("-c", "--csv", help="Arquivo CSV para problemas de permissão")
    parser.add_argument("-r", "--report", help="Arquivo de relatório em texto")
    parser.add_argument("-v", "--verbose", action="store_true", help="Modo verboso")
    
    args = parser.parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    try:
        # Criar analisador
        analyzer = PermissionsAnalyzer(args.directory)
        
        # Executar análise
        logger.info("Iniciando análise de permissões...")
        analysis_data = analyzer.analyze_permissions(args.max_depth)
        
        # Exportar resultados
        json_file = analyzer.export_to_json(args.output)
        
        if args.csv:
            analyzer.export_to_csv(args.csv)
        
        # Gerar relatório
        report = analyzer.generate_report()
        print(report)
        
        if args.report:
            with open(args.report, 'w', encoding='utf-8') as f:
                f.write(report)
            logger.info(f"Relatório salvo em: {args.report}")
        
        logger.info("Análise concluída com sucesso!")
        
    except Exception as e:
        logger.error(f"Erro durante a análise: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
