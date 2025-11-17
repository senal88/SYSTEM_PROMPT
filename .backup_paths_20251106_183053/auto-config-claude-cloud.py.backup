#!/usr/bin/env python3
"""
Script Automatizado para Claude Cloud Pro
- Verifica MCP conectado
- Revisa contexto e dados gerados
- Preenche configurações gerais automaticamente
- Gera prompt para Claude Cloud
- Direciona arquivos para upload

Autor: Luiz Fernando Moreira Sena
Versão: 1.0.0
"""

import json
import os
import sys
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import subprocess


class ClaudeCloudProAutomation:
    """Automação completa para Claude Cloud Pro"""

    def __init__(self, base_dir: str = None):
        """Inicializa com diretório base"""
        if base_dir is None:
            base_dir = os.path.expanduser("~/Dotfiles")
        self.base_dir = Path(base_dir)
        self.context_dir = self.base_dir / "context-engineering"
        self.claude_knowledge_dir = self.base_dir / "claude-cloud-knowledge"
        self.templates_dir = self.context_dir / "templates"
        self.results = {
            "mcp_status": {},
            "config_files": [],
            "context_files": [],
            "validation": {},
            "upload_instructions": []
        }

    def verificar_mcp(self) -> Dict:
        """Verifica se MCP está conectado e configurado"""
        print("🔍 Verificando configuração MCP...")

        mcp_configs = []

        # Verificar configuração Claude Desktop
        claude_desktop_config = Path.home() / "Library/Application Support/Claude/claude_desktop_config.json"
        if claude_desktop_config.exists():
            try:
                with open(claude_desktop_config, 'r') as f:
                    config = json.load(f)
                    if "mcpServers" in config:
                        mcp_configs.append({
                            "tipo": "Claude Desktop",
                            "arquivo": str(claude_desktop_config),
                            "servidores": list(config["mcpServers"].keys())
                        })
            except Exception as e:
                print(f"⚠️  Erro ao ler Claude Desktop config: {e}")

        # Verificar arquivos MCP no projeto
        mcp_files = [
            self.base_dir / "cursor/claude-task-master/.mcp.json",
            self.claude_knowledge_dir / "01_CONFIGURACOES/claude_desktop_config.json"
        ]

        for mcp_file in mcp_files:
            if mcp_file.exists():
                try:
                    with open(mcp_file, 'r') as f:
                        config = json.load(f)
                        if "mcpServers" in config:
                            mcp_configs.append({
                                "tipo": "Projeto",
                                "arquivo": str(mcp_file),
                                "servidores": list(config["mcpServers"].keys())
                            })
                except Exception as e:
                    print(f"⚠️  Erro ao ler {mcp_file}: {e}")

        # Verificar se task-master-ai está disponível
        try:
            result = subprocess.run(
                ["npx", "-y", "task-master-ai", "--version"],
                capture_output=True,
                timeout=5
            )
            task_master_available = result.returncode == 0
        except:
            task_master_available = False

        status = {
            "conectado": len(mcp_configs) > 0,
            "configuracoes": mcp_configs,
            "task_master_disponivel": task_master_available,
            "status": "✅ MCP configurado" if len(mcp_configs) > 0 else "⚠️  MCP não encontrado"
        }

        self.results["mcp_status"] = status
        print(f"   {status['status']}")
        if mcp_configs:
            for cfg in mcp_configs:
                print(f"   - {cfg['tipo']}: {len(cfg['servidores'])} servidor(es)")

        return status

    def revisar_contexto(self) -> Dict:
        """Revisa todos os arquivos de contexto e configuração"""
        print("\n📚 Revisando arquivos de contexto...")

        arquivos_revisados = {
            "configuracoes": [],
            "contexto": [],
            "templates": [],
            "documentacao": []
        }

        # Arquivos de configuração
        config_files = [
            self.context_dir / ".cursorrules",
            self.context_dir / "PREFERENCIAS_PESSOAIS.md",
            self.context_dir / "CONTEXTO_AMBIENTES_COMPLETO.md",
            self.context_dir / "CONFIGURACOES_GLOBAIS_PENDENTES.md",
            self.context_dir / "CLAUDE_CLOUD_PRO_SETUP.md"
        ]

        for file_path in config_files:
            if file_path.exists():
                arquivos_revisados["configuracoes"].append({
                    "arquivo": str(file_path.name),
                    "caminho": str(file_path),
                    "tamanho": file_path.stat().st_size,
                    "status": "✅"
                })

        # Arquivos de contexto
        context_files = [
            self.claude_knowledge_dir / "00_CONTEXTO_GLOBAL",
            self.claude_knowledge_dir / "01_CONFIGURACOES",
            self.claude_knowledge_dir / "02_PROJETO_BNI",
            self.claude_knowledge_dir / "05_SKILLS",
            self.claude_knowledge_dir / "06_MCP"
        ]

        for dir_path in context_files:
            if dir_path.exists() and dir_path.is_dir():
                md_files = list(dir_path.glob("*.md"))
                for md_file in md_files:
                    arquivos_revisados["contexto"].append({
                        "arquivo": md_file.name,
                        "caminho": str(md_file),
                        "tamanho": md_file.stat().st_size,
                        "categoria": dir_path.name
                    })

        # Templates
        if self.templates_dir.exists():
            template_files = list(self.templates_dir.glob("*.xml")) + list(self.templates_dir.glob("*.md"))
            for template_file in template_files:
                arquivos_revisados["templates"].append({
                    "arquivo": template_file.name,
                    "caminho": str(template_file)
                })

        # Documentação
        doc_files = [
            self.context_dir / "README.md",
            self.context_dir / "INDICE_GERAL.md",
            self.context_dir / "INSTALACAO.md",
            self.context_dir / "GUIA_RAPIDO.md"
        ]

        for doc_file in doc_files:
            if doc_file.exists():
                arquivos_revisados["documentacao"].append({
                    "arquivo": doc_file.name,
                    "caminho": str(doc_file)
                })

        self.results["config_files"] = arquivos_revisados["configuracoes"]
        self.results["context_files"] = arquivos_revisados["contexto"]

        total = (
            len(arquivos_revisados["configuracoes"]) +
            len(arquivos_revisados["contexto"]) +
            len(arquivos_revisados["templates"]) +
            len(arquivos_revisados["documentacao"])
        )

        print(f"   ✅ {len(arquivos_revisados['configuracoes'])} arquivos de configuração")
        print(f"   ✅ {len(arquivos_revisados['contexto'])} arquivos de contexto")
        print(f"   ✅ {len(arquivos_revisados['templates'])} templates")
        print(f"   ✅ {len(arquivos_revisados['documentacao'])} documentos")
        print(f"   📊 Total: {total} arquivos")

        return arquivos_revisados

    def ler_preferencias(self) -> Dict:
        """Lê preferências pessoais"""
        prefs_file = self.context_dir / "PREFERENCIAS_PESSOAIS.md"
        if not prefs_file.exists():
            return {}

        prefs = {}
        with open(prefs_file, 'r', encoding='utf-8') as f:
            content = f.read()

            # Extrair informações básicas
            if "Nome completo" in content:
                nome_match = [line for line in content.split('\n') if 'Nome completo' in line]
                if nome_match:
                    prefs["nome_completo"] = nome_match[0].split(':')[-1].strip()

            if "Como chamar" in content:
                chamar_match = [line for line in content.split('\n') if 'Como chamar' in line]
                if chamar_match:
                    prefs["nome_preferido"] = chamar_match[0].split(':')[-1].strip()

            if "Email" in content:
                email_match = [line for line in content.split('\n') if 'Email' in line and '@' in line]
                if email_match:
                    prefs["email"] = email_match[0].split(':')[-1].strip()

        return prefs

    def ler_cursorrules(self) -> Dict:
        """Lê informações do .cursorrules"""
        cursorrules_file = self.context_dir / ".cursorrules"
        if not cursorrules_file.exists():
            return {}

        info = {}
        with open(cursorrules_file, 'r', encoding='utf-8') as f:
            content = f.read()

            # Extrair informações de ambiente
            if "macOS Silicon" in content:
                info["ambiente_macos"] = True
            if "VPS Ubuntu" in content:
                info["ambiente_vps"] = True
            if "Codespaces" in content:
                info["ambiente_codespace"] = True

            # Extrair vaults 1Password
            if "Vault macOS:" in content:
                import re
                vault_match = re.search(r'Vault macOS:.*?`([a-z0-9]+)`', content)
                if vault_match:
                    info["vault_macos"] = vault_match.group(1)

            if "Vault VPS:" in content:
                import re
                vault_match = re.search(r'Vault VPS:.*?`([a-z0-9]+)`', content)
                if vault_match:
                    info["vault_vps"] = vault_match.group(1)

        return info

    def atualizar_xml_config(self) -> Tuple[bool, str]:
        """Atualiza o XML de configuração com dados revisados"""
        print("\n🔧 Atualizando configuração XML...")

        xml_file = self.templates_dir / "claude-cloud-pro-config.xml"
        if not xml_file.exists():
            print("   ⚠️  Arquivo XML não encontrado")
            return False, "Arquivo não encontrado"

        try:
            # Ler preferências e contexto
            prefs = self.ler_preferencias()
            cursor_info = self.ler_cursorrules()

            # Carregar XML
            tree = ET.parse(xml_file)
            root = tree.getroot()

            # Atualizar metadados
            root.set("dataAtualizacao", datetime.now().strftime("%Y-%m-%d"))

            # Atualizar seção de usuário se necessário
            usuario_elem = root.find(".//Usuario")
            if usuario_elem is not None:
                if prefs.get("nome_completo") and usuario_elem.find("NomeCompleto") is not None:
                    usuario_elem.find("NomeCompleto").text = prefs["nome_completo"]
                if prefs.get("nome_preferido") and usuario_elem.find("NomePreferido") is not None:
                    usuario_elem.find("NomePreferido").text = prefs["nome_preferido"]
                if prefs.get("email") and usuario_elem.find("Email") is not None:
                    usuario_elem.find("Email").text = prefs["email"]

            # Adicionar seção MCP se não existir
            integracoes = root.find(".//Integracoes")
            if integracoes is not None:
                mcp_elem = integracoes.find("MCP")
                if mcp_elem is None:
                    mcp_elem = ET.SubElement(integracoes, "MCP")
                    mcp_elem.text = "Configurado" if self.results["mcp_status"].get("conectado") else "Não configurado"

            # Salvar XML atualizado
            tree.write(xml_file, encoding='utf-8', xml_declaration=True)

            print("   ✅ XML atualizado com sucesso")
            return True, "Atualizado com sucesso"

        except Exception as e:
            print(f"   ❌ Erro ao atualizar XML: {e}")
            return False, str(e)

    def gerar_prompt_claude(self) -> str:
        """Gera prompt completo para Claude Cloud"""
        print("\n📝 Gerando prompt para Claude Cloud...")

        prompt = f"""# Prompt Automatizado para Claude Cloud Pro

## Contexto Completo

Este prompt foi gerado automaticamente em {datetime.now().strftime("%Y-%m-%d %H:%M:%S")} após revisar todos os arquivos de contexto e configuração.

### Status MCP
"""

        if self.results["mcp_status"].get("conectado"):
            prompt += "✅ MCP está conectado e configurado\n"
            for cfg in self.results["mcp_status"].get("configuracoes", []):
                prompt += f"- {cfg['tipo']}: {', '.join(cfg['servidores'])}\n"
        else:
            prompt += "⚠️  MCP não encontrado - configure se necessário\n"

        prompt += f"""
### Arquivos Revisados
- {len(self.results['config_files'])} arquivos de configuração
- {len(self.results['context_files'])} arquivos de contexto
- Templates e documentação atualizados

### Instruções para Upload

1. **Faça upload do arquivo XML completo:**
   `{self.templates_dir}/claude-cloud-pro-config.xml`

2. **Faça upload dos arquivos de contexto na seguinte ordem:**
"""

        # Ordem recomendada de upload
        upload_order = [
            ("00_CONTEXTO_GLOBAL", "Contexto Global Base"),
            ("01_CONFIGURACOES", "Configurações"),
            ("02_PROJETO_BNI", "Projeto BNI"),
            ("05_SKILLS", "Skills"),
            ("06_MCP", "MCP"),
        ]

        for folder, description in upload_order:
            folder_path = self.claude_knowledge_dir / folder
            if folder_path.exists():
                md_files = list(folder_path.glob("*.md"))
                prompt += f"\n   **{description}** ({folder}):\n"
                for md_file in md_files[:5]:  # Limitar a 5 arquivos por seção
                    prompt += f"   - {md_file.name}\n"

        prompt += """
3. **Valide após upload:**
   - Verifique se todos os arquivos foram carregados
   - Teste consultas no Claude Cloud
   - Confirme que o contexto está sendo usado corretamente

### Configurações Importantes

- Idioma: Português Brasileiro (pt-BR)
- Modelo recomendado: Claude Sonnet 4.5
- Preferências de notificações: Ativadas
"""

        self.results["upload_instructions"] = prompt

        return prompt

    def gerar_relatorio(self) -> str:
        """Gera relatório completo em Markdown"""
        relatorio = f"""# Relatório Automatizado - Claude Cloud Pro

**Data:** {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
**Versão:** 1.0.0

## ✅ Status MCP

"""

        mcp_status = self.results["mcp_status"]
        if mcp_status.get("conectado"):
            relatorio += "✅ **MCP está conectado e configurado**\n\n"
            for cfg in mcp_status.get("configuracoes", []):
                relatorio += f"- **{cfg['tipo']}**: {cfg['arquivo']}\n"
                relatorio += f"  - Servidores: {', '.join(cfg['servidores'])}\n"
        else:
            relatorio += "⚠️  **MCP não encontrado**\n\n"

        relatorio += f"""
## 📚 Arquivos Revisados

### Configurações ({len(self.results['config_files'])} arquivos)
"""

        for cfg_file in self.results["config_files"]:
            relatorio += f"- ✅ {cfg_file['arquivo']} ({cfg_file['tamanho']} bytes)\n"

        relatorio += f"""
### Contexto ({len(self.results['context_files'])} arquivos)
"""

        # Agrupar por categoria
        categorias = {}
        for ctx_file in self.results["context_files"]:
            cat = ctx_file.get("categoria", "Outros")
            if cat not in categorias:
                categorias[cat] = []
            categorias[cat].append(ctx_file)

        for categoria, arquivos in categorias.items():
            relatorio += f"\n**{categoria}** ({len(arquivos)} arquivos):\n"
            for arquivo in arquivos[:10]:  # Limitar a 10 por categoria
                relatorio += f"- ✅ {arquivo['arquivo']}\n"

        relatorio += f"""

## 📋 Checklist de Upload

### Ordem Recomendada:

1. ✅ Configuração XML completa
2. ✅ Contexto Global Base
3. ✅ Configurações e Setup
4. ✅ Documentação do Projeto
5. ✅ Skills e Especializações
6. ✅ Referências e APIs

## 🎯 Próximos Passos

1. Revisar o prompt gerado em: `{self.templates_dir}/prompt-claude-cloud.md`
2. Fazer upload dos arquivos no Claude Cloud Pro
3. Validar que todas as configurações foram aplicadas
4. Testar consultas no Claude Cloud

---

**Status:** ✅ Concluído
**Próxima revisão:** Recomendado após mudanças significativas
"""

        return relatorio

    def executar(self) -> bool:
        """Executa o processo completo"""
        print("=" * 60)
        print("🤖 Automação Claude Cloud Pro")
        print("=" * 60)

        # 1. Verificar MCP
        self.verificar_mcp()

        # 2. Revisar contexto
        self.revisar_contexto()

        # 3. Atualizar XML
        sucesso, mensagem = self.atualizar_xml_config()

        # 4. Gerar prompt
        prompt = self.gerar_prompt_claude()

        # 5. Salvar prompt
        prompt_file = self.templates_dir / "prompt-claude-cloud.md"
        with open(prompt_file, 'w', encoding='utf-8') as f:
            f.write(prompt)
        print(f"   ✅ Prompt salvo em: {prompt_file}")

        # 6. Gerar relatório
        relatorio = self.gerar_relatorio()
        relatorio_file = self.context_dir / "RELATORIO_AUTOMATIZADO.md"
        with open(relatorio_file, 'w', encoding='utf-8') as f:
            f.write(relatorio)
        print(f"   ✅ Relatório salvo em: {relatorio_file}")

        print("\n" + "=" * 60)
        print("✅ Processo concluído com sucesso!")
        print("=" * 60)
        print(f"\n📄 Arquivos gerados:")
        print(f"   - Prompt: {prompt_file}")
        print(f"   - Relatório: {relatorio_file}")
        print(f"   - XML atualizado: {self.templates_dir / 'claude-cloud-pro-config.xml'}")

        return True


def main():
    """Função principal"""
    try:
        automacao = ClaudeCloudProAutomation()
        automacao.executar()
        return 0
    except KeyboardInterrupt:
        print("\n\n⚠️  Processo interrompido pelo usuário")
        return 1
    except Exception as e:
        print(f"\n\n❌ Erro: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())

