# 📋 Cursor Rules - Execução Automática Parametrizada

**Versão**: 2.0.0
**Data**: 2025-11-17

---

## 🎯 Objetivo

O `.cursorrules` foi parametrizado para garantir que **planejamentos aprovados sejam executados automaticamente** seguindo uma sequência lógica completa de 14 fases, até chegar à parte manual.

---

## 📋 Sequência Lógica de Execução

### FASE 1: Atualização de Contexto e Sistema
- Contexto global (Cursor, VSCode, Claude, Gemini, ChatGPT)
- Sistema e projetos

### FASE 2: Cofres e Credenciais (1Password)
- Validação de vaults
- Validação de credenciais e API Keys
- Remoção de chaves expiradas

### FASE 3: Terminais e Sistemas
- macOS (Zsh)
- Ubuntu VPS (Bash)

### FASE 4: IDEs (Cursor e VSCode)
- Configurações e extensões

### FASE 5: Contexto Global VPS/macOS
- Informações do VPS
- Informações do macOS

### FASE 6: Automação 1Password e GitHub
- Scripts de automação
- Integração GitHub

### FASE 7: Codespaces e DevContainers
- Templates e configurações

### FASE 8: MCP Servers
- Validação e teste

### FASE 9: APIs e Chaves Validadas
- Gemini, Claude, Cursor, ChatGPT Plus
- Hostinger, GitHub, HuggingFace
- Validação sem necessidade de expiração

### FASE 10: Protocolos Validados
- SSH, HTTPS/HTTP, Git
- REST APIs

### FASE 11: Navegadores e HTTP/HTTPS
- Validação de certificados SSL
- Teste de endpoints

### FASE 12: Melhores Práticas do Framework
- Nomenclaturas padronizadas
- Estrutura de diretórios
- Versionamento
- Segurança

### FASE 13: Documentos Obsoletos Arquivados
- Identificação
- Arquivamento

### FASE 14: Acompanhamento Claro de Etapas
- Logging
- Documentação de progresso
- Status updates

---

## 🚨 Regras de Execução

1. **Execução Automática**: Não perguntar sobre cada etapa
2. **Validação Obrigatória**: Validar pré-requisitos antes de executar
3. **Tratamento de Erros**: Continuar quando possível, documentar erros
4. **Parte Manual**: Parar com instruções claras

---

## ✅ Checklist de Execução

Cada planejamento aprovado deve seguir o checklist completo das 14 fases antes de chegar à parte manual.

---

**Última atualização**: 2025-11-17
