# ls-edia-config: O Coracao Versionado do LS-EDIA

[![Repository Link](https://github.com/senal88/ls-edia-config)](https://github.com/senal88/ls-edia-config){target="_blank"}

## 1. Visao Geral do Repositorio

O repositorio `ls-edia-config` e o ponto central para gerenciar a arquitetura LS-EDIA (Luiz Sena's Integrated Development & AI Environment). Ele encapsula o DNA do seu ambiente de desenvolvimento e IA no macOS Tahoe 26.0.1, servindo como fonte unica da verdade para a configuracao base do sistema.

**Proposito**
- Versionamento: manter o historico de todas as mudancas nas configuracoes essenciais.
- Reprodutibilidade: recriar rapidamente o ambiente em qualquer nova maquina ou VM.
- AI-Awareness: oferecer contexto estruturado para agentes de IA interagirem e gerenciarem o ambiente de forma inteligente.
- Modularidade: separar o core de configuracoes de projetos, dados e segredos.

## 2. Componentes Principais

- **Dotfiles (`~/Dotfiles/`)**: configuracoes personalizadas para shell, Git e VS Code, todas versionadas e acessiveis via symlinks.
- **SystemBlueprint (`~/SystemBlueprint/`)**: arquivos constitucionais da arquitetura (architecture.md, gpt-expert-profile.md, classification-guide.yaml).
- **Tools & Scripts (`~/Tools/scripts/`)**: scripts de manutencao e validacao, como `validacao_final.sh`, que automatizam auditorias recorrentes.

## 3. Uso e Configuracao

### 3.1 Passo a Passo Inicial
1. Clonar o repositorio em `~/Dotfiles/`:
	 ```bash
	 cd ~
	 git clone https://github.com/senal88/ls-edia-config Dotfiles
	 ```
2. Criar links simbolicos a partir da HOME:
	 ```bash
	 cd ~
	 rm -f ~/.zshrc ~/.gitconfig
	 rm -rf ~/.vscode
	 ln -s ~/Dotfiles/.zshrc ~/.zshrc
	 ln -s ~/Dotfiles/.gitconfig ~/.gitconfig
	 ln -s ~/Dotfiles/vscode ~/.vscode
	 ```
3. Recarregar o shell:
	 ```bash
	 source ~/.zshrc
	 ```

### 3.2 Comandos Frequentes
- Executar validacao:
	```bash
	~/Tools/scripts/validacao_final.sh
	```
- Auditar configuracoes do Git global:
	```bash
	git config --global --list
	```
- Abrir o VS Code com o ambiente pronto:
	```bash
	code .
	```

### 3.3 Papel do SystemBlueprint
- Guia novas maquinas durante a clonagem inicial.
- Fornece contexto para agentes como ArchitectGPT classificarem arquivos e entenderem fluxos operacionais.
- Documenta filosofia de trabalho, regras de interacao e perfis de agentes.

## 4. Ferramentas e Integracoes

### 4.1 Homebrew e Mise
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
```
Defina versoes preferidas em `~/.config/mise/config.toml` e execute `mise install`.

### 4.2 Tokens e Segredos
- Guarde chaves em `~/Secrets/api_keys/.env/` (por exemplo `openai.env`, `huggingface.env`).
- Carregue apenas quando necessario via scripts dedicados ou `source` manual.

### 4.3 LLMs e Ferramentas Avancadas
- OpenAI GPT-5 Codex e Gemini 2.5 Pro exigem chaves em arquivos `.env` dedicados.
- Cursor IDE permanece suspenso ate a correção dos bugs no macOS Tahoe 26.0.1.

## 5. Templates Reutilizaveis

- **project_blueprint.md**: norteia novos projetos em `~/Workspaces/`.
- **AGENT.md**: descreve agentes em `~/Agents/`.
- Copie os templates de `~/Workspaces/Templates/` e adapte campos como visao geral e variaveis de configuracao.

## 6. Manutencao Continua

- Consolidar alterações apos ajustes em dotfiles.
- Rodar `git diff --cached` antes de cada commit.
- Sincronizar novos dispositivos clonando este repositorio e executando a validacao final.
- Atualizar `SystemBlueprint/` sempre que houver mudanca na estrategia, ferramentas ou fluxos IA.

## 7. Guardrails e Operacoes Permitidas

- Backups incrementais em `~/Backups/dotfiles`.
- Nunca versionar credenciais; todo segredo pertence a `~/Secrets/`.
- Respeitar `.gitignore` e executar `~/Tools/scripts/validacao_final.sh` regularmente.
- Humanos podem editar dotfiles, SystemBlueprint e templates.
- GPT Experts so atuam com confirmacao explicita e dentro das regras de `classification-guide.yaml`.

---

Este README consolida a documentacao operacional do LS-EDIA. Mantenha-o alinhado ao estado do ambiente e utilize-o como ponto de partida sempre que expandir sua infraestrutura pessoal ou treinar novos agentes.
