# 🚀 Plano de Avanço - Organização e Otimização

> Plano estratégico para otimizar IDEs, .lm-studio e área de projetos

## 📊 **Análise Atual**

### ✅ **Pontos Fortes Identificados:**
- **IDEs**: Cursor e VSCode instalados e funcionais
- **.lm-studio**: Configurado com modelos e conversas
- **Dotfiles**: Estrutura organizada e versionada
- **Projetos**: 52 projetos identificados com potencial

### ⚠️ **Problemas Identificados:**
- **IDEs**: Configurações básicas, sem otimizações avançadas
- **.lm-studio**: Não 100% revisado para produção
- **Projetos**: Muitos sem deploy, alguns obsoletos
- **Organização**: Estrutura dispersa, sem padrão claro

## 🎯 **Plano de Ação - 3 Fases**

### **FASE 1: Otimização de IDEs (Semana 1-2)**

#### **1.1 Configuração Avançada do Cursor**
```bash
# Criar configurações otimizadas
mkdir -p /Users/luiz.sena88/.cursor/settings
cat > /Users/luiz.sena88/.cursor/settings.json << 'EOF'
{
  "editor.fontSize": 14,
  "editor.fontFamily": "JetBrains Mono, Fira Code, monospace",
  "editor.fontLigatures": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": true,
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "workbench.colorTheme": "Dark+ (default dark)",
  "workbench.iconTheme": "material-icon-theme",
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "terminal.integrated.fontSize": 13,
  "python.defaultInterpreterPath": "/usr/bin/python3",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
  "typescript.preferences.importModuleSpecifier": "relative",
  "javascript.preferences.importModuleSpecifier": "relative"
}
EOF
```

#### **1.2 Extensões Essenciais**
```bash
# Extensões para Cursor
cursor --install-extension ms-python.python
cursor --install-extension ms-python.black-formatter
cursor --install-extension ms-python.pylint
cursor --install-extension ms-vscode.vscode-typescript-next
cursor --install-extension bradlc.vscode-tailwindcss
cursor --install-extension esbenp.prettier-vscode
cursor --install-extension ms-vscode.vscode-json
cursor --install-extension redhat.vscode-yaml
cursor --install-extension ms-vscode.vscode-docker
cursor --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
```

#### **1.3 Configuração do VSCode**
```bash
# Configurações otimizadas para VSCode
cat > /Users/luiz.sena88/.vscode/settings.json << 'EOF'
{
  "editor.fontSize": 14,
  "editor.fontFamily": "JetBrains Mono, Fira Code, monospace",
  "editor.fontLigatures": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": true,
  "editor.bracketPairColorization.enabled": true,
  "workbench.colorTheme": "Dark+ (default dark)",
  "workbench.iconTheme": "material-icon-theme",
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "terminal.integrated.fontSize": 13,
  "python.defaultInterpreterPath": "/usr/bin/python3",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
  "typescript.preferences.importModuleSpecifier": "relative",
  "javascript.preferences.importModuleSpecifier": "relative",
  "chatgpt.openOnStartup": true
}
EOF
```

### **FASE 2: Revisão Completa do .lm-studio (Semana 2-3)**

#### **2.1 Auditoria do .lm-studio**
```bash
# Script de auditoria
cat > /Users/luiz.sena88/Dotfiles/scripts/audit-lmstudio.sh << 'EOF'
#!/bin/bash
echo "🔍 AUDITORIA DO .lm-studio"
echo "=========================="

echo "📁 Estrutura de diretórios:"
ls -la /Users/luiz.sena88/.lmstudio/

echo "🤖 Modelos instalados:"
ls -la /Users/luiz.sena88/.lmstudio/models/

echo "💬 Conversas:"
ls -la /Users/luiz.sena88/.lmstudio/conversations/

echo "⚙️ Configurações:"
cat /Users/luiz.sena88/.lmstudio/mcp.json 2>/dev/null || echo "Arquivo não encontrado"

echo "📊 Tamanho total:"
du -sh /Users/luiz.sena88/.lmstudio/
EOF

chmod +x /Users/luiz.sena88/Dotfiles/scripts/audit-lmstudio.sh
```

#### **2.2 Otimização do .lm-studio**
```bash
# Configurações otimizadas
cat > /Users/luiz.sena88/.lmstudio/config.json << 'EOF'
{
  "server": {
    "host": "localhost",
    "port": 1234,
    "cors": true
  },
  "models": {
    "default": "llama-3.1-8b-instruct",
    "fallback": "llama-3.1-70b-instruct"
  },
  "performance": {
    "max_tokens": 4096,
    "temperature": 0.7,
    "top_p": 0.9,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0
  },
  "ui": {
    "theme": "dark",
    "font_size": 14,
    "auto_save": true
  }
}
EOF
```

#### **2.3 Limpeza e Organização**
```bash
# Script de limpeza
cat > /Users/luiz.sena88/Dotfiles/scripts/cleanup-lmstudio.sh << 'EOF'
#!/bin/bash
echo "🧹 LIMPEZA DO .lm-studio"
echo "======================="

# Limpar logs antigos
find /Users/luiz.sena88/.lmstudio/server-logs/ -name "*.log" -mtime +30 -delete

# Organizar conversas
mkdir -p /Users/luiz.sena88/.lmstudio/conversations/archived
find /Users/luiz.sena88/.lmstudio/conversations/ -name "*.json" -mtime +90 -exec mv {} /Users/luiz.sena88/.lmstudio/conversations/archived/ \;

# Limpar cache
rm -rf /Users/luiz.sena88/.lmstudio/.internal/cache/*

echo "✅ Limpeza concluída"
EOF

chmod +x /Users/luiz.sena88/Dotfiles/scripts/cleanup-lmstudio.sh
```

