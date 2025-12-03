# Setup Completo: Segundo Cérebro IA

**Versão:** 1.0.0
**Data:** 2025-12-02

---

## 🎯 Objetivo

Configurar um sistema completo de gestão de conhecimento integrando:

- **Claude Desktop** com MCP servers
- **Obsidian** como vault de segundo cérebro
- **n8n** para automação de transcrições
- **Mind Maps NextGen** para visualização

---

## 📋 Pré-requisitos

### Software Necessário

```bash
# Homebrew (macOS package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ferramentas CLI
brew install node bun jq
brew install --cask 1password-cli

# Aplicações
brew install --cask obsidian
brew install --cask claude
```

### Contas e APIs

- ✅ **1Password** - Gerenciamento de credenciais
- ✅ **OpenAI API** - Para transcrição Whisper e GPT-4
- ✅ **Cloudinary** - Para transcode de áudio (opcional)
- ✅ **Google Drive API** - Para trigger de uploads (opcional)
- ✅ **Claude Desktop** - Interface principal

---

## 🚀 Instalação

### Passo 1: Executar Script de Setup

```bash
cd ~/Dotfiles/system_prompts/segundo-cerebro-ia
chmod +x scripts/setup-segundo-cerebro.sh
bash scripts/setup-segundo-cerebro.sh
```

O script irá:

1. ✅ Verificar pré-requisitos
2. ✅ Criar estrutura de diretórios
3. ✅ Instalar MCP servers (Obsidian + YouTube)
4. ✅ Configurar credenciais no 1Password
5. ✅ Criar config do Claude Desktop
6. ✅ Gerar scripts auxiliares
7. ✅ Criar templates Obsidian
8. ✅ Copiar workflows n8n

### Passo 2: Sincronizar Claude Desktop

```bash
bash scripts/sync-claude-obsidian.sh
```

Isso copia a configuração MCP para:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**⚠️ Importante:** Reinicie o Claude Desktop após sincronizar.

### Passo 3: Configurar Obsidian

1. Abrir Obsidian:

   ```bash
   open -a Obsidian obsidian-vault/
   ```

2. Quando Obsidian perguntar "Confiar neste vault?", clique em **Confiar**

3. Instalar plugins Community:
   - Settings → Community Plugins → Turn on community plugins
   - Browse → Pesquisar **"Mind Maps NextGen"**
   - Install → Enable

4. (Opcional) Instalar plugins adicionais:
   - **Dataview** - Para queries em notas
   - **Templater** - Para templates avançados
   - **Excalidraw** - Para desenhos

### Passo 4: Configurar n8n

1. Acessar n8n: <https://n8n.senamfo.com>

2. Importar workflows:
   - Workflows → Import from File
   - Selecionar: `n8n-workflows/transcricao-audio.json`
   - Selecionar: `n8n-workflows/youtube-to-obsidian.json`

3. Configurar credenciais:
   - OpenAI API (para Whisper e GPT-4)
   - Cloudinary (se usar transcrição de áudio)
   - Google Drive (se usar trigger de upload)
   - Obsidian API (chave gerada no setup)

---

## 🔐 Configuração de Credenciais

### Estrutura no 1Password

```
Vault: Development
│
├── Obsidian MCP API Key
│   ├── credential: [chave gerada automaticamente]
│   └── tags: [obsidian, mcp, segundo-cerebro]
│
├── Cloudinary API Credentials
│   ├── cloud_name: [seu cloud name]
│   ├── api_key: [sua API key]
│   ├── api_secret: [seu secret]
│   └── tags: [cloudinary, n8n]
│
└── OpenAI API Key
    ├── credential: sk-proj-xxx
    └── tags: [openai, whisper, gpt4]
```

### Carregar Credenciais

```bash
# Carregar no shell atual
source scripts/load-obsidian-keys.sh

# Verificar se carregou
echo $OBSIDIAN_API_KEY
echo $OPENAI_API_KEY
```

---

## 🧪 Testar Instalação

### Teste 1: Claude MCP → Obsidian

Abra **Claude Desktop** e execute:

```
Crie um arquivo de teste no Obsidian vault em mapas-mentais/teste.md
com o seguinte conteúdo:

# [[Teste de Integração]]
- [[Claude Desktop]]
- [[MCP Server]]
- [[Obsidian]]

Depois abra o arquivo no Obsidian.
```

