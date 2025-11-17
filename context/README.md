# 📚 Contexto Global para IAs

Este diretório contém contexto estruturado para todas as IAs instaladas (Cursor, VSCode, Claude, Gemini, ChatGPT).

## 📖 Documentos Disponíveis

### Contexto Global
- **[CONTEXTO_GLOBAL_COMPLETO.md](./global/CONTEXTO_GLOBAL_COMPLETO.md)** - Documento principal com todas as informações

### Contextos Específicos por IA
- **[Cursor](./cursor/CONTEXTO_CURSOR.md)** - Contexto específico para Cursor 2.0
- **[VSCode](./vscode/CONTEXTO_VSCODE.md)** - Contexto específico para VSCode
- **[Claude](./claude/CONTEXTO_CLAUDE.md)** - Contexto específico para Claude
- **[Gemini](./gemini/CONTEXTO_GEMINI.md)** - Contexto específico para Gemini
- **[ChatGPT](./chatgpt/CONTEXTO_CHATGPT.md)** - Contexto específico para ChatGPT

## 🔄 Atualização

Para atualizar o contexto global:

```bash
cd ~/Dotfiles
./scripts/context/update-global-context.sh
```

Este script:
- Coleta informações do sistema
- Atualiza todos os arquivos de contexto
- Sincroniza com editores (Cursor, VSCode)
- Gera relatórios

## 📍 Localização

Todos os arquivos estão em `~/Dotfiles/context/`

## 🎯 Uso

### Cursor
O contexto é automaticamente copiado para:
- `~/Library/Application Support/Cursor/User/context/`

### VSCode
O contexto é automaticamente copiado para:
- `~/Library/Application Support/Code/User/context/`

### Claude/Gemini/ChatGPT
Consulte diretamente os arquivos em `~/Dotfiles/context/`

---

**Última atualização**: 2025-01-17