### **FASE 3: Organização da Área de Projetos (Semana 3-4)**

#### **3.1 Análise de Projetos**
```bash
# Script de análise de projetos
cat > /Users/luiz.sena88/Dotfiles/scripts/analyze-projects.sh << 'EOF'
#!/bin/bash
echo "📊 ANÁLISE DE PROJETOS"
echo "======================"

PROJECTS_DIR="/Users/luiz.sena88/Projetos"
REPORT_FILE="/Users/luiz.sena88/Dotfiles/notebooklm_accounting/analysis/projects-analysis.json"

mkdir -p /Users/luiz.sena88/Dotfiles/notebooklm_accounting/analysis

cat > "$REPORT_FILE" << 'JSON'
{
  "analysis_date": "$(date -Iseconds)",
  "total_projects": 0,
  "projects": {
    "active": [],
    "inactive": [],
    "obsolete": [],
    "deployed": [],
    "undeployed": []
  },
  "technologies": {},
  "recommendations": []
}
JSON

# Analisar cada projeto
for project in "$PROJECTS_DIR"/*; do
  if [ -d "$project" ]; then
    project_name=$(basename "$project")
    echo "Analisando: $project_name"
    
    # Verificar se tem package.json, requirements.txt, etc.
    if [ -f "$project/package.json" ]; then
      echo "  📦 Node.js project"
    fi
    
    if [ -f "$project/requirements.txt" ]; then
      echo "  🐍 Python project"
    fi
    
    if [ -f "$project/Dockerfile" ]; then
      echo "  🐳 Docker project"
    fi
    
    # Verificar última modificação
    last_modified=$(stat -f "%Sm" -t "%Y-%m-%d" "$project")
    echo "  📅 Última modificação: $last_modified"
  fi
done
EOF

chmod +x /Users/luiz.sena88/Dotfiles/scripts/analyze-projects.sh
```

#### **3.2 Estrutura de Organização**
```bash
# Criar estrutura organizada
mkdir -p /Users/luiz.sena88/Projetos/{active,archived,experimental,production}

# Mover projetos ativos
mv /Users/luiz.sena88/Projetos/agent_expert /Users/luiz.sena88/Projetos/active/
mv /Users/luiz.sena88/Projetos/agentkit /Users/luiz.sena88/Projetos/active/
mv /Users/luiz.sena88/Projetos/ai-ecosystem /Users/luiz.sena88/Projetos/active/

# Mover projetos experimentais
mv /Users/luiz.sena88/Projetos/app-tributario-3 /Users/luiz.sena88/Projetos/experimental/

# Mover projetos obsoletos
mv /Users/luiz.sena88/Projetos/compilador /Users/luiz.sena88/Projetos/archived/
```

#### **3.3 Scripts de Deploy**
```bash
# Criar scripts de deploy
cat > /Users/luiz.sena88/Dotfiles/scripts/deploy-project.sh << 'EOF'
#!/bin/bash
PROJECT_PATH="$1"
PROJECT_NAME=$(basename "$PROJECT_PATH")

echo "🚀 DEPLOY DO PROJETO: $PROJECT_NAME"
echo "=================================="

# Verificar tipo de projeto
if [ -f "$PROJECT_PATH/package.json" ]; then
  echo "📦 Projeto Node.js detectado"
  cd "$PROJECT_PATH"
  npm install
  npm run build
  echo "✅ Build concluído"
fi

if [ -f "$PROJECT_PATH/requirements.txt" ]; then
  echo "🐍 Projeto Python detectado"
  cd "$PROJECT_PATH"
  pip install -r requirements.txt
  echo "✅ Dependências instaladas"
fi

if [ -f "$PROJECT_PATH/Dockerfile" ]; then
  echo "🐳 Projeto Docker detectado"
  cd "$PROJECT_PATH"
  docker build -t "$PROJECT_NAME" .
  echo "✅ Imagem Docker criada"
fi

echo "🎉 Deploy concluído para: $PROJECT_NAME"
EOF

chmod +x /Users/luiz.sena88/Dotfiles/scripts/deploy-project.sh
```

## 📋 **Cronograma de Execução**

### **Semana 1: IDEs**
- [ ] Configurar Cursor com extensões essenciais
- [ ] Otimizar VSCode
- [ ] Testar configurações
- [ ] Documentar configurações

### **Semana 2: .lm-studio**
- [ ] Auditoria completa
- [ ] Otimização de configurações
- [ ] Limpeza de dados antigos
- [ ] Teste de performance

### **Semana 3: Projetos**
- [ ] Análise de todos os projetos
- [ ] Classificação por status
- [ ] Organização em categorias
- [ ] Criação de scripts de deploy

### **Semana 4: Consolidação**
- [ ] Testes finais
- [ ] Documentação completa
- [ ] Backup das configurações
- [ ] Relatório final

## 🎯 **Métricas de Sucesso**

### **IDEs:**
- ✅ Tempo de inicialização < 3s
- ✅ Extensões essenciais funcionando
- ✅ Configurações sincronizadas
- ✅ Performance otimizada

### **.lm-studio:**
- ✅ 100% revisado e otimizado
- ✅ Modelos organizados
- ✅ Conversas arquivadas
- ✅ Performance melhorada

### **Projetos:**
- ✅ 80% dos projetos organizados
- ✅ 60% com deploy automatizado
- ✅ 90% dos obsoletos arquivados
- ✅ Estrutura clara e navegável

## 🚀 **Próximos Passos**

1. **Executar Fase 1** (IDEs)
2. **Executar Fase 2** (.lm-studio)
3. **Executar Fase 3** (Projetos)
4. **Monitorar resultados**
5. **Ajustar conforme necessário**

---

**Última atualização**: $(date)
**Versão**: 1.0.0
**Status**: ✅ Plano Criado