**Resultado esperado:** Arquivo criado e aberto automaticamente no Obsidian.

### Teste 2: YouTube → Mapa Mental

Via **curl** ou **Postman**:

```bash
curl -X POST https://n8n.senamfo.com/webhook/youtube-to-mindmap \
  -H "Content-Type: application/json" \
  -d '{
    "youtube_url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "output_path": "mapas-mentais/teste-youtube.md"
  }'
```

**Resultado esperado:**

1. Transcrição extraída do YouTube
2. GPT-4 cria mapa mental
3. Arquivo salvo em Obsidian
4. Obsidian abre arquivo
5. Mind Map NextGen visualiza mapa

### Teste 3: Transcrição de Áudio

1. Fazer upload de arquivo `.m4a` ou `.mp3` para pasta monitorada no Google Drive
2. n8n detecta automaticamente
3. Cloudinary faz transcode (se necessário)
4. OpenAI Whisper transcreve
5. Texto salvo em Google Docs
6. (Manual) Copiar para Claude e gerar mapa mental

---

## 📖 Uso Diário

### Workflow 1: Mapear Artigo/Post

```
Claude> Leia o artigo em [URL]
Claude> Extraia os conceitos principais
Claude> Crie um mapa mental marcando 30%+ das palavras com [[brackets]]
Claude> Salve em obsidian-vault/mapas-mentais/artigo-YYYY-MM-DD.md
Claude> Abra no Obsidian e visualize com Mind Maps NextGen
```

### Workflow 2: Transcrever e Mapear Podcast

```bash
# 1. Upload do arquivo para Google Drive (pasta monitorada)
# 2. Aguardar n8n processar (5-10min para 1h de áudio)
# 3. Abrir transcrição gerada no Google Drive
# 4. Copiar texto e enviar para Claude:

Claude> Transcrição:
[colar texto]

Crie um mapa mental sobre os temas principais deste podcast.
Marque TODOS os conceitos técnicos com [[brackets]].
Salve em mapas-mentais/podcast-YYYY-MM-DD.md
```

### Workflow 3: Notas Atômicas de Conceitos

```
Claude> A partir do mapa mental em mapas-mentais/podcast-2025-12-02.md
Claude> Identifique todos os conceitos marcados [[assim]]
Claude> Crie uma nota atômica separada para cada conceito em conceitos/
Claude> Use o template nota-atomica.md
Claude> Adicione links bidirecionais entre conceitos relacionados
```

### Workflow 4: Conectar Conhecimento

```
Claude> Analise meu vault Obsidian
Claude> Identifique conceitos que aparecem em múltiplos mapas mentais
Claude> Crie uma nota de índice em conceitos/_indice.md
Claude> Liste todos os conceitos com links para onde aparecem
Claude> Visualize no Graph View do Obsidian
```

---

## 🎨 Personalizações

### Configurar Aparência Obsidian

```bash
# Instalar tema (exemplo: Minimal)
Settings → Appearance → Themes → Browse → "Minimal"

# Ajustar tamanho de fonte
Settings → Appearance → Font size: 16

# Habilitar line numbers
Settings → Editor → Show line numbers: ON
```

### Customizar Prompt de Mapas Mentais

Editar:

```
global/docs/obsidian-mcp/Prompt Projeto Claude.md
```

Adicionar seções personalizadas, ajustar percentual de marcação, etc.

### Adicionar Tags Personalizadas

Editar templates em:

```
templates/mapa-mental.md
templates/nota-atomica.md
```

Adicionar suas próprias tags:

```markdown
**Tags:** #mapa-mental #segundo-cerebro #sua-tag-aqui
```

---

## 🔄 Backup e Sincronização

### Backup Manual

```bash
# Criar backup completo
bash scripts/backup-vault.sh

# Backups salvos em:
# backups/YYYYMMDD_HHMMSS/obsidian-vault.tar.gz
```

### Backup Automático (cron)

```bash
# Adicionar ao crontab
crontab -e

# Adicionar linha (backup diário às 3h da manhã):
0 3 * * * /Users/luiz.sena88/Dotfiles/system_prompts/segundo-cerebro-ia/scripts/backup-vault.sh
```

