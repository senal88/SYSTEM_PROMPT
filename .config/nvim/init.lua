-- Neovim configuration
-- Gerado automaticamente - 2025-10-28

-- Configurações básicas
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Opções globais
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undo")
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.wildignore = {
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/*",
  "*/node_modules/*", "*/dist/*", "*/target/*"
}

-- Mapeamentos básicos
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>e", ":e<CR>", { desc = "Edit file" })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>n", ":enew<CR>", { desc = "New file" })
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>s", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>c", ":close<CR>", { desc = "Close window" })
vim.keymap.set("n", "<leader>o", ":only<CR>", { desc = "Only window" })

-- Navegação entre buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>ba", ":buffer #<CR>", { desc = "Alternate buffer" })

-- Navegação entre tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Only tab" })
vim.keymap.set("n", "<leader>tl", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous tab" })

-- Navegação de linha
vim.keymap.set("n", "j", "gj", { desc = "Move down (visual)" })
vim.keymap.set("n", "k", "gk", { desc = "Move up (visual)" })
vim.keymap.set("n", "0", "^", { desc = "First non-blank character" })
vim.keymap.set("n", "^", "0", { desc = "First character" })
vim.keymap.set("n", "$", "g_", { desc = "Last non-blank character" })
vim.keymap.set("n", "g_", "$", { desc = "Last character" })

-- Seleção visual
vim.keymap.set("v", "j", "gj", { desc = "Move down (visual)" })
vim.keymap.set("v", "k", "gk", { desc = "Move up (visual)" })
vim.keymap.set("v", "0", "^", { desc = "First non-blank character" })
vim.keymap.set("v", "^", "0", { desc = "First character" })
vim.keymap.set("v", "$", "g_", { desc = "Last non-blank character" })
vim.keymap.set("v", "g_", "$", { desc = "Last character" })

-- Indentação visual
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Busca e substituição
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })
vim.keymap.set("v", "<leader>r", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace selected text" })

-- Comandos úteis
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>", { desc = "Change to file directory" })
vim.keymap.set("n", "<leader>cf", ":let @+ = expand('%:p')<CR>", { desc = "Copy file path" })
vim.keymap.set("n", "<leader>cn", ":let @+ = expand('%:t')<CR>", { desc = "Copy file name" })
vim.keymap.set("n", "<leader>cl", ":let @+ = expand('%:t:r')<CR>", { desc = "Copy file name without extension" })

-- Comandos de desenvolvimento
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })
vim.keymap.set("n", "<leader>fg", ":grep ", { desc = "Grep" })
vim.keymap.set("n", "<leader>fr", ":grep <C-r><C-w>", { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fb", ":buffers<CR>", { desc = "List buffers" })
vim.keymap.set("n", "<leader>fm", ":marks<CR>", { desc = "List marks" })
vim.keymap.set("n", "<leader>fj", ":jumps<CR>", { desc = "List jumps" })
vim.keymap.set("n", "<leader>fc", ":changes<CR>", { desc = "List changes" })

-- Comandos de auditoria
vim.keymap.set("n", "<leader>aa", ":!cd /Users/luiz.sena88/auditoria && bash scripts/executar_auditoria_completa.sh<CR>", { desc = "Run full audit" })
vim.keymap.set("n", "<leader>ap", ":!cd /Users/luiz.sena88/auditoria && bash scripts/validar_estrutura_projetos.sh<CR>", { desc = "Validate projects" })
vim.keymap.set("n", "<leader>ah", ":!cd /Users/luiz.sena88/auditoria && bash scripts/validar_pastas_home.sh<CR>", { desc = "Validate home" })

-- Comandos de projeto
vim.keymap.set("n", "<leader>pp", ":!cd /Users/luiz.sena88/Projetos<CR>", { desc = "Go to projects" })
vim.keymap.set("n", "<leader>pi", ":!cd /Users/luiz.sena88/infra<CR>", { desc = "Go to infra" })
vim.keymap.set("n", "<leader>pd", ":!cd /Users/luiz.sena88/Dotfiles<CR>", { desc = "Go to dotfiles" })

-- Comandos de Git
vim.keymap.set("n", "<leader>gs", ":!git status<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>ga", ":!git add .<CR>", { desc = "Git add all" })
vim.keymap.set("n", "<leader>gc", ":!git commit -m ", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", ":!git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gl", ":!git log --oneline<CR>", { desc = "Git log" })
vim.keymap.set("n", "<leader>gd", ":!git diff<CR>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gb", ":!git branch<CR>", { desc = "Git branch" })
vim.keymap.set("n", "<leader>gco", ":!git checkout ", { desc = "Git checkout" })

-- Comandos de Docker
vim.keymap.set("n", "<leader>db", ":!docker build -t ", { desc = "Docker build" })
vim.keymap.set("n", "<leader>dr", ":!docker run -p ", { desc = "Docker run" })
vim.keymap.set("n", "<leader>ds", ":!docker stop ", { desc = "Docker stop" })
vim.keymap.set("n", "<leader>dps", ":!docker ps<CR>", { desc = "Docker ps" })
vim.keymap.set("n", "<leader>di", ":!docker images<CR>", { desc = "Docker images" })

-- Comandos de Node.js
vim.keymap.set("n", "<leader>ni", ":!npm install<CR>", { desc = "NPM install" })
vim.keymap.set("n", "<leader>ns", ":!npm start<CR>", { desc = "NPM start" })
vim.keymap.set("n", "<leader>nt", ":!npm test<CR>", { desc = "NPM test" })
vim.keymap.set("n", "<leader>nb", ":!npm run build<CR>", { desc = "NPM build" })
vim.keymap.set("n", "<leader>nd", ":!npm run dev<CR>", { desc = "NPM dev" })

-- Comandos de Python
vim.keymap.set("n", "<leader>py", ":!python3 %<CR>", { desc = "Run Python file" })
vim.keymap.set("n", "<leader>pt", ":!python3 -m pytest<CR>", { desc = "Run pytest" })
vim.keymap.set("n", "<leader>pi", ":!pip install -r requirements.txt<CR>", { desc = "Install Python deps" })

-- Configurações de tema
vim.cmd("colorscheme default")

-- Configurações de statusline
vim.opt.statusline = "%f %m %r %h %w [%Y] [%{&ff}] [%{&fenc}] [%l,%c] [%L] [%p%%]"

-- Configurações de tabline
vim.opt.tabline = "%!v:lua.require('tabline').build()"

-- Autocomandos
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "javascript", "typescript", "lua", "vim" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make", "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd("silent! %s/\\s\\+$//e")
  end,
})

-- Configurações específicas para arquivos de auditoria
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*/auditoria/*",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Mensagem de boas-vindas
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    print("Neovim configurado! Use <leader>aa para executar auditoria completa.")
  end,
})
