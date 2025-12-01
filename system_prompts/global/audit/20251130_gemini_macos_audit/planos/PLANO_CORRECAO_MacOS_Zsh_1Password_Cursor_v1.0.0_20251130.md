# Plano de Correção Automática – macOS + Zsh + 1Password

- RUN_ID: 20251130_gemini_macos_audit
- Gerado em: 2025-11-30 22:31:47
- Base de evidências: /Users/luiz.sena88/Dotfiles/system_prompts/global/audit/20251130_gemini_macos_audit

## 1. Homebrew
- [x] Homebrew instalado.

## 2. Zsh e ~/.zshrc
- [x] ~./zshrc existe. Revisar e modularizar via dotfiles.
- [ ] Validar ordem de carregamento de PATH, plugins e integrações (fzf, zoxide, etc.).

## 3. Linguagens (Node, Python, Go, Rust)
- [x] node: presente.
- [x] python3: presente.
- [ ] Instalar go via gerenciador adequado (brew, asdf, etc.).
- [ ] Instalar rustc via gerenciador adequado (brew, asdf, etc.).

## 4. Git
- [x] git instalado.
- [ ] Verificar se user.name e user.email globais estão corretos (senal88 / email GitHub).

## 5. 1Password CLI e SSH
- [x] op instalado.
- [ ] Validar sessão ativa (op whoami) e integração com 1Password SSH agent.
- [ ] Garantir que IdentityAgent no ~/.ssh/config aponte para o socket 1Password.

## 6. Dependências CLI (bat, eza, fzf, zoxide, gh, lazygit, mas)
- [ ] Instalar bat via Homebrew.
- [ ] Instalar eza via Homebrew.
- [x] fzf: instalado.
- [ ] Instalar zoxide via Homebrew.
- [x] gh: instalado.
- [ ] Instalar lazygit via Homebrew.
- [x] mas: instalado.

## 7. Nerd Fonts
- [ ] Instalar pelo menos uma Nerd Font (JetBrainsMono Nerd, FiraCode Nerd, etc.)

## 8. Ação para Cursor 2.1
- [ ] Ler  e este plano de correção.
- [ ] Gerar script(s) de correção automatizada alinhados a este plano (ex.: fix_zsh_env.sh, fix_deps.sh).