### Sincronização via Git (opcional)

```bash
cd obsidian-vault
git init
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:seu-usuario/segundo-cerebro.git
git push -u origin main

# Sincronizar mudanças
git pull
git add .
git commit -m "Update notes"
git push
```

---

## 🆘 Troubleshooting

### Problema: Claude não encontra MCP servers

**Sintoma:** Claude Desktop não mostra opções de Obsidian/YouTube

**Solução:**

```bash
# 1. Verificar config
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json

# 2. Re-sincronizar
bash scripts/sync-claude-obsidian.sh

# 3. Reiniciar Claude Desktop
killall Claude && open -a Claude

# 4. Verificar logs
tail -f ~/Library/Logs/Claude/mcp-*.log
```

### Problema: Obsidian não abre arquivos via MCP

**Sintoma:** Claude cria arquivo mas não abre

**Solução:**

```bash
# 1. Verificar API key
source scripts/load-obsidian-keys.sh
echo $OBSIDIAN_API_KEY

# 2. Verificar permissões vault
ls -la obsidian-vault/

# 3. Recriar API key
op item delete "Obsidian MCP API Key" --vault Development
bash scripts/setup-segundo-cerebro.sh  # Regenera key
```

### Problema: n8n não transcreve áudio

**Sintoma:** Workflow executa mas não retorna transcrição

**Solução:**

```bash
# 1. Verificar OpenAI API key no n8n
# 2. Testar Whisper diretamente:

curl https://api.openai.com/v1/audio/transcriptions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -F model="whisper-1" \
  -F file="@teste.m4a"

# 3. Verificar formato de áudio suportado
# Whisper aceita: mp3, mp4, mpeg, mpga, m4a, wav, webm
```

### Problema: Mind Maps não aparecem

**Sintoma:** Arquivo criado mas sem visualização de mapa

**Solução:**

1. Verificar plugin **Mind Maps NextGen** está instalado e habilitado
2. Verificar formato do arquivo:
   - Deve usar `#` para títulos
   - Deve usar `-` para listas
   - Deve ter hierarquia clara
3. Testar manualmente: `Ctrl+P` → "Mind Maps NextGen: Visualize"

---

## 📚 Recursos Adicionais

### Documentação

- [README.md](README.md) - Visão geral do projeto
- [Prompt Projeto Claude.md](global/docs/obsidian-mcp/Prompt Projeto Claude.md) - Prompt de mapas mentais
- [N8N workflow](n8n-workflows/) - Workflows de automação

### Comunidades

- [Obsidian Forum](https://forum.obsidian.md/)
- [r/ObsidianMD](https://reddit.com/r/ObsidianMD)
- [n8n Community](https://community.n8n.io/)
- [Claude Discord](https://discord.gg/claude)

### Cursos e Tutoriais

- [Building a Second Brain (Tiago Forte)](https://www.buildingasecondbrain.com/)
- [Linking Your Thinking (Nick Milo)](https://www.linkingyourthinking.com/)
- [Zettelkasten Method](https://zettelkasten.de/introduction/)

---

## ✅ Checklist de Implementação

```
Instalação:
☐ Homebrew instalado
☐ Node.js, Bun, jq instalados
☐ 1Password CLI configurado
☐ Claude Desktop instalado
☐ Obsidian instalado

Setup:
☐ Script setup-segundo-cerebro.sh executado
☐ Estrutura de diretórios criada
☐ MCP servers instalados (Obsidian + YouTube)
☐ Credenciais configuradas no 1Password
☐ Claude Desktop config sincronizado
☐ Obsidian vault aberto e "trust" concedido
☐ Plugin Mind Maps NextGen instalado

Testes:
☐ Claude cria arquivo no Obsidian
☐ Obsidian abre arquivo via MCP
☐ Mind Map visualizado
☐ n8n workflow importado
☐ Transcrição de áudio testada

Produção:
☐ Primeiro mapa mental criado
☐ Grafo de conhecimento iniciado (5+ notas)
☐ Backup automático configurado
☐ Workflow de uso diário estabelecido
```

---

**Versão:** 1.0.0
**Última Atualização:** 2025-12-02
**Autor:** Luiz Sena
